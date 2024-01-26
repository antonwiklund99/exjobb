i __\_\_alloc_skb__
![[Pasted image 20240124171951.png]]
__\_\_build_skb__ called by __napi_alloc_skb__
![[Pasted image 20240124173339.png]]
maybe we can avoid these if we zero them on free?