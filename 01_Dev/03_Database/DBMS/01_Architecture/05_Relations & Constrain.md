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
# ER MODEL – COMPLETE NOTES (AKTU STYLE)

## PART 1: RELATIONSHIPS IN ER MODEL

---

## 1. Relationship Type

### Definition

A **Relationship Type** represents an **association between entity types** in an ER model.

- Shown using a **diamond (◇)**
- Describes **how entities are related**, not actual data
- Defines the structure of the relationship

### Notation

```
ENTITY1 ─── RELATIONSHIP ─── ENTITY2
```

### Example

```
STUDENT ─── ENROLLS ─── COURSE
```

- `ENROLLS` → Relationship Type
- `STUDENT`, `COURSE` → Entity Types

---

## 2. Relationship Set

### Definition

A **Relationship Set** is a **collection of relationship instances** of the same relationship type.

- Mathematical set of tuples connecting entities
- Each tuple represents one relationship instance

### Example

**Relationship Type:**

```
STUDENT ─── ENROLLS ─── COURSE
```

**Relationship Set (Instances):**

```
{ (S101, DBMS), (S102, OS), (S103, CN), (S101, CN) }
```

Each tuple (StudentID, CourseID) is one enrollment instance.

**Comparison:**

|Relationship Type|Relationship Set|
|---|---|
|Schema/Structure|Data/Instances|
|Defines association|Actual relationships|
|Like table structure|Like table rows|

---

## 3. Relationship Degree

### Definition

The **number of entity types** participating in a relationship is called **Relationship Degree**.

### Classification

|Degree|Name|Entity Count|Example|
|---|---|---|---|
|1|Unary/Recursive|1 entity type|Person marries Person|
|2|Binary|2 entity types|Student enrolls Course|
|3|Ternary|3 entity types|Supplier supplies Part to Project|
|n|N-ary|n entity types (n ≥ 3)|More than 3 entities|

**Most Common:** Binary relationships (90% of real-world scenarios)

---

## 4. Domain and Range

### Definition

- **Domain** → Set of possible **starting entities** in a relationship
- **Range** → Set of possible **ending entities** in a relationship

### For a Binary Relationship

```
A ─── R ─── B
```

- **Domain** = Entity set A
- **Range** = Entity set B

### Mathematical View

```
R: A → B
Domain(R) = A
Range(R) = B
```

### Example

```
STUDENT ─── ENROLLS ─── COURSE

Domain = {S101, S102, S103, ...}  (All students)
Range = {DBMS, OS, CN, ...}       (All courses)
```

---

## 5. Unary Relationship (Recursive Relationship)

### Definition

A **Unary (Recursive) Relationship** involves **only one entity type** related to itself.

### Characteristics

- **Degree = 1**
- Same entity set participates multiple times with different roles
- Also called **self-referencing relationship**

### Example

**EMPLOYEE supervises EMPLOYEE**

### Diagram

```
        ┌────────────┐
        │  EMPLOYEE  │
        └─────┬──────┘
              │
         SUPERVISES
            (◇)
              │
        ┌─────▼──────┐
        │  EMPLOYEE  │
        └────────────┘
```

### Role Names

```
EMPLOYEE (Supervisor) ─── SUPERVISES ─── EMPLOYEE (Subordinate)
```

### Domain & Range

```
Domain = EMPLOYEE
Range  = EMPLOYEE
```

Both refer to the same entity set, but different roles.

### Real-World Examples

1. **Person marries Person** (spouse relationship)
2. **Employee manages Employee** (manager-subordinate)
3. **Course is prerequisite for Course**
4. **City is connected to City** (flight routes)

### Representation in Table

```
EMPLOYEE
+---------+----------+---------------+
| EmpID   | Name     | SupervisorID  |
+---------+----------+---------------+
| 101     | Amit     | NULL          | (Top manager)
| 102     | Raj      | 101           | (Reports to Amit)
| 103     | Priya    | 101           | (Reports to Amit)
| 104     | Meera    | 102           | (Reports to Raj)
+---------+----------+---------------+
```

`SupervisorID` is a **foreign key** referencing `EmpID` in the same table.

---

## 6. Binary Relationship

### Definition

A **Binary Relationship** involves **two different entity types**.

### Characteristics

- **Degree = 2**
- Most common relationship type
- Connects two distinct entity sets

### Example

**STUDENT enrolls in COURSE**

### Diagram

```
┌───────────┐                        ┌───────────┐
│ STUDENT   │──────◇ ENROLLS ◇──────│  COURSE   │
└───────────┘                        └───────────┘
```

### Domain & Range Diagram

```
Domain (STUDENT)              Range (COURSE)

   STUDENT                       COURSE
   -------                       -------
   S101  ────────────────►       DBMS
   S102  ────────────────►       OS
   S103  ────────────────►       CN
   S101  ────────────────►       CN
```

### Components

- **Domain** = STUDENT entity set
- **Range** = COURSE entity set
- **Relationship Set** = { (S101, DBMS), (S102, OS), (S103, CN), (S101, CN) }

### More Examples

1. **EMPLOYEE works in DEPARTMENT**
2. **AUTHOR writes BOOK**
3. **CUSTOMER places ORDER**
4. **STUDENT borrows BOOK**

---

## 7. Ternary Relationship

### Definition

A **Ternary Relationship** involves **three entity types**.

### Characteristics

- **Degree = 3**
- Represents three-way association
- Cannot be decomposed into binary relationships without losing information

### Example

**SUPPLIER supplies PART to PROJECT**

Three entities:

1. SUPPLIER
2. PART
3. PROJECT

### Diagram

```
        ┌───────────┐
        │ SUPPLIER  │
        └─────┬─────┘
              │
        ┌─────▼─────┐
        │ SUPPLIES  │
        │    (◇)    │
        └─────┬─────┘
              │
   ┌──────────┴──────────┐
   ▼                      ▼
┌────────┐          ┌──────────┐
│  PART  │          │ PROJECT  │
└────────┘          └──────────┘
```

### Clearer Representation

```
           SUPPLIER
               │
               │
        ┌──────┴──────┐
        │   SUPPLIES  │
        │     (◇)     │
        └──────┬──────┘
         ╱           ╲
       ╱               ╲
    PART            PROJECT
```

### Domain & Range

For ternary relationships:

- **Domain** = Cartesian product of all three entity sets
- Each instance is a tuple: (Supplier, Part, Project)

### Example Instances

```
Relationship Set:
{ (S1, P1, Proj1), (S1, P2, Proj2), (S2, P1, Proj1), (S2, P3, Proj3) }
```

Meaning:

- Supplier S1 supplies Part P1 to Project Proj1
- Supplier S1 supplies Part P2 to Project Proj2
- etc.

### Why Not Binary?

Breaking into binary loses information:

```
WRONG APPROACH:
SUPPLIER ─── SUPPLIES ─── PART
SUPPLIER ─── WORKS_ON ─── PROJECT
PART ─── USED_IN ─── PROJECT
```

This doesn't capture **which supplier supplies which part to which project**.

### More Examples

1. **DOCTOR treats PATIENT with MEDICINE**
2. **TEACHER teaches SUBJECT to CLASS**
3. **EMPLOYEE works on PROJECT using TECHNOLOGY**

---

## 8. N-ary Relationship (Degree ≥ 3)

### Definition

An **N-ary Relationship** involves **three or more entity types**.

### Characteristics

- **Degree = n** where n ≥ 3
- Ternary is a special case (n = 3)
- Quaternary (n = 4), Quinary (n = 5), etc.

### Example (Quaternary - 4 entities)

**STUDENT takes EXAM in SUBJECT taught by TEACHER**

Entities:

1. STUDENT
2. EXAM
3. SUBJECT
4. TEACHER

### Diagram

```
       STUDENT
           │
           │
    ┌──────┴──────┐
    │    TAKES    │
    │     (◇)     │
    └──────┬──────┘
      ╱    │    ╲
    ╱      │      ╲
  EXAM  SUBJECT  TEACHER
```

### Domain & Range

- **Domain** = Combination of all participating entities
- Each instance is an n-tuple

### Example Instance

```
(Student101, Exam2023, DBMS, Prof_Sharma)
```

Meaning: Student101 takes Exam2023 in DBMS subject taught by Prof_Sharma

### Practical Note

- N-ary relationships with n > 3 are rare
- Usually can be redesigned using multiple ternary/binary relationships
- Complex to implement and understand

---

## 9. Summary Table

|Concept|Meaning|Notation|Example|
|---|---|---|---|
|**Relationship Type**|Logical association between entity types|Diamond (◇)|ENROLLS|
|**Relationship Set**|Collection of relationship instances|Set of tuples|{(S1, C1), (S2, C2)}|
|**Relationship Degree**|Number of entity types involved|1, 2, 3, n|Binary = 2|
|**Unary**|Entity related to itself|Degree = 1|SUPERVISES|
|**Binary**|Two entities involved|Degree = 2|ENROLLS|
|**Ternary**|Three entities involved|Degree = 3|SUPPLIES|
|**N-ary**|n entities (n ≥ 3)|Degree = n|n entities|
|**Domain**|Set of source entities|Entity Set A|STUDENT|
|**Range**|Set of target entities|Entity Set B|COURSE|

---

## 10. Degree Classification Quick Reference

```
Degree = 1  →  Unary      →  Employee supervises Employee
Degree = 2  →  Binary     →  Student enrolls Course
Degree = 3  →  Ternary    →  Supplier supplies Part to Project
Degree ≥ 3  →  N-ary      →  Complex multi-entity relationships
```

---

## PART 2: MAPPING CONSTRAINTS

---

## 1. What are Mapping Constraints?

### Definition

**Mapping Constraints** define **how entities from different entity sets participate in a relationship**.

### Purpose

- Restrict possible mappings between entities
- Define business rules
- Ensure data integrity
- Control relationship participation

### Types of Mapping Constraints

```
Mapping Constraints
        │
        ├─── Cardinality Ratio (Quantitative)
        │         ├─── One-to-One (1:1)
        │         ├─── One-to-Many (1:N)
        │         ├─── Many-to-One (N:1)
        │         └─── Many-to-Many (M:N)
        │
        └─── Participation Constraint (Qualitative)
                  ├─── Total Participation
                  └─── Partial Participation
```

---

## 2. CARDINALITY RATIO

### Definition

**Cardinality Ratio** specifies the **maximum number of relationship instances** that an entity can participate in.

It answers: "How many entities on one side can relate to how many on the other side?"

---

### (a) One-to-One (1:1)

#### Definition

Each entity in set A maps to **at most one** entity in set B, and vice-versa.

#### Notation

```
A (1) <──────> (1) B
```

#### ER Diagram

```
┌───────┐               ┌───────┐
│   A   │───── 1:1 ─────│   B   │
└───────┘               └───────┘
```

#### Detailed Diagram

```
PERSON                  PASSPORT
  │                        │
  P1 ─────────────────── PP1
  P2 ─────────────────── PP2
  P3 ─────────────────── PP3
```

#### Characteristics

- **One entity in A** relates to **exactly one entity in B**
- **One entity in B** relates to **exactly one entity in A**
- Bijective mapping (if total participation)

#### Real-World Examples

1. **PERSON has PASSPORT**
    
    - One person has exactly one passport
    - One passport belongs to exactly one person
2. **COUNTRY has CAPITAL**
    
    - One country has one capital city
    - One capital belongs to one country
3. **STUDENT has ROLL_NUMBER**
    
    - One student has one unique roll number
    - One roll number belongs to one student
4. **EMPLOYEE has EMPLOYEE_ID**
    

#### Implementation

```
PERSON                      PASSPORT
+---------+-------+         +------------+---------+
| PersonID| Name  |         | PassportNo | PersonID|
+---------+-------+         +------------+---------+
| P1      | Amit  |         | PP1        | P1      |
| P2      | Raj   |         | PP2        | P2      |
| P3      | Meera |         | PP3        | P3      |
+---------+-------+         +------------+---------+
                            FK references PersonID
```

**Note**: Foreign key can be in either table or both can be merged into one table.

---

### (b) One-to-Many (1:N)

#### Definition

One entity in A can be associated with **many** entities in B, but each entity in B maps to **at most one** entity in A.

#### Notation

```
A (1) <─────── (N) B
```

#### ER Diagram

```
┌───────┐               ┌───────┐
│   A   │───── 1:N ─────│   B   │
└───────┘               └───────┘
```

#### Detailed Diagram

```
DEPARTMENT              EMPLOYEE
    │                      │
    D1 ──────┬──────┬───── E1
             │      │
             │      └───── E2
             │
             └──────────── E3
    
    D2 ──────┬──────────── E4
             │
             └──────────── E5
```

#### Characteristics

- **One entity in A** can relate to **multiple entities in B**
- **Each entity in B** relates to **at most one entity in A**
- One-to-many from A's perspective
- Many-to-one from B's perspective

#### Real-World Examples

1. **DEPARTMENT has EMPLOYEE**
    
    - One department has many employees
    - Each employee belongs to one department
2. **TEACHER teaches STUDENT**
    
    - One teacher teaches many students
    - Each student is taught by one teacher (in context)
3. **CUSTOMER places ORDER**
    
    - One customer can place many orders
    - Each order belongs to one customer
4. **AUTHOR writes BOOK**
    
    - One author can write many books
    - Each book has one author (simplified)
5. **COMPANY has EMPLOYEE**
    
6. **MOTHER has CHILD**
    

#### Implementation

```
DEPARTMENT                  EMPLOYEE
+---------+----------+      +-------+-------+---------+
| DeptID  | DeptName |      | EmpID | Name  | DeptID  |
+---------+----------+      +-------+-------+---------+
| D1      | HR       |      | E1    | Amit  | D1      |
| D2      | IT       |      | E2    | Raj   | D1      |
+---------+----------+      | E3    | Meera | D1      |
                            | E4    | Priya | D2      |
                            | E5    | Rohit | D2      |
                            +-------+-------+---------+
                            FK references DeptID
```

**Key Point**: Foreign key is always on the **"Many" side** (in EMPLOYEE table).

---

### (c) Many-to-One (N:1)

#### Definition

Many entities in A map to **one** entity in B.

#### Notation

```
A (N) ──────> (1) B
```

#### ER Diagram

```
┌───────┐               ┌───────┐
│   A   │───── N:1 ─────│   B   │
└───────┘               └───────┘
```

#### Detailed Diagram

```
STUDENT                 MENTOR
    │                      │
    S1 ──────┬──────────── M1
             │
    S2 ──────┘
             
    S3 ──────┬──────────── M2
             │
    S4 ──────┘
```

#### Characteristics

- **Multiple entities in A** relate to **one entity in B**
- Reverse of One-to-Many
- From A's perspective: many-to-one
- From B's perspective: one-to-many

#### Real-World Examples

1. **STUDENT assigned to MENTOR**
    
    - Many students assigned to one mentor
    - One mentor guides many students
2. **EMPLOYEE reports to MANAGER**
    
    - Many employees report to one manager
3. **BOOK belongs to PUBLISHER**
    
    - Many books from one publisher

#### Implementation

```
STUDENT                     MENTOR
+--------+-------+---------+    +----------+-------+
| StudID | Name  | MentorID|    | MentorID | Name  |
+--------+-------+---------+    +----------+-------+
| S1     | Amit  | M1      |    | M1       | Prof A|
| S2     | Raj   | M1      |    | M2       | Prof B|
| S3     | Meera | M2      |    +----------+-------+
| S4     | Priya | M2      |
+--------+-------+---------+
FK references MentorID
```

**Note**: N:1 is the same as 1:N, just viewed from the opposite direction.

---

### (d) Many-to-Many (M:N)

#### Definition

Entities on both sides can have multiple associations.

#### Notation

```
A (M) <──────> (N) B
```

#### ER Diagram

```
┌───────┐               ┌───────┐
│   A   │───── M:N ─────│   B   │
└───────┘               └───────┘
```

#### Detailed Diagram

```
STUDENT                 COURSE
    │                      │
    S1 ──────┬──────────── C1
             │       ╱
             │     ╱
             │   ╱
    S2 ──────┼─╱─────────── C2
             │ ╲
             │   ╲
             │     ╲
    S3 ──────┴──────────── C3
```

Full mapping:

```
S1 → C1, C2
S2 → C1, C2, C3
S3 → C2, C3

C1 → S1, S2
C2 → S1, S2, S3
C3 → S2, S3
```

#### Characteristics

- **Multiple entities in A** relate to **multiple entities in B**
- **Multiple entities in B** relate to **multiple entities in A**
- Most flexible relationship
- Requires junction/bridge table for implementation

#### Real-World Examples

1. **STUDENT enrolls in COURSE**
    
    - One student enrolls in many courses
    - One course has many students
2. **AUTHOR writes BOOK**
    
    - One author writes many books
    - One book can have many authors
3. **ACTOR acts in MOVIE**
    
    - One actor acts in many movies
    - One movie has many actors
4. **DOCTOR treats PATIENT**
    
5. **PRODUCT in ORDER**
    

#### Implementation

**Cannot be directly represented in two tables**

Need a **Junction Table** (also called Bridge Table, Associative Table):

```
STUDENT                 ENROLLMENT (Junction)           COURSE
+---------+-------+     +---------+---------+    +----------+-----------+
| StudID  | Name  |     | StudID  | CourseID|    | CourseID | CourseName|
+---------+-------+     +---------+---------+    +----------+-----------+
| S1      | Amit  |     | S1      | C1      |    | C1       | DBMS      |
| S2      | Raj   |     | S1      | C2      |    | C2       | OS        |
| S3      | Meera |     | S2      | C1      |    | C3       | CN        |
+---------+-------+     | S2      | C2      |    +----------+-----------+
                        | S2      | C3      |
                        | S3      | C2      |
                        | S3      | C3      |
                        +---------+---------+
                        FK → StudID, CourseID
```

**Junction Table Contains**:

- Foreign key from STUDENT
- Foreign key from COURSE
- Optional: Additional attributes (enrollment date, grades, etc.)

---

## 3. Cardinality Ratio Summary Table

|Type|Notation|A → B|B → A|Example|FK Location|
|---|---|---|---|---|---|
|**1:1**|A (1) ↔ (1) B|One|One|Person-Passport|Either table or merge|
|**1:N**|A (1) → (N) B|One|Many|Department-Employee|B table (N side)|
|**N:1**|A (N) → (1) B|Many|One|Student-Mentor|A table (N side)|
|**M:N**|A (M) ↔ (N) B|Many|Many|Student-Course|Junction table|

---

## 4. PARTICIPATION CONSTRAINT

### Definition

**Participation Constraint** specifies **whether the existence of an entity depends on participation in a relationship** or not.

It describes the **qualitative nature** (mandatory vs optional) of entity participation.

### Purpose

- Define business rules
- Ensure referential integrity
- Control data consistency

---

### (a) Total Participation (Mandatory)

#### Definition

**Every entity** in the entity set **must** participate in at least one relationship instance.

Also called **Existence Dependency** or **Mandatory Participation**.

#### Notation

- Shown by **double line (==)** in ER Diagram

```
A ==───── R ───── B
```

Double line from A means: Total participation of A in R

#### ER Diagram

```
┌───────┐                        ┌───────┐
│   A   │=======◇ R ◇===========│   B   │
└───────┘                        └───────┘
   ││                               ││
   Total                          Total
```

#### Characteristics

- **Minimum cardinality = 1**
- Every entity must have at least one related entity
- Entity cannot exist without participating in relationship
- Also called **Mandatory Participation**

#### Example 1: EMPLOYEE works in DEPARTMENT

```
┌──────────┐                        ┌────────────┐
│ EMPLOYEE │========◇ WORKS ◇──────│ DEPARTMENT │
└──────────┘                        └────────────┘
    Total                              Partial
```

**Meaning:**

- **Total from EMPLOYEE side**: Every employee MUST work in a department
- **Partial from DEPARTMENT side**: A department can exist without employees (newly created dept)

#### Example 2: LOAN requires CUSTOMER

```
┌──────┐                        ┌──────────┐
│ LOAN │========◇ TAKEN ◇──────│ CUSTOMER │
└──────┘                        └──────────┘
  Total                           Partial
```

**Meaning:**

- Every loan MUST have a customer
- A customer may or may not have loans

#### Real-World Examples

1. **ORDER must have CUSTOMER**
    
    - Order cannot exist without customer
2. **EMPLOYEE must have DEPARTMENT**
    
    - Employee must belong to some department
3. **MARRIAGE requires TWO PERSONS**
    
    - Marriage cannot exist with less than two people
4. **COURSE must have INSTRUCTOR**
    
    - Course cannot run without instructor

#### Implementation Note

```
EMPLOYEE
+--------+-------+---------+
| EmpID  | Name  | DeptID  |
+--------+-------+---------+
| E1     | Amit  | D1      | DeptID is NOT NULL
| E2     | Raj   | D2      |
+--------+-------+---------+

DeptID FOREIGN KEY REFERENCES DEPARTMENT(DeptID) NOT NULL
```

**NOT NULL constraint** enforces total participation.

---

### (b) Partial Participation (Optional)

#### Definition

**Some entities** in the entity set **may or may not** participate in the relationship.

Also called **Optional Participation**.

#### Notation

- Shown by **single line (─)** in ER Diagram

```
A ───── R ───── B
```

Single line from A means: Partial participation of A in R

#### ER Diagram

```
┌───────┐                        ┌───────┐
│   A   │───────◇ R ◇───────────│   B   │
└───────┘                        └───────┘
   │                                │
 Partial                          Partial
```

#### Characteristics

- **Minimum cardinality = 0**
- Entity can exist without participating in relationship
- Participation is optional, not mandatory

#### Example 1: EMPLOYEE manages PROJECT

```
┌──────────┐                        ┌─────────┐
│ EMPLOYEE │────────◇ MANAGES ◇────│ PROJECT │
└──────────┘                        └─────────┘
  Partial                            Total
```

**Meaning:**

- **Partial from EMPLOYEE**: Not all employees manage projects
- **Total from PROJECT**: Every project must have a manager

#### Example 2: DEPARTMENT has EMPLOYEE

```
┌────────────┐                        ┌──────────┐
│ DEPARTMENT │─────◇ HAS ◇══════════│ EMPLOYEE │
└────────────┘                        └──────────┘
   Partial                               Total
```

**Meaning:**

- **Partial from DEPARTMENT**: Department can exist without employees (newly created)
- **Total from EMPLOYEE**: Every employee must belong to a department

#### Real-World Examples

1. **EMPLOYEE may manage PROJECT**
    
    - Not all employees are managers
2. **CUSTOMER may place ORDER**
    
    - New customer hasn't placed orders yet
3. **STUDENT may borrow BOOK**
    
    - Not all students have borrowed books
4. **PERSON may own CAR**
    
    - Not everyone owns a car

#### Implementation Note

```
EMPLOYEE
+--------+-------+------------+
| EmpID  | Name  | ProjectID  |
+--------+-------+------------+
| E1     | Amit  | P1         | Can be NULL
| E2     | Raj   | NULL       | Not managing any project
+--------+-------+------------+

ProjectID FOREIGN KEY REFERENCES PROJECT(ProjectID) NULL ALLOWED
```

**NULL allowed** means partial participation.

---

## 5. Combining Cardinality and Participation

### Notation

```
       Minimum, Maximum
A ──────── (min, max) ──────◇ R ◇───── B
```

**Common Combinations:**

|Notation|Meaning|Participation|Example|
|---|---|---|---|
|(0, 1)|Optional, at most one|Partial|Person may own Car|
|(1, 1)|Mandatory, exactly one|Total|Employee must have Department|
|(0, N)|Optional, can be many|Partial|Department may have Employees|
|(1, N)|Mandatory, at least one|Total|Order must have Products|

### Example Diagram

```
┌──────────┐ (1,1)          (0,N) ┌────────────┐
│ EMPLOYEE │========◇ WORKS ◇────│ DEPARTMENT │
└──────────┘                      └────────────┘
```

**Meaning:**

- **EMPLOYEE (1,1)**:
    
    - Minimum = 1 (Total participation)
    - Maximum = 1 (One department only)
    - Every employee works in exactly one department
- **DEPARTMENT (0,N)**:
    
    - Minimum = 0 (Partial participation)
    - Maximum = N (Many employees)
    - Department can have zero or more employees

---

## 6. Participation Constraint Summary

|Type|Symbol|Min|Meaning|NULL|Example|
|---|---|---|---|---|---|
|**Total**|Double line (==)|1|Mandatory|NOT NULL|Employee must have Department|
|**Partial**|Single line (─)|0|Optional|NULL allowed|Employee may manage Project|

---

## PART 3: KEYS AND FOREIGN KEYS

---

## 1. Foreign Key (FK)

### Definition

A **Foreign Key** is an attribute (or set of attributes) in one table that **refers to the Primary Key** of another table.

### Purpose

1. **Establish relationships** between tables
2. **Maintain referential integrity**
3. **Link related data** across tables
4. **Enforce data consistency**

### Characteristics

- FK value must exist in the referenced table (or be NULL if allowed)
- FK can have duplicate values (unlike PK)
- FK can be NULL (if partial participation)
- One table can have multiple FKs

### Notation

```
TABLE1( ..., ColumnX FK, ... )
TABLE2( ColumnX PK, ... )
```

ColumnX in TABLE1 references ColumnX in TABLE2

---

### Basic Example

```
STUDENT( StudentID PK, Name, DeptID FK )
                               ↓
DEPARTMENT( DeptID PK, DeptName )
```

**Tables:**

```
STUDENT
+-----------+-------+---------+
| StudentID | Name  | DeptID  |
+-----------+-------+---------+
| S1        | Amit  | D1      |  ← DeptID references DEPARTMENT
| S2        | Raj   | D2      |
| S3        | Meera | D1      |
+-----------+-------+---------+

DEPARTMENT
+---------+-----------+
| DeptID  | DeptName  |
+---------+-----------+
| D1      | CSE       |  ← Referenced by STUDENT
| D2      | ECE       |
+---------+-----------+
```

**Explanation:**

- `DeptID` in STUDENT is a Foreign Key
- It references `DeptID` (Primary Key) in DEPARTMENT
- Ensures every student belongs to a valid department

---

### Referential Integrity

**Definition:** Data consistency between related tables.

**Rule:** FK value must:

1. Exist in the parent table's PK column, OR
2. Be NULL (if allowed)

**Example Violations:**

```
STUDENT
+-----------+-------+---------+
| StudentID | Name  | DeptID  |
+-----------+-------+---------+
| S4        | Priya | D3      |  ✗ INVALID: D3 doesn't exist in DEPARTMENT
+-----------+-------+---------+
```

This will be rejected by DBMS.

---

## 2. Referential Integrity Rules

### What Happens When Parent Row is Modified/Deleted?

When a parent table row is updated or deleted, several actions are possible:

---

### (a) RESTRICT (NO ACTION)

**Definition:** Prevents deletion/update of parent if child rows exist.

**Behavior:**

- Operation is **blocked**
- Error message is shown
- No changes made

**Example:**

```sql
DELETE FROM DEPARTMENT WHERE DeptID = 'D1';
```

**Result:** ✗ ERROR

```
Cannot delete: STUDENT rows reference D1
```

**Use Case:**

- Prevent accidental deletion of important data
- Ensure data consistency

---

### (b) CASCADE

**Definition:** Automatically propagates changes to child rows.

**For DELETE CASCADE:**

- Deleting parent row **automatically deletes** all child rows

**Example:**

```
Before:
DEPARTMENT                  STUDENT
+---------+---------+      +------+------+---------+
| DeptID  | DeptName|      | SID  | Name | DeptID  |
+---------+---------+      +------+------+---------+
| D1      | CSE     |      | S1   | Amit | D1      |
| D2      | ECE     |      | S2   | Raj  | D1      |
+---------+---------+      | S3   | Meera| D2      |
                           +------+------+---------+

DELETE FROM DEPARTMENT WHERE DeptID = 'D1';

After:
DEPARTMENT                  STUDENT
+---------+---------+      +------+------+---------+
| DeptID  | DeptName|      | SID  | Name | DeptID  |
+---------+---------+      +------+------+---------+
| D2      | ECE     |      | S3   | Meera| D2      |
+---------+---------+      +------+------+---------+
```

S1 and S2 automatically deleted (CASCADE)

**For UPDATE CASCADE:**

- Updating parent PK **automatically updates** FK in child rows

```
UPDATE DEPARTMENT SET DeptID = 'D10' WHERE DeptID = 'D1';
```

All STUDENT rows with DeptID='D1' automatically updated to 'D10'

**Use Case:**

- Master-detail relationships
- When child cannot exist without parent

---

### (c) SET NULL

**Definition:** Sets FK to NULL when parent row is deleted/updated.

**Example:**

```
Before:
DEPARTMENT                  STUDENT
+---------+---------+      +------+------+---------+
| DeptID  | DeptName|      | SID  | Name | DeptID  |
+---------+---------+      +------+------+---------+
| D1      | CSE     |      | S1   | Amit | D1      |
| D2      | ECE     |      | S2   | Raj  | D1      |
+---------+---------+      +------+------+---------+

DELETE FROM DEPARTMENT WHERE DeptID = 'D1';

After:
DEPARTMENT                  STUDENT
+---------+---------+      +------+------+---------+
| DeptID  | DeptName|      | SID  | Name | DeptID  |
+---------+---------+      +------+------+---------+
| D2      | ECE     |      | S1   | Amit | NULL    |
+---------+---------+      | S2   | Raj  | NULL    |
                           +------+------+---------+
```

**Use Case:**

- When relationship is optional
- Child can exist independently

**Requirement:** FK column must allow NULL

---

### (d) SET DEFAULT

**Definition:** Sets FK to a default value when parent row is deleted/updated.

**Example:**

```sql
CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    DeptID INT DEFAULT 999,  -- 999 = "Unassigned"
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
        ON DELETE SET DEFAULT
);
```

```
DELETE FROM DEPARTMENT WHERE DeptID = 'D1';
```

All STUDENT rows with DeptID='D1' set to DeptID=999

**Use Case:**

- When a default fallback category exists
- Temporary unassigned state

---

## 3. Referential Integrity Summary Table

|Action|Parent Deleted|Child Rows|Use Case|
|---|---|---|---|
|**RESTRICT**|Blocked|Unchanged|Prevent accidental deletion|
|**CASCADE**|Allowed|Deleted automatically|Master-detail relationship|
|**SET NULL**|Allowed|FK set to NULL|Optional relationship|
|**SET DEFAULT**|Allowed|FK set to default|Fallback category exists|

---

## 4. SQL Syntax for Foreign Key

```sql
-- Method 1: Inline
CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES DEPARTMENT(DeptID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Method 2: Constraint name
CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    DeptID INT,
    CONSTRAINT fk_student_dept 
        FOREIGN KEY (DeptID) 
        REFERENCES DEPARTMENT(DeptID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Method 3: Composite FK
CREATE TABLE ENROLLMENT (
    StudentID INT,
    CourseID INT,
    Semester INT,
    Grade CHAR(2),
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);
```

---

## PART 4: RELATIONS (RELATIONAL MODEL)

---

## 1. What is a Relation?

### Definition

A **Relation** in DBMS is a **table** that stores data in a structured format.

### Mathematical Definition

A relation R is a subset of the Cartesian product of domains:

```
R ⊆ D₁ × D₂ × D₃ × ... × Dₙ
```

Where:

- D₁, D₂, ..., Dₙ are domains (sets of allowed values)
- n is the degree (number of attributes)

### Practical Definition

A relation is a two-dimensional table with:

- **Rows (Tuples)**: Individual records
- **Columns (Attributes)**: Properties/fields

---

## 2. Structure of a Relation

```
STUDENT Relation

+-----------+-----------+----------+--------+
| RollNo    | Name      | Marks    | City   |  ← Attributes (Columns)
+-----------+-----------+----------+--------+
| 101       | Arjun     | 90       | Delhi  |  ← Tuple (Row)
| 102       | Meera     | 86       | Mumbai |
| 103       | Raj       | 92       | Pune   |
+-----------+-----------+----------+--------+
    ↑           ↑          ↑          ↑
  Domain    Domain     Domain     Domain
  (Numbers) (Strings)  (Numbers)  (Strings)
```

### Components:

**1. Relation Name:** STUDENT

**2. Attributes (Columns):** RollNo, Name, Marks, City

**3. Tuples (Rows):** Each row is one record

**4. Domain:** Set of allowed values for each attribute

- RollNo: {101, 102, 103, ...}
- Name: {All valid names}
- Marks: {0-100}
- City: {All city names}

**5. Degree:** Number of attributes = 4

**6. Cardinality:** Number of tuples = 3

---

## 3. Characteristics of a Relation

### (a) Atomic Values

**Rule:** Each cell contains **only one value** (atomic value).

**Valid:**

```
+-----------+-------+
| StudentID | Name  |
+-----------+-------+
| S1        | Amit  |
| S2        | Raj   |
+-----------+-------+
```

**Invalid:**

```
+-----------+--------------+
| StudentID | Phone        |
+-----------+--------------+
| S1        | 9876, 8765   | ✗ Multiple values
+-----------+--------------+
```

**Solution:** Create separate table for multi-valued attributes

```
STUDENT                    PHONE
+-----------+-------+      +-----------+--------+
| StudentID | Name  |      | StudentID | Phone  |
+-----------+-------+      +-----------+--------+
| S1        | Amit  |      | S1        | 9876   |
| S2        | Raj   |      | S1        | 8765   |
+-----------+-------+      | S2        | 5432   |
                           +-----------+--------+
```

---

### (b) No Duplicate Tuples

**Rule:** All tuples must be **unique**.

**Valid:**

```
+-----------+-------+
| StudentID | Name  |
+-----------+-------+
| S1        | Amit  | ✓
| S2        | Raj   | ✓
+-----------+-------+
```

**Invalid:**

```
+-----------+-------+
| StudentID | Name  |
+-----------+-------+
| S1        | Amit  | ✓
| S1        | Amit  | ✗ Duplicate tuple
+-----------+-------+
```

**Reason:** Relations are **mathematical sets**, sets cannot have duplicates.

---

### (c) Row Order is Irrelevant

**Rule:** Order of tuples does **not** matter.

**Both are same relation:**

**Version 1:**

```
+-----------+-------+
| StudentID | Name  |
+-----------+-------+
| S1        | Amit  |
| S2        | Raj   |
| S3        | Meera |
+-----------+-------+
```

**Version 2:**

```
+-----------+-------+
| StudentID | Name  |
+-----------+-------+
| S3        | Meera |
| S1        | Amit  |
| S2        | Raj   |
+-----------+-------+
```

Both represent the **same relation**.

---

### (d) Column Order is Irrelevant

**Rule:** Order of attributes does **not** matter (theoretically).

**Version 1:**

```
+-----------+-------+--------+
| StudentID | Name  | Marks  |
+-----------+-------+--------+
```

**Version 2:**

```
+-------+-----------+--------+
| Name  | StudentID | Marks  |
+-------+-----------+--------+
```

Theoretically same, but in practice SQL preserves column order.

---

### (e) Each Attribute Must Have Unique Name

**Rule:** Within a relation, all attribute names must be **unique**.

**Valid:**

```
+-----------+-------------+-------+
| StudentID | StudentName | Marks |
+-----------+-------------+-------+
```

**Invalid:**

```
+-----------+------+------+
| StudentID | Name | Name | ✗ Duplicate attribute name
+-----------+------+------+
```

---

### (f) Domain Constraint

**Rule:** All values in a column must be from the **same domain**.

**Valid:**

```
STUDENT
+--------+-----+
| RollNo | Age |
+--------+-----+
| 101    | 20  | ✓ Integer
| 102    | 21  | ✓ Integer
+--------+-----+
```

**Invalid:**

```
STUDENT
+--------+-----+
| RollNo | Age |
+--------+-----+
| 101    | 20  | ✓
| 102    | ABC | ✗ String in integer domain
+--------+-----+
```

---

## 4. Relation Schema vs Relation Instance

### Relation Schema (Structure)

**Definition:** Structure/blueprint of the relation.

**Components:**

- Relation name
- Attribute names
- Domain for each attribute

**Example:**

```
STUDENT( StudentID: Integer, Name: String, Marks: Integer )
```

**Notation:**

```
RELATION_NAME(Attribute1, Attribute2, ..., Attributen)
```

---

### Relation Instance (Data)

**Definition:** Actual data in the relation at a particular moment.

**Example:**

```
+-----------+-------+--------+
| StudentID | Name  | Marks  |
+-----------+-------+--------+
| 101       | Amit  | 90     |
| 102       | Raj   | 86     |
+-----------+-------+--------+
```

**Changes over time** as data is inserted/updated/deleted.

---

### Comparison

|Aspect|Schema|Instance|
|---|---|---|
|**Nature**|Structure|Data|
|**Stability**|Static (rarely changes)|Dynamic (changes frequently)|
|**Example**|STUDENT(ID, Name, Marks)|Actual rows of data|
|**Analogy**|Class definition|Object instances|

---

## 5. Degree and Cardinality

### Degree

**Definition:** Number of **attributes (columns)** in a relation.

**Example:**

```
STUDENT( StudentID, Name, Marks, City )
```

Degree = 4 attributes

**Classification:**

- **Unary:** 1 attribute
- **Binary:** 2 attributes
- **Ternary:** 3 attributes
- **N-ary:** n attributes

---

### Cardinality

**Definition:** Number of **tuples (rows)** in a relation at a given time.

**Example:**

```
+-----------+-------+--------+------+
| StudentID | Name  | Marks  | City |
+-----------+-------+--------+------+
| 101       | Amit  | 90     | Delhi|
| 102       | Raj   | 86     | Pune |
| 103       | Meera | 92     | Mumbai|
+-----------+-------+--------+------+
```

Cardinality = 3 tuples

**Note:** Cardinality changes as data is added/removed.

---

## 6. Keys in a Relation

### Overview of Keys

```
Keys in Relational Model
    │
    ├─── Super Key
    │       └─── Candidate Key
    │               ├─── Primary Key
    │               └─── Alternate Key
    │
    ├─── Foreign Key
    │
    └─── Composite Key
```

---

### (a) Super Key

**Definition:** A set of attributes that **uniquely identifies** each tuple.

**Characteristics:**

- Can have extra attributes
- Not minimal
- Multiple super keys possible

**Example:**

```
STUDENT( StudentID, RollNo, Name, Email )
```

**Super Keys:**

1. {StudentID}
2. {RollNo}
3. {Email}
4. {StudentID, Name}
5. {StudentID, RollNo}
6. {StudentID, Name, Email}
7. {RollNo, Name} ... and many more

**Rule:** Super Key + any other attribute = Still a Super Key

---

### (b) Candidate Key

**Definition:** A **minimal super key** (no redundant attributes).

**Characteristics:**

- Uniquely identifies tuples
- No proper subset is a super key
- Can have multiple candidate keys

**Example:**

```
STUDENT( StudentID, RollNo, Name, Email )
```

**Candidate Keys:**

1. {StudentID} - minimal ✓
2. {RollNo} - minimal ✓
3. {Email} - minimal ✓

**Not Candidate Keys:**

- {StudentID, Name} - not minimal (Name is redundant)
- {StudentID, RollNo} - not minimal

**Properties:**

1. **Uniqueness:** No two tuples have same value
2. **Minimality:** Cannot remove any attribute

---

### (c) Primary Key (PK)

**Definition:** The **chosen candidate key** that uniquely identifies tuples.

**Characteristics:**

- **Only one** per relation
- **Cannot be NULL**
- **Cannot have duplicates**
- Used for referencing by foreign keys

**Notation:**

```
STUDENT( StudentID PK, RollNo, Name, Email )
```

**Selection Criteria:**

1. Should be minimal
2. Should not change frequently
3. Should not be NULL
4. Should be simple (fewer attributes better)

**Example:**

```
STUDENT
+-----------+--------+-------+-----------------+
| StudentID | RollNo | Name  | Email           |
+-----------+--------+-------+-----------------+
| S101      | 101    | Amit  | amit@email.com  | ← StudentID is PK
| S102      | 102    | Raj   | raj@email.com   |
+-----------+--------+-------+-----------------+
```

---

### (d) Alternate Key

**Definition:** Candidate keys that are **not chosen** as primary key.

**Example:**

```
STUDENT( StudentID PK, RollNo, Name, Email )
```

**Candidate Keys:**

- {StudentID} - **Chosen as Primary Key**
- {RollNo} - **Alternate Key**
- {Email} - **Alternate Key**

**Use:**

- Can be used for searching
- Can have UNIQUE constraint
- Backup identification method

---

### (e) Composite Key

**Definition:** A key consisting of **two or more attributes**.

**Example:**

```
ENROLLMENT( StudentID, CourseID, Semester, Grade )
```

**Composite Primary Key:** {StudentID, CourseID}

**Why?**

- StudentID alone not unique (one student, many courses)
- CourseID alone not unique (one course, many students)
- Together they uniquely identify each enrollment

**Another Example:**

```
FLIGHT_BOOKING( FlightNo, Date, SeatNo, PassengerID )
```

**Composite PK:** {FlightNo, Date, SeatNo}

---

### (f) Foreign Key (Already Covered in Part 3)

**Quick Recap:**

- References Primary Key of another table
- Maintains referential integrity
- Can have duplicates
- Can be NULL (if partial participation)

---

## 7. Key Hierarchy Diagram

```
Super Key (Largest Set)
    │
    └─── {StudentID, Name, Email}
    └─── {StudentID, Name}
    └─── {StudentID, Email}
    └─── {RollNo, Name}
         │
         ├─── Candidate Keys (Minimal)
         │      ├─── {StudentID} ──┐
         │      ├─── {RollNo}      ├─── Choose One
         │      └─── {Email}       │
         │                         │
         └─── Primary Key ←────────┘
                   │
                   └─── Alternate Keys (Others)
```

---

## 8. Complete Example

### Relation:

```
EMPLOYEE
+--------+-----------+-------+-----------+---------+
| EmpID  | SSN       | Name  | Email     | DeptID  |
+--------+-----------+-------+-----------+---------+
| E101   | 123456789 | Amit  | a@co.com  | D1      |
| E102   | 987654321 | Raj   | r@co.com  | D2      |
| E103   | 555555555 | Meera | m@co.com  | D1      |
+--------+-----------+-------+-----------+---------+
```

### Keys:

**Super Keys:**

- {EmpID}
- {SSN}
- {Email}
- {EmpID, Name}
- {EmpID, SSN}
- {SSN, Email}
- {EmpID, Name, Email} ... (many more)

**Candidate Keys:**

- {EmpID}
- {SSN}
- {Email}

**Primary Key:**

- {EmpID} (chosen)

**Alternate Keys:**

- {SSN}
- {Email}

**Foreign Key:**

- {DeptID} → References DEPARTMENT(DeptID)

**Degree:** 5 attributes

**Cardinality:** 3 tuples

---

## 9. Summary Table - Keys

|Key Type|Definition|Unique?|NULL?|Count|Example|
|---|---|---|---|---|---|
|**Super Key**|Set that uniquely identifies|Yes|Can be|Many|{ID, Name}|
|**Candidate Key**|Minimal super key|Yes|No|Multiple|{ID}, {Email}|
|**Primary Key**|Chosen candidate key|Yes|No|One|{ID}|
|**Alternate Key**|Non-chosen candidates|Yes|No|Multiple|{Email}|
|**Foreign Key**|References another PK|No|Can be|Multiple|{DeptID}|
|**Composite Key**|Multiple attributes|Yes|No|One or more|{ID, Date}|

---

## 10. Exam-Ready Quick Points

### Relationships:

1. **Relationship Type** = Association between entities (schema)
2. **Relationship Set** = Collection of instances (data)
3. **Degree** = Number of participating entities
4. **Unary** = Self-referencing (Employee supervises Employee)
5. **Binary** = Two entities (Student enrolls Course)
6. **Ternary** = Three entities (Supplier-Part-Project)

### Cardinality:

1. **1:1** = One-to-one (Person-Passport)
2. **1:N** = One-to-many (Department-Employee)
3. **M:N** = Many-to-many (Student-Course, needs junction table)

### Participation:

1. **Total** = Mandatory (double line ==, NOT NULL)
2. **Partial** = Optional (single line ─, NULL allowed)

### Keys:

1. **Primary Key** = Chosen unique identifier (one per table)
2. **Foreign Key** = References another table's PK
3. **Candidate Key** = Minimal unique identifier
4. **Alternate Key** = Non-chosen candidates
5. **Super Key** = Any set that uniquely identifies
6. **Composite Key** = Multiple attributes together

### Relations:

1. **Relation** = Table with rows and columns
2. **Tuple** = Row (single record)
3. **Attribute** = Column (property)
4. **Domain** = Set of allowed values
5. **Degree** = Number of columns
6. **Cardinality** = Number of rows

---

## 11. Memory Tricks for AKTU Exam

**For Keys:**

```
Super ⊃ Candidate ⊃ Primary
       ⊃ Alternate
Foreign = Reference to Primary
```

**For Cardinality:**

```
1:1 = Passport
1:N = Department-Employee
M:N = Student-Course (Junction needed)
```

**For Participation:**

```
== (Double line) = Must participate (NOT NULL)
─ (Single line) = May participate (NULL OK)
```

**For Relationship Degree:**

```
1 = Unary (Recursive)
2 = Binary (Most common)
3+ = Ternary/N-ary (Complex)
```

---

## 12. Common Exam Questions & Answers

### Q1: Difference between Relationship Type and Relationship Set?

**Answer:**

|Aspect|Relationship Type|Relationship Set|
|---|---|---|
|Nature|Schema/Structure|Data/Instances|
|Example|ENROLLS (structure)|{(S1,C1), (S2,C2)}|
|Changes|Rarely|Frequently|
|Like|Table definition|Table rows|

---

### Q2: Why is junction table needed for M:N relationship?

**Answer:** M:N cannot be directly represented in two tables because:

- FK in either table would require multiple values (violates 1NF)
- Junction table stores each association as separate row
- Example: STUDENT-COURSE needs ENROLLMENT table

---

### Q3: Difference between Primary Key and Candidate Key?

**Answer:**

- **Candidate Key:** All possible minimal unique identifiers
- **Primary Key:** One chosen candidate key
- Example: {ID}, {Email} are candidates; {ID} chosen as primary

---

### Q4: When is Total Participation used?

**Answer:** Total participation (==) when:

- Entity cannot exist without relationship
- Enforced with NOT NULL constraint
- Example: LOAN must have CUSTOMER

---

### Q5: Why Super Key is not used as Primary Key?

**Answer:**

- Super key can have redundant attributes
- Not minimal (violates minimality principle)
- Example: {ID, Name} is super key, but Name is redundant

---

## END OF COMPLETE ER MODEL NOTES

These notes cover: ✓ Relationships (Type, Set, Degree, Domain/Range) ✓ Unary, Binary, Ternary, N-ary relationships ✓ Cardinality Ratios (1:1, 1:N, M:N) ✓ Participation Constraints (Total/Partial) ✓ Foreign Keys and Referential Integrity ✓ Relations and their characteristics ✓ All types of Keys (Super, Candidate, Primary, Alternate, Composite, Foreign)

**Exam Ready:** 5-10 mark questions covered with diagrams and examples.