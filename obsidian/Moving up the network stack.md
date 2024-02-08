When the protocol layers indicate that it is time to flush the GRO'd flow, the stack calls `napi_gro_complete()` . 

The first thing `napi_gro_complete()` does is check the number of segments aggregated for the skb. If it is 1, i.e. there is just one segment, `napi_gro_complete()` simply passes it to `gro_normal_one()` as it is. Otherwise, it searches for the protocol callback function. The chain will go up to the transport layer, and each layer adds some flags, sets the gso type, and some other protocol specific operations. Lastly, it will call on `gro_normal_one()`.

`gro_normal_one()` will queue one GRO_NORMAL SKB up for list processing. If batch size exceeded, we pass the whole batch up to the stack. And that is done by calling `gro_normal_list()` where it passes the `napi->rx_list` to `netif_receive_skb_list_internal()`, which clears the list and add the skbs in a new list to then pass them to `__netif_receive_skb_list() -> __netif_receive_skb_list_core()`.

`__netif_receive_skb_list_core()` will find out the packet type of the skb, and then through another function call the matching packet type receiver callback function (IPv4 / IPv6). If we look at `ip_list_rcv()` which is the callback function for IPv4, we see that it will, for each skb, call `ip_rcv_core()`, which is the main IP receive routine. It will mostly check the package if it is acceptable, if it is not, it will drop it with `kfree_skb_reason(skb, drop_reason)`. 

After that call it will pass the skbs to `ip_sublist_rcv()`. This function will for each skb in the list call `ip_rcv_finish()`,   which will in turn call on `tcp_v4_early_demux(skb)` or `udp_v4_early_demux(skb)`, depending on the transport protocol, and in these functions the package is demultiplexed to a socket. `ip_list_rcv_core()` will also initialize the virtual path cache for the packet. It describes how the packet travels inside Linux networking. So mostly routing etc.

Once the skbs has gone through this process the skb list will be passed on from `ip_sublist_rcv()` to `ip_list_rcv_finish() -> ip_sublist_rcv_finish() -> dst_input() -> (IPv4) ip_local_deliver() / (IPv6) ip6_input()`. And from there and some more function calls, it will finally deliver the package to the transport layer.

We will look at `tcp_v4_rcv()`. `upd_rcv()` is used for UDP packages. 


