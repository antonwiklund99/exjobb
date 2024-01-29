#!/bin/python3

import tabulate

def index_cond(xs, cond):
    for i in range(len(xs)):
        if cond(xs[i]):
            return i
    return -1

# https://docs.kernel.org/trace/events-kmem.html
# https://www.kernel.org/doc/html/v4.19/trace/events-kmem.html

events = []
with open("logs/trace_ping_kmem_events_20230129", "r") as f:
    for line in f.readlines()[12:]:
        [meta,name,out] = [x.strip() for x in line.strip().split(":")]
        [task_pid,cpu,irq_context,timestamp] = [x.strip() for x in meta.split()]
        event = {"name": name, "timestamp": float(timestamp)}
        for kv in out.split():
            [k,v] = kv.strip().split("=")
            event[k] = v 
        events.append(event)
        #print(f"{name}@{timestamp}: {out}")

# Stats
lifetimes = []
free_times = []
page_free_times = []
use_times = []
ptrs = []
pages = []

# State
active_skb_ptrs = {}
active_pages = {}
freed_skb_ptrs = {}
freed_pages = {}

for event in events:
    # Page allocation
    if event["name"] == "mm_page_alloc":
        page = event["page"]
        assert(not page in active_pages)
        # Check if page is in freed pages, if so we assume the freed fragments are in use now
        # This might not really be true, since the whole page might not be used...
        if page in freed_pages:
            page_entry = freed_pages.pop(page)
            for frag in page_entry["frags"]:
                lifetimes.append(event["timestamp"] - frag["alloc_time"])
                free_times.append(event["timestamp"] - frag["free_time"])
                page_free_times.append(event["timestamp"] - page_entry["free_time"])
                pages.append(event["page"])
                ptrs.append(frag["ptr"])
                use_times.append(frag["free_time"] - frag["alloc_time"])
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
            "alloc_time": event["timestamp"]
        })
    # Page fragment freeing
    elif event["name"] == "skb_head_frag_free":
        page = event["page"]
        # Ignore pages that were allocated before start of trace
        assert(not page in freed_pages)
        if not page in active_pages:
            continue
        # Add free timestamp
        frag_index = index_cond(active_pages[page]["frags"], lambda x:x["ptr"] == event["ptr"])
        assert(frag_index != -1)
        active_pages[page]["frags"][frag_index]["free_time"] = event["timestamp"]
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

none_page_free_times = [free_times[i] - page_free_times[i] for i in range(len(free_times))]
print(tabulate.tabulate(
    zip(ptrs, pages, lifetimes, use_times, free_times, none_page_free_times, page_free_times),
    headers=["Addr", "Page", "Lifetime", "Use time", "Free time", "None-page free time", "Page free time"],
    tablefmt="github"
))