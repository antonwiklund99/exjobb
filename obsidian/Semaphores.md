Semaphores in Linux are sleeping locks.When a task attempts to acquire a semaphore
that is unavailable, the semaphore places the task onto a wait queue and puts the task to
sleep.The processor is then free to execute other code.When the semaphore becomes
available, one of the tasks on the wait queue is awakened so that it can then acquire the
semaphore.
This provides better processor utilization than spin locks because there is no time spent
busy looping, but semaphores have much greater overhead than spin locks. Life is always a
trade-off.
You can draw some interesting conclusions from the sleeping behavior of semaphores:
- Because the contending tasks sleep while waiting for the lock to become available, semaphores are well suited to locks that are held for a long time. Conversely, semaphores are not optimal for locks that are held for short periods because the overhead of sleeping, maintaining the wait queue, and waking back up can easily outweigh the total lock hold time.
- Because a thread of execution sleeps on lock contention, semaphores must be obtained only in process context because interrupt context is not schedulable.
- You can (although you might not want to) sleep while holding a semaphore because you will not deadlock when another process acquires the same semaphore. (It will just go to sleep and eventually let you continue.)
- You cannot hold a spin lock while you acquire a semaphore, because you might have to sleep while waiting for the semaphore, and you cannot sleep while holding a spin lock