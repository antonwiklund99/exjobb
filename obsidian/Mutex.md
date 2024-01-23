The mutex is represented by struct mutex. It behaves similar to a semaphore with a
count of one, but it has a simpler interface, more efficient performance, and additional
constraints on its use.
To statically define a mutex, you do:
`DEFINE_MUTEX(name);
To dynamically initialize a mutex, you call
`mutex_init(&mutex);
Locking and unlocking the mutex is easy:
```
mutex_lock(&mutex);
/* critical region ... */
mutex_unlock(&mutex);
```
That is it! Simpler than a semaphore and without the need to manage usage counts.
The simplicity and efficiency of the mutex comes from the additional constraints it
imposes on its users over and above what the semaphore requires. Unlike a semaphore,
which implements the most basic of behavior in accordance with Dijkstra’s original design, the mutex has a stricter, narrower use case:
- Only one task can hold the mutex at a time. That is, the usage count on a mutex is always one.
- Whoever locked a mutex must unlock it. That is, you cannot lock a mutex in one context and then unlock it in another. This means that the mutex isn’t suitable for more complicated synchronizations between kernel and user-space. Most use cases, however, cleanly lock and unlock from the same context.
- Recursive locks and unlocks are not allowed. That is, you cannot recursively acquire the same mutex, and you cannot unlock an unlocked mutex.
- A process cannot exit while holding a mutex.
- A mutex cannot be acquired by an interrupt handler or bottom half, even with `mutex_trylock().
- A mutex can be managed only via the official API: It must be initialized via the methods described in this section and cannot be copied, hand initialized, or reinitialized.
Perhaps the most useful aspect of the new struct mutex is that, via a special debugging
mode, the kernel can programmatically check for and warn about violations of these
constraints. When the kernel configuration option CONFIG_DEBUG_MUTEXES is enabled, a multitude of debugging checks ensure that these (and other) constraints are always
upheld.This enables you and other users of the mutex to guarantee a regimented, simple
usage pattern.