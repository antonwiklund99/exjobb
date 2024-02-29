#!/bin/env python3

import sys

events = []
with open(sys.argv[1], "r") as f:
    for (i, line) in enumerate(f.readlines()[12:]):
        splitted = line.strip().split()
        [task_pid, cpu, irq_context] = splitted[:3]
        timestamp = float(splitted[3].replace(":", ""))
        if ":" not in splitted[4]:
            continue
        name = splitted[4].replace(":", "")
        event = {"name": name, "timestamp": timestamp}
        for kv in splitted[5:]:
            if "=" in kv:
                [k, v] = kv.strip().split("=")
            else:
                print(f"bug: no seperator in kv '{kv}'")
            event[k.strip()] = v.strip()
        events.append(event)
        # print(f"{name}@{timestamp}: {out}")

active_pages = {}
frag_ref_count = {}
for (line_num, event) in enumerate(events):
    if event["name"] == "mm_page_alloc":
        page = event["page"]
        assert (page not in active_pages)
        active_pages[page] = {"alloc_time": event["timestamp"], "frags_zeroed": {}}
    elif event["name"] == "mm_page_free":
        page = event["page"]
        # Ignore pages allocated before start of trace
        if page not in active_pages:
            continue
        page_entry = active_pages.pop(page)
        for frag_addr, zeros in page_entry["frags_zeroed"].items():
            if len(zeros) > 1:
                print(f"frag {frag_addr} in page {page} zeroed {len(zeros)} times ({zeros})")
    elif event["name"] == "skb_frag_zeroing":
        page = event["page"]
        frag = event["frag"]
        if page not in active_pages:
            print(f"WARNING: page {page} for frag {frag} not in active_pages")
            continue
        fz = active_pages[page]["frags_zeroed"]
        if frag not in fz:
            fz[frag] = []
        fz[frag].append((event["timestamp"], -1 if frag not in frag_ref_count else frag_ref_count[frag]))
    elif event["name"] == "skb_frag_ref":
        frag = event["frag"]
        if frag not in frag_ref_count:
            frag_ref_count[frag] = 0
        frag_ref_count[frag] += 1
    elif event["name"] == "skb_frag_unref":
        frag = event["frag"]
        if frag not in frag_ref_count:
            continue
        frag_ref_count[frag] -= 1
