(Linux Kernel Development Chapter 8)
The job of bottom halves is to perform any interrupt-related work not performed by the interrupt handler. In an ideal world, this is nearly all the work because you want the interrupt handler to perform as little work (and in turn be as fast) as possible. By offloading as much work as possible to the bottom half, the interrupt handler can return control of the system to whatever it interrupted as quickly as possible.

Currently, three methods exist for deferring work: [[Softirq]], tasklets, and [[Work Queues]]. Tasklets are built on softirqs and work queues are their own subsystem.
 ![[Pasted image 20240123124505.png]]