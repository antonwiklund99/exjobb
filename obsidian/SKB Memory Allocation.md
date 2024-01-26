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
kmem_cache for struct sk_buf, **ONE FOR ALL CPUs** . ([[Slab allocator]])
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
3) Set skb->frag_head = 1 because this is the first allocation subsequent packets fragments will use ??? instead (TODO)
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
2) Set skb->frag_head = 1 because this is the first allocation subsequent packets fragments will use ??? instead (TODO)
### alloc_skb
Must be called from interrupt (I guess softirq counts). Allocates an sk_buff and data using **kmalloc** instead of allocating from the page fragment caches as **netdev/nap_alloc_skb** does.
##### Function flow
1) If SKB_ALLOC_NAPI flag is set in flags, call **napi_skb_cache_get** that gets a **sk_buff** struct from **napi_alloc_cache.skb_cache** in the same way as in **napi_alloc_skb**.         Else call allocate a **sk_buff** struct from the **skb_buff_cache** (_kmem_cache_ for sk_buff).
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
Allocates an **sk_buff** with page frags. The argument **order** determines the maximal order for frags (max order of allocated pages), so it can be used to allocate a paged **skb**, given a maximal order for frags. (**napi/netdev_alloc_skb** allocates page fragments instead of full pages).
##### Function flow
1) Call **alloc_skb** to allocate a **sk_buff** with header_len skb->head.
2) Allocate pages (up to order amount per iteration) to get data_len bytes. Add pages to **sk_buff->head** by calling **skb_fill_page_desc**.