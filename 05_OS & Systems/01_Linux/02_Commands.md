---
title:
  "{ Title }":
tags:
  - OS
  - Linux
created:
  "{ date }":
updated:
  "{ date }":
---

# **Terminal, Shell, and Bash**

## **1. Terminal**

**Definition:**  
A terminal emulator is a program that provides a **window for text input and output**.

**Examples:**

- `gnome-terminal`
    
- `konsole`
    
- `alacritty`
    
- `kitty`
    

**Purpose:**

- Acts as the **interface** you type into
    
- Sends commands to the shell
    
- Displays output from the shell
    

---

## **2. Shell**

**Definition:**  
A shell is a **command-line interpreter** that runs inside the terminal.

**Examples:**

- `bash` (Bourne Again SHell)
    
- `zsh` (Z Shell)
    
- `fish` (Friendly Interactive Shell)
    

**Purpose:**

- Reads the commands you type
    
- Executes programs or scripts
    
- Communicates with the operating system
    

**Key Point:**

- Shell is **software inside the terminal**, not the terminal itself.
    

---

## **3. Bash**

**Definition:**  
Bash is a **specific type of shell**, widely used as default on Linux and macOS.

**Features:**

- Command history
    
- Tab completion
    
- Scripting capabilities
    
- Aliases and functions
    

---

## **4. How They Work Together**

```text
+-----------------+
|  Terminal Window |
|  (gnome-terminal|
|   alacritty)     |
+-----------------+
          │
          │ sends typed commands
          ▼
+-----------------+
|      Shell       |
|  (bash, zsh, etc)|
+-----------------+
          │
          │ executes commands via OS
          ▼
+-----------------+
| Operating System |
|  (Linux Kernel)  |
+-----------------+
```

---

# 🔹 DIRECTORY & FILE NAVIGATION

### `cd`

Change directory

```bash
cd .pws      # go inside .pws directory
cd ..        # go back one level
cd ~         # go to home
cd /etc      # absolute path
```

---

### `ls`

List files

```bash
ls           # normal list
ls -la       # long + hidden files
ls -R        # recursive (all subfolders)
```

Flags:

- `-l` → permissions, owner, size
    
- `-a` → includes hidden files (`.`)
    
- `-R` → recursive
    

---

# 🔹 FILE VIEWING & OUTPUT

### `cat`

Show file content

```bash
cat file.txt
cat file1 file2
```

⚠️ Large files → use `less`

---

### `echo`

Print text or variables

```bash
echo "Hello"
echo $PATH
```

Used for debugging, scripting, env variables.

---

### `whereis`

Find binary, source, man page

```bash
whereis python
```

---

# 🔹 ENVIRONMENT VARIABLES

### `$PATH`

List executable search paths

```bash
echo $PATH
```

If a command is inside PATH → you can run it directly.

---

# 🔹 REDIRECTION & PIPES (VERY IMPORTANT)

### `>` (funnel / redirect)

Overwrite output into file

```bash
echo "Hello" > file.txt
```

### `>>`

Append output

```bash
echo "World" >> file.txt
```

---

### `|` (pipe / tunnel)

Send output of one command to another

```bash
ls | grep ".js"
cat file.txt | wc -l
```

Think of it as:

```
command → command → command
```

---

# 🔹 HELP SYSTEM

### `man`

Manual pages

```bash
man ls
man cp
```

Navigation:

- `/word` → search
    
- `q` → quit
    

---

# 🔹 FILE CREATION

### `touch`

Create empty file or update timestamp

```bash
touch file.txt
```

---

### `mkdir`

Create directory

```bash
mkdir test
mkdir -p a/b/c     # nested directories
```

---

# 🔹 FILE COPYING & MOVING

### `cp`

Copy file

```bash
cp file1.txt file2.txt
```

### `cp -R`

Copy directory

```bash
cp -R folder1 folder2
```

---

### `mv`

Move or rename

```bash
mv old.txt new.txt
mv file.txt /tmp/
```

---

# 🔹 FILE & DIRECTORY DELETION (DANGEROUS)

### `rm`

Remove file

```bash
rm file.txt
```

### `rm -r`

Remove directory recursively

```bash
rm -r folder
```

⚠️ **No recycle bin in Linux**

```bash
rm -rf /
```

☠️ NEVER RUN THIS

---

# 🔹 ALIAS (SHORTCUT COMMANDS)

### User aliases (bash)

```bash
~/.bashrc
```

Example:

```bash
alias ll="ls -la"
```

Apply:

```bash
source ~/.bashrc
```

---

### System-wide aliases

```bash
/etc/bashrc
/etc/zshrc
```

⚠️ Requires sudo

---

# 🔹 COMMAND FLOW MENTAL MODEL

```
User
 ↓
Shell (bash/zsh)
 ↓
PATH lookup
 ↓
Binary (/usr/bin)
 ↓
Output
 ↓
> file  OR  | next command
```

---

# 🔹 QUICK SUMMARY TABLE

|Command|Purpose|
|---|---|
|`cd`|change directory|
|`ls`|list files|
|`ls -la`|detailed list|
|`cat`|read file|
|`echo`|print|
|`whereis`|find binaries|
|`>`|redirect|
|`|`|
|`man`|help|
|`touch`|create file|
|`mkdir`|create dir|
|`cp`|copy|
|`cp -R`|copy folder|
|`mv`|move/rename|
|`rm -r`|delete folder|
|`alias`|shortcut|

---

## 🔥 FINAL ADVICE (IMPORTANT)

You now know **80% of daily Linux usage**.

Next level skills to learn:

- `grep`
    
- `find`
    
- `chmod`, `chown`
    
- `tar`, `zip`
    
- `ps`, `top`, `htop`
    

If you want, I can:

- make **one-page ASCII cheat sheet**
    
- convert this into **Obsidian markdown**
    
- give **practice exercises like a Linux lab**
    

Just say the word 👍