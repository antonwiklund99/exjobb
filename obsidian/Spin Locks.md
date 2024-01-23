The most common lock in the Linux kernel is the spin lock. A spin lock is a lock that
can be held by at most one thread of execution. If a thread of execution attempts to ac-
quire a spin lock while it is already held, which is called contended, the thread busy loops—
spins—waiting for the lock to become available. If the lock is not contended, the thread
can immediately acquire the lock and continue. The spinning prevents more than one
thread of execution from entering the critical region at any one time. The same lock can
be used in multiple locations, so all access to a given data structure, for example, can be
protected and synchronized.
![[Pasted image 20231228130915.png]]
![[Pasted image 20231228131600.png]]

Another type of spin lock is a [[Reader-Writer Spin Lock]]