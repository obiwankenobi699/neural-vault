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



Database languages are used to define, manipulate, control, and manage transactions in a database. SQL supports different sub-languages, each designed for a specific purpose.

---

# **1. DDL (Data Definition Language)**

**Topic:** Data Definition Language  
**Paragraph:**  
DDL is used to **define and modify the structure** of the database. It works on schema-level changes such as creating tables, altering structures, defining constraints, and deleting objects. DDL commands affect the overall design of the database and automatically commit changes, meaning they cannot be rolled back in most DBMS.

**Common Commands:**

```
CREATE, ALTER, DROP, TRUNCATE, RENAME
```

---

# **2. DML (Data Manipulation Language)**

**Topic:** Data Manipulation Language  
**Paragraph:**  
DML is used to **manipulate or modify actual data** stored inside tables. These commands operate on database instances, allowing users to insert, update, delete, and retrieve data. Unlike DDL, DML changes can be rolled back or committed using transaction control commands.

**Common Commands:**

```
INSERT, UPDATE, DELETE, SELECT
```

---

# **3. DCL (Data Control Language)**

**Topic:** Data Control Language  
**Paragraph:**  
DCL is used to **control access and permissions** in the database. It ensures security by granting or revoking privileges to users so they can only perform allowed operations. DCL commands help maintain secure and controlled access in multi-user environments.

**Common Commands:**

```
GRANT, REVOKE
```

---

# **4. TCL / DTL (Transaction Control Language)**

(TCL is sometimes called DTL – Data Transaction Language)

**Topic:** Transaction Control Language  
**Paragraph:**  
TCL manages **transactions** in a database, ensuring data consistency and reliability. It allows grouping multiple operations into a single logical unit. TCL commands let users commit changes permanently, undo changes, or temporarily save intermediate states using savepoints. These commands ensure the ACID properties of transactions.

**Common Commands:**

```
COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION
```

---

# **Summary Table**

```
+---------+-------------------------------------------+------------------------------+
| Type    | Purpose                                   | Example Commands             |
+---------+-------------------------------------------+------------------------------+
| DDL     | Defines database structure                | CREATE, ALTER, DROP          |
| DML     | Manipulates stored data                   | INSERT, UPDATE, DELETE       |
| DCL     | Controls user access & permissions        | GRANT, REVOKE                |
| TCL/DTL | Manages transactions & consistency        | COMMIT, ROLLBACK, SAVEPOINT  |
+---------+-------------------------------------------+------------------------------+
```

---

If you want, I can also provide:  
• Short 2–3 marks notes  
• Difference table between DDL vs DML vs DCL vs TCL  
• Sample SQL commands for each type