---
title:
  "{ Title }":
tags:
  - database
  - Sql
created:
  "{ date }":
updated:
  "{ date }":
---

## . PostgreSQL Data Types

### Overview of Data Types

```
PostgreSQL Data Types
    │
    ├── Numeric Types
    │   ├── Integer (smallint, integer, bigint)
    │   ├── Decimal (numeric, decimal)
    │   ├── Floating-Point (real, double precision)
    │   └── Serial (smallserial, serial, bigserial)
    │
    ├── Character Types
    │   ├── CHAR(n) - Fixed length
    │   ├── VARCHAR(n) - Variable length
    │   └── TEXT - Unlimited length
    │
    ├── Date/Time Types
    │   ├── DATE
    │   ├── TIME
    │   ├── TIMESTAMP
    │   ├── TIMESTAMPTZ (with timezone)
    │   └── INTERVAL
    │
    ├── Boolean Type
    │   └── BOOLEAN (TRUE/FALSE/NULL)
    │
    ├── Binary Types
    │   └── BYTEA
    │
    ├── JSON Types
    │   ├── JSON
    │   └── JSONB (Binary JSON)
    │
    ├── Array Types
    │   └── Any type followed by []
    │
    └── UUID Type
        └── UUID
```

---

### Numeric Data Types

#### Integer Types

| Type              | Storage | Range                                                   | Use Case              |
| ----------------- | ------- | ------------------------------------------------------- | --------------------- |
| **SMALLINT**      | 2 bytes | -32,768 to 32,767                                       | Small numbers, flags  |
| **INTEGER (INT)** | 4 bytes | -2,147,483,648 to 2,147,483,647                         | General integers, IDs |
| **BIGINT**        | 8 bytes | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 | Large numbers         |

**Examples:**

```sql
CREATE TABLE products (
    product_id INTEGER,
    stock_count SMALLINT,
    views_count BIGINT
);
```

---

#### Serial Types (Auto-Increment)

| Type            | Storage | Range                          | Equivalent to       |
| --------------- | ------- | ------------------------------ | ------------------- |
| **SMALLSERIAL** | 2 bytes | 1 to 32,767                    | SMALLINT + SEQUENCE |
| **SERIAL**      | 4 bytes | 1 to 2,147,483,647             | INTEGER + SEQUENCE  |
| **BIGSERIAL**   | 8 bytes | 1 to 9,223,372,036,854,775,807 | BIGINT + SEQUENCE   |

**Example:**

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,        -- Auto-incrementing ID
    username VARCHAR(50)
);

-- Internally creates:
-- 1. Sequence: users_id_seq
-- 2. Column with DEFAULT nextval('users_id_seq')
```

**How SERIAL works:**

```
INSERT INTO users (username) VALUES ('John');
-- id automatically becomes 1

INSERT INTO users (username) VALUES ('Jane');
-- id automatically becomes 2
```

---

#### Decimal Types

| Type              | Description     | Precision    | Use Case               |
| ----------------- | --------------- | ------------ | ---------------------- |
| **NUMERIC(p, s)** | Exact numeric   | User-defined | Financial calculations |
| **DECIMAL(p, s)** | Same as NUMERIC | User-defined | Same as NUMERIC        |

**Parameters:**

- `p` = Precision (total number of digits)
- `s` = Scale (digits after decimal point)

**Examples:**

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    price NUMERIC(10, 2),     -- Max: 99999999.99
    tax_rate NUMERIC(5, 4),   -- Max: 9.9999
    discount DECIMAL(5, 2)    -- Max: 999.99
);

INSERT INTO products (price, tax_rate, discount) 
VALUES (1299.99, 0.1850, 10.50);
```

---

#### Floating-Point Types

| Type                 | Storage | Precision         | Use Case                    |
| -------------------- | ------- | ----------------- | --------------------------- |
| **REAL**             | 4 bytes | 6 decimal digits  | Scientific calculations     |
| **DOUBLE PRECISION** | 8 bytes | 15 decimal digits | High-precision calculations |

**⚠️ Warning:** Floating-point types are approximate. Use NUMERIC for exact values.

**Example:**

```sql
CREATE TABLE measurements (
    id SERIAL PRIMARY KEY,
    temperature REAL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);
```

---

### Character/String Types

| Type           | Description      | Max Length   | Storage                      |
| -------------- | ---------------- | ------------ | ---------------------------- |
| **CHAR(n)**    | Fixed-length     | n characters | n bytes (padded with spaces) |
| **VARCHAR(n)** | Variable-length  | n characters | Actual length + 1 byte       |
| **TEXT**       | Unlimited length | Unlimited    | Actual length + 1-4 bytes    |

**Examples:**

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    country_code CHAR(2),        -- Always 2 chars: 'US', 'IN'
    username VARCHAR(50),         -- Up to 50 chars
    bio TEXT,                     -- Unlimited length
    status CHAR(1)                -- Single char: 'A', 'I'
);

INSERT INTO users (country_code, username, bio, status) 
VALUES ('IN', 'john_doe', 'Software developer from India', 'A');
```

**CHAR vs VARCHAR:**

```sql
-- CHAR pads with spaces
INSERT INTO test (fixed) VALUES ('Hi');
-- Stored as: 'Hi        ' (padded to 10 chars)

-- VARCHAR stores actual length
INSERT INTO test (variable) VALUES ('Hi');
-- Stored as: 'Hi' (only 2 chars)
```

**When to use:**

- **CHAR(n)**: Fixed-length data (country codes, status flags)
- **VARCHAR(n)**: Variable-length with limit (usernames, emails)
- **TEXT**: Long text without specific limit (descriptions, comments)

---

### Date and Time Types

| Type            | Description             | Format                 | Storage  | Range                         |
| --------------- | ----------------------- | ---------------------- | -------- | ----------------------------- |
| **DATE**        | Date only               | YYYY-MM-DD             | 4 bytes  | 4713 BC to 5874897 AD         |
| **TIME**        | Time only               | HH:MI:SS               | 8 bytes  | 00:00:00 to 24:00:00          |
| **TIMESTAMP**   | Date + Time             | YYYY-MM-DD HH:MI:SS    | 8 bytes  | 4713 BC to 294276 AD          |
| **TIMESTAMPTZ** | Timestamp with timezone | YYYY-MM-DD HH:MI:SS+TZ | 8 bytes  | Same as TIMESTAMP             |
| **INTERVAL**    | Time interval           | Various formats        | 16 bytes | -178000000 to 178000000 years |

**Examples:**

```sql
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_date DATE,
    event_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    duration INTERVAL
);

-- Insert examples
INSERT INTO events (event_date, event_time, duration) 
VALUES (
    '2024-12-25',                    -- DATE
    '14:30:00',                      -- TIME
    INTERVAL '2 hours 30 minutes'    -- INTERVAL
);

-- Current date and time
INSERT INTO events (event_date, event_time) 
VALUES (CURRENT_DATE, CURRENT_TIME);
```

**Common Date/Time Functions:**

```sql
-- Current date
SELECT CURRENT_DATE;              -- 2024-12-25

-- Current time
SELECT CURRENT_TIME;              -- 14:30:45.123456+05:30

-- Current timestamp
SELECT CURRENT_TIMESTAMP;         -- 2024-12-25 14:30:45.123456+05:30
SELECT NOW();                     -- Same as CURRENT_TIMESTAMP

-- Extract parts
SELECT EXTRACT(YEAR FROM CURRENT_DATE);    -- 2024
SELECT EXTRACT(MONTH FROM CURRENT_DATE);   -- 12
SELECT EXTRACT(DAY FROM CURRENT_DATE);     -- 25

-- Date arithmetic
SELECT CURRENT_DATE + INTERVAL '7 days';    -- Add 7 days
SELECT CURRENT_DATE - INTERVAL '1 month';   -- Subtract 1 month
```

---

### Boolean Type

|Type|Values|Storage|Use Case|
|---|---|---|---|
|**BOOLEAN**|TRUE, FALSE, NULL|1 byte|Yes/No flags|

**Accepted Input Values:**

|For TRUE|For FALSE|
|---|---|
|TRUE, 't', 'true', 'y', 'yes', 'on', '1'|FALSE, 'f', 'false', 'n', 'no', 'off', '0'|

**Examples:**

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    is_admin BOOLEAN DEFAULT FALSE,
    email_verified BOOLEAN
);

-- Insert examples
INSERT INTO users (username, is_active, is_admin) 
VALUES ('john', TRUE, FALSE);

INSERT INTO users (username, is_active, is_admin) 
VALUES ('admin', 't', 'yes');

-- Query
SELECT * FROM users WHERE is_active = TRUE;
SELECT * FROM users WHERE is_admin;  -- Same as is_admin = TRUE
```

---

### Binary Data Type

|Type|Description|Storage|Use Case|
|---|---|---|---|
|**BYTEA**|Binary data|1 or 4 bytes + actual data|Images, files, encrypted data|

**Example:**

```sql
CREATE TABLE files (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255),
    file_data BYTEA,
    uploaded_at TIMESTAMP DEFAULT NOW()
);
```

---

### JSON Types

|Type|Description|Storage|Indexing|
|---|---|---|---|
|**JSON**|Text-based JSON|Exact copy of input|Not indexed|
|**JSONB**|Binary JSON|Decomposed binary|Can be indexed|

**Recommendation:** Use **JSONB** (faster, indexable, slightly more storage)

**Examples:**

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    attributes JSONB
);

-- Insert JSON data
INSERT INTO products (name, attributes) VALUES (
    'Laptop',
    '{"brand": "Dell", "ram": "16GB", "storage": "512GB SSD"}'
);

-- Query JSON data
SELECT * FROM products 
WHERE attributes->>'brand' = 'Dell';

-- Extract JSON field
SELECT name, attributes->>'ram' AS ram 
FROM products;
```

---

### Array Types

**Any PostgreSQL data type can be an array.**

**Syntax:** `data_type[]`

**Examples:**

```sql
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    phone_numbers TEXT[],           -- Array of text
    grades INTEGER[],                -- Array of integers
    hobbies VARCHAR(50)[]           -- Array of varchar
);

-- Insert array data
INSERT INTO students (name, phone_numbers, grades, hobbies) 
VALUES (
    'John Doe',
    ARRAY['9876543210', '8765432109'],
    ARRAY[85, 90, 88, 92],
    ARRAY['reading', 'coding', 'gaming']
);

-- Alternative syntax
INSERT INTO students (name, phone_numbers) 
VALUES ('Jane', '{"1234567890", "0987654321"}');

-- Query array
SELECT * FROM students WHERE 'coding' = ANY(hobbies);

-- Array functions
SELECT name, array_length(grades, 1) AS num_grades 
FROM students;
```

---

### UUID Type

|Type|Description|Format|Storage|
|---|---|---|---|
|**UUID**|Universally Unique Identifier|8-4-4-4-12 hex digits|16 bytes|

**Example:** `550e8400-e29b-41d4-a716-446655440000`

**Enable UUID extension:**

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

**Usage:**

```sql
CREATE TABLE sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Insert with auto-generated UUID
INSERT INTO sessions (user_id) VALUES (123);

-- Insert with specific UUID
INSERT INTO sessions (session_id, user_id) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 456);
```

---

### Data Type Selection Guide

|Use Case|Recommended Type|Example|
|---|---|---|
|**Primary Key (auto-increment)**|SERIAL|`id SERIAL PRIMARY KEY`|
|**Age, quantity**|INTEGER or SMALLINT|`age INTEGER`|
|**Price, money**|NUMERIC(10,2)|`price NUMERIC(10,2)`|
|**Username, short text**|VARCHAR(n)|`username VARCHAR(50)`|
|**Description, long text**|TEXT|`description TEXT`|
|**Email**|VARCHAR(255)|`email VARCHAR(255)`|
|**Date of birth**|DATE|`dob DATE`|
|**Created timestamp**|TIMESTAMP|`created_at TIMESTAMP`|
|**Active status**|BOOLEAN|`is_active BOOLEAN`|
|**Country code**|CHAR(2)|`country CHAR(2)`|
|**JSON data**|JSONB|`metadata JSONB`|
|**Phone numbers**|TEXT[]|`phones TEXT[]`|
|**Session ID**|UUID|`session_id UUID`|

---

## PART 12: CONSTRAINTS IN POSTGRESQL

---

## 24. Constraints Overview

### What are Constraints?

**Definition:** Constraints are rules applied to table columns to enforce data integrity and validity.

**Purpose:**

1. Ensure data accuracy
2. Prevent invalid data entry
3. Maintain referential integrity
4. Enforce business rules

---

### Types of Constraints

```
Constraints
    │
    ├── NOT NULL
    ├── UNIQUE
    ├── PRIMARY KEY
    ├── FOREIGN KEY
    ├── CHECK
    └── DEFAULT
```

---

### 1. NOT NULL Constraint

**Purpose:** Ensures column cannot contain NULL values.

**Syntax:**

```sql
column_name data_type NOT NULL
```

**Example:**

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,        -- Cannot be NULL
    email VARCHAR(100) NOT NULL,       -- Cannot be NULL
    phone VARCHAR(15)                  -- Can be NULL
);

-- Valid
INSERT INTO employees (name, email) 
VALUES ('John Doe', 'john@example.com');

-- Invalid - will fail
INSERT INTO employees (email) 
VALUES ('john@example.com');
-- ERROR: null value in column "name" violates not-null constraint
```

**Adding NOT NULL to existing column:**

```sql
ALTER TABLE employees 
ALTER COLUMN phone SET NOT NULL;
```

**Removing NOT NULL:**

```sql
ALTER TABLE employees 
ALTER COLUMN phone DROP NOT NULL;
```

---

### 2. UNIQUE Constraint

**Purpose:** Ensures all values in column are unique (no duplicates).

**Characteristics:**

- Allows multiple NULL values (NULL ≠ NULL)
- Can be applied to single or multiple columns

**Syntax:**

```sql
-- Single column
column_name data_type UNIQUE

-- Multiple columns (composite unique)
UNIQUE(column1, column2)
```

**Examples:**

**Single Column Unique:**

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,        -- No duplicate usernames
    email VARCHAR(100) UNIQUE           -- No duplicate emails
);

-- Valid
INSERT INTO users (username, email) 
VALUES ('john', 'john@example.com');

-- Invalid - duplicate username
INSERT INTO users (username, email) 
VALUES ('john', 'john2@example.com');
-- ERROR: duplicate key value violates unique constraint
```

**Composite Unique (Multiple Columns):**

```sql
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    semester VARCHAR(10),
    UNIQUE(student_id, course_id, semester)  -- Combination must be unique
);

-- Valid
INSERT INTO enrollments (student_id, course_id, semester) 
VALUES (1, 101, 'Fall2024');

-- Valid (different semester)
INSERT INTO enrollments (student_id, course_id, semester) 
VALUES (1, 101, 'Spring2025');

-- Invalid (duplicate combination)
INSERT INTO enrollments (student_id, course_id, semester) 
VALUES (1, 101, 'Fall2024');
-- ERROR: duplicate key value violates unique constraint
```

**Adding UNIQUE to existing column:**

```sql
ALTER TABLE users 
ADD CONSTRAINT unique_email UNIQUE(email);
```

**Removing UNIQUE constraint:**

```sql
ALTER TABLE users 
DROP CONSTRAINT unique_email;
```

---

### 3. PRIMARY KEY Constraint

**Purpose:** Uniquely identifies each row in a table.

**Characteristics:**

- Combines NOT NULL + UNIQUE
- Only ONE primary key per table
- Can be single column or composite
- Automatically creates index

**Syntax:**

```sql
-- Method 1: Inline
column_name data_type PRIMARY KEY

-- Method 2: Table-level
PRIMARY KEY(column_name)

-- Method 3: Composite
PRIMARY KEY(column1, column2)
```

**Examples:**

**Single Column Primary Key:**

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,     -- Auto-increment primary key
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Alternative syntax
CREATE TABLE students (
    student_id SERIAL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    PRIMARY KEY(student_id)
);
```

**Composite Primary Key:**

```sql
CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    price NUMERIC(10,2),
    PRIMARY KEY(order_id, product_id)   -- Both columns together form PK
);
```

**Adding PRIMARY KEY to existing table:**

```sql
ALTER TABLE students 
ADD PRIMARY KEY(student_id);
```

**Removing PRIMARY KEY:**

```sql
ALTER TABLE students 
DROP CONSTRAINT students_pkey;
```

---

### 4. FOREIGN KEY Constraint

**Purpose:** Establishes link between two tables, maintains referential integrity.

**Characteristics:**

- References PRIMARY KEY of another table
- Prevents orphaned records
- Can be NULL (if allowed)
- Enforces parent-child relationship

**Syntax:**

```sql
FOREIGN KEY(column_name) 
REFERENCES parent_table(parent_column)
```

**Complete Syntax with Actions:**

```sql
FOREIGN KEY(column_name) 
REFERENCES parent_table(parent_column)
    ON DELETE action
    ON UPDATE action
```

**Referential Actions:**

- `CASCADE`: Delete/update child rows automatically
- `SET NULL`: Set child FK to NULL
- `SET DEFAULT`: Set child FK to default value
- `RESTRICT`: Prevent delete/update (default)
- `NO ACTION`: Same as RESTRICT

---

**Examples:**

**Basic Foreign Key:**

```sql
-- Parent table
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- Child table
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

-- Insert department first
INSERT INTO departments (dept_name) VALUES ('IT');

-- Insert employee (valid)
INSERT INTO employees (name, dept_id) VALUES ('John', 1);

-- Insert employee with invalid dept_id (fails)
INSERT INTO employees (name, dept_id) VALUES ('Jane', 999);
-- ERROR: insert or update on table "employees" violates foreign key constraint
```

**Foreign Key with CASCADE:**

```sql
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
        ON DELETE CASCADE            -- Delete employees if department deleted
        ON UPDATE CASCADE            -- Update emp_id if dept_id changes
);

-- Delete department
DELETE FROM departments WHERE dept_id = 1;
-- All employees with dept_id = 1 are also deleted
```

**Foreign Key with SET NULL:**

```sql
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
        ON DELETE SET NULL           -- Set dept_id to NULL if department deleted
);

-- Delete department
DELETE FROM departments WHERE dept_id = 1;
-- Employees with dept_id = 1 now have dept_id = NULL
```

**Multiple Foreign Keys:**

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    order_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);
```

**Adding Foreign Key to existing table:**

```sql
ALTER TABLE employees 
ADD CONSTRAINT fk_emp_dept 
FOREIGN KEY(dept_id) REFERENCES departments(dept_id);
```

**Removing Foreign Key:**

```sql
ALTER TABLE employees 
DROP CONSTRAINT fk_emp_dept;
```

---

### 5. CHECK Constraint

**Purpose:** Ensures column values satisfy a specific condition.

**Syntax:**

```sql
column_name data_type CHECK(condition)

-- Or table-level
CHECK(condition)
```

**Examples:**

**Simple CHECK:**

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) CHECK(price > 0),           -- Price must be positive
    stock INTEGER CHECK(stock >= 0),                 -- Stock cannot be negative
    discount INTEGER CHECK(discount BETWEEN 0 AND 100)  -- Discount 0-100%
);

-- Valid
INSERT INTO products (name, price, stock, discount) 
VALUES ('Laptop', 1299.99, 50, 10);

-- Invalid - negative price
INSERT INTO products (name, price, stock) 
VALUES ('Mouse', -10.00, 100);
-- ERROR: new row violates check constraint "products_price_check"

-- Invalid - discount > 100
INSERT INTO products (name, price, stock, discount) 
VALUES ('Keyboard', 49.99, 20, 150);
-- ERROR: new row violates check constraint
```

**CHECK with Multiple Conditions:**

```sql
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INTEGER CHECK(age >= 18 AND age <= 65),     -- Age 18-65
    salary NUMERIC(10,2) CHECK(salary > 0),
    gender CHAR(1) CHECK(gender IN ('M', 'F', 'O'))  -- M, F, or O only
);
```

**Table-level CHECK:**

```sql
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    check_in DATE,
    check_out DATE,
    CHECK(check_out > check_in)     -- Check-out must be after check-in
);
```

**Named CHECK constraint:**

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    price NUMERIC(10,2),
    CONSTRAINT positive_price CHECK(price > 0)
);
```

**Adding CHECK to existing table:**

```sql
ALTER TABLE products 
ADD CONSTRAINT check_price_positive CHECK(price > 0);
```

**Removing CHECK constraint:**

```sql
ALTER TABLE products 
DROP CONSTRAINT check_price_positive;
```

---

### 6. DEFAULT Constraint

**Purpose:** Provides default value for column when no value is specified.

**Syntax:**

```sql
column_name data_type DEFAULT default_value
```

**Examples:**

**Simple DEFAULT:**

```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',           -- Default status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Default current time
    country CHAR(2) DEFAULT 'US',
    is_verified BOOLEAN DEFAULT FALSE
);

-- Insert without specifying defaults
INSERT INTO users (username) 
VALUES ('john_doe');

-- Result: status='active', created_at=(current timestamp), 
--         country='US', is_verified=FALSE
```

**DEFAULT with Functions:**

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) DEFAULT 'ORD-' || nextval('order_seq'),
    order_date DATE DEFAULT CURRENT_DATE,
    order_time TIME DEFAULT CURRENT_TIME,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

**Overriding DEFAULT:**

```sql
-- Use default
INSERT INTO users (username) VALUES ('jane');

-- Override default
INSERT INTO users (username, status) VALUES ('bob', 'inactive');
```

**Adding DEFAULT to existing column:**

```sql
ALTER TABLE users 
ALTER COLUMN country SET DEFAULT 'IN';
```

**Removing DEFAULT:**

```sql
ALTER TABLE users 
ALTER COLUMN country DROP DEFAULT;
```

---

### Complete Constraint Example

```sql
CREATE TABLE employees (
    -- PRIMARY KEY with SERIAL (auto-increment)
    emp_id SERIAL PRIMARY KEY,
    
    -- NOT NULL constraints
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    
    -- UNIQUE constraint
    email VARCHAR(100) UNIQUE NOT NULL,
    
    -- CHECK constraints
    age INTEGER CHECK(age >= 18 AND age <= 65),
    salary NUMERIC(10,2) CHECK(salary > 0),
    gender CHAR(1) CHECK(gender IN ('M', 'F', 'O')),
    
    -- DEFAULT constraints
    hire_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'active',
    is_manager BOOLEAN DEFAULT FALSE,
    
    -- FOREIGN KEY constraint
    dept_id INTEGER,
    CONSTRAINT fk_department 
        FOREIGN KEY(dept_id) 
        REFERENCES departments(dept_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    -- Table-level CHECK
    CONSTRAINT valid_salary_range 
        CHECK(salary BETWEEN 30000 AND 500000)
);
```

---
