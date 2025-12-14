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

**Summary:**

- You type commands in the **Terminal**
    
- Terminal passes them to the **Shell**
    
- Shell interprets commands (like **Bash**)
    
- Shell communicates with the **OS** to execute programs
    

---

If you want, I can **merge this with your Hyperland / Wayland / Linux stack notes**, so you have **one comprehensive Obsidian DevOps + Linux desktop note**.

Do you want me to do that?