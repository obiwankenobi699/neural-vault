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
# Concurrency Control in Database Systems

## Table of Contents

1. [Introduction](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#introduction)
2. [Concurrency Problems](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#concurrency-problems)
3. [Lock-Based Protocols](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#lock-based-protocols)
4. [Timestamp-Based Protocols](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#timestamp-based-protocols)
5. [Validation-Based Protocol](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#validation-based-protocol)
6. [Two-Phase Locking (2PL)](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#two-phase-locking-2pl)
7. [Two-Phase Commit (2PC)](https://claude.ai/chat/849f47ff-b482-4247-9444-e784c8333fe8#two-phase-commit-2pc)

---

## Introduction

**Concurrency Control** is a database management technique used to ensure that multiple transactions can execute simultaneously without violating data integrity. It maintains the consistency and isolation properties of the ACID model while allowing concurrent access to the database.

### Why is Concurrency Control Important?

- Ensures **data consistency** when multiple users access the database simultaneously
- Prevents **data anomalies** and maintains database integrity
- Maximizes **system throughput** by allowing multiple transactions to execute concurrently
- Maintains the **isolation** property of ACID transactions
- Prevents conflicts between concurrent transactions

---

## Concurrency Problems

Without proper concurrency control, several problems can occur:

### 1. Dirty Read

A transaction reads data written by another uncommitted transaction. If the first transaction rolls back, the second transaction has read invalid data.

**Example:**

```
T1: UPDATE Account SET balance = 150 WHERE id = 1;
T2: SELECT balance FROM Account WHERE id = 1;  -- Reads 150
T1: ROLLBACK;  -- T2 read dirty data (150 instead of original value)
```

### 2. Lost Update

Two transactions read the same data and then update it based on the value read. One of the updates gets lost because the second transaction overwrites the first update.

**Example:**

```
T1: READ balance (100)
T2: READ balance (100)
T1: balance = balance + 50 = 150
T2: balance = balance + 30 = 130
T1: WRITE balance (150)
T2: WRITE balance (130)  -- T1's update is lost!
```

### 3. Phantom Read

A transaction re-executes a query and finds a different set of rows due to another transaction's INSERT or DELETE operations.

**Example:**

```
T1: SELECT COUNT(*) FROM Employees WHERE dept = 'Sales';  -- Returns 5
T2: INSERT INTO Employees VALUES (106, 'Sales');
T2: COMMIT;
T1: SELECT COUNT(*) FROM Employees WHERE dept = 'Sales';  -- Returns 6 (Phantom row!)
```

### 4. Unrepeatable Read

A transaction reads the same data twice but gets different values because another transaction modified the data in between.

**Example:**

```
T1: SELECT balance FROM Account WHERE id = 1;  -- Reads 100
T2: UPDATE Account SET balance = 200 WHERE id = 1;
T2: COMMIT;
T1: SELECT balance FROM Account WHERE id = 1;  -- Reads 200 (Different value!)
```

### 5. Deadlock

Two or more transactions are waiting for each other to release locks, creating a circular dependency that prevents any of them from proceeding.

**Example:**

```
T1: LOCK(A)
T2: LOCK(B)
T1: LOCK(B)  -- Waits for T2 to release B
T2: LOCK(A)  -- Waits for T1 to release A (DEADLOCK!)
```

---

## Lock-Based Protocols

Lock-based protocols use locks to control concurrent access to data items. Transactions must acquire appropriate locks before accessing data.

### Shared Lock (S-Lock / Read Lock)

- Multiple transactions can hold shared locks on the same data item simultaneously
- Allows **READ** operations only
- Compatible with other shared locks but not with exclusive locks
- Notation: `lock-S(X)`

**Properties:**

- If T1 has S-lock on X, T1 can read X but cannot write X
- Other transactions can also acquire S-lock on X
- No transaction can acquire X-lock on X until all S-locks are released

### Exclusive Lock (X-Lock / Write Lock)

- Only one transaction can hold an exclusive lock on a data item at a time
- Allows both **READ** and **WRITE** operations
- Not compatible with any other lock (shared or exclusive)
- Notation: `lock-X(X)`

**Properties:**

- If T1 has X-lock on X, T1 can both read and write X
- No other transaction can acquire any lock (S-lock or X-lock) on X
- Ensures complete isolation for write operations

### Lock Compatibility Matrix

|Request ↓ / Held →|Shared (S)|Exclusive (X)|
|---|---|---|
|**Shared (S)**|✓ Yes|✗ No|
|**Exclusive (X)**|✗ No|✗ No|

### Simplistic Lock Protocol

- Transactions acquire locks when needed and release them immediately after use
- **Problem:** Does not guarantee serializability
- Can still lead to inconsistencies

**Example:**

```
T1: lock-X(A), READ(A), A = A - 50, WRITE(A), unlock(A)
T2: lock-X(A), READ(A), A = A + 50, WRITE(A), unlock(A)
```

### Pre-Claiming Lock Protocol

- Transaction must declare all locks it needs **before execution begins**
- All locks are acquired at once before the transaction starts
- **Advantages:** Prevents deadlock, ensures serializability
- **Disadvantages:** Difficult to predict all needed locks, reduces concurrency, may lock resources unnecessarily

**Example:**

```
T1: Declare locks needed: {A, B, C}
T1: Acquire all locks: lock-X(A), lock-X(B), lock-X(C)
T1: Execute operations
T1: Release all locks: unlock(A), unlock(B), unlock(C)
```

---

## Two-Phase Locking (2PL)

Two-Phase Locking is a concurrency control protocol that ensures serializability by dividing transaction execution into two distinct phases.

### Phases of 2PL

#### 1. Growing Phase (Expanding Phase)

- Transaction may **acquire locks** (S-lock or X-lock)
- Transaction **cannot release** any locks
- Phase continues until the transaction acquires all necessary locks
- Once a lock is released, the growing phase ends

#### 2. Shrinking Phase (Contracting Phase)

- Transaction may **release locks**
- Transaction **cannot acquire** new locks
- Begins immediately after the first lock is released
- Continues until all locks are released

### Visualization

```
Number of Locks
     ^
     |     Growing Phase  |  Shrinking Phase
     |        /\          |
     |       /  \         |
     |      /    \        |
     |     /      \       |
     |    /        \_____ |
     |___/_________________\____________> Time
         ^                 ^
    Lock Point      Transaction End
```

### Key Rules

1. A transaction cannot acquire a lock after releasing any lock
2. The point where the last lock is acquired is called the **Lock Point**
3. All 2PL schedules are **conflict serializable**

### Example of 2PL

```
T1:
  lock-S(A)          -- Growing phase starts
  READ(A)
  lock-X(B)          -- Still growing
  READ(B)
  B = B + A
  WRITE(B)
  unlock(A)          -- Shrinking phase starts
  unlock(B)          -- Still shrinking
```

### Variants of 2PL

#### Strict 2PL

- All exclusive locks are held until the transaction **commits or aborts**
- Prevents cascading rollbacks
- Most commonly used in practice

#### Rigorous 2PL

- All locks (both shared and exclusive) are held until transaction **commits or aborts**
- Simplifies recovery process
- Provides maximum isolation

#### Conservative 2PL

- Acquires all locks before the transaction begins (similar to pre-claiming)
- No growing phase during execution
- Prevents deadlock but reduces concurrency

### Advantages of 2PL

- Guarantees conflict serializability
- Widely implemented in commercial databases
- Relatively simple to implement

### Disadvantages of 2PL

- Can lead to **deadlocks**
- May cause **cascading rollbacks** (in basic 2PL)
- Reduces concurrency due to lock holding
- Does not prevent all types of anomalies (e.g., phantoms in basic 2PL)

---

## Timestamp-Based Protocols

Timestamp-based protocols use system-generated timestamps to determine the order of transaction execution. Each transaction is assigned a unique timestamp when it begins.

### Basic Concepts

- Each transaction T is assigned a unique timestamp TS(T)
- For transactions Ti and Tj: if Ti starts before Tj, then TS(Ti) < TS(Tj)
- Each data item X has two timestamp values:
    - **W-timestamp(X):** Timestamp of the last transaction that wrote X
    - **R-timestamp(X):** Timestamp of the last transaction that read X

### Basic Timestamp Ordering Protocol

#### Rules for READ Operation

When transaction T wants to read data item X:

1. **If TS(T) < W-timestamp(X):**
    
    - T is trying to read a value that was already overwritten by a newer transaction
    - **Action:** Reject the operation and rollback T
2. **If TS(T) ≥ W-timestamp(X):**
    
    - T can read X
    - **Action:** Execute READ(X) and set R-timestamp(X) = max(R-timestamp(X), TS(T))

#### Rules for WRITE Operation

When transaction T wants to write data item X:

1. **If TS(T) < R-timestamp(X):**
    
    - T is trying to write a value that was already read by a newer transaction
    - **Action:** Reject the operation and rollback T
2. **If TS(T) < W-timestamp(X):**
    
    - T is trying to write a value that was already overwritten by a newer transaction
    - **Action:** Reject the operation and rollback T (or ignore the write using Thomas Write Rule)
3. **If TS(T) ≥ R-timestamp(X) AND TS(T) ≥ W-timestamp(X):**
    
    - **Action:** Execute WRITE(X) and set W-timestamp(X) = TS(T)

### Example of Basic Timestamp Protocol

```
Assume: TS(T1) = 1, TS(T2) = 2, TS(T3) = 3

Initially: R-timestamp(A) = 0, W-timestamp(A) = 0

T1: READ(A)    -- TS(T1)=1 ≥ W-timestamp(A)=0 ✓
                  R-timestamp(A) = 1
                  
T3: WRITE(A)   -- TS(T3)=3 ≥ R-timestamp(A)=1 AND TS(T3)=3 ≥ W-timestamp(A)=0 ✓
                  W-timestamp(A) = 3
                  
T2: READ(A)    -- TS(T2)=2 < W-timestamp(A)=3 ✗
                  ROLLBACK T2 (reading obsolete data)
```

### Advantages of Basic Timestamp Protocol

- **No deadlocks:** Transactions never wait for locks
- Guarantees conflict serializability
- Older transactions get priority (ensures fairness based on start time)

### Disadvantages of Basic Timestamp Protocol

- High rollback rate (many transactions may be rolled back)
- Cascading rollbacks are possible
- Requires timestamp maintenance overhead
- Starvation possible for long transactions

---

## Strict Timestamp Ordering Protocol

An enhancement of the basic timestamp protocol that prevents cascading rollbacks.

### Key Difference from Basic Protocol

- A transaction T must wait if it attempts to read or write data item X that was written by a transaction T' where:
    - TS(T') < TS(T) AND
    - T' has not yet committed or aborted

### Rules

#### For READ Operation

- If W-timestamp(X) > TS(T): Rollback T
- If the transaction that wrote X has not committed: **Wait** until it commits or aborts
- Otherwise: Execute READ(X)

#### For WRITE Operation

- If R-timestamp(X) > TS(T) OR W-timestamp(X) > TS(T): Rollback T
- If any transaction that read or wrote X has not committed: **Wait** until it commits or aborts
- Otherwise: Execute WRITE(X)

### Advantages

- Prevents cascading rollbacks
- Maintains serializability
- Ensures recoverable schedules

### Disadvantages

- Transactions may have to wait (reduces concurrency)
- Can lead to deadlocks (transactions waiting for each other)
- More complex than basic timestamp protocol

---

## Validation-Based Protocol (Optimistic Concurrency Control)

Also known as **Optimistic Concurrency Control (OCC)**, this protocol assumes conflicts are rare and validates transactions only at commit time.

### Three Phases

#### 1. Read Phase (Execution Phase)

- Transaction executes and reads values from the database
- All updates are made to **local copies** (not the actual database)
- No locks are acquired
- Transaction collects its **Read Set (RS)** and **Write Set (WS)**
    - RS(T): Set of data items read by T
    - WS(T): Set of data items written by T

**Operations:**

```
- Read database values
- Perform computations
- Store updates in local workspace
- Build RS(T) and WS(T)
```

#### 2. Validation Phase

- Transaction enters validation when it's ready to commit
- System checks if the transaction conflicts with other concurrent transactions
- Assigned a validation timestamp
- Must pass validation tests to proceed to write phase

**Validation Rules:** For transactions Ti and Tj where TS(Ti) < TS(Tj):

One of the following conditions must be true:

1. **Ti completes before Tj starts:**
    
    - finish(Ti) < start(Tj)
    - No overlap, no conflict possible
2. **Ti completes before Tj starts validation AND Ti doesn't write items that Tj reads:**
    
    - start(Tj) < finish(Ti) < validation(Tj)
    - WS(Ti) ∩ RS(Tj) = ∅
    - Ti's writes don't affect Tj's reads
3. **Ti completes validation before Tj completes AND Ti doesn't read or write items that Tj writes:**
    
    - start(Tj) < validation(Ti) < validation(Tj)
    - WS(Ti) ∩ RS(Tj) = ∅ AND WS(Ti) ∩ WS(Tj) = ∅

**Action:** If validation fails → Rollback transaction; If validation succeeds → Proceed to write phase

#### 3. Write Phase

- If validation succeeds, local updates are applied to the actual database
- Changes become permanent and visible to other transactions
- Transaction commits

**Operations:**

```
- Copy local updates to database
- Make changes visible to other transactions
- Release all resources
- Transaction commits
```

### Example of Validation Protocol

```
T1 (TS=1):
  Read Phase:  READ(A), A = A - 50, RS(T1) = {A}, WS(T1) = {A}
  Validation:  Check conflicts with concurrent transactions → PASS
  Write Phase: WRITE(A) to database, COMMIT

T2 (TS=2):
  Read Phase:  READ(A), READ(B), RS(T2) = {A, B}, WS(T2) = {B}
  Validation:  Check WS(T1) ∩ RS(T2) = {A} ∩ {A, B} = {A} ≠ ∅
               Need to verify if T1 finished before T2 validation
               If yes → PASS, If no → FAIL (Rollback T2)
```

### Advantages

- **High concurrency:** No locks during read phase
- **No deadlocks:** Transactions don't wait for resources
- Better performance when conflicts are rare
- Read-only transactions never fail validation
- Good for read-heavy workloads

### Disadvantages

- **High rollback cost:** If validation fails, all work is wasted
- **Starvation possible:** Long transactions may repeatedly fail validation
- Not suitable for write-heavy workloads
- Validation overhead increases with transaction size
- Cascading aborts if many transactions conflict

### When to Use Validation Protocol

- Read-heavy workloads (few writes)
- Short transactions
- Low conflict probability
- Applications where conflict detection at commit time is acceptable

---

## Two-Phase Commit (2PC) Protocol

The Two-Phase Commit protocol is used in **distributed database systems** to ensure atomicity across multiple nodes. It coordinates the commit or abort decision for a transaction that spans multiple databases.

### Components

- **Coordinator:** Node that initiates and manages the commit process
- **Participants:** Nodes that execute portions of the distributed transaction

### Two Phases

#### Phase 1: Prepare Phase (Voting Phase)

1. **Coordinator sends PREPARE message** to all participants
2. **Each participant:**
    - Executes the transaction up to commit point
    - Writes transaction log to stable storage
    - Locks all affected resources
    - Responds with either:
        - **VOTE-COMMIT:** Ready to commit (has successfully prepared)
        - **VOTE-ABORT:** Cannot commit (encountered an error)
3. **Participant enters READY state** after voting commit and waits for coordinator's decision

#### Phase 2: Commit Phase (Decision Phase)

**Case 1: All participants vote COMMIT**

1. **Coordinator writes COMMIT decision** to its log
2. **Coordinator sends COMMIT message** to all participants
3. **Each participant:**
    - Writes COMMIT to its log
    - Makes changes permanent
    - Releases all locks
    - Sends ACK to coordinator
4. **Coordinator writes COMPLETE** to its log after receiving all ACKs

**Case 2: Any participant votes ABORT (or timeout occurs)**

1. **Coordinator writes ABORT decision** to its log
2. **Coordinator sends ABORT message** to all participants
3. **Each participant:**
    - Writes ABORT to its log
    - Undoes all changes
    - Releases all locks
    - Sends ACK to coordinator
4. **Coordinator writes COMPLETE** to its log

### Protocol Flow Diagram

```
Coordinator                  Participant 1              Participant 2
     |                            |                          |
     |-------- PREPARE ---------->|                          |
     |-------- PREPARE --------------------------->|
     |                            |                          |
     |<------ VOTE-COMMIT --------|                          |
     |<------ VOTE-COMMIT -----------------------------|
     |                            |                          |
  [Decision: All voted commit]
     |                            |                          |
     |-------- COMMIT ----------->|                          |
     |-------- COMMIT ---------------------------->|
     |                            |                          |
     |<------- ACK ---------------|                          |
     |<------- ACK -----------------------------------|
     |                            |                          |
  [Transaction Complete]
```

### Example Scenario

```
Distributed Transaction: Transfer $100 from Account A (Bank1) to Account B (Bank2)

Phase 1 (Prepare):
  Coordinator → Bank1: "PREPARE to deduct $100 from Account A"
  Bank1: Checks balance, locks Account A, writes log → "VOTE-COMMIT"
  
  Coordinator → Bank2: "PREPARE to add $100 to Account B"
  Bank2: Locks Account B, writes log → "VOTE-COMMIT"

Phase 2 (Commit):
  Coordinator: All voted commit, decision = COMMIT
  Coordinator → Bank1: "COMMIT"
  Bank1: Deducts $100, releases lock, "ACK"
  
  Coordinator → Bank2: "COMMIT"
  Bank2: Adds $100, releases lock, "ACK"
  
  Coordinator: Transaction complete!
```

### Failure Handling

#### Participant Failure During Prepare

- Coordinator doesn't receive vote → assumes VOTE-ABORT
- Coordinator sends ABORT to all participants

#### Participant Failure During Commit

- Participant recovers and checks its log
- If log shows READY state → contact coordinator for decision
- If log shows COMMIT → complete the commit
- If log shows ABORT → complete the abort

#### Coordinator Failure

- Participants in READY state are **blocked** (waiting for decision)
- Cannot commit or abort unilaterally
- Must wait for coordinator recovery or use timeout mechanisms
- This is the **blocking problem** of 2PC

### Advantages of 2PC

- Guarantees atomicity in distributed systems
- Ensures all nodes commit or all nodes abort (no partial commits)
- Well-understood and widely implemented protocol
- Works with heterogeneous database systems

### Disadvantages of 2PC

- **Blocking protocol:** Participants may be blocked waiting for coordinator
- **Single point of failure:** Coordinator failure blocks the system
- **High message overhead:** Requires multiple rounds of communication
- **Resource locking:** Resources locked during both phases (reduced concurrency)
- **Not partition-tolerant:** Network partitions can cause indefinite blocking

### Optimizations and Variants

#### Presumed Abort

- If coordinator has no record of transaction → presume it was aborted
- Reduces logging overhead for aborted transactions

#### Presumed Commit

- If coordinator has no record of transaction → presume it was committed
- Optimizes for the common case (most transactions commit)

#### Three-Phase Commit (3PC)

- Adds a "Pre-Commit" phase to reduce blocking
- More resilient to coordinator failures
- Higher message overhead

---

## Summary Table: Comparison of Protocols

|Protocol|Deadlock-Free|Prevents Cascading Rollback|Concurrency Level|Overhead|
|---|---|---|---|---|
|**Basic 2PL**|No|No|Medium|Low|
|**Strict 2PL**|No|Yes|Medium|Low|
|**Basic Timestamp**|Yes|No|High|Medium|
|**Strict Timestamp**|No|Yes|Medium|Medium|
|**Validation Protocol**|Yes|Yes|High (if few conflicts)|High|
|**2PC**|Depends on implementation|Yes|Low (distributed)|Very High|

---

## Key Takeaways

1. **Concurrency control is essential** for maintaining data consistency in multi-user database systems
    
2. **Lock-based protocols** (2PL) are most commonly used in practice due to their balance of simplicity and effectiveness
    
3. **Timestamp protocols** eliminate deadlocks but may have higher rollback rates
    
4. **Validation protocols** work well for read-heavy workloads with low conflict probability
    
5. **Two-Phase Commit** is the standard for ensuring atomicity in distributed transactions, despite its blocking nature
    
6. Different protocols have different trade-offs between **concurrency, complexity, and overhead**
    
7. Choice of protocol depends on:
    
    - Workload characteristics (read-heavy vs write-heavy)
    - System architecture (centralized vs distributed)
    - Performance requirements
    - Consistency guarantees needed

---

## Further Reading

- Database System Concepts (Silberschatz, Korth, Sudarshan)
- Transaction Processing: Concepts and Techniques (Gray, Reuter)
- Principles of Distributed Database Systems (Özsu, Valduriez)