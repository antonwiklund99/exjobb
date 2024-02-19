#!/bin/python3

import tabulate
import sys

def index_cond(xs, cond):
    for i in range(len(xs)):
        if cond(xs[i]):
            return i
    return -1

# https://docs.kernel.org/trace/events-kmem.html
# https://www.kernel.org/doc/html/v4.19/trace/events-kmem.html

events = []
with open(sys.argv[1], "r") as f:
    for (i,line) in enumerate(f.readlines()[12:]):
        splitted = line.strip().split()
        [task_pid,cpu,irq_context] = splitted[:3]
        timestamp = float(splitted[3].replace(":",""))
        name = splitted[4].replace(":","")
        event = {"name": name, "timestamp": timestamp}
        for kv in splitted[5:]:
            if "=" in kv:
                [k,v] = kv.strip().split("=")
            else:
                print(f"bug: no seperator in kv '{kv}'")
            event[k.strip()] = v.strip() 
        events.append(event)
        #print(f"{name}@{timestamp}: {out}")

# Stats
types = []
lifetimes = []
free_times = []
page_free_times = []
use_times = []
ptrs = []
pages = []
real_use_times = []
alloc_funcs = []
free_funcs = []

# State
active_skb_ptrs = {}
active_pages = {}
active_pages_with_data = {}
freed_skb_ptrs = {}
freed_pages = {}
consume_skb_locations = {}

for (line_num,event) in enumerate(events):
    #print(f"{event['name']}: {line_num}")
    # Page allocation
    if event["name"] == "mm_page_alloc":
        page = event["page"]
        assert(not page in active_pages)
        # Check if page is in freed pages, if so we assume the freed fragments are in use now
        # This might not really be true, since the whole page might not be used...
        if page in freed_pages:
            page_entry = freed_pages.pop(page)
            for frag in page_entry["frags"]:
                types.append("frag")
                lifetimes.append(event["timestamp"] - frag["alloc_time"])
                free_times.append(event["timestamp"] - frag["free_time"])
                page_free_times.append(event["timestamp"] - page_entry["free_time"])
                pages.append(event["page"])
                ptrs.append(frag["ptr"])
                use_times.append(frag["free_time"] - frag["alloc_time"])
                real_use_times.append(frag["free_time"] - frag["data_write_time"])
                alloc_funcs.append(frag["alloc_func"])
                free_funcs.append(frag["free_func"])
        active_pages[page] = {
            "alloc_time": event["timestamp"],
            "frags": []
        }
    # Page fragment alloc
    elif event["name"] == "napi_alloc_frag" or event["name"] == "netdev_alloc_frag":
        page = event["page"]
        # Ignore pages that were allocated before start of trace
        assert(not page in freed_pages)
        if not page in active_pages:
            continue
        active_pages[page]["frags"].append({
            "ptr": event["ptr"],
            "alloc_time": event["timestamp"],
            "alloc_func": event["location"]
        })
    # Finalize skb, this function creates the actual skb struct. We assume that after
    # this function is called that the skb->head is starting to be used and the
    # old data is overwritten (current data is in memory).
    elif event["name"] == "finalize_skb_around":
        # Search for page
        page = -1
        for p,f in active_pages.items():
            frag_index = index_cond(f["frags"], lambda x:x["ptr"] == event["ptr"])
            if frag_index != -1:
                page = p
                break
        # skb->head was allocated with page fragments
        if page != -1:
            # Ignore pages that were allocated before start of trace
            assert(not page in freed_pages)
            if not page in active_pages:
                continue
            # Add data write timestamp
            assert(frag_index != -1)
            active_pages[page]["frags"][frag_index]["data_write_time"] = event["timestamp"]
            active_pages[page]["frags"][frag_index]["skb_ptr"] = event["skb"]
        # skb->head was allocated with kmalloc
        else:
            ptr = event["ptr"]
            if not ptr in active_skb_ptrs:
                continue
            active_skb_ptrs[ptr]["data_write_time"] = event["timestamp"]
            active_skb_ptrs[ptr]["skb_ptr"] = event["skb"]
    # Page fragment freeing
    elif event["name"] == "skb_head_frag_free":
        page = event["page"]
        skb_ptr = event["skb"]
        # Ignore pages that were allocated before start of trace
        assert(not page in freed_pages)
        if not page in active_pages:
            # Remove free location if one exists for this
            if skb_ptr in consume_skb_locations:
                consume_skb_locations.pop(skb_ptr)
            continue
        # Save function that called skb_consume
        if skb_ptr in consume_skb_locations:
            free_func = consume_skb_locations.pop(skb_ptr)
        else:
            print("BUG: no consume location for skb_head_frag_free")
            free_func = "NOT FOUND"
        # Add free timestamp
        frag_index = index_cond(active_pages[page]["frags"], lambda x:x["ptr"] == event["ptr"])
        if (frag_index == -1):
            print("BUG: no frag in page['frags'] for skb_head_frag_free")
            continue
        active_pages[page]["frags"][frag_index]["free_time"] = event["timestamp"]
        active_pages[page]["frags"][frag_index]["free_func"] = free_func
    # Page freeing
    elif event["name"] == "mm_page_free":
        page = event["page"]
        # Ignore pages allocated before start of trace
        if not page in active_pages:
            continue
        page_entry = active_pages.pop(page)
        # Ignore pages that are not used for network page fragments
        if len(page_entry["frags"]) == 0:
            continue
        page_entry["free_time"] = event["timestamp"]
        assert(not page in freed_pages)
        freed_pages[page] = page_entry
    # SKB kmalloc
    elif event["name"] == "skb_head_kmalloc":
        ptr = event["ptr"]
        assert(not (ptr in active_skb_ptrs and ptr in freed_skb_ptrs))
        active_skb_ptrs[ptr] = {
            "len": int(event["len"]),
            "alloc_time": event["timestamp"],
            "alloc_func": event["location"]
        }
    # SKB alloc_with_frags (just set alloc func from here instead of alloc_skb)
    elif event["name"] == "alloc_skb_with_frags":
        skb_ptr = event["skb"]
        for entry in active_skb_ptrs.values():
            if entry["skb_ptr"] == skb_ptr:
                entry["alloc_func"] = event["location"]
                break
    # SKB kfree
    elif event["name"] == "skb_head_kfree":
        ptr = event["ptr"]
        assert(not ptr in freed_skb_ptrs)
        # Ignore skb's allocated before start of trace
        if not ptr in active_skb_ptrs:
            continue
        skb_ptr = event["skb"]
        if skb_ptr in consume_skb_locations:
            free_func = consume_skb_locations.pop(skb_ptr)
        else:
            print("BUG: skb ptr not in consume locations in skb_head_kfree")
            free_func = "NOT FOUND"
        ptr_entry = active_skb_ptrs.pop(ptr)
        ptr_entry["free_time"] = event["timestamp"]
        ptr_entry["free_func"] = free_func
        freed_skb_ptrs[ptr] = ptr_entry
    # kmalloc or small head alloc (small heads are allocated from a kmem_cache rather than with kmalloc)
    elif event["name"] == "kmalloc" or event["name"] == "skb_small_head_alloc":
        ptr = event["ptr"]
        if ptr in freed_skb_ptrs:
            entry = freed_skb_ptrs.pop(ptr)
            types.append("kmalloc")
            lifetimes.append(event["timestamp"] - entry["alloc_time"])
            free_times.append(event["timestamp"] - entry["free_time"])
            page_free_times.append("-")
            pages.append("-")
            ptrs.append(ptr)
            use_times.append(entry["free_time"] - entry["alloc_time"])
            real_use_times.append(entry["free_time"] - entry["data_write_time"])
            alloc_funcs.append(entry["alloc_func"])
            free_funcs.append(entry["free_func"])
    # SKB consume, save location from where this was called
    elif event["name"] == "consume_skb" or event["name"] == "kfree_skb":
        skb_ptr = event["skbaddr"]
        if skb_ptr in consume_skb_locations:
            print(f"BUG: consume_skb {skb_ptr} location already in consume_skb_locations")
        consume_skb_locations[skb_ptr] = event["location"]

none_page_free_times = [free_times[i] - page_free_times[i] if types[i] == "frag" else "-" for i in range(len(free_times))]
print(tabulate.tabulate(
    zip(types, ptrs, pages, lifetimes, use_times, free_times, none_page_free_times, page_free_times, real_use_times, alloc_funcs, free_funcs),
    headers=["Type", "Addr", "Page", "Lifetime", "Use time", "Free time", "None-page free time", "Page free time", "Real use time", "Alloc func", "Free func"],
    tablefmt="github"
))