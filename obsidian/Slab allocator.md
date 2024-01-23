(Operating System Concepts 10.8.2)
![[Pasted image 20231229144533.png]]
A second strategy for allocating kernel memory is known as slab allocation. A slab is made up of one or more physically contiguous pages. A cache consists of one or more slabs. There is a single cache for each unique kernel data structure—for example, a separate cache for the data structure representing process descriptors, a separate cache for file objects, a separate cache for semaphores, and so forth. Each cache is populated with objects that are instantiations of the kernel data structure the cache represents. For example, the cache representing semaphores stores instances of semaphore objects, the cache representing process descriptors stores instances of process descriptor objects, and so forth. The relationship among slabs, caches, and objects is shown in the figure. The figure shows two kernel objects 3 KB in size and three objects 7 KB in size, each stored in a separate cache. 3-KB objects 7-KB objects kernel objects caches slabs physically contiguous pages

The slab-allocation algorithm uses caches to store kernel objects. When a
cache is created, a number of objects—which are initially marked as free—are
allocated to the cache. The number of objects in the cache depends on the size
of the associated slab. For example, a 12- KB slab (made up of three contiguous
4-KB pages) could store six 2- KB objects. Initially, all objects in the cache are
marked as free. When a new object for a kernel data structure is needed, the
allocator can assign any free object from the cache to satisfy the request. The
object assigned from the cache is marked as used.

In Linux, a slab may be in one of three possible states:
1. Full. All objects in the slab are marked as used.
2. Empty. All objects in the slab are marked as free.
3. Partial. The slab consists of both used and free objects.
The slab allocator first attempts to satisfy the request with a free object in a partial slab. If none exists, a free object is assigned from an empty slab. If no empty slabs are available, a new slab is allocated from contiguous physical pages and assigned to a cache; memory for the object is allocated from this slab.

Linux refers to its slab implementation as SLAB. Recent distributions of Linux include two other kernel memory allocators - the SLOB and SLUB allocators.

The SLOB allocator is designed for systems with a limited amount of memory, such as embedded systems. SLOB (which stands for “simple list of blocks”) maintains three lists of objects: small (for objects less than 256 bytes), medium (for objects less than 1,024 bytes), and large (for all other objects less than thesize of a page). Memory requests are allocated from an object on the appropriate list using a first-fit policy.

Beginning with Version 2.6.24, the SLUB allocator replaced SLAB as the default allocator for the Linux kernel. SLUB reduced much of the overhead required by the SLAB allocator. For instance, whereas SLAB stores certain metadata with each slab, SLUB stores these data in the page structure the Linux kernel uses for each page. Additionally, SLUB does not include the per-CPU queues that the SLAB allocator maintains for objects in each cache. For systems with a large number of processors, the amount of memory allocated to these queues is significant. Thus, SLUB provides better performance as the number of processors on a system increases.

[[Slab poison]]