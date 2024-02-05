(https://courses.cs.washington.edu/courses/cse451/16au/readings/e1000.pdf)
## IRQ
The following interrupts are enabled:
![[Pasted image 20240205104204.png]]
The **RXT0** interrupt will start a timer whenever a packet is received, if the timer exceeds **RDTR** (defaults to 8) then the interrupt is triggered (no new packets in that time).
![[Pasted image 20240205104858.png]]
## e1000_intr (interrupt handler)
The interrupt handler. Checks the icr (interrupt control register) if we have errors (LCS or RXSEQ) and handle link status. Then calls **napi_schedule_prep** and **__napi_schedule** to schedule **e1000_clean** in NAPI context ([[Softirq]]).

## e1000_clean (poll callback)
The NAPI RX polling callback, will be called on TX interrupts as well i.e. TX descriptor finished (TXDW).
This function does two things:
* Reclaims resources (TX descriptors, SKB's, etc.) after transmission has finished (**e1000_clean_tx_irq**)
* Poll the NIC for received packets and send them up the network stack (**adapter->clean_rx, e1000_clean_rx_irq** or **e1000_clean_jumbo_rx_irq**).
### e1000_clean_rx_irq
This function reads received packets (rx_descriptors) until either:
* No more rx_descriptors available (no rx_desc with rx_desc->status == DONE)
* Number of packets received equals the budget i.e. max number of packets we are allowed to receive per this napi 'session' (work_done >= work_to_do).
For each **rx_desc**:
- Create a **sk_buff** with the received data. 
	- If data length < **copy_break** (default 256): allocate a skb with **napi_alloc_skb** (including full data) by calling **e1000_alloc_rx_skb**. Then copy the DMA mapped data from the NIC to the skb using **skb_put_data**. All of this is done inside **e1000_copybreak**.
	- Else: don't copy the data, instead build the **sk_buff** around the data by calling **napi_build_skb**. We then unmap the data from DMA and set the **buffer_info->rxbuf.data** to NULL to signal that we need to allocate new memory for this and DMA map it.
- Some error checking/checking for discarding is done (not important)
- We then reach the **process_skb** label.  That either calls:
	- **skb_put** - if we did not copy the data and just called **napi_build_skb**, this function will not set the tail pointer so we use put here to set **skb->tail** to the packet length.
	- **skb_trim** - if we did copy the data with **skb_put_data** this will set the **skb->tail** to the actual packet length, we might have copied more data than necessary if we don't use Ethernet RX FCS offloading (if above).
-  **e1000_receive_skb** is then called that sets the protocol on the **sk_buff** and then calls **napi_gro_receive** on the skb that sends it up the network stack.
In each iteration we also check if the number of buffers we have processed (**cleaned_count**) exceeds E1000_RX_BUFFER_WRITE (16) if so we call **adapter->alloc_rx_buf** (**e1000_alloc_rx_buffers**) to give back the descriptors to the NIC and allocate memory and DMA map it if necessary, this is done in bulk.
#### e1000_alloc_rx_buffers
Allocates and maps data for RX descriptors.
Tries to allocate and give back _cleaned_count_ **rx_desc**.
For each new **rx_desc** do:
- Check if **buffer_info->rxbuf.data** != NULL. If it is not then we copied the buffer to the skb instead of giving it and don't need to allocate new data.
- If it is NULL, then allocate new page fragments with **e1000_alloc_frag** that allocates a new data pointer in page fragments using **netdev_alloc_frag**. This function check's if we are in irq context (in hardirq or irq disabled) if so it takes page fragments from the _page_frag_cache_ **netdev_alloc_cache**. Otherwise it allocates them from **napi_alloc_cache**. When this function is called during initialization (**e1000_open**) we are in irq context. When it is called from the **e1000_clean_rx_irq** we are in NAPI context (softirq).
- Some weird errata checks (ignore)
- DMA map new data pointer and set **rx_desc->buffer_addr** to it
After all **rx_desc**'s have been allocated write the new descriptor tail to the **RDT** register (Receive Descriptor Tail).