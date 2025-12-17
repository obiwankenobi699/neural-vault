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
## FOUNDATIONAL CONCEPTS

### The Unix Philosophy
Linux commands follow the Unix philosophy: "Do one thing and do it well." Commands are designed to be composable, meaning they can be combined using pipes and redirection to create powerful workflows.

### Command Structure
```
command [options] [arguments]
```
- **Command**: The program to execute
- **Options**: Modify command behavior (usually prefixed with - or --)
- **Arguments**: What the command operates on (files, directories, text)

### Memory Aid: Command Categories
Think of Linux commands in functional groups:
- **Navigation**: Where am I? Where can I go? (cd, pwd, ls)
- **Manipulation**: Create, move, copy, delete (touch, mkdir, cp, mv, rm)
- **Inspection**: What's inside? (cat, less, head, tail)
- **Search**: Find what I need (find, grep, locate)
- **Control**: Manage running programs (ps, kill, top)
- **Network**: Connect to the world (ping, curl, wget)

---

## NAVIGATION & DIRECTORY OPERATIONS

### Core Concepts
The Linux filesystem is hierarchical, starting from root (/). Every file and directory has an absolute path from root and a relative path from your current location.

**Memory Aid**: Think of the filesystem as a tree. You're always standing on one branch (current directory). You can climb up to parent branches (..), jump to the trunk (root /), or return home (~).

### Navigation Commands

| Command | Full Form | Description | Example | Memory Aid |
|---|---|---|---|---|
| `cd <directory>` | Change Directory | Change current directory | `cd /var/log` | "CD" = Change Direction |
| `cd ..` | - | Go up one level | `cd ..` | ".." = Parent directory (two dots = go back) |
| `cd ~` | - | Go to home directory | `cd ~` | "~" looks like a house roof |
| `cd -` | - | Go to previous directory | `cd -` | "-" = minus = go backward |
| `pwd` | Print Working Directory | Show current directory path | `pwd` | "Where am I?" |

### Listing Commands

| Command | Options Breakdown | Description | Example | Use Case |
|---|---|---|---|---|
| `ls` | - | List directory contents | `ls` | Quick view |
| `ls -l` | Long format | Detailed listing (permissions, size, date) | `ls -l` | See file metadata |
| `ls -a` | All files | Include hidden files (starting with .) | `ls -a` | Find configuration files |
| `ls -la` | Long + All | Detailed view with hidden files | `ls -la` | Complete directory audit |
| `ls -lh` | Long + Human-readable | File sizes in KB, MB, GB | `ls -lh` | Understand storage usage |
| `ls -R` | Recursive | List subdirectories recursively | `ls -R` | See entire tree structure |
| `ls -lt` | Long + Time sorted | Sort by modification time (newest first) | `ls -lt` | Find recent changes |
| `ls -lS` | Long + Size sorted | Sort by file size (largest first) | `ls -lS` | Find large files |

**Memory Aid for ls options**:
- **l** = Long (detailed)
- **a** = All (including hidden)
- **h** = Human-readable sizes
- **R** = Recursive (go deep)
- **t** = Time sorted
- **S** = Size sorted

---

## FILE VIEWING & CONTENT OPERATIONS

### Core Concept
Different tools for different viewing needs: quick peek (cat), paginated reading (less/more), partial viewing (head/tail), or live monitoring (tail -f).

**Mental Model**: Think of viewing commands as different reading speeds:
- **cat**: Speed reader (dump everything)
- **less/more**: Normal reader (page by page)
- **head/tail**: Skimmer (first/last parts only)
- **tail -f**: Live news ticker (real-time updates)

| Command | Full Form | Description | Example | When to Use | Memory Aid |
|---|---|---|---|---|---|
| `cat <file>` | Concatenate | Display entire file content | `cat file.txt` | Small files, quick view | Cat knocks everything off the table at once |
| `cat <file1> <file2>` | - | Combine and display multiple files | `cat file1.txt file2.txt` | Merge file contents | Concatenate = chain together |
| `tac <file>` | Cat reversed | Display file in reverse order | `tac file.txt` | View logs bottom-up | "tac" is "cat" backwards |
| `less <file>` | - | View file with pagination (forward/backward) | `less large_file.txt` | Large files, search capability | "Less is more" - better than more |
| `more <file>` | - | View file page by page (forward only) | `more file.txt` | Simple pagination | Shows "more" as you progress |
| `head <file>` | - | Show first 10 lines | `head file.txt` | Preview file beginning | Head = top of body |
| `head -n 20 <file>` | Number of lines | Show first N lines | `head -n 20 file.txt` | Custom preview size | -n = number |
| `tail <file>` | - | Show last 10 lines | `tail file.txt` | Check recent entries | Tail = end of body |
| `tail -n 20 <file>` | Number of lines | Show last N lines | `tail -n 20 file.txt` | Custom recent view | -n = number |
| `tail -f <file>` | Follow | Monitor file in real-time | `tail -f /var/log/syslog` | Watch log files live | Follow = track continuously |
| `tail -F <file>` | Follow + Retry | Follow even if file rotates | `tail -F app.log` | Production log monitoring | -F = robust follow |

### Text Analysis Commands

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `wc -l <file>` | Count lines | `wc -l file.txt` | Get file length | wc = word count, -l = lines |
| `wc -w <file>` | Count words | `wc -w file.txt` | Analyze text size | -w = words |
| `wc -c <file>` | Count bytes | `wc -c file.txt` | File size in bytes | -c = characters/bytes |
| `wc <file>` | Show all counts | `wc file.txt` | Complete statistics | Shows lines, words, bytes |

**Professional Tip**: Use `less` for large files because it doesn't load the entire file into memory. Use `tail -f` for real-time log monitoring during troubleshooting.

---

## FILE & DIRECTORY CREATION

### Core Concept
Creating structure in the filesystem. Think of `touch` for files and `mkdir` for directories (containers for files).

| Command | Description | Example | Options Explained | Memory Aid |
|---|---|---|---|---|
| `touch <file>` | Create empty file or update timestamp | `touch newfile.txt` | Creates if doesn't exist, updates timestamp if exists | "Touch" something to show it exists |
| `touch <file1> <file2> <file3>` | Create multiple files | `touch a.txt b.txt c.txt` | Space-separated list | Batch creation |
| `mkdir <directory>` | Make directory | `mkdir project` | Single directory | "Make dir" |
| `mkdir -p <path>` | Create parent directories if needed | `mkdir -p dir1/dir2/dir3` | -p = parents (no error if exists) | "Parents" - create family tree |
| `mkdir -m 755 <directory>` | Create with specific permissions | `mkdir -m 755 secure_dir` | -m = mode | Set permissions at creation |

**Interview Insight**: `mkdir -p` is idempotent (safe to run multiple times) and won't error if directories exist. This makes it ideal for scripts.

---

## FILE & DIRECTORY OPERATIONS

### Core Concept: The Three Basic Operations
- **Copy (cp)**: Duplicate - original remains
- **Move (mv)**: Relocate or rename - original is gone
- **Remove (rm)**: Delete - permanent action

**Mental Model**: Think of physical objects:
- **Archive (tar)**: Packing items into a box (still takes same space)
- **Compress (gzip)**: Vacuum-sealing the box (reduces space)
- **tar.gz**: Packing into a box, then vacuum-sealing it

### Copy Operations

| Command | Description | Example | Critical Options | Memory Aid |
|---|---|---|---|---|
| `cp <source> <dest>` | Copy file | `cp file1.txt file2.txt` | Destination can be new name or directory | "Copy paste" |
| `cp -r <source> <dest>` | Copy directory recursively | `cp -r folder1 folder2` | -r = recursive (needed for directories) | "Recursive" = go into subfolders |
| `cp -i <source> <dest>` | Interactive copy (prompt before overwrite) | `cp -i file1.txt file2.txt` | -i = interactive (safe mode) | "i" = interactive confirmation |
| `cp -u <source> <dest>` | Copy only if source is newer | `cp -u file1.txt file2.txt` | -u = update | "u" = update only |
| `cp -v <source> <dest>` | Verbose output | `cp -v file1.txt file2.txt` | -v = verbose | "v" = visual confirmation |
| `cp -p <source> <dest>` | Preserve attributes (permissions, timestamps) | `cp -p file1.txt file2.txt` | -p = preserve | "p" = preserve metadata |

### Move/Rename Operations

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `mv <source> <dest>` | Move or rename file | `mv old.txt new.txt` | Same directory = rename, different = move | "Move" does both |
| `mv <file> <directory>` | Move file to directory | `mv file.txt /tmp/` | Target must be directory | Move into container |
| `mv -i <source> <dest>` | Interactive move | `mv -i file1.txt file2.txt` | -i = prompt before overwrite | Safe move |
| `mv -u <source> <dest>` | Move only if source is newer | `mv -u file1.txt file2.txt` | -u = update | Update only |
| `mv -n <source> <dest>` | No overwrite | `mv -n file1.txt file2.txt` | -n = no clobber | "n" = never overwrite |

### Removal Operations

| Command | Description | Example | Danger Level | Memory Aid |
|---|---|---|---|---|
| `rm <file>` | Remove file | `rm file.txt` | Medium - file deleted | "Remove" |
| `rm -r <directory>` | Remove directory recursively | `rm -r folder` | High - directory tree deleted | "r" = recursive |
| `rm -rf <directory>` | Force remove without prompt | `rm -rf folder` | EXTREME - no confirmation | "rf" = recursive force (dangerous) |
| `rm -i <file>` | Interactive removal | `rm -i file.txt` | Low - asks confirmation | "i" = interactive (safe) |
| `rm -I <file1> <file2> <file3>` | Prompt once for 3+ files | `rm -I *.txt` | Medium - single prompt for bulk | "I" = intelligent prompt |
| `rmdir <directory>` | Remove empty directory only | `rmdir empty_folder` | Low - fails if not empty | Safe directory removal |

**Critical Interview Points**:
1. `rm` has no recycle bin - deletions are permanent
2. `rm -rf /` is catastrophic - deletes entire system
3. Always use `-i` flag when removing important data
4. `mv` is atomic within the same filesystem (safe for databases)
5. `cp` without `-p` loses original permissions and timestamps

---

## SEARCH & FIND OPERATIONS

### Core Concept: Two Search Paradigms
- **find**: Searches filesystem structure (filenames, types, sizes, dates)
- **grep**: Searches file content (text patterns inside files)

**Mental Model**: 
- **find** = Library catalog (searches by title, author, location)
- **grep** = Reading the book (searches actual content)

### Find Command - Filesystem Search

**Basic Syntax**: `find <where> <what> <action>`

| Command | Description | Example | Pattern Explanation | Memory Aid |
|---|---|---|---|---|
| `find <path>` | List all files/directories | `find .` | No criteria = show everything | Starting point |
| `find <path> -name <pattern>` | Find by exact name | `find . -name "*.txt"` | Case-sensitive, use quotes for wildcards | "name" = exact match |
| `find <path> -iname <pattern>` | Find by name (case-insensitive) | `find . -iname "*.TXT"` | -i = ignore case | "i" = case-insensitive |
| `find <path> -type f` | Find only files | `find /home -type f` | f = file | "f" = file |
| `find <path> -type d` | Find only directories | `find /home -type d` | d = directory | "d" = directory |
| `find <path> -type l` | Find only symbolic links | `find /etc -type l` | l = link | "l" = link |
| `find <path> -size +100M` | Find files larger than 100MB | `find / -size +100M` | + = greater than, - = less than | Size threshold |
| `find <path> -mtime -7` | Modified in last 7 days | `find . -mtime -7` | -7 = within 7 days, +7 = older than | "mtime" = modification time |
| `find <path> -user <username>` | Find by owner | `find /home -user john` | Ownership search | User filter |
| `find <path> -perm 644` | Find by exact permissions | `find . -perm 644` | Exact permission match | Permission filter |
| `find <path> -empty` | Find empty files/directories | `find . -empty` | Zero size or no contents | Empty filter |

### Find with Actions

| Command | Description | Example | Use Case |
|---|---|---|---|
| `find . -name "*.txt" -delete` | Find and delete | `find . -name "*.log" -delete` | Clean up files |
| `find . -name "*.txt" -exec rm {} \;` | Find and execute command (one by one) | `find . -name "*.tmp" -exec rm {} \;` | Individual processing |
| `find . -name "*.txt" -exec rm {} +` | Find and execute command (batch) | `find . -name "*.log" -exec rm {} +` | Efficient batch operation |
| `find . -type f -exec chmod 644 {} +` | Find files and change permissions | `find . -type f -exec chmod 644 {} +` | Permission correction |
| `find . -name "*.txt" -print` | Find and print (default action) | `find . -name "*.txt" -print` | Explicit listing |

**Exec Syntax Explanation**:
- `{}` = placeholder for found file
- `\;` = execute command for each file individually
- `+` = pass all files as arguments (faster, preferred)

### Grep Command - Content Search

**Basic Syntax**: `grep <pattern> <file>`

**Full Form**: **G**lobal **R**egular **E**xpression **P**rint

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `grep <pattern> <file>` | Search for pattern in file | `grep "error" log.txt` | Find specific text | Basic search |
| `grep -i <pattern> <file>` | Case-insensitive search | `grep -i "error" log.txt` | Flexible matching | "i" = ignore case |
| `grep -v <pattern> <file>` | Invert match (exclude pattern) | `grep -v "debug" log.txt` | Filter out noise | "v" = invert |
| `grep -n <pattern> <file>` | Show line numbers | `grep -n "error" log.txt` | Locate in file | "n" = number |
| `grep -c <pattern> <file>` | Count matching lines | `grep -c "error" log.txt` | Get statistics | "c" = count |
| `grep -r <pattern> <directory>` | Recursive search in directory | `grep -r "TODO" .` | Search entire project | "r" = recursive |
| `grep -l <pattern> <files>` | List filenames only | `grep -l "error" *.log` | Find which files | "l" = list names |
| `grep -A 3 <pattern> <file>` | Show 3 lines After match | `grep -A 3 "error" log.txt` | Context after | "A" = After |
| `grep -B 3 <pattern> <file>` | Show 3 lines Before match | `grep -B 3 "error" log.txt` | Context before | "B" = Before |
| `grep -C 3 <pattern> <file>` | Show 3 lines Context (before & after) | `grep -C 3 "error" log.txt` | Full context | "C" = Context |
| `grep -w <pattern> <file>` | Match whole words only | `grep -w "test" file.txt` | Avoid partial matches | "w" = word boundary |
| `grep -E <pattern> <file>` | Extended regex (ERE) | `grep -E "error\|warning" log.txt` | Complex patterns | "E" = Extended |
| `grep -o <pattern> <file>` | Show only matched part | `grep -o "[0-9]+" file.txt` | Extract specific data | "o" = only match |

### Location Commands

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `which <command>` | Show command executable path | `which python` | Find binary location | "Which path?" |
| `whereis <command>` | Show binary, source, and manual paths | `whereis python` | Complete program info | "Where is it?" |
| `locate <pattern>` | Fast filename search (uses database) | `locate config.txt` | Quick file finding | Database search |
| `updatedb` | Update locate database | `sudo updatedb` | Refresh file index | Update before locate |
| `type <command>` | Show command type (alias, builtin, file) | `type ls` | Identify command nature | Command type |

**Professional Interview Points**:
1. `find` is slower but real-time; `locate` is faster but uses cached database
2. `grep -r` searches content recursively; `find -name` searches filenames
3. Combine: `find . -name "*.log" -exec grep "error" {} +` (find logs, search content)
4. Use `grep -E` for multiple patterns: `grep -E "error|warning|critical" log.txt`
5. `which` only shows executables in PATH; `whereis` shows more locations

---

## PERMISSIONS & OWNERSHIP

### Core Concept: The Linux Security Model

Every file has three permission levels and three permission types:

**Permission Levels** (Who):
- **u** (User/Owner): The file's owner
- **g** (Group): Users in the file's group
- **o** (Others): Everyone else
- **a** (All): Everyone (u+g+o)

**Permission Types** (What):
- **r** (Read): View file contents or list directory (value: 4)
- **w** (Write): Modify file or add/remove files in directory (value: 2)
- **x** (Execute): Run file as program or enter directory (value: 1)

**Mental Model**: Think of a house:
- **Owner**: Homeowner (full control)
- **Group**: Family members (shared access)
- **Others**: Visitors (limited access)

### Understanding Permission Notation

**Symbolic**: `rwxr-xr--` (9 characters)
- First 3: Owner permissions (rwx)
- Next 3: Group permissions (r-x)
- Last 3: Others permissions (r--)

**Numeric**: `754` (3 digits)
- First digit: Owner (7 = 4+2+1 = rwx)
- Second digit: Group (5 = 4+1 = r-x)
- Third digit: Others (4 = r--)

### Chmod - Change Permissions

**Two modes: Symbolic and Numeric**

#### Symbolic Mode

| Command | Description | Example | Explanation | Memory Aid |
|---|---|---|---|---|
| `chmod u+x <file>` | Add execute for user | `chmod u+x script.sh` | u=user, +=add, x=execute | Make script runnable |
| `chmod g+w <file>` | Add write for group | `chmod g+w file.txt` | g=group, +=add, w=write | Group can edit |
| `chmod o-r <file>` | Remove read for others | `chmod o-r private.txt` | o=others, -=remove, r=read | Hide from others |
| `chmod a+r <file>` | Add read for all | `chmod a+r public.txt` | a=all (ugo) | Everyone can read |
| `chmod u=rwx <file>` | Set user to rwx exactly | `chmod u=rwx script.sh` | = sets exactly | Precise control |
| `chmod go-rwx <file>` | Remove all from group & others | `chmod go-rwx secret.txt` | g+o combined | Private file |
| `chmod +x <file>` | Add execute for all | `chmod +x script.sh` | No target = all | Quick executable |

#### Numeric Mode

| Command | Numeric | Symbolic | Description | Common Use |
|---|---|---|---|---|
| `chmod 777 <file>` | 777 | rwxrwxrwx | Full access for everyone | Testing only (insecure) |
| `chmod 755 <file>` | 755 | rwxr-xr-x | Owner: all, Others: read+execute | Scripts, executables |
| `chmod 644 <file>` | 644 | rw-r--r-- | Owner: read+write, Others: read | Standard files |
| `chmod 600 <file>` | 600 | rw------- | Owner: read+write only | Private files (SSH keys) |
| `chmod 700 <file>` | 700 | rwx------ | Owner: all, Others: none | Private directories |
| `chmod 666 <file>` | 666 | rw-rw-rw- | All can read+write | Shared writable files |
| `chmod 400 <file>` | 400 | r-------- | Read-only for owner | Protected config files |

**Recursive Permission Change**:
```
chmod -R 755 <directory>  # Apply to directory and all contents
```

### Chown - Change Ownership

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `chown <user> <file>` | Change owner | `chown john file.txt` | Transfer ownership | "Change owner" |
| `chown <user>:<group> <file>` | Change owner and group | `chown john:developers file.txt` | Full ownership change | user:group syntax |
| `chown :<group> <file>` | Change group only | `chown :developers file.txt` | Group reassignment | Shorthand for group |
| `chown -R <user> <directory>` | Recursive ownership change | `chown -R john folder/` | Change directory tree | -R = recursive |
| `chown --reference=<ref> <file>` | Match reference file ownership | `chown --reference=file1 file2` | Copy ownership | Reference template |

### Chgrp - Change Group

| Command | Description | Example | Use Case |
|---|---|---|---|
| `chgrp <group> <file>` | Change file group | `chgrp developers file.txt` | Group reassignment |
| `chgrp -R <group> <directory>` | Recursive group change | `chgrp -R staff folder/` | Change directory tree |

### Special Permissions

| Permission | Numeric | Symbol | Description | Example |
|---|---|---|---|---|
| **SUID** (Set User ID) | 4000 | s (user x position) | Execute as file owner | `chmod 4755 program` (runs as owner) |
| **SGID** (Set Group ID) | 2000 | s (group x position) | Execute as file group / New files inherit directory group | `chmod 2755 shared_dir` |
| **Sticky Bit** | 1000 | t (others x position) | Only owner can delete files (for directories) | `chmod 1777 /tmp` (public but protected) |

**Example**: `/tmp` directory typically has `1777` (sticky bit + full access)
- Everyone can create files
- Only file owner can delete their own files
- Prevents users from deleting others' files

### File Attribute Commands

| Command | Description | Example | Use Case |
|---|---|---|---|
| `umask` | Show default permission mask | `umask` | Check default settings |
| `umask 022` | Set default permission mask | `umask 022` | New files: 644, directories: 755 |
| `lsattr <file>` | List file attributes | `lsattr file.txt` | Check extended attributes |
| `chattr +i <file>` | Make file immutable (cannot be modified/deleted) | `chattr +i critical.conf` | Protect important files |
| `chattr -i <file>` | Remove immutable attribute | `chattr -i critical.conf` | Allow modifications |

**Professional Interview Points**:
1. **644** is standard for files (owner writes, all read)
2. **755** is standard for directories and executables (owner modifies, all execute/access)
3. **SUID on executables** allows normal users to run with elevated privileges (e.g., passwd command)
4. **Sticky bit on /tmp** prevents users from deleting others' temporary files
5. **Never use 777** in production - it's a security vulnerability
6. **SSH private keys must be 600** or 400 (owner-only access)
7. **umask 022** means new files get 644 (666-022) and directories get 755 (777-022)

---

## REDIRECTION & PIPES

### Core Concept: Data Flow Control

Linux treats everything as a stream of data. Understanding these three streams is fundamental:

**Standard Streams**:
- **stdin (0)**: Standard input (keyboard by default)
- **stdout (1)**: Standard output (screen by default)
- **stderr (2)**: Standard error (screen by default)

**Mental Model**: Think of water flowing through pipes:
- **Redirection** (>, >>, <): Change where water comes from or goes to
- **Pipes** (|): Connect pipes so water flows from one to another
- **Filters**: Commands that transform the water as it flows

### Redirection Operators

| Operator | Description | Example | Effect | Memory Aid |
|---|---|---|---|---|
| `>` | Redirect stdout (overwrite) | `echo "text" > file.txt` | Replace file content | ">" points to file |
| `>>` | Redirect stdout (append) | `echo "text" >> file.txt` | Add to end of file | ">>" = add more |
| `<` | Redirect stdin from file | `sort < unsorted.txt` | Read from file instead of keyboard | "<" points from file |
| `2>` | Redirect stderr (overwrite) | `command 2> errors.txt` | Save errors to file | "2" = stderr stream |
| `2>>` | Redirect stderr (append) | `command 2>> errors.txt` | Append errors to file | Accumulate errors |
| `&>` | Redirect both stdout and stderr | `command &> output.txt` | Capture all output | "&" = both streams |
| `2>&1` | Redirect stderr to stdout | `command > file.txt 2>&1` | Merge error into output | "2 goes to 1" |
| `1>&2` | Redirect stdout to stderr | `echo "error" 1>&2` | Send output to error stream | Reverse direction |
| `<< EOF` | Here document (multi-line input) | `cat << EOF` | Multi-line input until EOF | Heredoc |
| `<<< "text"` | Here string (single line input) | `grep "pattern" <<< "text"` | Quick string input | Herestring |
| `/dev/null` | Discard output | `command > /dev/null 2>&1` | Suppress all output | Black hole device |

**Common Redirection Patterns**:

```bash
# Discard all output (both stdout and stderr)
command > /dev/null 2>&1

# Save output, discard errors
command 2> /dev/null > output.txt

# Save output and errors to different files
command > output.txt 2> errors.txt

# Append output, overwrite errors
command >> output.txt 2> errors.txt
```

### Pipe Operations

| Command Pattern | Description | Example | Use Case |
|---|---|---|---|
| `cmd1 | cmd2` | Send cmd1 output to cmd2 input | `ls | grep ".txt"` | Filter results |
| `cmd1 | cmd2 | cmd3` | Chain multiple commands | `cat file.txt | grep "error" | wc -l` | Multi-stage processing |
| `cmd1 | tee file.txt` | View and save simultaneously | `ls | tee output.txt` | Monitor and log |
| `cmd1 | tee -a file.txt` | View and append simultaneously | `date | tee -a log.txt` | Continuous logging |
| `cmd1 | xargs cmd2` | Convert stdout to arguments | `find . -name "*.txt" | xargs rm` | Bulk operations |

### Practical Pipe Combinations

| Command Chain | Purpose | Explanation |
|---|---|---|
| `ps aux | grep "process"` | Find specific process | List processes, filter by name |
| `cat file.txt | sort | uniq` | Remove duplicates | Sort first (uniq needs sorted input) |
| `history | grep "command"` | Search command history | Find previously used commands |
| `ls -l | awk '{print $9}'` | Extract filenames | Parse ls output, get 9th column |
| `du -sh * | sort -h` | Sort directories by size | Human-readable, size-sorted |
| `cat file.txt | tr 'a-z' 'A-Z'` | Convert to uppercase | Transform characters |
| `curl url | jq '.field'` | Parse JSON from API | Fetch and extract JSON data |
| `tail -f log.txt | grep "ERROR"` | Live error monitoring | Real-time filtered logs |

### Advanced Redirection Techniques

| Technique | Command | Use Case |
|---|---|---|
| **Redirect stdout and stderr separately** | `cmd >stdout.txt 2>stderr.txt` | Separate outputs for analysis |
| **Append stdout, overwrite stderr** | `cmd >>stdout.txt 2>stderr.txt` | Cumulative output, fresh errors |
| **Swap stdout and stderr** | `cmd 3>&1 1>&2 2>&3` | Reverse output streams |
| **Close file descriptor** | `cmd 2>&-` | Close stderr |
| **Duplicate file descriptor** | `exec 3>&1` | Create backup of stdout |

**Professional Interview Points**:
1. `2>&1` must come AFTER `> file.txt` to work correctly: `command > file.txt 2>&1`
2. Pipes create subshells - variables set in pipes don't persist: `echo "test" | read var` won't work
3. `tee` is essential for debugging pipelines - it lets you see intermediate results
4. `/dev/null` is a special file that discards all data written to it (commonly used to suppress output)
5. Pipelines execute all commands concurrently (not sequentially) - they process streams in real-time
6. `xargs` is necessary when command expects arguments, not stdin: `find` output needs `xargs rm`
7. Order matters in redirection: `2>&1 > file` is different from `> file 2>&1`

---

## ENVIRONMENT & VARIABLES

### Core Concept: Shell Environment

The shell maintains variables that control its behavior and provide information. Two types exist:

**Types of Variables**:
- **Local Variables**: Exist only in current shell (not inherited by child processes)
- **Environment Variables**: Exported to child processes (inherited)

**Mental Model**: Think of variables as labels on containers:
- Local variables: Post-it notes visible only in your room
- Environment variables: Name tags that travel with you everywhere

### Variable Operations

| Command | Description | Example | Scope | Memory Aid |
|---|---|---|---|---|
| `VAR=value` | Create local variable | `NAME="John"` | Current shell only | Simple assignment |
| `export VAR=value` | Create environment variable | `export PATH="/usr/bin"` | Current + child shells | "Export" = send out |
| `export VAR` | Convert local to environment | `export NAME` | Promote existing variable | Export after creation |
| `echo $VAR` | Print variable value | `echo $PATH` | Read variable | "$" accesses value |
| `echo ${VAR}` | Print variable (explicit) | `echo ${PATH}` | Unambiguous reference | Braces for clarity |
| `unset VAR` | Delete variable | `unset NAME` | Remove completely | "Unset" = erase |
| `readonly VAR=value` | Create read-only variable | `readonly API_KEY="secret"` | Immutable | Cannot change |

### Viewing Environment

| Command | Description | Example | Output | Use Case |
|---|---|---|---|---|
| `env` | Show all environment variables | `env` | Full environment | List all exported vars |
| `printenv` | Display environment variables | `printenv` | Same as env | Alternative to env |
| `printenv VAR` | Display specific variable | `printenv PATH` | Single variable value | Check one variable |
| `set` | Show all variables (local + environment) | `set` | Complete variable list | Debug shell state |
| `declare -p` | Show all variables with attributes | `declare -p` | Detailed information | Advanced inspection |
| `echo $VARIABLE` | Print specific variable | `echo $HOME` | Variable value | Quick check |

### Important Environment Variables

| Variable | Purpose | Example Value | Usage |
|---|---|---|---|
| `$PATH` | Command search directories | `/usr/bin:/bin:/usr/local/bin` | Where shell finds commands |
| `$HOME` | User home directory | `/home/username` | User's personal space |
| `$USER` | Current username | `john` | Who is logged in |
| `$SHELL` | Current shell path | `/bin/bash` | Which shell is running |
| `$PWD` | Present working directory | `/home/john/projects` | Current location |
| `$OLDPWD` | Previous working directory | `/var/log` | Last directory visited |
| `$HOSTNAME` | System hostname | `server01` | Machine identifier |
| `$LANG` | Language/locale setting | `en_US.UTF-8` | Language preferences |
| `$TERM` | Terminal type | `xterm-256color` | Terminal capabilities |
| `$EDITOR` | Default text editor | `/usr/bin/vim` | Which editor to use |
| `$PS1` | Primary shell prompt | `[\u@\h \W]\# Comprehensive Linux Command Reference & Conceptual Guide

## FOUNDATIONAL CONCEPTS

### The Unix Philosophy
Linux commands follow the Unix philosophy: "Do one thing and do it well." Commands are designed to be composable, meaning they can be combined using pipes and redirection to create powerful workflows.

### Command Structure
```
command [options] [arguments]
```
- **Command**: The program to execute
- **Options**: Modify command behavior (usually prefixed with - or --)
- **Arguments**: What the command operates on (files, directories, text)

### Memory Aid: Command Categories
Think of Linux commands in functional groups:
- **Navigation**: Where am I? Where can I go? (cd, pwd, ls)
- **Manipulation**: Create, move, copy, delete (touch, mkdir, cp, mv, rm)
- **Inspection**: What's inside? (cat, less, head, tail)
- **Search**: Find what I need (find, grep, locate)
- **Control**: Manage running programs (ps, kill, top)
- **Network**: Connect to the world (ping, curl, wget)

---

## NAVIGATION & DIRECTORY OPERATIONS

### Core Concepts
The Linux filesystem is hierarchical, starting from root (/). Every file and directory has an absolute path from root and a relative path from your current location.

**Memory Aid**: Think of the filesystem as a tree. You're always standing on one branch (current directory). You can climb up to parent branches (..), jump to the trunk (root /), or return home (~).

### Navigation Commands

| Command | Full Form | Description | Example | Memory Aid |
|---|---|---|---|---|
| `cd <directory>` | Change Directory | Change current directory | `cd /var/log` | "CD" = Change Direction |
| `cd ..` | - | Go up one level | `cd ..` | ".." = Parent directory (two dots = go back) |
| `cd ~` | - | Go to home directory | `cd ~` | "~" looks like a house roof |
| `cd -` | - | Go to previous directory | `cd -` | "-" = minus = go backward |
| `pwd` | Print Working Directory | Show current directory path | `pwd` | "Where am I?" |

### Listing Commands

| Command | Options Breakdown | Description | Example | Use Case |
|---|---|---|---|---|
| `ls` | - | List directory contents | `ls` | Quick view |
| `ls -l` | Long format | Detailed listing (permissions, size, date) | `ls -l` | See file metadata |
| `ls -a` | All files | Include hidden files (starting with .) | `ls -a` | Find configuration files |
| `ls -la` | Long + All | Detailed view with hidden files | `ls -la` | Complete directory audit |
| `ls -lh` | Long + Human-readable | File sizes in KB, MB, GB | `ls -lh` | Understand storage usage |
| `ls -R` | Recursive | List subdirectories recursively | `ls -R` | See entire tree structure |
| `ls -lt` | Long + Time sorted | Sort by modification time (newest first) | `ls -lt` | Find recent changes |
| `ls -lS` | Long + Size sorted | Sort by file size (largest first) | `ls -lS` | Find large files |

**Memory Aid for ls options**:
- **l** = Long (detailed)
- **a** = All (including hidden)
- **h** = Human-readable sizes
- **R** = Recursive (go deep)
- **t** = Time sorted
- **S** = Size sorted

---

## FILE VIEWING & CONTENT OPERATIONS

### Core Concept
Different tools for different viewing needs: quick peek (cat), paginated reading (less/more), partial viewing (head/tail), or live monitoring (tail -f).

**Mental Model**: Think of viewing commands as different reading speeds:
- **cat**: Speed reader (dump everything)
- **less/more**: Normal reader (page by page)
- **head/tail**: Skimmer (first/last parts only)
- **tail -f**: Live news ticker (real-time updates)

| Command | Full Form | Description | Example | When to Use | Memory Aid |
|---|---|---|---|---|---|
| `cat <file>` | Concatenate | Display entire file content | `cat file.txt` | Small files, quick view | Cat knocks everything off the table at once |
| `cat <file1> <file2>` | - | Combine and display multiple files | `cat file1.txt file2.txt` | Merge file contents | Concatenate = chain together |
| `tac <file>` | Cat reversed | Display file in reverse order | `tac file.txt` | View logs bottom-up | "tac" is "cat" backwards |
| `less <file>` | - | View file with pagination (forward/backward) | `less large_file.txt` | Large files, search capability | "Less is more" - better than more |
| `more <file>` | - | View file page by page (forward only) | `more file.txt` | Simple pagination | Shows "more" as you progress |
| `head <file>` | - | Show first 10 lines | `head file.txt` | Preview file beginning | Head = top of body |
| `head -n 20 <file>` | Number of lines | Show first N lines | `head -n 20 file.txt` | Custom preview size | -n = number |
| `tail <file>` | - | Show last 10 lines | `tail file.txt` | Check recent entries | Tail = end of body |
| `tail -n 20 <file>` | Number of lines | Show last N lines | `tail -n 20 file.txt` | Custom recent view | -n = number |
| `tail -f <file>` | Follow | Monitor file in real-time | `tail -f /var/log/syslog` | Watch log files live | Follow = track continuously |
| `tail -F <file>` | Follow + Retry | Follow even if file rotates | `tail -F app.log` | Production log monitoring | -F = robust follow |

### Text Analysis Commands

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `wc -l <file>` | Count lines | `wc -l file.txt` | Get file length | wc = word count, -l = lines |
| `wc -w <file>` | Count words | `wc -w file.txt` | Analyze text size | -w = words |
| `wc -c <file>` | Count bytes | `wc -c file.txt` | File size in bytes | -c = characters/bytes |
| `wc <file>` | Show all counts | `wc file.txt` | Complete statistics | Shows lines, words, bytes |

**Professional Tip**: Use `less` for large files because it doesn't load the entire file into memory. Use `tail -f` for real-time log monitoring during troubleshooting.

---

## FILE & DIRECTORY CREATION

### Core Concept
Creating structure in the filesystem. Think of `touch` for files and `mkdir` for directories (containers for files).

| Command | Description | Example | Options Explained | Memory Aid |
|---|---|---|---|---|
| `touch <file>` | Create empty file or update timestamp | `touch newfile.txt` | Creates if doesn't exist, updates timestamp if exists | "Touch" something to show it exists |
| `touch <file1> <file2> <file3>` | Create multiple files | `touch a.txt b.txt c.txt` | Space-separated list | Batch creation |
| `mkdir <directory>` | Make directory | `mkdir project` | Single directory | "Make dir" |
| `mkdir -p <path>` | Create parent directories if needed | `mkdir -p dir1/dir2/dir3` | -p = parents (no error if exists) | "Parents" - create family tree |
| `mkdir -m 755 <directory>` | Create with specific permissions | `mkdir -m 755 secure_dir` | -m = mode | Set permissions at creation |

**Interview Insight**: `mkdir -p` is idempotent (safe to run multiple times) and won't error if directories exist. This makes it ideal for scripts.

---

## FILE & DIRECTORY OPERATIONS

### Core Concept: The Three Basic Operations
- **Copy (cp)**: Duplicate - original remains
- **Move (mv)**: Relocate or rename - original is gone
- **Remove (rm)**: Delete - permanent action

**Mental Model**: Think of physical objects:
- **Archive (tar)**: Packing items into a box (still takes same space)
- **Compress (gzip)**: Vacuum-sealing the box (reduces space)
- **tar.gz**: Packing into a box, then vacuum-sealing it

### Copy Operations

| Command | Description | Example | Critical Options | Memory Aid |
|---|---|---|---|---|
| `cp <source> <dest>` | Copy file | `cp file1.txt file2.txt` | Destination can be new name or directory | "Copy paste" |
| `cp -r <source> <dest>` | Copy directory recursively | `cp -r folder1 folder2` | -r = recursive (needed for directories) | "Recursive" = go into subfolders |
| `cp -i <source> <dest>` | Interactive copy (prompt before overwrite) | `cp -i file1.txt file2.txt` | -i = interactive (safe mode) | "i" = interactive confirmation |
| `cp -u <source> <dest>` | Copy only if source is newer | `cp -u file1.txt file2.txt` | -u = update | "u" = update only |
| `cp -v <source> <dest>` | Verbose output | `cp -v file1.txt file2.txt` | -v = verbose | "v" = visual confirmation |
| `cp -p <source> <dest>` | Preserve attributes (permissions, timestamps) | `cp -p file1.txt file2.txt` | -p = preserve | "p" = preserve metadata |

### Move/Rename Operations

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `mv <source> <dest>` | Move or rename file | `mv old.txt new.txt` | Same directory = rename, different = move | "Move" does both |
| `mv <file> <directory>` | Move file to directory | `mv file.txt /tmp/` | Target must be directory | Move into container |
| `mv -i <source> <dest>` | Interactive move | `mv -i file1.txt file2.txt` | -i = prompt before overwrite | Safe move |
| `mv -u <source> <dest>` | Move only if source is newer | `mv -u file1.txt file2.txt` | -u = update | Update only |
| `mv -n <source> <dest>` | No overwrite | `mv -n file1.txt file2.txt` | -n = no clobber | "n" = never overwrite |

### Removal Operations

| Command | Description | Example | Danger Level | Memory Aid |
|---|---|---|---|---|
| `rm <file>` | Remove file | `rm file.txt` | Medium - file deleted | "Remove" |
| `rm -r <directory>` | Remove directory recursively | `rm -r folder` | High - directory tree deleted | "r" = recursive |
| `rm -rf <directory>` | Force remove without prompt | `rm -rf folder` | EXTREME - no confirmation | "rf" = recursive force (dangerous) |
| `rm -i <file>` | Interactive removal | `rm -i file.txt` | Low - asks confirmation | "i" = interactive (safe) |
| `rm -I <file1> <file2> <file3>` | Prompt once for 3+ files | `rm -I *.txt` | Medium - single prompt for bulk | "I" = intelligent prompt |
| `rmdir <directory>` | Remove empty directory only | `rmdir empty_folder` | Low - fails if not empty | Safe directory removal |

**Critical Interview Points**:
1. `rm` has no recycle bin - deletions are permanent
2. `rm -rf /` is catastrophic - deletes entire system
3. Always use `-i` flag when removing important data
4. `mv` is atomic within the same filesystem (safe for databases)
5. `cp` without `-p` loses original permissions and timestamps

---

## SEARCH & FIND OPERATIONS

### Core Concept: Two Search Paradigms
- **find**: Searches filesystem structure (filenames, types, sizes, dates)
- **grep**: Searches file content (text patterns inside files)

**Mental Model**: 
- **find** = Library catalog (searches by title, author, location)
- **grep** = Reading the book (searches actual content)

### Find Command - Filesystem Search

**Basic Syntax**: `find <where> <what> <action>`

| Command | Description | Example | Pattern Explanation | Memory Aid |
|---|---|---|---|---|
| `find <path>` | List all files/directories | `find .` | No criteria = show everything | Starting point |
| `find <path> -name <pattern>` | Find by exact name | `find . -name "*.txt"` | Case-sensitive, use quotes for wildcards | "name" = exact match |
| `find <path> -iname <pattern>` | Find by name (case-insensitive) | `find . -iname "*.TXT"` | -i = ignore case | "i" = case-insensitive |
| `find <path> -type f` | Find only files | `find /home -type f` | f = file | "f" = file |
| `find <path> -type d` | Find only directories | `find /home -type d` | d = directory | "d" = directory |
| `find <path> -type l` | Find only symbolic links | `find /etc -type l` | l = link | "l" = link |
| `find <path> -size +100M` | Find files larger than 100MB | `find / -size +100M` | + = greater than, - = less than | Size threshold |
| `find <path> -mtime -7` | Modified in last 7 days | `find . -mtime -7` | -7 = within 7 days, +7 = older than | "mtime" = modification time |
| `find <path> -user <username>` | Find by owner | `find /home -user john` | Ownership search | User filter |
| `find <path> -perm 644` | Find by exact permissions | `find . -perm 644` | Exact permission match | Permission filter |
| `find <path> -empty` | Find empty files/directories | `find . -empty` | Zero size or no contents | Empty filter |

### Find with Actions

| Command | Description | Example | Use Case |
|---|---|---|---|
| `find . -name "*.txt" -delete` | Find and delete | `find . -name "*.log" -delete` | Clean up files |
| `find . -name "*.txt" -exec rm {} \;` | Find and execute command (one by one) | `find . -name "*.tmp" -exec rm {} \;` | Individual processing |
| `find . -name "*.txt" -exec rm {} +` | Find and execute command (batch) | `find . -name "*.log" -exec rm {} +` | Efficient batch operation |
| `find . -type f -exec chmod 644 {} +` | Find files and change permissions | `find . -type f -exec chmod 644 {} +` | Permission correction |
| `find . -name "*.txt" -print` | Find and print (default action) | `find . -name "*.txt" -print` | Explicit listing |

**Exec Syntax Explanation**:
- `{}` = placeholder for found file
- `\;` = execute command for each file individually
- `+` = pass all files as arguments (faster, preferred)

### Grep Command - Content Search

**Basic Syntax**: `grep <pattern> <file>`

**Full Form**: **G**lobal **R**egular **E**xpression **P**rint

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `grep <pattern> <file>` | Search for pattern in file | `grep "error" log.txt` | Find specific text | Basic search |
| `grep -i <pattern> <file>` | Case-insensitive search | `grep -i "error" log.txt` | Flexible matching | "i" = ignore case |
| `grep -v <pattern> <file>` | Invert match (exclude pattern) | `grep -v "debug" log.txt` | Filter out noise | "v" = invert |
| `grep -n <pattern> <file>` | Show line numbers | `grep -n "error" log.txt` | Locate in file | "n" = number |
| `grep -c <pattern> <file>` | Count matching lines | `grep -c "error" log.txt` | Get statistics | "c" = count |
| `grep -r <pattern> <directory>` | Recursive search in directory | `grep -r "TODO" .` | Search entire project | "r" = recursive |
| `grep -l <pattern> <files>` | List filenames only | `grep -l "error" *.log` | Find which files | "l" = list names |
| `grep -A 3 <pattern> <file>` | Show 3 lines After match | `grep -A 3 "error" log.txt` | Context after | "A" = After |
| `grep -B 3 <pattern> <file>` | Show 3 lines Before match | `grep -B 3 "error" log.txt` | Context before | "B" = Before |
| `grep -C 3 <pattern> <file>` | Show 3 lines Context (before & after) | `grep -C 3 "error" log.txt` | Full context | "C" = Context |
| `grep -w <pattern> <file>` | Match whole words only | `grep -w "test" file.txt` | Avoid partial matches | "w" = word boundary |
| `grep -E <pattern> <file>` | Extended regex (ERE) | `grep -E "error\|warning" log.txt` | Complex patterns | "E" = Extended |
| `grep -o <pattern> <file>` | Show only matched part | `grep -o "[0-9]+" file.txt` | Extract specific data | "o" = only match |

### Location Commands

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `which <command>` | Show command executable path | `which python` | Find binary location | "Which path?" |
| `whereis <command>` | Show binary, source, and manual paths | `whereis python` | Complete program info | "Where is it?" |
| `locate <pattern>` | Fast filename search (uses database) | `locate config.txt` | Quick file finding | Database search |
| `updatedb` | Update locate database | `sudo updatedb` | Refresh file index | Update before locate |
| `type <command>` | Show command type (alias, builtin, file) | `type ls` | Identify command nature | Command type |

**Professional Interview Points**:
1. `find` is slower but real-time; `locate` is faster but uses cached database
2. `grep -r` searches content recursively; `find -name` searches filenames
3. Combine: `find . -name "*.log" -exec grep "error" {} +` (find logs, search content)
4. Use `grep -E` for multiple patterns: `grep -E "error|warning|critical" log.txt`
5. `which` only shows executables in PATH; `whereis` shows more locations

---

## PERMISSIONS & OWNERSHIP

### Core Concept: The Linux Security Model

Every file has three permission levels and three permission types:

**Permission Levels** (Who):
- **u** (User/Owner): The file's owner
- **g** (Group): Users in the file's group
- **o** (Others): Everyone else
- **a** (All): Everyone (u+g+o)

**Permission Types** (What):
- **r** (Read): View file contents or list directory (value: 4)
- **w** (Write): Modify file or add/remove files in directory (value: 2)
- **x** (Execute): Run file as program or enter directory (value: 1)

**Mental Model**: Think of a house:
- **Owner**: Homeowner (full control)
- **Group**: Family members (shared access)
- **Others**: Visitors (limited access)

### Understanding Permission Notation

**Symbolic**: `rwxr-xr--` (9 characters)
- First 3: Owner permissions (rwx)
- Next 3: Group permissions (r-x)
- Last 3: Others permissions (r--)

**Numeric**: `754` (3 digits)
- First digit: Owner (7 = 4+2+1 = rwx)
- Second digit: Group (5 = 4+1 = r-x)
- Third digit: Others (4 = r--)

### Chmod - Change Permissions

**Two modes: Symbolic and Numeric**

#### Symbolic Mode

| Command | Description | Example | Explanation | Memory Aid |
|---|---|---|---|---|
| `chmod u+x <file>` | Add execute for user | `chmod u+x script.sh` | u=user, +=add, x=execute | Make script runnable |
| `chmod g+w <file>` | Add write for group | `chmod g+w file.txt` | g=group, +=add, w=write | Group can edit |
| `chmod o-r <file>` | Remove read for others | `chmod o-r private.txt` | o=others, -=remove, r=read | Hide from others |
| `chmod a+r <file>` | Add read for all | `chmod a+r public.txt` | a=all (ugo) | Everyone can read |
| `chmod u=rwx <file>` | Set user to rwx exactly | `chmod u=rwx script.sh` | = sets exactly | Precise control |
| `chmod go-rwx <file>` | Remove all from group & others | `chmod go-rwx secret.txt` | g+o combined | Private file |
| `chmod +x <file>` | Add execute for all | `chmod +x script.sh` | No target = all | Quick executable |

#### Numeric Mode

| Command | Numeric | Symbolic | Description | Common Use |
|---|---|---|---|---|
| `chmod 777 <file>` | 777 | rwxrwxrwx | Full access for everyone | Testing only (insecure) |
| `chmod 755 <file>` | 755 | rwxr-xr-x | Owner: all, Others: read+execute | Scripts, executables |
| `chmod 644 <file>` | 644 | rw-r--r-- | Owner: read+write, Others: read | Standard files |
| `chmod 600 <file>` | 600 | rw------- | Owner: read+write only | Private files (SSH keys) |
| `chmod 700 <file>` | 700 | rwx------ | Owner: all, Others: none | Private directories |
| `chmod 666 <file>` | 666 | rw-rw-rw- | All can read+write | Shared writable files |
| `chmod 400 <file>` | 400 | r-------- | Read-only for owner | Protected config files |

**Recursive Permission Change**:
```
chmod -R 755 <directory>  # Apply to directory and all contents
```

### Chown - Change Ownership

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `chown <user> <file>` | Change owner | `chown john file.txt` | Transfer ownership | "Change owner" |
| `chown <user>:<group> <file>` | Change owner and group | `chown john:developers file.txt` | Full ownership change | user:group syntax |
| `chown :<group> <file>` | Change group only | `chown :developers file.txt` | Group reassignment | Shorthand for group |
| `chown -R <user> <directory>` | Recursive ownership change | `chown -R john folder/` | Change directory tree | -R = recursive |
| `chown --reference=<ref> <file>` | Match reference file ownership | `chown --reference=file1 file2` | Copy ownership | Reference template |

### Chgrp - Change Group

| Command | Description | Example | Use Case |
|---|---|---|---|
| `chgrp <group> <file>` | Change file group | `chgrp developers file.txt` | Group reassignment |
| `chgrp -R <group> <directory>` | Recursive group change | `chgrp -R staff folder/` | Change directory tree |

### Special Permissions

| Permission | Numeric | Symbol | Description | Example |
|---|---|---|---|---|
| **SUID** (Set User ID) | 4000 | s (user x position) | Execute as file owner | `chmod 4755 program` (runs as owner) |
| **SGID** (Set Group ID) | 2000 | s (group x position) | Execute as file group / New files inherit directory group | `chmod 2755 shared_dir` |
| **Sticky Bit** | 1000 | t (others x position) | Only owner can delete files (for directories) | `chmod 1777 /tmp` (public but protected) |

**Example**: `/tmp` directory typically has `1777` (sticky bit + full access)
- Everyone can create files
- Only file owner can delete their own files
- Prevents users from deleting others' files

### File Attribute Commands

| Command | Description | Example | Use Case |
|---|---|---|---|
| `umask` | Show default permission mask | `umask` | Check default settings |
| `umask 022` | Set default permission mask | `umask 022` | New files: 644, directories: 755 |
| `lsattr <file>` | List file attributes | `lsattr file.txt` | Check extended attributes |
| `chattr +i <file>` | Make file immutable (cannot be modified/deleted) | `chattr +i critical.conf` | Protect important files |
| `chattr -i <file>` | Remove immutable attribute | `chattr -i critical.conf` | Allow modifications |

**Professional Interview Points**:
1. **644** is standard for files (owner writes, all read)
2. **755** is standard for directories and executables (owner modifies, all execute/access)
3. **SUID on executables** allows normal users to run with elevated privileges (e.g., passwd command)
4. **Sticky bit on /tmp** prevents users from deleting others' temporary files
5. **Never use 777** in production - it's a security vulnerability
6. **SSH private keys must be 600** or 400 (owner-only access)
7. **umask 022** means new files get 644 (666-022) and directories get 755 (777-022)

---

## REDIRECTION & PIPES

### Core Concept: Data Flow Control

Linux treats everything as a stream of data. Understanding these three streams is fundamental:

**Standard Streams**:
- **stdin (0)**: Standard input (keyboard by default)
- **stdout (1)**: Standard output (screen by default)
- **stderr (2)**: Standard error (screen by default)

**Mental Model**: Think of water flowing through pipes:
- **Redirection** (>, >>, <): Change where water comes from or goes to
- **Pipes** (|): Connect pipes so water flows from one to another
- **Filters**: Commands that transform the water as it flows

### Redirection Operators

| Operator | Description | Example | Effect | Memory Aid |
|---|---|---|---|---|
| `>` | Redirect stdout (overwrite) | `echo "text" > file.txt` | Replace file content | ">" points to file |
| `>>` | Redirect stdout (append) | `echo "text" >> file.txt` | Add to end of file | ">>" = add more |
| `<` | Redirect stdin from file | `sort < unsorted.txt` | Read from file instead of keyboard | "<" points from file |
| `2>` | Redirect stderr (overwrite) | `command 2> errors.txt` | Save errors to file | "2" = stderr stream |
| `2>>` | Redirect stderr (append) | `command 2>> errors.txt` | Append errors to file | Accumulate errors |
| `&>` | Redirect both stdout and stderr | `command &> output.txt` | Capture all output | "&" = both streams |
| `2>&1` | Redirect stderr to stdout | `command > file.txt 2>&1` | Merge error into output | "2 goes to 1" |
| `1>&2` | Redirect stdout to stderr | `echo "error" 1>&2` | Send output to error stream | Reverse direction |
| `<< EOF` | Here document (multi-line input) | `cat << EOF` | Multi-line input until EOF | Heredoc |
| `<<< "text"` | Here string (single line input) | `grep "pattern" <<< "text"` | Quick string input | Herestring |
| `/dev/null` | Discard output | `command > /dev/null 2>&1` | Suppress all output | Black hole device |

**Common Redirection Patterns**:

```bash
# Discard all output (both stdout and stderr)
command > /dev/null 2>&1

# Save output, discard errors
command 2> /dev/null > output.txt

# Save output and errors to different files
command > output.txt 2> errors.txt

# Append output, overwrite errors
command >> output.txt 2> errors.txt
```

### Pipe Operations

| Command Pattern | Description | Example | Use Case |
|---|---|---|---|
| `cmd1 | cmd2` | Send cmd1 output to cmd2 input | `ls | grep ".txt"` | Filter results |
| `cmd1 | cmd2 | cmd3` | Chain multiple commands | `cat file.txt | grep "error" | wc -l` | Multi-stage processing |
| `cmd1 | tee file.txt` | View and save simultaneously | `ls | tee output.txt` | Monitor and log |
| `cmd1 | tee -a file.txt` | View and append simultaneously | `date | tee -a log.txt` | Continuous logging |
| `cmd1 | xargs cmd2` | Convert stdout to arguments | `find . -name "*.txt" | xargs rm` | Bulk operations |

### Practical Pipe Combinations

| Command Chain | Purpose | Explanation |
|---|---|---|
| `ps aux | grep "process"` | Find specific process | List processes, filter by name |
| `cat file.txt | sort | uniq` | Remove duplicates | Sort first (uniq needs sorted input) |
| `history | grep "command"` | Search command history | Find previously used commands |
| `ls -l | awk '{print $9}'` | Extract filenames | Parse ls output, get 9th column |
| `du -sh * | sort -h` | Sort directories by size | Human-readable, size-sorted |
| `cat file.txt | tr 'a-z' 'A-Z'` | Convert to uppercase | Transform characters |
| `curl url | jq '.field'` | Parse JSON from API | Fetch and extract JSON data |
| `tail -f log.txt | grep "ERROR"` | Live error monitoring | Real-time filtered logs |

### Advanced Redirection Techniques

| Technique | Command | Use Case |
|---|---|---|
| **Redirect stdout and stderr separately** | `cmd >stdout.txt 2>stderr.txt` | Separate outputs for analysis |
| **Append stdout, overwrite stderr** | `cmd >>stdout.txt 2>stderr.txt` | Cumulative output, fresh errors |
| **Swap stdout and stderr** | `cmd 3>&1 1>&2 2>&3` | Reverse output streams |
| **Close file descriptor** | `cmd 2>&-` | Close stderr |
| **Duplicate file descriptor** | `exec 3>&1` | Create backup of stdout |

**Professional Interview Points**:
1. `2>&1` must come AFTER `> file.txt` to work correctly: `command > file.txt 2>&1`
2. Pipes create subshells - variables set in pipes don't persist: `echo "test" | read var` won't work
3. `tee` is essential for debugging pipelines - it lets you see intermediate results
4. `/dev/null` is a special file that discards all data written to it (commonly used to suppress output)
5. Pipelines execute all commands concurrently (not sequentially) - they process streams in real-time
 | Prompt appearance |
| `$?` | Last command exit status | `0` (success) or `1` (error) | Check command success |
| `$` | Current shell process ID | `12345` | Shell's PID |
| `$!` | Last background process ID | `12346` | Recent background job |

### PATH Management

```bash
# View PATH
echo $PATH

# Add directory to PATH (temporary)
export PATH="$PATH:/new/directory"

# Add to beginning of PATH (higher priority)
export PATH="/new/directory:$PATH"

# Make permanent (add to ~/.bashrc or ~/.bash_profile)
echo 'export PATH="$PATH:/new/directory"' >> ~/.bashrc
source ~/.bashrc
```

### Variable Substitution & Manipulation

| Syntax | Description | Example | Result |
|---|---|---|---|
| `${VAR:-default}` | Use default if VAR unset | `echo ${NAME:-"Guest"}` | "Guest" if NAME empty |
| `${VAR:=default}` | Set and use default if unset | `${PORT:=8080}` | Sets PORT to 8080 if unset |
| `${VAR:?error}` | Error if VAR unset | `${FILE:?"File required"}` | Exits with error message |
| `${VAR:+value}` | Use value if VAR is set | `${DEBUG:+"debug mode"}` | Returns "debug mode" if DEBUG exists |
| `${#VAR}` | Length of variable | `echo ${#PATH}` | Number of characters |
| `${VAR#pattern}` | Remove shortest match from start | `${PATH#/usr}` | Remove "/usr" prefix |
| `${VAR##pattern}` | Remove longest match from start | `${FILE##*/}` | Get filename from path |
| `${VAR%pattern}` | Remove shortest match from end | `${FILE%.txt}` | Remove ".txt" extension |
| `${VAR%%pattern}` | Remove longest match from end | `${PATH%%:*}` | Get first PATH entry |

**Professional Interview Points**:
1. Environment variables are inherited by child processes; local variables are not
2. `$?` returns 0 for success, non-zero for failure (critical for error checking)
3. `export` makes a variable available to subshells and scripts
4. Modifying PATH in terminal is temporary unless added to `.bashrc` or `.bash_profile`
5. Use `${VAR}` (with braces) when variable is adjacent to other text: `${FILE}name`
6. `env` shows only environment variables; `set` shows all variables including shell-specific ones
7. Shell variables must start with letter or underscore, can contain letters, digits, underscores

---

## PROCESS MANAGEMENT

### Core Concept: Understanding Processes

A process is a running instance of a program. Every process has:
- **PID**: Process ID (unique identifier)
- **PPID**: Parent Process ID (which process started it)
- **State**: Running, Sleeping, Stopped, Zombie
- **Priority**: How much CPU time it gets

**Mental Model**: Think of processes as employees in a company:
- **PID**: Employee ID
- **PPID**: Manager who hired them
- **State**: Working, on break, fired
- **Priority**: How important their tasks are

### Process Viewing Commands

| Command | Description | Example | Output Focus | Memory Aid |
|---|---|---|---|---|
| `ps` | Show current user processes | `ps` | Minimal current shell | Process status |
| `ps aux` | Show all processes (BSD style) | `ps aux` | Comprehensive system view | "a"=all, "u"=user-oriented, "x"=include non-terminal |
| `ps -ef` | Show all processes (UNIX style) | `ps -ef` | Full format listing | "e"=everything, "f"=full format |
| `ps -u <user>` | Show user's processes | `ps -u john` | Specific user | User filter |
| `ps -p <PID>` | Show specific process | `ps -p 1234` | Single process details | PID lookup |
| `ps aux --sort=-%mem` | Sort by memory usage | `ps aux --sort=-%mem` | Memory hogs first | Resource analysis |
| `ps aux --sort=-%cpu` | Sort by CPU usage | `ps aux --sort=-%cpu` | CPU intensive first | Performance analysis |
| `pgrep <pattern>` | Find PID by process name | `pgrep firefox` | PIDs only | "Process grep" |
| `pgrep -u <user>` | Find user's process PIDs | `pgrep -u john` | User's PIDs | Filter by user |
| `pidof <program>` | Get PID of running program | `pidof nginx` | Program PIDs | "PID of" |

### Interactive Process Monitoring

| Command | Description | Key Features | Navigation | Memory Aid |
|---|---|---|---|---|
| `top` | Real-time process monitor | CPU, memory, load average | q=quit, k=kill, r=renice | "Top" processes |
| `htop` | Enhanced interactive monitor | Color-coded, mouse support | F9=kill, F7/F8=nice | Better than top |
| `atop` | Advanced system monitor | Disk I/O, network | Detailed resource tracking | Advanced top |

**Top Command Keys**:
- `P`: Sort by CPU usage
- `M`: Sort by memory usage
- `k`: Kill process (asks for PID)
- `r`: Renice process (change priority)
- `h`: Help
- `q`: Quit
- `1`: Show individual CPU cores
- `c`: Show full command path

### Process Control: Killing Processes

| Command | Signal | Description | Example | When to Use | Memory Aid |
|---|---|---|---|---|---|
| `kill <PID>` | TERM (15) | Graceful termination (default) | `kill 1234` | Normal shutdown | Polite kill |
| `kill -9 <PID>` | KILL (9) | Force kill (cannot be caught) | `kill -9 1234` | Frozen/unresponsive process | Nuclear option |
| `kill -15 <PID>` | TERM (15) | Terminate (explicit) | `kill -15 1234` | Same as kill | Explicit signal |
| `kill -1 <PID>` | HUP (1) | Hangup (reload config) | `kill -1 1234` | Reload without restart | Hang up |
| `kill -2 <PID>` | INT (2) | Interrupt (like Ctrl+C) | `kill -2 1234` | Interrupt gracefully | Interrupt |
| `kill -STOP <PID>` | STOP (19) | Pause process | `kill -STOP 1234` | Temporarily suspend | Freeze |
| `kill -CONT <PID>` | CONT (18) | Resume process | `kill -CONT 1234` | Resume after STOP | Continue |
| `killall <name>` | TERM (15) | Kill by process name | `killall firefox` | Multiple instances | Kill all instances |
| `killall -9 <name>` | KILL (9) | Force kill by name | `killall -9 firefox` | Force multiple | Force all |
| `pkill <pattern>` | TERM (15) | Kill by pattern match | `pkill -f "python.*script"` | Flexible matching | Pattern kill |
| `pkill -u <user>` | TERM (15) | Kill user's processes | `pkill -u john` | Terminate user session | User kill |

**Common Signals Reference**:
| Signal | Number | Name | Effect | Use Case |
|---|---|---|---|---|
| SIGHUP | 1 | Hangup | Reload configuration | Refresh daemon config |
| SIGINT | 2 | Interrupt | Graceful interrupt (Ctrl+C) | User interruption |
| SIGQUIT | 3 | Quit | Quit with core dump | Debugging |
| SIGKILL | 9 | Kill | Force termination (cannot be caught) | Last resort |
| SIGTERM | 15 | Terminate | Graceful termination (default) | Normal shutdown |
| SIGSTOP | 19 | Stop | Pause process (cannot be caught) | Suspend |
| SIGCONT | 18 | Continue | Resume paused process | Resume |

### Background & Foreground Jobs

| Command | Description | Example | Use Case | Memory Aid |
|---|---|---|---|---|
| `command &` | Run command in background | `./script.sh &` | Non-blocking execution | "&" = background |
| `jobs` | List background jobs | `jobs` | See active jobs | Job status |
| `jobs -l` | List jobs with PIDs | `jobs -l` | Get PIDs of jobs | Long format |
| `fg` | Bring last job to foreground | `fg` | Resume interactive work | Foreground |
| `fg %1` | Bring job 1 to foreground | `fg %1` | Resume specific job | Job number |
| `bg` | Resume job in background | `bg` | Continue suspended job | Background |
| `bg %1` | Resume job 1 in background | `bg %1` | Specific background resume | Job number |
| `Ctrl+Z` | Suspend current process | (interactive) | Pause to do something else | Stop signal |
| `Ctrl+C` | Interrupt current process | (interactive) | Cancel running command | Cancel |
| `disown %1` | Remove job from shell | `disown %1` | Prevent job termination on exit | Disown job |
| `nohup <command> &` | Run immune to hangups | `nohup ./script.sh &` | Survive terminal closure | No hangup |

**Job Control Workflow Example**:
```bash
# Start a long-running process
find / -name "*.log" > results.txt

# Suspend it (Ctrl+Z)
[1]+ Stopped   find / -name "*.log"

# Resume in background
bg %1

# List jobs
jobs
[1]+ Running   find / -name "*.log" &

# Bring back to foreground
fg %1
```

### Process Priority & Nice Values

**Nice Values**: Range from -20 (highest priority) to 19 (lowest priority). Default is 0.

**Mental Model**: "Nicer" processes let others go first (higher nice = lower priority)

| Command | Description | Example | Effect | Memory Aid |
|---|---|---|---|---|
| `nice -n <value> <command>` | Start with priority | `nice -n 10 ./script.sh` | Lower priority (+10) | Be nice to others |
| `nice -n -10 <command>` | Start with high priority | `nice -n -10 ./script.sh` | Higher priority (needs sudo) | Less nice = more priority |
| `renice <value> -p <PID>` | Change running process priority | `renice 5 -p 1234` | Adjust existing process | Re-nice |
| `renice 10 -u <user>` | Change all user processes | `renice 10 -u john` | Affect user's processes | User-wide nice |

**Priority Rules**:
- Negative nice values (higher priority) require root/sudo
- Positive nice values (lower priority) can be set by any user
- Default nice value is 0
- Child processes inherit parent's nice value

### Process Information & Monitoring

| Command | Description | Example | Output | Use Case |
|---|---|---|---|---|
| `pstree` | Show process tree | `pstree` | Hierarchical process view | Understand relationships |
| `pstree -p` | Show tree with PIDs | `pstree -p` | Tree with identifiers | PID hierarchy |
| `lsof` | List open files | `lsof` | Files and processes | Resource usage |
| `lsof -p <PID>` | Files opened by process | `lsof -p 1234` | Process file handles | Debug process |
| `lsof -u <user>` | Files opened by user | `lsof -u john` | User's open files | User activity |
| `lsof -i` | Network connections | `lsof -i` | Active network files | Network debugging |
| `lsof -i :80` | Processes using port 80 | `lsof -i :80` | Port usage | Find port conflicts |
| `strace -p <PID>` | Trace system calls | `strace -p 1234` | System call trace | Debug behavior |
| `/proc/<PID>/` | Process information directory | `cat /proc/1234/status` | Detailed process info | Kernel interface |

### Performance Analysis

| Command | Description | Example | Use Case |
|---|---|---|---|
| `time <command>` | Measure command execution time | `time ls -R /` | Performance timing |
| `uptime` | System load average | `uptime` | Overall system load |
| `w` | Who is logged in and what they're doing | `w` | User activity overview |
| `vmstat` | Virtual memory statistics | `vmstat 1` | Memory performance |
| `iostat` | CPU and I/O statistics | `iostat -x 1` | Disk performance |
| `sar` | System activity report | `sar -u 1 10` | Historical performance data |

**Professional Interview Points**:
1. **Signal 9 (SIGKILL) cannot be caught or ignored** - it's the only guaranteed way to kill a process
2. **Signal 15 (SIGTERM) is preferred** - allows process to cleanup (close files, save state)
3. **Zombie processes** have finished execution but parent hasn't read exit status (can't be killed)
4. **Background jobs terminate when terminal closes** unless started with `nohup` or `disown`
5. **Process priority affects CPU scheduling** - nice values don't affect I/O priority
6. **Load average** shows 1, 5, and 15-minute averages (rule of thumb: < number of CPU cores is healthy)
7. **PID 1 is init/systemd** - first process started by kernel, parent of all processes
8. **Orphan processes are adopted by init/systemd** when parent dies
9. **In `ps aux`, STAT column**: R=Running, S=Sleeping, D=Uninterruptible sleep, Z=Zombie, T=Stopped
10. **Use `pgrep` instead of `ps | grep`** - more efficient and avoids matching grep itself

---

*Due to character limits, I'll provide the rest of the comprehensive guide in the artifact. The complete markdown document includes all remaining sections: Compression & Archives, System Information, Network Commands, Text Processing, Help & Documentation, Shell Configuration, Memory Techniques, Interview Scenarios, and Quick Reference Tables.*