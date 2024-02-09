(https://courses.cs.washington.edu/courses/cse451/16au/readings/e1000.pdf)
## IRQ
The following interrupts are enabled:
![[Pasted image 20240205104204.png]]
The **RXT0** interrupt will start a timer whenever a packet is received, if the timer exceeds **RDTR** (defaults to 8) then the interrupt is triggered (no new packets in that time).
![[Pasted image 20240205104858.png]]
The **TXDW** interrupts whenever a TX descriptor is done.
## e1000_intr (interrupt handler)
The interrupt handler. Checks the icr (interrupt control register) for errors to handle and changes in link status(LCS or RXSEQ). Then calls **napi_schedule_prep** and **__napi_schedule** to schedule **e1000_clean** in NAPI context ([[Softirq]]).

## e1000_clean (poll callback)
The NAPI RX polling callback, will be called on TX interrupts as well i.e. TX descriptor finished (TXDW).
This function does two things:
* Reclaims resources (TX descriptors, SKB's, etc.) after a transmission has finished by calling **e1000_clean_tx_irq**.
* Poll the NIC for received packets and send them up the network stack by calling **adapter->clean_rx**. This function is either **e1000_clean_rx_irq** or **e1000_clean_jumbo_rx_irq** depending on if jumbo frames are enabled.
### e1000_clean_rx_irq
This function reads received packets (rx_descriptors) until either:
* No more rx_descriptors available (no rx_desc with rx_desc.status == DONE)
* Number of packets received equals the budget i.e. max number of packets we are allowed to receive in this NAPI "session" (work_done >= work_to_do).
For each **rx_desc**:
1) Create a **sk_buff** for the received packet. 
	- If data length < **copy_break** (default 256): allocate a skb with **napi_alloc_skb** (including full data) by calling **e1000_alloc_rx_skb**. Then copy the data from the DMA mapped area in the RX descriptor to **skb->head** using **skb_put_data**. All of this is done inside **e1000_copybreak**.
	- Else: don't copy the data, instead build the **sk_buff** around the data by calling **napi_build_skb**. Then unmap the data from DMA and set the **buffer_info.rxbuf.data** to NULL to signal that we need to allocate new memory for this descriptor and DMA map it.
2) Some error checking/checking for discarding is done (not important)
3) We then reach the **process_skb** label.  Here we fix the **skb.tail** pointer with:
	- **skb_put** - if we did not copy the data and just called **napi_build_skb** the tail pointer will not be set so we use **skb_put** here to set **skb->tail** to the packet length.
	- **skb_trim** - if we did copy the data with **skb_put_data** **skb_trim** will set the **skb->tail** to the actual packet length, we might have copied more data than the packet length.
4) **e1000_receive_skb** is then called that sets the protocol on the **sk_buff** and then calls **napi_gro_receive** on the skb that sends it up the network stack.
In each iteration we also check if the number of buffers we have processed (**cleaned_count**) exceeds E1000_RX_BUFFER_WRITE (16) if so we call **adapter->alloc_rx_buf** (**e1000_alloc_rx_buffers**) to give back processed descriptors to the NIC and allocate new memory and DMA map it if necessary (if we did not used copybreak when creating the skb). This is done in bulk to speed things up.
#### e1000_alloc_rx_buffers
Allocates and maps data for RX descriptors.
Tries to allocate and give back _cleaned_count_ **rx_desc**.
For each new **rx_desc** do:
1) Check if **buffer_info->rxbuf.data** != NULL. If it is not then we copied the buffer to the skb instead of giving it and don't need to allocate new data.
2) If it is NULL, then allocate new page fragments with **e1000_alloc_frag** that allocates a new data pointer in page fragments using **netdev_alloc_frag**. This function check's if we are in irq context (in hardirq or irq disabled) if so it takes page fragments from the _page_frag_cache_ **netdev_alloc_cache**. Otherwise it allocates them from **napi_alloc_cache**. When this function is called during initialization (**e1000_open**) we are in irq context. When it is called from the **e1000_clean_rx_irq** we are in NAPI context (softirq).
3) Some weird errata checks (ignore)
4) DMA map new data pointer and set **rx_desc->buffer_addr** to it
After all **rx_desc**'s have been allocated write the new descriptor tail to the **RDT** register (Receive Descriptor Tail).

### e1000_clean_tx_irq
Cleans up and frees TX descriptors that have been sent out by the NIC.
This function will start at tx_ring->next_to_clean and go through TX descriptors as long as the descriptor status is done and the number of used tx_descriptors < 0 (count < tx_ring->count). It will go through each skb, for each skb with multiple TX descriptors, it uses the buffer_info->next_to_watch to get the last TX descriptor for one SKB/packet. It calls the last descriptor eop and checks for done on this.
For each TX descriptor it calls **e1000_unmap_and_free_tx_resource**. This function unmaps the DMA memory (buffer_info->dma) and free's the SKB in buffer_info->skb if it is not NULL with **napi_consume_skb**.
It will then set tx_ring->next_to_clean to signal to **e1000_xmit_frame** that the cleaned TX descriptors can be used.
Then signals to the kernel that the bytes have been sent with **netdev_completed_queue**.

## e1000_xmit_frame
Function registered as **ndo_start_xmit** in the e1000 device driver **net_device_ops** struct. So this function will be called to setup up the packets for the NIC to send.
1) Set **mss** (Maximum Segment Size) to **shinfo->gso_size**. If it is larger than 0 that means that the SKB is using [[GSO]] and we assume that it is a TCP packet (I think)
2) Do alot of checks on the skb to determine the number of descriptors needed (**count**)
3) Check if we have enough room for count + 2 descriptors by calling **e1000_maybe_stop_tx** that will check the number of unused descriptors and if they are less then the number of needed - stop the **qeueue** associated with the **netdev** and return _NETDEV_TX_BUSY_ 
4) Check if skb is using [[TSO]] and setup the appropiate registers if so by calling **e1000_tso**. This function calls **skb_is_gso** to determine if it is a TSO (GSO?) and if so configures a context descriptor describing the segmentation in the tx ring. See _3.5 TCP Segmentation_ for all the registers/config fields in the **context_desc** for configuring TCP segmentation.
5) Call **e1000_tx_map**, this function starts by going through the linear data in the **sk_buff** and DMA maps it and adds it to buffer_info->dma in the TX ring. Then goes through the paged data in the skb (skb->frags) and DMA maps them into the TX ring. In this function **i** is the next available TX descriptor in the ring and **count** is the number of new TX descriptors. Stores the pointer to the skb and meta info in the last skb we used. Store the last index in buffer_info.next_to_watch of the first descriptor.
6) If we mapped new descriptors call **netdev_sent_queue** to signal to the kernel how many bytes we sent and then call **e1000_tx_queue** to write the buffer_info's to the TX descriptor and then advance **tx_ring->next_to_use** to beyond the new TX descriptors.
7) Call **e1000_maybe_stop_tx** again to make sure we have enough room for the next transmit (after this one) otherwise turn the queue off.
8) If there are no more skb's queued (by qdisc) or if the queue is off - write the **TDT** Transmit Descriptor Tail) register to signal to the NIC that we have new TX descriptors. I think we do this to have the NIC read as much as possible each time it reads packets into it's packet buffer.