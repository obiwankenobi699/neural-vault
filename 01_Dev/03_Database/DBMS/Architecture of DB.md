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

## **1️ Tier-1 Architecture (Single-Tier / Monolithic Architecture)**

**Topic:** _What is Tier-1 Architecture?_  
**Paragraph:**  
Tier-1 architecture is the simplest software architecture where the entire application — UI, business logic, and database — exists within a **single layer** or a **single machine**. It is also called the _monolithic_ or _standalone_ architecture. All operations (input handling, processing, storage) occur locally without any external servers. Because everything runs together, Tier-1 apps are easy to build and deploy but become hard to scale, update, and maintain as complexity grows. Common examples include desktop applications (MS Word, VLC player) where all logic executes on a single device.

---

## **2️Tier-2 Architecture (Client–Server Architecture)**

**Topic:** _What is Tier-2 Architecture?_  
**Paragraph:**  
Tier-2 architecture splits the application into **two distinct layers**: the client and the server. The client handles the UI and some presentation logic, while the server manages business logic, data processing, and the database. Communication between the two happens through network protocols (HTTP, TCP, etc.). This separation improves performance and maintainability compared to Tier-1. It is commonly used in web applications where a browser acts as the client, and a backend server (Node.js, Flask, Django) handles processing and database operations. However, scaling may become limited because both logic and data reside on the same server-side tier.

---

## **3️ Tier-3 Architecture (Three-Tier / N-Tier Architecture)**

**Topic:** _What is Tier-3 Architecture?_  
**Paragraph:**  
Tier-3 architecture divides the system into **three independent layers**: the Presentation Layer (UI), Business Logic Layer (API/Backend), and Data Layer (Database). Each tier runs on separate servers and communicates through APIs or network protocols. This architecture provides high scalability, security, and maintainability because each layer can be modified, upgraded, and scaled independently. For example, the frontend (React/Angular) interacts with a backend (Express.js/Django/Spring) which then communicates with a database (MySQL/MongoDB). This separation allows load balancing, microservices expansion, and fault isolation, making Tier-3 the most widely used architecture in modern web systems.

---

# **Three-Level Database Architecture**

```
              +---------------------------+
              |     External Level        |
              |  (User Views / Applications) 
              +---------------------------+
                          ↑
                          |
              +---------------------------+
              |     Conceptual Level      |
              |     (Logical Schema)      |
              +---------------------------+
                          ↑
                          |
              +---------------------------+
              |      Internal Level        |
              |   (Physical Storage)       |
              +---------------------------+
```

---

# **1. Internal Level (Physical Level)**

**Topic:** Internal Level  
**Paragraph:**  
The internal level is the lowest layer of the database architecture that defines _how data is physically stored_ in memory and on disk. It describes file structures, record formats, indexing techniques, hashing, data compression, and physical block organization. This level is concerned with storage efficiency, access speed, and performance optimization. It hides low-level hardware details from higher layers, allowing them to remain unaffected by physical storage changes.

---

# **2. Conceptual Level (Logical Level)**

**Topic:** Conceptual Level  
**Paragraph:**  
The conceptual level represents the _logical structure_ of the entire database. It defines what data is stored, the relationships between data, constraints, schemas, keys, and integrity rules. This level provides a unified organization-wide view of the database independent of any application. It also ensures logical data independence, meaning that changes in the logical structure do not affect users' external views.

---

# **3. External Level (View / Application Level)**

**Topic:** External Level  
**Paragraph:**  
The external level is the highest layer that describes _how individual users or applications view the data_. Each user may have a different external schema, showing only the relevant subset of the data. This ensures security by hiding sensitive information and simplifies user interaction. Changes to user views at this level do not affect the conceptual schema, providing view-level independence.

---

# **Summary Table**

```
+-----------------+----------------------+------------------------------------------+
| Level           | Also Called          | Defines                                  |
+-----------------+----------------------+------------------------------------------+
| External        | View / Application   | User-specific views of data              |
| Conceptual      | Logical              | Overall logical structure of database    |
| Internal        | Physical             | Physical storage of data on disk         |
+-----------------+----------------------+------------------------------------------+
```

# **Instance, Schema, and Types of Schema**

---

## **1. Schema**

**Topic:** Schema  
**Paragraph:**  
A _schema_ is the **overall logical design** or **blueprint** of the entire database. It describes the structure of data, including tables, attributes, relationships, constraints, and data types. A schema defines _what the database contains_ and _how the data is organized_. It is generally stable and changes very rarely. Schemas are defined during database design and remain constant unless the structure itself is modified.

---

## **2. Instance**

**Topic:** Instance  
**Paragraph:**  
An _instance_ of a database refers to the **actual data stored** in the database at a particular moment in time. It is the “snapshot” of the database’s content. Unlike schemas, instances change frequently as data is inserted, updated, or deleted. The schema is the blueprint, and the instance is the current state based on that blueprint.

---

## **Schema vs. Instance (ASCII Diagram)**

```
SCHEMA (Structure)
--------------------------------
| Student(roll, name, age)     |   --> Fixed structure
--------------------------------

INSTANCE (Current Data)
--------------------------------
| 1 | Rohan | 20               |
| 2 | Neha  | 21               |
--------------------------------   --> Changes over time
```

---

# **Types of Schema**

Database systems use **three types of schema**, corresponding to the 3-level architecture.

```
          External Schema (View)
                   ↑
          Conceptual Schema (Logical)
                   ↑
          Internal Schema (Physical)
```

---

## **1. External Schema (View Schema)**

**Topic:** External Schema  
**Paragraph:**  
The external schema defines **how individual users or applications view the data**. Each user may have a customized view showing only a part of the full database. This layer ensures security and hides irrelevant or sensitive data from specific users. External schemas are also called _sub-schemas_ or _views_.

---

## **2. Conceptual Schema**

**Topic:** Conceptual Schema  
**Paragraph:**  
The conceptual schema describes the **entire logical structure** of the database for the whole organization. It includes all entities, relationships, constraints, tables, keys, and data models. This schema provides logical data independence—changes in the physical level do not affect the conceptual design.

---

## **3. Internal Schema (Physical Schema)**

**Topic:** Internal Schema  
**Paragraph:**  
The internal schema describes the **physical storage** of the database. It defines how data is stored on disk using files, indexes, hashing, pointers, and record formats. This schema focuses on efficiency, performance, and storage optimization.

---

# **Summary Table**

```
+--------------------+----------------------+--------------------------------------------+
| Schema Type        | Meaning              | Role                                       |
+--------------------+----------------------+--------------------------------------------+
| External Schema    | User views           | Shows specific subsets of data             |
| Conceptual Schema  | Logical structure    | Full database design for whole organization|
| Internal Schema    | Physical storage     | How data is stored on disk                 |
+--------------------+----------------------+--------------------------------------------+
```

---
