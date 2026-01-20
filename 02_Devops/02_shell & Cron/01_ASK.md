---
title: ask, ifelse
tags:
  - DevOps
  - Shell
created:
  "{ date }":
updated:
  "{ date }":
---
## Table of Contents

1. [Understanding OS Architecture](#understanding-os-architecture)
2. [Shell Types & Selection](#shell-types--selection)
3. [Shebang & Script Execution](#shebang--script-execution)
4. [Variables & User Input](#variables--user-input)
5. [Command Arguments](#command-arguments)
6. [System Files Reference](#system-files-reference)

---

## Understanding OS Architecture

### OS Layer Model

```
┌─────────────────────────────────────┐
│        USER (You)                   │
│  Commands: ls, cd, mkdir, ./script  │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│     APPLICATION LAYER               │
│  Programs: Firefox, VSCode, etc     │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│     SHELL (Command Interpreter)     │
│  Types: bash, zsh, fish, sh         │
│  Job: Translate commands to kernel  │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│     KERNEL (OS Core)                │
│  Manages: Memory, CPU, I/O, Files   │
│  Examples: Linux, Windows NT        │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│     HARDWARE                        │
│  CPU, RAM, Disk, Network            │
└─────────────────────────────────────┘
```

### What is a Shell?

**Shell** is a command-line interpreter that:
- Accepts commands from user
- Translates them to kernel calls
- Returns output to user
- Provides scripting capabilities

**Example flow:**

```
You type:    ls -la
             ↓
Shell:       Parses command
             Checks permissions
             Calls kernel syscall
             ↓
Kernel:      Reads directory
             Returns file list
             ↓
Shell:       Formats output
             ↓
Terminal:    Displays files
```

### What is a Kernel?

**Kernel** is the core of OS that:
- Manages hardware resources
- Provides system calls
- Handles process scheduling
- Controls memory management
- Manages file systems

---

## Shell Types & Selection

### Common Shell Types

| Shell | Binary Path | Description | Default On |
|-------|-------------|-------------|------------|
| **bash** | `/bin/bash` | Bourne Again Shell (most common) | Most Linux |
| **sh** | `/bin/sh` | Original Bourne Shell | Old Unix |
| **zsh** | `/bin/zsh` | Z Shell (modern, feature-rich) | macOS |
| **fish** | `/usr/bin/fish` | Friendly Interactive Shell | User install |
| **ksh** | `/bin/ksh` | Korn Shell | AIX, Solaris |
| **tcsh** | `/bin/tcsh` | Enhanced C Shell | BSD |
| **dash** | `/bin/dash` | Debian Almquist Shell (fast) | Debian/Ubuntu |

### Check Your Shell

```bash
# Current shell
echo $SHELL
# Output: /bin/bash

# Available shells
cat /etc/shells
# Output:
# /bin/sh
# /bin/bash
# /usr/bin/zsh
# /usr/bin/fish

# Change default shell
chsh -s /bin/zsh
```

### Shell Feature Comparison

| Feature | bash | zsh | fish | sh |
|---------|------|-----|------|-----|
| Tab completion | Basic | Advanced | Best | None |
| Syntax highlighting | No | Plugin | Built-in | No |
| Command history | Yes | Better | Best | Basic |
| Scripting | Standard | Compatible | Different | Basic |
| Speed | Medium | Medium | Slower | Fastest |
| Learning curve | Easy | Medium | Easy | Easy |

---

## Shebang & Script Execution

### What is Shebang?

**Shebang** (`#!`) tells the system which interpreter to use.

```
Structure:  #!interpreter [optional-arg]
            ││
            │└─ Path to interpreter
            └── Shebang marker
```

### Common Shebangs

| Shebang | Interpreter | Use Case |
|---------|-------------|----------|
| `#!/bin/bash` | Bash shell | Standard Linux scripts |
| `#!/bin/sh` | System shell | POSIX-compatible scripts |
| `#!/usr/bin/env bash` | Bash (portable) | Cross-platform scripts |
| `#!/usr/bin/env python3` | Python 3 | Python scripts |
| `#!/usr/bin/zsh` | Z shell | macOS scripts |
| `#!/usr/bin/fish` | Fish shell | Fish scripts |
| `#!/bin/dash` | Dash | Fast system scripts |

### Why Use `/usr/bin/env`?

**Direct path:**
```bash
#!/bin/bash
# Assumes bash is at /bin/bash
# Fails if bash is at /usr/local/bin/bash
```

**Using env (portable):**
```bash
#!/usr/bin/env bash
# env searches $PATH for bash
# Works across different systems
```

### Creating & Running Scripts

**Method 1: chmod with octal (xxx)**

```bash
# Create script
cat > script.sh << 'EOF'
#!/bin/bash
echo "Hello World"
EOF

# Set permissions (octal)
chmod 755 script.sh
# 7 = rwx (owner)
# 5 = r-x (group)
# 5 = r-x (others)

# Run
./script.sh
```

**Octal permission table:**

| Octal | Binary | Permission | Meaning |
|-------|--------|------------|---------|
| 0 | 000 | `---` | No access |
| 1 | 001 | `--x` | Execute only |
| 2 | 010 | `-w-` | Write only |
| 3 | 011 | `-wx` | Write + Execute |
| 4 | 100 | `r--` | Read only |
| 5 | 101 | `r-x` | Read + Execute |
| 6 | 110 | `rw-` | Read + Write |
| 7 | 111 | `rwx` | Full access |

**Common chmod values:**

```bash
chmod 755 script.sh  # rwxr-xr-x (standard for scripts)
chmod 700 script.sh  # rwx------ (private script)
chmod 644 file.txt   # rw-r--r-- (standard for files)
chmod 600 file.txt   # rw------- (private file)
```

**Method 2: chmod with symbolic (+x)**

```bash
# Create script
cat > script.sh << 'EOF'
#!/bin/bash
echo "Hello World"
EOF

# Add execute permission
chmod +x script.sh

# Run
./script.sh
```

**Symbolic permission syntax:**

| Symbol | Meaning | Example | Result |
|--------|---------|---------|--------|
| `+` | Add permission | `chmod +x file` | Add execute |
| `-` | Remove permission | `chmod -w file` | Remove write |
| `=` | Set exact permission | `chmod =rx file` | Only read+exec |
| `u` | User (owner) | `chmod u+x file` | Owner execute |
| `g` | Group | `chmod g+w file` | Group write |
| `o` | Others | `chmod o-r file` | Remove other read |
| `a` | All | `chmod a+x file` | All execute |

**Examples:**

```bash
chmod u+x file    # Owner can execute
chmod g+w file    # Group can write
chmod o-r file    # Others cannot read
chmod a+x file    # Everyone can execute
chmod ug+rw file  # Owner and group read+write
chmod o= file     # Remove all permissions for others
```

**Comparison: 755 vs +x**

```bash
# chmod 755 (explicit)
chmod 755 script.sh
ls -l script.sh
# -rwxr-xr-x  script.sh

# chmod +x (adds execute to existing)
chmod 644 script.sh  # Start with rw-r--r--
chmod +x script.sh   # Add execute
ls -l script.sh
# -rwxr-xr-x  script.sh

# Difference: +x adds to current, octal sets exact
```

### Running Scripts

**Method 1: Direct execution (requires shebang)**

```bash
chmod +x script.sh
./script.sh
```

**Method 2: Specify interpreter**

```bash
bash script.sh      # No chmod needed
sh script.sh
zsh script.sh
```

**Method 3: Source (run in current shell)**

```bash
source script.sh    # Variables persist
. script.sh         # Same as source
```

---

## Comments & Here Documents

### Single Line Comments

```bash
#!/bin/bash
# This is a comment
echo "Hello"  # Inline comment
```

### Block Comments

**Method 1: Multiple # lines**

```bash
#!/bin/bash
# This is a comment block
# Line 1
# Line 2
# Line 3
echo "After comments"
```

**Method 2: Here document redirect to null**

```bash
#!/bin/bash
<< 'COMMENT'
This is a block comment
Multiple lines
No execution
COMMENT

echo "Script continues"
```

**Method 3: Colon command**

```bash
#!/bin/bash
: '
This is also a block comment
Using colon operator
Multi-line
'
echo "Script continues"
```

### Here Documents (Heredoc)

**Basic heredoc:**

```bash
cat << EOF
Line 1
Line 2
Line 3
EOF
```

**Create file with heredoc:**

```bash
cat > filename.txt << 'EOF'
#!/bin/bash
echo "Hello-mukul"
echo "This is a script"
EOF
```

**Heredoc variations:**

```bash
# With variable expansion
cat << EOF
Username: $USER
Home: $HOME
EOF

# Without variable expansion (quoted delimiter)
cat << 'EOF'
Username: $USER
Home: $HOME
EOF

# Suppress leading tabs (<<-)
cat <<- EOF
	Line with tab
	Another tab
EOF

# Append to file
cat >> file.txt << EOF
New content
EOF
```

---

## Variables & User Input

### Variable Declaration Rules

```bash
# CORRECT
name="mukul"
age=25
path="/home/user"

# WRONG - No spaces around =
name = "mukul"     # Error
age = 25           # Error
```

**Rules:**
1. No spaces around `=`
2. No special characters in name (except `_`)
3. Cannot start with number
4. Case-sensitive

### Using Variables

```bash
#!/bin/bash

# Declare
name="mukul"
age=25

# Use with $
echo "My name is $name"
echo "I am $age years old"

# Use with ${} (safer)
echo "My name is ${name}"
echo "File: ${name}.txt"

# Concatenation
fullname="${name} sharma"
echo $fullname
```

**Variable expansion comparison:**

```bash
# Without braces (can be ambiguous)
name="mukul"
echo "$nameshah"    # Empty (looks for $nameshah)

# With braces (clear)
echo "${name}shah"  # mukulshah
```

### User Input with read

**Basic input:**

```bash
#!/bin/bash

# Simple read
echo "Enter your name:"
read username
echo "Hello, $username"
```

**Read with prompt (-p):**

```bash
#!/bin/bash

# Inline prompt
read -p "Enter your name: " username
echo "Hello, $username"
```

**Multiple inputs:**

```bash
#!/bin/bash

read -p "Enter first number: " num1
read -p "Enter second number: " num2
echo "Sum is $((num1 + num2))"
```

**Read options:**

| Option | Description | Example |
|--------|-------------|---------|
| `-p` | Prompt message | `read -p "Name: " name` |
| `-s` | Silent (for passwords) | `read -s password` |
| `-t` | Timeout in seconds | `read -t 5 answer` |
| `-n` | Read N characters | `read -n 1 char` |
| `-r` | Raw (don't escape \) | `read -r line` |
| `-a` | Store in array | `read -a array` |

**Examples:**

```bash
# Password input (hidden)
read -sp "Enter password: " pass
echo ""  # New line after silent input
echo "Password set"

# Timeout
read -t 5 -p "Quick! Enter something: " answer
if [ -z "$answer" ]; then
    echo "Timeout!"
fi

# Read single character
read -n 1 -p "Press any key to continue..."
echo ""

# Read array
read -p "Enter 3 numbers: " -a numbers
echo "First: ${numbers[0]}"
echo "All: ${numbers[@]}"
```

### Arithmetic Operations

**Using $(( ))**

```bash
#!/bin/bash

read -p "Enter first number: " num1
read -p "Enter second number: " num2

# Arithmetic expansion
echo "Sum: $((num1 + num2))"
echo "Difference: $((num1 - num2))"
echo "Product: $((num1 * num2))"
echo "Division: $((num1 / num2))"
echo "Remainder: $((num1 % num2))"

# With variables
result=$((num1 + num2))
echo "Result stored: $result"
```

**Operators:**

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `$((5 + 3))` = 8 |
| `-` | Subtraction | `$((5 - 3))` = 2 |
| `*` | Multiplication | `$((5 * 3))` = 15 |
| `/` | Division | `$((10 / 3))` = 3 |
| `%` | Modulo | `$((10 % 3))` = 1 |
| `**` | Exponent | `$((2 ** 3))` = 8 |
| `++` | Increment | `$((i++))` |
| `--` | Decrement | `$((i--))` |

---

## Command Arguments

### Argument Variables

| Variable | Meaning | Example |
|----------|---------|---------|
| `$0` | Script name | `./myscript.sh` |
| `$1` | First argument | `arg1` |
| `$2` | Second argument | `arg2` |
| `$3` | Third argument | `arg3` |
| `$#` | Total argument count | `3` |
| `$@` | All args (separate) | `"arg1" "arg2" "arg3"` |
| `$*` | All args (single string) | `"arg1 arg2 arg3"` |
| `$?` | Last command exit status | `0` (success) |
| `$$` | Current process ID | `12345` |
| `$!` | Last background process ID | `12346` |

### Basic Argument Usage

```bash
#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"
```

**Run:**

```bash
chmod +x script.sh
./script.sh hello world
# Output:
# Script name: ./script.sh
# First argument: hello
# Second argument: world
# Total arguments: 2
# All arguments: hello world
```

### Complete Example with Arguments

```bash
#!/bin/bash

# Get command arguments
num1=$1
num2=$2

# If not provided, ask user
if [ -z "$num1" ]; then
    read -p "Enter first number: " num1
fi

if [ -z "$num2" ]; then
    read -p "Enter second number: " num2
fi

# Calculate
echo "Sum is $((num1 + num2))"
echo "Script: $0"
echo "Total args: $#"
echo "All args: $@"
```

**Usage:**

```bash
# With arguments
./script.sh 100 200
# Output:
# Sum is 300
# Script: ./script.sh
# Total args: 2
# All args: 100 200

# Without arguments (interactive)
./script.sh
# Prompts for input
```

### Difference: $@ vs $*

```bash
#!/bin/bash

echo "Using \$@:"
for arg in "$@"; do
    echo "- $arg"
done

echo ""
echo "Using \$*:"
for arg in "$*"; do
    echo "- $arg"
done
```

**Run:**

```bash
./script.sh "arg 1" "arg 2" "arg 3"

# Output with "$@" (separate):
# - arg 1
# - arg 2
# - arg 3

# Output with "$*" (single string):
# - arg 1 arg 2 arg 3
```

### Practical Argument Example

```bash
#!/bin/bash

# Check if username provided
if [ -z "$1" ]; then
    read -p "Enter username for new user: " name
else
    name=$1
fi

# Create user
sudo useradd -m $name

# Verify
echo "New user added: $name"
cat /etc/passwd | grep $name
```

**Usage:**

```bash
# Method 1: With argument
./create_user.sh johnsmith

# Method 2: Interactive
./create_user.sh
# Prompts: Enter username for new user:
```

---

## System Files Reference
etc stores system info inside it 
### /etc/passwd File

**File structure:**

```
username:password:UID:GID:comment:home_dir:shell
```

**Field breakdown:**

| Field | Position | Description | Example |
|-------|----------|-------------|---------|
| Username | 1 | Login name | `mukul` |
| Password | 2 | `x` = in /etc/shadow | `x` |
| UID | 3 | User ID | `1000` |
| GID | 4 | Primary Group ID | `1000` |
| Comment | 5 | Full name/description | `Mukul Sharma` |
| Home Dir | 6 | User home directory | `/home/mukul` |
| Shell | 7 | Login shell | `/bin/bash` |

**Example entries:**

```bash
# Root user
root:x:0:0::/root:/usr/bin/bash

# System user
daemon:x:2:2::/:/usr/bin/nologin

# Regular user
mukul:x:1000:1000::/home/mukul:/bin/bash

# Service account
mysql:x:959:959:MariaDB:/var/lib/mysql:/usr/bin/nologin
```

**Special UIDs:**

| UID Range | Type | Description |
|-----------|------|-------------|
| 0 | Root | Superuser |
| 1-99 | System | Static system users |
| 100-999 | System | Dynamic system users |
| 1000+ | Regular | Normal users |

**Special shells:**

| Shell | Purpose |
|-------|---------|
| `/bin/bash` | Interactive login |
| `/usr/bin/nologin` | Deny login |
| `/bin/false` | Deny login (alt) |
| `/usr/bin/git-shell` | Git-only access |

### Reading /etc/passwd

```bash
# View all users
cat /etc/passwd

# Find specific user
cat /etc/passwd | grep mukul

# Get only usernames
cut -d: -f1 /etc/passwd

# Get users with bash shell
grep "/bin/bash" /etc/passwd

# Count total users
wc -l /etc/passwd
```

### User Management Commands

```bash
# Add user
sudo useradd -m username
# -m = create home directory

# Add user with options
sudo useradd -m -s /bin/bash -c "Full Name" username

# Set password
sudo passwd username

# Delete user
sudo userdel username

# Delete with home dir
sudo userdel -r username

# Modify user
sudo usermod -s /bin/zsh username   # Change shell
sudo usermod -d /new/home username  # Change home

# List user info
id username
finger username
```

---

## Quick Reference

### Script Template

```bash
#!/bin/bash
# Script: script_name.sh
# Description: What it does
# Author: Your Name
# Date: YYYY-MM-DD

# Exit on error
set -e

# Variables
VAR1="value"
VAR2="value"

# Functions
function main() {
    echo "Script starts"
    # Your code here
}

# Main execution
main
```

### Common Patterns

**Check if argument provided:**

```bash
if [ -z "$1" ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi
```

**Loop through arguments:**

```bash
for arg in "$@"; do
    echo "Processing: $arg"
done
```

**Read file line by line:**

```bash
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt
```

**Check if file exists:**

```bash
if [ -f "file.txt" ]; then
    echo "File exists"
fi
```

---

## Summary

**Core concepts:**
1. Shell interprets commands between user and kernel
2. Shebang (`#!/bin/bash`) specifies interpreter
3. `chmod 755` or `chmod +x` makes scripts executable
4. Variables use `$name` or `${name}`
5. User input with `read -p "Prompt: " variable`
6. Arguments: `$1, $2, $#, $@`
7. Arithmetic: `$((expression))`
8. `/etc/passwd` stores user account info