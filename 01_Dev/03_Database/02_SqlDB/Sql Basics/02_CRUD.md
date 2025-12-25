---
title: 02_CRUD
tags:
  - database
  - Sql
created: 2025-12-25
updated:
  "{ date }":
---
## TABLE OF CONTENTS

1. Theory: Database vs Table Operations
2. Database CRUD Operations
3. Table CRUD Operations
4. Constraints Reference
5. Data Types Reference
6. psql Meta-Commands
7. Common Patterns & Examples
8. Troubleshooting Commands

---

## PART 1: THEORY

### Understanding CRUD

**CRUD Definition:**

- **C**reate: Add new data (INSERT, CREATE)
- **R**ead: Retrieve data (SELECT, LIST)
- **U**pdate: Modify existing data (UPDATE, ALTER)
- **D**elete: Remove data (DELETE, DROP)

### Database vs Table Operations

**Database Level:**

- Contains multiple tables, views, sequences
- Managed by database owner
- Authentication configured in pg_hba.conf
- Connection required to access tables

**Table Level:**

- Stores actual data in rows and columns
- Has schema (structure definition)
- Contains constraints and indexes
- Belongs to a specific database

### PostgreSQL Architecture Hierarchy

```
PostgreSQL Server (Port 5432)
    |
    +-- Database Cluster
        |
        +-- Database 1 (e.g., postgres)
        |   |
        |   +-- Schema (e.g., public)
        |       |
        |       +-- Tables
        |       +-- Views
        |       +-- Sequences
        |       +-- Indexes
        |
        +-- Database 2 (e.g., myapp_db)
            |
            +-- Schema (public)
                |
                +-- Tables
                +-- Views
                +-- Sequences
```

### Connection Context

**Important Concept:**

- You must be connected to a specific database to work with its tables
- Cannot directly access tables from other databases
- Use `\c database_name` to switch context

---

## DATABASE CRUD OPERATIONS

### 2.1 CREATE Database

**Basic Syntax:**

```sql
CREATE DATABASE database_name;
```

**With Options:**

```sql
CREATE DATABASE database_name
    OWNER owner_name
    ENCODING 'UTF8'
    LC_COLLATE 'en_US.UTF-8'
    LC_CTYPE 'en_US.UTF-8'
    TEMPLATE template0
    CONNECTION LIMIT 100;
```

**Common Examples:**

```sql
-- Simple creation
CREATE DATABASE company_db;

-- With owner
CREATE DATABASE company_db OWNER admin_user;

-- From template
CREATE DATABASE myapp_db TEMPLATE template0;
```

**Template Databases:**

- `template0`: Pristine, read-only template
- `template1`: Default template (modifiable)
- New databases clone from template1 by default

---

### 2.2 READ (List) Databases

**psql Meta-Commands:**

```sql
\l                          -- List all databases
\l+                         -- Detailed listing with size
\list                       -- Same as \l
```

**SQL Queries:**

```sql
-- Simple list
SELECT datname FROM pg_database;

-- Detailed information
SELECT 
    datname AS database,
    pg_get_userbyid(datdba) AS owner,
    pg_encoding_to_char(encoding) AS encoding
FROM pg_database;

-- Filter user databases
SELECT datname FROM pg_database 
WHERE datname NOT IN ('template0', 'template1', 'postgres');
```

**Check Current Database:**

```sql
SELECT current_database();
\conninfo
```

**Database Size:**

```sql
SELECT pg_size_pretty(pg_database_size('database_name'));
```

---

### 2.3 UPDATE Database

**Rename Database:**

```sql
ALTER DATABASE old_name RENAME TO new_name;
```

**Change Owner:**

```sql
ALTER DATABASE database_name OWNER TO new_owner;
```

**Change Connection Limit:**

```sql
ALTER DATABASE database_name CONNECTION LIMIT 200;
ALTER DATABASE database_name CONNECTION LIMIT -1;  -- Unlimited
```

**Important Notes:**

- Cannot rename database you're currently connected to
- Must disconnect from database first
- Connect to different database (e.g., postgres) before renaming

---

### 2.4 DELETE Database

**Basic DROP:**

```sql
DROP DATABASE database_name;
```

**Safe DROP (No Error if Not Exists):**

```sql
DROP DATABASE IF EXISTS database_name;
```

**Force Drop (Terminate Active Connections):**

```sql
-- Step 1: Terminate all connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'database_name'
  AND pid <> pg_backend_pid();

-- Step 2: Drop database
DROP DATABASE database_name;
```

**Critical Warnings:**

- Cannot drop database you're connected to
- Operation is irreversible (no undo)
- All data permanently lost
- Must terminate active connections first

---

### 2.5 Switch Database Context

**PostgreSQL Method (No USE command):**

```sql
\c database_name            -- Switch to database
\c database_name username   -- Switch with specific user
```

**From Command Line:**

```bash
psql -U username -d database_name
psql -U username -d database_name -h localhost
```

**Why Switching is Important:**

- Must be in correct database to access its tables
- Each database is isolated
- Tables only visible in their own database

---

## PART 3: TABLE CRUD OPERATIONS

### 3.1 CREATE Table

**Basic Syntax:**

```sql
CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    table_constraints
);
```

**Complete Example:**

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    age INTEGER CHECK(age >= 16 AND age <= 100),
    gender CHAR(1) CHECK(gender IN ('M', 'F', 'O')),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    gpa NUMERIC(3,2) CHECK(gpa BETWEEN 0 AND 4),
    dept_id INTEGER,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);
```

**Create from Existing Table:**

```sql
-- Structure only (no data)
CREATE TABLE students_backup (LIKE students);

-- Structure and data
CREATE TABLE students_backup AS SELECT * FROM students;

-- With conditions
CREATE TABLE active_students AS 
SELECT * FROM students WHERE is_active = TRUE;
```

**Temporary Table:**

```sql
CREATE TEMP TABLE temp_students (
    student_id INTEGER,
    name VARCHAR(100)
);
-- Exists only for current session
```

---

### 3.2 READ (List/Describe) Tables

**List Tables:**

```sql
\dt                         -- List all tables
\dt+                        -- Detailed list with size
\dt pattern*                -- List matching pattern
```

**SQL Query:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE';
```

**Describe Table Structure:**

```sql
\d table_name               -- Basic structure
\d+ table_name              -- Detailed structure
```

**Column Information:**

```sql
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'students'
ORDER BY ordinal_position;
```

**Table Size:**

```sql
SELECT pg_size_pretty(pg_total_relation_size('table_name'));
```

**List All Relations:**

```sql
\d              -- All relations
\dt             -- Tables only
\dv             -- Views only
\ds             -- Sequences only
\di             -- Indexes only
```

---

### 3.3 UPDATE (ALTER) Table

**Add Column:**

```sql
-- Single column
ALTER TABLE students ADD COLUMN phone VARCHAR(15);

-- With constraints
ALTER TABLE students 
ADD COLUMN address TEXT NOT NULL DEFAULT 'Not provided';

-- Multiple columns
ALTER TABLE students
ADD COLUMN city VARCHAR(50),
ADD COLUMN country VARCHAR(50) DEFAULT 'India';
```

**Drop Column:**

```sql
-- Single column
ALTER TABLE students DROP COLUMN phone;

-- Multiple columns
ALTER TABLE students
DROP COLUMN city,
DROP COLUMN country;

-- Safe drop (no error if not exists)
ALTER TABLE students DROP COLUMN IF EXISTS phone;

-- Drop with dependencies
ALTER TABLE students DROP COLUMN phone CASCADE;
```

**Rename Column:**

```sql
ALTER TABLE students RENAME COLUMN first_name TO fname;
ALTER TABLE students RENAME COLUMN last_name TO lname;
```

**Change Column Data Type:**

```sql
-- Simple change
ALTER TABLE students ALTER COLUMN age TYPE BIGINT;

-- With conversion
ALTER TABLE students 
ALTER COLUMN gpa TYPE VARCHAR(10) USING gpa::VARCHAR;

-- Change VARCHAR length
ALTER TABLE students ALTER COLUMN email TYPE VARCHAR(150);
```

**Modify Column Constraints:**

```sql
-- Set NOT NULL
ALTER TABLE students ALTER COLUMN email SET NOT NULL;

-- Remove NOT NULL
ALTER TABLE students ALTER COLUMN phone DROP NOT NULL;

-- Set DEFAULT
ALTER TABLE students ALTER COLUMN is_active SET DEFAULT TRUE;

-- Remove DEFAULT
ALTER TABLE students ALTER COLUMN enrollment_date DROP DEFAULT;
```

**Add Constraints:**

```sql
-- PRIMARY KEY
ALTER TABLE students ADD PRIMARY KEY (student_id);

-- UNIQUE
ALTER TABLE students ADD CONSTRAINT unique_email UNIQUE (email);

-- CHECK
ALTER TABLE students ADD CONSTRAINT valid_age CHECK (age >= 16);

-- FOREIGN KEY
ALTER TABLE students 
ADD CONSTRAINT fk_dept 
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Multiple column UNIQUE
ALTER TABLE students
ADD CONSTRAINT unique_name_email UNIQUE (first_name, last_name, email);
```

**Drop Constraints:**

```sql
-- Drop by name
ALTER TABLE students DROP CONSTRAINT unique_email;
ALTER TABLE students DROP CONSTRAINT valid_age;
ALTER TABLE students DROP CONSTRAINT students_pkey;
```

**Rename Table:**

```sql
ALTER TABLE students RENAME TO scholars;
```

**Change Table Owner:**

```sql
ALTER TABLE students OWNER TO new_owner;
```

---

### 3.4 DELETE Table

**DROP Table:**

```sql
-- Simple drop
DROP TABLE students;

-- Safe drop
DROP TABLE IF EXISTS students;

-- Multiple tables
DROP TABLE IF EXISTS students, teachers, courses;
```

**DROP with CASCADE:**

```sql
-- Drop with all dependencies
DROP TABLE students CASCADE;

-- Drop only if no dependencies (default)
DROP TABLE students RESTRICT;
```

**TRUNCATE Table:**

```sql
-- Delete all rows, keep structure
TRUNCATE TABLE students;

-- Multiple tables
TRUNCATE TABLE students, teachers, courses;

-- With CASCADE
TRUNCATE TABLE students CASCADE;

-- Reset auto-increment
TRUNCATE TABLE students RESTART IDENTITY;
```

**TRUNCATE vs DELETE:**

```
TRUNCATE:
- Faster (doesn't scan rows)
- Cannot use WHERE clause
- Resets sequences with RESTART IDENTITY
- Less logging overhead
- Cannot be rolled back in some cases

DELETE:
- Slower (scans all rows)
- Can use WHERE clause
- Doesn't reset sequences
- More logging
- Can be rolled back
- Triggers are fired
```

---

##  PSQL META-COMMANDS

### 6.1 Database Commands

|Command|Description|
|---|---|
|`\l`|List all databases|
|`\l+`|Detailed database list with size|
|`\c dbname`|Connect to database|
|`\c dbname user`|Connect as specific user|
|`\conninfo`|Show connection information|

### 6.2 Table Commands

|Command|Description|
|---|---|
|`\dt`|List all tables|
|`\dt+`|List tables with size|
|`\d tablename`|Describe table structure|
|`\d+ tablename`|Detailed table description|
|`\d`|List all relations|

### 6.3 Schema Commands

|Command|Description|
|---|---|
|`\dn`|List schemas|
|`\dv`|List views|
|`\ds`|List sequences|
|`\di`|List indexes|
|`\df`|List functions|
|`\dT`|List data types|

### 6.4 User/Role Commands

|Command|Description|
|---|---|
|`\du`|List roles/users|
|`\du+`|Detailed role information|
|`\du username`|Show specific user|

### 6.5 Permission Commands

|Command|Description|
|---|---|
|`\dp`|List table permissions|
|`\dp tablename`|Show table-specific permissions|
|`\z`|Same as \dp|

### 6.6 Utility Commands

|Command|Description|
|---|---|
|`\?`|Help on meta-commands|
|`\h`|Help on SQL commands|
|`\h CREATE TABLE`|Help on specific SQL command|
|`\q`|Quit psql|
|`\timing`|Toggle query execution timing|
|`\x`|Toggle expanded output|
|`\e`|Open query in editor|
|`\i filename`|Execute SQL from file|
|`\o filename`|Send output to file|
|`\! command`|Execute shell command|
|`\! clear`|Clear screen|
|`\s`|Show command history|
|`\password`|Change user password|

### 6.7 Important Meta-Command Rules

```
1. Meta-commands start with backslash (\)
2. Do NOT end with semicolon (;)
3. Case-insensitive (\dt = \DT)
4. Can use patterns (\dt stud*)
5. Work only in psql (not in SQL queries)
```

---

## PART 7: COMMON PATTERNS & EXAMPLES

### 7.1 Complete Database Setup

```sql
-- Create database owner
CREATE ROLE app_admin WITH LOGIN PASSWORD 'secure_pass' CREATEDB;

-- Create database
CREATE DATABASE app_db OWNER app_admin;

-- Connect to database
\c app_db app_admin

-- Verify
\l app_db
\conninfo
```

### 7.2 Complete Table Setup

```sql
-- Parent table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Child table with foreign key
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary NUMERIC(10,2) CHECK(salary > 0),
    dept_id INTEGER,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);
```

### 7.3 Insert Sample Data

```sql
-- Insert departments
INSERT INTO departments (dept_name) VALUES
('Sales'),
('Engineering'),
('HR');

-- Insert employees
INSERT INTO employees (first_name, last_name, email, salary, dept_id) VALUES
('John', 'Doe', 'john@company.com', 75000, 1),
('Jane', 'Smith', 'jane@company.com', 85000, 2),
('Bob', 'Johnson', 'bob@company.com', 65000, 3);
```

### 7.4 Common SELECT Queries

```sql
-- Select all
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, salary FROM employees;

-- With WHERE clause
SELECT * FROM employees WHERE salary > 70000;

-- With JOIN
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- With aggregation
SELECT dept_id, COUNT(*), AVG(salary)
FROM employees
GROUP BY dept_id;

-- With ORDER BY and LIMIT
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 5;
```

### 7.5 UPDATE Examples

```sql
-- Update single row
UPDATE employees 
SET salary = 80000 
WHERE emp_id = 1;

-- Update multiple columns
UPDATE employees 
SET salary = salary * 1.1, 
    hire_date = CURRENT_DATE
WHERE dept_id = 2;

-- Update with subquery
UPDATE employees 
SET salary = (SELECT AVG(salary) FROM employees)
WHERE dept_id IS NULL;
```

### 7.6 DELETE Examples

```sql
-- Delete specific rows
DELETE FROM employees WHERE emp_id = 1;

-- Delete with condition
DELETE FROM employees WHERE hire_date < '2020-01-01';

-- Delete all (dangerous!)
DELETE FROM employees;
```

### 7.7 ALTER TABLE Chain

```sql
-- Multiple operations
ALTER TABLE employees
    ADD COLUMN phone VARCHAR(15),
    ADD COLUMN address TEXT,
    DROP COLUMN hire_date,
    RENAME COLUMN email TO email_address;
```

---

## PART 8: TROUBLESHOOTING COMMANDS

### 8.1 Check Active Connections

```sql
-- View all connections
SELECT * FROM pg_stat_activity;

-- Connections to specific database
SELECT 
    pid,
    usename,
    application_name,
    client_addr,
    state,
    query
FROM pg_stat_activity
WHERE datname = 'app_db';

-- Count connections per database
SELECT datname, COUNT(*) 
FROM pg_stat_activity 
GROUP BY datname;
```

### 8.2 Terminate Connections

```sql
-- Kill specific connection
SELECT pg_terminate_backend(12345);  -- PID

-- Kill all connections to database
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'app_db' 
AND pid <> pg_backend_pid();
```

### 8.3 Check Database Size

```sql
-- Single database
SELECT pg_size_pretty(pg_database_size('app_db'));

-- All databases with size
SELECT 
    datname,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;
```

### 8.4 Check Table Size

```sql
-- Single table
SELECT pg_size_pretty(pg_total_relation_size('employees'));

-- All tables with size
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### 8.5 Check Locks

```sql
-- View locked tables
SELECT * FROM pg_locks WHERE granted = false;

-- Detailed lock information
SELECT 
    pg_stat_activity.pid,
    pg_stat_activity.usename,
    pg_locks.mode,
    pg_locks.locktype,
    pg_stat_activity.query
FROM pg_stat_activity
JOIN pg_locks ON pg_stat_activity.pid = pg_locks.pid;
```

### 8.6 Check Table Constraints

```sql
-- All constraints on table
SELECT
    conname AS constraint_name,
    contype AS constraint_type,
    pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'employees'::regclass;
```

---

## PART 9: QUICK REFERENCE SUMMARY

### Database CRUD Quick Reference

```sql
-- CREATE
CREATE DATABASE dbname [OWNER user];

-- READ
\l                              -- List databases
SELECT current_database();      -- Current DB

-- UPDATE
ALTER DATABASE old RENAME TO new;
ALTER DATABASE db OWNER TO user;

-- DELETE
DROP DATABASE [IF EXISTS] dbname;

-- SWITCH
\c dbname                       -- Switch database
```

### Table CRUD Quick Reference

```sql
-- CREATE
CREATE TABLE name (col type constraints);
CREATE TABLE new (LIKE old);    -- Copy structure
CREATE TABLE new AS SELECT * FROM old;  -- Copy data

-- READ
\dt                             -- List tables
\d tablename                    -- Describe table

-- UPDATE
ALTER TABLE name ADD COLUMN col type;
ALTER TABLE name DROP COLUMN col;
ALTER TABLE name RENAME COLUMN old TO new;
ALTER TABLE name ALTER COLUMN col TYPE type;

-- DELETE
DROP TABLE [IF EXISTS] name;
TRUNCATE TABLE name;
```

### Constraint Quick Reference

```sql
PRIMARY KEY (col)
FOREIGN KEY (col) REFERENCES table(col)
UNIQUE (col)
NOT NULL
CHECK (condition)
DEFAULT value
```

### Data Types Quick Reference

```sql
-- Numeric
SERIAL, INTEGER, BIGINT, NUMERIC(10,2)

-- Text
CHAR(n), VARCHAR(n), TEXT

-- Date/Time
DATE, TIME, TIMESTAMP, TIMESTAMPTZ

-- Other
BOOLEAN, UUID, JSON, JSONB, ARRAY
```

### psql Commands Quick Reference

```sql
\l              -- List databases
\c db           -- Connect to database
\dt             -- List tables
\d table        -- Describe table
\du             -- List users
\dp             -- List permissions
\q              -- Quit
```

---

## PART 10: IMPORTANT CONCEPTS

### 10.1 Why PostgreSQL Has No USE Command

**MySQL:**

```sql
USE database_name;  -- Switch database
```

**PostgreSQL:**

```sql
\c database_name    -- Switch database
```

**Reason:**

- PostgreSQL uses connection-based database access
- Each connection is bound to one database
- Must reconnect to switch databases
- This provides better isolation and security

### 10.2 Template Databases Explained

**template0:**

- Pristine, read-only template
- Never modified
- Used for creating databases with different encodings
- Backup template if template1 corrupted

**template1:**

- Default template for new databases
- Can be modified (add extensions, default tables)
- All new databases clone template1
- Modifications automatically appear in new databases

**Usage:**

```sql
-- Default (uses template1)
CREATE DATABASE mydb;

-- Explicit template
CREATE DATABASE mydb TEMPLATE template0;
```

### 10.3 SERIAL vs SEQUENCE

**SERIAL is shorthand:**

```sql
-- This:
id SERIAL PRIMARY KEY

-- Is equivalent to:
id INTEGER PRIMARY KEY DEFAULT nextval('tablename_id_seq')
-- Plus automatic sequence creation
```

**Manual sequence:**

```sql
CREATE SEQUENCE my_seq START 1000;
CREATE TABLE t (id INTEGER DEFAULT nextval('my_seq'));
```

### 10.4 CASCADE Behavior

**ON DELETE CASCADE:**

```sql
FOREIGN KEY (dept_id) REFERENCES departments(dept_id) 
ON DELETE CASCADE
```

- When parent row deleted, child rows automatically deleted

**ON DELETE SET NULL:**

```sql
FOREIGN KEY (dept_id) REFERENCES departments(dept_id) 
ON DELETE SET NULL
```

- When parent deleted, foreign key in child set to NULL

**ON DELETE RESTRICT (default):**

```sql
FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
```

- Prevents deletion if child rows exist

### TRUNCATE vs DELETE Performance

**TRUNCATE:**

- Removes all rows without scanning
- Faster for large tables
- Cannot use WHERE clause
- Resets sequences with RESTART IDENTITY
- Less transaction log overhead

**DELETE:**

- Scans and removes rows one by one
- Slower for large tables
- Can use WHERE clause
- Keeps sequence values
- More transaction log overhead
- Triggers are fired

**When to use:**

```sql
-- Delete all rows quickly
TRUNCATE TABLE large_table;

-- Delete specific rows
DELETE FROM table WHERE condition;

-- Delete all and reset auto-increment
TRUNCATE TABLE table RESTART IDENTITY;
```

---

## BEST PRACTICES

### 11.1 Naming Conventions

**Tables:**

```sql
-- Use lowercase with underscores
CREATE TABLE user_profiles;
CREATE TABLE product_categories;

-- Not: UserProfiles, productCategories
```

**Columns:**

```sql
-- Descriptive names
first_name, last_name, email_address

-- Not: fn, ln, email
```

**Constraints:**

```sql
-- Prefix with type
pk_users_id          -- Primary key
fk_orders_user_id    -- Foreign key
uk_users_email       -- Unique
chk_users_age        -- Check
```

### 11.2 Data Type Selection

**Use appropriate types:**

```sql
-- Good
age SMALLINT                    -- Age won't exceed 32767
price NUMERIC(10,2)             -- Exact decimal for money
is_active BOOLEAN               -- Clear true/false

-- Avoid
age VARCHAR(10)                 -- Wrong type for numbers
price REAL                      -- Imprecise for money
is_active CHAR(1)               -- Use BOOLEAN instead
```

### 11.3 Always Use Constraints

```sql
-- Good table design
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER CHECK(age >= 18),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Poor design (no constraints)
CREATE TABLE users (
    id INTEGER,
    email TEXT,
    age INTEGER,
    created_at TEXT
);
```

### 11.4 Use IF EXISTS

```sql
-- Safe operations
DROP DATABASE IF EXISTS old_db;
DROP TABLE IF EXISTS temp_table;
ALTER TABLE users DROP COLUMN IF EXISTS old_column;

-- Prevents errors if object doesn't exist
```

### 11.5 Always Backup Before DROP

```bash
# Backup before dropping
pg_dump -U user -d database > backup.sql

# Then drop
DROP DATABASE database;

# Restore if needed
psql -U user -d database < backup.sql
```
