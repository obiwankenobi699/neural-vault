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
# Linux Command Reference Cheat Sheet

## NAVIGATION & DIRECTORY OPERATIONS

|Command|Description|Example|
|---|---|---|
|`cd <directory>`|Change directory|`cd /var/log`|
|`cd ..`|Go up one level|`cd ..`|
|`cd ~`|Go to home directory|`cd ~`|
|`cd -`|Go to previous directory|`cd -`|
|`pwd`|Print working directory|`pwd`|
|`ls`|List files and directories|`ls`|
|`ls -l`|Long format listing|`ls -l`|
|`ls -a`|Show hidden files|`ls -a`|
|`ls -la`|Long format with hidden files|`ls -la`|
|`ls -R`|Recursive listing|`ls -R`|
|`ls -lh`|Human-readable file sizes|`ls -lh`|

## FILE VIEWING & CONTENT OPERATIONS

|Command|Description|Example|
|---|---|---|
|`cat <file>`|Display file content|`cat file.txt`|
|`cat <file1> <file2>`|Concatenate files|`cat file1.txt file2.txt`|
|`less <file>`|View file with pagination|`less large_file.txt`|
|`more <file>`|View file page by page|`more file.txt`|
|`head <file>`|Show first 10 lines|`head file.txt`|
|`head -n 20 <file>`|Show first N lines|`head -n 20 file.txt`|
|`tail <file>`|Show last 10 lines|`tail file.txt`|
|`tail -f <file>`|Follow file updates|`tail -f /var/log/syslog`|
|`wc -l <file>`|Count lines in file|`wc -l file.txt`|
|`wc -w <file>`|Count words in file|`wc -w file.txt`|

## FILE & DIRECTORY CREATION

|Command|Description|Example|
|---|---|---|
|`touch <file>`|Create empty file|`touch newfile.txt`|
|`mkdir <directory>`|Create directory|`mkdir project`|
|`mkdir -p <path>`|Create nested directories|`mkdir -p dir1/dir2/dir3`|

## FILE & DIRECTORY OPERATIONS

|Command|Description|Example|
|---|---|---|
|`cp <source> <dest>`|Copy file|`cp file1.txt file2.txt`|
|`cp -r <source> <dest>`|Copy directory recursively|`cp -r folder1 folder2`|
|`cp -i <source> <dest>`|Interactive copy (confirm overwrite)|`cp -i file1.txt file2.txt`|
|`mv <source> <dest>`|Move or rename file|`mv old.txt new.txt`|
|`mv <file> <directory>`|Move file to directory|`mv file.txt /tmp/`|
|`rm <file>`|Remove file|`rm file.txt`|
|`rm -r <directory>`|Remove directory recursively|`rm -r folder`|
|`rm -rf <directory>`|Force remove without prompt|`rm -rf folder`|
|`rm -i <file>`|Interactive removal|`rm -i file.txt`|

## SEARCH & FIND OPERATIONS {global regular expression print}

| Command                              | Description                  | Example                              |
| ------------------------------------ | ---------------------------- | ------------------------------------ |
| `find <path> -name <pattern>`        | Find files by name           | `find . -name "*.txt"`               |
| `find <path> -type f`                | Find only files              | `find /home -type f`                 |
| `find <path> -type d`                | Find only directories        | `find /home -type d`                 |
| `find . -name "*.txt" -exec rm {} +` | Find and execute command     | `find . -name "*.log" -exec rm {} +` |
| `grep <pattern> <file>`              | Search pattern in file       | `grep "error" log.txt`               |
| `grep -r <pattern> <directory>`      | Recursive search             | `grep -r "TODO" .`                   |
| `grep -i <pattern> <file>`           | Case-insensitive search      | `grep -i "error" log.txt`            |
| `grep -n <pattern> <file>`           | Show line numbers            | `grep -n "error" log.txt`            |
| `whereis <command>`                  | Locate binary and manual     | `whereis python`                     |
| `which <command>`                    | Show command path            | `which python`                       |
| `locate <file>`                      | Find file by name (database) | `locate config.txt`                  |

## PERMISSIONS & OWNERSHIP

|Command|Description|Example|
|---|---|---|
|`chmod <mode> <file>`|Change file permissions|`chmod 755 script.sh`|
|`chmod +x <file>`|Make file executable|`chmod +x script.sh`|
|`chmod -x <file>`|Remove execute permission|`chmod -x script.sh`|
|`chmod u+r <file>`|Add read for user|`chmod u+r file.txt`|
|`chmod g+w <file>`|Add write for group|`chmod g+w file.txt`|
|`chmod o-r <file>`|Remove read for others|`chmod o-r file.txt`|
|`chmod 777 <file>`|Full permissions (rwxrwxrwx)|`chmod 777 file.txt`|
|`chmod 644 <file>`|Standard file permissions|`chmod 644 file.txt`|
|`chown <user> <file>`|Change file owner|`chown john file.txt`|
|`chown <user>:<group> <file>`|Change owner and group|`chown john:developers file.txt`|
|`chown -R <user> <directory>`|Recursive ownership change|`chown -R john folder/`|
|`chgrp <group> <file>`|Change group ownership|`chgrp developers file.txt`|

## REDIRECTION & PIPES

|Command|Description|Example|
|---|---|---|
|`command > file`|Redirect output (overwrite)|`echo "text" > file.txt`|
|`command >> file`|Redirect output (append)|`echo "text" >> file.txt`|
|`command < file`|Redirect input from file|`sort < unsorted.txt`|
|`command1 \| command2`|Pipe output to next command|`ls \| grep ".txt"`|
|`command 2> file`|Redirect errors to file|`find / 2> errors.txt`|
|`command &> file`|Redirect output and errors|`command &> output.txt`|

## ENVIRONMENT & VARIABLES

|Command|Description|Example|
|---|---|---|
|`echo <text>`|Print text or variable|`echo "Hello World"`|
|`echo $VARIABLE`|Print variable value|`echo $PATH`|
|`export VAR=value`|Set environment variable|`export JAVA_HOME=/usr/lib/jvm`|
|`env`|Show all environment variables|`env`|
|`printenv`|Display environment variables|`printenv`|
|`printenv <VAR>`|Display specific variable|`printenv PATH`|

## PROCESS MANAGEMENT

|Command|Description|Example|
|---|---|---|
|`ps`|Show current processes|`ps`|
|`ps aux`|Show all processes|`ps aux`|
|`ps -ef`|Full format listing|`ps -ef`|
|`top`|Real-time process monitor|`top`|
|`htop`|Interactive process viewer|`htop`|
|`kill <PID>`|Terminate process by ID|`kill 1234`|
|`kill -9 <PID>`|Force kill process|`kill -9 1234`|
|`killall <name>`|Kill processes by name|`killall firefox`|
|`bg`|Resume job in background|`bg`|
|`fg`|Bring job to foreground|`fg`|
|`jobs`|List background jobs|`jobs`|

## COMPRESSION & ARCHIVES

|Command|Description|Example|
|---|---|---|
|`tar -cvf <archive.tar> <files>`|Create tar archive|`tar -cvf backup.tar files/`|
|`tar -xvf <archive.tar>`|Extract tar archive|`tar -xvf backup.tar`|
|`tar -czvf <archive.tar.gz> <files>`|Create compressed tar.gz|`tar -czvf backup.tar.gz files/`|
|`tar -xzvf <archive.tar.gz>`|Extract tar.gz archive|`tar -xzvf backup.tar.gz`|
|`zip <archive.zip> <files>`|Create zip archive|`zip backup.zip file1 file2`|
|`zip -r <archive.zip> <directory>`|Zip directory recursively|`zip -r backup.zip folder/`|
|`unzip <archive.zip>`|Extract zip archive|`unzip backup.zip`|
|`gzip <file>`|Compress file with gzip|`gzip file.txt`|
|`gunzip <file.gz>`|Decompress gzip file|`gunzip file.txt.gz`|

## SYSTEM INFORMATION

|Command|Description|Example|
|---|---|---|
|`uname -a`|Show system information|`uname -a`|
|`hostname`|Display system hostname|`hostname`|
|`whoami`|Show current user|`whoami`|
|`id`|Show user and group IDs|`id`|
|`df -h`|Show disk space usage|`df -h`|
|`du -sh <directory>`|Show directory size|`du -sh /var/log`|
|`free -h`|Show memory usage|`free -h`|
|`uptime`|Show system uptime|`uptime`|
|`date`|Display current date and time|`date`|

## NETWORK COMMANDS

|Command|Description|Example|
|---|---|---|
|`ping <host>`|Test network connectivity|`ping google.com`|
|`ifconfig`|Show network interfaces|`ifconfig`|
|`ip addr`|Show IP addresses|`ip addr`|
|`netstat -tuln`|Show listening ports|`netstat -tuln`|
|`ss -tuln`|Show socket statistics|`ss -tuln`|
|`curl <url>`|Transfer data from URL|`curl https://api.example.com`|
|`wget <url>`|Download file from URL|`wget https://example.com/file.zip`|

## HELP & DOCUMENTATION

|Command|Description|Example|
|---|---|---|
|`man <command>`|Show manual page|`man ls`|
|`<command> --help`|Show command help|`ls --help`|
|`info <command>`|Show info documentation|`info grep`|
|`whatis <command>`|Brief command description|`whatis cp`|
|`apropos <keyword>`|Search manual pages|`apropos copy`|

## SHELL CONFIGURATION & ALIASES

|Command|Description|Example|
|---|---|---|
|`alias <name>='<command>'`|Create command alias|`alias ll='ls -la'`|
|`unalias <name>`|Remove alias|`unalias ll`|
|`source <file>`|Execute commands from file|`source ~/.bashrc`|
|`. <file>`|Execute commands (alternative)|`. ~/.bashrc`|
|`history`|Show command history|`history`|
|`!<number>`|Execute command from history|`!42`|
|`!!`|Execute previous command|`!!`|

## TEXT PROCESSING

|Command|Description|Example|
|---|---|---|
|`sort <file>`|Sort lines in file|`sort names.txt`|
|`sort -r <file>`|Reverse sort|`sort -r numbers.txt`|
|`uniq <file>`|Remove duplicate lines|`uniq sorted.txt`|
|`cut -d'<delim>' -f<field> <file>`|Extract columns|`cut -d',' -f1 data.csv`|
|`awk '{print $1}' <file>`|Process and extract fields|`awk '{print $1}' file.txt`|
|`sed 's/<old>/<new>/g' <file>`|Search and replace|`sed 's/foo/bar/g' file.txt`|
|`tr '<set1>' '<set2>'`|Translate characters|`echo "hello" \| tr 'a-z' 'A-Z'`|

## PERMISSION NOTATION REFERENCE

|Numeric|Symbolic|Meaning|
|---|---|---|
|0|---|No permissions|
|1|--x|Execute only|
|2|-w-|Write only|
|3|-wx|Write and execute|
|4|r--|Read only|
|5|r-x|Read and execute|
|6|rw-|Read and write|
|7|rwx|Read, write, and execute|

## COMMON PERMISSION PATTERNS

|Pattern|Description|
|---|---|
|644|Standard file (rw-r--r--)|
|755|Standard directory/executable (rwxr-xr-x)|
|600|Private file (rw-------)|
|700|Private directory (rwx------)|
|777|Full access (rwxrwxrwx) - avoid in production|

## CONFIGURATION FILE LOCATIONS

|File|Purpose|
|---|---|
|`~/.bashrc`|User bash configuration|
|`~/.bash_profile`|Bash login configuration|
|`~/.zshrc`|User zsh configuration|
|`/etc/bashrc`|System-wide bash configuration|
|`/etc/profile`|System-wide login configuration|
|`~/.vimrc`|Vim editor configuration|
|`~/.ssh/config`|SSH client configuration|

## SPECIAL CHARACTERS & SHORTCUTS

|Symbol|Meaning|
|---|---|
|`.`|Current directory|
|`..`|Parent directory|
|`~`|Home directory|
|`/`|Root directory|
|`-`|Previous directory|
|`*`|Wildcard (any characters)|
|`?`|Single character wildcard|
|`&`|Run command in background|
|`;`|Command separator|
|`&&`|Execute if previous succeeds|
|`\|`|Execute if previous fails|

## KEYBOARD SHORTCUTS

|Shortcut|Action|
|---|---|
|`Ctrl + C`|Interrupt/kill current command|
|`Ctrl + D`|Exit shell or end input|
|`Ctrl + Z`|Suspend current process|
|`Ctrl + L`|Clear screen|
|`Ctrl + A`|Move to line beginning|
|`Ctrl + E`|Move to line end|
|`Ctrl + U`|Delete from cursor to line start|
|`Ctrl + K`|Delete from cursor to line end|
|`Ctrl + R`|Search command history|
|`Tab`|Auto-complete|
|`Tab Tab`|Show all completions|