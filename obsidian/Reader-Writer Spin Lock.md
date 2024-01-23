Sometimes, lock usage can be clearly divided into reader and writer paths. For example,
consider a list that is both updated and searched. When the list is updated (written to), it is
important that no other threads of execution concurrently write to or read from the list.
Writing demands mutual exclusion. On the other hand, when the list is searched (read
from), it is only important that nothing else writes to the list. Multiple concurrent readers
are safe so long as there are no writers. The task list’s access patterns fit this description. Not surprisingly, a reader-writer spin lock protects the task list. When a data structure is neatly split into reader/writer or consumer/producer usage patterns, it makes sense to use a locking mechanism that provides similar semantics. To satisfy this use, the Linux kernel provides reader-writer spin locks. Reader-writer spin locks provide separate reader and writer variants of the lock. One or more readers can concurrently hold the reader lock. The writer lock, conversely, can be held by at most one writer with no concurrent readers. Reader/writer locks are sometimes called shared/exclusive or concurrent/exclusive locks because the lock is available in a shared (for readers) and an exclusive (for writers) form.
![[Pasted image 20231228131350.png]]
![[Pasted image 20231228131457.png]]