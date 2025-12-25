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
---

## 1. What is PostgreSQL?

### Definition

**PostgreSQL** is an open-source, object-relational database management system (ORDBMS) that uses SQL for querying and managing data.

### Key Features

1. **ACID Compliant**: Atomicity, Consistency, Isolation, Durability
2. **Multi-User Support**: Concurrent access by multiple users
3. **Cross-Platform**: Works on Linux, Windows, macOS
4. **Extensible**: Custom functions, data types, operators
5. **MVCC**: Multi-Version Concurrency Control for performance

### Why PostgreSQL?

- Free and open-source
- Highly reliable and stable
- Advanced features (JSON, arrays, full-text search)
- Active community support
- Enterprise-grade performance

---

## 2. PostgreSQL Architecture

```
┌─────────────────────────────────────────────────────┐
│                   CLIENT LAYER                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │   psql   │  │ DBeaver  │  │ pgAdmin  │          │
│  │  (CLI)   │  │  (GUI)   │  │  (GUI)   │          │
│  └─────┬────┘  └─────┬────┘  └─────┬────┘          │
└────────┼─────────────┼─────────────┼────────────────┘
         │             │             │
         └─────────────┴─────────────┘
                       │
            ┌──────────▼──────────┐
            │   JDBC / Protocol   │
            └──────────┬──────────┘
                       │
         ┌─────────────▼─────────────────────────────┐
         │         POSTGRESQL SERVER                 │
         │  ┌────────────────────────────────────┐   │
         │  │    postmaster (Main Process)       │   │
         │  └────────────┬───────────────────────┘   │
         │               │                            │
         │     ┌─────────┴──────────┐                │
         │     │   Backend Processes │                │
         │     │   (One per client)  │                │
         │     └─────────┬────────────┘               │
         │               │                            │
         │  ┌────────────▼───────────────────────┐   │
         │  │     Shared Memory & Buffers        │   │
         │  └────────────┬───────────────────────┘   │
         └───────────────┼────────────────────────────┘
                         │
         ┌───────────────▼────────────────────────────┐
         │         DATA DIRECTORY                     │
         │  ┌──────────────────────────────────────┐  │
         │  │  Databases                           │  │
         │  │  ├─ postgres (system)                │  │
         │  │  ├─ template0 (read-only template)   │  │
         │  │  ├─ template1 (default template)     │  │
         │  │  └─ mukuldb (user database)          │  │
         │  │                                       │  │
         │  │  Tables, Indexes, Sequences          │  │
         │  │  WAL (Write-Ahead Logs)              │  │
         │  │  Configuration Files                 │  │
         │  └──────────────────────────────────────┘  │
         └────────────────────────────────────────────┘
              Location: /var/lib/postgres/data
```

---

## PART 2: POSTGRESQL INSTALLATION & SETUP

---

## 3. Installation on Arch Linux

### Step 1: Update System

```bash
sudo pacman -Syu
```

**Why?**

- Ensures latest package database
- Prevents dependency conflicts

---

### Step 2: Install PostgreSQL

```bash
sudo pacman -S postgresql
```

**What Gets Installed?**

1. **postgresql-server**: Database server daemon
2. **psql**: Command-line client
3. **System user**: `postgres` (created automatically)
4. **Data directory**: `/var/lib/postgres/data` (empty initially)

**Verify Installation:**

```bash
psql --version
```

**Expected Output:**

```
psql (PostgreSQL) 16.1
```

---

## 4. Database Initialization (initdb)

### Why Initialization is Required?

**Problem:** After installation, PostgreSQL cannot start immediately.

**Reason:** The data directory is empty. PostgreSQL needs:

- System catalogs (metadata about databases, tables, users)
- Template databases
- Configuration files
- WAL directory

### What is initdb?

**Definition:** `initdb` initializes a PostgreSQL database cluster.

**Database Cluster:** A collection of databases managed by a single server instance.

---

### Initialize Data Directory

**Command:**

```bash
sudo -u postgres initdb -D /var/lib/postgres/data
```

**Flag Explanation:**

- `sudo -u postgres`: Run as postgres user (owner of data files)
- `initdb`: Initialization program
- `-D /var/lib/postgres/data`: Data directory location

**What Happens Internally:**

```
┌─────────────────────────────────────────────────────┐
│  initdb Process                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │  1. Create data directory structure          │  │
│  │     /var/lib/postgres/data/                  │  │
│  │     ├── base/         (databases)            │  │
│  │     ├── global/       (shared catalogs)      │  │
│  │     ├── pg_wal/       (transaction logs)     │  │
│  │     └── pg_tblspc/    (tablespaces)          │  │
│  └───────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────┐  │
│  │  2. Create system catalogs                   │  │
│  │     pg_database, pg_user, pg_tables, etc.    │  │
│  └───────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────┐  │
│  │  3. Create template databases                │  │
│  │     template0 (read-only, pristine)          │  │
│  │     template1 (default template for new DBs) │  │
│  │     postgres (default user database)         │  │
│  └───────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────┐  │
│  │  4. Generate configuration files             │  │
│  │     postgresql.conf  (server settings)       │  │
│  │     pg_hba.conf      (authentication)        │  │
│  │     pg_ident.conf    (user mapping)          │  │
│  └───────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────┐  │
│  │  5. Set default encoding and locale          │  │
│  │     UTF8, en_US.UTF-8                        │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

**Output:**

```
Success. You can now start the database server using:

    pg_ctl -D /var/lib/postgres/data -l logfile start
```

---

## 5. Starting PostgreSQL Service

### Why Service Must Be Started?

**Reason:** PostgreSQL runs as a **background daemon** (service).

**Without the service:**

- No client connections possible
- psql, DBeaver, pgAdmin cannot connect
- Database is inaccessible

---

### Start PostgreSQL Service

**Command:**

```bash
sudo systemctl start postgresql
```

**What Happens:**

1. `postmaster` process starts
2. Listens on port 5432 (default)
3. Reads configuration from `postgresql.conf`
4. Loads authentication rules from `pg_hba.conf`
5. Ready to accept client connections

---

### Check Service Status

**Command:**

```bash
sudo systemctl status postgresql
```

**Expected Output:**

```
● postgresql.service - PostgreSQL database server
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service)
     Active: active (running) since Wed 2024-01-15 10:30:00 IST
   Main PID: 12345 (postgres)
      Tasks: 8
     Memory: 25.5M
        CPU: 100ms
     CGroup: /system.slice/postgresql.service
             └─12345 /usr/bin/postgres -D /var/lib/postgres/data
```

**Key Indicators:**

- `Active: active (running)` ✓
- Main PID exists ✓
- Port 5432 listening ✓

---

### Enable Service at Boot (Optional)

**Command:**

```bash
sudo systemctl enable postgresql
```

**Effect:** PostgreSQL starts automatically on system boot.

---

### Other Service Commands

|Command|Purpose|
|---|---|
|`sudo systemctl stop postgresql`|Stop service|
|`sudo systemctl restart postgresql`|Restart service|
|`sudo systemctl reload postgresql`|Reload config without restart|
|`sudo systemctl disable postgresql`|Disable auto-start|

---

## PART 3: USERS, ROLES, AND DATABASES

---

## 6. Understanding Users in PostgreSQL

### Two Types of Users

```
┌────────────────────────────────────────────────────┐
│                                                    │
│  1. LINUX SYSTEM USER                             │
│     ├─ Created by OS                              │
│     ├─ Has system permissions                     │
│     └─ Example: postgres, mukul (Linux user)      │
│                                                    │
│  2. POSTGRESQL DATABASE ROLE                      │
│     ├─ Created inside PostgreSQL                  │
│     ├─ Has database permissions                   │
│     └─ Example: postgres, mukul (DB role)         │
│                                                    │
│  ⚠️  IMPORTANT: They are SEPARATE                 │
│      Linux user ≠ PostgreSQL role                 │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

### The `postgres` User

**Linux System User:**

```bash
$ id postgres
uid=88(postgres) gid=88(postgres) groups=88(postgres)
```

**Created during PostgreSQL installation:**

- Owns data directory files
- Runs PostgreSQL server process
- Used for administrative tasks

**PostgreSQL Database Role:**

```
postgres=# \du postgres
          List of roles
 Role name | Attributes | Member of
-----------+------------+-----------
 postgres  | Superuser  | {}
```

**Default superuser with full privileges:**

- Create databases
- Create roles
- Modify any data
- Change configuration

---

## 7. Accessing PostgreSQL CLI (psql)

### Switch to postgres User

**Command:**

```bash
sudo -i -u postgres
```

**Explanation:**

- `sudo`: Run with elevated privileges
- `-i`: Simulate login shell
- `-u postgres`: Switch to postgres user

**You're now:**

```
[postgres@hostname ~]$
```

---

### Start psql as postgres

**Command:**

```bash
psql
```

**Default connection:**

- User: postgres
- Database: postgres
- Host: localhost (Unix socket)

**Prompt:**

```
postgres=#
```

`#` indicates superuser privileges.

---

### Alternative: Direct Connection

**From your user account:**

```bash
sudo -u postgres psql
```

**Effect:** Same as switching user, then running psql.

---

## 8. Creating Database Roles (Users)

### Why Create New Roles?

**Problem:** By default, only `postgres` role exists.

**Issues:**

1. Security risk (superuser for everything)
2. No user separation
3. Applications need dedicated users
4. GUI tools need valid credentials

**Best Practice:** Create separate roles for each user/application.

---

### Create a New Role

**Syntax:**

```sql
CREATE ROLE role_name WITH options;
```

**Common Options:**

|Option|Purpose|
|---|---|
|`LOGIN`|Allow role to login (required for users)|
|`PASSWORD 'password'`|Set password for authentication|
|`SUPERUSER`|Grant superuser privileges|
|`CREATEDB`|Allow creating databases|
|`CREATEROLE`|Allow creating other roles|
|`REPLICATION`|Allow replication connections|
|`VALID UNTIL 'timestamp'`|Set expiration date|

---

### Example: Create User 'mukul'

**Command:**

```sql
CREATE ROLE mukul WITH LOGIN PASSWORD 'your_secure_password';
```

**Breakdown:**

- `CREATE ROLE mukul`: Creates role named 'mukul'
- `WITH LOGIN`: Allows mukul to connect to database
- `PASSWORD 'your_secure_password'`: Sets authentication password

**Execute in psql:**

```
postgres=# CREATE ROLE mukul WITH LOGIN PASSWORD 'password123';
CREATE ROLE
```

---

### Create Role with Additional Privileges

**Example 1: User who can create databases**

```sql
CREATE ROLE developer WITH LOGIN PASSWORD 'dev123' CREATEDB;
```

**Example 2: Superuser (like postgres)**

```sql
CREATE ROLE admin WITH LOGIN PASSWORD 'admin123' SUPERUSER;
```

**Example 3: Read-only user**

```sql
CREATE ROLE readonly WITH LOGIN PASSWORD 'read123';
-- Grant only SELECT on specific tables later
```

---

### Alternative: CREATE USER Command

**Shorthand syntax:**

```sql
CREATE USER mukul WITH PASSWORD 'password123';
```

**Difference:**

- `CREATE USER` = `CREATE ROLE ... WITH LOGIN`
- `CREATE USER` automatically includes LOGIN privilege

**Both are equivalent:**

```sql
CREATE ROLE mukul WITH LOGIN PASSWORD 'pass';
CREATE USER mukul WITH PASSWORD 'pass';
```

---

## 9. Creating Databases

### Why Create Separate Databases?

**Best Practices:**

1. **Separation of Concerns**: Each project has its own database
2. **Security**: Users can access only their databases
3. **Backup**: Easier to backup individual projects
4. **Maintenance**: Clear ownership and permissions

**Avoid:** Using default `postgres` database for applications.

---

### Create Database Syntax

**Basic:**

```sql
CREATE DATABASE database_name;
```

**With Owner:**

```sql
CREATE DATABASE database_name OWNER role_name;
```

**With All Options:**

```sql
CREATE DATABASE database_name
    OWNER role_name
    ENCODING 'UTF8'
    LC_COLLATE 'en_US.UTF-8'
    LC_CTYPE 'en_US.UTF-8'
    TEMPLATE template0
    CONNECTION LIMIT 100;
```

---

### Example: Create Database for User 'mukul'

**Command:**

```sql
CREATE DATABASE mukuldb OWNER mukul;
```

**Breakdown:**

- `CREATE DATABASE mukuldb`: Creates database named 'mukuldb'
- `OWNER mukul`: Sets 'mukul' as database owner

**Execute in psql:**

```
postgres=# CREATE DATABASE mukuldb OWNER mukul;
CREATE DATABASE
```

---

### Verify Database Created

**Command:**

```sql
\l
```

**Output:**

```
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    | Access privileges
-----------+----------+----------+-------------+-------------+-------------------
 mukuldb   | mukul    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres
```

---

### Database Ownership Explained

**Owner Privileges:**

- Full control over the database
- Can create/drop tables
- Grant/revoke permissions to other users
- Backup and restore

**Change Ownership:**

```sql
ALTER DATABASE mukuldb OWNER TO new_owner;
```

---

### Template Databases

**template0:**

- Pristine, read-only template
- Used for creating databases with different encodings
- Never modified

**template1:**

- Default template for new databases
- Can be modified (add extensions, default tables)
- New databases are clones of template1

**Creating from Specific Template:**

```sql
CREATE DATABASE mydb TEMPLATE template0 ENCODING 'UTF8';
```

---

## PART 4: AUTHENTICATION CONFIGURATION

---

## 10. Understanding pg_hba.conf

### What is pg_hba.conf?

**Full Name:** PostgreSQL Host-Based Authentication Configuration

**Purpose:** Controls **who can connect**, **from where**, and **how they authenticate**.

**Location:** `/var/lib/postgres/data/pg_hba.conf`

---

### File Format

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
```

**Columns:**

|Column|Description|Values|
|---|---|---|
|**TYPE**|Connection type|`local` (Unix socket), `host` (TCP/IP), `hostssl`, `hostnossl`|
|**DATABASE**|Which database|`all`, specific database name, `sameuser`|
|**USER**|Which role|`all`, specific role name|
|**ADDRESS**|IP address range|CIDR notation, `all`, hostname|
|**METHOD**|Authentication method|`peer`, `md5`, `scram-sha-256`, `trust`, `reject`|

---

### Authentication Methods

#### (a) peer

**How it works:**

- Uses Linux system username
- Matches OS username to PostgreSQL role name
- **No password required**
- Only works for local connections (Unix socket)

**Example:**

```
local   all   all   peer
```

**Scenario:**

```bash
$ whoami
mukul

$ psql -U mukul -d mukuldb
# Works if PostgreSQL role 'mukul' exists
# No password asked
```

**Limitation:**

- ✓ Works for psql (local CLI)
- ✗ Does NOT work for GUI tools (DBeaver, pgAdmin)
- ✗ Does NOT work for remote connections

---

#### (b) md5

**How it works:**

- Password-based authentication
- Password is MD5-hashed before sending
- Works for both local and remote connections

**Example:**

```
local   all   all   md5
host    all   all   127.0.0.1/32   md5
```

**Scenario:**

```bash
$ psql -U mukul -d mukuldb -h localhost
Password for user mukul: ****
```

**Benefits:**

- ✓ Works for psql
- ✓ Works for GUI tools (DBeaver, pgAdmin)
- ✓ Works for remote applications
- ✓ More secure (password-based)

---

#### (c) scram-sha-256

**How it works:**

- Modern password authentication
- More secure than md5
- Uses SCRAM (Salted Challenge Response Authentication Mechanism)

**Example:**

```
local   all   all   scram-sha-256
```

**Recommendation:** Use this for new installations (PostgreSQL 10+).

---

#### (d) trust

**How it works:**

- **No authentication**
- Anyone can connect as any user

**Example:**

```
local   all   all   trust
```

**⚠️ DANGER:** Never use in production!

**Use Case:** Temporary testing, development only.

---

#### (e) reject

**How it works:**

- Denies connection
- Used to block specific users/databases

**Example:**

```
local   testdb   baduser   reject
```

---

### Change Authentication Method

**Problem:** Default configuration uses `peer` for local connections.

**Effect:** GUI tools cannot connect.

**Solution:** Change to `md5`.

---

**Step 1: Open pg_hba.conf**

```bash
sudo nano /var/lib/postgres/data/pg_hba.conf
```

**Step 2: Find this line:**

```
local   all   all   peer
```

**Step 3: Change to:**

```
local   all   all   md5
```

**Step 4: Save and exit** (Ctrl+O, Enter, Ctrl+X in nano)

**Step 5: Reload PostgreSQL**

```bash
sudo systemctl reload postgresql
```

**Why reload, not restart?**

- `reload`: Re-reads configuration files (no downtime)
- `restart`: Stops and starts server (active connections dropped)

---

### Full pg_hba.conf Example

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5

# IPv4 local connections:
host    all             all             127.0.0.1/32            md5

# IPv6 local connections:
host    all             all             ::1/128                 md5

# Allow replication connections from localhost
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
```

---

## PART 5: POSTGRESQL CLI COMMANDS (psql)

---

## 11. Basic psql Commands

### Starting psql

**As postgres user:**

```bash
sudo -u postgres psql
```

**As specific user:**

```bash
psql -U username -d database
```

**With password prompt:**

```bash
psql -U mukul -d mukuldb -h localhost
```

**Flags:**

- `-U`: Username (role)
- `-d`: Database name
- `-h`: Hostname (use `localhost` for TCP/IP, omit for Unix socket)
- `-p`: Port (default 5432)
- `-W`: Force password prompt

---

### Meta-Commands (Backslash Commands)

**Important:** Meta-commands start with `\` and do NOT end with semicolon.

---

### Database Commands

|Command|Description|Example|
|---|---|---|
|`\l` or `\list`|List all databases|`\l`|
|`\c <database>` or `\connect`|Connect to database|`\c mukuldb`|
|`\d`|List tables, views, sequences|`\d`|
|`\dt`|List tables only|`\dt`|
|`\dv`|List views only|`\dv`|
|`\di`|List indexes|`\di`|
|`\ds`|List sequences|`\ds`|
|`\dn`|List schemas|`\dn`|

---

### Table Commands

|Command|Description|Example|
|---|---|---|
|`\d <table>`|Describe table structure|`\d students`|
|`\d+ <table>`|Detailed table info|`\d+ students`|
|`\dt <pattern>`|List tables matching pattern|`\dt stud*`|

---

### User/Role Commands

|Command|Description|Example|
|---|---|---|
|`\du` or `\dg`|List roles (users)|`\du`|
|`\du+`|Detailed role information|`\du+`|
|`\du <role>`|Show specific role|`\du mukul`|

**Example Output:**

```
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 mukul     |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS| {}
```

---

### Permission Commands

|Command|Description|Example|
|---|---|---|
|`\dp` or `\z`|List table permissions|`\dp`|
|`\dp <table>`|Show table permissions|`\dp students`|

---

### System/Session Commands

|Command|Description|Example|
|---|---|---|
|`\q` or `\quit`|Quit psql|`\q`|
|`\!`|Execute shell command|`\! ls -l`|
|`\! clear`|Clear screen|`\! clear`|
|`\timing`|Toggle query timing|`\timing`|
|`\x`|Toggle expanded output|`\x`|
|`\e`|Open query in editor|`\e`|
|`\g`|Execute last query|`\g`|
|`\s`|Display command history|`\s`|
|`\i <file>`|Execute SQL from file|`\i script.sql`|
|`\o <file>`|Send output to file|`\o output.txt`|

---

### Connection Information

|Command|Description|Example|
|---|---|---|
|`\conninfo`|Display connection info|`\conninfo`|
|`\password`|Change role password|`\password mukul`|

**Example Output:**

```
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/run/postgresql" at port "5432".
```

---

### Help Commands

|Command|Description|Example|
|---|---|---|
|`\?`|List all psql commands|`\?`|
|`\h`|List SQL commands|`\h`|
|`\h <command>`|Help on SQL command|`\h CREATE TABLE`|

---

## 12. Complete psql Workflow Example

### Scenario: Create Database and User

```sql
-- Step 1: Connect as postgres
$ sudo -u postgres psql

-- Step 2: List existing databases
postgres=# \l

-- Step 3: List existing roles
postgres=# \du

-- Step 4: Create new role
postgres=# CREATE ROLE mukul WITH LOGIN PASSWORD 'secure_password';
CREATE ROLE

-- Step 5: Verify role created
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 mukul     |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS| {}

-- Step 6: Create database for mukul
postgres=# CREATE DATABASE mukuldb OWNER mukul;
CREATE DATABASE

-- Step 7: Verify database created
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    | Access privileges
-----------+----------+----------+-------------+-------------+-------------------
 mukuldb   | mukul    | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |

-- Step 8: Connect to new database
postgres=# \c mukuldb
You are now connected to database "mukuldb" as user "postgres".

-- Step 9: Create a table (as example)
mukuldb=# CREATE TABLE students (
mukuldb(#     id SERIAL PRIMARY KEY,
mukuldb(#     name VARCHAR(100),
mukuldb(#     marks INTEGER
mukuldb(# );
CREATE TABLE

-- Step 10: List tables
mukuldb=# \dt
          List of relations
 Schema |   Name   | Type  | Owner
--------+----------+-------+----------
 public | students | table | postgres

-- Step 11: Describe table
mukuldb=# \d students
                                     Table "public.students"
 Column |          Type          | Collation | Nullable |               Default
--------+------------------------+-----------+----------+-------------------------------------
 id     | integer                |           | not null | nextval('students_id_seq'::regclass)
 name   | character varying(100) |           |          |
 marks  | integer                |           |          |
Indexes:
    "students_pkey" PRIMARY KEY, btree (id)

-- Step 12: Exit
mukuldb=# \q
```

---

## PART 6: GUI TOOLS INTEGRATION

---

## 13. Connecting DBeaver to PostgreSQL

### What is DBeaver?

**Definition:** DBeaver is a universal database management tool with graphical interface.

**Features:**

- Visual database browser
- SQL editor with auto-completion
- ER diagram generation
- Data export/import
- Multi-database support

---

### Architecture

```
┌─────────────────────────────────────────────────────┐
│                 DBeaver (GUI Client)                │
│  ┌───────────────────────────────────────────────┐  │
│  │  User Interface (Tables, SQL Editor, etc.)    │  │
│  └────────────────────┬──────────────────────────┘  │
│                       │                             │
│  ┌────────────────────▼──────────────────────────┐  │
│  │          JDBC Driver                          │  │
│  │    org.postgresql.Driver                      │  │
│  └────────────────────┬──────────────────────────┘  │
└───────────────────────┼──────────────────────────────┘
                        │
           jdbc:postgresql://localhost:5432/mukuldb
                        │
         ┌──────────────▼──────────────┐
         │   PostgreSQL Server         │
         │   (Port 5432)               │
         └─────────────────────────────┘
```

---

### JDBC Explained

**JDBC:** Java Database Connectivity

**Purpose:** Standard API for connecting Java applications to databases.

**JDBC URL Format:**

```
jdbc:postgresql://host:port/database
```

**Example:**

```
jdbc:postgresql://localhost:5432/mukuldb
```

**Components:**

- `jdbc:postgresql://`: Protocol
- `localhost`: Hostname (127.0.0.1)
- `5432`: Port number
- `mukuldb`: Database name

---

### DBeaver Connection Steps

#### Step 1: Open DBeaver

Launch DBeaver application.

---

#### Step 2: Create New Connection

**Method 1:** Menu → Database → New Database Connection

**Method 2:** Click "New Database Connection" button (plug icon)

---

#### Step 3: Select PostgreSQL

Select **PostgreSQL** from the list of databases.

Click **Next**.

---

#### Step 4: Configure Connection Settings

**Fill in the following:**

|Field|Value|Explanation|
|---|---|---|
|**Host**|`localhost`|Server location (same machine)|
|**Port**|`5432`|PostgreSQL default port|
|**Database**|`mukuldb`|Your database name|
|**Username**|`mukul`|PostgreSQL role name|
|**Password**|`your_password`|Role password|

**⚠️ Common Mistakes:**

- ✗ Using `postgres` user (works, but not recommended)
- ✗ Leaving database field empty
- ✗ Wrong password
- ✗ Using Linux username instead of PostgreSQL role

---

#### Step 5: Test Connection

Click **Test Connection** button.

**Expected Result:**

```
Connected
PostgreSQL 16.1
```

**If connection fails, see troubleshooting section.**

---

#### Step 6: Download Driver (If Prompted)

If DBeaver doesn't have PostgreSQL driver:

- Click **Download** when prompted
- Wait for driver download to complete
- Test connection again

**Driver Details:**

- **Driver Class:** `org.postgresql.Driver`
- **Default Port:** `5432`
- **URL Template:** `jdbc:postgresql://{host}:{port}/{database}`

---

#### Step 7: Save Connection

Click **Finish**.

Your PostgreSQL database now appears in Database Navigator panel.

---

### DBeaver Interface Overview

```
┌────────────────────────────────────────────────────────┐
│  DBeaver Interface                                     │
│                                                        │
│  ┌──────────────┐  ┌─────────────────────────────┐   │
│  │   Database   │  │     SQL Editor              │   │
│  │   Navigator  │  │                             │   │
│  │              │  │  SELECT * FROM students;    │   │
│  │  ▼ mukuldb   │  │                             │   │
│  │    ├─Schemas │  │  [Execute] [Ctrl+Enter]     │   │
│  │    │ ├public │  └─────────────────────────────┘   │
│  │    │  ├Tables│  ┌─────────────────────────────┐   │
│  │    │  │├students│     Results Grid            │   │
│  │    │  ││└columns│  ┌──────┬────────┬──────┐  │   │
│  │    │  │└indexes│  │  id  │  name  │marks │  │   │
│  │    │  ├Views  │  ├──────┼────────┼──────┤  │   │
│  │    │  └Sequences│ │  1   │ Amit   │  90  │  │   │
│  │    └─Roles    │  │  2   │ Raj    │  86  │  │   │
│  └──────────────┘  └───────────────────────────┘   │
└────────────────────────────────────────────────────────┘
```

---

## 14. pgAdmin (Alternative GUI Tool)

### What is pgAdmin?

**Definition:** Official PostgreSQL administration and development platform.

**Features:**

- Web-based interface
- Database design tools
- Query tool with syntax highlighting
- Server monitoring
- Backup/restore utilities

---

### pgAdmin Installation

**On Arch Linux:**

```bash
sudo pacman -S pgadmin4
```

**On Ubuntu/Debian:**

```bash
sudo apt install pgadmin4
```

---

### pgAdmin Connection Steps

#### Step 1: Launch pgAdmin

```bash
pgadmin4
```

Opens in web browser (default: http://127.0.0.1:5050)

---

#### Step 2: Create Master Password

First launch requires setting master password for pgAdmin.

---

#### Step 3: Add Server

**Right-click "Servers" → Create → Server**

---

#### Step 4: General Tab

- **Name:** `Local PostgreSQL` (friendly name)

---

#### Step 5: Connection Tab

|Field|Value|
|---|---|
|**Host name/address**|`localhost`|
|**Port**|`5432`|
|**Maintenance database**|`postgres`|
|**Username**|`mukul`|
|**Password**|`your_password`|
|**Save password?**|✓ (optional)|

---

#### Step 6: Save and Connect

Click **Save**.

Server appears in left panel, expand to see databases.

---

## PART 7: TROUBLESHOOTING

---

## 15. Common Connection Errors

### Error 1: FATAL: role "username" does not exist

**Error Message:**

```
FATAL: role "mukul" does not exist
```

**Cause:** PostgreSQL role not created.

**Solution:**

```sql
-- Connect as postgres
sudo -u postgres psql

-- Create role
CREATE ROLE mukul WITH LOGIN PASSWORD 'password';

-- Verify
\du
```

---

### Error 2: FATAL: database "username" does not exist

**Error Message:**

```
FATAL: database "mukul" does not exist
```

**Cause:**

- No database specified
- PostgreSQL tries to connect to database with same name as username

**Solution 1: Specify database explicitly**

```bash
psql -U mukul -d postgres
```

**Solution 2: Create database with user's name**

```sql
CREATE DATABASE mukul OWNER mukul;
```

---

### Error 3: Peer authentication failed

**Error Message:**

```
FATAL: Peer authentication failed for user "mukul"
```

**Cause:** `pg_hba.conf` uses `peer` authentication but:

- Username doesn't match system username
- Connecting via TCP/IP (peer only works for Unix socket)

**Solution:** Change authentication method to `md5`

```bash
# Edit pg_hba.conf
sudo nano /var/lib/postgres/data/pg_hba.conf

# Change:
local   all   all   peer

# To:
local   all   all   md5

# Reload PostgreSQL
sudo systemctl reload postgresql
```

---

### Error 4: Connection refused

**Error Message:**

```
could not connect to server: Connection refused
    Is the server running on host "localhost" (127.0.0.1) and accepting
    TCP/IP connections on port 5432?
```

**Possible Causes:**

1. PostgreSQL service not running
2. Listening on wrong port
3. Firewall blocking

**Solutions:**

**Check service status:**

```bash
sudo systemctl status postgresql
```

**Start service if not running:**

```bash
sudo systemctl start postgresql
```

**Check listening ports:**

```bash
sudo ss -tulnp | grep 5432
```

**Expected output:**

```
tcp   LISTEN 0  244  127.0.0.1:5432  0.0.0.0:*  users:(("postgres",pid=1234,fd=6))
```

---

### Error 5: Password authentication failed

**Error Message:**

```
FATAL: password authentication failed for user "mukul"
```

**Causes:**

1. Wrong password
2. User doesn't have LOGIN privilege

**Solutions:**

**Change password:**

```sql
-- As postgres
sudo -u postgres psql

-- Change password
ALTER ROLE mukul WITH PASSWORD 'new_password';
```

**Grant LOGIN privilege:**

```sql
ALTER ROLE mukul WITH LOGIN;
```

---

### Error 6: DBeaver cannot connect

**Symptoms:**

- DBeaver shows "Connection failed"
- CLI (psql) works fine

**Common Causes:**

1. Using `peer` authentication
2. Wrong connection parameters
3. Driver not downloaded

**Debugging Steps:**

**Step 1: Test CLI connection**

```bash
psql -U mukul -d mukuldb -h localhost
```

If this works but DBeaver doesn't:

**Step 2: Check pg_hba.conf**

```bash
sudo cat /var/lib/postgres/data/pg_hba.conf | grep -v "^#" | grep -v "^$"
```

Should have:

```
local   all   all   md5
host    all   all   127.0.0.1/32   md5
```

**Step 3: Verify DBeaver settings**

- Host: `localhost` (not empty)
- Port: `5432`
- Database: `mukuldb` (not empty)
- Username: `mukul` (PostgreSQL role, not Linux user)
- Password: Correct password

---

## PART 8: ADVANCED ROLE MANAGEMENT

---

## 16. Role Attributes and Privileges

### Viewing Role Attributes

**Command:**

```sql
\du
```

**Output:**

```
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 mukul     |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS| {}
```

---

### Role Attributes Explained

|Attribute|Description|SQL Keyword|
|---|---|---|
|**SUPERUSER**|Bypasses all permission checks|`SUPERUSER`|
|**CREATEDB**|Can create databases|`CREATEDB`|
|**CREATEROLE**|Can create other roles|`CREATEROLE`|
|**LOGIN**|Can connect to database|`LOGIN`|
|**REPLICATION**|Can initiate replication|`REPLICATION`|
|**BYPASSRLS**|Bypass row-level security|`BYPASSRLS`|
|**CONNECTION LIMIT**|Max concurrent connections|`CONNECTION LIMIT n`|
|**PASSWORD**|Encrypted password|`PASSWORD 'text'`|
|**VALID UNTIL**|Password expiration|`VALID UNTIL 'timestamp'`|

---

### Modifying Role Attributes

**Syntax:**

```sql
ALTER ROLE role_name WITH option;
```

**Examples:**

**Grant CREATEDB privilege:**

```sql
ALTER ROLE mukul WITH CREATEDB;
```

**Remove CREATEDB privilege:**

```sql
ALTER ROLE mukul WITH NOCREATEDB;
```

**Change password:**

```sql
ALTER ROLE mukul WITH PASSWORD 'new_secure_password';
```

**Set connection limit:**

```sql
ALTER ROLE mukul WITH CONNECTION LIMIT 10;
```

**Set password expiration:**

```sql
ALTER ROLE mukul VALID UNTIL '2025-12-31';
```

**Make superuser:**

```sql
ALTER ROLE mukul WITH SUPERUSER;
```

**Remove superuser:**

```sql
ALTER ROLE mukul WITH NOSUPERUSER;
```

---

### Renaming Role

**Syntax:**

```sql
ALTER ROLE old_name RENAME TO new_name;
```

**Example:**

```sql
ALTER ROLE mukul RENAME TO mukul_admin;
```

---

### Dropping (Deleting) Role

**Syntax:**

```sql
DROP ROLE role_name;
```

**Example:**

```sql
DROP ROLE mukul;
```

**⚠️ Important:**

- Cannot drop role that owns databases or objects
- Must first reassign or drop owned objects

**Reassign ownership before dropping:**

```sql
-- Reassign all objects owned by mukul to postgres
REASSIGN OWNED BY mukul TO postgres;

-- Drop objects owned by mukul
DROP OWNED BY mukul;

-- Now can drop role
DROP ROLE mukul;
```

---

## 17. Database Privileges

### Grant Privileges

**Connect to database:**

```sql
GRANT CONNECT ON DATABASE mukuldb TO mukul;
```

**All privileges on database:**

```sql
GRANT ALL PRIVILEGES ON DATABASE mukuldb TO mukul;
```

**Create schema privilege:**

```sql
GRANT CREATE ON DATABASE mukuldb TO mukul;
```

---

### Table Privileges

**Grant SELECT (read) on table:**

```sql
GRANT SELECT ON students TO mukul;
```

**Grant INSERT, UPDATE, DELETE:**

```sql
GRANT INSERT, UPDATE, DELETE ON students TO mukul;
```

**Grant all privileges on table:**

```sql
GRANT ALL PRIVILEGES ON students TO mukul;
```

**Grant on all tables in schema:**

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mukul;
```

**Grant on future tables:**

```sql
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO mukul;
```

---

### Revoke Privileges

**Revoke SELECT:**

```sql
REVOKE SELECT ON students FROM mukul;
```

**Revoke all privileges:**

```sql
REVOKE ALL PRIVILEGES ON students FROM mukul;
```

---

### Check Privileges

**View table privileges:**

```sql
\dp students
```

**Output:**

```
                              Access privileges
 Schema |   Name   | Type  | Access privileges | Column privileges | Policies
--------+----------+-------+-------------------+-------------------+----------
 public | students | table | postgres=arwdDxt  |                   |
        |          |       | mukul=r           |                   |
```

**Privilege codes:**

- `a`: INSERT
- `r`: SELECT
- `w`: UPDATE
- `d`: DELETE
- `D`: TRUNCATE
- `x`: REFERENCES
- `t`: TRIGGER

---

## PART 9: PRACTICAL EXAMPLES

---

## 18. Complete Setup Example

### Scenario: Setup database for a web application

**Requirements:**

1. Create database: `webapp_db`
2. Create application user: `webapp_user`
3. Create read-only user: `readonly_user`
4. Set appropriate permissions

---

### Step-by-Step Implementation

```sql
-- Step 1: Connect as postgres
sudo -u postgres psql

-- Step 2: Create application user
CREATE ROLE webapp_user WITH LOGIN PASSWORD 'secure_app_password';

-- Step 3: Grant CREATEDB to webapp_user (optional)
ALTER ROLE webapp_user WITH CREATEDB;

-- Step 4: Create database
CREATE DATABASE webapp_db OWNER webapp_user;

-- Step 5: Connect to new database
\c webapp_db

-- Step 6: Create tables (as webapp_user would)
-- Switch to webapp_user
\c webapp_db webapp_user

-- Create example table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 7: Create read-only user
-- Switch back to postgres
\c webapp_db postgres

-- Create readonly role
CREATE ROLE readonly_user WITH LOGIN PASSWORD 'readonly_password';

-- Grant connect privilege
GRANT CONNECT ON DATABASE webapp_db TO readonly_user;

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO readonly_user;

-- Grant SELECT on all existing tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;

-- Grant SELECT on future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO readonly_user;

-- Step 8: Verify setup
\du
\l
\c webapp_db
\dt
\dp
```

---

### Verify Permissions

**Test webapp_user (should work):**

```bash
psql -U webapp_user -d webapp_db -h localhost
```

```sql
-- Insert data
INSERT INTO users (username, email) VALUES ('john', 'john@example.com');
INSERT INTO posts (user_id, title, content) VALUES (1, 'First Post', 'Hello World');

-- Query data
SELECT * FROM users;
SELECT * FROM posts;
```

**Test readonly_user (should only read):**

```bash
psql -U readonly_user -d webapp_db -h localhost
```

```sql
-- This should work
SELECT * FROM users;
SELECT * FROM posts;

-- This should fail
INSERT INTO users (username, email) VALUES ('jane', 'jane@example.com');
-- ERROR: permission denied for table users
```

---

## 19. Backup and Restore

### Backup Database

**Single Database:**

```bash
pg_dump -U webapp_user -d webapp_db > webapp_backup.sql
```

**With password:**

```bash
PGPASSWORD='password' pg_dump -U webapp_user -d webapp_db > webapp_backup.sql
```

**Compressed backup:**

```bash
pg_dump -U webapp_user -d webapp_db | gzip > webapp_backup.sql.gz
```

**Custom format (recommended):**

```bash
pg_dump -U webapp_user -d webapp_db -F c -f webapp_backup.dump
```

---

### Restore Database

**From SQL file:**

```bash
psql -U webapp_user -d webapp_db < webapp_backup.sql
```

**From compressed file:**

```bash
gunzip -c webapp_backup.sql.gz | psql -U webapp_user -d webapp_db
```

**From custom format:**

```bash
pg_restore -U webapp_user -d webapp_db webapp_backup.dump
```

---

### Backup All Databases

**All databases:**

```bash
pg_dumpall -U postgres > all_databases.sql
```

**Only roles and tablespaces:**

```bash
pg_dumpall -U postgres --globals-only > globals.sql
```

---

## PART 10: QUICK REFERENCE

---

## 20. Command Cheat Sheet

### Service Management

```bash
# Start PostgreSQL
sudo systemctl start postgresql

# Stop PostgreSQL
sudo systemctl stop postgresql

# Restart PostgreSQL
sudo systemctl restart postgresql

# Reload configuration
sudo systemctl reload postgresql

# Check status
sudo systemctl status postgresql

# Enable auto-start at boot
sudo systemctl enable postgresql
```

---

### User Management

```sql
-- Create role with login
CREATE ROLE username WITH LOGIN PASSWORD 'password';

-- Create user (same as above)
CREATE USER username WITH PASSWORD 'password';

-- Create superuser
CREATE ROLE admin WITH LOGIN PASSWORD 'password' SUPERUSER;

-- Grant CREATEDB privilege
ALTER ROLE username WITH CREATEDB;

-- Change password
ALTER ROLE username WITH PASSWORD 'new_password';

-- Rename role
ALTER ROLE old_name RENAME TO new_name;

-- Drop role
DROP ROLE username;

-- List all roles
\du
```

---

### Database Management

```sql
-- Create database
CREATE DATABASE dbname;

-- Create database with owner
CREATE DATABASE dbname OWNER username;

-- Create database from template
CREATE DATABASE dbname TEMPLATE template0;

-- Rename database
ALTER DATABASE oldname RENAME TO newname;

-- Change owner
ALTER DATABASE dbname OWNER TO new_owner;

-- Drop database
DROP DATABASE dbname;

-- List all databases
\l

-- Connect to database
\c dbname

-- Show current database
SELECT current_database();
```

---

### Connection Commands

```bash
# Connect as postgres
sudo -u postgres psql

# Connect as specific user
psql -U username -d dbname

# Connect with hostname (TCP/IP)
psql -U username -d dbname -h localhost

# Connect with password prompt
psql -U username -d dbname -h localhost -W

# Connect to specific port
psql -U username -d dbname -p 5432
```

---

### psql Meta-Commands

```sql
-- Quit
\q

-- Help on meta-commands
\?

-- Help on SQL commands
\h

-- List databases
\l

-- List tables
\dt

-- List all relations
\d

-- Describe table
\d tablename

-- List users/roles
\du

-- Connect to database
\c dbname

-- Connection info
\conninfo

-- Execute SQL file
\i filename.sql

-- Toggle timing
\timing

-- Toggle expanded output
\x

-- Show SQL for meta-command
\set ECHO_HIDDEN on
```

---

### Table Operations

```sql
-- Create table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INTEGER,
    email VARCHAR(100) UNIQUE
);

-- Insert data
INSERT INTO students (name, age, email) 
VALUES ('John', 20, 'john@example.com');

-- Select data
SELECT * FROM students;
SELECT name, age FROM students WHERE age > 18;

-- Update data
UPDATE students SET age = 21 WHERE name = 'John';

-- Delete data
DELETE FROM students WHERE id = 1;

-- Drop table
DROP TABLE students;

-- Truncate table (delete all rows)
TRUNCATE TABLE students;
```

---

## 21. Exam-Ready Summary

### Installation Steps (Arch Linux)

```
1. Install PostgreSQL
   → pacman -S postgresql

2. Initialize database cluster
   → sudo -u postgres initdb -D /var/lib/postgres/data

3. Start service
   → sudo systemctl start postgresql

4. Enable auto-start
   → sudo systemctl enable postgresql
```

---

### User and Database Creation

```
1. Switch to postgres user
   → sudo -u postgres psql

2. Create role
   → CREATE ROLE username WITH LOGIN PASSWORD 'password';

3. Create database
   → CREATE DATABASE dbname OWNER username;

4. Grant privileges
   → GRANT ALL PRIVILEGES ON DATABASE dbname TO username;
```

---

### Authentication Configuration

```
1. Edit pg_hba.conf
   → sudo nano /var/lib/postgres/data/pg_hba.conf

2. Change peer to md5
   → local all all md5

3. Reload PostgreSQL
   → sudo systemctl reload postgresql
```

---

### GUI Connection (DBeaver)

```
1. Create new connection → PostgreSQL

2. Configure:
   Host: localhost
   Port: 5432
   Database: dbname
   Username: username
   Password: password

3. Test connection

4. Save and connect
```

---

## 22. One-Line Exam Answer

**Question:** Explain PostgreSQL setup and GUI integration.

**Answer:** PostgreSQL installation requires initializing a data directory using initdb, starting the postgresql service, creating database roles with LOGIN privilege and passwords, creating databases with specific owners, configuring password-based authentication (md5) in pg_hba.conf for GUI tools, and connecting through JDBC-based clients like DBeaver by providing host, port, database, username, and password credentials.

---

## END OF POSTGRESQL SETUP GUIDE

**Topics Covered:** ✓ PostgreSQL architecture and components ✓ Installation on Arch Linux ✓ Database initialization (initdb) ✓ Service management (systemctl) ✓ User vs Role concepts ✓ Creating roles with LOGIN privilege ✓ Creating databases with owners ✓ Authentication methods (peer, md5, scram-sha-256) ✓ pg_hba.conf configuration ✓ Complete psql command reference ✓ DBeaver and pgAdmin integration ✓ JDBC connection concepts ✓ Troubleshooting common errors ✓ Role attributes and privileges ✓ Backup and restore procedures ✓ Practical examples and workflows

**Exam Ready:** Complete theoretical and practical guide for DBMS/System Administration.