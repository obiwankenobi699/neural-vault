---
title:
  "{ Title }":
tags:
  - theory
  - "{ Subject }":
  - semester_notes
created:
  "{ date }":
updated:
  "{ date }":
---

## Complete Theory Guide

---

## Table of Contents

1. [Relational Data Model](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#relational-data-model)
2. [Integrity Constraints](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#integrity-constraints)
3. [Relational Algebra](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#relational-algebra)
4. [Relational Calculus](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#relational-calculus)
5. [Tuple and Domain Calculus](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#tuple-and-domain-calculus)
6. [SQL Introduction](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#sql-introduction)
7. [SQL Data Types and Literals](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#sql-data-types-and-literals)
8. [SQL Commands](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#sql-commands)
9. [SQL Operators](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#sql-operators)
10. [Database Objects](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#database-objects)
11. [Queries and Sub-Queries](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#queries-and-sub-queries)
12. [Aggregate Functions](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#aggregate-functions)
13. [DML Operations](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#dml-operations)
14. [Set Operations](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#set-operations)
15. [Advanced SQL Features](https://claude.ai/chat/2bb45d7a-775d-4e65-b19f-b464be367530#advanced-sql-features)

---

## Relational Data Model

### Fundamental Concepts

The relational data model represents data as a collection of relations (tables). Each relation consists of tuples (rows) containing attributes (columns).

**Key Components:**

A relation R is defined as a subset of the Cartesian product of domains:

```
R ⊆ D₁ × D₂ × D₃ × ... × Dₙ

Where:
- R = Relation name
- Dᵢ = Domain of attribute i
- n = Degree (number of attributes)
```

**Relation Schema:**

```
STUDENT(StudentID, Name, Age, Department, GPA)
         ↑         ↑     ↑       ↑         ↑
      Attributes (columns)
```

**Relation Instance:**

```
+------------+----------+-----+------------+------+
| StudentID  | Name     | Age | Department | GPA  |
+------------+----------+-----+------------+------+
| S001       | Alice    | 20  | CS         | 3.8  |
| S002       | Bob      | 21  | EE         | 3.5  |
| S003       | Carol    | 19  | CS         | 3.9  |
+------------+----------+-----+------------+------+
```

### Properties of Relations

**1. Atomic Values:** Each cell contains a single, indivisible value **2. Unique Rows:** No duplicate tuples in a relation **3. Unordered Tuples:** Row order is insignificant **4. Unordered Attributes:** Column order is insignificant (logically) **5. Named Attributes:** Each column has a unique name

### Relational Model Architecture

```
┌─────────────────────────────────────────────────┐
│            RELATIONAL DATABASE                  │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐      ┌──────────────┐       │
│  │  RELATION 1  │      │  RELATION 2  │       │
│  │  (TABLE)     │      │  (TABLE)     │       │
│  ├──────────────┤      ├──────────────┤       │
│  │ Tuple 1      │      │ Tuple 1      │       │
│  │ Tuple 2      │      │ Tuple 2      │       │
│  │ Tuple 3      │      │ Tuple 3      │       │
│  │ ...          │      │ ...          │       │
│  └──────────────┘      └──────────────┘       │
│         ↓                      ↓               │
│    Attributes              Attributes          │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Terminology Mapping

```
Formal Term          Common Term          Description
─────────────────────────────────────────────────────
Relation             Table                Collection of data
Tuple                Row/Record           Single data entry
Attribute            Column/Field         Property of entity
Cardinality          Number of Rows       Total tuples
Degree               Number of Columns    Total attributes
Domain               Data Type            Valid value set
Relation Schema      Table Definition     Structure
Relation Instance    Table Data           Actual data
```

---

## Integrity Constraints

Integrity constraints are rules that ensure data accuracy, consistency, and validity in the database.

### Types of Integrity Constraints

```
                 INTEGRITY CONSTRAINTS
                         |
        ┌────────────────┼────────────────┐
        |                |                |
    DOMAIN          KEY             REFERENTIAL
   CONSTRAINTS   CONSTRAINTS       CONSTRAINTS
        |                |                |
        |         ┌──────┴──────┐         |
        |         |             |         |
        |    SUPER KEY    PRIMARY KEY    FOREIGN KEY
        |         |             |         
        |    CANDIDATE KEY      |
        |                       |
        └───────────────────────┴─────────────┐
                                              |
                                    ENTITY INTEGRITY
```

### 1. Domain Constraints

Domain constraints specify the permissible values for an attribute.

**Definition:**

```
Domain Constraint: ∀t ∈ R, t[A] ∈ dom(A)

Where:
- t = tuple
- R = relation
- A = attribute
- dom(A) = domain of attribute A
```

**Examples:**

```sql
Age INT CHECK (Age >= 0 AND Age <= 120)
Grade CHAR(1) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F'))
Email VARCHAR(100) CHECK (Email LIKE '%@%.%')
Salary DECIMAL(10,2) CHECK (Salary > 0)
```

**Visual Representation:**

```
Domain of Age: {0, 1, 2, 3, ..., 120}
Domain of Grade: {'A', 'B', 'C', 'D', 'F'}
Domain of Boolean: {TRUE, FALSE}
Domain of Date: {valid dates in YYYY-MM-DD format}
```

### 2. Key Constraints

**Super Key:** A set of attributes that uniquely identifies tuples

```
SK = {A₁, A₂, ..., Aₙ}
∀t₁, t₂ ∈ R: t₁[SK] ≠ t₂[SK] → t₁ ≠ t₂
```

**Candidate Key:** Minimal super key (no subset is a super key)

```
CK ⊆ SK where no proper subset of CK is a super key
```

**Primary Key:** Selected candidate key for identification

```
PK ∈ {CK₁, CK₂, ..., CKₙ}
```

**Key Hierarchy:**

```
        ┌─────────────────┐
        │   SUPER KEYS    │
        │  (All possible  │
        │  unique combos) │
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │ CANDIDATE KEYS  │
        │   (Minimal      │
        │   super keys)   │
        └────────┬────────┘
                 │
        ┌────────▼────────┐
        │  PRIMARY KEY    │
        │   (Selected     │
        │   candidate)    │
        └─────────────────┘
```

**Example:**

```
STUDENT(StudentID, Email, Phone, Name, Age)

Super Keys:
  - {StudentID}
  - {Email}
  - {StudentID, Name}
  - {Email, Phone}
  - {StudentID, Email, Name, Age}
  ... and many more

Candidate Keys:
  - {StudentID}
  - {Email}

Primary Key:
  - {StudentID}  [chosen as PK]

Alternate Keys:
  - {Email}  [not chosen as PK]
```

### 3. Entity Integrity

**Rule:** Primary key attributes cannot be NULL

**Formal Definition:**

```
∀t ∈ R: t[PK] ≠ NULL

Where:
- t = tuple in relation R
- PK = primary key attribute(s)
- NULL = absence of value
```

**Visual:**

```
EMPLOYEE Table
+--------+--------+------------+
| EmpID  | Name   | Department |  ← EmpID is Primary Key
+--------+--------+------------+
| E001   | John   | Sales      |  ✓ Valid
| E002   | Mary   | IT         |  ✓ Valid
| NULL   | Bob    | HR         |  ✗ INVALID (NULL PK)
+--------+--------+------------+
```

### 4. Referential Integrity

**Rule:** Foreign key must reference an existing primary key value or be NULL

**Formal Definition:**

```
∀t ∈ R₁: t[FK] ≠ NULL → ∃s ∈ R₂: s[PK] = t[FK]

Where:
- R₁ = referencing relation
- R₂ = referenced relation
- FK = foreign key in R₁
- PK = primary key in R₂
```

**Referential Integrity Actions:**

```
ON DELETE:
  - CASCADE:    Delete related tuples
  - SET NULL:   Set FK to NULL
  - SET DEFAULT: Set FK to default value
  - NO ACTION:  Reject deletion
  - RESTRICT:   Same as NO ACTION

ON UPDATE:
  - CASCADE:    Update related FKs
  - SET NULL:   Set FK to NULL
  - SET DEFAULT: Set FK to default value
  - NO ACTION:  Reject update
  - RESTRICT:   Same as NO ACTION
```

**Example with Two Tables:**

```
DEPARTMENT (Primary Table)
+--------+-----------+
| DeptID | DeptName  |  ← PK
+--------+-----------+
| D01    | IT        |
| D02    | Sales     |
+--------+-----------+

EMPLOYEE (Foreign Table)
+--------+--------+--------+
| EmpID  | Name   | DeptID |  ← FK references DEPARTMENT(DeptID)
+--------+--------+--------+
| E001   | Alice  | D01    |  ✓ Valid (D01 exists)
| E002   | Bob    | D02    |  ✓ Valid (D02 exists)
| E003   | Carol  | D99    |  ✗ INVALID (D99 doesn't exist)
| E004   | Dave   | NULL   |  ✓ Valid (NULL allowed)
+--------+--------+--------+
```

**Referential Integrity Graph:**

```
    DEPARTMENT                    EMPLOYEE
    ┌──────────┐                 ┌──────────┐
    │ DeptID   │◄────────────────│ DeptID   │
    │ DeptName │   (References)  │ EmpID    │
    └──────────┘                 │ Name     │
        PK                       └──────────┘
                                      FK
```

---

## Relational Algebra

Relational Algebra is a procedural query language consisting of operations on relations.

### Basic Operations

**1. Selection (σ) - Select Rows**

```
σ_condition(R)

Selects tuples that satisfy the condition

Example:
σ_Age>21(STUDENT)
```

**Visual:**

```
Original Relation R:
+----+-------+-----+
| ID | Name  | Age |
+----+-------+-----+
| 1  | Alice | 20  |
| 2  | Bob   | 25  |
| 3  | Carol | 22  |
+----+-------+-----+

σ_Age>21(R):
+----+-------+-----+
| ID | Name  | Age |
+----+-------+-----+
| 2  | Bob   | 25  |
| 3  | Carol | 22  |
+----+-------+-----+
```

**2. Projection (π) - Select Columns**

```
π_attributes(R)

Selects specified attributes, removes duplicates

Example:
π_Name,Age(STUDENT)
```

**Visual:**

```
Original Relation R:
+----+-------+-----+------+
| ID | Name  | Age | Dept |
+----+-------+-----+------+
| 1  | Alice | 20  | CS   |
| 2  | Bob   | 25  | EE   |
+----+-------+-----+------+

π_Name,Age(R):
+-------+-----+
| Name  | Age |
+-------+-----+
| Alice | 20  |
| Bob   | 25  |
+-------+-----+
```

**3. Union (∪)**

```
R ∪ S

Combines tuples from R and S (union compatible)

Conditions:
- Same degree (number of attributes)
- Compatible domains
```

**Visual:**

```
R:                    S:
+----+-------+        +----+-------+
| ID | Name  |        | ID | Name  |
+----+-------+        +----+-------+
| 1  | Alice |        | 2  | Bob   |
| 2  | Bob   |        | 3  | Carol |
+----+-------+        +----+-------+

R ∪ S:
+----+-------+
| ID | Name  |
+----+-------+
| 1  | Alice |
| 2  | Bob   |
| 3  | Carol |
+----+-------+
```

**4. Set Difference (−)**

```
R − S

Tuples in R but not in S
```

**Visual:**

```
R:                    S:
+----+-------+        +----+-------+
| ID | Name  |        | ID | Name  |
+----+-------+        +----+-------+
| 1  | Alice |        | 2  | Bob   |
| 2  | Bob   |        | 3  | Carol |
| 4  | Dave  |        +----+-------+
+----+-------+

R − S:
+----+-------+
| ID | Name  |
+----+-------+
| 1  | Alice |
| 4  | Dave  |
+----+-------+
```

**5. Cartesian Product (×)**

```
R × S

All possible combinations of tuples from R and S
Result cardinality: |R| × |S|
Result degree: degree(R) + degree(S)
```

**Visual:**

```
R:                    S:
+----+-------+        +-------+-----+
| ID | Name  |        | Color | Age |
+----+-------+        +-------+-----+
| 1  | Alice |        | Red   | 20  |
| 2  | Bob   |        | Blue  | 25  |
+----+-------+        +-------+-----+

R × S:
+----+-------+-------+-----+
| ID | Name  | Color | Age |
+----+-------+-------+-----+
| 1  | Alice | Red   | 20  |
| 1  | Alice | Blue  | 25  |
| 2  | Bob   | Red   | 20  |
| 2  | Bob   | Blue  | 25  |
+----+-------+-------+-----+
```

**6. Rename (ρ)**

```
ρ_S(A₁,A₂,...,Aₙ)(R)

Renames relation R to S with attributes A₁,A₂,...,Aₙ
```

### Additional Operations

**7. Intersection (∩)**

```
R ∩ S

Tuples present in both R and S

Equivalent to: R − (R − S)
```

**8. Division (÷)**

```
R ÷ S

Tuples in R that are associated with all tuples in S

Used for "for all" queries
```

**Visual:**

```
R (Student, Course):       S (Course):
+----------+--------+      +--------+
| Student  | Course |      | Course |
+----------+--------+      +--------+
| Alice    | DB     |      | DB     |
| Alice    | OS     |      | OS     |
| Bob      | DB     |      +--------+
| Carol    | DB     |
| Carol    | OS     |
+----------+--------+

R ÷ S (Students who took ALL courses):
+----------+
| Student  |
+----------+
| Alice    |
| Carol    |
+----------+
```

**9. Join Operations**

**Natural Join (⋈):**

```
R ⋈ S

Combines tuples with matching values on common attributes
```

**Theta Join (⋈_θ):**

```
R ⋈_θ S = σ_θ(R × S)

Cartesian product followed by selection
```

**Equi Join:**

```
R ⋈_(R.A=S.B) S

Theta join with equality condition
```

**Outer Joins:**

```
Left Outer Join (⟕):   R ⟕ S
Right Outer Join (⟖):  R ⟖ S
Full Outer Join (⟗):   R ⟗ S
```

**Join Visual:**

```
EMPLOYEE:                 DEPARTMENT:
+-------+------+--------+  +--------+-----------+
| EmpID | Name | DeptID |  | DeptID | DeptName  |
+-------+------+--------+  +--------+-----------+
| E1    | John | D1     |  | D1     | Sales     |
| E2    | Mary | D2     |  | D2     | IT        |
| E3    | Bob  | NULL   |  | D3     | HR        |
+-------+------+--------+  +--------+-----------+

EMPLOYEE ⋈ DEPARTMENT (Natural Join):
+-------+------+--------+-----------+
| EmpID | Name | DeptID | DeptName  |
+-------+------+--------+-----------+
| E1    | John | D1     | Sales     |
| E2    | Mary | D2     | IT        |
+-------+------+--------+-----------+

EMPLOYEE ⟕ DEPARTMENT (Left Outer Join):
+-------+------+--------+-----------+
| EmpID | Name | DeptID | DeptName  |
+-------+------+--------+-----------+
| E1    | John | D1     | Sales     |
| E2    | Mary | D2     | IT        |
| E3    | Bob  | NULL   | NULL      |
+-------+------+--------+-----------+
```

### Operation Precedence

```
Highest:  σ, π, ρ  (Unary operations)
          ×, ⋈     (Product and Join)
          ∩        (Intersection)
Lowest:   ∪, −     (Union and Difference)
```

### Complex Query Example

**Query:** Find names of students in CS department with GPA > 3.5

```
π_Name(σ_Department='CS' ∧ GPA>3.5(STUDENT))
```

**Step-by-step:**

```
1. σ_Department='CS' ∧ GPA>3.5(STUDENT)  [Select CS students with high GPA]
2. π_Name(result)                        [Project only names]
```

---

## Relational Calculus

Relational Calculus is a non-procedural query language based on mathematical logic.

### Types of Relational Calculus

```
        RELATIONAL CALCULUS
               |
       ┌───────┴───────┐
       |               |
  TUPLE CALCULUS  DOMAIN CALCULUS
       |               |
    {t | P(t)}    {⟨x₁,x₂,...⟩ | P(x₁,x₂,...)}
```

---

## Tuple Relational Calculus (TRC)

### Syntax

```
{t | P(t)}

Where:
- t = tuple variable
- P(t) = predicate (logical formula)
```

### Components

**Tuple Variables:**

```
t ∈ R  (tuple t belongs to relation R)
```

**Predicates:**

```
- t.A op value    (comparison)
- t.A op s.B      (comparison between tuples)
- P₁ ∧ P₂         (AND)
- P₁ ∨ P₂         (OR)
- ¬P              (NOT)
- ∃t(P(t))        (exists)
- ∀t(P(t))        (for all)
```

### Examples

**1. Simple Selection:**

```
Query: Find all students with Age > 21

TRC: {t | t ∈ STUDENT ∧ t.Age > 21}
```

**2. Projection:**

```
Query: Find names of all students

TRC: {t.Name | t ∈ STUDENT}
```

**3. Join:**

```
Query: Find employee names and their department names

TRC: {⟨t.Name, s.DeptName⟩ | 
      t ∈ EMPLOYEE ∧ s ∈ DEPARTMENT ∧ 
      t.DeptID = s.DeptID}
```

**4. Existential Quantifier:**

```
Query: Find students enrolled in at least one course

TRC: {t | t ∈ STUDENT ∧ 
      ∃e(e ∈ ENROLLMENT ∧ e.StudentID = t.StudentID)}
```

**5. Universal Quantifier:**

```
Query: Find students enrolled in all courses

TRC: {t | t ∈ STUDENT ∧ 
      ∀c(c ∈ COURSE → 
      ∃e(e ∈ ENROLLMENT ∧ 
      e.StudentID = t.StudentID ∧ 
      e.CourseID = c.CourseID))}
```

---

## Domain Relational Calculus (DRC)

### Syntax

```
{⟨x₁, x₂, ..., xₙ⟩ | P(x₁, x₂, ..., xₙ)}

Where:
- xᵢ = domain variables
- P = predicate over domain variables
```

### Examples

**1. Simple Query:**

```
Query: Find StudentID and Name of students with Age > 21

DRC: {⟨i, n⟩ | ∃a, d, g(STUDENT(i, n, a, d, g) ∧ a > 21)}

Where STUDENT(ID, Name, Age, Dept, GPA)
```

**2. Join Query:**

```
Query: Find employee names and department names

DRC: {⟨en, dn⟩ | 
      ∃ei, ed(EMPLOYEE(ei, en, ed) ∧ 
      DEPARTMENT(ed, dn))}
```

### TRC vs DRC Comparison

```
Aspect              TRC                    DRC
────────────────────────────────────────────────────
Variables           Tuple variables        Domain variables
Granularity         Whole tuples           Individual attributes
Expression Form     {t | P(t)}            {⟨x₁,x₂,...⟩ | P(...)}
Typical Use         More intuitive         More explicit
Equivalence         Both equally powerful
```

---

## SQL Introduction

### Characteristics of SQL

SQL (Structured Query Language) is a standard language for managing relational databases.

**Key Characteristics:**

1. **Declarative Language:** Specify what data you want, not how to get it
2. **Set-Based:** Operates on sets of data, not individual records
3. **Standardized:** ANSI/ISO standard (SQL-86, SQL-92, SQL:1999, SQL:2003, SQL:2016)
4. **Comprehensive:** Data definition, manipulation, control, and query
5. **Case-Insensitive:** Keywords not case-sensitive (by convention uppercase)

### SQL Architecture

```
┌─────────────────────────────────────────────┐
│              SQL COMPONENTS                 │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │   DDL    │  │   DML    │  │   DCL    │ │
│  │  Data    │  │   Data   │  │  Data    │ │
│  │Definition│  │Manipulate│  │ Control  │ │
│  └──────────┘  └──────────┘  └──────────┘ │
│       │             │              │       │
│       │             │              │       │
│  ┌────▼─────────────▼──────────────▼────┐ │
│  │          DQL (Data Query)           │ │
│  │           SELECT Statements         │ │
│  └─────────────────────────────────────┘ │
│                                             │
│  ┌─────────────────────────────────────┐ │
│  │     TCL (Transaction Control)       │ │
│  │   COMMIT, ROLLBACK, SAVEPOINT      │ │
│  └─────────────────────────────────────┘ │
│                                             │
└─────────────────────────────────────────────┘
```

### Advantages of SQL

**1. Standardization:** Portable across different RDBMS platforms **2. High-Level Language:** Abstract away low-level implementation details **3. Powerful:** Complex queries in simple statements **4. Interactive:** Immediate results from queries **5. Multi-User:** Concurrent access with ACID properties **6. Flexible:** Supports ad-hoc queries and embedded SQL **7. Scalable:** Works with small to very large databases

---

## SQL Data Types and Literals

### Numeric Data Types

```
┌────────────────────────────────────────────┐
│         NUMERIC DATA TYPES                 │
├────────────────────────────────────────────┤
│                                            │
│  INTEGER TYPES:                            │
│  ├─ TINYINT      1 byte   (-128 to 127)   │
│  ├─ SMALLINT     2 bytes  (-32K to 32K)   │
│  ├─ INT/INTEGER  4 bytes  (-2B to 2B)     │
│  └─ BIGINT       8 bytes  (-9Q to 9Q)     │
│                                            │
│  DECIMAL TYPES:                            │
│  ├─ DECIMAL(p,s)  Exact numeric           │
│  ├─ NUMERIC(p,s)  Exact numeric           │
│  ├─ FLOAT(p)      Approximate             │
│  ├─ REAL          4 bytes approximate     │
│  └─ DOUBLE        8 bytes approximate     │
│                                            │
└────────────────────────────────────────────┘

Where:
p = precision (total digits)
s = scale (digits after decimal)
```

**Examples:**

```sql
-- Integer
age INT
quantity SMALLINT
population BIGINT

-- Decimal
price DECIMAL(10, 2)    -- 99999999.99
salary NUMERIC(8, 2)    -- 999999.99
rate FLOAT(7)
```

### Character Data Types

```
┌────────────────────────────────────────────┐
│         CHARACTER DATA TYPES               │
├────────────────────────────────────────────┤
│                                            │
│  FIXED LENGTH:                             │
│  └─ CHAR(n)       Fixed n characters       │
│                   Padded with spaces       │
│                                            │
│  VARIABLE LENGTH:                          │
│  ├─ VARCHAR(n)    Up to n characters       │
│  ├─ TEXT          Large text (65535)       │
│  ├─ MEDIUMTEXT    16MB text                │
│  └─ LONGTEXT      4GB text                 │
│                                            │
│  UNICODE:                                  │
│  ├─ NCHAR(n)      Fixed Unicode            │
│  └─ NVARCHAR(n)   Variable Unicode         │
│                                            │
└────────────────────────────────────────────┘
```

**Examples:**

```sql
-- Fixed length
country_code CHAR(2)      -- 'US', 'IN'
state_code CHAR(2)        -- 'CA', 'NY'

-- Variable length
name VARCHAR(100)
email VARCHAR(255)
description TEXT

-- Binary
profile_pic BLOB
document MEDIUMBLOB
```

### Date and Time Data Types

```
┌────────────────────────────────────────────┐
│        DATE/TIME DATA TYPES                │
├────────────────────────────────────────────┤
│                                            │
│  DATE         'YYYY-MM-DD'                 │
│               Range: 1000-01-01 to         │
│                      9999-12-31            │
│                                            │
│  TIME         'HH:MM:SS'                   │
│               Range: -838:59:59 to         │
│                      838:59:59             │
│                                            │
│  DATETIME     'YYYY-MM-DD HH:MM:SS'        │
│               Range: 1000-01-01 to         │
│                      9999-12-31            │
│                                            │
│  TIMESTAMP    'YYYY-MM-DD HH:MM:SS'        │
│               Range: 1970-01-01 to         │
│                      2038-01-19            │
│               (Unix timestamp)             │
│                                            │
│  YEAR         YYYY                         │
│               Range: 1901 to 2155          │
│                                            │
└────────────────────────────────────────────┘
```

**Examples:**

```sql
birth_date DATE              -- '1990-05-15'
start_time TIME              -- '09:30:00'
created_at DATETIME          -- '2024-03-09 14:30:00'
last_login TIMESTAMP         -- Auto-updated
graduation_year YEAR         -- 2024
```

### Other Data Types

```
BOOLEAN/BOOL        TRUE (1) or FALSE (0)
ENUM('v1','v2')     Predefined string values
SET('v1','v2')      Set of predefined values
JSON                JSON document storage
XML                 XML document storage
SPATIAL             Geometric/geographic data
```

### Literals

**Numeric Literals:**

```sql
42              -- Integer
3.14159         -- Decimal
2.5E10          -- Scientific notation
0xFF            -- Hexadecimal
0b1010          -- Binary
```

**String Literals:**

```sql
'Hello World'           -- Single quotes
"Hello World"           -- Double quotes (MySQL)
'O''Brien'              -- Escaped quote
'Line1\nLine2'          -- Newline
N'Unicode string'       -- Unicode string
```

**Date/Time Literals:**

```sql
DATE '2024-03-09'
TIME '14:30:00'
TIMESTAMP '2024-03-09 14:30:00'
```

**Boolean Literals:**

```sql
TRUE or 1
FALSE or 0
NULL
```

---

## Types of SQL Commands

### Command Classification

```
                    SQL COMMANDS
                         |
        ┌────────────────┼────────────────┐
        |                |                |
       DDL              DML              DCL
 (Data Definition) (Data Manipulation) (Data Control)
        |                |                |
    CREATE           INSERT            GRANT
    ALTER            UPDATE            REVOKE
    DROP             DELETE
    TRUNCATE         MERGE
    RENAME
        |
        └─── DQL (Data Query Language)
                 |
              SELECT
                 |
        ┌────────┴────────┐
        |                 |
       TCL              Others
(Transaction Control)
        |
    COMMIT
    ROLLBACK
    SAVEPOINT
```

### 1. DDL (Data Definition Language)

DDL commands define and modify database structure.

**CREATE:** Creates database objects

```sql
-- Create database
CREATE DATABASE company_db;

-- Create table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT,
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Create index
CREATE INDEX idx_name ON employees(name);

-- Create view
CREATE VIEW high_earners AS
SELECT * FROM employees WHERE salary > 100000;
```

**ALTER:** Modifies existing structure

```sql
-- Add column
ALTER TABLE employees ADD COLUMN email VARCHAR(100);

-- Modify column
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2);

-- Drop column
ALTER TABLE employees DROP COLUMN email;

-- Add constraint
ALTER TABLE employees ADD CONSTRAINT fk_dept 
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Rename column
ALTER TABLE employees RENAME COLUMN name TO full_name;
```

**DROP:** Removes database objects

```sql
-- Drop table
DROP TABLE employees;

-- Drop database
DROP DATABASE company_db;

-- Drop index
DROP INDEX idx_name ON employees;

-- Drop view
DROP VIEW high_earners;
```

**TRUNCATE:** Removes all rows, keeps structure

```sql
TRUNCATE TABLE employees;

-- Differences from DELETE:
-- - Faster (no logging individual rows)
-- - Resets auto-increment
-- - Cannot be rolled back (in some RDBMS)
-- - No WHERE clause
```

**RENAME:** Renames objects

```sql
RENAME TABLE employees TO staff;
ALTER TABLE employees RENAME TO staff;
```

### 2. DML (Data Manipulation Language)

DML commands manipulate data within tables.

**INSERT:** Adds new rows

```sql
-- Insert single row
INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (101, 'John Doe', 75000.00, 10);

-- Insert multiple rows
INSERT INTO employees VALUES
    (102, 'Jane Smith', 80000.00, 20, '2024-01-15'),
    (103, 'Bob Johnson', 72000.00, 10, '2024-02-01');

-- Insert from SELECT
INSERT INTO employees_archive
SELECT * FROM employees WHERE hire_date < '2020-01-01';
```

**UPDATE:** Modifies existing rows

```sql
-- Update single column
UPDATE employees SET salary = 80000.00 WHERE emp_id = 101;

-- Update multiple columns
UPDATE employees 
SET salary = salary * 1.10,
    dept_id = 20
WHERE emp_id = 101;

-- Update with subquery
UPDATE employees
SET salary = (SELECT AVG(salary) FROM employees WHERE dept_id = 10)
WHERE emp_id = 101;

-- Update all rows (dangerous without WHERE)
UPDATE employees SET salary = salary * 1.05;
```

**DELETE:** Removes rows

```sql
-- Delete specific rows
DELETE FROM employees WHERE emp_id = 101;

-- Delete with condition
DELETE FROM employees WHERE hire_date < '2020-01-01';

-- Delete with subquery
DELETE FROM employees WHERE dept_id IN 
    (SELECT dept_id FROM departments WHERE location = 'Chicago');

-- Delete all rows (use TRUNCATE instead)
DELETE FROM employees;
```

**MERGE (UPSERT):** Insert or Update based on condition

```sql
MERGE INTO employees AS target
USING new_employees AS source
ON target.emp_id = source.emp_id
WHEN MATCHED THEN
    UPDATE SET salary = source.salary
WHEN NOT MATCHED THEN
    INSERT (emp_id, name, salary)
    VALUES (source.emp_id, source.name, source.salary);
```

### 3. DQL (Data Query Language)

**SELECT:** Retrieves data

```sql
-- Basic SELECT
SELECT * FROM employees;

-- Select specific columns
SELECT emp_id, name, salary FROM employees;

-- With WHERE clause
SELECT * FROM employees WHERE salary > 75000;

-- With ORDER BY
SELECT * FROM employees ORDER BY salary DESC;

-- With LIMIT
SELECT * FROM employees ORDER BY salary DESC LIMIT 10;

-- With DISTINCT
SELECT DISTINCT dept_id FROM employees;
```

### 4. DCL (Data Control Language)

DCL commands manage user permissions.

**GRANT:** Gives privileges

```sql
-- Grant SELECT privilege
GRANT SELECT ON employees TO user1;

-- Grant multiple privileges
GRANT SELECT, INSERT, UPDATE ON employees TO user1;

-- Grant all privileges
GRANT ALL PRIVILEGES ON company_db.* TO user1;

-- Grant with grant option
GRANT SELECT ON employees TO user1 WITH GRANT OPTION;
```

**REVOKE:** Removes privileges

```sql
-- Revoke specific privilege
REVOKE SELECT ON employees FROM user1;

-- Revoke all privileges
REVOKE ALL PRIVILEGES ON company_db.* FROM user1;
```

### 5. TCL (Transaction Control Language)

TCL commands manage database transactions.

**COMMIT:** Saves transaction changes permanently

```sql
START TRANSACTION;
UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 10;
COMMIT;  -- Changes are permanent
```

**ROLLBACK:** Undoes transaction changes

```sql
START TRANSACTION;
DELETE FROM employees WHERE emp_id = 101;
ROLLBACK;  -- Deletion is undone
```

**SAVEPOINT:** Creates checkpoint within transaction

```sql
START TRANSACTION;
UPDATE employees SET salary = salary * 1.05;
SAVEPOINT sp1;
DELETE FROM employees WHERE emp_id = 101;
ROLLBACK TO SAVEPOINT sp1;  -- Only DELETE is rolled back
COMMIT;  -- UPDATE is committed
```

**Transaction Flow:**

```
BEGIN TRANSACTION
    |
    ├─→ SQL Statement 1
    ├─→ SQL Statement 2
    ├─→ SAVEPOINT sp1
    ├─→ SQL Statement 3
    ├─→ SQL Statement 4
    |
    ├─→ ROLLBACK TO sp1 (undo 3 & 4)
    |
    └─→ COMMIT (finalize 1 & 2)
```

---

## SQL Operators and Their Procedure

### Comparison Operators

```
Operator    Meaning                Example
────────────────────────────────────────────────────
=           Equal to               age = 25
!=, <>      Not equal to           age != 25
>           Greater than           salary > 50000
<           Less than              salary < 100000
>=          Greater than or equal  age >= 18
<=          Less than or equal     age <= 65
BETWEEN     Within range           age BETWEEN 18 AND 65
IN          In a list             dept_id IN (10, 20, 30)
LIKE        Pattern matching       name LIKE 'A%'
IS NULL     NULL value check       email IS NULL
IS NOT NULL Not NULL check         email IS NOT NULL
```

**Examples:**

```sql
-- Equal
SELECT * FROM employees WHERE dept_id = 10;

-- Range
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 100000;

-- List membership
SELECT * FROM employees WHERE dept_id IN (10, 20, 30);

-- NULL check
SELECT * FROM employees WHERE email IS NULL;
```

### Logical Operators

```
Operator    Meaning                     Example
──────────────────────────────────────────────────────────
AND         Both conditions true        age > 18 AND salary > 50000
OR          Either condition true       dept_id = 10 OR dept_id = 20
NOT         Negates condition           NOT (age < 18)
```

**Truth Tables:**

```
AND Truth Table:        OR Truth Table:         NOT Truth Table:
A     B    A AND B      A     B    A OR B       A     NOT A
T     T      T          T     T      T          T       F
T     F      F          T     F      T          F       T
F     T      F          F     T      T
F     F      F          F     F      F
```

**Examples:**

```sql
-- AND
SELECT * FROM employees WHERE dept_id = 10 AND salary > 75000;

-- OR
SELECT * FROM employees WHERE dept_id = 10 OR dept_id = 20;

-- NOT
SELECT * FROM employees WHERE NOT (salary < 50000);

-- Combined
SELECT * FROM employees 
WHERE (dept_id = 10 OR dept_id = 20) AND salary > 75000;
```

### Arithmetic Operators

```
Operator    Operation           Example
─────────────────────────────────────────────────
+           Addition            salary + 5000
-           Subtraction         salary - 1000
*           Multiplication      salary * 1.10
/           Division            salary / 12
%           Modulo (remainder)  emp_id % 2
```

**Examples:**

```sql
-- Calculate annual bonus (10% of salary)
SELECT name, salary, salary * 0.10 AS bonus FROM employees;

-- Monthly salary
SELECT name, salary / 12 AS monthly_salary FROM employees;

-- Increase salary by 5000
UPDATE employees SET salary = salary + 5000 WHERE emp_id = 101;
```

### String Operators and Functions

**LIKE Operator Pattern Matching:**

```
Wildcard    Meaning                Example              Matches
─────────────────────────────────────────────────────────────────
%           Any sequence of        'A%'                 Alice, Andrew
            characters             '%son'               Johnson, Wilson
                                  '%an%'               Daniel, Anna

_           Single character       'A_'                 At, An
                                  '_____'              5-char names
                                  'A_____'             6-char names starting with A
```

**Examples:**

```sql
-- Names starting with 'A'
SELECT * FROM employees WHERE name LIKE 'A%';

-- Names ending with 'son'
SELECT * FROM employees WHERE name LIKE '%son';

-- Names containing 'an'
SELECT * FROM employees WHERE name LIKE '%an%';

-- 5-character names
SELECT * FROM employees WHERE name LIKE '_____';

-- Names with 'a' as second character
SELECT * FROM employees WHERE name LIKE '_a%';
```

**String Functions:**

```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;

-- Upper/Lower case
SELECT UPPER(name), LOWER(name) FROM employees;

-- Substring
SELECT SUBSTRING(name, 1, 3) FROM employees;  -- First 3 chars

-- Length
SELECT name, LENGTH(name) FROM employees;

-- Trim whitespace
SELECT TRIM(name), LTRIM(name), RTRIM(name) FROM employees;

-- Replace
SELECT REPLACE(email, '@old.com', '@new.com') FROM employees;
```

### Set Membership Operators

**IN Operator:**

```sql
-- Using IN
SELECT * FROM employees WHERE dept_id IN (10, 20, 30);

-- Equivalent to OR
SELECT * FROM employees 
WHERE dept_id = 10 OR dept_id = 20 OR dept_id = 30;

-- With subquery
SELECT * FROM employees WHERE dept_id IN 
    (SELECT dept_id FROM departments WHERE location = 'New York');

-- NOT IN
SELECT * FROM employees WHERE dept_id NOT IN (10, 20);
```

**EXISTS Operator:**

```sql
-- Check if subquery returns any rows
SELECT * FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d 
    WHERE d.dept_id = e.dept_id AND d.location = 'New York'
);

-- NOT EXISTS
SELECT * FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM assignments a 
    WHERE a.emp_id = e.emp_id
);
```

### Special Operators

**CASE Expression:**

```sql
-- Simple CASE
SELECT name, salary,
    CASE 
        WHEN salary < 50000 THEN 'Low'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM employees;

-- Searched CASE
SELECT name,
    CASE dept_id
        WHEN 10 THEN 'Sales'
        WHEN 20 THEN 'IT'
        WHEN 30 THEN 'HR'
        ELSE 'Other'
    END AS department_name
FROM employees;
```

**COALESCE Function:**

```sql
-- Return first non-NULL value
SELECT name, COALESCE(email, phone, 'No contact') AS contact
FROM employees;
```

**NULLIF Function:**

```sql
-- Return NULL if expressions are equal
SELECT name, NULLIF(salary, 0) AS salary
FROM employees;
```

---

## Tables, Views, and Indexes

### Tables

**Table Structure:**

```
TABLE: employees
┌─────────────────────────────────────────────┐
│  Column Name    Data Type      Constraints  │
├─────────────────────────────────────────────┤
│  emp_id         INT            PRIMARY KEY  │
│  name           VARCHAR(100)   NOT NULL     │
│  salary         DECIMAL(10,2)  CHECK > 0    │
│  dept_id        INT            FOREIGN KEY  │
│  hire_date      DATE           DEFAULT NOW  │
└─────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────┐
│                   ROWS                      │
├─────────────────────────────────────────────┤
│  101  John Doe      75000.00   10  2024-01 │
│  102  Jane Smith    80000.00   20  2024-02 │
│  103  Bob Johnson   72000.00   10  2024-03 │
└─────────────────────────────────────────────┘
```

**Creating Tables:**

```sql
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100),
    budget DECIMAL(12,2) CHECK (budget > 0),
    manager_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2) CHECK (salary >= 0),
    dept_id INT,
    hire_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
```

**Table Constraints:**

```sql
-- NOT NULL: Column cannot contain NULL
name VARCHAR(100) NOT NULL

-- UNIQUE: All values must be unique
email VARCHAR(100) UNIQUE

-- PRIMARY KEY: Unique identifier (NOT NULL + UNIQUE)
emp_id INT PRIMARY KEY

-- FOREIGN KEY: References another table
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)

-- CHECK: Custom validation
salary DECIMAL(10,2) CHECK (salary > 0)
age INT CHECK (age BETWEEN 18 AND 65)

-- DEFAULT: Default value if not specified
hire_date DATE DEFAULT CURRENT_DATE
status VARCHAR(20) DEFAULT 'active'
```

### Views

A view is a virtual table based on a SELECT query.

**View Concept:**

```
STORED TABLE              VIEW (Virtual Table)
┌──────────┐              ┌──────────┐
│employees │              │high_     │
│          │   SELECT     │earners   │
│emp_id    │─────────────▶│          │
│name      │   WHERE      │emp_id    │
│salary    │   salary     │name      │
│dept_id   │   > 100000   │salary    │
└──────────┘              └──────────┘
```

**Creating Views:**

```sql
-- Simple view
CREATE VIEW high_earners AS
SELECT emp_id, name, salary
FROM employees
WHERE salary > 100000;

-- View with join
CREATE VIEW employee_details AS
SELECT e.emp_id, e.name, e.salary, d.dept_name, d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- View with aggregation
CREATE VIEW dept_summary AS
SELECT dept_id, COUNT(*) as emp_count, AVG(salary) as avg_salary
FROM employees
GROUP BY dept_id;
```

**Using Views:**

```sql
-- Query a view like a table
SELECT * FROM high_earners;

-- Join views
SELECT he.name, ed.dept_name
FROM high_earners he
JOIN employee_details ed ON he.emp_id = ed.emp_id;
```

**Modifying Views:**

```sql
-- Replace view definition
CREATE OR REPLACE VIEW high_earners AS
SELECT emp_id, name, salary, dept_id
FROM employees
WHERE salary > 120000;

-- Drop view
DROP VIEW high_earners;
```

**View Types:**

```
1. Simple Views:
   - Based on single table
   - No functions, GROUP BY
   - Updatable (INSERT, UPDATE, DELETE possible)

2. Complex Views:
   - Multiple tables (joins)
   - Aggregate functions
   - GROUP BY, DISTINCT
   - Usually read-only
```

**View Advantages:**

- Security (restrict access to specific columns/rows)
- Simplification (hide complex queries)
- Consistency (same logic for multiple users)
- Logical data independence

### Indexes

Indexes improve query performance by providing fast data access paths.

**Index Structure (B-Tree):**

```
                    [50]
                   /    \
               [25]      [75]
              /    \    /    \
           [10] [30][60] [90]
            /\   /\  /\   /\
          Data Pointers
```

**Creating Indexes:**

```sql
-- Single column index
CREATE INDEX idx_name ON employees(name);

-- Composite index (multiple columns)
CREATE INDEX idx_dept_salary ON employees(dept_id, salary);

-- Unique index
CREATE UNIQUE INDEX idx_email ON employees(email);

-- Full-text index
CREATE FULLTEXT INDEX idx_description ON products(description);
```

**Index Types:**

```
1. B-Tree Index (Default):
   - Balanced tree structure
   - Good for equality and range queries
   - Most commonly used

2. Hash Index:
   - Hash table structure
   - Only for equality comparisons
   - Very fast for exact matches

3. Bitmap Index:
   - Bitmap for each distinct value
   - Good for low-cardinality columns
   - Efficient for AND/OR operations

4. Full-Text Index:
   - Specialized for text searching
   - Supports natural language queries
```

**When to Use Indexes:**

```sql
-- Good candidates for indexing:
✓ Primary keys (auto-indexed)
✓ Foreign keys
✓ Columns in WHERE clause
✓ Columns in JOIN conditions
✓ Columns in ORDER BY
✓ Columns in GROUP BY

-- Poor candidates:
✗ Small tables
✗ Columns with high update frequency
✗ Columns with low selectivity
✗ Large columns (TEXT, BLOB)
```

**Index Trade-offs:**

```
BENEFITS:                    COSTS:
+ Faster SELECT queries      - Slower INSERT/UPDATE/DELETE
+ Faster JOIN operations     - Additional storage space
+ Faster ORDER BY            - Index maintenance overhead
+ Enforces uniqueness        - Query optimizer complexity
```

**Managing Indexes:**

```sql
-- View indexes on a table
SHOW INDEX FROM employees;

-- Drop index
DROP INDEX idx_name ON employees;

-- Rebuild index (optimize)
ALTER TABLE employees ENGINE=InnoDB;  -- MySQL
REINDEX TABLE employees;              -- PostgreSQL
```

---

## Queries and Sub-Queries

### Basic Queries

**SELECT Clause Components:**

```sql
SELECT [DISTINCT] column1, column2, ...
FROM table_name
[WHERE condition]
[GROUP BY column(s)]
[HAVING condition]
[ORDER BY column(s) [ASC|DESC]]
[LIMIT number];
```

**Query Execution Order:**

```
Logical Order:              Physical/Optimization Order:
1. FROM                     1. FROM (load data)
2. WHERE                    2. WHERE (filter rows)
3. GROUP BY                 3. GROUP BY (group rows)
4. HAVING                   4. HAVING (filter groups)
5. SELECT                   5. SELECT (compute columns)
6. DISTINCT                 6. DISTINCT (remove duplicates)
7. ORDER BY                 7. ORDER BY (sort results)
8. LIMIT                    8. LIMIT (restrict rows)
```

**Examples:**

```sql
-- Simple SELECT
SELECT * FROM employees;

-- With WHERE
SELECT name, salary FROM employees WHERE salary > 75000;

-- With ORDER BY
SELECT * FROM employees ORDER BY salary DESC, name ASC;

-- With LIMIT
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

-- With DISTINCT
SELECT DISTINCT dept_id FROM employees;

-- Aliases
SELECT e.name AS employee_name, d.dept_name AS department
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;
```

### Sub-Queries (Nested Queries)

A sub-query is a query nested within another query.

**Sub-Query Types:**

```
                  SUB-QUERIES
                       |
        ┌──────────────┼──────────────┐
        |              |              |
    SCALAR        COLUMN/ROW        TABLE
  (Single value)  (Multiple values) (Result set)
        |              |              |
   Returns 1x1     Returns Nx1     Returns NxM
                   or 1xN
```

**1. Scalar Sub-Query (Single Value):**

```sql
-- Returns single value
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- In SELECT clause
SELECT name, 
       salary,
       (SELECT AVG(salary) FROM employees) AS avg_salary,
       salary - (SELECT AVG(salary) FROM employees) AS difference
FROM employees;
```

**2. Column Sub-Query (Multiple Values):**

```sql
-- With IN operator
SELECT name, dept_id
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'New York'
);

-- With ANY/ALL
SELECT name, salary
FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE dept_id = 10);

SELECT name, salary
FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE dept_id = 10);
```

**3. Row Sub-Query:**

```sql
-- Comparing multiple columns
SELECT * FROM employees
WHERE (dept_id, salary) = (
    SELECT dept_id, MAX(salary) 
    FROM employees 
    GROUP BY dept_id 
    LIMIT 1
);
```

**4. Table Sub-Query (Derived Table):**

```sql
-- In FROM clause
SELECT dept_id, avg_salary
FROM (
    SELECT dept_id, AVG(salary) as avg_salary
    FROM employees
    GROUP BY dept_id
) AS dept_avg
WHERE avg_salary > 75000;
```

**5. Correlated Sub-Query:**

```sql
-- References outer query
SELECT e1.name, e1.salary
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e1.dept_id  -- Correlated
);
```

**Sub-Query Execution:**

```
Non-Correlated:                 Correlated:
┌──────────────┐               ┌──────────────┐
│ Outer Query  │               │ Outer Query  │
│      ▼       │               │      ▼       │
│ ┌──────────┐ │               │ ┌──────────┐ │
│ │Sub-Query │ │               │ │Sub-Query │◄┼── For each row
│ │ (Once)   │ │               │ │(Multiple)│ │
│ └─────┬────┘ │               │ └─────┬────┘ │
│       ▼      │               │       ▼      │
│   Use Result │               │   Use Result │
└──────────────┘               └──────────────┘
```

**EXISTS vs IN:**

```sql
-- Using IN (materializes sub-query result)
SELECT * FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'New York'
);

-- Using EXISTS (short-circuits on first match)
SELECT * FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d 
    WHERE d.dept_id = e.dept_id AND d.location = 'New York'
);

-- NOT EXISTS
SELECT * FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM assignments a WHERE a.emp_id = e.emp_id
);
```

---

## Aggregate Functions

Aggregate functions perform calculations on sets of values and return a single result.

**Common Aggregate Functions:**

```
┌────────────────────────────────────────┐
│       AGGREGATE FUNCTIONS              │
├────────────────────────────────────────┤
│                                        │
│  COUNT(*)      Count all rows          │
│  COUNT(col)    Count non-NULL values   │
│  SUM(col)      Sum of values           │
│  AVG(col)      Average of values       │
│  MIN(col)      Minimum value           │
│  MAX(col)      Maximum value           │
│  STDDEV(col)   Standard deviation      │
│  VARIANCE(col) Variance                │
│                                        │
└────────────────────────────────────────┘
```

**Examples:**

```sql
-- COUNT
SELECT COUNT(*) FROM employees;  -- Total rows
SELECT COUNT(email) FROM employees;  -- Non-NULL emails
SELECT COUNT(DISTINCT dept_id) FROM employees;  -- Unique departments

-- SUM
SELECT SUM(salary) FROM employees;  -- Total payroll
SELECT SUM(salary) AS total_payroll FROM employees WHERE dept_id = 10;

-- AVG
SELECT AVG(salary) FROM employees;  -- Average salary
SELECT AVG(salary) AS avg_salary FROM employees WHERE dept_id = 10;

-- MIN and MAX
SELECT MIN(salary), MAX(salary) FROM employees;
SELECT MIN(hire_date) AS first_hire, MAX(hire_date) AS last_hire 
FROM employees;

-- Multiple aggregates
SELECT 
    COUNT(*) AS total_employees,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll
FROM employees;
```

### GROUP BY Clause

Groups rows with same values into summary rows.

**Syntax:**

```sql
SELECT column(s), aggregate_function(column)
FROM table
WHERE condition
GROUP BY column(s)
HAVING aggregate_condition;
```

**Examples:**

```sql
-- Group by single column
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id;

-- Group by multiple columns
SELECT dept_id, YEAR(hire_date) AS hire_year, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id, YEAR(hire_date);

-- With aggregate functions
SELECT dept_id, 
       COUNT(*) AS emp_count,
       AVG(salary) AS avg_salary,
       SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id;
```

**GROUP BY Visualization:**

```
EMPLOYEES Table:
+--------+-------+--------+
| emp_id | name  | dept_id|
+--------+-------+--------+
| 1      | Alice | 10     |
| 2      | Bob   | 10     |
| 3      | Carol | 20     |
| 4      | Dave  | 20     |
| 5      | Eve   | 20     |
+--------+-------+--------+

GROUP BY dept_id:
┌────────────┐     ┌────────────┐
│ Group: 10  │     │ Group: 20  │
├────────────┤     ├────────────┤
│ Alice      │     │ Carol      │
│ Bob        │     │ Dave       │
└────────────┘     │ Eve        │
COUNT = 2          └────────────┘
                   COUNT = 3

Result:
+--------+-----------+
|dept_id | emp_count |
+--------+-----------+
| 10     | 2         |
| 20     | 3         |
+--------+-----------+
```

### HAVING Clause

Filters grouped results (WHERE filters before grouping, HAVING filters after).

**Examples:**

```sql
-- Filter groups with more than 5 employees
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 5;

-- Filter groups with average salary > 75000
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 75000;

-- Combined WHERE and HAVING
SELECT dept_id, AVG(salary) AS avg_salary
FROM employees
WHERE salary > 50000  -- Filter individual rows
GROUP BY dept_id
HAVING AVG(salary) > 75000;  -- Filter groups
```

**WHERE vs HAVING:**

```
WHERE:                          HAVING:
- Filters rows before grouping  - Filters groups after grouping
- Cannot use aggregate functions - Can use aggregate functions
- Applied to individual rows    - Applied to groups
- Faster (reduces data early)   - Slower (after aggregation)

SELECT dept_id, AVG(salary)
FROM employees
WHERE salary > 50000        ← Filters rows
GROUP BY dept_id
HAVING AVG(salary) > 75000  ← Filters groups
```

---

## Insert, Update, and Delete Operations

### INSERT Operations

**Insert Single Row:**

```sql
-- With all columns
INSERT INTO employees VALUES (101, 'John Doe', 'john@email.com', 75000, 10, '2024-01-15');

-- With specific columns
INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (102, 'Jane Smith', 80000, 20);

-- Missing columns get DEFAULT or NULL
```

**Insert Multiple Rows:**

```sql
INSERT INTO employees (emp_id, name, salary, dept_id) VALUES
    (103, 'Bob Johnson', 72000, 10),
    (104, 'Alice Brown', 85000, 20),
    (105, 'Charlie Wilson', 78000, 10);
```

**Insert from SELECT:**

```sql
-- Copy data from another table
INSERT INTO employees_backup
SELECT * FROM employees WHERE hire_date < '2020-01-01';

-- Insert specific columns
INSERT INTO high_earners (emp_id, name, salary)
SELECT emp_id, name, salary FROM employees WHERE salary > 100000;
```

**Insert with ON DUPLICATE KEY:**

```sql
-- MySQL: Update if duplicate key exists
INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (101, 'John Updated', 80000, 10)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    salary = VALUES(salary);
```

### UPDATE Operations

**Basic Update:**

```sql
-- Update single column
UPDATE employees 
SET salary = 80000 
WHERE emp_id = 101;

-- Update multiple columns
UPDATE employees
SET salary = 85000,
    dept_id = 20,
    email = 'newemail@company.com'
WHERE emp_id = 101;
```

**Update with Calculations:**

```sql
-- Increase all salaries by 10%
UPDATE employees 
SET salary = salary * 1.10;

-- Give 5000 raise to specific department
UPDATE employees 
SET salary = salary + 5000
WHERE dept_id = 10;
```

**Update with Sub-Query:**

```sql
-- Set salary to department average
UPDATE employees e
SET salary = (
    SELECT AVG(salary) 
    FROM employees 
    WHERE dept_id = e.dept_id
)
WHERE emp_id = 101;

-- Update based on another table
UPDATE employees e
SET salary = salary * 1.15
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'New York'
);
```

**Update with JOIN:**

```sql
-- Update using JOIN (MySQL syntax)
UPDATE employees e
JOIN departments d ON e.dept_id = d.dept_id
SET e.salary = e.salary * 1.10
WHERE d.location = 'New York';
```

### DELETE Operations

**Basic Delete:**

```sql
-- Delete specific row
DELETE FROM employees WHERE emp_id = 101;

-- Delete multiple rows
DELETE FROM employees WHERE dept_id = 10;

-- Delete with condition
DELETE FROM employees WHERE salary < 50000 AND hire_date < '2020-01-01';
```

**Delete with Sub-Query:**

```sql
-- Delete employees in specific departments
DELETE FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments WHERE location = 'Chicago'
);

-- Delete employees earning less than average
DELETE FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees);
```

**Delete All Rows:**

```sql
-- DELETE (slower, logged, can rollback)
DELETE FROM employees;

-- TRUNCATE (faster, cannot rollback in most RDBMS)
TRUNCATE TABLE employees;
```

**DELETE vs TRUNCATE:**

```
Feature              DELETE                  TRUNCATE
───────────────────────────────────────────────────────────
Speed                Slower                  Faster
WHERE clause         Yes                     No
Rollback             Yes (in transaction)    No (most RDBMS)
Triggers             Fired                   Not fired
Identity reset       No                      Yes
Row-by-row           Yes                     No (all at once)
Logging              Full logging            Minimal logging
```

---

## Joins

Joins combine rows from two or more tables based on related columns.

### Join Types Visualization

```
Table A              Table B
┌────┬──────┐        ┌────┬──────┐
│ ID │ Name │        │ ID │ Dept │
├────┼──────┤        ├────┼──────┤
│ 1  │ John │        │ 1  │ HR   │
│ 2  │ Jane │        │ 3  │ IT   │
│ 3  │ Bob  │        │ 4  │ Sales│
└────┴──────┘        └────┴──────┘

INNER JOIN:          LEFT JOIN:           RIGHT JOIN:
┌────┬──────┬──────┐ ┌────┬──────┬──────┐ ┌────┬──────┬──────┐
│ 1  │ John │ HR   │ │ 1  │ John │ HR   │ │ 1  │ John │ HR   │
│ 3  │ Bob  │ IT   │ │ 2  │ Jane │ NULL │ │ 3  │ Bob  │ IT   │
└────┴──────┴──────┘ │ 3  │ Bob  │ IT   │ │ 4  │ NULL │Sales │
                     └────┴──────┴──────┘ └────┴──────┴──────┘

FULL OUTER JOIN:     CROSS JOIN:
┌────┬──────┬──────┐ ┌────┬──────┬──────┐
│ 1  │ John │ HR   │ │ 1  │ John │ HR   │
│ 2  │ Jane │ NULL │ │ 1  │ John │ IT   │
│ 3  │ Bob  │ IT   │ │ 1  │ John │Sales │
│ 4  │ NULL │Sales │ │ 2  │ Jane │ HR   │
└────┴──────┴──────┘ │ 2  │ Jane │ IT   │
                     │ 2  │ Jane │Sales │
                     │ 3  │ Bob  │ HR   │
                     │ 3  │ Bob  │ IT   │
                     │ 3  │ Bob  │Sales │
                     └────┴──────┴──────┘
```

### 1. INNER JOIN

Returns only matching rows from both tables.

**Syntax:**

```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

**Examples:**

```sql
-- Basic INNER JOIN
SELECT e.name, e.salary, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- Multiple tables
SELECT e.name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON e.emp_id = p.emp_id;

-- With WHERE clause
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary > 75000;
```

### 2. LEFT JOIN (LEFT OUTER JOIN)

Returns all rows from left table and matching rows from right table.

**Syntax:**

```sql
SELECT columns
FROM table1
LEFT JOIN table2 ON table1.column = table2.column;
```

**Examples:**

```sql
-- All employees with their departments (including employees without departments)
SELECT e.name, e.salary, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Find employees without departments
SELECT e.name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
```

### 3. RIGHT JOIN (RIGHT OUTER JOIN)

Returns all rows from right table and matching rows from left table.

**Syntax:**

```sql
SELECT columns
FROM table1
RIGHT JOIN table2 ON table1.column = table2.column;
```

**Examples:**

```sql
-- All departments with their employees (including departments without employees)
SELECT d.dept_name, e.name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Find departments without employees
SELECT d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;
```

### 4. FULL OUTER JOIN

Returns all rows when there's a match in either table.

**Syntax:**

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.column = table2.column;
```

**Example:**

```sql
-- All employees and departments (with or without matches)
SELECT e.name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id;
```

**MySQL workaround (no native FULL OUTER JOIN):**

```sql
SELECT e.name, d.dept_name
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

### 5. CROSS JOIN (Cartesian Product)

Returns Cartesian product of both tables.

**Syntax:**

```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

**Examples:**

```sql
-- All possible combinations
SELECT e.name, d.dept_name
FROM employees e
CROSS JOIN departments d;

-- Same as:
SELECT e.name, d.dept_name
FROM employees e, departments d;
```

### 6. SELF JOIN

Joins a table to itself.

**Examples:**

```sql
-- Find employees and their managers
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id;

-- Find employees in same department
SELECT e1.name AS emp1, e2.name AS emp2
FROM employees e1
JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id;
```

### 7. NATURAL JOIN

Automatically joins on columns with same names.

**Syntax:**

```sql
SELECT columns
FROM table1
NATURAL JOIN table2;
```

**Example:**

```sql
-- Joins on all common column names
SELECT *
FROM employees
NATURAL JOIN departments;  -- Joins on dept_id if both tables have it
```

---

## Unions, Intersections, and Minus

### Set Operations Overview

```
        SET OPERATIONS
              |
    ┌─────────┼─────────┐
    |         |         |
  UNION   INTERSECT   EXCEPT/MINUS
    |         |         |
Combines   Common    Difference
  both      rows       rows
```

### UNION

Combines results from multiple SELECT statements.

**Syntax:**

```sql
SELECT columns FROM table1
UNION [ALL]
SELECT columns FROM table2;
```

**Rules:**

- Same number of columns
- Compatible data types
- Column names from first SELECT

**UNION vs UNION ALL:**

```
UNION:                      UNION ALL:
- Removes duplicates        - Keeps all rows
- Slower (sorting)          - Faster
- Distinct results          - May have duplicates
```

**Examples:**

```sql
-- Combine active and inactive employees
SELECT emp_id, name, 'Active' AS status FROM active_employees
UNION
SELECT emp_id, name, 'Inactive' AS status FROM inactive_employees;

-- Keep duplicates with UNION ALL
SELECT dept_id FROM employees
UNION ALL
SELECT dept_id FROM contractors;

-- Multiple UNION
SELECT name FROM employees WHERE dept_id = 10
UNION
SELECT name FROM employees WHERE dept_id = 20
UNION
SELECT name FROM employees WHERE dept_id = 30;
```

**Visual:**

```
Table A:           Table B:           UNION:
┌────┐            ┌────┐             ┌────┐
│ 1  │            │ 2  │             │ 1  │
│ 2  │            │ 3  │             │ 2  │
│ 3  │            │ 4  │             │ 3  │
└────┘            └────┘             │ 4  │
                                     └────┘
```

### INTERSECT

Returns only rows present in both queries.

**Syntax:**

```sql
SELECT columns FROM table1
INTERSECT
SELECT columns FROM table2;
```

**Examples:**

```sql
-- Employees who are also managers
SELECT emp_id FROM employees
INTERSECT
SELECT manager_id FROM departments;

-- Students enrolled in both courses
SELECT student_id FROM enrollments WHERE course_id = 'CS101'
INTERSECT
SELECT student_id FROM enrollments WHERE course_id = 'CS102';
```

**MySQL workaround (no native INTERSECT):**

```sql
-- Using INNER JOIN
SELECT DISTINCT e.emp_id
FROM employees e
INNER JOIN departments d ON e.emp_id = d.manager_id;

-- Using IN
SELECT emp_id FROM employees
WHERE emp_id IN (SELECT manager_id FROM departments);

-- Using EXISTS
SELECT emp_id FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d WHERE d.manager_id = e.emp_id
);
```

**Visual:**

```
Table A:           Table B:           INTERSECT:
┌────┐            ┌────┐             ┌────┐
│ 1  │            │ 2  │             │ 2  │
│ 2  │            │ 3  │             │ 3  │
│ 3  │            │ 4  │             └────┘
└────┘            └────┘
```

### EXCEPT/MINUS

Returns rows from first query not in second query.

**Syntax:**

```sql
-- PostgreSQL, SQL Server
SELECT columns FROM table1
EXCEPT
SELECT columns FROM table2;

-- Oracle
SELECT columns FROM table1
MINUS
SELECT columns FROM table2;
```

**Examples:**

```sql
-- Employees who are not managers
SELECT emp_id FROM employees
EXCEPT
SELECT manager_id FROM departments;

-- Students in CS101 but not in CS102
SELECT student_id FROM enrollments WHERE course_id = 'CS101'
EXCEPT
SELECT student_id FROM enrollments WHERE course_id = 'CS102';
```

**MySQL workaround:**

```sql
-- Using LEFT JOIN
SELECT e.emp_id
FROM employees e
LEFT JOIN departments d ON e.emp_id = d.manager_id
WHERE d.manager_id IS NULL;

-- Using NOT IN
SELECT emp_id FROM employees
WHERE emp_id NOT IN (SELECT manager_id FROM departments WHERE manager_id IS NOT NULL);

-- Using NOT EXISTS
SELECT emp_id FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM departments d WHERE d.manager_id = e.emp_id
);
```

**Visual:**

```
Table A:           Table B:           EXCEPT:
┌────┐            ┌────┐             ┌────┐
│ 1  │            │ 2  │             │ 1  │
│ 2  │            │ 3  │             └────┘
│ 3  │            │ 4  │
└────┘            └────┘
```

---

## Cursors

Cursors allow row-by-row processing of query results.

### Cursor Concept

```
┌─────────────────────────────────────┐
│         RESULT SET                  │
├─────────────────────────────────────┤
│  Row 1: John, 75000        ← CURSOR │
│  Row 2: Jane, 80000                 │
│  Row 3: Bob, 72000                  │
│  Row 4: Alice, 85000                │
└─────────────────────────────────────┘
         |
         ├─ FETCH (get current row)
         ├─ MOVE to next row
         └─ CLOSE when done
```

### Cursor Lifecycle

```
DECLARE → OPEN → FETCH → CLOSE
   |        |       |       |
 Define   Execute  Process  Release
 cursor   query    rows    resources
```

### Cursor Syntax (PL/SQL)

**Declare:**

```sql
DECLARE
    CURSOR emp_cursor IS
    SELECT emp_id, name, salary FROM employees WHERE dept_id = 10;
    
    v_emp_id employees.emp_id%TYPE;
    v_name employees.name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    -- Cursor operations here
END;
```

**Open:**

```sql
OPEN emp_cursor;
```

**Fetch:**

```sql
FETCH emp_cursor INTO v_emp_id, v_name, v_salary;
```

**Close:**

```sql
CLOSE emp_cursor;
```

**Complete Example:**

```sql
DECLARE
    CURSOR emp_cursor IS
        SELECT emp_id, name, salary FROM employees WHERE dept_id = 10;
    
    v_emp_id employees.emp_id%TYPE;
    v_name employees.name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_id, v_name, v_salary;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- Process each row
        DBMS_OUTPUT.PUT_LINE(v_name || ': ' || v_salary);
    END LOOP;
    
    CLOSE emp_cursor;
END;
```

### Cursor Types

**1. Implicit Cursors:**

```sql
-- Automatically created for DML statements
BEGIN
    UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 10;
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
END;
```

**2. Explicit Cursors:**

```sql
-- Manually declared and controlled
DECLARE
    CURSOR emp_cursor IS SELECT * FROM employees;
BEGIN
    -- Manual control
END;
```

**3. Parameterized Cursors:**

```sql
DECLARE
    CURSOR emp_cursor(p_dept_id NUMBER) IS
        SELECT * FROM employees WHERE dept_id = p_dept_id;
BEGIN
    OPEN emp_cursor(10);
    -- Process
    CLOSE emp_cursor;
END;
```

**4. REF Cursors (Cursor Variables):**

```sql
DECLARE
    TYPE emp_cursor_type IS REF CURSOR;
    emp_cursor emp_cursor_type;
BEGIN
    OPEN emp_cursor FOR SELECT * FROM employees WHERE dept_id = 10;
    -- Process
    CLOSE emp_cursor;
END;
```

### Cursor Attributes

```
Attribute          Description
─────────────────────────────────────────────────
%FOUND             TRUE if last FETCH returned row
%NOTFOUND          TRUE if last FETCH didn't return row
%ISOPEN            TRUE if cursor is open
%ROWCOUNT          Number of rows fetched so far
```

**Example:**

```sql
DECLARE
    CURSOR emp_cursor IS SELECT * FROM employees;
    emp_record employees%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Row ' || emp_cursor%ROWCOUNT || 
                             ': ' || emp_record.name);
    END LOOP;
    
    IF emp_cursor%ISOPEN THEN
        CLOSE emp_cursor;
    END IF;
END;
```

### Cursor FOR Loop (Simplified)

```sql
DECLARE
    CURSOR emp_cursor IS SELECT emp_id, name, salary FROM employees;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        -- No need for OPEN, FETCH, CLOSE
        DBMS_OUTPUT.PUT_LINE(emp_record.name || ': ' || emp_record.salary);
    END LOOP;
END;
```

**Even simpler (no cursor declaration):**

```sql
BEGIN
    FOR emp_record IN (SELECT emp_id, name, salary FROM employees) LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.name);
    END LOOP;
END;
```

---

## Triggers

Triggers are stored procedures that automatically execute in response to events.

### Trigger Concept

```
DATABASE EVENT
      |
      ├─ INSERT
      ├─ UPDATE    ──→  TRIGGER FIRES  ──→  ACTION
      └─ DELETE
      
      BEFORE or AFTER the event
```

### Trigger Types

```
              TRIGGERS
                 |
        ┌────────┴────────┐
        |                 |
    ROW-LEVEL        STATEMENT-LEVEL
        |                 |
   (FOR EACH ROW)    (Once per statement)
        |                 |
  ┌─────┴─────┐     ┌─────┴─────┐
  |           |     |           |
BEFORE      AFTER  BEFORE      AFTER
```

### Trigger Timing

**BEFORE Trigger:**

- Executes before the triggering event
- Can modify NEW values
- Can prevent the operation

**AFTER Trigger:**

- Executes after the triggering event
- Cannot modify data being changed
- Can perform additional operations

### Trigger Syntax

**Basic Structure:**

```sql
CREATE TRIGGER trigger_name
{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
ON table_name
[FOR EACH ROW]
[WHEN (condition)]
BEGIN
    -- Trigger body
END;
```

### Trigger Examples

**1. Audit Trail Trigger:**

```sql
-- Log all changes to employees table
CREATE TRIGGER audit_employee_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (
        emp_id, old_salary, new_salary, change_date, changed_by
    ) VALUES (
        :NEW.emp_id, :OLD.salary, :NEW.salary, SYSDATE, USER
    );
END;
```

**2. Validation Trigger:**

```sql
-- Ensure salary is always positive
CREATE TRIGGER check_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be negative');
    END IF;
END;
```

**3. Derived Column Trigger:**

```sql
-- Automatically calculate total_price
CREATE TRIGGER calculate_total
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
BEGIN
    :NEW.total_price := :NEW.quantity * :NEW.unit_price;
END;
```

**4. Referential Integrity Trigger:**

```sql
-- Prevent deletion of department with employees
CREATE TRIGGER prevent_dept_delete
BEFORE DELETE ON departments
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM employees
    WHERE dept_id = :OLD.dept_id;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Cannot delete department with employees');
    END IF;
END;
```

**5. Auto-increment Trigger:**

```sql
-- Automatically generate primary key
CREATE TRIGGER auto_emp_id
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF :NEW.emp_id IS NULL THEN
        SELECT emp_seq.NEXTVAL INTO :NEW.emp_id FROM DUAL;
    END IF;
END;
```

### OLD and NEW Pseudo-records

```
Operation     :OLD              :NEW
───────────────────────────────────────────
INSERT        NULL              New values
UPDATE        Old values        New values
DELETE        Old values        NULL
```

**Example:**

```sql
CREATE TRIGGER log_salary_changes
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee: ' || :NEW.name);
    DBMS_OUTPUT.PUT_LINE('Old Salary: ' || :OLD.salary);
    DBMS_OUTPUT.PUT_LINE('New Salary: ' || :NEW.salary);
    DBMS_OUTPUT.PUT_LINE('Increase: ' || (:NEW.salary - :OLD.salary));
END;
```

### Trigger Management

**View Triggers:**

```sql
-- See all triggers
SELECT trigger_name, table_name, triggering_event
FROM user_triggers;

-- See trigger definition
SELECT trigger_body FROM user_triggers WHERE trigger_name = 'AUDIT_EMPLOYEE_CHANGES';
```

**Disable/Enable Triggers:**

```sql
-- Disable specific trigger
ALTER TRIGGER audit_employee_changes DISABLE;

-- Enable specific trigger
ALTER TRIGGER audit_employee_changes ENABLE;

-- Disable all triggers on a table
ALTER TABLE employees DISABLE ALL TRIGGERS;

-- Enable all triggers on a table
ALTER TABLE employees ENABLE ALL TRIGGERS;
```

**Drop Trigger:**

```sql
DROP TRIGGER audit_employee_changes;
```

### Trigger Best Practices

```
DO:
✓ Keep triggers simple and fast
✓ Document trigger logic
✓ Use for audit trails
✓ Use for maintaining derived data
✓ Handle errors properly

DON'T:
✗ Perform complex business logic
✗ Call external systems
✗ Create cascading triggers
✗ Access many tables
✗ Perform long-running operations
```

---

## Procedures in SQL/PL-SQL

Stored procedures are precompiled SQL code stored in the database.

### Procedure Concept

```
┌─────────────────────────────────────┐
│       STORED PROCEDURE              │
├─────────────────────────────────────┤
│                                     │
│  CREATE PROCEDURE proc_name         │
│  (parameters)                       │
│  AS                                 │
│  BEGIN                              │
│      -- SQL statements              │
│      -- Control structures          │
│      -- Error handling              │
│  END;                               │
│                                     │
└─────────────────────────────────────┘
         ↓
    Compiled and stored in DB
         ↓
    Called multiple times
```

### Procedure Syntax

**Basic Structure:**

```sql
CREATE [OR REPLACE] PROCEDURE procedure_name
(
    parameter1 [IN | OUT | IN OUT] datatype,
    parameter2 [IN | OUT | IN OUT] datatype
)
AS
    -- Variable declarations
BEGIN
    -- Procedure body
EXCEPTION
    -- Error handling
END;
```

### Parameter Modes

```
Mode        Description                       Example
──────────────────────────────────────────────────────────
IN          Input parameter (read-only)       Default mode
OUT         Output parameter (write-only)     Return values
IN OUT      Both input and output             Modify values
```

### Procedure Examples

**1. Simple Procedure:**

```sql
CREATE OR REPLACE PROCEDURE give_raise
(
    p_emp_id IN NUMBER,
    p_amount IN NUMBER
)
AS
BEGIN
    UPDATE employees
    SET salary = salary + p_amount
    WHERE emp_id = p_emp_id;
    
    COMMIT;
END;
/

-- Call procedure
EXECUTE give_raise(101, 5000);
-- Or
BEGIN
    give_raise(101, 5000);
END;
```

**2. Procedure with OUT Parameter:**

```sql
CREATE OR REPLACE PROCEDURE get_employee_info
(
    p_emp_id IN NUMBER,
    p_name OUT VARCHAR2,
    p_salary OUT NUMBER
)
AS
BEGIN
    SELECT name, salary
    INTO p_name, p_salary
    FROM employees
    WHERE emp_id = p_emp_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_name := NULL;
        p_salary := NULL;
END;
/

-- Call procedure
DECLARE
    v_name VARCHAR2(100);
    v_salary NUMBER;
BEGIN
    get_employee_info(101, v_name, v_salary);
    DBMS_OUTPUT.PUT_LINE(v_name || ': ' || v_salary);
END;
```

**3. Procedure with IN OUT Parameter:**

```sql
CREATE OR REPLACE PROCEDURE apply_bonus
(
    p_salary IN OUT NUMBER,
    p_percentage IN NUMBER
)
AS
BEGIN
    p_salary := p_salary * (1 + p_percentage / 100);
END;
/

-- Call procedure
DECLARE
    v_salary NUMBER := 75000;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before: ' || v_salary);
    apply_bonus(v_salary, 10);
    DBMS_OUTPUT.PUT_LINE('After: ' || v_salary);
END;
```

**4. Complex Procedure with Control Structures:**

```sql
CREATE OR REPLACE PROCEDURE process_department
(
    p_dept_id IN NUMBER,
    p_raise_percent IN NUMBER
)
AS
    v_emp_count NUMBER;
    v_total_salary NUMBER;
BEGIN
    -- Get employee count
    SELECT COUNT(*), SUM(salary)
    INTO v_emp_count, v_total_salary
    FROM employees
    WHERE dept_id = p_dept_id;
    
    -- Check if department has employees
    IF v_emp_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees in department');
        RETURN;
    END IF;
    
    -- Give raise to all employees
    UPDATE employees
    SET salary = salary * (1 + p_raise_percent / 100)
    WHERE dept_id = p_dept_id;
    
    -- Log the change
    INSERT INTO salary_audit (dept_id, emp_count, old_total, change_date)
    VALUES (p_dept_id, v_emp_count, v_total_salary, SYSDATE);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Processed ' || v_emp_count || ' employees');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
```

### Control Structures in Procedures

**1. IF-THEN-ELSE:**

```sql
IF condition THEN
    -- statements
ELSIF condition THEN
    -- statements
ELSE
    -- statements
END IF;
```

**2. CASE:**

```sql
CASE variable
    WHEN value1 THEN
        -- statements
    WHEN value2 THEN
        -- statements
    ELSE
        -- statements
END CASE;
```

**3. LOOP:**

```sql
LOOP
    -- statements
    EXIT WHEN condition;
END LOOP;
```

**4. WHILE LOOP:**

```sql
WHILE condition LOOP
    -- statements
END LOOP;
```

**5. FOR LOOP:**

```sql
FOR counter IN 1..10 LOOP
    -- statements
END LOOP;
```

### Exception Handling

```sql
BEGIN
    -- Procedure logic
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle no data
    WHEN TOO_MANY_ROWS THEN
        -- Handle multiple rows
    WHEN OTHERS THEN
        -- Handle all other errors
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
```

### Procedure Management

**View Procedures:**

```sql
-- List all procedures
SELECT object_name, object_type
FROM user_objects
WHERE object_type = 'PROCEDURE';

-- View procedure source
SELECT text
FROM user_source
WHERE name = 'GIVE_RAISE'
ORDER BY line;
```

**Drop Procedure:**

```sql
DROP PROCEDURE give_raise;
```

### Procedures vs Functions

```
Feature              Procedure              Function
────────────────────────────────────────────────────────
Return value         Via OUT parameters     RETURN statement
Usage                EXECUTE/CALL           In SQL expressions
Purpose              Perform actions        Calculate/return value
DML operations       Yes                    Limited
Transaction control  Yes                    No
```

---

## Summary and Quick Reference

### RDBMS Concepts Hierarchy

```
RELATIONAL DATABASE
├── Data Model
│   ├── Relations (Tables)
│   ├── Tuples (Rows)
│   └── Attributes (Columns)
├── Integrity Constraints
│   ├── Domain Constraints
│   ├── Key Constraints (PK, CK, SK)
│   ├── Entity Integrity
│   └── Referential Integrity (FK)
├── Relational Algebra
│   ├── Selection (σ)
│   ├── Projection (π)
│   ├── Union (∪)
│   ├── Difference (−)
│   ├── Cartesian Product (×)
│   └── Join (⋈)
└── Relational Calculus
    ├── Tuple Calculus
    └── Domain Calculus
```

### SQL Command Summary

```
DDL (Definition)        DML (Manipulation)      DQL (Query)
├── CREATE             ├── INSERT              └── SELECT
├── ALTER              ├── UPDATE
├── DROP               ├── DELETE
├── TRUNCATE           └── MERGE
└── RENAME

DCL (Control)          TCL (Transaction)
├── GRANT              ├── COMMIT
└── REVOKE             ├── ROLLBACK
                       └── SAVEPOINT
```

### Key Formulas and Concepts

**Cardinality and Degree:**

```
Cardinality = Number of tuples (rows
```