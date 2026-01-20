---
title: condition , loop , fun()
tags:
  - DevOps
  - Shell
created:
  "{ date }":
updated:
  "{ date }":
---
a
## Table of Contents

1. [Conditional Statements](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#conditional-statements)
2. [Loops: For & While](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#loops-for--while)
3. [Functions](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#functions)
4. [Complete Examples](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#complete-examples)

---

## Conditional Statements

### Basic If-Elif-Else

```bash
#!/bin/bash

read -p "Enter Marks: " marks

if [ $marks -ge 90 ]; then
    echo "A+"
elif [ $marks -le 33 ]; then
    echo "F-"
else
    echo "Avg Student"
fi
```

### Test Brackets: [ ] vs [[ ]]

**Single brackets [ ] - POSIX standard**

```bash
if [ $marks -ge 90 ]; then
    echo "A+"
fi

# Must use -eq, -ne, -gt, -lt, -ge, -le
# Variables should be quoted for safety
if [ "$name" = "mukul" ]; then
    echo "Hello"
fi
```

**Double brackets [[ ]] - Bash extended (recommended)**

```bash
# Can use comparison operators directly
if [[ $marks >= 90 ]]; then
    echo "A+"
fi

# String comparison
if [[ $name == "mukul" ]]; then
    echo "Hello"
fi

# Pattern matching
if [[ $file == *.txt ]]; then
    echo "Text file"
fi

# No quotes needed (safer)
if [[ $var == value ]]; then
    echo "Match"
fi
```

### Comparison Operators

**Numeric comparisons:**

|[ ] Syntax|[[ ]] Syntax|Meaning|
|---|---|---|
|`[ $a -eq $b ]`|`[[ $a == $b ]]`|Equal|
|`[ $a -ne $b ]`|`[[ $a != $b ]]`|Not equal|
|`[ $a -gt $b ]`|`[[ $a > $b ]]`|Greater than|
|`[ $a -ge $b ]`|`[[ $a >= $b ]]`|Greater or equal|
|`[ $a -lt $b ]`|`[[ $a < $b ]]`|Less than|
|`[ $a -le $b ]`|`[[ $a <= $b ]]`|Less or equal|

**String comparisons:**

|Operator|Meaning|Example|
|---|---|---|
|`=` or `==`|Equal|`[[ $str == "hello" ]]`|
|`!=`|Not equal|`[[ $str != "bye" ]]`|
|`-z`|Empty string|`[[ -z $str ]]`|
|`-n`|Not empty|`[[ -n $str ]]`|
|`=~`|Regex match|`[[ $email =~ @.+\. ]]`|

**File tests:**

|Test|Meaning|
|---|---|
|`-f file`|File exists and is regular file|
|`-d dir`|Directory exists|
|`-e path`|Path exists|
|`-r file`|File is readable|
|`-w file`|File is writable|
|`-x file`|File is executable|
|`-s file`|File not empty|

### Logical Operators

**With [ ] brackets:**

```bash
# AND
if [ $age -ge 18 ] && [ $age -le 60 ]; then
    echo "Working age"
fi

# OR
if [ $day = "Sat" ] || [ $day = "Sun" ]; then
    echo "Weekend"
fi

# NOT
if [ ! -f file.txt ]; then
    echo "File does not exist"
fi
```

**With [[ ]] brackets:**

```bash
# AND
if [[ $age -ge 18 && $age -le 60 ]]; then
    echo "Working age"
fi

# OR
if [[ $day == "Sat" || $day == "Sun" ]]; then
    echo "Weekend"
fi

# NOT
if [[ ! -f file.txt ]]; then
    echo "File does not exist"
fi
```

### Complete Grade Example

```bash
#!/bin/bash

read -p "Enter your marks: " marks

# Validate input
if [[ ! $marks =~ ^[0-9]+$ ]]; then
    echo "Error: Enter valid number"
    exit 1
fi

# Check range
if [[ $marks -lt 0 || $marks -gt 100 ]]; then
    echo "Error: Marks must be 0-100"
    exit 1
fi

# Grade calculation
if [[ $marks -ge 90 ]]; then
    echo "Grade: A+"
elif [[ $marks -ge 80 ]]; then
    echo "Grade: A"
elif [[ $marks -ge 70 ]]; then
    echo "Grade: B"
elif [[ $marks -ge 60 ]]; then
    echo "Grade: C"
elif [[ $marks -ge 50 ]]; then
    echo "Grade: D"
elif [[ $marks -ge 33 ]]; then
    echo "Grade: E (Pass)"
else
    echo "Grade: F- (Fail)"
fi
```

---

## Loops: For & While

### For Loop (C-style)

**Basic syntax:**

```bash
for (( initialization; condition; increment )); do
    # commands
done
```

**Simple example:**

```bash
#!/bin/bash

for (( i=1; i<=5; i++ )); do
    echo "Number: $i"
done

# Output:
# Number: 1
# Number: 2
# Number: 3
# Number: 4
# Number: 5
```

### For Loop: Create Directories

**Your handwritten code (translated):**

```bash
#!/bin/bash
# 1 = folder name prefix
# 2 = start range
# 3 = end range

for (( num=2; num<=3; num++ )); do
    mkdir "$1num"
done
```

**Corrected version:**

```bash
cat > for_loop.sh << 'EOF'
#!/bin/bash
# Arguments:
# $1 = prefix (folder name)
# $2 = start number
# $3 = end number

for (( num=$2; num<=$3; num++ )); do
    mkdir "${1}num${num}"
done
EOF

chmod +x for_loop.sh
```

**Key corrections explained:**

```
Issue 1: Variable expansion
--------
Wrong:  mkdir "$1num"
Right:  mkdir "${1}num${num}"

Why: $1num looks for variable "$1num" (doesn't exist)
     ${1} separates the first argument clearly


Issue 2: Hardcoded values
--------
Wrong:  for (( num=2; num<=3; num++ ))
Right:  for (( num=$2; num<=$3; num++ ))

Why: Should use script arguments $2 and $3
     Makes it flexible for any range


Issue 3: Folder naming
--------
Created: folder2, folder3
Better:  daynum2, daynum3

Why: Uses both prefix ($1) and number ($num)
```

**Usage examples:**

```bash
# Create day folders
./for_loop.sh day 1 5
# Creates: daynum1 daynum2 daynum3 daynum4 daynum5

# Create week folders
./for_loop.sh week 10 12
# Creates: weeknum10 weeknum11 weeknum12

# Create lab folders
./for_loop.sh lab 1 100
# Creates: labnum1 labnum2 ... labnum100
```

**Your logic was 100% correct!**

```
C-style for loop structure:
for (( init; condition; increment ))

Your handwriting matched bash syntax perfectly!
```

### While Loop Version

```bash
cat > while_loop.sh << 'EOF'
#!/bin/bash
# Arguments:
# $1 = prefix
# $2 = start
# $3 = end

num=$2                      # Initialize with start value

while [ $num -le $3 ]; do   # Loop until end value
    mkdir "${1}num${num}"
    ((num++))               # Increment
done
EOF

chmod +x while_loop.sh
./while_loop.sh day 2 3
# Creates: daynum2  daynum3
```

**While loop structure:**

```
Initialization:  num=$2
                 ↓
Condition:       while [ $num -le $3 ]; do
                 ↓
Action:          mkdir "${1}num${num}"
                 ↓
Increment:       ((num++))
                 ↓
                 (loop back to condition)
```

**Same usage as for loop:**

```bash
./while_loop.sh day 1 5
# daynum1 to daynum5

./while_loop.sh week 10 12
# weeknum10 to weeknum12

./while_loop.sh lab 1 100
# labnum1 to labnum100
```

### For vs While Comparison

|Loop Type|Syntax|Best For|
|---|---|---|
|**for**|`for ((num=$2; num<=$3; num++))`|Fixed iterations, counters|
|**while**|`while [ $num -le $3 ]; do`|Variable conditions, unknown iterations|

**When to use for:**

```bash
# Known iterations
for (( i=1; i<=10; i++ )); do
    echo $i
done

# Array iteration
arr=(apple banana cherry)
for item in "${arr[@]}"; do
    echo $item
done

# File iteration
for file in *.txt; do
    echo "Processing: $file"
done
```

**When to use while:**

```bash
# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# User input loop
while true; do
    read -p "Continue? (y/n): " ans
    [[ $ans == "n" ]] && break
done

# Condition-based
count=0
while [ $count -lt 100 ]; do
    echo $count
    ((count += 10))
done
```

### Loop Control

**break - Exit loop:**

```bash
for (( i=1; i<=10; i++ )); do
    if [[ $i -eq 5 ]]; then
        break  # Exit loop at 5
    fi
    echo $i
done
# Output: 1 2 3 4
```

**continue - Skip iteration:**

```bash
for (( i=1; i<=10; i++ )); do
    if [[ $i -eq 5 ]]; then
        continue  # Skip 5
    fi
    echo $i
done
# Output: 1 2 3 4 6 7 8 9 10
```

---

## Functions

### Basic Function Syntax

```bash
# Method 1: function keyword
function name() {
    # commands
}

# Method 2: Without function keyword (preferred)
name() {
    # commands
}
```

### Function Arguments

Functions use same argument variables as scripts:

|Variable|Meaning|
|---|---|
|`$1`|First argument|
|`$2`|Second argument|
|`$#`|Argument count|
|`$@`|All arguments|

### Simple Function Example

```bash
#!/bin/bash

# Define function
greet() {
    echo "Hello, $1!"
}

# Call function
greet "Mukul"
greet "World"

# Output:
# Hello, Mukul!
# Hello, World!
```

### Function with Return Value

**Your add_number function:**

```bash
#!/bin/bash

read -p "First num: " one
read -p "Second num: " two

add_number() {
    sum=$(( $1 + $2 ))
    echo "$sum"           # Output to capture
    return $sum           # Exit status (0-255 only)
}

ans=$(add_number $one $two)
echo "$ans"
```

**Important: return vs echo**

```bash
# return: Sets exit status ($?)
# - Only accepts 0-255
# - Used for success/failure
# - NOT for returning values

# echo: Prints to stdout
# - Can output any value
# - Captured with $()
# - Used for returning data
```

**Corrected version:**

```bash
#!/bin/bash

read -p "First num: " one
read -p "Second num: " two

add_number() {
    local sum=$(( $1 + $2 ))
    echo "$sum"
}

# Capture output
result=$(add_number $one $two)
echo "Sum is: $result"

# Check exit status
add_number $one $two > /dev/null
if [[ $? -eq 0 ]]; then
    echo "Function succeeded"
fi
```

### Function Best Practices

**Use local variables:**

```bash
calculate() {
    local num1=$1
    local num2=$2
    local result=$(( num1 + num2 ))
    echo $result
}
```

**Return success/failure:**

```bash
check_file() {
    if [[ -f $1 ]]; then
        echo "File exists"
        return 0  # Success
    else
        echo "File not found"
        return 1  # Failure
    fi
}

check_file "data.txt"
if [[ $? -eq 0 ]]; then
    echo "Check passed"
fi
```

### Complete Calculator Function

```bash
#!/bin/bash

calculator() {
    local num1=$1
    local op=$2
    local num2=$3
    local result
    
    case $op in
        +) result=$(( num1 + num2 )) ;;
        -) result=$(( num1 - num2 )) ;;
        \*) result=$(( num1 * num2 )) ;;
        /) result=$(( num1 / num2 )) ;;
        %) result=$(( num1 % num2 )) ;;
        *)
            echo "Error: Invalid operator"
            return 1
            ;;
    esac
    
    echo $result
    return 0
}

# Usage
read -p "Enter first number: " n1
read -p "Enter operator (+,-,*,/,%): " op
read -p "Enter second number: " n2

answer=$(calculator $n1 $op $n2)
echo "Result: $answer"
```

---

## Complete Examples

### Example 1: Directory Creator with Validation

```bash
#!/bin/bash

create_dirs() {
    local prefix=$1
    local start=$2
    local end=$3
    
    # Validate arguments
    if [[ $# -ne 3 ]]; then
        echo "Usage: $0 <prefix> <start> <end>"
        return 1
    fi
    
    # Validate numbers
    if [[ ! $start =~ ^[0-9]+$ ]] || [[ ! $end =~ ^[0-9]+$ ]]; then
        echo "Error: Start and end must be numbers"
        return 1
    fi
    
    # Check range
    if [[ $start -gt $end ]]; then
        echo "Error: Start must be <= end"
        return 1
    fi
    
    # Create directories
    for (( num=start; num<=end; num++ )); do
        local dirname="${prefix}${num}"
        mkdir -p "$dirname"
        echo "Created: $dirname"
    done
    
    return 0
}

# Main
create_dirs "$1" "$2" "$3"
```

### Example 2: User Management Script

```bash
#!/bin/bash

add_user() {
    local username=$1
    
    # Check if user exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists"
        return 1
    fi
    
    # Create user
    sudo useradd -m "$username"
    
    if [[ $? -eq 0 ]]; then
        echo "User $username created successfully"
        sudo passwd "$username"
        return 0
    else
        echo "Failed to create user"
        return 1
    fi
}

# Main
if [[ -z $1 ]]; then
    read -p "Enter username: " name
else
    name=$1
fi

add_user "$name"
```

### Example 3: Grade Calculator with Menu

```bash
#!/bin/bash

calculate_grade() {
    local marks=$1
    
    if [[ $marks -ge 90 ]]; then
        echo "A+"
    elif [[ $marks -ge 80 ]]; then
        echo "A"
    elif [[ $marks -ge 70 ]]; then
        echo "B"
    elif [[ $marks -ge 60 ]]; then
        echo "C"
    elif [[ $marks -ge 50 ]]; then
        echo "D"
    elif [[ $marks -ge 33 ]]; then
        echo "E"
    else
        echo "F-"
    fi
}

# Main loop
while true; do
    echo ""
    echo "=== Grade Calculator ==="
    echo "1. Calculate grade"
    echo "2. Exit"
    read -p "Choose option: " choice
    
    case $choice in
        1)
            read -p "Enter marks (0-100): " marks
            
            # Validate
            if [[ ! $marks =~ ^[0-9]+$ ]]; then
                echo "Error: Invalid input"
                continue
            fi
            
            if [[ $marks -lt 0 || $marks -gt 100 ]]; then
                echo "Error: Marks must be 0-100"
                continue
            fi
            
            grade=$(calculate_grade $marks)
            echo "Grade: $grade"
            ;;
        2)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
```

### Example 4: Batch File Renamer

```bash
#!/bin/bash

rename_files() {
    local old_ext=$1
    local new_ext=$2
    local count=0
    
    for file in *."$old_ext"; do
        if [[ -f $file ]]; then
            local newname="${file%.*}.$new_ext"
            mv "$file" "$newname"
            echo "Renamed: $file → $newname"
            ((count++))
        fi
    done
    
    echo "Total files renamed: $count"
}

# Usage
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <old_extension> <new_extension>"
    echo "Example: $0 txt md"
    exit 1
fi

rename_files "$1" "$2"
```

---

## Quick Reference

### Conditional Flow

```bash
if [[ condition ]]; then
    # commands
elif [[ condition ]]; then
    # commands
else
    # commands
fi
```

### For Loop

```bash
for (( i=start; i<=end; i++ )); do
    # commands
done

for item in "${array[@]}"; do
    # commands
done
```

### While Loop

```bash
while [[ condition ]]; do
    # commands
done
```

### Function

```bash
function_name() {
    local var=$1
    echo "result"
    return 0
}

result=$(function_name arg)
```

---

## Summary

**Key Points:**

1. Use `[[ ]]` over `[ ]` in Bash (safer, more features)
2. For loops: Fixed iterations with counters
3. While loops: Condition-based, unknown iterations
4. Functions: Use `echo` for values, `return` for status
5. Always use `local` in functions
6. Validate inputs before processing
7. Use `${var}` for clear variable expansion