## SKB caches
### napi_alloc_cache
Struct for caching page frags and sk_bufs when allocating napi skb. **ONE PER CPU**.
This struct contains:
- _page_ (**struct page_frag_cache**) used allocating the skb->head (data). The cache allocates pages in bulk, i.e. if there are no pages in the cache it allocates multiple page fragments in **page_frag_alloc_align** and hands them out in the subsequent calls.
- _page_small_ (**struct page_frag_1k**) cache used in a similar way but with smaller page fragments. Mostly used for systems that are memory constrained so most likely not enabled.
- _skb_cache_ used for caching SKB structs. It is basically a (per-cpu) cache for the **skbuff_cache** (kmem_cache for sk_buff structs). It stores NAPI_SKB_CACHE_SIZE (64) **sk_bufs**.
### netdev_alloc_cache
A **page_frag_cache** struct for allocating skb->head (data). The cache allocates pages in bulk, i.e. if there are no pages in the cache it allocates multiple page fragments in **page_frag_alloc_align** and hands them out in the subsequent calls. **ONE PER CPU**.
### skb_small_head_cache
kmem_cache for smaller skb->head (data), **ONE FOR ALL CPUs**. Used for skb->heads smaller than SKB_SMALL_HEAD_CACHE_SIZE, in **kmalloc_reserve** that allocates skb->head.
### skbuff_cache
kmem_cache for struct **sk_buff*, **ONE FOR ALL CPUs** . ([[Slab allocator]])
### skbuff_fclone_cache
kmem_cache for **sk_buff** fclones (what is fclone?????? TODO). **ONE FOR ALL CPUs**
### skbuff_ext_cache (if CONFIG_SKB_EXTENSION enabled)
kmem_cache for struct **skb_ext**, **ONE FOR ALL CPUs**. 
## SKB allocation functions
### napi_alloc_skb
Called from softirq ([[netdev vs napi]]).
Allocates a RX SKB for a specific **napi instance** (scheduling struct for a device queue).
##### Function flow
If requested length is too small or too big, it will use kmalloc for skb->head allocation instead and just calls **__alloc_skb** with the SKB_ALLOC_NAPI flag and then returns.
Otherwise:
1) Allocate page fragments for skb->head from page_frag_cache (**napi_alloc_cache.page**) by calling **page_frag_alloc**.
2) Call **__napi_build_skb** with the allocated data pointer as argument.
	1) Calls **napi_skb_cache_get** to retrieve a **sk_buff** struct. This function checks the **skb_cache** in the **napi_alloc_cache** if there are no SKBs in it, calls **kmem_cache_alloc_bulk** that will allocate NAPI_SKB_CACHE_BULK (16) SKBs to **napi_alloc_cache.skb_cache**. Then it takes and returns the top SKB.
	2) **memset**s the sk_buff to 0 (to **skb.tail**).
	3) Calls **__build_skb_around** with the newly allocated SKB and data pointer. There is a if in this function that will allocate the data pointer if len is 0 however it is deprecated, so most likely it will just skip this and simply call **\_\_finalize_skb_around** with the same arguments. This function sets all fields in the SKB correctly and resets the shared info part and sets refcount to 1.
3) Set skb->head_frag = 1 because we allocated skb->head from page fragments (not kmalloc).
### netdev_alloc_skb (+\_ip_aligned)
Called from a network device's interrupt ([[netdev vs napi]]).
Allocates and RX SKB for a specific **device**. This functions is very similiar to **napi_alloc_skb** with major difference being the page fragment allocation, if we are in an interrupt this function will use the **netdev_alloc_cache** instead of **napi_alloc_cache.page**. And that it uses **\_\_build_skb**  rather than **\_\_napi_build_skb** that uses the *kmem_cache* **skbuff_cache** to allocate the sk_buff struct rather than the napi per-cpu cache (**napi_alloc_cache**).
##### Function flow
If requested length is too small or too big, it will use kmalloc for skb->head allocation instead and just calls **alloc_skb** and then returns.
Otherwise:
1) If we are in an interrupt or interrupts are disabled, allocate page fragments for the skb->head (data pointer) from the **netdev_alloc_cache** (**page_frag_alloc**).
	Else disable bottom halves (**local_bh_disable**) so we don't get data races with napi running in an softirq. And then allocate page fragments from **napi_alloc_cache.page**. Then enable bottom halves again (**local_bh_enable**).
1) Call **__build_skb** with the allocated data pointer as argument.
	1) Calls **kmem_cache_alloc** on **skbuff_cache** to allocate a **sk_buff** struct.
	2) **memset**s the sk_buff to 0 (to **skb.tail**).
	3) Calls **__build_skb_around** with the newly allocated SKB and data pointer. There is a if in this function that will allocate the data pointer if len is 0 however it is deprecated, so most likely it will just skip this and simply call **\_\_finalize_skb_around** with the same arguments. This function sets all fields in the SKB correctly and resets the shared info part and sets refcount to 1.
2) Set skb->head_frag = 1 since we allocated the skb->head with page fragments (not kmalloc).
### alloc_skb
Allocates an sk_buff and data using **kmalloc** instead of allocating from the page fragment caches as **netdev/napi_alloc_skb** does.
##### Function flow
1) If SKB_ALLOC_NAPI flag is set in flags, call **napi_skb_cache_get** that gets a **sk_buff** struct from **napi_alloc_cache.skb_cache** in the same way as in **napi_alloc_skb**.  Else call allocate a **sk_buff** struct from the **skb_buff_cache** (_kmem_cache_ for sk_buff) or **skbuff_fclone_cache** if the SKB_ALLOC_FCLONE flag is set.
2) Call **kmalloc_reserve** to allocate skb->head (data).
	1) If the size of the object is smaller than SKB_SMALL_HEAD_CACHE_SIZE allocate it from **skb_small_head_cache** (_kmem_cache_ for small skb->heads) using **kmem_cache_alloc_node**.
	2) Else allocate the memory using **kmalloc_node_track_caller**. There is a lot of checking here for if we failed to allocate memory and trying again with reserves, pfmemalloc ([[GFP_MEMALLOC]]).
3) **memset**s the sk_buff to 0 (to **skb.tail**).
4) Calls **__build_skb_around** with the newly allocated SKB and data pointer. There is a if in this function that will allocate the data pointer if len is 0 however it is deprecated, so most likely it will just skip this and simply call **\_\_finalize_skb_around** with the same arguments. This function sets all fields in the SKB correctly and resets the shared info part and sets refcount to 1.
### alloc_skb_for_msg
Allocates an **sk_buff** for wrapping a frag list forming a message ([IP Fragmentation](https://en.wikipedia.org/wiki/IP_fragmentation)). The argument **first** is a pointer to the **sk_buff** of the first fragment.
Rarely used only called from here in **\_\_strp__recv** (net/strparser/strparser.c):
![[Pasted image 20240126094821.png]]
##### Function flow
1) Call **alloc_skb** to allocate a **sk_buff** struct of **size 0** (first argument).
2) Copy all the length fields from **first** to the new **sk_buff**.
3) Set the fraglist pointer of the **skb_shinfo** (shared info/header) to first.
4) Call **\_\_copy_skb_header** to copy all the header fields from **first** to the new **sk_buff**.
### alloc_skb_with_frags
Allocates an **sk_buff** (possibly) using **skb_frag**'s in shinfo(skb)->frags (non-linear part of **sk_buff**. It will allocate **header_len** in skb->head and **data_len** bytes in **skb_frag**'s.
##### Function flow
1) Call **alloc_skb** to allocate a **sk_buff**, this will allocate a **sk_buff** with a **skb->head** of **header_len** bytes.
2) Allocate pages of max order _order_. Allocate pages until we have allocated more or exactly **data_len** bytes. Each iteration allocate one order below the order that would fit the rest of the data bytes. For example, if we wanted to allocate 7\*PAGE_SIZE. The pages allocated in frags would be:
	1) 4 pages (order 2), remaining bytes = 3\*PAGE_SIZE
	2) 2 pages (order 1), remainng bytes = PAGE_SIZE
	3) 1 page (order 0), remaining bytes = 0
	For each allocation add the pages to the **skb_frag** in shinfo(skb)->frags with **skb_fill_page_desc**. This function will fill in the fields in the skb_frag i.e. bv_page (pointer to the page), bv_offset (offset where the fragment starts, this will always be 0 in this case since we allocate new pages) and bv_size (number of bytes in the fragment, this will be min(PAGE_SIZE << order, data_len)).
	When the allocation order is > 0, we allocate the pages with **alloc_pages** with the \_\_GFP_COMP flag meaning that the pages are allocated as [compound pages](https://lwn.net/Articles/619514/).
### alloc_skb_fclone
Call **alloc_skb** with SKB_ALLOC_FCLONE flag thus enabling use of the fclone cache if that is enabled.

## SKB de-allocation functions
[[SKB kfree vs consume]]
These functions should **NOT** be called from hardware interrupt context or with hardware interrupts disabled. Then the functions in the next section (**dev_kfree_skb...**) should be used instead.
### \_\_kfree_skb
This function assumes that refcount is 0, so functions need to check this before calling
1) Call skb_release_all on skb
	1) Call **skb_release_head_state** on skb. This drops reference to the SKBs [[DST]] and calls **skb_ext_put**, that frees the **skb_ext** struct (if it has one) to the **skb_ext_cache** _kmem_cache_.
	2) If skb->head not NULL (skb has data) calls **skb_release_data**. 
	3) This function decrements the data ref and checks if it is not zero (some one else has a ref) exit. Else it goes through the **skb_shared_info.frags** (skb->data page fragments/buffers [[skb_shared_info struct]]) and calls **napi_frag_unref**. If CONFIG_PAGE_POOL is activated the fragment is added to the page pool otherwise it just calls **put_page** on it to free the page associated with the fragment.
	4) If there is a **frag_list** in the _skb_shared_info_ (**shinfo)** call **kfree_skb_list_reason** on it (this SKB is part of a fragmented message so we want to free all of them).
	5) Call **skb_free_head**, that checks if **skb.head_frag** is true meaning that **skb.head** (data) is allocated with page fragments. If it is we either recycle into a page pool (if we use one) or call **skb_free_frag** that calls **page_frag_free** that frees the page associated with the skb->head if the number of references to the page is zero (no other page fragments point to it). Else calls **skb_kfree_head** that either puts the head into **skb_small_head_cache** if it is a small head or calls **kfree** on it to free the head.
2) Call **kfree_skbmem**, that checks if there are fclones of this SKB (SKB_FCLONE_UNAVAILABLE), simply put the **sk_buff** into **skbuff_cache**. Otherwise decrement the refcount and if it is zero put the fclones into **skbuff_fclone_cache** (_kmem_cache_ for struct **sk_buff_fclones**).
### kfree_skb_reason
Calls **\_\_kfree_skb_reason** that drops ref to SKB and checks if it has hit zero.
If it has add a trace point for _reason_ and call **\_\_kfree_skb** on the SKB.
### kfree_skb
Calls **kfree_skb_reason** with reason NOT_SPECIFIED
### kfree_skb_list_reason
Go though each **sk_buff** in the linked list (skb->next)
1) Call **\_\_kfree_skb_reason** on the skb, drops the ref to skb and if refcount has hit 0 adds a tracepoint for _reason_ and then calls **kfree_skb_add_bulk**.
2) **kfree_skb_add_bulk** calls **release_all** on the SKB. This function will:
	1) Call **skb_release_head_state** on skb. This drops reference to the SKBs [[DST]] and calls **skb_ext_put**, that frees the **skb_ext** struct (if it has one) to the **skb_ext_cache** _kmem_cache_.
	2) If skb->head not NULL (skb has data) calls **skb_release_data**. 
		1) This function decrements the data ref and checks if it is not zero (some one else has a ref) exit. Else it goes through the **skb_shared_info.frags** (unmapped page fragments/buffers [[skb_shared_info struct]]) and calls **napi_frag_unref**. If CONFIG_PAGE_POOL is activated the fragment is added to the page pool otherwise it just calls **put_page** on it to free the page associated with the fragment.
		2) If there is a **frag_list** in the _skb_shared_info_ (**shinfo)** call **kfree_skb_list_reason** on it (this SKB is part of a fragmented message so we want to free all of them).
		3) Call **skb_free_head**, that checks if **skb.head_frag** is true meaning that **skb.head** (data) is allocated with page fragments.                                              If it is we either recycle into a page pool (if we use one) or call **skb_free_frag** that calls **page_frag_free** that frees the page associated with the skb->head. Else calls **skb_kfree_head** that either puts the head into **skb_small_head_cache** if it is a small head or calls **kfree** on it to free the head.
3) **kfree_skb_add_bulk** then adds the freed **sk_buff** to the **skb_free_array** if the number of SKBs in the free array is equal to KFREE_SKB_BULK_SIZE (16) then it calls **kmem_cache_free_bulk** that puts all the **sk_buff** structs in the free array into the **skbuff_cache**. 
4) If the **skb_free_array** is not empty after iterating through each SKB, call **kmem_cache_free_bulk** on it to put the rest into the **skbuff_cache**.
### kfree_skb_list
Calls **kfree_skb_list_reason** with reason NOT_SPECIFIED
### consume_skb
Drop ref to skb and check if it has hit zero by calling **skb_unref**.
If it has add a trace with **trace_consume_skb** and call **__kfree_skb** on the SKB.
### napi_consume_skb
1) Check if we are in non-NAPI context if so call **dev_consume_skb_any** and return
2) Drop the skb reference if it is not zero return
3) Add a tracepoint with **trace_consume_skb**
4) Check if skb is a clone, if so call **\_\_kfree** on it and return
5) Call **skb_release_all** on the skb which frees the headers and data (see above for more details).
6) Call **napi_skb_cache_put** which puts the **sk_buff** into **napi_alloc_cache.skb_cache** (see above for more details).
### \_\_consume_stateless_skb
Same as **consume_skb** but it assumes that this is the last skb reference and all the head state have already been dropped.
### kfree_skb_partial
Frees an **sk_buff** but not the data if the argument **head_stolen** is true. It does this by calling **skb_release_head_state** and puts the **sk_buff** back into **sk_buff_cache**.
If head_stolen is false then it simply calls **__kfree_skb** on the **sk_buff** that free the head (data) as well.
### napi_free_stole_head
Same as **kfree_skb_partial** but stole head is not an argument. If **skb->slow_gro** is true free headers states (meaning????). Then call **napi_skb_cache_put** which puts the **sk_buff** into **napi_alloc_cache.skb_cache** (see above for more details).
### \_\_napi_kfree_skb
Same as **\_\_kfree** but puts **sk_buff** into **napi_alloc_cache.skb_cache** instead of **sk_buff_cache**. Called from **net_tx_action** on completion queue
1) Call **skb_release_all** on skb
2) Put the **sk_buff** into **napi_alloc_cache_skb_cache** by calling **napi_skb_cache_put** (see above for more details). 
### skb_free_datagram
Calls **consume_skb** on **sk_buff**
## SKB de-allocation queueing
Calling the normal de-allocation functions above from interrupt context or with interrupts disabled is not allowed so then the **dev_kfree_...** functions below should be used instead. The **dev_kfree_skb_irq** if you know that you are in interrupt context and **dev_kfree_skb_any** if you don't know.
### dev_kfree_skb_irq_reason
Drop reference to **sk_buff** if there is no other references. Add the skb to the front of **softnet_data.completion_qeueue** and raise a softirq for NET_TX_SOFTIRQ. Inside **net_tx_action** it will then call **__napi_kfree_skb** on the **sk_buff**. 
### dev_kfree_skb_any_reason
Check if we are in irq context if so call **dev_kfree_skb_irq_reason** otherwise call **kfree_skb_reason** on the skb that will free it directly and not schedule it for NAPI.

![[Pasted image 20240126144600.png]]
### skb_attempt_defer_free
Queue **sk_buff** for remote freeing. Adds the skb to **softnet_data.defer_list**, these are later freed in **net_rx_action** (the RX NAPI **softirq**) that calls **skb_defer_free_flush**. If the defer list is half full raise a **softirq** to avoid overflow or if the defer list is full call **__kfree_skb** directly from this function instead of adding to defer list.
**RARELY USED**, only found in one place in net/ipv4/tcp.c
![[Pasted image 20240126143821.png]]