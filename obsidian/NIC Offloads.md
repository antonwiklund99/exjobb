The default Ethernet maximum transfer unit (MTU) is 1500 bytes, which is the largest frame size that can usually be transmitted. This can cause system resources to be underutilized, for example, if there are 3200 bytes of data for transmission, it would mean the generation of three smaller packets. There are several options, called offloads, which allow the relevant protocol stack to transmit packets that are larger than the normal MTU. Packets as large as the maximum allowable 64KiB can be created, with options for both transmitting (Tx) and receiving (Rx). When sending or receiving large amounts of data this can mean handling one large packet as opposed to multiple smaller ones for every 64KiB of data sent or received. This means there are fewer interrupt requests generated, less processing overhead is spent on splitting or combining traffic, and more opportunities for transmission, leading to an overall increase in throughput.

Here is a picture that shows the normal data flow through a TCP/IP stack without offloading. TCP is used in the example but it is the same principle with UDP etc.
![[Pasted image 20240207124000.png]]

And here is an example when using offloading:
![[Pasted image 20240207124149.png]]

### Offload Types
#### Transmit side

##### TCP Segmentation Offload (TSO)

Uses the TCP protocol to send large packets. Uses the NIC to handle segmentation, and then adds the TCP, IP and data link layer protocol headers to each segment.

##### UDP Fragmentation Offload (UFO)

Uses the UDP protocol to send large packets. Uses the NIC to handle IP fragmentation into MTU sized packets for large UDP datagrams.

##### Generic Segmentation Offload (GSO)

Uses the TCP or UDP protocol to send large packets. If the NIC cannot handle segmentation/fragmentation, GSO performs the same operations, bypassing the NIC hardware. This is achieved by delaying segmentation until as late as possible, more specifically before passing it down to the network driver in `sch_direct_xmit()`.

One important thing to notice is that a GSO segmentation function comes after L2 protocol, because L2 header size will remain unchanged and attached to each segment. The type of the segmentation function is determined by the Ethertype. Then, we may have GSO for MPLS and IPv4/TCP, for example.

`sch_direct_xmit()` is an important participant in moving data down toward the network device. This is the "last step" before scheduling the package for transmission. So this is a good place to perform the GSO if the NIC driver cannot handle it. Before scheduling the sk_buff it will be validated depending on whether it has been validated before, which is will be if the skb has been re-queued. Since the packages can only be validated once, it means we can do this without holding qdisc lock. 

`sch_direct_xmit()` will call on a function named `validate_xmit_skb_list()`, which will in turn go through all the skbs in the buffer, if more than one, and validate them with `validate_xmit_skb()`. This is were the actual validation happens. So I will talk about the steps in the validation, even though we are mostly interested in GSO:
1. `validate_xmit_vlan`: Checks if there is the skb is vlan tagged, if so, the tag is pushed into the payload.
2. `sk_validate_xmit_skb`: Checks if this SKB belongs to an HW offloaded socket and whether any SW fallbacks are required based on dev. Check decrypted mark in case skb_orphan() cleared socket.
3. Now to the GSO step. Firstly we need to check whether the skb actually is GSO, and if so, does the NIC driver **not** support the GSO type? If so, we need to perform the GSO here.
   
**`__skb_gso_segment()`** 
This function segments the given skb and returns a list of segments. It will call on `skb_mac_gso_segment()`, which will in turn trigger a protocol specific segmentation offload functions (protocols above L2). It does this by called `skb_network_protocol`. Here if go down a bit in calls, but it will return the EtherType of the packet, regardless of whether it is vlan encapsulated (normal or hardware accelerated) or not. Once it has the network protocol, it will iterate over each of the packet_offload and find the one that matches the network type. It does this in order to find the right callback function for the protocol, e.g. UDP and `__udp_gso_segment()` or TCP and `tcp_gso_segment()`. I wont go into what their implementations are but they return a list of segments from the skb being passed.

#### Receiver side
##### Large Receive Offload (LRO)

Uses the TCP protocol. All incoming packets are re-segmented as they are received, reducing the number of segments the system has to process. They can be merged either in the driver or using the NIC. A problem with LRO is that it tends to resegment all incoming packets, often ignoring differences in headers and other information which can cause errors. It is generally not possible to use LRO when IP forwarding is enabled. LRO in combination with IP forwarding can lead to checksum errors. Forwarding is enabled if `/proc/sys/net/ipv4/ip_forward` is set to 1.

##### Generic Receive Offload (GRO)

Uses either the TCP or UDP protocols. GRO is more rigorous than LRO when resegmenting packets. For example it checks the MAC headers of each packet, which must match, only a limited number of TCP or IP headers can be different, and the TCP timestamps must match. Resegmenting can be handled by either the NIC or the GSO code.

GRO is implemented like a minimal buffer between the NIC (real or virtual) receive softirq and the network stack entry point. This is where packets are queued and then looked up for similarities in between them.

Upon every received packet, it will be compared and checked against all packets received in the last timeframes. If a match is found, the packet gets aggregated, and the system proceeds on pulling more packets from the NIC. When the NIC budget is fully consumed, the maximum number of queued packets is reached or no more packets are received, we send the whole queue up the stack: packets that can be optimized via GRO will be pushed up the stack as one or more large aggregated packets. The other packets will go up without being aggregated.

In order to identify which packets can be aggregated, GRO compares the headers of the packets in the queue to the headers of the incoming packet. That is, for a TCP connection, it will compare: MAC headers (when present), IP headers and TCP headers. If the last check succeeds, a match was found and packet is aggregated. Otherwise, it is from a different flow, and nothing GRO-related is performed.

Packets can be aggregated up to a resulting size of 64 kbytes. On a link with MTU=1500, it means it can aggregate up to 43 packets into 1. One possible counter-argument against GRO could be the number of comparisons (43 in this case) required. But in reality, they would be there anyway in order to locate the destination socket. And secondly, it saved 42 times of network stack processing on interface handling, route calculation, and so on. Currently a sustained rate of 10Gbps is impossible without GRO, even with jumbo frames. In a way GRO is a flexible and on-demand jumbo frame style of optimization.

So where are the packages merged? In the following functions:

**`napi_gro_receive()`**
The function `napi_gro_receive()` deals processing network data for GRO (if GRO is enabled for the system) and sending the data up the stack toward the protocol layers. Much of this logic is handled in a function called `dev_gro_recieve()`.

**`dev_gro_recieve()`**
This function begins by checking if GRO is enabled and, if so, preparing to do GRO. In the case where GRO is enabled, a list of GRO offload filters is traversed to allow the higher level protocol stacks to act on a piece of data which is being considered for GRO. This is done so that the protocol layers can let the network device layer know if this packet is part of a network flow that is currently being receive offloaded and handle anything protocol specific that should happen for GRO. For example, the TCP protocol will need to decide if/when to ACK a packet that is being coalesced into an existing packet:

```
list_for_each_entry_rcu(ptype, head, list) {
	if (ptype->type == type && ptype->callbacks.gro_receive)
		goto found_ptype;
}
```

If the protocol layers indicated that it is time to flush the GRO’d packet, that is taken care of next. This happens with a call to `napi_gro_complete()`, which calls a `gro_complete()` callback for the protocol layers and then passes the packet up the stack by calling `netif_receive_skb()`:

```
if (pp) {
	skb_list_del_init(pp);
	napi_gro_complete(napi, pp);
	gro_list->count--;
}
```

If the packet was was not merged and there are more than `MAX_GRO_SKBS` (8) GRO flows on the system, the oldest skb gets on the gro list gets flushed.
```
if (unlikely(gro_list->count >= MAX_GRO_SKBS))
		gro_flush_oldest(napi, &gro_list->list);
	else
		gro_list->count++;
```

Otherwise we do nothing. 