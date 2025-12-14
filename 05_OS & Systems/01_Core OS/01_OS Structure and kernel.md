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


---

## Table of Contents

1. [[#1. Operating System Basics]]
2. [[#2. OS Structure & Design]]
3. [[#3. Process Management]]
4. [[#4. Threads]]
5. [[#5. CPU Scheduling]]
6. [[#6. Process Synchronization]]
7. [[#7. Deadlocks]]
8. [[#8. Memory Management]]
9. [[#9. Paging]]
10. [[#10. Segmentation]]
11. [[#11. Virtual Memory]]
12. [[#12. File System]]
13. [[#13. Disk Scheduling]]
14. [[#14. I/O Management]]
15. [[#15. Protection and Security]]

---

## 1. Operating System Basics

### Definition of Operating System

An **Operating System** is a software program that acts as an intermediary between computer hardware and users. It manages hardware resources and provides services for application programs.

**Key Points:**

- Interface between user and hardware
- Resource manager and coordinator
- Enables program execution
- Provides user-friendly environment

### Functions of OS

1. **Process Management**: Creation, scheduling, termination
2. **Memory Management**: Allocation, deallocation, virtual memory
3. **File Management**: File creation, deletion, access control
4. **Device Management**: I/O operations, device drivers
5. **Security & Protection**: Authentication, authorization, access control
6. **Command Interpretation**: User interface (CLI/GUI)
7. **Error Detection**: Monitoring and handling errors
8. **Resource Allocation**: CPU, memory, I/O devices

### OS as Resource Manager

OS manages four main resources:

**1. CPU Management**

- Process scheduling
- Context switching
- CPU utilization optimization

**2. Memory Management**

- RAM allocation
- Virtual memory
- Memory protection

**3. I/O Device Management**

- Device allocation
- Buffering and caching
- Driver management

**4. Storage Management**

- File system organization
- Disk space allocation
- Access control

### Types of Operating Systems

#### Batch Operating System

**Characteristics:**

- Jobs collected in batches
- No direct user interaction
- Sequential execution
- CPU idle time reduced

**Advantages:**

- Efficient CPU utilization
- Can handle large workloads
- Shared computer resources

**Disadvantages:**

- No user interaction
- Difficult to debug
- Jobs can get stuck waiting

**Examples**: IBM mainframe systems, payroll systems

---

#### Multiprogramming OS

**Concept**: Multiple programs loaded in memory simultaneously

**How it Works:**

1. Multiple jobs kept in memory
2. OS picks one job and executes
3. When job waits (I/O), OS switches to another job
4. CPU never idle

**Key Features:**

- Increased CPU utilization
- Reduced response time
- Memory partitioning required

**Example**: Early Unix systems

---

#### Multitasking OS (Time-Sharing)

**Concept**: CPU switches between tasks so quickly that users can interact with each program

**Key Features:**

- Time quantum/time slice allocated
- Rapid context switching
- Multiple users can work simultaneously
- Interactive environment

**Difference from Multiprogramming:**

- Multiprogramming: Maximize CPU utilization
- Multitasking: Minimize response time

**Examples**: Windows, Linux, macOS

---

#### Multiprocessing OS

**Concept**: Multiple CPUs/processors in single computer system

**Types:**

**1. Symmetric Multiprocessing (SMP)**

- All processors equal
- Share same memory
- Example: Modern Windows/Linux

**2. Asymmetric Multiprocessing (AMP)**

- Master-slave relationship
- Master assigns tasks to slaves

**Advantages:**

- Increased throughput
- Economy of scale
- Increased reliability (fault tolerance)

**Examples**: Windows Server, Linux with SMP support

---

#### Distributed OS

**Concept**: Multiple independent computers appear as single system

**Characteristics:**

- Connected via network
- Resource sharing
- Computation speedup
- Transparency to users

**Types:**

- Client-Server systems
- Peer-to-Peer systems
- N-tier architectures

**Examples**: Google's infrastructure, Apache Hadoop

---

#### Real-Time OS (RTOS)

**Concept**: OS with time constraints - must respond within guaranteed time

**Types:**

**1. Hard Real-Time**

- Strict deadlines
- Missing deadline = system failure
- Examples: Airbag systems, pacemakers, flight control

**2. Soft Real-Time**

- Deadlines preferred but not critical
- Degraded performance acceptable
- Examples: Video streaming, online gaming

**Characteristics:**

- Deterministic behavior
- Minimal latency
- Priority-based scheduling
- Preemptive kernel

**Examples**: VxWorks, FreeRTOS, QNX

---

## 2. OS Structure & Design

### OS Services

Operating systems provide various services to users and programs:

**1. User Interface Services**

- CLI (Command Line Interface)
- GUI (Graphical User Interface)
- Batch interface

**2. Program Execution**

- Load programs into memory
- Run programs
- Terminate execution

**3. I/O Operations**

- File I/O
- Device I/O
- Buffering and caching

**4. File System Manipulation**

- Create, delete files/directories
- Search, list files
- Permission management

**5. Communications**

- Inter-process communication (IPC)
- Network communication
- Shared memory, message passing

**6. Error Detection**

- Hardware errors (CPU, memory, I/O)
- Software errors (divide by zero, invalid memory access)
- Logging and debugging

**7. Resource Allocation**

- CPU scheduling
- Memory allocation
- I/O device allocation

**8. Protection and Security**

- Access control
- User authentication
- Defend against external threats

### System Calls

**Definition**: Interface between user programs and OS kernel

**Purpose:**

- Request OS services
- Controlled access to hardware
- Mode switching (user → kernel mode)

**Types of System Calls:**

**1. Process Control**

- `fork()` - Create process
- `exit()` - Terminate process
- `wait()` - Wait for process
- `exec()` - Execute program
- `kill()` - Send signal

**2. File Management**

- `open()` - Open file
- `read()` - Read from file
- `write()` - Write to file
- `close()` - Close file
- `lseek()` - Reposition file pointer

**3. Device Management**

- `ioctl()` - Device control
- `read()` - Read from device
- `write()` - Write to device

**4. Information Maintenance**

- `getpid()` - Get process ID
- `time()` - Get system time
- `sleep()` - Suspend execution

**5. Communication**

- `pipe()` - Create pipe
- `socket()` - Create socket
- `send()`, `recv()` - Network communication

**System Call Mechanism:**

```
User Program
    ↓ (system call)
Trap to Kernel Mode
    ↓
System Call Handler
    ↓
Execute Kernel Code
    ↓
Return to User Mode
    ↓
Continue User Program
```

### OS Structures

#### Monolithic Kernel

**Architecture:**

- All OS services in single large kernel
- Everything runs in kernel mode
- Tightly integrated

**Advantages:**

- Fast performance (no mode switching overhead)
- Direct access to hardware
- Efficient communication between modules

**Disadvantages:**

- Large kernel size
- Difficult to maintain
- Single point of failure
- Hard to debug

**Examples**: Traditional Unix, Linux (technically modular monolithic)

---

#### Layered Architecture

**Concept**: OS divided into layers, each built on lower layer

**Structure:**

```
Layer N: User Applications
Layer N-1: User Interface
...
Layer 2: I/O Management
Layer 1: Process & Memory Management
Layer 0: Hardware
```

**Advantages:**

- Modularity
- Easy debugging (bottom-up)
- Easy to update individual layers

**Disadvantages:**

- Performance overhead (multiple layer traversal)
- Difficult to define layers properly

**Example**: THE operating system

---

#### Microkernel

**Concept**: Minimal kernel with only essential services

**Kernel Contains Only:**

- Basic IPC (Inter-Process Communication)
- Basic memory management
- Low-level process management
- Basic I/O

**User Space Contains:**

- File system
- Device drivers
- Network stack
- Higher-level services

**Advantages:**

- Easy to extend
- More reliable (less code in kernel)
- More secure
- Portable

**Disadvantages:**

- Performance overhead (frequent mode switching)
- Complex IPC mechanisms

**Examples**: Minix, QNX, L4

---

#### Modular Kernel

**Concept**: Core kernel with dynamically loadable modules

**Characteristics:**

- Core kernel minimal
- Modules loaded on demand
- Modules run in kernel mode
- Best of monolithic and microkernel

**Advantages:**

- Flexible (load/unload modules)
- Good performance (kernel mode execution)
- Easier maintenance than monolithic

**Disadvantages:**

- Module bugs can crash kernel
- Security concerns with third-party modules

**Examples**: Modern Linux, Windows (hybrid)

---

### User Mode vs Kernel Mode

**Purpose**: Protection mechanism to prevent user programs from damaging OS

#### User Mode (Unprivileged Mode)

**Characteristics:**

- Limited access to hardware
- Cannot execute privileged instructions
- Cannot access kernel memory
- Most application code runs here

**Restrictions:**

- No direct hardware access
- No memory management operations
- No interrupt handling
- Must use system calls for OS services

---

#### Kernel Mode (Privileged Mode)

**Characteristics:**

- Full hardware access
- Can execute all instructions
- Access to all memory
- OS kernel runs here

**Capabilities:**

- Modify system registers
- Access I/O devices
- Handle interrupts
- Manage memory protection

---

**Mode Switching:**

```
User Mode Program
    ↓
System Call / Interrupt / Exception
    ↓
Switch to Kernel Mode
    ↓
Execute Kernel Code
    ↓
Switch back to User Mode
    ↓
Resume User Program
```

**Why Two Modes?**

1. **Protection**: Prevent user programs from crashing OS
2. **Security**: Isolate user programs from each other
3. **Stability**: Bugs in user programs don't affect kernel
4. **Resource Management**: Controlled access to resources

---
Below are **clean, core-CSE interview-ready notes** on **Types of File Systems**, structured so you can directly place this inside  
`05_OS & Systems / 09_File_Systems`.

No emojis, clear categorization.

---

# **Types of File Systems (OS – Core CSE)**

A **file system** defines how data is stored, organized, accessed, and managed on storage devices.

---

## **1. Disk File Systems**

Used on physical storage devices like hard disks and SSDs.

### **Types:**

- **FAT (File Allocation Table)**
    
    - FAT16, FAT32
        
- **NTFS**
    
- **ext2 / ext3 / ext4**
    
- **XFS**
    
- **Btrfs**
    
- **HFS+ / APFS**
    

**Key Characteristics:**

- Persistent storage
    
- Directory-based structure
    
- Supports permissions, metadata, and indexing
    

---

## **2. Network File Systems**

Allow files to be accessed over a network as if they were local.

### **Types:**

- **NFS (Network File System)**
    
- **SMB / CIFS**
    
- **AFS**
    
- **DFS**
    

**Key Characteristics:**

- Client–server model
    
- Centralized storage
    
- Used in distributed systems
    

---

## **3. Distributed File Systems**

Files are distributed across multiple machines for scalability and fault tolerance.

### **Types:**

- **HDFS (Hadoop Distributed File System)**
    
- **Ceph**
    
- **GlusterFS**
    
- **GFS (Google File System)**
    

**Key Characteristics:**

- High availability
    
- Replication
    
- Used in big data and cloud systems
    

---

## **4. Virtual File Systems (VFS)**

An abstraction layer that provides a common interface to different file systems.

### **Examples:**

- **Linux VFS**
    
- **procfs (/proc)**
    
- **sysfs (/sys)**
    

**Key Characteristics:**

- Not real storage
    
- Kernel-level abstraction
    
- Allows multiple FS types to coexist
    

---

## **5. Journaling File Systems**

Maintain a log (journal) of changes to ensure consistency after crashes.

### **Types:**

- **ext3**
    
- **ext4**
    
- **NTFS**
    
- **XFS**
    

**Key Characteristics:**

- Faster recovery
    
- Crash consistency
    
- Reduced corruption
    

---

## **6. Flash File Systems**

Optimized for flash memory like SSDs and embedded devices.

### **Types:**

- **JFFS2**
    
- **YAFFS**
    
- **F2FS**
    

**Key Characteristics:**

- Wear leveling
    
- Low write amplification
    
- Used in embedded systems
    

---

## **7. Read-Only File Systems**

Designed for read-only access.

### **Types:**

- **ISO 9660**
    
- **SquashFS**
    

**Key Characteristics:**

- No modification allowed
    
- Used in boot media and live CDs
    

---

## **8. Memory-Based File Systems**

Files are stored in RAM instead of disk.

### **Types:**

- **tmpfs**
    
- **ramfs**
    

**Key Characteristics:**

- Very fast
    
- Volatile (data lost on reboot)
    
- Used for temporary storage
    

---

## **9. Object-Based File Systems**

Store data as objects instead of blocks.

### **Examples:**

- **Ceph Object Store**
    
- **Amazon S3 (conceptually)**
    

**Key Characteristics:**

- Scalability
    
- Metadata-rich
    
- Used in cloud storage
    

---

# **Interview-Oriented Classification (Very Important)**

```
File Systems
│
├── Disk File Systems
├── Network File Systems
├── Distributed File Systems
├── Journaling File Systems
├── Virtual File Systems
├── Flash File Systems
├── Memory File Systems
├── Read-Only File Systems
└── Object-Based File Systems
```

---

# **Most Asked in Interviews**

Focus especially on:

- FAT vs NTFS vs ext4
    
- Journaling file systems
    
- Distributed file systems (HDFS)
    
- Virtual file system (VFS)
    
- inode-based systems (Linux)
    

---
