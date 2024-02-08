This is a protocol-specific. Depending on the socket type (IPv6/IPv4, UDP/TCP/RAW), there's different implementation of this struct.

For most socket types (at least for IPv4+TCP, IPv4+UDP, IPv4+RAW), the `inet_sendmsg` function will be called to sendmsg.

## inet_sendmsg
`int inet_sendmsg(struct socket *sock, struct msghdr *msg size_t size)`
This function will first off check if the socket is binded, if not, it will bind it to a local IP/port.
After unlikely binding the socket. It will pass the packet to the Transport layer. I.e. TCP / UDP.

## UDP
### udp_sendmsg
`int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)`
First off it will route the package: check if the socket is in the rtable, if so it has the routing for the package. If not, it will call ip_route_output_flow() in order to get the routing. 
After routing the package. `ip_make_skb` will be called in order to make the skb.

### ip_make_skb
`struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4, int getfrag(void from, char *to, int offset, int len, int odd, struct sk_buff skb), void from, int length, int transhdrlen, struct ipcm_cookie ipc, struct rtable rtp, struct inet_cork cork, unsigned int flags)

Function to make the skb before queueing. First off it will setup the cork by calling `ip_setup_cork()`. The struct  inet_cork stores the values of TOS, TTL and priority that are passed through the struct ipcm_cookie. If there are user-specified TOS (tos != -1) or TTL (ttl != 0) in the struct ipcm_cookie, these values are used to override the per-socket values. In case of TOS also the priority is changed accordingly. 
Then it calls `__ip_append_data` in order to allocate the skb and pass the data to it.


### \_\_ip_append_data
`__ip_append_data(struct sock *sk, struct flowi4 *fl4, struct sk_buff_head queue, struct inet_cork *cork, struct page_frag *pfrag, int getfrag(void from, char *to, int offset, int len, int odd, struct sk_buff skb), void from, int length, int transhdrlen, unsigned int flags)`
This function will allocate one or more skb in a skb_buff_head queue , depending on the size data to be transmitted and the mtu, which is decided by:
`mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;` 
`IP_MAX_MTU` is 65535. 

The first skb will be allocated with `sock_alloc_send_pskb() -> alloc_skb_with_frags() -> __alloc_skb()` and will be orphaned with `skb_set_owner_w()`. While the others will be directly allocated with `__alloc_skb()`.

The data pointer will then be moved with `skb_put()` and then some data will be copied to where the data pointer is pointing with `ip_generic_getfrag()`, and checksum if is the first fragment and we wish it won't be fragmented in the future.

Each skb gets added to the queue after being allocated and copied data to.

### \_\_ip_make_skb
`struct sk_buff *__ip_make_skb(struct sock *sk, struct flowi4 fl4, struct sk_buff_head queue ,struct inet_cork cork)
This will combine all pending IP fragments on the socket as one IP datagram and push them out. It will dequeue the skb's and add them to the first (head) `skb_shinfo(skb)->frag_list`.
Flags are set here:
```
	iph = ip_hdr(skb);
	iph->version = 4;
	iph->ihl = 5;
	iph->tos = (cork->tos != -1) ? cork->tos : inet->tos;
	iph->frag_off = df;
	iph->ttl = ttl;
	iph->protocol = sk->sk_protocol;
	ip_copy_addrs(iph, fl4);
	ip_select_ident(net, skb, sk);
	...
	skb_dst_set(skb, &rt->dst);
```
Now we have our IP datagram ready to be pushed out.

### udp_send_msg
`static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4, struct inet_cork *cork)`
Firstly a UDP header is created and fields are set such as source, dest, etc for the header. 
if gso is needed then flags on the skb are set:
```
if (datalen > cork->gso_size) {
	skb_shinfo(skb)->gso_size = cork->gso_size;
	skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
	skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen, cork->gso_size);
}
```
Then the package is pushed out with `ip_send_skb() -> ... -> ip_finish_output2() -> __dev_queue_xmit() -> sch_direct_xmit() -> dev_hard_start_xmit89 -> e1000_xmit_frame()`

In `ip_finish_output2()` `validate_xmit_skb_list() -> ... -> __skb_gso_segment()` is called which segments the given skb and returns a list of segments, if the gso_type is not supported by the net device. 