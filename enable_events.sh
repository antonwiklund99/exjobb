#!/bin/sh

# SKB events
echo "1" > /sys/kernel/tracing/events/skb/enable
# Page events (for page fragments)
echo "1" > /sys/kernel/tracing/events/kmem/mm_page_alloc/enable
echo "1" > /sys/kernel/tracing/events/kmem/mm_page_free/enable
# kmalloc and kfree events (for skb heads allocated with kmalloc)
echo "1" > /sys/kernel/tracing/events/kmem/kmalloc/enable
echo "1" > /sys/kernel/tracing/events/kmem/kfree/enable 
# Net events
echo "1" > /sys/kernel/tracing/events/net/enable
# Napi poll
echo "1" > /sys/kernel/tracing/events/napi/enable
# Sock events
echo "1" > /sys/kernel/tracing/events/sock/enable
# TCP events
echo "1" > /sys/kernel/tracing/events/tcp/enable
# UDP events
echo "1" > /sys/kernel/tracing/events/udp/enable 
# Set tracer (nop/function/function_graph)
echo nop > /sys/kernel/tracing/current_tracer

# Turn tracing off, clear trace and then turn it on again
echo "0" > /sys/kernel/tracing/tracing_on
echo "" > /sys/kernel/tracing/trace
echo "1" > /sys/kernel/tracing/tracing_on
