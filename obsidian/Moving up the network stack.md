When the protocol layers indicate that it is time to flush the GRO'd flow, the stack calls `napi_gro_complete()` . 

The first thing `napi_gro_complete()` does is check the number of segments aggregated for the skb. If it is 1, i.e. there is just one segment, `napi_gro_complete()` simply passes it to `gro_normal_one()` as it is. Otherwise, it searches for the protocol callback function. The chain will go up to the transport layer, and each layer adds some flags, sets the gso type, and some other protocol specific operations. Lastly, it will call on `gro_normal_one()`.

`gro_normal_one()` will queue one GRO_NORMAL SKB up for list processing. If batch size exceeded, we pass the whole batch up to the stack. And that is done by calling `gro_normal_list()` where it passes the `napi->rx_list` to `netif_receive_skb_list_internal()`, which clears the list and add the skbs in a new list to then pass them to `__netif_receive_skb_list() -> __netif_receive_skb_list_core()`.

### IP layer
`__netif_receive_skb_list_core()` will find out the packet type of the skb, and then through another function call the matching packet type receiver callback function (IPv4 / IPv6). If we look at `ip_list_rcv()` which is the callback function for IPv4, we see that it will, for each skb, call `ip_rcv_core()`, which is the main IP receive routine. It will mostly check the package if it is acceptable, if it is not, it will drop it with `kfree_skb_reason(skb, drop_reason)`. 

After that call it will pass the skbs to `ip_sublist_rcv()`. This function will for each skb in the list call `ip_rcv_finish()`,   which will in turn call on `tcp_v4_early_demux(skb)` or `udp_v4_early_demux(skb)`, depending on the transport protocol, and in these functions the package is demultiplexed to a socket. `ip_list_rcv_core()` will also initialize the virtual path cache for the packet. It describes how the packet travels inside Linux networking. So mostly routing etc.

Once the skbs has gone through this process the skb list will be passed on from `ip_sublist_rcv()` to `ip_list_rcv_finish() -> ip_sublist_rcv_finish() -> dst_input() -> (IPv4) ip_local_deliver() / (IPv6) ip6_input()`. And from there and some more function calls, it will finally deliver the package to the transport layer. This is in `ip_protocol_deliver_rcu()`. 

We will look at `tcp_v4_rcv()`. `upd_rcv()` is used for UDP packages. 

### Transport layer

The `tcp_v4_rcv()` function defined in `ipv4/tcp_ipv4.c` is the main entry point for delivery ofdatagrams from the IP layer.

As usual, the pskb_may_pull() function is responsible for ensuring that the TCP header, and in the next call, the header options are in the kmalloc'ed portion of the sk_buff.
``` 
if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
	goto discard_it;
th = skb->h.th;
```

Ensure that the offset to the data in words exceeds size of tcp header.
```
if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
	goto bad_packet;
```

Ensure the options are in the kmalloc'ed part.
```
if (!pskb_may_pull(skb, th->doff * 4))
	goto discard_it;
```

Some other sanity checks such as data offset and packet length are validated later, but if the checksum (which covers the whole packet) is bad the packet is ditched here.
```
/* An explanation is required here, I think.
 * Packet length and doff are validated by header prediction,
 * provided case of th->doff==0 is eliminated.
 * So, we defer the checks. */

if (skb_checksum_init(skb, IPPROTO_TCP, inet_compute_pseudo))
	goto csum_error;
```

The `__inet_lookup()` function used to be called `__tcp_v4_lookup()`. It attempts to find a struct sock that may be associated with this packet, which was done in `tcp_v4_early_demux()`. Lookup elements include source and destination IP and port addresses along with any bound input interface
```
sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
					   skb, __tcp_hdrlen(th), th->source,
					   th->dest, sdif, &refcounted);
if (!sk)
	goto no_tcp_socket;
```

Next the TCP state is checked, and if it is a SYN-packet do some stuff. 
```
if (sk->sk_state == TCP_TIME_WAIT)
	goto do_time_wait;

if (sk->sk_state == TCP_NEW_SYN_RECV) {
	...
}
```

#### Adding the package to the socket
If the socket is locked, the packet must be added to the backlog queue. If there is no process blocked waiting to consume data on the socket, or the state of the socket is `TCP_LISTEN` the packet must be processed immediately via the call to `tcp_v4_do_rcv()`. If the socket is locked, the packet must be added to the backlog queue with `tcp_add_backlog()`. This queue is processed by the owner of the socket lock right before it is released. Then it will call `tcp_4_do_rcv()` on each.
```
if (sk->sk_state == TCP_LISTEN) {
	ret = tcp_v4_do_rcv(sk, skb);
	goto put_and_return;
}

sk_incoming_cpu_update(sk);

bh_lock_sock_nested(sk);
tcp_segs_in(tcp_sk(sk), skb);
ret = 0;
if (!sock_owned_by_user(sk)) {
	ret = tcp_v4_do_rcv(sk, skb);
} else {
	if (tcp_add_backlog(sk, skb, &drop_reason))
		goto discard_and_relse;
}
bh_unlock_sock(sk);
```

`tcp_add_backlog()` will return false if it succeeded in adding the skb to the backlog, true otherwise. 

The owner variable is actually a Boolean flag. A value of 0 means that no application process owns the socket at present. A value of 1 means that some application process owns the socket:
`#define sock_owned_by_user(sk) ((sk)->sk_lock.owner)`

`tcp_add_backlog()` will firstly do a checksum check.
```
if (unlikely(tcp_checksum_complete(skb))) {
		bh_unlock_sock(sk);
		trace_tcp_bad_csum(skb);
		*reason = SKB_DROP_REASON_TCP_CSUM;
		__TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
		__TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
		return true;
	}
```

Then it will attempt coalescing to last skb in backlog, even if we are above the limits.
This is okay because skb capacity is limited to MAX_SKB_FRAGS.
```
th = (const struct tcphdr *)skb->data;
hdrlen = th->doff * 4;

tail = sk->sk_backlog.tail;
if (!tail)
	goto no_coalesce;
thtail = (struct tcphdr *)tail->data;

if (TCP_SKB_CB(tail)->end_seq != TCP_SKB_CB(skb)->seq ||
	TCP_SKB_CB(tail)->ip_dsfield != TCP_SKB_CB(skb)->ip_dsfield ||
	((TCP_SKB_CB(tail)->tcp_flags |
	  TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_SYN | TCPHDR_RST | TCPHDR_URG)) 
	!((TCP_SKB_CB(tail)->tcp_flags &
	  TCP_SKB_CB(skb)->tcp_flags) & TCPHDR_ACK) ||
	((TCP_SKB_CB(tail)->tcp_flags ^
	  TCP_SKB_CB(skb)->tcp_flags) & (TCPHDR_ECE | TCPHDR_CWR)) ||
#ifdef CONFIG_TLS_DEVICE
	tail->decrypted != skb->decrypted ||
#endif
	!mptcp_skb_can_collapse(tail, skb) ||
	thtail->doff != th->doff ||
	memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)))
	goto no_coalesce;
```

`tcp->doff` stands for data offset, and because the doff carries the number of 32-bit words in the TCP header, we multiply it by 4 to get the TCP header length in bytes.

Then it will pull the tcp header from the skb with `__skb_pull(skb, hdrlen)`

Now it tries to do the merging with `skb_try_coalesce()`.

`skb_try_coalesce()` will first off do some checks.

```
if (skb_cloned(to))
	return false;
	
if (to->pp_recycle != from->pp_recycle ||
	(from->pp_recycle && skb_cloned(from)))
	return false;

if (len <= skb_tailroom(to)) {
	if (len)
		BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
	*delta_truesize = 0;
	return true;
}

to_shinfo = skb_shinfo(to);
from_shinfo = skb_shinfo(from);
if (to_shinfo->frag_list || from_shinfo->frag_list)
	return false;
if (skb_zcopy(to) || skb_zcopy(from))
	return false;
```

If they pass the checks, just like `skb_gro_receive()`, it first checks whether the skb headlen is zero, i.e. whether it needs to merge the head, or only the frags. If it needs to merge the head, it will convert it to a page descriptor first. 
```
page = virt_to_head_page(from->head);
offset = from->data - (unsigned char *)page_address(page);

skb_fill_page_desc(to, to_shinfo->nr_frags,
		   page, offset, skb_headlen(from));
*fragstolen = true;
```
`fragstolen` is a pointer to a boolean that we will use later.

In both cases it needs to copy the frags from the merging skb, if any. So what it does, just like `skb_gro_receive()`, is copy the structs (note: not the data, just pointer) to its own frags and update the merged skb.

```
memcpy(to_shinfo->frags + to_shinfo->nr_frags,
	   from_shinfo->frags,
	   from_shinfo->nr_frags * sizeof(skb_frag_t));
to_shinfo->nr_frags += from_shinfo->nr_frags;

if (!skb_cloned(from))
	from_shinfo->nr_frags = 0;

/* if the skb is not cloned this does nothing
 * since we set nr_frags to 0.
 */
for (i = 0; i < from_shinfo->nr_frags; i++)
	__skb_frag_ref(&from_shinfo->frags[i]);

to->truesize += delta;
to->len += len;
to->data_len += len;

*delta_truesize = delta;
return true;
```

The reason we set the `fragstolen` boolean, is because we need to use it now. If this goes through, i.e. the merge, we call on `kfree_skb_partial(skb, fragstolen)`. 

`kfree_skb_partial()` will free the skb, and depending on whether it had its head stolen, we need to free it.
```
void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
{
	if (head_stolen) {
		skb_release_head_state(skb);
		kmem_cache_free(skbuff_cache, skb);
	} else {
		__kfree_skb(skb);
	}
}
```

If coalesce fails, then we simply add the skb to the backlog, without merging. 
```
no_coalesce:
	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);

	/* Only socket owner can try to collapse/prune rx queues
	 * to reduce memory overhead, so add a little headroom here.
	 * Few sockets backlog are possibly concurrently non empty.
	 */
	limit += 64 * 1024;

	if (unlikely(sk_add_backlog(sk, skb, limit))) {
		bh_unlock_sock(sk);
		*reason = SKB_DROP_REASON_SOCKET_BACKLOG;
		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
		return true;
	}
	return false;
```

Jumping back to the `tcp_v4_rcv()` it unlocks the socket, now when it is done with it, and decrement the ref counter, i.e. if it holds a reference. 
```
if (refcounted)
	sock_put(sk);
```

`sock_put()` un-grab socket and destroy it, if it was the last reference. Now it returns whether the delivery was successful or not to `ip_protocol_deliver_rcu()`. If it was not, it will resubmit the package (to the upper layers). 

So now onto `tcp_v4_do_rcv()`. It will check the state of the socket and if it is established, call `tcp_rcv_established()`. `tcp_rcv_established()` is the TCP receive function for the ESTABLISHED state. It is split into a fast path and a slow path. The fast path is disabled when:
 * A zero window was announced from us - zero window probing is only handled properly in the slow path.
 * Out of order segments arrived.
 * Urgent data is expected.
 * There is no buffer space left
 * Unexpected TCP flags/window values/header lengths are received (detected by checking the TCP header against pred_flags)
 * Data is sent in both directions. Fast path only supports pure senders or pure receivers (this means either the sequence number or the ack value must stay constant)
 * Unexpected TCP option.
When these conditions are not satisfied it drops into a standard receive procedure patterned after RFC793 to handle all cases. The first three cases are guaranteed by proper `pred_flags` setting, the rest is checked inline. Fast processing is turned on in `tcp_data_queue` when everything is OK.

Urgent data handling is done in `tcp_urg()` which copies a bit from the skb to a bit which is then placed in `tcp_sk(sk)->urg_data`.
```
u32 ptr = tp->urg_seq - ntohl(th->seq) + (th->doff * 4) -
			  th->syn;

/* Is the urgent pointer pointing into this packet? */
if (ptr < skb->len) {
	u8 tmp;
	if (skb_copy_bits(skb, ptr, &tmp, 1))
		BUG();
	tp->urg_data = TCP_URG_VALID | tmp;
	if (!sock_flag(sk, SOCK_DEAD))
		sk->sk_data_ready(sk);
}
```
As you can see only one bit is copied, and will, from my understanding, be the bit that says if the skb has any urgent data to be processed. `sk_data_ready()` is a callback to indicate there is data to be processed. 

After processing urgent data. `tcp_data_queue()` will be called in order to queue the data for delivery to the user. Packets in sequence go to the receive queue. Out of sequence packets to the out_of_order_queue. It will first off pull the TCP header off, now it will only be data left in the skb. If there are any urgent data, it will copy it directly to the user. 
```
if (tp->ucopy.task == current &&
	tp->copied_seq == tp->rcv_nxt && tp->ucopy.len &&
	sock_owned_by_user(sk) && !tp->urg_data) {
	int chunk = min_t(unsigned int, skb->len,
			  tp->ucopy.len);

	__set_current_state(TASK_RUNNING);

	local_bh_enable();
	if (!skb_copy_datagram_msg(skb, 0, tp->ucopy.msg, chunk)) {
		tp->ucopy.len -= chunk;
		tp->copied_seq += chunk;
		eaten = (chunk == skb->len);
		tcp_rcv_space_adjust(sk);
	}
	local_bh_disable();
}
```

If all of the skb was eaten, i.e. `eaten = (chunk == skb->len)` then it will not queue the skb. Otherwise it will call `tcp_queue_rcv()`. `tcp_queue_rcv()` will first try to merge the skb with the last skb in the queue. If it was not successful, it will simply enqueue the skb. 

The out of order packets will be placed in a separate queue. When a packet is enqueued to the receive queue it will check the out of order queue to see if any of the out of order packages is next, if so it will enqueue it to the receive queue as well. If it has already been received it will free it with `__kfree_skb()`. 

When adding packages to the receive queue and tries to merge, it will set a boolean pointer to true or false whether it "stole" the head frag. That pointer will be passed to `kfree_skb_partial()`. This will only be called when the skb was merged with the last skb in the receive queue. 

For the fast path in `tcp_rcv_established()`, it will call on `tcp_queue_rcv()` directly without going through `tcp_data_queue()`. 

#### Copying the data from the socket to user space
Now onto how the user actually receives the data from the socket. This starts by the user application doing a sys_read system call on the socket. Then the protocol specific calls will be made in order to read the data. For example in IPv4/TCP the call chain will look like:
`ksys_read() -> ... -> sock_recvmsg() -> inet_recvmsg() -> tcp_recvmsg()`.

We will look at `tcp_recvmsg()`, i.e. for TCP. This one is pretty simple, if there is any data on the socket, i.e. packets in the receive queue, it will lock the socket and then call `tcp_recvmsg_locked()`. Otherwise it will busy-loop until it the socket is ready. 

`tcp_recvmsg_locked()` will look through the receive queue until it finds a package which is okay. Once it has found an okay skb it will check how much, if any, off the data is urgent. If it is more or equal than the data we want, we will skip the copy. Otherwise we will copy the skb data to the msg (user data buffer). 

if we used all data in the skb. We will then free the skb, or more specifically queue the skb up for freeing, with `tpc_eat_recv_skb()`, which is defined as:
```
static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
{
	__skb_unlink(skb, &sk->sk_receive_queue);
	if (likely(skb->destructor == sock_rfree)) {
		sock_rfree(skb);
		skb->destructor = NULL;
		skb->sk = NULL;
		return skb_attempt_defer_free(skb);
	}
	__kfree_skb(skb);
}
```

`skb_attempt_defer_free()` will queue up the skb for freeing in a `defer_list()`, if possible, otherwise free it. The defer list is a queue for skbs that will be freed later. 

So later when `tcp_recvmsg()` releases the lock. it will first go through the socket backlog and call `tcp_v4_do_receive()` on each in order to put them in the queue. They will then be freed once a call to `skb_defer_free_flush()` has been made.



