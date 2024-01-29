#!/bin/sh

# SKB events
echo "1" > /sys/kernel/tracing/events/skb/skb_head_kmalloc/enable
echo "1" > /sys/kernel/tracing/events/skb/netdev_alloc_frag/enable
echo "1" > /sys/kernel/tracing/events/skb/napi_alloc_frag/enable
echo "1" > /sys/kernel/tracing/events/skb/consume_skb/enable
echo "1" > /sys/kernel/tracing/events/skb/kfree_skb/enable
echo "1" > /sys/kernel/tracing/events/skb/skb_head_frag_free/enable
echo "1" > /sys/kernel/tracing/events/skb/skb_head_kfree/enable
# Page events (for page fragments)
echo "1" > /sys/kernel/tracing/events/kmem/mm_page_alloc/enable
echo "1" > /sys/kernel/tracing/events/kmem/mm_page_free/enable
# kmalloc and kfree events (for skb heads allocated with kmalloc)
echo "1" > /sys/kernel/tracing/events/kmem/kmalloc/enable
echo "1" > /sys/kernel/tracing/events/kmem/kfree/enable 