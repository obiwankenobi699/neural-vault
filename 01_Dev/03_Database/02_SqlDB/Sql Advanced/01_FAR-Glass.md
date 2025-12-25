---
title:
  "{ Title }":
tags:
  - database
  - Sql
created: 2025-12-25
updated:
  "{ date }":
---

## 1. What is FAR-GLASS?

### Definition

**FAR-GLASS** is a mental model that explains **how SELECT queries work** in a logical, structured way.

### Purpose

- **CRUD** tells you **WHAT** you do (Create, Read, Update, Delete)
- **FAR-GLASS** tells you **HOW** SELECT works (the Read operation)

### The Acronym

```
F A R G L A S S
│ │ │ │ │ │ │ │
│ │ │ │ │ │ │ └─ Search (Pattern matching)
│ │ │ │ │ │ └─── Slice (Pagination)
│ │ │ │ │ └───── Arrange (Sorting)
│ │ │ │ └─────── Logical (Conditions)
│ │ │ └───────── Group (Aggregation)
│ │ └─────────── Relate (Joins)
│ └───────────── Aggregate (Metrics)
└─────────────── Filter (Row selection)
```

---

## 2. FAR-GLASS Breakdown with SQL Mapping

### Complete Mapping Table

|Letter|Component|Purpose|SQL Clauses/Keywords|Example|
|---|---|---|---|---|
|**F**|**Filter**|Row-level filtering|`WHERE`|`WHERE age >= 18`|
|**A**|**Aggregate**|Compute metrics|`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`|`COUNT(*) AS total`|
|**R**|**Relate**|Combine tables|`JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`|`JOIN orders ON ...`|
|**G**|**Group**|Group rows for aggregation|`GROUP BY`|`GROUP BY department`|
|**L**|**Logical**|Combine conditions|`AND`, `OR`, `NOT`, `IN`, `BETWEEN`, `EXISTS`|`WHERE status = 'active' AND age > 18`|
|**A**|**Arrange**|Sort results|`ORDER BY`|`ORDER BY salary DESC`|
|**S**|**Slice**|Pagination/limit results|`LIMIT`, `OFFSET`|`LIMIT 10 OFFSET 20`|
|**S**|**Search**|Pattern/text matching|`LIKE`, `ILIKE`, `~` (regex)|`WHERE name LIKE 'J%'`|

---

## 3. Detailed Explanation of Each Component

### F - Filter (WHERE Clause)

**Purpose**: Select specific rows based on conditions.

**When to Use**: When you need to filter data **before** aggregation.

**Syntax**:

```sql
WHERE condition
```

**Examples**:

**Basic Filtering**:

```sql
-- Single condition
SELECT * FROM users 
WHERE status = 'active';

-- Multiple conditions
SELECT * FROM users 
WHERE status = 'active' AND age >= 18;

-- Numeric comparison
SELECT * FROM orders 
WHERE total_amount > 1000;

-- Date filtering
SELECT * FROM logs 
WHERE created_at > '2025-01-01';
```

**Common Operators**:

|Operator|Meaning|Example|
|---|---|---|
|`=`|Equal|`status = 'active'`|
|`<>`, `!=`|Not equal|`status <> 'deleted'`|
|`>`, `<`|Greater/Less than|`age > 18`|
|`>=`, `<=`|Greater/Less or equal|`salary >= 50000`|
|`BETWEEN`|Range|`age BETWEEN 18 AND 65`|
|`IN`|List membership|`status IN ('active', 'pending')`|
|`IS NULL`|Null check|`phone IS NULL`|
|`IS NOT NULL`|Not null|`email IS NOT NULL`|

**Key Point**: WHERE filters **individual rows** before grouping.

---

### A - Aggregate (Aggregate Functions)

**Purpose**: Compute summary metrics from multiple rows.

**Common Functions**:

|Function|Purpose|Example|
|---|---|---|
|`COUNT(*)`|Count all rows|`COUNT(*) AS total_users`|
|`COUNT(column)`|Count non-NULL values|`COUNT(email) AS users_with_email`|
|`SUM(column)`|Sum of values|`SUM(amount) AS total_sales`|
|`AVG(column)`|Average value|`AVG(age) AS average_age`|
|`MIN(column)`|Minimum value|`MIN(price) AS cheapest`|
|`MAX(column)`|Maximum value|`MAX(salary) AS highest_salary`|

**Examples**:

```sql
-- Count total users
SELECT COUNT(*) AS total_users
FROM users;

-- Total sales amount
SELECT SUM(amount) AS total_sales
FROM orders;

-- Average age of users
SELECT AVG(age) AS avg_age
FROM users
WHERE status = 'active';

-- Min and Max in one query
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price
FROM products;
```

**With GROUP BY**:

```sql
-- Total sales per customer
SELECT 
    customer_id,
    COUNT(*) AS order_count,
    SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id;
```

---

### R - Relate (JOIN Clause)

**Purpose**: Combine data from multiple tables.

**Types of Joins**:

```
┌─────────────────────────────────────────────────────────┐
│                    JOIN TYPES                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  INNER JOIN       LEFT JOIN        RIGHT JOIN          │
│  ┌───┐ ┌───┐     ┌───┐ ┌───┐     ┌───┐ ┌───┐         │
│  │ A │ │ B │     │ A │ │ B │     │ A │ │ B │         │
│  └─┬─┘ └─┬─┘     └─┬─┘ └─┬─┘     └─┬─┘ └─┬─┘         │
│    │  ╱  │         │ ═══╪═         ═╪═══ │           │
│    │╱    │         │    │             │   │           │
│  ┌─▼─────▼─┐     ┌─▼────▼─┐       ┌─▼───▼─┐          │
│  │ A ∩ B  │     │ A + AB │       │AB + B │          │
│  └─────────┘     └────────┘       └───────┘          │
│   Only         All from A +      All from B +        │
│   matching     matching B        matching A         │
│                                                       │
│  FULL OUTER JOIN          CROSS JOIN                │
│  ┌───┐ ┌───┐             ┌───┐ ┌───┐               │
│  │ A │ │ B │             │ A │ │ B │               │
│  └─┬─┘ └─┬─┘             └─┬─┘ └─┬─┘               │
│    │═════│                 │ × × │                 │
│  ┌─▼─────▼─┐             ┌─▼─────▼─┐               │
│  │A + AB +B│             │ A × B  │               │
│  └─────────┘             └─────────┘               │
│   All rows               Cartesian                │
│   from both              product                  │
└─────────────────────────────────────────────────────────┘
```

**Syntax & Examples**:

**INNER JOIN** (only matching rows):

```sql
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id;

-- Can omit INNER keyword
SELECT u.name, o.total
FROM users u
JOIN orders o ON u.user_id = o.user_id;
```

**LEFT JOIN** (all from left table + matches):

```sql
-- All users, even without orders
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

-- Find users WITHOUT orders
SELECT u.name
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;
```

**RIGHT JOIN** (all from right table + matches):

```sql
-- All orders, even without user info
SELECT u.name, o.total
FROM users u
RIGHT JOIN orders o ON u.user_id = o.user_id;
```

**FULL OUTER JOIN** (all rows from both):

```sql
-- All users and all orders
SELECT u.name, o.total
FROM users u
FULL OUTER JOIN orders o ON u.user_id = o.user_id;
```

**Multiple Joins**:

```sql
SELECT 
    u.name,
    o.order_id,
    p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
```

---

### G - Group (GROUP BY Clause)

**Purpose**: Group rows with same values for aggregation.

**Syntax**:

```sql
GROUP BY column1, column2, ...
```

**Rule**: If you use aggregate functions, all non-aggregated columns in SELECT must be in GROUP BY.

**Examples**:

**Single Column Grouping**:

```sql
-- Count users per status
SELECT status, COUNT(*) AS count
FROM users
GROUP BY status;

-- Total sales per customer
SELECT 
    customer_id,
    SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id;
```

**Multiple Column Grouping**:

```sql
-- Count users per status and country
SELECT 
    status,
    country,
    COUNT(*) AS count
FROM users
GROUP BY status, country;

-- Daily sales per product
SELECT 
    DATE(order_date) AS date,
    product_id,
    SUM(quantity) AS total_sold
FROM sales
GROUP BY DATE(order_date), product_id;
```

**Common Mistake**:

```sql
-- WRONG: name is not in GROUP BY
SELECT name, COUNT(*) 
FROM users 
GROUP BY status;  -- ERROR!

-- CORRECT: Include all non-aggregated columns
SELECT name, status, COUNT(*) 
FROM users 
GROUP BY name, status;
```

---

### L - Logical (Logical Operators)

**Purpose**: Combine multiple conditions.

**Operators**:

|Operator|Purpose|Example|
|---|---|---|
|`AND`|Both conditions must be true|`age >= 18 AND status = 'active'`|
|`OR`|At least one condition true|`status = 'active' OR status = 'pending'`|
|`NOT`|Negate condition|`NOT status = 'deleted'`|
|`IN`|Value in list|`status IN ('active', 'pending')`|
|`NOT IN`|Value not in list|`status NOT IN ('deleted', 'banned')`|
|`BETWEEN`|Value in range|`age BETWEEN 18 AND 65`|
|`EXISTS`|Subquery returns rows|`EXISTS (SELECT 1 FROM orders...)`|
|`ANY`|Compare to any subquery value|`price > ANY (SELECT...)`|
|`ALL`|Compare to all subquery values|`price > ALL (SELECT...)`|

**Examples**:

**AND - Both conditions must be true**:

```sql
SELECT * FROM users
WHERE status = 'active' 
  AND age >= 18
  AND country = 'USA';
```

**OR - At least one condition true**:

```sql
SELECT * FROM logs
WHERE level = 'ERROR' 
   OR level = 'CRITICAL';

-- Better: Use IN
SELECT * FROM logs
WHERE level IN ('ERROR', 'CRITICAL');
```

**NOT - Negation**:

```sql
SELECT * FROM users
WHERE NOT status = 'deleted';

-- Same as:
SELECT * FROM users
WHERE status <> 'deleted';
```

**IN - List membership**:

```sql
SELECT * FROM orders
WHERE status IN ('pending', 'processing', 'shipped');

-- Equivalent to:
SELECT * FROM orders
WHERE status = 'pending' 
   OR status = 'processing' 
   OR status = 'shipped';
```

**BETWEEN - Range**:

```sql
SELECT * FROM products
WHERE price BETWEEN 10.00 AND 100.00;

-- Equivalent to:
SELECT * FROM products
WHERE price >= 10.00 AND price <= 100.00;
```

**EXISTS - Subquery check**:

```sql
-- Find users who have placed orders
SELECT u.name
FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.user_id = u.user_id
);
```

**Combining with Parentheses**:

```sql
-- Complex condition
SELECT * FROM users
WHERE (status = 'active' OR status = 'pending')
  AND (age >= 18 OR country = 'USA')
  AND email IS NOT NULL;
```

---

### A - Arrange (ORDER BY Clause)

**Purpose**: Sort query results.

**Syntax**:

```sql
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...
```

**Options**:

- `ASC`: Ascending (default)
- `DESC`: Descending

**Examples**:

**Single Column**:

```sql
-- Ascending (default)
SELECT name, age FROM users
ORDER BY age;

-- Descending
SELECT name, salary FROM employees
ORDER BY salary DESC;
```

**Multiple Columns**:

```sql
-- Sort by department, then by salary
SELECT name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;
```

**By Alias**:

```sql
SELECT 
    name,
    salary * 12 AS annual_salary
FROM employees
ORDER BY annual_salary DESC;
```

**By Expression**:

```sql
-- Order by full name
SELECT first_name, last_name
FROM users
ORDER BY first_name || ' ' || last_name;

-- Order by calculated value
SELECT product_name, price, quantity
FROM products
ORDER BY price * quantity DESC;
```

**NULL Handling**:

```sql
-- NULLs last (PostgreSQL)
SELECT name, phone
FROM users
ORDER BY phone NULLS LAST;

-- NULLs first
SELECT name, phone
FROM users
ORDER BY phone NULLS FIRST;
```

**With LIMIT (Top N)**:

```sql
-- Top 10 highest salaries
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- Bottom 5 prices
SELECT product_name, price
FROM products
ORDER BY price ASC
LIMIT 5;
```

---

### S - Slice (LIMIT & OFFSET)

**Purpose**: Pagination and result limiting.

**Syntax**:

```sql
LIMIT n OFFSET m
```

**Explanation**:

- `LIMIT n`: Return maximum n rows
- `OFFSET m`: Skip first m rows

**Examples**:

**Basic LIMIT**:

```sql
-- Get first 10 results
SELECT * FROM users
LIMIT 10;

-- Top 5 highest salaries
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

**LIMIT with OFFSET (Pagination)**:

```sql
-- Page 1 (rows 1-10)
SELECT * FROM products
ORDER BY product_id
LIMIT 10 OFFSET 0;

-- Page 2 (rows 11-20)
SELECT * FROM products
ORDER BY product_id
LIMIT 10 OFFSET 10;

-- Page 3 (rows 21-30)
SELECT * FROM products
ORDER BY product_id
LIMIT 10 OFFSET 20;
```

**Pagination Formula**:

```
OFFSET = (page_number - 1) × page_size
LIMIT = page_size

Example for page 3 with 25 items per page:
OFFSET = (3 - 1) × 25 = 50
LIMIT = 25
```

**Practical Pagination**:

```sql
-- Function-style pagination
-- Page 1, 20 items per page
SELECT * FROM logs
ORDER BY created_at DESC
LIMIT 20 OFFSET 0;

-- Page 5, 20 items per page
SELECT * FROM logs
ORDER BY created_at DESC
LIMIT 20 OFFSET 80;  -- (5-1) * 20 = 80
```

**Alternative Syntax (ANSI SQL)**:

```sql
-- Same as LIMIT 10 OFFSET 20
SELECT * FROM users
OFFSET 20 ROWS
FETCH FIRST 10 ROWS ONLY;
```

---

### S - Search (Pattern Matching)

**Purpose**: Text pattern matching and regex search.

**Methods**:

|Method|Purpose|Case Sensitive|Example|
|---|---|---|---|
|`LIKE`|Pattern matching|Yes|`name LIKE 'J%'`|
|`ILIKE`|Pattern matching|No (PostgreSQL)|`name ILIKE 'j%'`|
|`~`|Regex match|Yes (PostgreSQL)|`email ~ '@gmail.com# SQL Practice Guide - DevOps Interview Style|

## PART 1: SAMPLE DATABASE SETUP

---

## 1. Create Tables and Insert Data

### Tables Structure

```sql
-- Services table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL
);

-- Logs table
CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    service_id INTEGER NOT NULL,
    level VARCHAR(10) NOT NULL,
    response_time_ms INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);
```

---

### Insert Sample Data

```sql
-- Insert services
INSERT INTO services (service_id, service_name) VALUES
(1, 'auth'),
(2, 'payments'),
(3, 'search'),
(4, 'notifications');

-- Insert logs
INSERT INTO logs (log_id, service_id, level, response_time_ms, created_at) VALUES
(1, 1, 'INFO', 120, '2025-01-01 10:00'),
(2, 1, 'ERROR', 450, '2025-01-01 10:05'),
(3, 2, 'ERROR', 700, '2025-01-01 10:10'),
(4, 2, 'WARN', 300, '2025-01-01 10:15'),
(5, 3, 'INFO', 90, '2025-01-01 10:20'),
(6, 3, 'ERROR', 800, '2025-01-01 10:25'),
(7, 3, 'ERROR', 650, '2025-01-01 10:30'),
(8, 4, 'INFO', 110, '2025-01-01 10:35');
```

---

### View Data

```sql
-- View services
SELECT * FROM services;

-- View logs
SELECT * FROM logs;

-- View logs with service names
SELECT l.log_id, s.service_name, l.level, l.response_time_ms, l.created_at
FROM logs l
JOIN services s ON l.service_id = s.service_id
ORDER BY l.created_at;
```

---


---
##  Pattern Matching and Negation

### Problem

List all logs where:

- Service name contains the letter "a"
- Log level is NOT INFO

### Expected Output

```
service_name | level | response_time_ms | created_at
-------------+-------+------------------+-------------------
payments     | ERROR | 700              | 2025-01-01 10:10
payments     | WARN  | 300              | 2025-01-01 10:15
search       | ERROR | 800              | 2025-01-01 10:25
search       | ERROR | 650              | 2025-01-01 10:30
```

### Solution

```sql
SELECT s.service_name, l.level, l.response_time_ms, l.created_at
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE s.service_name LIKE '%a%'
  AND l.level <> 'INFO';
```

### Explanation

1. **LIKE '%a%'**: Pattern matching
    - `%` matches zero or more characters
    - Finds any name containing 'a'
2. **<> 'INFO'**: Not equal operator
    - Could also use `!= 'INFO'` or `NOT level = 'INFO'`

### Pattern Matching Variations

```sql
-- Starts with 'a'
WHERE service_name LIKE 'a%'

-- Ends with 'a'
WHERE service_name LIKE '%a'

-- Case-insensitive (PostgreSQL)
WHERE service_name ILIKE '%A%'

-- Multiple patterns (OR)
WHERE service_name LIKE '%a%' OR service_name LIKE '%e%'

-- NOT LIKE
WHERE service_name NOT LIKE '%test%'
```

### Key Concepts

- `LIKE` for pattern matching
- `%` = wildcard (any characters)
- `_` = single character wildcard
- `<>` and `!=` both mean "not equal"

---

## PART 3: ADVANCED QUESTIONS

---

## Window Functions - Ranking

### Problem

Rank services by their average response time. Show rank, service name, and average response time.

### Solution

```sql
SELECT 
    RANK() OVER (ORDER BY AVG(l.response_time_ms) DESC) AS rank,
    s.service_name,
    AVG(l.response_time_ms) AS avg_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
ORDER BY rank;
```

### Expected Output

```
rank | service_name  | avg_response_time
-----+---------------+-------------------
1    | search        | 513.33
2    | payments      | 500.00
3    | auth          | 285.00
4    | notifications | 110.00
```

---

##  Subquery - Services Slower Than Average

### Problem

Find services where the maximum response time is greater than the overall average response time across all logs.

### Solution

```sql
SELECT s.service_name, MAX(l.response_time_ms) AS max_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING MAX(l.response_time_ms) > (
    SELECT AVG(response_time_ms) FROM logs
);
```

### Explanation

1. **Subquery**: `(SELECT AVG(response_time_ms) FROM logs)` calculates overall average
2. **HAVING with subquery**: Compare max per service against overall average
3. Only services exceeding overall average are returned

---

##  Date Functions - Daily Statistics

### Problem

Show total logs and average response time per day.

### Solution

```sql
SELECT 
    DATE(created_at) AS log_date,
    COUNT(*) AS total_logs,
    AVG(response_time_ms) AS avg_response_time,
    MIN(response_time_ms) AS min_response_time,
    MAX(response_time_ms) AS max_response_time
FROM logs
GROUP BY DATE(created_at)
ORDER BY log_date;
```

---

## Question 10: Self Join - Compare Service Performance

### Problem

Find pairs of services where service A has a higher average response time than service B.

### Solution

```sql
WITH service_avg AS (
    SELECT 
        s.service_id,
        s.service_name,
        AVG(l.response_time_ms) AS avg_response_time
    FROM logs l
    JOIN services s ON l.service_id = s.service_id
    GROUP BY s.service_id, s.service_name
)
SELECT 
    a.service_name AS faster_service,
    b.service_name AS slower_service,
    a.avg_response_time AS faster_avg,
    b.avg_response_time AS slower_avg
FROM service_avg a
JOIN service_avg b ON a.avg_response_time < b.avg_response_time
ORDER BY b.avg_response_time DESC;
```

---

## PART 4: ALTERNATIVE APPROACHES (WITHOUT JOINS)

---

## Question 1 Alternative: Using Subquery

### Original Problem

List service name and total error count for each service that has more than 1 ERROR.

### Solution Without JOIN

```sql
SELECT 
    (SELECT service_name FROM services WHERE service_id = l.service_id) AS service_name,
    COUNT(*) AS error_count
FROM logs l
WHERE l.level = 'ERROR'
GROUP BY l.service_id
HAVING COUNT(*) > 1
ORDER BY error_count DESC;
```

---

## Question 4 Alternative: Using EXISTS

### Original Problem

Find services that have both ERROR and WARN logs.

### Solution Without JOIN (EXISTS)

```sql
SELECT service_name
FROM services s
WHERE EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'ERROR'
)
AND EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'WARN'
);
```

---

## PART 5: POSTGRESQL-SPECIFIC FEATURES

## Question 5 PostgreSQL Version: Using FILTER Clause

### Original Problem

Total logs and error logs per service.

### PostgreSQL Solution with FILTER

```sql
SELECT 
    s.service_name,
    COUNT(*) AS total_logs,
    COUNT(*) FILTER (WHERE l.level = 'ERROR') AS error_logs,
    COUNT(*) FILTER (WHERE l.level = 'WARN') AS warn_logs,
    COUNT(*) FILTER (WHERE l.level = 'INFO') AS info_logs
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING COUNT(*) >= 2;
```

### Explanation

- `FILTER (WHERE condition)` is PostgreSQL extension
- More readable than `COUNT(CASE WHEN ...)`
- Can use with any aggregate function


---

## Question 1: Error Count by Service (Filtered & Sorted)

### Problem

List service name and total error count for each service that has **more than 1 ERROR**, sorted by error count descending.

### Expected Output

```
service_name | error_count
-------------+-------------
search       | 2
```

### Solution

```sql
SELECT s.service_name, COUNT(*) AS error_count
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE l.level = 'ERROR'
GROUP BY s.service_name
HAVING COUNT(*) > 1
ORDER BY error_count DESC;
```

### Explanation

1. **JOIN**: Combine logs with services to get service names
2. **WHERE**: Filter only ERROR level logs
3. **GROUP BY**: Group by service name to count errors per service
4. **HAVING**: Filter groups that have more than 1 error
5. **ORDER BY**: Sort by error count in descending order

### Key Concepts

- `WHERE` filters **before** grouping
- `HAVING` filters **after** grouping
- `COUNT(*)` counts all rows in each group

---

## Question 2: Average Response Time (Multiple Conditions)

### Problem

Find the average response time per service, but only include logs with:

- level = `ERROR`
- response time greater than 500 ms

### Expected Output

```
service_name | avg_response_time
-------------+-------------------
payments     | 700.00
search       | 725.00
```

### Solution

```sql
SELECT s.service_name, AVG(l.response_time_ms) AS avg_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE l.level = 'ERROR'
  AND l.response_time_ms > 500
GROUP BY s.service_name;
```

### Explanation

1. **JOIN**: Get service names
2. **WHERE**: Two conditions combined with AND
    - Only ERROR logs
    - Only response time > 500ms
3. **AVG()**: Calculate average response time
4. **GROUP BY**: Calculate average per service

### Key Concepts

- Multiple conditions in WHERE clause use `AND`
- `AVG()` is an aggregate function
- Only rows matching WHERE clause are included in average

---

## Question 3: Top N with Limit

### Problem

Show the **top 2 services** with the highest maximum response time, along with that max value.

### Expected Output

```
service_name | max_response_time
-------------+-------------------
search       | 800
payments     | 700
```

### Solution

```sql
SELECT s.service_name, MAX(l.response_time_ms) AS max_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
ORDER BY max_response_time DESC
LIMIT 2;
```

### Explanation

1. **MAX()**: Find highest response time per service
2. **GROUP BY**: Calculate max per service
3. **ORDER BY DESC**: Sort highest to lowest
4. **LIMIT 2**: Get only top 2 results

### Key Concepts

- `LIMIT` restricts number of rows returned
- `ORDER BY DESC` is essential before LIMIT for "top N"
- Without ORDER BY, LIMIT gives arbitrary rows

---

---

## 7. WHERE vs HAVING (Critical Distinction)

### Comparison Table

|Aspect|WHERE|HAVING|
|---|---|---|
|**Filters**|Individual rows|Groups (after GROUP BY)|
|**Execution**|Before GROUP BY|After GROUP BY|
|**Can use aggregates?**|No|Yes|
|**Use with**|Any SELECT|Only with GROUP BY|

### Examples

**WHERE - Row Filtering**:

```sql
-- Filter rows before grouping
SELECT department, AVG(salary) AS avg_salary
FROM employees
WHERE status = 'active'  -- Filters individual employee rows
GROUP BY department;
```

**HAVING - Group Filtering**:

```sql
-- Filter groups after aggregation
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;  -- Filters department groups
```

**Both Together**:

```sql
-- Filter rows first, then filter groups
SELECT department, AVG(salary) AS avg_salary
FROM employees
WHERE status = 'active'          -- Filter: only active employees
GROUP BY department
HAVING AVG(salary) > 50000       -- Filter: departments with high avg
   AND COUNT(*) >= 5;            -- Filter: departments with 5+ employees
```

---

## 8. FAR-GLASS Quick Reference

### One-Line Summary per Component

```
F - Filter      → WHERE: Filter rows before grouping
A - Aggregate   → COUNT/SUM/AVG/MIN/MAX: Calculate metrics
R - Relate      → JOIN: Combine multiple tables
G - Group       → GROUP BY: Group rows for aggregation
L - Logical     → AND/OR/NOT/IN: Combine conditions
A - Arrange     → ORDER BY: Sort results
S - Slice       → LIMIT/OFFSET: Paginate results
S - Search      → LIKE/ILIKE/regex: Pattern matching
```

### Memory Aid

**FAR-GLASS Query Flow**:

```
1. Get data FROM tables
2. RELATE tables with JOIN
3. FILTER rows with WHERE
4. GROUP rows with GROUP BY
5. FILTER groups with HAVING
6. AGGREGATE with COUNT/SUM/AVG
7. ARRANGE with ORDER BY
8. SLICE with LIMIT
9. SEARCH with LIKE/ILIKE
```

---

## 9. Interview-Ready One-Liner

**"CRUD defines data operations (Create, Read, Update, Delete). FAR-GLASS explains how SELECT queries work: Filter rows with WHERE, Aggregate metrics with COUNT/SUM/AVG, Relate tables with JOIN, Group with GROUP BY, use Logical operators AND/OR, Arrange with ORDER BY, Slice with LIMIT, and Search with LIKE for pattern matching."**

---

## END OF FAR-GLASS EXPLANATION

**Key Takeaways:** ✓ FAR-GLASS is a mental model for SELECT queries ✓ Execution order differs from written order ✓ WHERE filters rows, HAVING filters groups ✓ Aggregates cannot be used in WHERE ✓ Always ORDER BY before LIMIT for "Top N" ✓ JOIN types determine which rows are kept ✓ GROUP BY is required when mixing aggregates with non-aggregates

**Covered Topics:** ✓ Complete data types (numeric, character, date/time, boolean, JSON, array, UUID) ✓ All constraints (NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT) ✓ Database CRUD (CREATE, USE/Switch, UPDATE, DELETE) ✓ Table CRUD (CREATE, ALTER, DROP, TRUNCATE) ✓ Data CRUD (INSERT, SELECT, UPDATE, DELETE) ✓ Advanced SELECT (WHERE, ORDER BY, LIMIT, GROUP BY, HAVING, JOINS, Subqueries) ✓ Real-world examples (Library Management System, DevOps Log Analysis) ✓ FAR-GLASS Model (Complete structured explanation) ✓ Complete syntax reference

**Exam & Interview Ready:** Comprehensive guide for PostgreSQL, SQL, DBMS theory, and practical operations.# SQL Practice Guide - DevOps Interview Style

## PART 1: SAMPLE DATABASE SETUP

---

## 1. Create Tables and Insert Data

### Tables Structure

```sql
-- Services table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL
);

-- Logs table
CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    service_id INTEGER NOT NULL,
    level VARCHAR(10) NOT NULL,
    response_time_ms INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);
```

---

### Insert Sample Data

```sql
-- Insert services
INSERT INTO services (service_id, service_name) VALUES
(1, 'auth'),
(2, 'payments'),
(3, 'search'),
(4, 'notifications');

-- Insert logs
INSERT INTO logs (log_id, service_id, level, response_time_ms, created_at) VALUES
(1, 1, 'INFO', 120, '2025-01-01 10:00'),
(2, 1, 'ERROR', 450, '2025-01-01 10:05'),
(3, 2, 'ERROR', 700, '2025-01-01 10:10'),
(4, 2, 'WARN', 300, '2025-01-01 10:15'),
(5, 3, 'INFO', 90, '2025-01-01 10:20'),
(6, 3, 'ERROR', 800, '2025-01-01 10:25'),
(7, 3, 'ERROR', 650, '2025-01-01 10:30'),
(8, 4, 'INFO', 110, '2025-01-01 10:35');
```

---

### View Data

```sql
-- View services
SELECT * FROM services;

-- View logs
SELECT * FROM logs;

-- View logs with service names
SELECT l.log_id, s.service_name, l.level, l.response_time_ms, l.created_at
FROM logs l
JOIN services s ON l.service_id = s.service_id
ORDER BY l.created_at;
```

---

## PART 2: BASIC TO MEDIUM LEVEL QUESTIONS

---

## Question 1: Error Count by Service (Filtered & Sorted)

### Problem

List service name and total error count for each service that has **more than 1 ERROR**, sorted by error count descending.

### Expected Output

```
service_name | error_count
-------------+-------------
search       | 2
```

### Solution

```sql
SELECT s.service_name, COUNT(*) AS error_count
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE l.level = 'ERROR'
GROUP BY s.service_name
HAVING COUNT(*) > 1
ORDER BY error_count DESC;
```

### Explanation

1. **JOIN**: Combine logs with services to get service names
2. **WHERE**: Filter only ERROR level logs
3. **GROUP BY**: Group by service name to count errors per service
4. **HAVING**: Filter groups that have more than 1 error
5. **ORDER BY**: Sort by error count in descending order

### Key Concepts

- `WHERE` filters **before** grouping
- `HAVING` filters **after** grouping
- `COUNT(*)` counts all rows in each group

---

## Question 2: Average Response Time (Multiple Conditions)

### Problem

Find the average response time per service, but only include logs with:

- level = `ERROR`
- response time greater than 500 ms

### Expected Output

```
service_name | avg_response_time
-------------+-------------------
payments     | 700.00
search       | 725.00
```

### Solution

```sql
SELECT s.service_name, AVG(l.response_time_ms) AS avg_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE l.level = 'ERROR'
  AND l.response_time_ms > 500
GROUP BY s.service_name;
```

### Explanation

1. **JOIN**: Get service names
2. **WHERE**: Two conditions combined with AND
    - Only ERROR logs
    - Only response time > 500ms
3. **AVG()**: Calculate average response time
4. **GROUP BY**: Calculate average per service

### Key Concepts

- Multiple conditions in WHERE clause use `AND`
- `AVG()` is an aggregate function
- Only rows matching WHERE clause are included in average

---

## Question 3: Top N with Limit

### Problem

Show the **top 2 services** with the highest maximum response time, along with that max value.

### Expected Output

```
service_name | max_response_time
-------------+-------------------
search       | 800
payments     | 700
```

### Solution

```sql
SELECT s.service_name, MAX(l.response_time_ms) AS max_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
ORDER BY max_response_time DESC
LIMIT 2;
```

### Explanation

1. **MAX()**: Find highest response time per service
2. **GROUP BY**: Calculate max per service
3. **ORDER BY DESC**: Sort highest to lowest
4. **LIMIT 2**: Get only top 2 results

### Key Concepts

- `LIMIT` restricts number of rows returned
- `ORDER BY DESC` is essential before LIMIT for "top N"
- Without ORDER BY, LIMIT gives arbitrary rows

---

## Question 4: Services with Multiple Log Levels

### Problem

Find services that have **both ERROR and WARN** logs.

### Expected Output

```
service_name
-------------
payments
```

### Solution

```sql
SELECT s.service_name
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE l.level IN ('ERROR', 'WARN')
GROUP BY s.service_name
HAVING COUNT(DISTINCT l.level) = 2;
```

### Explanation

1. **WHERE IN**: Filter logs that are either ERROR or WARN
2. **GROUP BY**: Group by service
3. **COUNT(DISTINCT l.level)**: Count unique log levels
4. **HAVING = 2**: Only services with exactly 2 distinct levels (both ERROR and WARN)

### Alternative Solution (Using Subqueries)

```sql
SELECT s.service_name
FROM services s
WHERE EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'ERROR'
)
AND EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'WARN'
);
```

### Key Concepts

- `DISTINCT` removes duplicates before counting
- `HAVING COUNT(DISTINCT ...)` is powerful for "has both" queries
- `EXISTS` subquery is alternative approach

---

## Question 5: Conditional Counting

### Problem

For each service, show:

- total logs
- total ERROR logs

Include only services where **total logs ≥ 2**.

### Expected Output

```
service_name | total_logs | error_logs
-------------+------------+------------
auth         | 2          | 1
payments     | 2          | 1
search       | 3          | 2
notifications| 1          | 0
```

(Note: notifications excluded due to HAVING filter)

### Solution

```sql
SELECT s.service_name,
       COUNT(*) AS total_logs,
       COUNT(CASE WHEN l.level = 'ERROR' THEN 1 END) AS error_logs
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING COUNT(*) >= 2;
```

### Explanation

1. **COUNT(*)**: Total logs per service
2. **COUNT(CASE WHEN ... THEN 1 END)**: Conditional count
    - Returns 1 only when level is ERROR
    - COUNT counts non-NULL values
    - Non-matching rows return NULL (not counted)
3. **HAVING COUNT(*) >= 2**: Filter services with at least 2 logs

### Alternative Using SUM

```sql
SELECT s.service_name,
       COUNT(*) AS total_logs,
       SUM(CASE WHEN l.level = 'ERROR' THEN 1 ELSE 0 END) AS error_logs
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING COUNT(*) >= 2;
```

### Key Concepts

- `CASE WHEN` creates conditional logic in SELECT
- `COUNT(expression)` only counts non-NULL values
- `SUM(CASE ...)` is alternative for counting with conditions

---

## Question 6: Pattern Matching and Negation

### Problem

List all logs where:

- Service name contains the letter "a"
- Log level is NOT INFO

### Expected Output

```
service_name | level | response_time_ms | created_at
-------------+-------+------------------+-------------------
payments     | ERROR | 700              | 2025-01-01 10:10
payments     | WARN  | 300              | 2025-01-01 10:15
search       | ERROR | 800              | 2025-01-01 10:25
search       | ERROR | 650              | 2025-01-01 10:30
```

### Solution

```sql
SELECT s.service_name, l.level, l.response_time_ms, l.created_at
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE s.service_name LIKE '%a%'
  AND l.level <> 'INFO';
```

### Explanation

1. **LIKE '%a%'**: Pattern matching
    - `%` matches zero or more characters
    - Finds any name containing 'a'
2. **<> 'INFO'**: Not equal operator
    - Could also use `!= 'INFO'` or `NOT level = 'INFO'`

### Pattern Matching Variations

```sql
-- Starts with 'a'
WHERE service_name LIKE 'a%'

-- Ends with 'a'
WHERE service_name LIKE '%a'

-- Case-insensitive (PostgreSQL)
WHERE service_name ILIKE '%A%'

-- Multiple patterns (OR)
WHERE service_name LIKE '%a%' OR service_name LIKE '%e%'

-- NOT LIKE
WHERE service_name NOT LIKE '%test%'
```

### Key Concepts

- `LIKE` for pattern matching
- `%` = wildcard (any characters)
- `_` = single character wildcard
- `<>` and `!=` both mean "not equal"

---

## PART 3: ADVANCED QUESTIONS

---

## Question 7: Window Functions - Ranking

### Problem

Rank services by their average response time. Show rank, service name, and average response time.

### Solution

```sql
SELECT 
    RANK() OVER (ORDER BY AVG(l.response_time_ms) DESC) AS rank,
    s.service_name,
    AVG(l.response_time_ms) AS avg_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
ORDER BY rank;
```

### Expected Output

```
rank | service_name  | avg_response_time
-----+---------------+-------------------
1    | search        | 513.33
2    | payments      | 500.00
3    | auth          | 285.00
4    | notifications | 110.00
```

---

## Question 8: Subquery - Services Slower Than Average

### Problem

Find services where the maximum response time is greater than the overall average response time across all logs.

### Solution

```sql
SELECT s.service_name, MAX(l.response_time_ms) AS max_response_time
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING MAX(l.response_time_ms) > (
    SELECT AVG(response_time_ms) FROM logs
);
```

### Explanation

1. **Subquery**: `(SELECT AVG(response_time_ms) FROM logs)` calculates overall average
2. **HAVING with subquery**: Compare max per service against overall average
3. Only services exceeding overall average are returned

---

## Question 9: Date Functions - Daily Statistics

### Problem

Show total logs and average response time per day.

### Solution

```sql
SELECT 
    DATE(created_at) AS log_date,
    COUNT(*) AS total_logs,
    AVG(response_time_ms) AS avg_response_time,
    MIN(response_time_ms) AS min_response_time,
    MAX(response_time_ms) AS max_response_time
FROM logs
GROUP BY DATE(created_at)
ORDER BY log_date;
```

---

## Question 10: Self Join - Compare Service Performance

### Problem

Find pairs of services where service A has a higher average response time than service B.

### Solution

```sql
WITH service_avg AS (
    SELECT 
        s.service_id,
        s.service_name,
        AVG(l.response_time_ms) AS avg_response_time
    FROM logs l
    JOIN services s ON l.service_id = s.service_id
    GROUP BY s.service_id, s.service_name
)
SELECT 
    a.service_name AS faster_service,
    b.service_name AS slower_service,
    a.avg_response_time AS faster_avg,
    b.avg_response_time AS slower_avg
FROM service_avg a
JOIN service_avg b ON a.avg_response_time < b.avg_response_time
ORDER BY b.avg_response_time DESC;
```

---

## PART 4: ALTERNATIVE APPROACHES (WITHOUT JOINS)

---

## Question 1 Alternative: Using Subquery

### Original Problem

List service name and total error count for each service that has more than 1 ERROR.

### Solution Without JOIN

```sql
SELECT 
    (SELECT service_name FROM services WHERE service_id = l.service_id) AS service_name,
    COUNT(*) AS error_count
FROM logs l
WHERE l.level = 'ERROR'
GROUP BY l.service_id
HAVING COUNT(*) > 1
ORDER BY error_count DESC;
```

---

## Question 4 Alternative: Using EXISTS

### Original Problem

Find services that have both ERROR and WARN logs.

### Solution Without JOIN (EXISTS)

```sql
SELECT service_name
FROM services s
WHERE EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'ERROR'
)
AND EXISTS (
    SELECT 1 FROM logs WHERE service_id = s.service_id AND level = 'WARN'
);
```

---

## PART 5: POSTGRESQL-SPECIFIC FEATURES

---

## Question 5 PostgreSQL Version: Using FILTER Clause

### Original Problem

Total logs and error logs per service.

### PostgreSQL Solution with FILTER

```sql
SELECT 
    s.service_name,
    COUNT(*) AS total_logs,
    COUNT(*) FILTER (WHERE l.level = 'ERROR') AS error_logs,
    COUNT(*) FILTER (WHERE l.level = 'WARN') AS warn_logs,
    COUNT(*) FILTER (WHERE l.level = 'INFO') AS info_logs
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING COUNT(*) >= 2;
```

### Explanation

- `FILTER (WHERE condition)` is PostgreSQL extension
- More readable than `COUNT(CASE WHEN ...)`
- Can use with any aggregate function
---

## Common Mistakes to Avoid

### Mistake 1: Using WHERE instead of HAVING

```sql
-- WRONG: Cannot use aggregate in WHERE
SELECT service_name, COUNT(*) AS total
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE COUNT(*) > 5;  -- ERROR!

-- CORRECT: Use HAVING for aggregates
SELECT s.service_name, COUNT(*) AS total
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name
HAVING COUNT(*) > 5;
```

---

### Mistake 2: Forgetting GROUP BY

```sql
-- WRONG: SELECT non-aggregated column without GROUP BY
SELECT service_name, COUNT(*)
FROM logs;  -- ERROR!

-- CORRECT: Include all non-aggregated columns in GROUP BY
SELECT s.service_name, COUNT(*)
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name;
```

---

### Mistake 3: Wrong Conditional Counting

```sql
-- WRONG: Counts all rows, not just ERRORs
SELECT service_name, COUNT(*)
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE level = 'ERROR' OR level = 'WARN'
GROUP BY service_name;

-- CORRECT: Use CASE WHEN for conditional count
SELECT 
    s.service_name,
    COUNT(CASE WHEN l.level = 'ERROR' THEN 1 END) AS errors,
    COUNT(CASE WHEN l.level = 'WARN' THEN 1 END) AS warnings
FROM logs l
JOIN services s ON l.service_id = s.service_id
GROUP BY s.service_name;
```

---

### Mistake 4: Not Using DISTINCT with Multiple Criteria

```sql
-- WRONG: May count duplicates
SELECT service_name
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE level IN ('ERROR', 'WARN')
GROUP BY service_name
HAVING COUNT(level) = 2;  -- Counts rows, not distinct levels

-- CORRECT: Use COUNT(DISTINCT ...)
SELECT s.service_name
FROM logs l
JOIN services s ON l.service_id = s.service_id
WHERE level IN ('ERROR', 'WARN')
GROUP BY s.service_name
HAVING COUNT(DISTINCT level) = 2;
```

---

