---
title:
  "{ Title }":
tags:
  - OS
created:
  "{ date }":
updated:
  "{ date }":
---
## 3. Process Management

### Process Concept

**Definition**: A program in execution

**Process vs Program:**

- **Program**: Passive entity (executable file on disk)
- **Process**: Active entity (program + execution context)

**Process Components:**

1. **Text Section**: Program code
2. **Data Section**: Global variables
3. **Heap**: Dynamically allocated memory
4. **Stack**: Function parameters, local variables, return addresses
5. **Program Counter**: Next instruction to execute
6. **CPU Registers**: Current values

**Process Memory Layout:**

```
High Address
┌─────────────┐
│    Stack    │ ← Grows downward
├─────────────┤
│      ↓      │
│   (Free)    │
│      ↑      │
├─────────────┤
│    Heap     │ ← Grows upward
├─────────────┤
│    Data     │ (Global variables)
├─────────────┤
│    Text     │ (Program code)
└─────────────┘
Low Address
```

### Process States

A process changes states during execution:

```
       ┌─────────┐
       │   New   │
       └────┬────┘
            │
            ↓
       ┌─────────┐      Interrupt      ┌─────────┐
   ┌───│  Ready  │◄──────────────────  │ Running │
   │   └────┬────┘                     └────┬────┘
   │        ↑                               │
   │        │ I/O completion                │
   │        │ or event                      │ I/O or
   │        │                               │ event wait
   │   ┌────┴────┐                         │
   └──►│ Waiting │◄────────────────────────┘
       └────┬────┘
            │
            ↓
       ┌─────────┐
       │Terminated│
       └─────────┘
```

**1. New**: Process being created

**2. Ready**:

- Process waiting for CPU
- Has all resources except CPU
- In ready queue

**3. Running**:

- Process currently executing on CPU
- Instructions being executed

**4. Waiting (Blocked)**:

- Process waiting for I/O or event
- Cannot proceed until event occurs
- In wait queue

**5. Terminated**:

- Process finished execution
- Resources being released

**State Transitions:**

- **New → Ready**: Process created, loaded into memory
- **Ready → Running**: Scheduler assigns CPU (Dispatch)
- **Running → Ready**: Time quantum expired (Preemption)
- **Running → Waiting**: I/O request or event wait
- **Waiting → Ready**: I/O complete or event occurred
- **Running → Terminated**: Process completes execution

### Process Control Block (PCB)

**Definition**: Data structure maintained by OS for each process

**Also Called**: Task Control Block (TCB)

**PCB Contents:**

```
┌─────────────────────────────┐
│     Process Control Block   │
├─────────────────────────────┤
│ Process ID (PID)            │
│ Process State               │
│ Program Counter             │
│ CPU Registers               │
│ CPU Scheduling Info         │
│   - Priority                │
│   - Scheduling queue ptr    │
│ Memory Management Info      │
│   - Page tables             │
│   - Memory limits           │
│ Accounting Info             │
│   - CPU time used           │
│   - Time limits             │
│ I/O Status Info             │
│   - Open files              │
│   - I/O devices             │
└─────────────────────────────┘
```

**Key PCB Fields:**

1. **Process State**: Current state (ready/running/waiting)
2. **Process ID (PID)**: Unique identifier
3. **Program Counter**: Address of next instruction
4. **CPU Registers**: Register values (saved during context switch)
5. **CPU Scheduling Information**: Priority, scheduling queue pointers
6. **Memory Management**: Base/limit registers, page tables
7. **Accounting**: CPU time, time limits, process numbers
8. **I/O Status**: List of open files, allocated devices

**PCB Usage:**

- Context switching
- Process scheduling
- Resource tracking
- Security and protection

### Process Creation

**Reasons for Creating Process:**

- User initiates new program
- System boot
- Batch job initiation
- Existing process creates child process

**Parent-Child Relationship:**

- **Parent Process**: Creates new process
- **Child Process**: Created by parent

**Resource Sharing Options:**

1. **Child shares all parent resources**
2. **Child shares subset of parent resources**
3. **Child gets new resources from OS**

**Execution Options:**

1. **Concurrent**: Parent and child execute concurrently
2. **Wait**: Parent waits until child terminates

**Address Space Options:**

1. **Duplicate**: Child duplicates parent's address space
2. **New Program**: Child has new program loaded

**Unix/Linux Process Creation:**

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main() {
    pid_t pid;
    
    pid = fork();  // Create child process
    
    if (pid < 0) {
        // Fork failed
        fprintf(stderr, "Fork failed\n");
        return 1;
    }
    else if (pid == 0) {
        // Child process
        printf("Child process (PID: %d)\n", getpid());
        execlp("/bin/ls", "ls", NULL);  // Load new program
    }
    else {
        // Parent process
        printf("Parent process (PID: %d)\n", getpid());
        wait(NULL);  // Wait for child to complete
        printf("Child completed\n");
    }
    
    return 0;
}
```

**fork() System Call:**

- Creates exact copy of parent process
- Returns 0 to child
- Returns child PID to parent
- Child gets copy of parent's data space, heap, stack

**exec() Family:**

- Replaces current process image with new program
- `execlp()`, `execvp()`, `execve()`, etc.
- Does not create new process, transforms existing one

### Process Termination

**Normal Termination:**

- Process executes last statement
- Calls `exit()` system call
- Returns status value to parent
- Resources deallocated by OS

**Abnormal Termination:**

- Fatal error (divide by zero, invalid memory access)
- Killed by another process
- Parent termination

**Termination Process:**

1. Process calls `exit()` or is killed
2. Resources deallocated:
    - Memory freed
    - Open files closed
    - I/O devices released
3. PCB removed
4. Exit status returned to parent

**Parent Termination Effects:**

**Option 1: Cascading Termination**

- All children terminated when parent terminates
- Used in some OS

**Option 2: Orphan Processes**

- Children continue executing
- Adopted by init process (PID 1)
- Used in Unix/Linux

**Zombie Process:**

- Child terminated but parent hasn't called `wait()`
- PCB still maintained
- "Undead" process
- Parent must call `wait()` to remove zombie

```c
// Parent code to prevent zombies
pid_t pid = fork();

if (pid > 0) {
    // Parent process
    int status;
    wait(&status);  // Reap child, prevent zombie
}
```

### Parent-Child Processes

**Process Hierarchy:**

```
init (PID 1)
├── Shell (PID 100)
│   ├── Process A (PID 200)
│   │   └── Process A1 (PID 300)
│   └── Process B (PID 201)
└── Daemon (PID 101)
    └── Worker (PID 250)
```

**Key Concepts:**

**1. Process Tree**

- Hierarchical structure
- Each process (except init) has parent
- Can have multiple children

**2. Parent Process**

- Creates child using `fork()`
- Can wait for child termination
- Receives child's exit status
- PPID stored in child's PCB

**3. Child Process**

- Inherits parent's environment
- Gets copy of parent's file descriptors
- Separate address space
- Can execute different program via `exec()`

**Communication:**

- Pipes
- Shared memory
- Message passing
- Signals

**Example - Process Family:**

```c
int main() {
    pid_t pid1, pid2;
    
    // Create first child
    pid1 = fork();
    
    if (pid1 == 0) {
        // First child
        printf("Child 1 (PID: %d, Parent: %d)\n", 
               getpid(), getppid());
        exit(0);
    }
    
    // Parent creates second child
    pid2 = fork();
    
    if (pid2 == 0) {
        // Second child
        printf("Child 2 (PID: %d, Parent: %d)\n", 
               getpid(), getppid());
        exit(0);
    }
    
    // Parent waits for both children
    wait(NULL);
    wait(NULL);
    
    printf("Parent (PID: %d) - All children done\n", 
           getpid());
    
    return 0;
}
```

### CPU-I/O Burst Cycle

**Concept**: Process execution alternates between CPU execution and I/O wait

**Burst Types:**

**1. CPU Burst**

- Period of computation
- Process uses CPU
- No I/O operations

**2. I/O Burst**

- Process waits for I/O
- CPU idle for this process
- Can be scheduled out

**Execution Pattern:**

```
Process Execution Timeline:

CPU → I/O → CPU → I/O → CPU → I/O → CPU
│      │      │      │      │      │      │
└─ CPU burst ─┘      │      │      │      │
       └─ I/O burst ─┘      │      │      │
              └─ CPU burst ─┘      │      │
                     └─ I/O burst ─┘      │
                            └─ CPU burst ─┘
```

**Process Types:**

**1. CPU-Bound Process**

- Long CPU bursts
- Few I/O operations
- Examples: Scientific calculations, compilers
- Spends more time computing

**2. I/O-Bound Process**

- Short CPU bursts
- Frequent I/O operations
- Examples: Text editors, database queries
- Spends more time waiting for I/O

**CPU Burst Distribution:**

Most processes have:

- Many short CPU bursts
- Few long CPU bursts

```
Frequency
│    ┌─┐
│    │ │
│    │ │  ┌─┐
│    │ │  │ │
│    │ │  │ │ ┌┐
│    │ │  │ │ ││  ┌┐
└────┴─┴──┴─┴─┴┴──┴┴────► Burst Duration
     Short    Medium  Long
```

**Scheduling Implications:**

- **I/O-bound**: Need faster response, higher priority
- **CPU-bound**: Can wait longer, lower priority
- Mix of both types needed for good CPU utilization

---

## 4. Threads

### Thread Concept

**Definition**: Lightweight process; basic unit of CPU utilization

**Thread Components:**

- Thread ID
- Program Counter
- Register set
- Stack

**Shared Among Threads (within same process):**

- Code section
- Data section
- Open files
- Signals

**Process vs Thread:**

```
Process:                   Multithreaded Process:
┌─────────────┐           ┌─────────────┐
│    Code     │           │    Code     │ (Shared)
├─────────────┤           ├─────────────┤
│    Data     │           │    Data     │ (Shared)
├─────────────┤           ├─────────────┤
│   Files     │           │   Files     │ (Shared)
├─────────────┤           ├─────────────┤───┬───┬───┐
│   Stack     │           │Stack│Stack│Stack │   │   │
├─────────────┤           ├─────┼─────┼───── ┤   │   │
│  Registers  │           │Reg  │Reg  │ Reg  │   │   │
├─────────────┤           ├─────┼─────┼───── ┤   │   │
│     PC      │           │ PC  │ PC  │ PC   │   │   │
└─────────────┘           └─────┴─────┴───── ┘   │   │
                          Thread1 Thread2 Thread3
```

**Why Threads?**

1. **Responsiveness**: One thread blocked, others continue
2. **Resource Sharing**: Threads share memory, easier communication
3. **Economy**: Cheaper to create than processes
4. **Scalability**: Can utilize multiple processors

**Example Use Cases:**

- Web server handling multiple requests
- Word processor (typing, spell-check, printing simultaneously)
- Video player (decode, render, audio separate threads)

### Benefits of Multithreading

**1. Responsiveness**

- Interactive applications remain responsive
- One thread blocked doesn't block others
- Example: Browser continues rendering while downloading

**2. Resource Sharing**

- Threads share memory and resources
- No need for IPC mechanisms
- Easier data sharing

**3. Economy**

- Thread creation faster than process creation
- Context switching between threads cheaper
- Less overhead

**4. Scalability**

- Process can utilize multiple CPU cores
- Parallel execution
- Better performance on multicore systems

**Real-World Example - Web Server:**

```
Single-threaded Server:
Request 1 → Process → Response 1
                      Request 2 → Process → Response 2
                                            Request 3 → ...
(Sequential, slow)

Multi-threaded Server:
Request 1 → Thread 1 → Response 1
Request 2 → Thread 2 → Response 2  } Concurrent
Request 3 → Thread 3 → Response 3
(Parallel, fast)
```

### User-Level Threads

**Definition**: Threads managed by user-level thread library

**Characteristics:**

- Managed by thread library (POSIX Pthreads, Windows threads)
- Kernel unaware of threads
- Thread table maintained in user space
- Fast creation and management

**Advantages:**

- Fast thread creation/destruction
- Fast context switching (no kernel involvement)
- Portable across OS
- Can run on any OS

**Disadvantages:**

- One thread blocks → entire process blocks
- Cannot utilize multiple CPUs
- No true parallelism
- Kernel schedules process, not threads

**Thread Operations:**

```
User Space:
┌──────────────────────────┐
│  Thread Library          │
│  ┌───┐ ┌───┐ ┌───┐      │
│  │ T1│ │ T2│ │ T3│      │
│  └───┘ └───┘ └───┘      │
└──────────────────────────┘
────────────────────────────  ← No kernel involvement
Kernel Space:
┌──────────────────────────┐
│  Sees single process     │
└──────────────────────────┘
```

### Kernel-Level Threads

**Definition**: Threads managed directly by OS kernel

**Characteristics:**

- Kernel maintains thread table
- Kernel schedules threads
- Kernel aware of all threads

**Advantages:**

- One thread blocks → others can continue
- True parallelism on multiprocessors
- Kernel can schedule threads on different CPUs
- Better for CPU-intensive tasks

**Disadvantages:**

- Slower than user-level threads
- Thread operations require system calls
- Higher overhead
- Mode switching required

**Thread Operations:**

```
User Space:
┌──────────────────────────┐
│  Application             │
│  Uses thread API         │
└──────────────────────────┘
────────────────────────────  ← System calls
Kernel Space:
┌──────────────────────────┐
│  Kernel Thread Manager   │
│  ┌───┐ ┌───┐ ┌───┐      │
│  │KT1│ │KT2│ │KT3│      │
│  └───┘ └───┘ └───┘      │
└──────────────────────────┘
```

### Multithreading Models

#### Many-to-One Model

**Concept**: Many user threads mapped to one kernel thread

```
User Level:
┌───┐ ┌───┐ ┌───┐ ┌───┐
│ T1│ │ T2│ │ T3│ │ T4│
└─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘
  └─────┴─────┴─────┘
          │
Kernel Level:  ▼
         ┌─────┐
         │  K1 │
         └─────┘
```

**Characteristics:**

- Thread management in user space
- Entire process blocks if one thread blocks
- No parallel execution
- Fast and efficient

**Disadvantage**: Cannot use multiple processors

**Example**: Green threads (early Java)

---

#### One-to-One Model

**Concept**: Each user thread mapped to separate kernel thread

```
User Level:
┌───┐ ┌───┐ ┌───┐
│ T1│ │ T2│ │ T3│
└─┬─┘ └─┬─┘ └─┬─┘
  │     │     │
Kernel Level:
  ▼     ▼     ▼
┌───┐ ┌───┐ ┌───┐
│K1 │ │K2 │ │K3 │
└───┘ └───┘ └───┘
```

**Characteristics:**

- True concurrency
- One thread blocks → others continue
- Can utilize multiple processors
- Parallel execution

**Disadvantage**:

- Overhead of kernel thread creation
- Limited number of threads (system resources)

**Examples**: Windows, Linux, modern Unix

---

#### Many-to-Many Model

**Concept**: Many user threads mapped to smaller/equal number of kernel threads

```
User Level:
┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐
│ T1│ │ T2│ │ T3│ │ T4│ │ T5│
└─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘
  └───┬───┴───┬───┴───┬───┘
      │       │       │
Kernel Level:
      ▼       ▼       ▼
    ┌───┐   ┌───┐   ┌───┐
    │K1 │   │K2 │   │K3 │
    └───┘   └───┘   └───┘
```

**Characteristics:**

- Flexibility: Create many user threads
- OS creates sufficient kernel threads
- Balance between many-to-one and one-to-one
- Good concurrency without excessive overhead

**Advantages:**

- Can create as many user threads as needed
- Corresponding kernel threads run in parallel
- Developer can create thousands of threads

**Examples**: Older Solaris, some Unix variants

---

#### Two-Level Model

**Concept**: Many-to-many + some one-to-one bindings

```
User Level:
┌───┐ ┌───┐ ┌───┐ ┌───┐
│ T1│ │ T2│ │ T3│ │ T4│
└─┬─┘ └┬┬─┘ └─┬─┘ └─┬─┘
  │    ││      │     │
  │    │└──────│─────┘
  │    │       │
Kernel Level:
  ▼    ▼       ▼
┌───┐┌───┐   ┌───┐
│K1 ││K2 │   │K3 │
└───┘└───┘   └───┘
     ↑
  Bound thread
```

**Characteristics:**

- Combines many-to-many with one-to-one
- Some threads bound to specific kernel thread
- Critical threads can have dedicated kernel thread

**Example**: IRIX, HP-UX

---

**Comparison:**

|Model|Concurrency|Parallelism|Overhead|Blocking Effect|
|---|---|---|---|---|
|Many-to-One|Limited|No|Low|Entire process|
|One-to-One|High|Yes|High|Only that thread|
|Many-to-Many|High|Yes|Medium|Managed by system|

---

## 5. CPU Scheduling

### Scheduling Criteria

Performance metrics for evaluating scheduling algorithms:

**1. CPU Utilization**

- Percentage of time CPU is busy
- Goal: Maximize (keep CPU as busy as possible)
- Ideal: 100% (practically 40-90%)

**2. Throughput**

- Number of processes completed per unit time
- Goal: Maximize
- Example: 10 processes/second

**3. Turnaround Time**

- Time from process submission to completion
- Formula: Completion Time - Arrival Time
- Goal: Minimize
- Includes waiting time + execution time

**4. Waiting Time**

- Total time process spends in ready queue
- Formula: Turnaround Time - Burst Time
- Goal: Minimize
- Doesn't include execution or I/O time

**5. Response Time**

- Time from submission until first response
- Formula: Time of First Response - Arrival Time
- Goal: Minimize
- Important for interactive systems

**Example Calculation:**

```
Process | Arrival | Burst | Start | Complete | Turnaround | Waiting | Response
--------|---------|-------|-------|----------|------------|---------|----------
P1      |    0    |   5   |   0   |    5     |     5      |    0    |    0
P2      |    1    |   3   |   5   |    8     |     7      |    4    |    4
P3      |    2    |   4   |   8   |   12     |    10      |    6    |    6

Average Turnaround Time = (5 + 7 + 10) / 3 = 7.33
Average Waiting Time = (0 + 4 + 6) / 3 = 3.33
Average Response Time = (0 + 4 + 6) / 3 = 3.33
```

### Preemptive vs Non-Preemptive Scheduling

#### Non-Preemptive Scheduling

**Definition**: Once CPU is allocated to a process, it keeps CPU until termination or I/O wait

**Characteristics:**

- Process runs to completion
- No interruption by scheduler
- Simpler implementation
- Less overhead

**When Scheduling Occurs:**

1. Process switches from running to waiting (I/O request)
2. Process terminates

**Advantages:**

- Simple to implement
- Lower overhead
- Predictable behavior

**Disadvantages:**

- Poor response time for short processes
- One long process can monopolize CPU
- Not suitable for time-sharing systems

**Examples**: FCFS, SJF (non-preemptive), Priority (non-preemptive)

---

#### Preemptive Scheduling

**Definition**: CPU can be taken away from a process before completion

**Characteristics:**

- Scheduler can interrupt running process
- Context switching overhead
- Better response time
- More complex

**When Scheduling Occurs:**

1. Process switches from running to ready (interrupt, time quantum expires)
2. Process switches from waiting to ready (I/O completion)
3. Process switches from running to waiting
4. Process terminates

**Advantages:**

- Better response time
- Fair CPU sharing
- Suitable for time-sharing
- Prevents CPU monopolization

**Disadvantages:**

- Context switching overhead
- More complex implementation
- Race conditions possible (shared data)
- Requires synchronization

**Examples**: Round Robin, SRTF, Preemptive Priority

---

**Comparison:**

|Aspect|Non-Preemptive|Preemptive|
|---|---|---|
|CPU Release|Voluntary|Forced|
|Context Switch|Less frequent|More frequent|
|Overhead|Lower|Higher|
|Response Time|Worse|Better|
|Implementation|Simpler|Complex|
|Use Case|Batch systems|Interactive systems|

### Scheduling Algorithms

#### 1. FCFS (First-Come, First-Served)

**Also Called**: FIFO (First In, First Out)

**Concept**: Process that arrives first gets CPU first

**Characteristics:**

- Non-preemptive
- Simple queue implementation
- Like standing in line

**Algorithm:**

1. Process enters ready queue
2. CPU allocated in arrival order
3. Process runs until completion or I/O
4. Next process gets CPU

**Example:**

```
Process | Arrival Time | Burst Time
--------|--------------|------------
P1      |      0       |     24
P2      |      1       |      3
P3      |      2       |      3

Gantt Chart:
|    P1    |P2 |P3 |
0         24  27  30

Waiting Time:
P1 = 0 - 0 = 0
P2 = 24 - 1 = 23
P3 = 27 - 2 = 25
Average = (0 + 23 + 25) / 3 = 16
```

**Advantages:**

- Simple to understand and implement
- No starvation
- Fair in order of arrival

**Disadvantages:**

- **Convoy Effect**: Short processes wait for long process
- Poor average waiting time
- Not suitable for time-sharing
- No priority consideration

**Convoy Effect Example:**

```
One long process (10s) arrives first
10 short processes (1s each) arrive next
Total waiting = 10 + 11 + 12 + ... + 19 = 145s
Average = 145/11 = 13.18s
```

---

#### 2. SJF (Shortest Job First)

**Also Called**: SPN (Shortest Process Next)

**Concept**: Process with smallest burst time gets CPU first

**Types:**

**A. Non-Preemptive SJF**

- Choose shortest job when CPU becomes free
- Once started, runs to completion

**Example:**

```
Process | Arrival Time | Burst Time
--------|--------------|------------
P1      |      0       |      6
P2      |      1       |      8
P3      |      2       |      7
P4      |      3       |      3

Gantt Chart:
|  P1  |P4 | P3  | P2  |
0      6   9    16    24

Waiting Time:
P1 = 0 - 0 = 0
P4 = 6 - 3 = 3
P3 = 9 - 2 = 7
P2 = 16 - 1 = 15
Average = (0 + 3 + 7 + 15) / 4 = 6.25
```

**B. Preemptive SJF (SRTF - Shortest Remaining Time First)**

- New process can preempt if shorter burst time
- Choose process with shortest remaining time

**Example:**

```
Process | Arrival Time | Burst Time
--------|--------------|------------
P1      |      0       |      8
P2      |      1       |      4
P3      |      2       |      9
P4      |      3       |      5

Gantt Chart:
|P1|  P2  |P4 | P1  |  P3   |
0  1      5   10    17      26

Execution Flow:
- t=0: P1 starts (remaining=8)
- t=1: P2 arrives (burst=4 < P1's remaining=7), P2 preempts
- t=5: P2 done, P4 shortest (burst=5)
- t=10: P4 done, P1 resumes
- t=17: P1 done, P3 runs
```

**Advantages:**

- **Optimal** - minimizes average waiting time
- Good throughput
- Short jobs prioritized

**Disadvantages:**

- **Starvation**: Long processes may never execute
- Impossible to know next CPU burst accurately
- Must estimate burst time
- Overhead of preemption (SRTF)

**Burst Time Prediction:**

Use exponential averaging:

```
τ(n+1) = α × t(n) + (1-α) × τ(n)

Where:
τ(n+1) = predicted next burst
t(n) = actual last burst
τ(n) = predicted last burst
α = weight (0 ≤ α ≤ 1)
```

---

#### 3. Priority Scheduling

**Concept**: Each process assigned a priority, highest priority gets CPU

**Priority Assignment:**

- Internal: Time limits, memory requirements, I/O usage
- External: Importance, payment, department

**Convention**: Lower number = Higher priority (usually)

**Types:**

**A. Non-Preemptive Priority**

```
Process | Arrival | Burst | Priority
--------|---------|-------|----------
P1      |    0    |  10   |    3
P2      |    1    |   1   |    1 (highest)
P3      |    2    |   2   |    4
P4      |    3    |   1   |    5
P5      |    4    |   5   |    2

Gantt Chart:
|  P1   |P2|P5  |P3 |P4|
0      10 11    16  18 19

Execution: P1 starts first, runs to completion (non-preemptive)
Then P2 (highest priority), P5, P3, P4
```

**B. Preemptive Priority**

```
Same processes as above:

Gantt Chart:
|P1|P2|P5  |P1  |P3 |P4|
0  1  2     7   16  18 19

Execution:
- P1 starts at t=0
- t=1: P2 arrives (priority 1 > P1's priority 3), preempts
- t=2: P2 done, P5 highest priority
- t=7: P5 done, P1 resumes
```

**Advantages:**

- Flexible
- Important processes get CPU first
- Can reflect real-world priorities

**Disadvantages:**

- **Starvation**: Low-priority processes may never execute
- Requires priority assignment
- Can be unfair

**Solution to Starvation: Aging**

- Gradually increase priority of waiting processes
- Ensures eventual execution
- Example: Increase priority by 1 every 10 minutes

```c
// Aging implementation
if (process->waiting_time > threshold) {
    process->priority = max(process->priority - 1, min_priority);
}
```

---

#### 4. Round Robin (RR)

**Concept**: Each process gets small time quantum in circular order

**Characteristics:**

- Preemptive
- Time quantum (time slice): typically 10-100ms
- Ready queue as circular queue
- Designed for time-sharing systems

**Algorithm:**

1. Each process gets time quantum
2. If process finishes, remove from queue
3. If time quantum expires, preempt and move to end of queue
4. CPU goes to next process in queue

**Example:**

```
Process | Burst Time | Time Quantum = 4
--------|------------
P1      |     24     |
P2      |      3     |
P3      |      3     |

Gantt Chart:
|P1|P2|P3|P1|P1|P1|P1|P1|P1|
0  4  7 10 14 18 22 26 30

Round 1: P1(4) → P2(3 done) → P3(3 done) → P1(4)
Round 2: P1(4) → P1(4) → P1(4) → P1(4) → P1(4 done)

Waiting Time:
P1 = (0 + 6 + 4×5) - 0 = 26 - 0 = 6
P2 = 4 - 0 = 4
P3 = 7 - 0 = 7
Average = (6 + 4 + 7) / 3 = 5.67
```

**Time Quantum Selection:**

**Too Large:**

- Behaves like FCFS
- Poor response time
- Example: Q=100ms, burst=5ms → like FCFS

**Too Small:**

- Excessive context switching
- High overhead
- Example: Q=1ms, context switch=0.1ms → 10% overhead

**Optimal:**

- 80% of CPU bursts should be shorter than quantum
- Typical: 10-100ms
- Context switch time should be < 10% of quantum

**Performance:**

```
Average Turnaround Time vs Time Quantum:

Turnaround
    │        ╱─────
    │      ╱
    │    ╱
    │  ╱
    │╱_____________ Quantum
```

**Advantages:**

- Fair CPU allocation
- Good response time
- No starvation
- Ideal for time-sharing

**Disadvantages:**

- Higher average waiting time than SJF
- Context switching overhead
- Performance depends on quantum size

---

#### 5. Multilevel Queue Scheduling

**Concept**: Multiple separate queues with different priorities

**Queue Categories:**

1. **System Processes** (highest priority)
2. **Interactive Processes**
3. **Batch Processes** (lowest priority)

**Structure:**

```
┌─────────────────────────────┐
│  System Processes Queue     │ Priority 0
│  (FCFS)                     │
├─────────────────────────────┤
│  Interactive Processes      │ Priority 1
│  (Round Robin, Q=10)        │
├─────────────────────────────┤
│  Batch Processes            │ Priority 2
│  (FCFS)                     │
└─────────────────────────────┘
        ↓
       CPU
```

**Scheduling Between Queues:**

**Fixed Priority:**

- Serve higher queue completely first
- Lower queues may starve

**Time Slicing:**

- Each queue gets CPU time percentage
- Example:
    - System: 20%
    - Interactive: 60%
    - Batch: 20%

**Characteristics:**

- Process permanently assigned to queue
- Based on process type
- Each queue can have different algorithm
- No movement between queues

**Example:**

```
Queue 1 (Foreground - RR, Q=8): P1(10), P2(5)
Queue 2 (Background - FCFS): P3(20), P4(15)

Execution (Fixed Priority):
All Queue 1 processes complete first
Then Queue 2 processes

Gantt Chart:
|P1|P2| P1 |P3     |P4    |
0  8 13  15      35       50
```

**Advantages:**

- Low scheduling overhead
- Different scheduling for different process types
- Clear priority separation

**Disadvantages:**

- Inflexible (no queue movement)
- Low-priority queues may starve

---

#### 6. Multilevel Feedback Queue Scheduling

**Concept**: Multiple queues with process movement between queues

**Key Feature**: Process can move between queues based on behavior

**Structure:**

```
┌─────────────────────────────┐
│  Queue 0 (Highest Priority) │
│  RR, Quantum = 8            │ ↓ Demote if uses full quantum
├─────────────────────────────┤
│  Queue 1                    │
│  RR, Quantum = 16           │ ↓ Demote if uses full quantum
├─────────────────────────────┤
│  Queue 2 (Lowest Priority)  │
│  FCFS                       │
└─────────────────────────────┘
```

**Algorithm:**

1. New process enters highest priority queue
2. If uses full quantum → demoted to next lower queue
3. If completes before quantum → finished
4. If I/O wait → promoted to higher queue

**Example:**

```
Process | Burst Time
--------|------------
P1      |     20
P2      |     15
P3      |      5

Execution:
P1: Q0(8) → Q1(12) → finished
P2: Q0(8) → Q1(7) → finished
P3: Q0(5) → finished (didn't use full quantum)

Gantt Chart shows interleaving based on queue priorities
```

**Parameters Define Behavior:**

1. Number of queues
2. Scheduling algorithm for each queue
3. Method to determine queue promotion
4. Method to determine queue demotion
5. Method to determine initial queue

**Adaptive Behavior:**

**CPU-Bound Process:**

- Uses full quantum repeatedly
- Demoted to lower priority
- Gets less frequent CPU time

**I/O-Bound Process:**

- Doesn't use full quantum
- Stays in high priority
- Gets quick response

**Advantages:**

- Most flexible
- Adapts to process behavior
- Good for unknown process characteristics
- Prevents starvation (aging)
- Favors I/O-bound and interactive processes

**Disadvantages:**

- Complex to implement
- Higher overhead
- Many parameters to tune

---

### Dispatcher

**Definition**: Module that gives CPU control to the process selected by scheduler

**Functions:**

1. Context switching
2. Switching to user mode
3. Jumping to proper location in user program

**Dispatch Latency**: Time to stop one process and start another

**Components of Dispatch Latency:**

1. Save context of current process
2. Switch to kernel mode
3. Select next process
4. Load context of new process
5. Switch to user mode
6. Resume new process

```
Dispatch Latency Timeline:

|←─ Dispatch Latency ─→|
├──────┬────────┬───────┤
│ Save │ Select │ Load  │
│Context│ Next  │Context│
│      │Process │       │
└──────┴────────┴───────┘
```

**Typical Dispatch Latency**: 0.1 to 1 millisecond

**Goal**: Minimize dispatch latency

### Context Switching

**Definition**: Saving state of current process and loading state of next process

**What is Saved/Restored:**

- Program Counter (PC)
- CPU Registers
- Process State
- Memory Management Info
- Accounting Info
- I/O Status

**Context Switch Steps:**

```
Process P0 Running
        ↓
1. Interrupt/System Call
        ↓
2. Save State of P0 in PCB0
        ↓
3. Reload State of P1 from PCB1
        ↓
Process P1 Running
```

**Detailed Process:**

```c
// Pseudocode for context switch

void context_switch(Process* old, Process* new) {
    // 1. Save old process state
    save_registers(old->pcb);
    old->pcb->pc = program_counter;
    old->pcb->state = READY;
    
    // 2. Update scheduling info
    update_scheduling_info(old);
    
    // 3. Load new process state
    program_counter = new->pcb->pc;
    restore_registers(new->pcb);
    new->pcb->state = RUNNING;
    
    // 4. Update memory management
    switch_page_table(new->pcb->page_table);
    
    // 5. Resume new process
    return_to_user_mode();
}
```

**Cost of Context Switch:**

- Direct: Time to save/restore registers (microseconds)
- Indirect: Cache invalidation, TLB flush, pipeline flush

**Cache Impact:**

```
Before Switch: Cache full of P0's data
After Switch: Cache must be refilled with P1's data
Result: Cache misses increase, performance drops
```

**When Context Switch Occurs:**

1. Time quantum expires (RR)
2. Process makes I/O request
3. Higher priority process arrives
4. Interrupt occurs
5. Process terminates

**Reducing Context Switch Overhead:**

- Use threads (lighter than processes)
- Increase time quantum (fewer switches)
- Hardware support (multiple register sets)
- Better scheduling algorithms

---

## 6. Process Synchronization

### Critical Section Problem

**Definition**: Section of code that accesses shared resources and must not be executed by more than one process simultaneously

**Code Structure:**

```c
do {
    // Entry Section
    // Request permission to enter critical section
    
    /* CRITICAL SECTION */
    // Code that accesses shared resources
    
    // Exit Section
    // Release critical section
    
    /* REMAINDER SECTION */
    // Other code
    
} while (true);
```

**Requirements for Solution:**

**1. Mutual Exclusion**

- Only one process in critical section at a time
- If P1 in CS, no other process can enter
- Mandatory requirement

**2. Progress**

- If no process in CS, selection of next process cannot be postponed indefinitely
- Only processes not in remainder section can decide
- Bounded waiting time

**3. Bounded Waiting**

- Limit on number of times other processes can enter CS after a process requests entry
- Prevents starvation
- Ensures fairness

**4. No Assumptions (optional)**

- No assumptions about speed or number of CPUs
- Solution should work on any hardware

### Race Condition

**Definition**: Situation where multiple processes access shared data concurrently, and outcome depends on execution order

**Example - Bank Account:**

```c
// Shared variable
int balance = 1000;

// Process 1: Deposit $500
temp1 = balance;      // Read: temp1 = 1000
temp1 = temp1 + 500;  // Calculate: temp1 = 1500
balance = temp1;      // Write: balance = 1500

// Process 2: Withdraw $300
temp2 = balance;      // Read: temp2 = 1000
temp2 = temp2 - 300;  // Calculate: temp2 = 700
balance = temp2;      // Write: balance = 700
```

**Race Condition Scenario:**

```
Time | Process 1           | Process 2           | balance
-----|---------------------|---------------------|--------
t1   | temp1 = balance     |                     | 1000
t2   | temp1 = temp1 + 500 |                     | 1000
t3   |                     | temp2 = balance     | 1000
t4   |                     | temp2 = temp2 - 300 | 1000
t5   | balance = temp1     |                     | 1500
t6   |                     | balance = temp2     | 700

Expected: 1000 + 500 - 300 = 1200
Actual: 700 (Lost update!)
```

**Why Race Conditions Occur:**

- Concurrent access to shared data
- No synchronization
- Interleaving of operations
- Non-atomic operations

**Solution**: Use synchronization mechanisms

### Mutex (Mutual Exclusion)

**Definition**: Lock mechanism to ensure only one process can access critical section

**Concept**: Binary lock (locked/unlocked)

**Operations:**

```c
mutex lock;

// Acquire lock
acquire(lock) {
    while (lock == LOCKED)
        ; // Busy wait
    lock = LOCKED;
}

// Release lock
release(lock) {
    lock = UNLOCKED;
}
```

**Usage:**

```c
mutex m;

// Process code
do {
    acquire(m);        // Entry section
    
    /* CRITICAL SECTION */
    
    release(m);        // Exit section
    
    /* REMAINDER SECTION */
    
} while (true);
```

**Implementation with Test-and-Set:**

```c
// Hardware instruction (atomic)
bool test_and_set(bool *target) {
    bool rv = *target;
    *target = true;
    return rv;
}

// Mutex implementation
void acquire(bool *lock) {
    while (test_and_set(lock))
        ; // Busy wait
}

void release(bool *lock) {
    *lock = false;
}
```

**Types:**

**1. Spinlock (Busy Waiting)**

- Process keeps checking lock
- Wastes CPU cycles
- Good for short critical sections
- Used in multiprocessor systems

**2. Blocking Mutex**

- Process sleeps when lock unavailable
- No CPU waste
- Context switch overhead
- Better for long critical sections

**Advantages:**

- Simple to understand
- Guarantees mutual exclusion
- Works with any number of processes

**Disadvantages:**

- Busy waiting wastes CPU
- No fairness guarantee
- Priority inversion possible

### Semaphore

**Definition**: Integer variable accessed only through atomic operations

**Operations:**

**wait() / P() / down()** - Decrement and wait if needed

```c
wait(S) {
    while (S <= 0)
        ; // Busy wait
    S--;
}
```

**signal() / V() / up()** - Increment

```c
signal(S) {
    S++;
}
```

**Usage:**

```c
semaphore S = 1;

// Process code
wait(S);           // Entry

/* CRITICAL SECTION */

signal(S);         // Exit

/* REMAINDER SECTION */
```

**Implementation Without Busy Waiting:**

```c
typedef struct {
    int value;
    struct process *list;  // Waiting queue
} semaphore;

void wait(semaphore *S) {
    S->value--;
    if (S->value < 0) {
        add_process_to_list(S->list);
        block();  // Put process to sleep
    }
}

void signal(semaphore *S) {
    S->value++;
    if (S->value <= 0) {
        remove_process_from_list(S->list);
        wakeup(P);  // Wake up a waiting process
    }
}
```

### Binary vs Counting Semaphore

#### Binary Semaphore

**Definition**: Semaphore with value 0 or 1

**Also Called**: Mutex lock

**Usage:**

```c
semaphore S = 1;  // Initially unlocked

// Process 1
wait(S);         // S = 0 (locked)
/* CRITICAL SECTION */
signal(S);       // S = 1 (unlocked)

// Process 2
wait(S);         // Must wait if S = 0
/* CRITICAL SECTION */
signal(S);
```

**Purpose**: Mutual exclusion

---

#### Counting Semaphore

**Definition**: Semaphore with value ranging over unrestricted domain

**Value Meaning:**

- Value > 0: Number of available resources
- Value = 0: No resources available
- Value < 0: Absolute value = number of waiting processes

**Usage Example - Resource Pool:**

```c
semaphore S = 5;  // 5 resources available

// Process requests resource
wait(S);          // S = 4 (one resource taken)
/* USE RESOURCE */
signal(S);        // S = 5 (resource returned)

// If 5 processes take resources:
// S = 0, next wait() will block
```

**Real-World Example - Database Connections:**

```c
semaphore db_connections = 10;  // 10 connections available

void access_database() {
    wait(db_connections);       // Get connection
    
    // Use database connection
    execute_query();
    
    signal(db_connections);     // Release connection
}

// Allows max 10 concurrent database accesses
```

---

**Comparison:**

|Aspect|Binary Semaphore|Counting Semaphore|
|---|---|---|
|Value Range|0 or 1|Any integer|
|Purpose|Mutual exclusion|Resource counting|
|Example|Lock/Unlock|Connection pool|
|Initial Value|Usually 1|Number of resources|

### Classical Synchronization Problems

#### 1. Producer-Consumer Problem

**Also Called**: Bounded Buffer Problem

**Scenario**: Producers create data, consumers use data, shared buffer between them

**Problem:**

- Producer shouldn't add when buffer full
- Consumer shouldn't remove when buffer empty
- Mutual exclusion on buffer access

**Solution:**

```c
#define BUFFER_SIZE 10

semaphore mutex = 1;           // Binary: Buffer access
semaphore empty = BUFFER_SIZE; // Counting: Empty slots
semaphore full = 0;            // Counting: Full slots

int buffer[BUFFER_SIZE];
int in = 0, out = 0;

// Producer
void producer() {
    int item;
    
    while (true) {
        item = produce_item();
        
        wait(empty);           // Wait for empty slot
        wait(mutex);           // Lock buffer
        
        buffer[in] = item;     // Add item
        in = (in + 1) % BUFFER_SIZE;
        
        signal(mutex);         // Unlock buffer
        signal(full);          // Signal full slot
    }
}

// Consumer
void consumer() {
    int item;
    
    while (true) {
        wait(full);            // Wait for full slot
        wait(mutex);           // Lock buffer
        
        item = buffer[out];    // Remove item
        out = (out + 1) % BUFFER_SIZE;
        
        signal(mutex);         // Unlock buffer
        signal(empty);         // Signal empty slot
        
        consume_item(item);
    }
}
```

**Key Points:**

- `mutex`: Ensures mutual exclusion
- `empty`: Counts empty buffer slots
- `full`: Counts full buffer slots
- Order of waits matters!

**Wrong Order Example:**

```c
// DEADLOCK POSSIBLE!
wait(mutex);   // Lock first
wait(empty);   // Then wait - BAD!
// If buffer full, holds lock while waiting
```

---

#### 2. Readers-Writers Problem

**Scenario**: Multiple readers and writers accessing shared database

**Constraints:**

- Multiple readers can read simultaneously
- Only one writer at a time
- No reader when writer is writing
- No writer when any reader is reading

**Types:**

**First Readers-Writers Problem**: Readers preference **Second Readers-Writers Problem**: Writers preference

**Solution (First Readers-Writers):**

```c
semaphore mutex = 1;        // Protects read_count
semaphore wrt = 1;          // Writer access
int read_count = 0;         // Number of readers

// Writer
void writer() {
    while (true) {
        wait(wrt);              // Request write access
        
        /* WRITING */
        
        signal(wrt);            // Release write access
    }
}

// Reader
void reader() {
    while (true) {
        wait(mutex);            // Lock read_count
        read_count++;
        if (read_count == 1)    // First reader
            wait(wrt);          // Block writers
        signal(mutex);          // Unlock read_count
        
        /* READING */
        
        wait(mutex);            // Lock read_count
        read_count--;
        if (read_count == 0)    // Last reader
            signal(wrt);        // Allow writers
        signal(mutex);          // Unlock read_count
    }
}
```

**Explanation:**

- First reader blocks writers
- Last reader unblocks writers
- Readers don't block each other
- Writers wait for all readers to finish

**Problem with First R-W**: Writers may starve

**Solution (Second Readers-Writers):**

```c
semaphore mutex1 = 1, mutex2 = 1, mutex3 = 1;
semaphore wrt = 1, read = 1;
int read_count = 0, write_count = 0;

// Writer (with priority)
void writer() {
    while (true) {
        wait(mutex2);
        write_count++;
        if (write_count == 1)
            wait(read);         // Block new readers
        signal(mutex2);
        
        wait(wrt);              // Wait for writing
        
        /* WRITING */
        
        signal(wrt);
        
        wait(mutex2);
        write_count--;
        if (write_count == 0)
            signal(read);       // Allow readers
        signal(mutex2);
    }
}
```

---

#### 3. Dining Philosophers Problem

**Scenario**: 5 philosophers sit at round table with 5 chopsticks

**Rules:**

- Each philosopher needs 2 chopsticks to eat
- Philosophers alternate between thinking and eating
- Chopsticks shared between neighbors

```
      P0
     /  \
   C0    C1
   |      |
  P4      P1
   |      |
   C4    C2
     \  /
      P3----C3----P2
```

**Problem**: Potential deadlock if all philosophers pick up left chopstick simultaneously

**Solution 1: Asymmetric**

```c
semaphore chopstick[5] = {1, 1, 1, 1, 1};

void philosopher(int i) {
    while (true) {
        think();
        
        if (i %
```