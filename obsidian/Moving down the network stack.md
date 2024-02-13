This section will describe how data travel from user application down to the NIC driver. 

## Writing data to socket
It all starts with the user application calling sys_write system call in order to pass some data to the socket. Then the protocol specific functions will be called. So for a IPv4/TCP stream the call chain would look like this:
`ksys_write() -> ... -> __sock_sendmsg() -> inet_sendmsg() and tcp_sendmsg()`

After checking permissions,  `__sock_sendmsg()` will pass the message down to `inet_sendmsg()`. This function will bind the socket, if not binded already, and then pass the msg onto `tcp_sendmsg()`. `tcp_sendmsg()` will lock the socket, call `tcp_sendmsg_locked()` and then release the socket. When releasing the socket it will do some checks and processing of the backlog, you can read more about it in [[Moving up the network stack]].

`tcp_sendmsg_locked()` appends the message to socket's `sk_write_queue` with `tcp_skb_entail()`, allocating a new SKB if needed with `tcp_stream_alloc_skb()` which allocates with `alloc_skb_fclone()`. For the data, it will allocate page frags and copy the data from the message to them.
```
struct page_frag *pfrag = sk_page_frag(sk);
...
err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
						       pfrag->page,
						       pfrag->offset,
						       copy);
if (err)
	goto do_error;

/* Update the skb. */
if (merge) {
	skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
} else {
	skb_fill_page_desc(skb, i, pfrag->page,
					   pfrag->offset, copy);
	page_ref_inc(pfrag->page);
}
pfrag->offset += copy;
```

The `tcp_sendmsg_locked()` then calls `tcp_push()` to flush out full TCP segments with `__tcp_push_pending_frames()` that calls `tcp_write_xmit()`.

### Sending the packet down the stack
`tcp_write_xmit()` writes packets to the network. It goes through the `sk_write_queue` and for each packet, do some tests. If the skb is larger than the maximum segment size (MSS), it will trim the packet, and put the rest in next of the skbs list. This is done in `tso_fragment()`. After doing these checks, it will pass the skb to `tcp_transmit_skb() -> -__tcp_transmit_skb()`.

From `__tcp_transmit_skb()`
```
/* This routine actually transmits TCP packets queued in by
 * tcp_do_sendmsg().  This is used by both the initial
 * transmission and possible later retransmissions.
 * All SKB's seen here are completely headerless.  It is our
 * job to build the TCP header, and pass the packet down to
 * IP so it can do the same plus pass the packet off to the
 * device.
 *
 * We are working here with either a clone of the original
 * SKB, or a fresh unique copy made by the retransmit engine.
 */
```

We are calling this with intentions of cloning the skb, i.e. `clone_it` being true. So first off we clone the skb. We do this if we need to retransmit the skb. Then we initialize and build a TCP header for the packet. Then compute a checksum for the packet with `tcp_v4_send_check()`. We set some more fields and do some more operations you can read about it the code. But lastly, we send the package to `ip_queue_xmit() -> __ip_queue_xmit()`. 

`__ip_queue_xmit()` routes the packet. Then, if we know where to send it, we allocate and build IP header.  When the package is routed and header is built, we pass it along to `ip_local_out() -> __ip_local_out()`. This lets the packet traverse the Netfilter Output hook. If the packet is not dropped here, then function `dst_output()` is being called, which calls `ip_output()`. `ip_output()` sets the network protocol `skb->protocol = htons(ETH_P_IP)` and passes it to `ip_finish_output() -> __ip_finish_output()`.

If skb is a gso packet, then the packet is passed to `ip_finish_output_gso()` which I will get back to what it does, otherwise it passes it to `ip_fragment()` to be fragmented into  smaller pieces (each of size equal to IP header plus a block of the data of the original IP data part).

`ip_finish_output_gso()` will first validates if a given skb will fit a wanted MTU once split. It considers L3 headers, L4 headers, and the payload. If so, then just pass it along (common case). If not, it does an IP fragmentation. 

After possible fragmentation, the skb will be passed to `ip_finish_output2()`, which hands the packet over to the _neighbouring subsystem_ and thereby finally to link layer, so that it can be sent out on the network. Which would be a call to `dev_queue_xmit() -> __dev_queue_xmit()`.

`__dev_queue_xmit()` queues a buffer for transmission to a network device. You can read a detailed explanation of what it does here: [Monitoring and Tuning the Linux Networking Stack: Sending Data](https://blog.packagecloud.io/monitoring-tuning-linux-networking-stack-sending-data/). In fact, you can read about the rest of the calls down to the NIC there (until `dev_hard_start_xmit`). And for GSO you can read [[NIC Offloads]].







