---
title:
  "{ Title }":
tags:
  - ML
  - DA
created:
  "{ date }":
updated:
  "{ date }":
---
## Table of Contents

1. [What is Hadoop?](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#what-is-hadoop)
2. [HDFS (Hadoop Distributed File System)](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#hdfs)
3. [MapReduce](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#mapreduce)
4. [YARN (Yet Another Resource Negotiator)](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#yarn)
5. [Complete Workflow Example](https://claude.ai/chat/a9f210c4-2570-4485-90f1-6755fa8f7fa6#complete-workflow)

---

## What is Hadoop?

**Hadoop** is an open-source framework for distributed storage and processing of massive datasets across clusters of computers.

### Core Components:

```
                    HADOOP ECOSYSTEM
        ┌─────────────────────────────────────┐
        │                                     │
        │  ┌─────────────────────────────┐   │
        │  │    HDFS                     │   │  ← Storage Layer
        │  │  (Distributed File System)  │   │
        │  └─────────────────────────────┘   │
        │                                     │
        │  ┌─────────────────────────────┐   │
        │  │    YARN                     │   │  ← Resource Management
        │  │  (Resource Manager)         │   │
        │  └─────────────────────────────┘   │
        │                                     │
        │  ┌─────────────────────────────┐   │
        │  │    MapReduce                │   │  ← Processing Framework
        │  │  (Programming Model)        │   │
        │  └─────────────────────────────┘   │
        │                                     │
        └─────────────────────────────────────┘
```

### Key Principles:

1. **Distributed Storage** - Data spread across many machines
2. **Distributed Processing** - Computation moves to data (not vice versa)
3. **Fault Tolerance** - Automatic recovery from failures
4. **Scalability** - Add more machines to handle more data

---

## HDFS (Hadoop Distributed File System)

### What is HDFS?

A **distributed file system** designed to store massive files across multiple machines reliably.

### Architecture:

```
                    HDFS ARCHITECTURE
                           
        ┌──────────────────────────────────────────┐
        │         NAMENODE (Master)                │
        │  • Manages file system metadata          │
        │  • Tracks where blocks are stored        │
        │  • Coordinates file operations           │
        │  • Single point of coordination          │
        └──────────────────────────────────────────┘
                      |
        ──────────────┼──────────────┬──────────────
                      |              |              
        ┌─────────────▼───┐  ┌───────▼──────┐  ┌──────▼──────┐
        │  DATANODE 1     │  │  DATANODE 2  │  │ DATANODE 3  │
        │  (Worker)       │  │  (Worker)    │  │ (Worker)    │
        │                 │  │              │  │             │
        │  Block A-1      │  │  Block A-2   │  │ Block A-3   │
        │  Block B-1      │  │  Block C-1   │  │ Block B-2   │
        │  Block C-2      │  │  Block B-3   │  │ Block C-3   │
        └─────────────────┘  └──────────────┘  └─────────────┘
```

### How HDFS Works:

#### 1. File Storage (Writing):

```
ORIGINAL FILE: largefile.txt (300 MB)
                    |
                    v
        ┌───────────────────────┐
        │  STEP 1: Split File   │
        │  into Blocks          │
        │  (Default: 128 MB)    │
        └───────────────────────┘
                    |
        ┌───────────┴───────────┬───────────┐
        v                       v           v
    Block 1                 Block 2     Block 3
    (128 MB)               (128 MB)     (44 MB)
        |                       |           |
        v                       v           v
┌───────────────────────────────────────────────────┐
│  STEP 2: Replicate Blocks (Default: 3 copies)    │
└───────────────────────────────────────────────────┘
        |
        v

    Block 1 Replicas:          Block 2 Replicas:
    ┌──────────────┐          ┌──────────────┐
    │ DataNode A   │          │ DataNode B   │
    │ DataNode C   │          │ DataNode A   │
    │ DataNode E   │          │ DataNode D   │
    └──────────────┘          └──────────────┘

                Block 3 Replicas:
                ┌──────────────┐
                │ DataNode C   │
                │ DataNode D   │
                │ DataNode E   │
                └──────────────┘
```

#### 2. File Retrieval (Reading):

```
CLIENT REQUEST: Read largefile.txt
        |
        v
┌────────────────────────────────┐
│ STEP 1: Contact NameNode       │
│ "Where are blocks for file X?" │
└────────────────────────────────┘
        |
        v
┌────────────────────────────────┐
│ NameNode Returns Map:          │
│ Block 1 → [DataNode A, C, E]   │
│ Block 2 → [DataNode B, A, D]   │
│ Block 3 → [DataNode C, D, E]   │
└────────────────────────────────┘
        |
        v
┌────────────────────────────────┐
│ STEP 2: Client Reads Directly  │
│ from DataNodes (parallel)      │
└────────────────────────────────┘
        |
    ┌───┴───┬────────┐
    v       v        v
Block 1  Block 2  Block 3
(from A) (from B) (from C)
    |       |        |
    └───┬───┴───┬────┘
        v       v
    Reassemble File
```

### Key Features:

**Replication (Fault Tolerance):**

```
If DataNode C fails:
Before:                      After:
┌─────────────┐             ┌─────────────┐
│ DataNode A  │             │ DataNode A  │
│ DataNode C  │ ← FAILED    │ DataNode E  │ ← Re-replicated
│ DataNode E  │             │ DataNode F  │ ← Re-replicated
└─────────────┘             └─────────────┘

NameNode detects failure and triggers re-replication
to maintain 3 copies automatically
```

**Rack Awareness:**

```
        Data Center
    ┌──────────────────┐
    │   Rack 1         │   Rack 2
    │  ┌─────┐         │  ┌─────┐
    │  │Node1│         │  │Node4│
    │  │Node2│         │  │Node5│
    │  │Node3│         │  │Node6│
    │  └─────┘         │  └─────┘
    └──────────────────┘

Block Replica Placement Strategy:
• Replica 1: Same node as writer
• Replica 2: Different rack
• Replica 3: Same rack as Replica 2

This protects against both node AND rack failures
```

---

## MapReduce

### What is MapReduce?

A **programming model** for processing large datasets in parallel across distributed clusters.

### Core Concept:

```
        DIVIDE          PROCESS         COMBINE
          ↓                ↓               ↓
    Split Data    →   Map Phase   →   Reduce Phase
```

### The Two Phases:

#### 1. MAP Phase:

**Purpose:** Transform input data into key-value pairs

```
Input:                    Map Function:              Output:
┌──────────┐             ┌────────────┐           ┌──────────────┐
│ "hello"  │────────────→│ Process    │──────────→│ (hello, 1)   │
│ "world"  │             │ each word  │           │ (world, 1)   │
│ "hello"  │             │ emit       │           │ (hello, 1)   │
└──────────┘             │ (word, 1)  │           └──────────────┘
                         └────────────┘
```

#### 2. REDUCE Phase:

**Purpose:** Aggregate values for each key

```
Input:                    Reduce Function:          Output:
┌──────────────┐         ┌────────────┐          ┌──────────────┐
│ (hello, 1)   │         │ Sum values │          │ (hello, 2)   │
│ (hello, 1)   │────────→│ for each   │─────────→│ (world, 1)   │
│ (world, 1)   │         │ key        │          └──────────────┘
└──────────────┘         └────────────┘
```

### Complete MapReduce Workflow:

```
                    MAPREDUCE EXECUTION FLOW

INPUT DATA (in HDFS):
┌───────────────────────────────────────────────────┐
│ File 1: "hello world"                             │
│ File 2: "hello hadoop"                            │
│ File 3: "world hadoop"                            │
└───────────────────────────────────────────────────┘
                        |
        ────────────────┼────────────────┐
        |               |                |
        v               v                v
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   SPLIT 1   │  │   SPLIT 2   │  │   SPLIT 3   │
│ "hello      │  │ "hello      │  │ "world      │
│  world"     │  │  hadoop"    │  │  hadoop"    │
└─────────────┘  └─────────────┘  └─────────────┘
        |               |                |
        v               v                v
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│   MAPPER 1  │  │   MAPPER 2  │  │   MAPPER 3  │
│             │  │             │  │             │
│ (hello,1)   │  │ (hello,1)   │  │ (world,1)   │
│ (world,1)   │  │ (hadoop,1)  │  │ (hadoop,1)  │
└─────────────┘  └─────────────┘  └─────────────┘
        |               |                |
        └───────┬───────┴────────┬───────┘
                v                v
        ┌──────────────┐  ┌──────────────┐
        │   SHUFFLE    │  │   SHUFFLE    │
        │   & SORT     │  │   & SORT     │
        └──────────────┘  └──────────────┘
                |                |
        ┌───────┴────────┬───────┴────────┐
        v                v                v
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  REDUCER 1  │  │  REDUCER 2  │  │  REDUCER 3  │
│             │  │             │  │             │
│ (hadoop,2)  │  │ (hello,2)   │  │ (world,2)   │
└─────────────┘  └─────────────┘  └─────────────┘
        |                |                |
        └────────────────┼────────────────┘
                         v
                 ┌──────────────┐
                 │ FINAL OUTPUT │
                 │ (in HDFS)    │
                 │              │
                 │ hadoop: 2    │
                 │ hello: 2     │
                 │ world: 2     │
                 └──────────────┘
```

### The Shuffle & Sort Phase (Critical!):

```
BEFORE SHUFFLE:                  AFTER SHUFFLE & SORT:
(Output from Mappers)            (Input to Reducers)

Mapper 1:                        Reducer 1 gets:
(hello, 1)                       (hadoop, [1, 1])
(world, 1)                       
                                 Reducer 2 gets:
Mapper 2:                        (hello, [1, 1])
(hello, 1)                       
(hadoop, 1)                      Reducer 3 gets:
                                 (world, [1, 1])
Mapper 3:
(world, 1)                       ↑
(hadoop, 1)                      All values for same key
                                 grouped together!
```

### Word Count Example (Detailed):

```
PROBLEM: Count word frequency in documents

MAP FUNCTION (Pseudocode):
─────────────────────────────
function map(document):
    for each word in document:
        emit(word, 1)

REDUCE FUNCTION (Pseudocode):
─────────────────────────────
function reduce(word, values):
    sum = 0
    for each value in values:
        sum += value
    emit(word, sum)

EXECUTION:
─────────────────────────────

Input Split 1:                  Mapper 1 Output:
"The quick brown fox"    →      (the, 1)
                                (quick, 1)
                                (brown, 1)
                                (fox, 1)

Input Split 2:                  Mapper 2 Output:
"The lazy dog"           →      (the, 1)
                                (lazy, 1)
                                (dog, 1)

        ↓ SHUFFLE & SORT ↓

Grouped by Key:
(brown, [1])
(dog, [1])
(fox, [1])
(lazy, [1])
(quick, [1])
(the, [1, 1])

        ↓ REDUCE ↓

Final Output:
(brown, 1)
(dog, 1)
(fox, 1)
(lazy, 1)
(quick, 1)
(the, 2)        ← "the" appeared twice!
```

---

## YARN (Yet Another Resource Negotiator)

### What is YARN?

YARN is the **resource management layer** that schedules jobs and allocates resources across the cluster.

### Why YARN?

**Hadoop 1.0 Problem:**

```
OLD (MapReduce v1):
┌────────────────────────┐
│  JobTracker            │  ← Single point managing
│  (Does Everything)     │     BOTH resources AND jobs
│                        │     (Bottleneck!)
└────────────────────────┘
           |
    ┌──────┴──────┬──────┐
    ▼             ▼      ▼
TaskTracker  TaskTracker  TaskTracker
```

**YARN Solution (Separation of Concerns):**

```
NEW (YARN):
┌────────────────────────┐
│  ResourceManager       │  ← Manages resources ONLY
└────────────────────────┘
           |
    ┌──────┴──────┬──────┐
    ▼             ▼      ▼
NodeManager  NodeManager  NodeManager

Per-Application:
┌────────────────────────┐
│  ApplicationMaster     │  ← Manages ONE job
└────────────────────────┘
```

### YARN Architecture:

```
                    YARN COMPONENTS

    ┌─────────────────────────────────────────────┐
    │         RESOURCEMANAGER (Master)            │
    │                                             │
    │  ┌──────────────┐    ┌──────────────────┐  │
    │  │  Scheduler   │    │ ApplicationsManager│ │
    │  │              │    │                    │ │
    │  │ • Allocates  │    │ • Accepts jobs    │ │
    │  │   resources  │    │ • Starts AppMaster│ │
    │  └──────────────┘    └──────────────────┘  │
    └─────────────────────────────────────────────┘
                     |
        ─────────────┼─────────────┬──────────────
                     |             |
        ┌────────────▼──────┐  ┌───▼──────────────┐
        │ NODEMANAGER 1     │  │ NODEMANAGER 2    │
        │ (Worker)          │  │ (Worker)         │
        │                   │  │                  │
        │ ┌───────────────┐ │  │ ┌──────────────┐│
        │ │ Container 1   │ │  │ │ Container 3  ││
        │ │ (2GB, 2 CPU)  │ │  │ │ (1GB, 1 CPU) ││
        │ └───────────────┘ │  │ └──────────────┘│
        │                   │  │                  │
        │ ┌───────────────┐ │  │ ┌──────────────┐│
        │ │ Container 2   │ │  │ │ Container 4  ││
        │ │ (4GB, 4 CPU)  │ │  │ │ (2GB, 2 CPU) ││
        │ └───────────────┘ │  │ └──────────────┘│
        └───────────────────┘  └──────────────────┘
```

### Key Components:

**1. ResourceManager (RM):**

- Global resource scheduler
- Tracks available resources across cluster
- Allocates containers to applications

**2. NodeManager (NM):**

- Per-machine agent
- Manages containers on that node
- Monitors resource usage (CPU, RAM, disk)
- Reports to ResourceManager

**3. ApplicationMaster (AM):**

- Per-application coordinator
- Negotiates resources with ResourceManager
- Works with NodeManagers to execute tasks
- Monitors task progress

**4. Container:**

- Unit of resource allocation
- Defined by: CPU cores, RAM, disk, network
- Runs application tasks

### Job Submission Flow:

```
STEP-BY-STEP: How a MapReduce Job Runs on YARN

STEP 1: Client Submits Job
───────────────────────────
    ┌────────┐
    │ Client │──────┐
    └────────┘      │ "Run my MapReduce job"
                    ▼
            ┌──────────────┐
            │ResourceManager│
            └──────────────┘

STEP 2: RM Allocates Container for ApplicationMaster
──────────────────────────────────────────────────────
    ┌──────────────┐
    │ResourceManager│────► "Start AM in Container"
    └──────────────┘              │
                                  ▼
                        ┌────────────────┐
                        │ NodeManager 1  │
                        │  ┌──────────┐  │
                        │  │ Container│  │
                        │  │   (AM)   │  │
                        │  └──────────┘  │
                        └────────────────┘

STEP 3: ApplicationMaster Requests Resources
─────────────────────────────────────────────
    ┌────────────────────┐
    │ ApplicationMaster  │──────► "Need 5 containers"
    │ (for MapReduce)    │        "for Map tasks"
    └────────────────────┘
                │
                ▼
    ┌──────────────┐
    │ResourceManager│──────► "Allocating..."
    └──────────────┘

STEP 4: RM Allocates Containers
────────────────────────────────
    ┌──────────────┐
    │ResourceManager│
    └──────────────┘
            │
        ┌───┴───┬───────┬───────┐
        ▼       ▼       ▼       ▼
    ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
    │ NM 1 │ │ NM 2 │ │ NM 3 │ │ NM 4 │
    │┌────┐│ │┌────┐│ │┌────┐│ │┌────┐│
    ││Cont││ ││Cont││ ││Cont││ ││Cont││
    │└────┘│ │└────┘│ │└────┘│ │└────┘│
    └──────┘ └──────┘ └──────┘ └──────┘

STEP 5: ApplicationMaster Launches Tasks
─────────────────────────────────────────
    ┌────────────────────┐
    │ ApplicationMaster  │───► Launch Map tasks
    └────────────────────┘     in containers
                │
        ┌───────┼───────┬───────┐
        ▼       ▼       ▼       ▼
    ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
    │Map 1 │ │Map 2 │ │Map 3 │ │Map 4 │
    │ Task │ │ Task │ │ Task │ │ Task │
    └──────┘ └──────┘ └──────┘ └──────┘

STEP 6: Monitor & Complete
───────────────────────────
    ┌────────────────────┐
    │ ApplicationMaster  │
    │                    │
    │ • Monitors tasks   │
    │ • Handles failures │
    │ • Reports progress │
    │ • Launches Reduce  │
    └────────────────────┘
                │
                ▼
    ┌──────────────┐
    │ResourceManager│◄─── "Job Complete"
    └──────────────┘
                │
                ▼
            ┌────────┐
            │ Client │◄─── Notification
            └────────┘
```

### Container Allocation Example:

```
Cluster Resources:
┌─────────────────────────────────────┐
│ Total: 100 GB RAM, 50 CPU cores     │
└─────────────────────────────────────┘

Job Submission:
┌─────────────────────────────────────┐
│ MapReduce Job Requests:             │
│ • 10 Map tasks (2GB, 1 CPU each)    │
│ • 5 Reduce tasks (4GB, 2 CPU each)  │
│ • 1 ApplicationMaster (2GB, 1 CPU)  │
└─────────────────────────────────────┘

YARN Allocation:
─────────────────
ApplicationMaster:  1 × (2GB, 1 CPU)  = 2GB,  1 CPU
Map Containers:    10 × (2GB, 1 CPU)  = 20GB, 10 CPU
Reduce Containers:  5 × (4GB, 2 CPU)  = 20GB, 10 CPU
                                      ───────────────
Total Used:                            42GB, 21 CPU

Remaining:                             58GB, 29 CPU
(Available for other jobs)
```

---

## Complete Workflow Example

### Scenario: Word Count on Large Dataset

```
═══════════════════════════════════════════════════════════
COMPLETE HADOOP WORKFLOW: Word Count Job
═══════════════════════════════════════════════════════════

PHASE 1: DATA STORAGE (HDFS)
─────────────────────────────

┌─────────────────────────────────────────────────────┐
│ Input: 10GB text file uploaded to HDFS              │
│ Location: /user/data/books.txt                      │
└─────────────────────────────────────────────────────┘
                      ↓
        ┌─────────────────────────┐
        │ HDFS splits into blocks │
        └─────────────────────────┘
                      ↓
    ┌─────────┬──────┴──────┬─────────┐
    ▼         ▼             ▼         ▼
Block 1   Block 2   ...   Block 79  Block 80
(128MB)   (128MB)         (128MB)   (16MB)
    ↓         ↓             ↓         ↓
Replicated × 3 across DataNodes


PHASE 2: JOB SUBMISSION (YARN)
───────────────────────────────

User runs:
$ hadoop jar wordcount.jar /user/data/books.txt /output

                ↓
┌───────────────────────────────────────┐
│ Step 1: ResourceManager receives job │
└───────────────────────────────────────┘
                ↓
┌───────────────────────────────────────┐
│ Step 2: Allocate AM container        │
└───────────────────────────────────────┘
                ↓
┌───────────────────────────────────────┐
│ Step 3: ApplicationMaster starts     │
└───────────────────────────────────────┘
                ↓
┌───────────────────────────────────────┐
│ Step 4: AM requests 80 Map containers│
│         (one per HDFS block)         │
└───────────────────────────────────────┘


PHASE 3: MAP PHASE (MapReduce)
───────────────────────────────

Each Mapper processes one HDFS block locally:

DataNode 1:                    DataNode 2:
┌──────────────┐              ┌──────────────┐
│ Block 1      │              │ Block 2      │
│ "hello world"│              │ "foo bar"    │
└──────────────┘              └──────────────┘
       ↓                             ↓
┌──────────────┐              ┌──────────────┐
│  Mapper 1    │              │  Mapper 2    │
│              │              │              │
│ (hello, 1)   │              │ (foo, 1)     │
│ (world, 1)   │              │ (bar, 1)     │
└──────────────┘              └──────────────┘

... (78 more mappers) ...


PHASE 4: SHUFFLE & SORT
────────────────────────

┌────────────────────────────────────────┐
│ All intermediate (key,value) pairs    │
│ shuffled across network to Reducers   │
│                                        │
│ Keys grouped: all "hello"→Reducer 1   │
│               all "world"→Reducer 2   │
│               etc.                     │
└────────────────────────────────────────┘


PHASE 5: REDUCE PHASE
──────────────────────

Reducer 1:                   Reducer 2:
┌──────────────┐            ┌──────────────┐
│ (hello,      │            │ (world,      │
│  [1,1,1,...])│            │  [1,1,1,...])│
│      ↓       │            │      ↓       │
│ Sum = 5,230  │            │ Sum = 3,107  │
│      ↓       │            │      ↓       │
│ (hello,5230) │            │ (world,3107) │
└──────────────┘            └──────────────┘

... (N reducers) ...


PHASE 6: OUTPUT (HDFS)
──────────────────────

┌────────────────────────────────┐
│ Final output written to HDFS:  │
│ /output/part-00000             │
│ /output/part-00001             │
│ ...                            │
│                                │
│ Contents:                      │
│ hello  5230                    │
│ world  3107                    │
│ foo    892                     │
│ ...                            │
└────────────────────────────────┘


PHASE 7: CLEANUP
────────────────

┌────────────────────────────────┐
│ ApplicationMaster reports      │
│ success to ResourceManager     │
└────────────────────────────────┘
                ↓
┌────────────────────────────────┐
│ All containers released        │
│ Resources available for        │
│ next jobs                      │
└────────────────────────────────┘
```

### Timeline View:

```
TIME ──────────────────────────────────────────────►

T=0s    Job Submitted
        │
        ├─► ResourceManager receives job
        │
T=1s    │
        ├─► ApplicationMaster container allocated
        │
T=2s    │
        ├─► ApplicationMaster starts
        │   └─► Analyzes input (80 blocks found)
T=5s    │
        ├─► Requests 80 Map containers
        │
T=10s   │
        ├─► YARN allocates containers across cluster
        │
T=15s   │
        ├─► MAP PHASE STARTS (80 mappers running)
        │   │
        │   │ (Data locality: mappers run where data is)
        │   │
T=120s  │   │
        ├─► MAP PHASE COMPLETES
        │
T=125s  │
        ├─► SHUFFLE & SORT (transferring ~2GB intermediate)
        │
T=180s  │
        ├─► REDUCE PHASE STARTS (10 reducers)
        │   │
T=250s  │   │
        ├─► REDUCE PHASE COMPLETES
        │
T=255s  │
        ├─► Output written to HDFS
        │
T=260s  │
        └─► JOB COMPLETE
```

---

## Key Concepts Summary

### Data Locality (Critical for Performance):

```
BAD (No Data Locality):
────────────────────────
    ┌──────────┐                    ┌──────────┐
    │ Mapper   │◄───network────────►│  Data    │
    │ (Node A) │    transfer        │ (Node Z) │
    └──────────┘    (SLOW!)         └──────────┘

GOOD (Data Locality):
─────────────────────
    ┌──────────────────┐
    │  Same Node       │
    │  ┌──────────┐    │
    │  │ Mapper   │    │  ← No network!
    │  └────┬─────┘    │     (FAST!)
    │       │         │
    │  ┌────▼─────┐   │
    │  │   Data   │   │  ← Local read
    │  └──────────┘   │
    └──────────────────┘

Hadoop scheduler tries to run mappers on nodes
that already have the data blocks!
```

### Fault Tolerance Mechanisms:

```
SCENARIO: Node Failure During Job
──────────────────────────────────

Initial State (5 Mappers running):
┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│Map 1 │  │Map 2 │  │Map 3 │  │Map 4 │  │Map 5 │
│Node A│  │Node B│  │Node C│  │Node D│  │Node E│
└──────┘  └──────┘  └──────┘  └──────┘  └──────┘
  ✓         ✓         ✓         ✓         ✓

                    ↓
            Node C FAILS! ❌
                    ↓

┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│Map 1 │  │Map 2 │  │  ❌  │  │Map 4 │  │Map 5 │
│Done  │  │Done  │  │FAILED│  │Running│ │Running│
└──────┘  └──────┘  └──────┘  └──────┘  └──────┘

                    ↓
        ApplicationMaster Detects Failure
                    ↓
        Requests New Container for Map 3
                    ↓
┌──────────────────────────────────────┐
│ YARN allocates on Node F             │
│ Map 3 RESTARTS (reads from HDFS)     │
│ (Data still available - replicated!) │
└──────────────────────────────────────┘
                    ↓
                  ✓ RECOVERED
```

### Scalability:

```
SCALING EXAMPLE: Processing Time vs Cluster Size

Dataset: 1 TB
Task: Word Count

1 Node Cluster:
┌────┐
│ N1 │  Time: ~24 hours
└────┘

10 Node Cluster:
┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┐
│ N1 │ N2 │ N3 │ N4 │ N5 │ N6 │ N7 │ N8 │ N9 │N10 │
└────┴────┴────┴────┴────┴────┴────┴────┴────┴────┘
Time: ~2.5 hours (near-linear scaling)

100 Node Cluster:
┌────┬────┬────┬─  ─┬────┬────┐
│ N1 │ N2 │ N3 │....│N99 │N100│
└────┴────┴────┴─  ─┴────┴────┘
Time: ~20 minutes

Add more nodes → Process faster
(Horizontal Scaling)
```

---

## Real-World Use Cases

### 1. Log Analysis

```
SCENARIO: Analyze web server logs for error patterns

Input: 500GB of Apache logs across 100 servers
Goal: Count HTTP error codes

Map Phase:
──────────
Each log line:
192.168.1.1 - - [01/Jan/2026] "GET /index.html" 200 1234
                                                 ↑
                                           Extract status
Output: (200, 1)

Reduce Phase:
─────────────
Group by status code:
(200, [1,1,1,...]) → (200, 1500000)
(404, [1,1,1,...]) → (404, 25000)
(500, [1,1,...])   → (500, 3500)

Result:
───────
200: 1,500,000 requests (Success)
404: 25,000 requests (Not Found)
500: 3,500 requests (Server Error) ← INVESTIGATE!
```

### 2. Data Warehouse ETL

```
SCENARIO: Daily data aggregation for analytics

Extract:
────────
┌─────────────────────────────────────┐
│ Raw transaction data (100M records) │
│ Stored in HDFS: /raw/transactions/  │
└─────────────────────────────────────┘

Transform (MapReduce):
──────────────────────
Map: Parse each transaction
     Extract: customer_id, amount, date
     
Reduce: Aggregate by customer_id
        Sum amounts, count transactions
        
Output:
───────
customer_id | total_spent | transaction_count | avg_amount
12345      | 5,230.50    | 47               | 111.29
67890      | 12,450.00   | 103              | 120.87
...

Load:
─────
Write to /warehouse/customer_summary/2026-01-11/
```

### 3. Machine Learning Data Prep

```
SCENARIO: Feature extraction for ML model

Input: 10TB of raw sensor data
Goal: Create feature vectors for training

Map Phase:
──────────
Raw sensor reading → Extract features
timestamp, sensor_id, value1, value2, ...
           ↓
Compute: mean, std_dev, min, max per window

Reduce Phase:
─────────────
Aggregate features by sensor_id and time_window
Normalize values
Create feature vectors

Output:
───────
sensor_id | window | feature_vector
S001     | T1     | [0.23, 0.45, 0.12, ...]
S001     | T2     | [0.25, 0.43, 0.15, ...]
```

---

## Advanced Concepts

### Combiners (Local Reduce)

```
WITHOUT COMBINER:
─────────────────
Mapper Output:
(hello, 1), (hello, 1), (hello, 1), ... (1000 times)
         ↓
All 1000 pairs sent over network
         ↓
Reducer receives 1000 values to sum

Network Traffic: HIGH
Reducer Load: HIGH


WITH COMBINER:
──────────────
Mapper Output:
(hello, 1), (hello, 1), (hello, 1), ... (1000 times)
         ↓
LOCAL COMBINER (mini-reduce on mapper node):
(hello, 1000)  ← Pre-aggregated!
         ↓
Only 1 pair sent over network
         ↓
Reducer receives 1 value (or few values from different mappers)

Network Traffic: LOW (99.9% reduction!)
Reducer Load: LOW

Combiner Code:
──────────────
function combine(key, values):
    return (key, sum(values))

Same as Reduce function for associative operations!
```

### Speculative Execution

```
PROBLEM: Straggler Tasks
────────────────────────

Normal execution:
┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐
│Task1│ │Task2│ │Task3│ │Task4│ │Task5│
│ 5s  │ │ 5s  │ │ 5s  │ │ 5s  │ │120s │ ← Slow!
└─────┘ └─────┘ └─────┘ └─────┘ └─────┘
  ✓       ✓       ✓       ✓       ⏳

Job waits for slowest task → Total: 120s


SOLUTION: Speculative Execution
────────────────────────────────

When Task5 is detected as slow:
┌─────┐
│Task5│  Original (still running)
│ 60s │  ← Slow
└─────┘

┌─────┐
│Task5│  Duplicate launched on different node
│ 8s  │  ← Fast!
└─────┘
  ✓  First one to finish wins!

Total time: ~13s instead of 120s
```

### Custom InputFormat

```
DEFAULT: TextInputFormat
────────────────────────
Reads text files line by line
One line = one map input

CUSTOM: WholeFileInputFormat
────────────────────────────
Reads entire file as single input
Useful for processing images, videos, etc.

Example: Image Processing
─────────────────────────

Map Input: (filename, entire_file_bytes)
Map Processing:
    1. Parse image from bytes
    2. Apply filters/transformations
    3. Extract features
    4. Output: (image_id, features)

Reduce:
    Aggregate features, create thumbnails, etc.
```

### Partitioner (Control Reduce Distribution)

```
DEFAULT PARTITIONER:
────────────────────
hash(key) % num_reducers

Problem with skewed data:
────────────────────────
If keys are: A, A, A, A, ..., B, C
Most data goes to one reducer!

Reducer 1: (A, [millions of values])  ← Overloaded
Reducer 2: (B, [few values])          ← Idle
Reducer 3: (C, [few values])          ← Idle


CUSTOM PARTITIONER:
───────────────────
class CustomPartitioner:
    def getPartition(key, value, numReducers):
        if key == 'A':
            # Distribute 'A' across multiple reducers
            return hash(value) % (numReducers - 2)
        else:
            # Other keys to remaining reducers
            return numReducers - 2 + hash(key) % 2

Balanced load:
Reducer 1: (A_subset_1, [...])  ← Balanced
Reducer 2: (A_subset_2, [...])  ← Balanced
Reducer 3: (B, [...])           ← Balanced
Reducer 4: (C, [...])           ← Balanced
```

---

## Performance Optimization Tips

### 1. Block Size Tuning

```
SMALL FILES PROBLEM:
────────────────────
10,000 files × 1MB each = 10GB total
With 128MB blocks → 10,000 map tasks
Overhead: Task startup × 10,000 = SLOW

SOLUTION: Combine small files
─────────────────────────────
Use SequenceFile or HAR (Hadoop Archive)
10,000 files → 1 combined file
128MB blocks → ~80 map tasks
Overhead: Task startup × 80 = MUCH FASTER


LARGE BLOCK SIZE:
─────────────────
Fewer map tasks, but:
- Less parallelism
- Harder to balance load

SMALL BLOCK SIZE:
─────────────────
More map tasks, but:
- More overhead
- More metadata on NameNode

OPTIMAL: 128MB-256MB for most workloads
```

### 2. Compression

```
SCENARIO: 1TB uncompressed data

WITHOUT COMPRESSION:
────────────────────
Disk I/O: 1TB read + 1TB write = 2TB
Network: 1TB shuffle
Time: ~4 hours

WITH COMPRESSION (Gzip, 10:1 ratio):
─────────────────────────────────────
Disk I/O: 100GB read + 100GB write = 200GB
Network: 100GB shuffle
Decompression CPU: Extra cost
Time: ~1 hour (net benefit despite CPU cost)

Compression Codecs:
───────────────────
Gzip:    High compression, not splittable
Snappy:  Fast, moderate compression, splittable
LZO:     Fast, low compression, splittable
Bzip2:   Very high compression, slow, splittable

Recommendation: Snappy for most cases
```

### 3. Memory Configuration

```
YARN Memory Settings:
─────────────────────

yarn.nodemanager.resource.memory-mb = 64GB
    ↑ Total memory available on node

mapreduce.map.memory.mb = 2GB
    ↑ Memory per map task

mapreduce.reduce.memory.mb = 4GB
    ↑ Memory per reduce task

Max concurrent tasks per node:
    Maps: 64GB / 2GB = 32 mappers
    Reduces: 64GB / 4GB = 16 reducers

JVM Heap Settings:
──────────────────
mapreduce.map.java.opts = -Xmx1600m
    ↑ ~80% of container memory

If heap too small → OutOfMemoryError
If heap too large → Swapping, slowdown
```

### 4. Number of Reducers

```
CHOOSING NUMBER OF REDUCERS:
────────────────────────────

Too Few:
────────
┌──────────────┐
│  Reducer 1   │  ← Overloaded
│  (all data)  │
└──────────────┘
• Long runtime
• Memory issues
• No parallelism

Too Many:
─────────
┌───┐ ┌───┐ ┌───┐ ... ┌───┐ (1000 reducers)
│ R1│ │ R2│ │ R3│     │R1k│
└───┘ └───┘ └───┘     └───┘
• Excessive overhead
• Many small output files
• Scheduler overhead

RULE OF THUMB:
──────────────
# reducers = 0.95 × (# nodes × mapred.tasktracker.reduce.tasks.maximum)

Or:
# reducers = (total input size) / (desired output per reducer)

Example:
────────
Input: 1TB
Desired output per reducer: 1GB
Reducers: 1TB / 1GB = ~1000 reducers
```

---

## Monitoring & Debugging

### Job Tracking

```
RESOURCEMANAGER WEB UI:
───────────────────────
http://resourcemanager:8088

┌────────────────────────────────────────┐
│  Running Applications                  │
├────────────────────────────────────────┤
│ App ID        | Name      | Progress   │
│ app_001       | WordCount | ████░░ 65% │
│ app_002       | ETL_Job   | ██░░░░ 25% │
└────────────────────────────────────────┘

Click on job → Detailed view:
┌────────────────────────────────────────┐
│ Map Progress:     ████████░░  80%      │
│ Reduce Progress:  ████░░░░░░  40%      │
│                                        │
│ Maps:     Total: 100  Running: 20      │
│           Complete: 80  Failed: 0      │
│                                        │
│ Reduces:  Total: 10   Running: 4       │
│           Complete: 6   Failed: 0      │
└────────────────────────────────────────┘

HDFS WEB UI:
────────────
http://namenode:50070

┌────────────────────────────────────────┐
│ Cluster Summary                        │
├────────────────────────────────────────┤
│ Total Storage:     500 TB              │
│ Used:              350 TB (70%)        │
│ Available:         150 TB (30%)        │
│                                        │
│ Live Nodes:        100                 │
│ Dead Nodes:        2  ← Check these!   │
│                                        │
│ Under-replicated Blocks: 150           │
└────────────────────────────────────────┘
```

### Common Issues & Solutions

```
ISSUE 1: Job Stuck at Map 100%, Reduce 0%
──────────────────────────────────────────
Symptom: Maps finish, reduces never start

Cause: Not enough memory/containers for reducers

Solution:
• Increase yarn.nodemanager.resource.memory-mb
• Reduce mapreduce.reduce.memory.mb
• Add more nodes


ISSUE 2: Tasks Keep Failing
────────────────────────────
Symptom: Tasks retry and fail repeatedly

Check logs:
$ yarn logs -applicationId app_001

Common causes:
• OutOfMemoryError → Increase heap
• Input split error → Check data format
• Disk full → Clean up temp space


ISSUE 3: Slow Performance
──────────────────────────
Symptom: Job takes much longer than expected

Debug steps:
1. Check data skew (one reducer gets most data)
   → Use custom partitioner
   
2. Check speculative execution enabled
   → mapreduce.map.speculative=true
   
3. Check data locality
   → View counters for rack-local vs node-local
   
4. Check compression enabled
   → io.compression.codecs


ISSUE 4: NameNode Out of Memory
────────────────────────────────
Symptom: NameNode crashes, HDFS unavailable

Cause: Too many small files (high metadata overhead)

Solution:
• Combine small files using HAR or SequenceFiles
• Increase NameNode heap (-Xmx)
• Archive old data
```

---

## Hadoop vs Other Systems

### Hadoop vs Spark

```
HADOOP MapReduce:
─────────────────
┌──────┐    ┌──────┐    ┌──────┐
│ Map  │ → │Reduce│ → │ HDFS │
└──────┘    └──────┘    └──────┘
    ↓           ↓
  HDFS        HDFS  ← Writes to disk between stages

Advantages:
• Extremely fault-tolerant
• Handles huge datasets
• Battle-tested, stable

Disadvantages:
• Slow (disk I/O between stages)
• Complex for iterative jobs
• Verbose programming


APACHE SPARK:
─────────────
┌──────┐    ┌──────┐    ┌──────┐
│ Map  │ → │Filter│ → │Reduce│
└──────┘    └──────┘    └──────┘
    ↓           ↓           ↓
  RAM         RAM         RAM  ← In-memory!

Advantages:
• 10-100× faster (in-memory)
• Simpler API
• Better for iterative algorithms (ML)
• Interactive queries

Disadvantages:
• Requires more RAM
• Less fault-tolerant for very long jobs
• More complex cluster management


WHEN TO USE WHAT:
─────────────────
Hadoop MapReduce:
• Batch ETL jobs
• One-pass data processing
• Very large datasets (>100TB)
• Limited memory

Spark:
• Iterative algorithms (ML)
• Interactive analytics
• Stream processing
• Graph processing
• Datasets that fit in cluster RAM
```

---

## Summary & Key Takeaways

```
═══════════════════════════════════════════════════════
                    HADOOP STACK
═══════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────┐
│                  APPLICATIONS                       │
│  MapReduce Jobs | Hive | Pig | Spark | HBase       │
└─────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────┐
│                     YARN                            │
│  • Resource Management                              │
│  • Job Scheduling                                   │
│  • Container Allocation                             │
└─────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────┐
│                     HDFS                            │
│  • Distributed Storage                              │
│  • Fault Tolerance (Replication)                    │
│  • Data Locality                                    │
└─────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────┐
│              CLUSTER HARDWARE                       │
│  Node 1 | Node 2 | ... | Node N                    │
└─────────────────────────────────────────────────────┘
```

### Core Principles:

**1. HDFS:**

- Splits large files into blocks (128MB default)
- Replicates blocks across nodes (3× default)
- Provides fault tolerance through replication
- NameNode manages metadata, DataNodes store blocks

**2. MapReduce:**

- Map: Transform data → (key, value) pairs
- Shuffle & Sort: Group by key
- Reduce: Aggregate values per key
- Scales linearly with cluster size

**3. YARN:**

- Separates resource management from job execution
- ResourceManager allocates resources globally
- NodeManagers manage per-node resources
- ApplicationMasters manage individual jobs
- Containers provide resource isolation

### The Big Picture:

```
USER PERSPECTIVE:
─────────────────
"I have 10TB of data to process"
         ↓
Write MapReduce program (map + reduce functions)
         ↓
Submit job: hadoop jar myjob.jar
         ↓
Wait for results
         ↓
Access output in HDFS


HADOOP PERSPECTIVE:
───────────────────
Receive job → YARN
         ↓
Allocate resources → Containers
         ↓
Read data from HDFS → Data locality
         ↓
Execute Map tasks → Parallel
         ↓
Shuffle data → Network transfer
         ↓
Execute Reduce tasks → Parallel
         ↓
Write output to HDFS → Replicated
         ↓
Return success to user
```

### Why Hadoop Changed Everything:

**Before Hadoop:**

- Expensive proprietary systems (Oracle, Teradata)
- Vertical scaling (bigger, more expensive machines)
- Limited to structured data
- Complex to scale

**After Hadoop:**

- Open-source, runs on commodity hardware
- Horizontal scaling (add cheap machines)
- Handles any data type (structured, unstructured)
- Simple to scale (just add nodes)

### Modern Hadoop Ecosystem:

```
         ┌─── SQL: Hive, Impala
         │
HADOOP ──┼─── Streaming: Kafka, Storm
         │
         ├─── NoSQL: HBase, Cassandra
         │
         ├─── ML: Mahout, Spark MLlib
         │
         └─── Graph: Giraph, GraphX
```

**Hadoop is the foundation** for modern big data infrastructure, enabling organizations to store and process massive datasets economically and reliably.

═══════════════════════════════════════════════════════ END OF GUIDE ═══════════════════════════════════════════════════════