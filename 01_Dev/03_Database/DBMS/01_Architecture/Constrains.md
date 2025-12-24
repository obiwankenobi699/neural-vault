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


---

## **1. Mapping Constraints**

Mapping constraints define **how entities from different entity sets participate in a relationship**. They restrict the possible mappings between entities.

### **Types of Mapping Constraints**
1> cardinality ratio 
2> participation ratio




## 1.Cardinality ratios
### **(a) One-to-One (1:1)**

Each entity in set A maps to **at most one** entity in set B, and vice-versa.

```
A (1) <-------> (1) B
```

**Example:**  
Each person has exactly one passport.

---

### **(b) One-to-Many (1:N)**

One entity in A can be associated with **many** entities in B,  
but each entity in B maps to **at most one** entity in A.

```
A (1) <------- (N) B
```

**Example:**  
One department has many employees, but each employee belongs to one department.

---

### **(c) Many-to-One (N:1)**

Reverse of 1:N.

```
A (N) -------> (1) B
```

**Example:**  
Many students are assigned to one mentor.

---

### **(d) Many-to-Many (M:N)**

Entities on both sides can have multiple associations.

```
A (M) <------> (N) B
```

**Example:**  
A student can enroll in many courses; a course has many students.

---
# **2. Participation Ratio

Participation Ratio specifies **whether the existence of an entity depends on participation in a relationship** or not.

It describes the **qualitative nature** of a relationship.

There are **two types**:

---

## **(a) Total Participation**

Entity **must** participate in the relationship.  
Shown by a **double line** in ERD.

`A ==--- R ---== B`

Meaning: all entities of A **must** have a relationship instance.

**Example:**  
Every department must have at least one employee.  
(If a department cannot exist without employees → total participation)

---

## **(b) Partial Participation**

Entity **may or may not** participate in the relationship.  
Shown by a **single line**.

`A -- R -- B`

Meaning: some entities of A participate in R, some do not.

**Example:**  
Some employees may not have assigned projects.
## **3. Foreign Key**

A **foreign key (FK)** is an attribute in one table that **refers to the primary key (PK)** of another table.

### **Purpose**

- Establishes **referential integrity** between relations.
    
- Ensures that relationships between tables remain consistent.
    

### **Example**

```
STUDENT( StudentID PK, Name, DeptID FK )
DEPARTMENT( DeptID PK, DeptName )
```

`DeptID` in STUDENT references `DeptID` in DEPARTMENT.

### **Referential Integrity Rules**

- FK value must be **present in the parent table** (or NULL if allowed).
    
- Deleting parent row may:
    
    - RESTRICT (block deletion)
        
    - CASCADE (delete child rows)
        
    - SET NULL (child FK set to NULL)
        
    - SET DEFAULT
        

---

## **4. Relations (In Relational Model)**

A **relation** in DBMS is essentially a **table**.

### **Characteristics of a Relation**

- Has **rows (tuples)**
    
- Has **columns (attributes)**
    
- All values must be **atomic** (no multi-valued attributes)
    
- No duplicate tuples
    
- Order of rows and columns does not matter
    

### **Structure of a Relation**

```
+-----------+-----------+----------+
| RollNo PK | Name      | Marks    |
+-----------+-----------+----------+
| 101       | Arjun     | 90       |
| 102       | Meera     | 86       |
+-----------+-----------+----------+
```

### **Keys in a Relation**

- **Primary Key (PK)** → uniquely identifies tuples
    
- **Foreign Key (FK)** → maintains links between tables
    
- **Candidate Key** → possible PK
    
- **Super Key** → PK + extra attributes
    
- **Alternate Key** → candidate keys not chosen as PK
    


---
