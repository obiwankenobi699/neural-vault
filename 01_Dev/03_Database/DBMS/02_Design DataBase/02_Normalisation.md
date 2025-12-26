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

## TABLE OF CONTENTS

1. Introduction to Normalization
2. Unnormalized Form (UNF)
3. First Normal Form (1NF)
4. Second Normal Form (2NF)
5. Third Normal Form (3NF)
6. Boyce-Codd Normal Form (BCNF)
7. Complete Example
8. Summary

---

# 1. INTRODUCTION TO NORMALIZATION

## What is Normalization?

**Definition:** Normalization is a systematic process of organizing data in a database to:

- Reduce data redundancy
- Eliminate insertion, update, and deletion anomalies
- Ensure data dependencies make sense
- Improve data integrity

## Why Normalize?

### Problems Without Normalization:

**1. Data Redundancy**

- Same information stored multiple times
- Wastes storage space
- Harder to maintain consistency

**2. Update Anomaly**

- Must update multiple rows for single change
- Risk of inconsistency if some rows missed

**3. Insertion Anomaly**

- Cannot insert data without other required data
- Example: Cannot add department without employee

**4. Deletion Anomaly**

- Deleting one piece of information loses other useful data
- Example: Deleting last employee removes department info

---

# 2. UNNORMALIZED FORM (UNF)

## Example: Library Management System

Let's start with raw, unnormalized data:

### LIBRARY_DATA Table (UNF)

|StudentID|StudentName|Phone|BooksIssued|Author|ReturnDate|
|---|---|---|---|---|---|
|S101|Rahul Kumar|9999999999, 8888888888|Database Systems, Operating Systems|Elmasri, Silberschatz|2024-02-15, 2024-02-20|
|S102|Priya Singh|7777777777|Computer Networks, Data Structures, Algorithm Design|Tanenbaum, Cormen, Kleinberg|2024-02-18, 2024-02-22, 2024-02-25|
|S103|Amit Sharma|6666666666|Database Systems|Elmasri|2024-02-16|

### Problems in UNF:

**1. Multi-valued Attributes**

```
Phone: "9999999999, 8888888888" (multiple values in one cell)
BooksIssued: "Database Systems, Operating Systems" (multiple values)
Author: "Elmasri, Silberschatz" (multiple values)
ReturnDate: "2024-02-15, 2024-02-20" (multiple values)
```

**2. Repeating Groups**

- Book information repeats for each book issued

**3. No Clear Primary Key**

- Cannot uniquely identify each row

**4. Data Redundancy**

- Student information repeated for each book
- Same book details stored multiple times

**5. Difficult to Query**

- Hard to search: "Find all students who borrowed X book"
- Cannot easily count: "How many books did each student borrow?"

---

# 3. FIRST NORMAL FORM (1NF)

## Rules for 1NF

**Rule 1:** Each cell must contain ATOMIC (single) values

- No comma-separated values
- No multiple values in one cell

**Rule 2:** No REPEATING GROUPS

- No columns like Phone1, Phone2, Phone3

**Rule 3:** Each column must contain values of SAME TYPE

**Rule 4:** Each column must have a UNIQUE NAME

**Rule 5:** Order of rows doesn't matter

**Rule 6:** Must have a PRIMARY KEY

## Converting UNF to 1NF

### Strategy:

Split multi-valued attributes into separate rows, making each cell atomic.

### LIBRARY_DATA Table (1NF)

|StudentID|StudentName|Phone|BookTitle|Author|ReturnDate|
|---|---|---|---|---|---|
|S101|Rahul Kumar|9999999999|Database Systems|Elmasri|2024-02-15|
|S101|Rahul Kumar|8888888888|Database Systems|Elmasri|2024-02-15|
|S101|Rahul Kumar|9999999999|Operating Systems|Silberschatz|2024-02-20|
|S101|Rahul Kumar|8888888888|Operating Systems|Silberschatz|2024-02-20|
|S102|Priya Singh|7777777777|Computer Networks|Tanenbaum|2024-02-18|
|S102|Priya Singh|7777777777|Data Structures|Cormen|2024-02-22|
|S102|Priya Singh|7777777777|Algorithm Design|Kleinberg|2024-02-25|
|S103|Amit Sharma|6666666666|Database Systems|Elmasri|2024-02-16|

**Primary Key:** (StudentID, Phone, BookTitle)

### Changes Made:

**Before (UNF):** 3 rows with multi-valued cells **After (1NF):** 8 rows with atomic values

**Benefits:**

- All cells now contain single values
- Can use SQL operations properly
- Primary key defined

### Problems Still Remaining in 1NF:

**1. Data Redundancy**

```
"Rahul Kumar" appears 4 times
"Database Systems" appears 3 times
"Elmasri" appears 3 times
```

**2. Update Anomaly**

```
To change "Rahul Kumar" to "Rahul K. Sharma":
- Must update 4 rows
- Risk: Might miss one row → inconsistency
```

**3. Insertion Anomaly**

```
Cannot add a student without issuing books
(BookTitle is part of primary key)
```

**4. Deletion Anomaly**

```
If S103 returns "Database Systems":
- We lose all information about S103
- Last book for that student
```

---

# 4. SECOND NORMAL FORM (2NF)

## Understanding Partial Dependency

### What is Partial Dependency?

**Definition:** When a non-prime attribute depends on PART of a composite primary key (not the whole key).

**Example from our 1NF table:**

```
Primary Key: (StudentID, Phone, BookTitle)
              ↓           ↓         ↓
           Part 1      Part 2    Part 3

StudentName depends ONLY on StudentID (part of key)
→ This is PARTIAL DEPENDENCY
```

### Functional Dependencies in 1NF Table

**Primary Key:** (StudentID, Phone, BookTitle)

**FD1:** StudentID → StudentName

- PARTIAL (depends on part of key)

**FD2:** StudentID → Phone

- PARTIAL (depends on part of key)

**FD3:** BookTitle → Author

- PARTIAL (depends on part of key)

**FD4:** (StudentID, BookTitle) → ReturnDate

- FULL (depends on StudentID AND BookTitle)

**Problem:** FD1, FD2, FD3 are PARTIAL dependencies → Violates 2NF

## Rules for 2NF

**Rule 1:** Must be in 1NF

**Rule 2:** No PARTIAL DEPENDENCY

- Non-prime attributes must depend on ENTIRE primary key
- Not just part of it

**Note:** Only applies when primary key is COMPOSITE (multiple attributes)

## Converting 1NF to 2NF

### Decomposition Strategy:

Split into 4 tables to remove partial dependencies:

1. **STUDENT** - StudentID, StudentName
2. **STUDENT_PHONE** - StudentID, Phone
3. **BOOK** - BookTitle, Author
4. **ISSUE** - StudentID, BookTitle, ReturnDate

### Table 1: STUDENT (2NF)

|StudentID|StudentName|
|---|---|
|S101|Rahul Kumar|
|S102|Priya Singh|
|S103|Amit Sharma|

**FD:** StudentID → StudentName ✓ **Primary Key:** StudentID **Status:** No partial dependency (single attribute key)

### Table 2: STUDENT_PHONE (2NF)

|StudentID|Phone|
|---|---|
|S101|9999999999|
|S101|8888888888|
|S102|7777777777|
|S103|6666666666|

**Primary Key:** (StudentID, Phone) **Status:** No partial dependency (both are key attributes)

### Table 3: BOOK (2NF)

|BookTitle|Author|
|---|---|
|Database Systems|Elmasri|
|Operating Systems|Silberschatz|
|Computer Networks|Tanenbaum|
|Data Structures|Cormen|
|Algorithm Design|Kleinberg|

**FD:** BookTitle → Author ✓ **Primary Key:** BookTitle **Status:** No partial dependency (single attribute key)

### Table 4: ISSUE (2NF)

|StudentID|BookTitle|ReturnDate|
|---|---|---|
|S101|Database Systems|2024-02-15|
|S101|Operating Systems|2024-02-20|
|S102|Computer Networks|2024-02-18|
|S102|Data Structures|2024-02-22|
|S102|Algorithm Design|2024-02-25|
|S103|Database Systems|2024-02-16|

**FD:** (StudentID, BookTitle) → ReturnDate ✓ **Primary Key:** (StudentID, BookTitle) **Status:** No partial dependency (ReturnDate depends on BOTH key parts)

### Benefits of 2NF:

**1. Reduced Redundancy**

```
Before: "Rahul Kumar" appeared 4 times
After: "Rahul Kumar" appears once in STUDENT table
```

**2. Better Updates**

```
Before: Change name → update 4 rows
After: Change name → update 1 row
```

**3. Insertion Flexibility**

```
Before: Cannot add student without books
After: Can add student in STUDENT table directly
```

**4. Deletion Safety**

```
Before: Return last book → lose student info
After: Student info remains in STUDENT table
```

### Problems Still Remaining:

Let's extend the BOOK table with publisher information:

|BookTitle|Author|Publisher|Pub_City|Pub_Phone|
|---|---|---|---|---|
|Database Systems|Elmasri|Pearson|Delhi|9876543210|
|Operating Systems|Silberschatz|Wiley|Mumbai|8765432109|
|Computer Networks|Tanenbaum|Pearson|Delhi|9876543210|
|Data Structures|Cormen|MIT Press|Boston|7654321098|
|Algorithm Design|Kleinberg|Pearson|Delhi|9876543210|

**Problem Identified:**

```
BookTitle → Publisher → Pub_City
BookTitle → Publisher → Pub_Phone

This is TRANSITIVE DEPENDENCY:
- Pub_City depends on Publisher (not on key directly)
- Pub_Phone depends on Publisher (not on key directly)
```

---

# 5. THIRD NORMAL FORM (3NF)

## Understanding Transitive Dependency

### What is Transitive Dependency?

**Definition:** When a non-prime attribute depends on another non-prime attribute (not on the key directly).

**Formula:**

```
If A → B and B → C
Then A → C (Transitive)
```

**Example from our BOOK table:**

```
BookTitle → Publisher (Direct)
Publisher → Pub_City (Direct)
Therefore: BookTitle → Pub_City (Transitive)

BookTitle → Publisher (Direct)
Publisher → Pub_Phone (Direct)
Therefore: BookTitle → Pub_Phone (Transitive)
```

### Functional Dependencies in Extended BOOK Table

**Primary Key:** BookTitle

**Direct Dependencies:**

- BookTitle → Author ✓
- BookTitle → Publisher ✓

**Publisher Dependencies:**

- Publisher → Pub_City ✓
- Publisher → Pub_Phone ✓

**Transitive Dependencies:**

- BookTitle → Publisher → Pub_City ✗
- BookTitle → Publisher → Pub_Phone ✗

**Problem:** Pub_City and Pub_Phone are non-prime attributes depending on another non-prime attribute (Publisher)

### Problems with Transitive Dependency:

**1. Data Redundancy**

```
"Pearson, Delhi, 9876543210" repeated 3 times
```

**2. Update Anomaly**

```
Scenario: Pearson moves from Delhi to Noida
Action: Must update 3 rows (all Pearson books)
Risk: Might miss one → inconsistency
```

**3. Insertion Anomaly**

```
Cannot add publisher info without a book
Example: New publisher "Oxford" in Bangalore
Must wait for a book from Oxford
```

**4. Deletion Anomaly**

```
Scenario: Remove "Data Structures" (only MIT Press book)
Result: Lose all information about MIT Press
        (City: Boston, Phone: 7654321098)
```

## Rules for 3NF

**Rule 1:** Must be in 2NF

**Rule 2:** No TRANSITIVE DEPENDENCY

- Non-prime attributes should depend ONLY on primary key
- Not on other non-prime attributes

**Formal Definition:**

For every FD X → Y, one of following must be true:

- X is a super key, OR
- Y is a prime attribute

## Converting 2NF to 3NF

### Decomposition Strategy:

Split BOOK table into 2 tables:

1. **BOOK** - BookTitle, Author, Publisher
2. **PUBLISHER** - Publisher, Pub_City, Pub_Phone

### Table 1: BOOK (3NF)

|BookTitle|Author|Publisher|
|---|---|---|
|Database Systems|Elmasri|Pearson|
|Operating Systems|Silberschatz|Wiley|
|Computer Networks|Tanenbaum|Pearson|
|Data Structures|Cormen|MIT Press|
|Algorithm Design|Kleinberg|Pearson|

**FD:** BookTitle → Author, Publisher ✓ **Primary Key:** BookTitle **Status:** No transitive dependency

### Table 2: PUBLISHER (3NF)

|Publisher|Pub_City|Pub_Phone|
|---|---|---|
|Pearson|Delhi|9876543210|
|Wiley|Mumbai|8765432109|
|MIT Press|Boston|7654321098|

**FD:** Publisher → Pub_City, Pub_Phone ✓ **Primary Key:** Publisher **Status:** No transitive dependency (Publisher is the key)

### Complete Database in 3NF:

**1. STUDENT**

- StudentID (PK)
- StudentName

**2. STUDENT_PHONE**

- StudentID (PK, FK)
- Phone (PK)

**3. BOOK**

- BookTitle (PK)
- Author
- Publisher (FK)

**4. PUBLISHER**

- Publisher (PK)
- Pub_City
- Pub_Phone

**5. ISSUE**

- StudentID (PK, FK)
- BookTitle (PK, FK)
- ReturnDate

### Benefits of 3NF:

**1. Eliminated Transitive Dependency**

- No non-key → non-key dependencies

**2. Further Reduced Redundancy**

```
Before: "Pearson, Delhi, 9876543210" × 3 times
After: "Pearson, Delhi, 9876543210" × 1 time
```

**3. Better Updates**

```
Before: Update Pearson city → 3 rows
After: Update Pearson city → 1 row
```

**4. Insertion Flexibility**

```
Before: Cannot add publisher without book
After: Can add publisher directly in PUBLISHER table
```

**5. Deletion Safety**

```
Before: Delete last book → lose publisher info
After: Publisher info remains in PUBLISHER table
```

---

# 6. BOYCE-CODD NORMAL FORM (BCNF)

## Understanding BCNF

### What is BCNF?

**Definition:** A stricter version of 3NF

**Rule:** For EVERY functional dependency X → Y, X must be a SUPER KEY

**Difference from 3NF:**

- 3NF allows: Prime attribute depending on non-super-key
- BCNF doesn't allow: ANY attribute depending on non-super-key

**Relationship:**

- Every BCNF relation is in 3NF
- Not every 3NF relation is in BCNF

### When is a Relation in 3NF but NOT BCNF?

**Scenario:** When there's an FD where:

- LHS is NOT a super key
- RHS IS a prime attribute

This passes 3NF (because RHS is prime) But fails BCNF (because LHS is not super key)

## Example: COURSE_INSTRUCTOR

### Business Rules:

- One student can take multiple courses
- One course can have multiple students
- **Each instructor teaches only ONE specific course**
- One course can be taught by multiple instructors

### Initial Table (3NF but not BCNF)

|StudentID|Course|Instructor|
|---|---|---|
|S101|Database Systems|Dr. Kumar|
|S101|Operating Systems|Dr. Sharma|
|S102|Database Systems|Dr. Kumar|
|S102|Computer Networks|Dr. Verma|
|S103|Database Systems|Dr. Patel|
|S103|Operating Systems|Dr. Sharma|
|S104|Computer Networks|Dr. Verma|

### Functional Dependencies:

**FD1:** (StudentID, Course) → Instructor

- Full dependency

**FD2:** Instructor → Course

- One instructor teaches only one course

**Problem:** FD2 violates BCNF because Instructor is NOT a super key

### Finding Candidate Keys:

**Try: (StudentID, Course)+**

```
Start: {StudentID, Course}
Apply FD1: Add Instructor
Result: {StudentID, Course, Instructor} ✓
```

**Try: (StudentID, Instructor)+**

```
Start: {StudentID, Instructor}
Apply FD2: Instructor → Course, Add Course
Result: {StudentID, Instructor, Course} ✓
```

**Candidate Keys:**

- (StudentID, Course)
- (StudentID, Instructor)

**Prime Attributes:** StudentID, Course, Instructor (all are prime!) **Non-Prime Attributes:** NONE

### Checking Normal Forms:

**Check 1NF:**

- All values atomic? YES ✓

**Check 2NF:**

- Any partial dependency?
- All attributes are prime, so NO ✓

**Check 3NF:**

- Any transitive among non-prime?
- No non-prime attributes, so NO ✓
- **IN 3NF ✓**

**Check BCNF:**

```
For FD: Instructor → Course
- Is Instructor a super key?
- Instructor+ = {Instructor, Course}
- Cannot determine StudentID
- NOT a super key ✗

Result: IN 3NF but NOT IN BCNF
```

### Problems with This Structure:

**1. Redundancy**

```
"Dr. Kumar teaches Database Systems" repeated for S101, S102
```

**2. Update Anomaly**

```
Scenario: Dr. Kumar now teaches "Data Mining"
Action: Must update multiple rows (all students with Dr. Kumar)
```

**3. Insertion Anomaly**

```
Cannot record "Dr. Shah teaches AI" without a student enrollment
```

**4. Deletion Anomaly**

```
If S103 drops Database Systems with Dr. Patel
and no other student takes it,
we lose info that Dr. Patel teaches Database Systems
```

## Converting to BCNF

### Decomposition Strategy:

**Violating FD:** Instructor → Course (Instructor is not super key)

**Decompose into:**

**R1:** Attributes in violating FD

- {Instructor, Course}

**R2:** Original - (RHS of violating FD - LHS)

- {StudentID, Course, Instructor} - (Course)
- {StudentID, Instructor}

### Table 1: INSTRUCTOR_COURSE (BCNF)

|Instructor|Course|
|---|---|
|Dr. Kumar|Database Systems|
|Dr. Sharma|Operating Systems|
|Dr. Verma|Computer Networks|
|Dr. Patel|Database Systems|

**FD:** Instructor → Course ✓ **Candidate Key:** Instructor (super key ✓) **Status:** In BCNF ✓

### Table 2: STUDENT_INSTRUCTOR (BCNF)

|StudentID|Instructor|
|---|---|
|S101|Dr. Kumar|
|S101|Dr. Sharma|
|S102|Dr. Kumar|
|S102|Dr. Verma|
|S103|Dr. Patel|
|S103|Dr. Sharma|
|S104|Dr. Verma|

**Primary Key:** (StudentID, Instructor) **Status:** In BCNF ✓

### Verifying BCNF:

**INSTRUCTOR_COURSE:**

- FD: Instructor → Course
- Candidate Key: Instructor
- Is Instructor a super key? YES ✓

**STUDENT_INSTRUCTOR:**

- Primary Key: (StudentID, Instructor)
- No other FDs exist
- Trivially in BCNF ✓

**Both tables are in BCNF ✓**

### Benefits of BCNF:

**1. Complete Elimination of Redundancy**

- Each fact stored exactly once

**2. No Update Anomalies**

- Change instructor's course in one place

**3. No Insertion Anomalies**

- Can add instructor-course mapping independently

**4. No Deletion Anomalies**

- Removing enrollment doesn't lose instructor info

**5. Maximum Data Integrity**

- Impossible to have inconsistent data

---

# 7. COMPLETE NORMALIZED DATABASE

## Final Schema (BCNF)

### All Tables:

**1. STUDENT**

```
StudentID (PK)
StudentName
```

**2. STUDENT_PHONE**

```
StudentID (PK, FK → STUDENT)
Phone (PK)
```

**3. BOOK**

```
BookTitle (PK)
Author
Publisher (FK → PUBLISHER)
```

**4. PUBLISHER**

```
Publisher (PK)
Pub_City
Pub_Phone
```

**5. ISSUE**

```
StudentID (PK, FK → STUDENT)
BookTitle (PK, FK → BOOK)
ReturnDate
```

**6. INSTRUCTOR_COURSE**

```
Instructor (PK)
Course
```

**7. STUDENT_INSTRUCTOR**

```
StudentID (PK, FK → STUDENT)
Instructor (PK, FK → INSTRUCTOR_COURSE)
```

## Comparison Across Normalization Stages

### Data Volume:

|Stage|Tables|Redundancy|Anomalies|
|---|---|---|---|
|UNF|1|Very High|All Present|
|1NF|1|High|All Present|
|2NF|4|Medium|Some Present|
|3NF|5|Low|Few Present|
|BCNF|7|None|None|

### Features:

|Form|Eliminates|
|---|---|
|**1NF**|Multi-valued attributes, Repeating groups|
|**2NF**|Partial dependencies|
|**3NF**|Transitive dependencies (non-prime → non-prime)|
|**BCNF**|All dependencies where determinant is not super key|

---

# 8. SUMMARY AND QUICK REFERENCE

## Normalization Process Flow

```
UNF (Unnormalized)
    ↓
    Remove multi-valued attributes
    Remove repeating groups
    ↓
1NF (Atomic values, Primary key)
    ↓
    Remove partial dependencies
    ↓
2NF (No partial dependency)
    ↓
    Remove transitive dependencies
    ↓
3NF (No transitive dependency)
    ↓
    Ensure all determinants are super keys
    ↓
BCNF (Every determinant is super key)
```

## Quick Decision Guide

**Is your table in 1NF?**

- All cells have single values? → YES, check 2NF
- Has multi-valued cells? → NO, fix first

**Is your table in 2NF?**

- Has composite key? → Check for partial dependencies
- Single attribute key? → Automatically in 2NF, check 3NF

**Is your table in 3NF?**

- Any non-key → non-key dependency? → NO, fix first
- All non-keys depend only on key? → YES, check BCNF

**Is your table in BCNF?**

- For every FD, is LHS a super key? → YES, in BCNF
- Any FD where LHS is not super key? → NO, decompose

## Key Concepts

**Partial Dependency:**

- Non-prime attribute depends on PART of composite key

**Transitive Dependency:**

- A → B and B → C, therefore A → C
- Non-prime → Non-prime

**Super Key:**

- Any combination that uniquely identifies tuple

**Candidate Key:**

- Minimal super key (no proper subset is key)

**Prime Attribute:**

- Part of at least one candidate key

**Non-Prime Attribute:**

- Not part of any candidate key

## Benefits vs Trade-offs

### Benefits of Normalization:

✓ Data integrity ✓ Reduced redundancy ✓ Easier updates ✓ No anomalies ✓ Flexible schema ✓ Better security ✓ Optimized storage

### Trade-offs:

✗ More joins needed ✗ More tables to manage ✗ Query complexity increases ✗ May impact read performance

### When to Denormalize:

- Read-heavy applications (reporting, analytics)
- Performance is critical
- Data rarely changes
- Redundancy is acceptable

---

**END OF GUIDE**

This complete guide covers normalization from UNF to BCNF with a practical library management system example, showing all transformations, problems, and solutions at each stage.