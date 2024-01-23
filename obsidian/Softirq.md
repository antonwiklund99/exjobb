Softirqs are statically allocated at compile time. Unlike tasklets, you cannot dynamically
register and destroy softirqs.
![[Pasted image 20240123112320.png]]
![[Pasted image 20240123112601.png]]
A softirq never preempts another softirq. The only event that can preempt a softirq is an interrupt handler.Another softirq, even the same one, can run on another processor, however.
When a softirq is run on a processor softirq is disabled on **that** processor, however the same softirq can be run on another processor simultaneously. This means that all shared data needs synchronization. For performance reasons this means that most softirq use per-processor data to avoid locking (including the networking subsystem)
[[NAPI Scheduling]]