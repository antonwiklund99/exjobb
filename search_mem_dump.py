#!/bin/env python3

import sys
import mmap
import os

page_size_shift = 12
page_offset_mask = (1 << page_size_shift) - 1
page_number_mask = ~page_offset_mask

fd = os.open(sys.argv[1], os.O_RDONLY)
mm = mmap.mmap(fd, 0, prot=mmap.PROT_READ)
i = mm.find(b"LEAK", 0)
while i != -1:
    page_offset = i & page_offset_mask
    page_number = (i & page_number_mask) >> page_size_shift
    print(f"full addr = {hex(i)}, page_number = {hex(page_number)}, page_offset = {hex(page_offset)}")
    i = mm.find(b"LEAK", i + 1)
