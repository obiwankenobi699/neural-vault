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
## TABLE OF CONTENTS

1. [Transaction System](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#1-transaction-system)
2. [ACID Properties](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#2-acid-properties)
3. [Transaction Operations](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#3-transaction-operations)
4. [Transaction States](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#4-transaction-states)
5. [Logs and Recovery](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#5-logs-and-recovery)
6. [Rollback Mechanism](https://claude.ai/chat/171e538e-8ef9-4961-ae03-68ed1ef41d58#6-rollback-mechanism)
---

# 1. TRANSACTION SYSTEM

## 1.1 What is a Transaction?

**Definition:** A transaction is a **single logical unit of work** that accesses and possibly modifies database contents.

**Key Principle:** A transaction is an **ALL or NOTHING** operation.

## 1.2 Real-World Example: Bank Transfer

**Scenario:** Transfer $100 from Account A to Account B

```
Transaction T1: Money Transfer
│
├── Operation 1: Read balance of Account A
├── Operation 2: Deduct $100 from Account A  
├── Operation 3: Write new balance to Account A
├── Operation 4: Read balance of Account B
├── Operation 5: Add $100 to Account B
└── Operation 6: Write new balance to Account B

Result: Either ALL 6 operations execute OR NONE execute
```

## 1.3 Why Transactions Are Needed

| Requirement     | Description                                      |
| --------------- | ------------------------------------------------ |
| **Consistency** | Database should remain in consistent state       |
| **Reliability** | Handle system failures gracefully                |
| **Concurrency** | Multiple users accessing database simultaneously |
| **Isolation**   | Transactions don't interfere with each other     |

---

# 2. ACID PROPERTIES

## 2.1 Overview

**ACID** = Four fundamental properties ensuring reliable transaction processing

```
A → Atomicity
C → Consistency  
I → Isolation
D → Durability
```

---

## 2.2 ATOMICITY (All or Nothing)

### Definition

Transaction is treated as a single, indivisible unit. Either ALL operations complete successfully OR NONE complete.

### Example

**Scenario:** Transfer $500 from Account A to Account B

| Account   | Initial Balance |
| --------- | --------------- |
| Account A | $1000           |
| Account B | $500            |

**Transaction Execution:**

```
Step 1: A = A - 500  →  A = $500  ✓
Step 2: B = B + 500  →  SYSTEM CRASH ✗
```

**Without Atomicity:**

- Account A: $500
- Account B: $500
- **Result:** $500 disappeared! ✗

**With Atomicity:**

- System performs **ROLLBACK**
- Account A: $1000 (restored)
- Account B: $500 (unchanged)
- **Result:** Transaction completely undone ✓

### Responsibility

**Transaction Management Component** ensures atomicity.

---

## 2.3 CONSISTENCY (Integrity Maintained)

### Definition

Transaction must take database from one **consistent state** to another consistent state.

### Consistency Rules

- All integrity constraints satisfied
- Data follows all defined rules
- Business logic maintained

### Example

**Business Rule:** Total money in bank = constant

| Stage                                    | Account A | Account B | Total   |
| ---------------------------------------- | --------- | --------- | ------- |
| **Before Transaction**                   | $1000     | $500      | $1500   |
| **Operation:** Transfer $200 from A to B |           |           |         |
| **After Transaction**                    | $800      | $700      | $1500 ✓ |

**Consistency Maintained!** Total remains $1500

**Violation Example:**

- Account A: $800
- Account B: $500
- Total: $1300 ✗ (Inconsistent!)

### Responsibility

**Application Programmer** ensures consistency.

---

## 2.4 ISOLATION (No Interference)

### Definition

Multiple transactions execute concurrently without interfering with each other. Intermediate results not visible to other transactions.

### Example

**Initial State:** Account X = $1000

**Two Concurrent Transactions:**

- T1: Withdraw $100
- T2: Deposit $200

#### Without Isolation (INCORRECT)

| Time | T1             | T2             | Comment                |
| ---- | -------------- | -------------- | ---------------------- |
| t1   | Read X = 1000  |                |                        |
| t2   |                | Read X = 1000  | Both read same value   |
| t3   | X = 1000 - 100 |                |                        |
| t4   |                | X = 1000 + 200 |                        |
| t5   | Write X = 900  |                |                        |
| t6   |                | Write X = 1200 | Overwrites T1's change |

**Final X = $1200** (Lost $100 withdrawal!) ✗

#### With Isolation (CORRECT)

| Time | T1             | T2             | Comment                |
| ---- | -------------- | -------------- | ---------------------- |
| t1   | Read X = 1000  | WAIT           | T2 waits for T1        |
| t2   | X = 1000 - 100 | WAIT           |                        |
| t3   | Write X = 900  | WAIT           |                        |
| t4   | COMMIT         | Read X = 900   | T2 reads updated value |
| t5   |                | X = 900 + 200  |                        |
| t6   |                | Write X = 1100 |                        |
| t7   |                | COMMIT         |                        |

**Final X = $1100** ✓

### Responsibility

**Concurrency Control Component** ensures isolation.

---

## 2.5 DURABILITY (Changes Persist)

### Definition

Once a transaction is **committed**, its effects are **permanent** in the database, surviving system failures.

### Example

**Transaction:** Update Employee Salary

| Time  | Event                                   |
| ----- | --------------------------------------- |
| 10:00 | BEGIN TRANSACTION                       |
| 10:01 | Read Employee record (Salary = $50,000) |
| 10:02 | Update Salary = $55,000                 |
| 10:03 | Write to buffer (in RAM)                |
| 10:04 | **COMMIT**                              |
| 10:05 | Write to disk (permanent storage)       |
| 10:06 | **SYSTEM CRASH**                        |

**After Recovery:**

- Salary = $55,000 ✓
- Change is permanent, not lost

**If crash happened BEFORE commit:**

- Salary = $50,000
- Transaction rolled back

### Responsibility

**Recovery Management Component** ensures durability.

---

## 2.6 ACID Properties Summary

| Property        | Ensures                             |
| --------------- | ----------------------------------- |
| **Atomicity**   | All or Nothing execution            |
| **Consistency** | Database integrity maintained       |
| **Isolation**   | Concurrent transactions don't clash |
| **Durability**  | Changes survive failures            |

---

# 3. TRANSACTION OPERATIONS

## 3.1 READ(X)

### Definition

Read data item X from database into a program variable.

### Process

1. Check if X is in buffer
2. If YES → Read from buffer
3. If NO → Read from disk to buffer, then to variable

### Syntax

```sql
READ(X)
```

### Example

```sql
READ(Account_A)
-- Reads balance of Account A into memory
```

---

## 3.2 WRITE(X)

### Definition

Write value of program variable X into the database.

### Process

1. Write to buffer in main memory
2. Eventually written to disk (not immediate)

### Syntax

```sql
WRITE(X)
```

### Example

```sql
WRITE(Account_A)
-- Writes new balance of Account A to database
```

---

## 3.3 UPDATE

### Definition

Modify the value of a data item.

**Note:** UPDATE = READ + Modify + WRITE

### Process for: A = A + 100

```
Step 1: READ(A)       → Read current value
Step 2: A = A + 100   → Modify in memory
Step 3: WRITE(A)      → Write back to database
```

---

## 3.4 COMMIT

### Definition

Successful completion of transaction. All changes made permanent.

### Characteristics

- Changes written to disk
- Transaction cannot be rolled back after commit
- Database in new consistent state

### Syntax

```sql
COMMIT
```

### Example

```sql
BEGIN TRANSACTION
    READ(A)
    A = A - 100
    WRITE(A)
    READ(B)
    B = B + 100
    WRITE(B)
COMMIT  ← Makes all changes permanent
```

---

## 3.5 ROLLBACK (ABORT)

### Definition

Unsuccessful termination of transaction. All changes undone.

### Characteristics

- Database returns to state before transaction
- All modifications reversed
- Locks released

### Syntax

```sql
ROLLBACK
```

### Example

```sql
BEGIN TRANSACTION
    READ(A)
    A = A - 100
    WRITE(A)
    -- ERROR OCCURS
ROLLBACK  ← Undo all changes, A returns to original value
```

---

# 4. TRANSACTION STATES

## 4.1 State Transition Diagram

```
                    BEGIN
                      ↓
            ┌──────────────────┐
            │     ACTIVE       │
            │   (Executing)    │
            └────────┬─────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
      Success                 Failure
         │                       │
         ↓                       ↓
┌─────────────────┐    ┌─────────────────┐
│   PARTIALLY     │    │     FAILED      │
│   COMMITTED     │    │                 │
└────────┬────────┘    └────────┬────────┘
         │                       │
    Write to disk           Rollback
         │                       │
         ↓                       ↓
┌─────────────────┐    ┌─────────────────┐
│    COMMITTED    │    │     ABORTED     │
│   (Complete)    │    │  (Rolled back)  │
└─────────────────┘    └─────────────────┘
```

---

## 4.2 State Descriptions

### 1. ACTIVE State

**Definition:** Initial state when transaction begins execution.

**Characteristics:**

- Transaction currently executing
- Performing read/write operations
- Can move to Partially Committed or Failed state

**Example:**

```sql
BEGIN TRANSACTION
READ(A)          ← ACTIVE state
A = A - 100      ← ACTIVE state
WRITE(A)         ← ACTIVE state
```

---

### 2. PARTIALLY COMMITTED State

**Definition:** Transaction executed final operation but changes still in main memory (buffer).

**Characteristics:**

- All operations completed successfully
- Changes not yet written to disk
- Waiting for commit confirmation
- Can still fail (e.g., disk error)

**Example:**

```sql
BEGIN TRANSACTION
READ(A)
A = A - 100
WRITE(A)
READ(B)
B = B + 100
WRITE(B)         ← Last operation done
-- Now in PARTIALLY COMMITTED state
-- Changes in buffer, not on disk yet
```

---

### 3. COMMITTED State

**Definition:** Transaction completed successfully. All changes permanently saved to disk.

**Characteristics:**

- Changes written to disk
- Transaction cannot be undone
- Database in new consistent state
- **Final success state**

**Example:**

```sql
BEGIN TRANSACTION
READ(A)
A = A - 100
WRITE(A)
COMMIT           ← COMMITTED state
-- Changes are permanent now
```

---

### 4. FAILED State

**Definition:** Transaction cannot proceed further due to error.

**Characteristics:**

- Error occurred during execution
- Cannot continue normal execution
- Must be rolled back

**Error Types:**

- Hardware failure
- Logical error
- Integrity constraint violation

**Example:**

```sql
BEGIN TRANSACTION
READ(A)
A = A - 100
WRITE(A)
-- SYSTEM CRASH or ERROR
-- Now in FAILED state
```

---

### 5. ABORTED State

**Definition:** Transaction rolled back. Database restored to state before transaction.

**Characteristics:**

- All changes undone
- Database restored to previous consistent state
- **Final failure state**
- Transaction can be:
    - **Restarted** (if failure was temporary)
    - **Killed** (if failure was logical error)

**Example:**

```sql
BEGIN TRANSACTION
READ(A)
A = A - 100
WRITE(A)
-- ERROR OCCURS
ROLLBACK         ← ABORTED state
-- A returns to original value
```

---

## 4.3 State Transition Examples

### Scenario 1: Successful Transaction

| Time | State               | Action                  |
| ---- | ------------------- | ----------------------- |
| t1   | BEGIN               | START transaction       |
| t2   | ACTIVE              | READ(A)                 |
| t3   | ACTIVE              | A = A - 100             |
| t4   | ACTIVE              | WRITE(A)                |
| t5   | ACTIVE              | READ(B)                 |
| t6   | ACTIVE              | B = B + 100             |
| t7   | ACTIVE              | WRITE(B)                |
| t8   | PARTIALLY COMMITTED | Last operation done     |
| t9   | COMMITTED           | Changes written to disk |

---

### Scenario 2: Failed Transaction

|Time|State|Action|
|---|---|---|
|t1|BEGIN|START transaction|
|t2|ACTIVE|READ(A)|
|t3|ACTIVE|A = A - 100|
|t4|ACTIVE|WRITE(A)|
|t5|ACTIVE|READ(B)|
|t6|FAILED|SYSTEM CRASH|
|t7|ABORTED|ROLLBACK executed|
|||A restored to original value|

---

# 5. LOGS AND RECOVERY

## 5.1 What is a Log?

**Definition:** A log is a **sequential file** that records all operations performed by transactions.

### Purpose

- Recovery after system failure
- Maintain transaction history
- Support undo/redo operations

---

## 5.2 Log Record Structure

### Basic Format

```
[Transaction_ID, Data_Item, Old_Value, New_Value]
```

### Components

|Component|Description|
|---|---|
|**Transaction ID**|Unique identifier for transaction|
|**Data Item**|Which data was modified (e.g., Account_A)|
|**Old Value**|Value before modification|
|**New Value**|Value after modification|

---

## 5.3 Types of Log Records

### 1. Transaction Start

```
Format: [TID, START]
Example: [T1, START]
```

### 2. Write Operation

```
Format: [TID, Data_Item, Old_Value, New_Value]
Example: [T1, A, 1000, 900]
-- Transaction T1 changed A from 1000 to 900
```

### 3. Read Operation

```
Format: [TID, READ, Data_Item]
Example: [T1, READ, A]
```

### 4. Commit

```
Format: [TID, COMMIT]
Example: [T1, COMMIT]
```

### 5. Abort

```
Format: [TID, ABORT]
Example: [T1, ABORT]
```

---

## 5.4 Complete Log Example

### Transaction: Transfer $100 from A to B

**Initial State:**

- A = 1000
- B = 500

**Log Records:**

```
[T1, START]
[T1, READ, A]
[T1, A, 1000, 900]      ← Write operation
[T1, READ, B]
[T1, B, 500, 600]       ← Write operation
[T1, COMMIT]
```

**Final State:**

- A = 900
- B = 600

---

## 5.5 Write-Ahead Logging (WAL) Protocol

### Definition

Log records must be written to stable storage **BEFORE** actual database modifications.

### WAL Rules

**Rule 1:** Before modifying database, write log record to stable storage

**Rule 2:** Transaction commits only after all log records (including commit record) written to stable storage

### Why WAL is Important

#### Without WAL (INCORRECT)

|Time|Action|
|---|---|
|t1|Update A = 900 in database|
|t2|CRASH (before writing log)|
|t3|Recovery: Cannot undo (no log record!) ✗|

#### With WAL (CORRECT)

|Time|Action|
|---|---|
|t1|Write log: [T1, A, 1000, 900]|
|t2|Update A = 900 in database|
|t3|CRASH|
|t4|Recovery: Read log, undo A = 1000 ✓|

---

## 5.6 Recovery Operations

### UNDO Operation

**Purpose:** Rollback uncommitted transactions

**Process:**

1. Scan log backwards from end
2. For each transaction without COMMIT:
    - Find all write operations
    - Restore old_value
3. Mark transaction as ABORTED

**Example:**

```
LOG:
[T1, START]
[T1, A, 1000, 900]
[T1, B, 500, 600]
-- CRASH (No COMMIT record)

UNDO Process:
├── Restore A = 1000 (old value)
└── Restore B = 500 (old value)
```

---

### REDO Operation

**Purpose:** Reapply committed transactions

**Process:**

1. Scan log forward from beginning
2. For each transaction with COMMIT:
    - Find all write operations
    - Apply new_value
3. Ensure durability

**Example:**

```
LOG:
[T1, START]
[T1, A, 1000, 900]
[T1, B, 500, 600]
[T1, COMMIT]
-- CRASH (Changes might not be on disk)

REDO Process:
├── Apply A = 900 (new value)
└── Apply B = 600 (new value)
```

---

# 6. ROLLBACK MECHANISM

## 6.1 When Does Rollback Occur?

|Scenario|Description|
|---|---|
|**1. Explicit Rollback**|User/Application calls ROLLBACK command|
|**2. System Failure**|Power failure, Hardware crash, Software crash|
|**3. Transaction Failure**|Deadlock detected, Timeout, Resource unavailable|
|**4. Integrity Constraint Violation**|Primary key violation, Foreign key violation, Check constraint violation|
|**5. Logical Error**|Division by zero, Invalid data type, Business rule violation|

---

## 6.2 Rollback Process

### Step-by-Step Process

```
Step 1: Identify failed transaction
Step 2: Read log backwards
Step 3: For each write operation, restore old_value
Step 4: Release all locks held by transaction
Step 5: Mark transaction as ABORTED
```

### Example

```sql
BEGIN TRANSACTION
READ(A)          -- A = 1000
A = A - 500
WRITE(A)         -- A = 500, LOG: [T1, A, 1000, 500]
READ(B)          -- B = 2000
B = B + 500
WRITE(B)         -- B = 2500, LOG: [T1, B, 2000, 2500]
-- ERROR OCCURS
ROLLBACK
```

**Rollback Process:**

1. Read log backwards
2. Find [T1, B, 2000, 2500] → Restore B = 2000
3. Find [T1, A, 1000, 500] → Restore A = 1000
4. Transaction T1 ABORTED

---

## 6.3 Where Does Rollback Revert Changes?

### Memory Hierarchy

```
┌─────────────────────────────────────────┐
│  PRIMARY MEMORY (RAM)                   │
│  - Buffer Pool                          │
│  - Transaction Workspace                │
│  - Volatile (Lost on crash)             │
└─────────────────────────────────────────┘
                 ↓ Write
┌─────────────────────────────────────────┐
│  SECONDARY MEMORY (Disk)                │
│  - Database Files                       │
│  - Log Files                            │
│  - Non-volatile (Survives crash)        │
└─────────────────────────────────────────┘
```

---

### Rollback Behavior

**Rollback Reverts Changes In:**

|Memory Type|Rollback Action|
|---|---|
|**PRIMARY MEMORY (RAM)**|YES - Discards modified buffers, Clears transaction workspace|
|**SECONDARY MEMORY (Disk)**|YES - Uses log to restore old values, Physical restore from backup if needed|

**KEY POINT:** Rollback reverts changes **WHEREVER** they are (RAM or Disk)

---

### Detailed Examples

#### Case 1: Changes Only in PRIMARY MEMORY

```
Transaction T1:
├── READ(A) from disk to buffer (RAM)
├── A = A - 100 (modify in RAM)
├── WRITE(A) to buffer (still in RAM)
└── CRASH before writing to disk

Rollback Action:
└── Discard buffer contents
    No disk restore needed
    Changes never reached disk
```

#### Case 2: Changes in SECONDARY MEMORY

```
Transaction T1:
├── READ(A) from disk
├── A = A - 100
├── WRITE(A) to buffer
├── Buffer flushed to disk (A modified on disk)
└── CRASH before COMMIT

Rollback Action:
├── Read log: [T1, A, old_value, new_value]
└── Restore old_value to DISK
    Must physically write old value back
```

---

## 6.4 Answer: Where Does Rollback Revert?

**Question:** Does rollback revert changes in secondary memory or primary memory?

**Answer:** **BOTH**

**Rollback Mechanism:**

- Uses LOG to determine:
    - What was changed
    - Where it was changed (RAM/Disk)
    - What the old value was
- Then reverts changes in BOTH places

---
