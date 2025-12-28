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

```
1. Functional Dependency (FD)
   ├── Definition & Notation
   ├── Real-World Example
   ├── Determinant vs Dependent
   └── Why FD Matters

2. Types of Attributes
   ├── Prime Attribute
   ├── Non-Prime Attribute
   └── Identification Process

3. Types of Functional Dependencies
   ├── Trivial FD
   ├── Non-Trivial FD
   ├── Partial Dependency
   ├── Full Dependency
   ├── Transitive Dependency
   └── Multivalued Dependency

4. Armstrong's Axioms
   ├── Primary Rules
   ├── Derived Rules
   └── Closure Computation

5. Keys in DBMS
   ├── Super Key
   ├── Candidate Key
   ├── Primary Key
   └── Finding Candidate Keys

6. Normalization Process
   ├── What is Normalization?
   ├── Why Normalize?
   └── Anomalies Explained

7. Normal Forms (1NF to BCNF)
   ├── First Normal Form (1NF)
   ├── Second Normal Form (2NF)
   ├── Third Normal Form (3NF)
   └── Boyce-Codd Normal Form (BCNF)

8. Numerical Problems
   ├── Finding Candidate Keys
   ├── Determining Normal Form
   └── Decomposition Examples
```

---

# 1. FUNCTIONAL DEPENDENCY (FD)

## Definition

A **Functional Dependency** X → Y exists when:

- For any two tuples (rows) in a relation
- If they have the same value for attribute(s) X
- They must have the same value for attribute(s) Y

**Mathematical Notation:**

```
X → Y
```

Where:

- **X** = Determinant (left-hand side)
- **Y** = Dependent (right-hand side)

---

## Real-World Example

Consider a company database:

```
┌─────────────────────────────────────────────────────────────────┐
│                     EMPLOYEE TABLE                              │
├────────┬───────────┬─────────┬─────────────┬──────────┬─────────┤
│ EmpID  │ EmpName   │ DeptID  │ DeptName    │ Salary   │ City    │
├────────┼───────────┼─────────┼─────────────┼──────────┼─────────┤
│ E101   │ Rahul     │ D1      │ CSE         │ 50000    │ Delhi   │
│ E102   │ Priya     │ D2      │ ECE         │ 45000    │ Mumbai  │
│ E103   │ Amit      │ D1      │ CSE         │ 52000    │ Delhi   │
│ E104   │ Sneha     │ D3      │ Mechanical  │ 48000    │ Pune    │
│ E105   │ Rohan     │ D2      │ ECE         │ 46000    │ Mumbai  │
└────────┴───────────┴─────────┴─────────────┴──────────┴─────────┘
```

### Functional Dependencies in this table:

```
┌──────────────────────────────────────────────┐
│  FUNCTIONAL DEPENDENCIES                     │
├──────────────────────────────────────────────┤
│  EmpID → EmpName                             │
│  EmpID → DeptID                              │
│  EmpID → Salary                              │
│  EmpID → City                                │
│  DeptID → DeptName                           │
│  EmpID → DeptName (via DeptID, transitive)   │
└──────────────────────────────────────────────┘
```

**Explanation:**

- `EmpID → EmpName`: Each employee ID uniquely determines employee name
- `EmpID → DeptID`: Each employee works in exactly one department
- `DeptID → DeptName`: Each department ID has exactly one department name
- `EmpID → DeptName`: This is transitive (EmpID → DeptID → DeptName)

---

## Determinant vs Dependent

```
        DETERMINANT          DEPENDENT
             ↓                   ↓
         ┌───────┐           ┌──────┐
         │ EmpID │  ──────→  │ Name │
         └───────┘           └──────┘
         
    "determines"          "is determined by"
```

### Visual Representation:

```
┌─────────────────────────────────────────────┐
│        FD: EmpID → EmpName                  │
├─────────────────────────────────────────────┤
│                                             │
│  If EmpID = E101 → EmpName = "Rahul"       │
│  If EmpID = E102 → EmpName = "Priya"       │
│  If EmpID = E103 → EmpName = "Amit"        │
│                                             │
│  Same EmpID ALWAYS gives same EmpName       │
└─────────────────────────────────────────────┘
```

---

## Why Functional Dependency Matters

```
                    FUNCTIONAL DEPENDENCY
                            |
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
   IDENTIFY KEYS      FIND ATTRIBUTES    NORMALIZATION
        |                   |                   |
    ┌───┴───┐          ┌────┴────┐        ┌────┴────┐
    │ Super │          │  Prime  │        │ Remove  │
    │ Key   │          │  Attrib │        │ Redund- │
    └───┬───┘          └────┬────┘        │ ancy    │
        │                   │             └────┬────┘
    ┌───┴────┐         ┌────┴────┐            │
    │ Candi- │         │ Non-    │       ┌────┴────┐
    │ date   │         │ Prime   │       │ Prevent │
    │ Key    │         │ Attrib  │       │ Anomaly │
    └───┬────┘         └─────────┘       └─────────┘
        │
    ┌───┴────┐
    │ Primary│
    │ Key    │
    └────────┘
```

---

# 2. TYPES OF ATTRIBUTES

## Prime Attribute

**Definition:** An attribute that is part of **at least one candidate key**.

## Non-Prime Attribute

**Definition:** An attribute that is **not part of any candidate key**.

---

## Example with Detailed Explanation

```
┌────────────────────────────────────────────────────────────┐
│           STUDENT_COURSE TABLE                             │
├────────────┬────────────┬──────────────┬──────────┬────────┤
│ StudentID  │ CourseID   │ StudentName  │ Grade    │ Year   │
├────────────┼────────────┼──────────────┼──────────┼────────┤
│ S101       │ C201       │ Rahul        │ A        │ 2024   │
│ S101       │ C202       │ Rahul        │ B        │ 2024   │
│ S102       │ C201       │ Priya        │ A        │ 2024   │
│ S103       │ C203       │ Amit         │ B        │ 2024   │
└────────────┴────────────┴──────────────┴──────────┴────────┘
```

### Step 1: Identify Functional Dependencies

```
FDs:
├── (StudentID, CourseID) → Grade
├── (StudentID, CourseID) → Year
├── StudentID → StudentName
└── (No other minimal FDs)
```

### Step 2: Find Candidate Key

```
Try: StudentID?
     StudentID+ = {StudentID, StudentName}
     Cannot determine CourseID, Grade, Year ✗

Try: (StudentID, CourseID)?
     (StudentID, CourseID)+ = {StudentID, CourseID, StudentName, Grade, Year}
     Can determine all attributes ✓

Candidate Key = (StudentID, CourseID)
```

### Step 3: Classify Attributes

```
┌──────────────────────────────────────────────────────┐
│  ATTRIBUTE CLASSIFICATION                            │
├──────────────────────────────────────────────────────┤
│                                                      │
│  PRIME ATTRIBUTES (part of candidate key):          │
│  ├── StudentID    ✓ (in candidate key)              │
│  └── CourseID     ✓ (in candidate key)              │
│                                                      │
│  NON-PRIME ATTRIBUTES (not in any candidate key):   │
│  ├── StudentName  ✗                                 │
│  ├── Grade        ✗                                 │
│  └── Year         ✗                                 │
└──────────────────────────────────────────────────────┘
```

---

# 3. TYPES OF FUNCTIONAL DEPENDENCIES

## Overview Diagram

```
                FUNCTIONAL DEPENDENCIES
                         |
        ┌────────────────┼────────────────┐
        ↓                ↓                ↓
    TRIVIAL        NON-TRIVIAL       SPECIAL TYPES
        |                |                |
        |                |          ┌─────┴─────┐
        |                |          ↓           ↓
        |                |      PARTIAL      FULL
        |                |          |           |
        |                |          ↓           ↓
        |                |    TRANSITIVE   MULTIVALUED
```

---

## 1. Trivial Functional Dependency

**Definition:** X → Y is trivial if Y ⊆ X (Y is subset of X)

**Characteristic:** Always true, provides no useful information

### Examples:

```
┌─────────────────────────────────────────────┐
│  TRIVIAL FD EXAMPLES                        │
├─────────────────────────────────────────────┤
│  1. (EmpID, DeptID) → EmpID                 │
│     RHS is part of LHS ✓                    │
│                                             │
│  2. (A, B, C) → B                           │
│     B is subset of (A, B, C) ✓              │
│                                             │
│  3. EmpName → EmpName                       │
│     Always true (reflexive) ✓               │
└─────────────────────────────────────────────┘
```

**Visual:**

```
    LHS: {A, B, C}
           ↓
    RHS: {B}        ← Subset of LHS = TRIVIAL
```

---

## 2. Non-Trivial Functional Dependency

**Definition:** X → Y is non-trivial if Y ⊄ X (Y is not subset of X)

**Characteristic:** Provides meaningful information

### Examples:

```
┌─────────────────────────────────────────────┐
│  NON-TRIVIAL FD EXAMPLES                    │
├─────────────────────────────────────────────┤
│  1. EmpID → EmpName                         │
│     EmpName is not part of EmpID ✓          │
│                                             │
│  2. DeptID → DeptName                       │
│     DeptName is not part of DeptID ✓        │
│                                             │
│  3. (StudentID, CourseID) → Grade           │
│     Grade is not in LHS ✓                   │
└─────────────────────────────────────────────┘
```

**Visual:**

```
    LHS: {EmpID}
           ↓
    RHS: {EmpName}  ← Not in LHS = NON-TRIVIAL
```

---

## 3. Partial Dependency

**Definition:** A non-prime attribute depends on **proper subset** of a composite candidate key.

**Problem:** Violates 2NF

### Example:

```
┌──────────────────────────────────────────────────────────┐
│        ENROLLMENT TABLE (Not in 2NF)                     │
├────────────┬────────────┬──────────────┬─────────────────┤
│ StudentID  │ CourseID   │ StudentName  │ Grade           │
│ (PK part)  │ (PK part)  │              │                 │
├────────────┼────────────┼──────────────┼─────────────────┤
│ S101       │ C201       │ Rahul        │ A               │
│ S101       │ C202       │ Rahul        │ B               │
│ S102       │ C201       │ Priya        │ A               │
└────────────┴────────────┴──────────────┴─────────────────┘

Candidate Key: (StudentID, CourseID)
```

### Functional Dependencies:

```
┌────────────────────────────────────────────────────┐
│  FD ANALYSIS                                       │
├────────────────────────────────────────────────────┤
│                                                    │
│  1. (StudentID, CourseID) → Grade                 │
│     Full dependency ✓ (needs both parts of key)   │
│                                                    │
│  2. StudentID → StudentName                       │
│     Partial dependency ✗ (only part of key)       │
│                                                    │
│  Problem: StudentName depends on PART of key      │
│           not the WHOLE key                       │
└────────────────────────────────────────────────────┘
```

**Visual Representation:**

```
        Candidate Key
            ↓
    ┌──────────────────┐
    │ StudentID        │
    │      +           │
    │ CourseID         │
    └────┬─────────┬───┘
         │         │
         │         └─────────→ Grade (Full Dependency ✓)
         │
         └─────────────────→ StudentName (Partial Dependency ✗)
                            depends only on StudentID
```

---

## 4. Full Functional Dependency

**Definition:** A non-prime attribute depends on the **entire composite key**, not on any proper subset.

**Goal:** Required for 2NF

### Example:

```
┌──────────────────────────────────────────────────────────┐
│     MARKS TABLE (Full Dependency)                        │
├────────────┬────────────┬─────────────────────────────────┤
│ StudentID  │ CourseID   │ Grade                          │
│ (PK part)  │ (PK part)  │                                │
├────────────┼────────────┼─────────────────────────────────┤
│ S101       │ C201       │ A                              │
│ S101       │ C202       │ B                              │
│ S102       │ C201       │ A                              │
└────────────┴────────────┴─────────────────────────────────┘

FD: (StudentID, CourseID) → Grade
```

**Visual:**

```
    ┌─────────────────────┐
    │ StudentID           │
    │        +            │  ───────→  Grade
    │ CourseID            │            (needs BOTH)
    └─────────────────────┘
    
    Cannot determine Grade with:
    - StudentID alone ✗
    - CourseID alone ✗
    - Need BOTH ✓
```

---

## 5. Transitive Dependency

**Definition:** If A → B and B → C, then A → C (indirect dependency)

**Problem:** Violates 3NF

### Example:

```
┌──────────────────────────────────────────────────────────────┐
│           EMPLOYEE TABLE (Has Transitive Dependency)         │
├────────┬───────────┬─────────┬─────────────┬──────────────────┤
│ EmpID  │ EmpName   │ DeptID  │ DeptName    │ DeptLocation     │
├────────┼───────────┼─────────┼─────────────┼──────────────────┤
│ E101   │ Rahul     │ D1      │ CSE         │ Building A       │
│ E102   │ Priya     │ D2      │ ECE         │ Building B       │
│ E103   │ Amit      │ D1      │ CSE         │ Building A       │
└────────┴───────────┴─────────┴─────────────┴──────────────────┘
```

### Functional Dependencies:

```
┌────────────────────────────────────────────────────┐
│  TRANSITIVE DEPENDENCY CHAIN                       │
├────────────────────────────────────────────────────┤
│                                                    │
│  Direct FDs:                                       │
│  ├── EmpID → EmpName     ✓                        │
│  ├── EmpID → DeptID      ✓                        │
│  ├── DeptID → DeptName   ✓                        │
│  └── DeptID → DeptLocation ✓                      │
│                                                    │
│  Transitive FDs:                                   │
│  ├── EmpID → DeptName (via DeptID) ✗              │
│  └── EmpID → DeptLocation (via DeptID) ✗          │
│                                                    │
│  Problem: Non-prime → Non-prime dependency        │
└────────────────────────────────────────────────────┘
```

**Visual Chain:**

```
    EmpID ────→ DeptID ────→ DeptName
      A            B            C
      
    Therefore: EmpID ────────────→ DeptName
                     (Transitive)
                     
    ┌─────────┐      ┌────────┐      ┌──────────┐
    │  EmpID  │ ───→ │ DeptID │ ───→ │ DeptName │
    └─────────┘      └────────┘      └──────────┘
         └──────────────────────────────────→
                  (Transitive Path)
```

---

## 6. Multivalued Dependency (MVD)

**Definition:** X →→ Y means for each X value, there's a set of Y values independent of other attributes.

**Notation:** X →→ Y (double arrow)

### Example:

```
┌──────────────────────────────────────────────────────────┐
│         STUDENT_SKILLS_HOBBIES TABLE                     │
├────────────┬──────────────┬───────────────────────────────┤
│ StudentID  │ Skill        │ Hobby                        │
├────────────┼──────────────┼───────────────────────────────┤
│ S101       │ Java         │ Cricket                      │
│ S101       │ Java         │ Reading                      │
│ S101       │ Python       │ Cricket                      │
│ S101       │ Python       │ Reading                      │
│ S102       │ C++          │ Football                     │
│ S102       │ C++          │ Music                        │
└────────────┴──────────────┴───────────────────────────────┘
```

### Multivalued Dependencies:

```
┌────────────────────────────────────────────────────┐
│  MVD ANALYSIS                                      │
├────────────────────────────────────────────────────┤
│                                                    │
│  StudentID →→ Skill                               │
│  StudentID →→ Hobby                               │
│                                                    │
│  Characteristics:                                  │
│  ├── Skills and Hobbies are independent           │
│  ├── Each student can have multiple skills        │
│  ├── Each student can have multiple hobbies       │
│  └── Cartesian product created                    │
│                                                    │
│  Problem: Data redundancy                         │
│  Solution: Decompose into separate tables (4NF)   │
└────────────────────────────────────────────────────┘
```

**Visual:**

```
        StudentID: S101
              |
      ┌───────┴───────┐
      ↓               ↓
   Skills          Hobbies
   ├─ Java        ├─ Cricket
   └─ Python      └─ Reading
   
   Creates: 2 × 2 = 4 rows (Cartesian product)
```

---

# 4. ARMSTRONG'S AXIOMS

## Overview

Armstrong's Axioms are inference rules to derive all functional dependencies from a given set.

```
                ARMSTRONG'S AXIOMS
                        |
        ┌───────────────┼───────────────┐
        ↓               ↓               ↓
    PRIMARY         DERIVED         CLOSURE
     RULES           RULES         COMPUTATION
        |               |               |
    ┌───┴───┐       ┌───┴───┐       ┌──┴──┐
    │ Reflex│       │ Union │       │ X+  │
    │ Augmt │       │ Decomp│       │Find │
    │ Transit       │ Pseudo│       │ All │
    └───────┘       └───────┘       └─────┘
```

---

## Primary Rules (Basic Axioms)

### 1. Reflexive Rule (Reflexivity)

**Rule:** If Y ⊆ X, then X → Y

**In simple words:** A set of attributes always determines its subsets.

**Examples:**

```
┌────────────────────────────────────────────────────┐
│  REFLEXIVE RULE EXAMPLES                           │
├────────────────────────────────────────────────────┤
│                                                    │
│  1. (A, B, C) → A         ✓                       │
│  2. (A, B, C) → (A, B)    ✓                       │
│  3. (EmpID, DeptID) → EmpID  ✓                    │
│  4. StudentName → StudentName  ✓                   │
│                                                    │
│  Always true, trivial dependencies                 │
└────────────────────────────────────────────────────┘
```

**Visual:**

```
    Set X = {A, B, C}
              ↓
    Subset Y = {A, B}
    
    X → Y is always valid (Reflexive)
```

---

### 2. Augmentation Rule (Augmentation)

**Rule:** If X → Y, then XZ → YZ

**In simple words:** Adding same attributes to both sides preserves the dependency.

**Examples:**

```
┌────────────────────────────────────────────────────────┐
│  AUGMENTATION RULE EXAMPLES                            │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Given: EmpID → EmpName                                │
│                                                        │
│  Add DeptID to both sides:                             │
│  Result: (EmpID, DeptID) → (EmpName, DeptID)          │
│                                                        │
│  Given: A → B                                          │
│  Add C to both sides:                                  │
│  Result: (A, C) → (B, C)                              │
└────────────────────────────────────────────────────────┘
```

**Visual:**

```
    Original:  X ───→ Y
                ↓      ↓
    Add Z:     XZ ──→ YZ
    
    Example:
    EmpID ────────────→ EmpName
       ↓                   ↓
    (EmpID, Dept) ──→ (EmpName, Dept)
```

---

### 3. Transitive Rule (Transitivity)

**Rule:** If X → Y and Y → Z, then X → Z

**In simple words:** Dependencies chain together.

**Examples:**

```
┌────────────────────────────────────────────────────────┐
│  TRANSITIVE RULE EXAMPLES                              │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Example 1:                                            │
│  ├── EmpID → DeptID        (Given)                    │
│  ├── DeptID → DeptName     (Given)                    │
│  └── EmpID → DeptName      (Derived by transitivity)  │
│                                                        │
│  Example 2:                                            │
│  ├── A → B                 (Given)                    │
│  ├── B → C                 (Given)                    │
│  └── A → C                 (Derived by transitivity)  │
└────────────────────────────────────────────────────────┘
```

**Visual:**

```
    EmpID ──→ DeptID ──→ DeptName
      └──────────────────────→
         (Transitive Path)
         
    Chain:
    ┌────────┐    ┌────────┐    ┌──────────┐
    │ EmpID  │──→│ DeptID │──→│ DeptName │
    └────────┘    └────────┘    └──────────┘
        └────────────────────────────→
              (Derived FD: EmpID → DeptName)
```

---

## Derived Rules (Secondary Axioms)

### 4. Union Rule

**Rule:** If X → Y and X → Z, then X → YZ

**In simple words:** Multiple dependencies from same determinant can be combined.

**Examples:**

```
┌────────────────────────────────────────────────────────┐
│  UNION RULE EXAMPLES                                   │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Given:                                                │
│  ├── EmpID → EmpName                                  │
│  └── EmpID → Salary                                   │
│                                                        │
│  Union:                                                │
│  └── EmpID → (EmpName, Salary)                        │
│                                                        │
│  Given:                                                │
│  ├── A → B                                            │
│  └── A → C                                            │
│                                                        │
│  Union:                                                │
│  └── A → BC                                           │
└────────────────────────────────────────────────────────┘
```

**Visual:**

```
         EmpID
           |
      ┌────┴────┐
      ↓         ↓
   EmpName   Salary
   
   Combine:
   
      EmpID ──→ (EmpName, Salary)
```

---

### 5. Decomposition Rule

**Rule:** If X → YZ, then X → Y and X → Z

**In simple words:** Combined dependencies can be split.

**Examples:**

```
┌────────────────────────────────────────────────────────┐
│  DECOMPOSITION RULE EXAMPLES                           │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Given:                                                │
│  └── EmpID → (EmpName, Salary)                        │
│                                                        │
│  Decompose:                                            │
│  ├── EmpID → EmpName                                  │
│  └── EmpID → Salary                                   │
│                                                        │
│  Given:                                                │
│  └── A → BC                                           │
│                                                        │
│  Decompose:                                            │
│  ├── A → B                                            │
│  └── A → C                                            │
└────────────────────────────────────────────────────────┘
```

**Visual:**

```
   EmpID ──→ (EmpName, Salary)
      |
      └──→ Split into:
           ├── EmpID → EmpName
           └── EmpID → Salary
```

---

### 6. Pseudo-Transitive Rule

**Rule:** If X → Y and WY → Z, then WX → Z

**In simple words:** Partial overlap in dependencies allows inference.

**Examples:**

```
┌────────────────────────────────────────────────────────┐
│  PSEUDO-TRANSITIVE RULE EXAMPLES                       │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Given:                                                │
│  ├── A → B                                            │
│  └── (C, B) → D                                       │
│                                                        │
│  Derive:                                               │
│  └── (A, C) → D                                       │
│                                                        │
│  Explanation:                                          │
│  Since A determines B, and (C, B) determines D,       │
│  then (A, C) can determine D                          │
└────────────────────────────────────────────────────────┘
```

---

## Closure Computation (Finding X+)

**Definition:** X+ is the set of all attributes that can be determined by X.

### Algorithm:

```
┌────────────────────────────────────────────────────────┐
│  CLOSURE ALGORITHM                                     │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Step 1: Result = X (start with X itself)             │
│                                                        │
│  Step 2: For each FD Y → Z:                           │
│          If Y ⊆ Result:                               │
│             Add Z to Result                           │
│                                                        │
│  Step 3: Repeat Step 2 until no more attributes       │
│          can be added                                  │
│                                                        │
│  Step 4: Result = X+                                  │
└────────────────────────────────────────────────────────┘
```

### Detailed Example:

```
Given Relation: R(A, B, C, D, E)
FDs:
├── A → BC
├── CD → E
├── B → D
└── E → A

Find: A+
```

**Step-by-Step Solution:**

```
┌────────────────────────────────────────────────────────┐
│  FINDING CLOSURE OF A (A+)                            │
├──────┬──────────────────────────────┬──────────────────┤
│ Step │ Current Result               │ FD Applied       │
├──────┼──────────────────────────────┼──────────────────┤
│  0   │ {A}                          │ Initial          │
├──────┼──────────────────────────────┼──────────────────┤
│  1   │ {A, B, C}                    │ A → BC           │
│      │ (A is in result, add BC)     │                  │
├──────┼──────────────────────────────┼──────────────────┤
│  2   │ {A, B, C, D}                 │ B → D            │
│      │ (B is in result, add D)      │                  │
├──────┼──────────────
```
