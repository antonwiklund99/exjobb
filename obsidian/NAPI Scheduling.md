(net/core/dev.c)

Two of the static softirqs are used by the networking subsystem to schedule tx/rx packets. Initialized in **netdev_init(void)**.
![[Pasted image 20240123112730.png]]
## RX
RX softirq is raised by **napi_schedule**.
![[Pasted image 20240123115956.png]]
Or **net_rx_action** if there is more to poll after it is done:
![[Pasted image 20240123120330.png]]
(unlikely) It can also be raised directly by **trigger_rx_softirq**
![[Pasted image 20240123120455.png]]
The softirq handler (**net_rx_action**) will poll the NIC for a certain amount of time/packets. Calling the registered **poll** method in the drivers **napi_struct**.
 ![[Pasted image 20240123114113.png]]