---
title:
  "{ Title }":
tags:
  - database
  - DBMS
created:
  "{ date }":
updated:
  "{ date }":
---

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║   ██████╗ ██████╗ ███╗   ███╗███████╗███████╗                 ║
║   ██╔══██╗██╔══██╗████╗ ████║██╔════╝██╔════╝                 ║
║   ██║  ██║██████╔╝██╔████╔██║███████╗███████╗                 ║
║   ██║  ██║██╔══██╗██║╚██╔╝██║╚════██║╚════██║                 ║
║   ██████╔╝██████╔╝██║ ╚═╝ ██║███████║███████║                 ║
║   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝                 ║
║                                                                ║
║        INTERNAL ARCHITECTURE OF DATABASE SYSTEM               ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 1. DBMS Internal Architecture – Overview

A **DBMS** is divided into **three major layers**:

- **Query Processing Layer**
    
- **Storage Management Layer**
    
- **Transaction & Metadata Management Layer**
    

```ascii
┌───────────────────────────────┐
│            USERS              │
└───────────────┬───────────────┘
                │ SQL Queries
┌───────────────▼───────────────┐
│        QUERY PROCESSOR         │
└───────────────┬───────────────┘
                │ Optimized Plan
┌───────────────▼───────────────┐
│       STORAGE MANAGER          │
└───────────────┬───────────────┘
                │ Disk I/O
┌───────────────▼───────────────┐
│        PHYSICAL STORAGE       │
└───────────────────────────────┘
```

---

## 2. Query Processor

### Role

Converts **high-level SQL queries** into **low-level execution plans**.

### Responsibilities

- Syntax checking
    
- Semantic checking
    
- Query translation
    
- Query optimization (via optimizer)
    

### Components

- DDL Compiler
    
- DML Compiler
    
- Query Optimizer
    
- Execution Engine
    

---

## 3. Query Optimizer

### Definition

The **brain of DBMS** that selects the **most efficient execution plan**.

### What it Optimizes

- Join order
    
- Index usage
    
- Access paths
    
- Cost (CPU + I/O + Memory)
    

### Uses

- Statistics from Data Dictionary
    
- Cost-based or rule-based optimization
    

```ascii
┌──────────────────────────────┐
│        QUERY OPTIMIZER       │
├──────────────────────────────┤
│ Cost Estimation              │
│ Join Reordering              │
│ Index Selection              │
│ Access Path Selection        │
└──────────────────────────────┘
```

---

## 4. Execution Engine

### Function

Executes the **query execution plan** produced by the optimizer.

### Responsibilities

- Executes relational operators (select, join, project)
    
- Calls storage manager for data access
    
- Returns result to user
    

```ascii
Execution Plan
     │
     ▼
┌───────────────┐
│ Execution     │
│ Engine        │
└───────────────┘
     │
     ▼
 Storage Manager
```

---

## 5. Storage Manager

### Definition

Handles **low-level data storage**, retrieval, and updates.

### Core Duties

- File organization
    
- Index management
    
- Disk space management
    
- Buffer management coordination
    

```ascii
┌──────────────────────────────┐
│        STORAGE MANAGER       │
├──────────────────────────────┤
│ File Manager                 │
│ Index Manager                │
│ Buffer Manager               │
│ Disk Space Manager           │
└──────────────────────────────┘
```

---

## 6. DDL Compiler

### Purpose

Processes **DDL statements** (`CREATE`, `ALTER`, `DROP`).

### Output

- Updates **Data Dictionary**
    
- Creates internal database schema
    

```ascii
CREATE TABLE student(...)
        │
        ▼
┌──────────────────────────┐
│      DDL COMPILER        │
└───────────┬─────────────┘
            ▼
    Data Dictionary
```

---

## 7. DML Compiler

### Purpose

Processes **DML queries** (`SELECT`, `INSERT`, `UPDATE`, `DELETE`).

### Steps

1. Syntax check
    
2. Query translation
    
3. Sends to Query Optimizer
    

```ascii
SELECT * FROM student;
        │
        ▼
┌──────────────────────────┐
│      DML COMPILER        │
└───────────┬─────────────┘
            ▼
     Query Optimizer
```

---

## 8. Scheduler

### Function

Controls **concurrent execution of transactions**.

### Ensures

- Serializability
    
- Isolation
    
- Deadlock prevention
    

### Uses

- Locking
    
- Timestamp ordering
    
- Validation techniques
    

```ascii
┌──────────────────────────┐
│        SCHEDULER         │
├──────────────────────────┤
│ Lock Management          │
│ Deadlock Handling        │
│ Transaction Ordering     │
└──────────────────────────┘
```

---

## 9. Buffer Manager

### Definition

Manages **main memory buffers** that cache disk blocks.

### Why Needed

- Disk is slow
    
- Memory is fast
    

### Responsibilities

- Fetch blocks into memory
    
- Page replacement
    
- Write back dirty pages
    

```ascii
Disk Block ⇄ Buffer ⇄ CPU
```

---

## 10. Recovery Manager

### Purpose

Ensures **database consistency after failures**.

### Handles

- System crashes
    
- Transaction failures
    
- Power loss
    

### Techniques

- Write-Ahead Logging (WAL)
    
- Checkpointing
    
- Undo / Redo operations
    

```ascii
┌──────────────────────────┐
│     RECOVERY MANAGER     │
├──────────────────────────┤
│ Logging                  │
│ Checkpointing            │
│ Crash Recovery           │
└──────────────────────────┘
```

---

## 11. Data Dictionary Manager

### Definition

Manages **metadata (data about data)**.

### Stores

- Table names
    
- Attributes
    
- Indexes
    
- Constraints
    
- User privileges
    

```ascii
┌──────────────────────────┐
│   DATA DICTIONARY        │
├──────────────────────────┤
│ Schema Information       │
│ Index Details            │
│ User Privileges          │
│ Statistics               │
└──────────────────────────┘
```

---

## 12. Combined Multi-Level ASCII Architecture Diagram

```
╔══════════════════════════════════════════════════════════════╗
║                       DBMS ARCHITECTURE                      ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║   USER / APPLICATION                                         ║
║           │                                                  ║
║           ▼                                                  ║
║   ┌──────────────────────────────┐                           ║
║   │        QUERY PROCESSOR       │                           ║
║   │  ┌────────────┐ ┌─────────┐  │                           ║
║   │  │ DDL        │ │ DML     │  │                           ║
║   │  │ Compiler   │ │ Compiler│  │                           ║
║   │  └────┬───────┘ └────┬────┘  │                           ║
║   │       ▼              ▼       │                           ║
║   │        QUERY OPTIMIZER       │                           ║
║   │               │              │                           ║
║   │        EXECUTION ENGINE      │                           ║
║   └───────────────┬──────────────┘                           ║
║                   ▼                                          ║
║   ┌──────────────────────────────┐                           ║
║   │        STORAGE MANAGER       │                           ║
║   │  Buffer Manager              │  |                        ║
║   │  Scheduler -------------------->|Transaction Schedular   ║
║   │  Recovery Manager            │  |                        ║
║   └───────────────┬──────────────┘                           ║
║                   ▼                                          ║
║   ┌──────────────────────────────┐                           ║
║   │     PHYSICAL STORAGE         │                           ║
║   │  Data Files | Index Files    │                           ║
║   │  Log Files                   │                           ║
║   └──────────────────────────────┘                           ║
║                                                              ║
║   Data Dictionary  ⇄  Used by all components                ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 13. Exam & Interview Summary

```ascii
┌──────────────────────────────────────────────────────────┐
│                DBMS INTERNAL STRUCTURE – KEY POINTS      │
├──────────────────────────────────────────────────────────┤
│ Query Processor → SQL to Execution Plan                  │
│ Query Optimizer → Best plan selection                    │
│ Execution Engine → Executes plan                         │
│ Storage Manager → Disk & memory handling                 │
│ DDL Compiler → Schema creation                           │
│ DML Compiler → Query translation                         │
│ Scheduler → Concurrency control                          │
│ Buffer Manager → Memory cache                            │
│ Recovery Manager → Failure handling                      │
│ Data Dictionary → Metadata repository                    │
└──────────────────────────────────────────────────────────┘
```

---
