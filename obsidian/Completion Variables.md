Using completion variables is an easy way to synchronize between two tasks in the kernel when one task needs to signal to the other that an event has occurred. One task waits on the completion variable while another task performs some work. When the other task has completed the work, it uses the completion variable to wake up any waiting tasks. If you think this sounds like a semaphore, you are right—the idea is much the same. In fact, completion variables merely provide a simple solution to a problem whose answer is otherwise semaphores. For example, the vfork() system call uses completion variables to wake up the parent process when the child process execs or exits.
Completion variables are represented by the struct completion type, which is defined in `<linux/completion.h>`
A statically created completion variable is created and initialized via:
`DECLARE_COMPLETION(mr_comp);
A dynamically created completion variable is initialized via:
`init_completion().
On a given completion variable, the tasks that want to wait call `wait_for_completion()`. After the event has occurred, calling `complete()` signals all waiting tasks to wake up.