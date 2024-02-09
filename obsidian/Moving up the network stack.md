When the protocol layers indicate that it is time to flush the GRO'd flow, the stack calls `napi_gro_complete()` . 

The first thing `napi_gro_complete()` does is check the number of segments aggregated for the skb. If it is 1, i.e. there is just one segment, `napi_gro_complete()` simply passes it to `gro_normal_one()` as it is. Otherwise, it searches for the protocol callback function. The chain will go up to the transport layer, and each layer adds some flags, sets the gso type, and some other protocol specific operations. Lastly, it will call on `gro_normal_one()`.

`gro_normal_one()` will queue one GRO_NORMAL SKB up for list processing. If batch size exceeded, we pass the whole batch up to the stack. And that is done by calling `gro_normal_list()` where it passes the `napi->rx_list` to `netif_receive_skb_list_internal()`, which clears the list and add the skbs in a new list to then pass them to `__netif_receive_skb_list() -> __netif_receive_skb_list_core()`.

### IP layer
`__netif_receive_skb_list_core()` will find out the packet type of the skb, and then through another function call the matching packet type receiver callback function (IPv4 / IPv6). If we look at `ip_list_rcv()` which is the callback function for IPv4, we see that it will, for each skb, call `ip_rcv_core()`, which is the main IP receive routine. It will mostly check the package if it is acceptable, if it is not, it will drop it with `kfree_skb_reason(skb, drop_reason)`. 

After that call it will pass the skbs to `ip_sublist_rcv()`. This function will for each skb in the list call `ip_rcv_finish()`,   which will in turn call on `tcp_v4_early_demux(skb)` or `udp_v4_early_demux(skb)`, depending on the transport protocol, and in these functions the package is demultiplexed to a socket. `ip_list_rcv_core()` will also initialize the virtual path cache for the packet. It describes how the packet travels inside Linux networking. So mostly routing etc.

Once the skbs has gone through this process the skb list will be passed on from `ip_sublist_rcv()` to `ip_list_rcv_finish() -> ip_sublist_rcv_finish() -> dst_input() -> (IPv4) ip_local_deliver() / (IPv6) ip6_input()`. And from there and some more function calls, it will finally deliver the package to the transport layer.

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
If the socket is locked, the packet must be added to the backlog queue. If there is no process blocked waiting to consume data on the socket, or the state of the socket is `TCP_LISTEN` the packet must be processed immediately via the call to `tcp_v4_do_rcv()`. If the socket is locked, the packet must be added to the backlog queue with `tcp_add_backlog()`.
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

