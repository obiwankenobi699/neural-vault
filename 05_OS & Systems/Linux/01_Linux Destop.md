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

## 1. High-Level Linux Desktop Stack (Mental Model)

```graph
User
 │
 │ runs
 ▼
Applications (Firefox, Terminal, VSCode)
 │
 │ use
 ▼
UI Toolkits (GTK / Qt)
 │
 │ talk to
 ▼
Desktop Environment / Window Manager
 │   ├─ GNOME
 │   ├─ KDE Plasma
 │   └─ Hyprland (tiling WM)
 │
 │ implement
 ▼
Display Protocol
 │   ├─ Wayland
 │   └─ X11 (legacy)
 │
 │ runs on
 ▼
Linux Kernel
 │
 │ manages
 ▼
File System (ext4) + FHS
```

Key idea:

- **These are layers, not alternatives**
    
- Multiple layers exist together
    

---

## 2. File System Hierarchy Standard (FHS)

Purpose:

- Defines **where files live**, not how they are stored
    

Important directories:

```text
/bin     → essential user binaries
/sbin    → system binaries
/etc     → configuration files
/usr     → user programs & libraries
/lib     → shared libraries
/var     → logs, cache, spool
/home    → user data
```

Used by:

- Linux distributions
    
- Package managers
    
- System services
    

Not related to:

- Wayland
    
- Hyprland
    
- KDE
    
- GTK
    

---

## 3. Display Systems

### 3.1 Wayland

What it is:

- Display protocol
    
- Successor to X11
    

Responsibilities:

- Window rendering
    
- Input handling
    
- Security isolation
    

What it is NOT:

- Window manager
    
- Desktop environment
    

---

## 4. Desktop Environments

### 4.1 GNOME

- GTK-based
    
- Opinionated design
    
- Uses Mutter (Wayland compositor)
    

### 4.2 KDE Plasma

- Qt-based
    
- Highly customizable
    
- Uses KWin (Wayland compositor)
    

```graph
KDE Plasma
 ├─ KWin (WM / compositor)
 ├─ Plasma Shell
 ├─ System Settings
 └─ Qt Applications
```

---

## 5. Window Managers (Tiling)

### 5.1 Hyprland

What it is:

- Wayland compositor
    
- Tiling window manager
    

What it does:

- Window placement
    
- Animations
    
- Input bindings
    

What it does NOT:

- Provide UI widgets
    
- Provide panels
    
- Provide launchers
    

Hyprland requires external tools.

---

## 6. Hyprland Ecosystem Tools (Very Important)

### 6.1 Hyprpaper

Wallpaper daemon for Hyprland.

Purpose:

- Set wallpapers on Wayland
    
- Replaces feh (X11)
    

```text
hyprpaper
 └─ manages wallpapers
```

---

### 6.2 Wofi

Application launcher (Wayland alternative to rofi).

Used for:

- Launching apps
    
- Running commands
    

```text
Super + D
 └─ wofi --show drun
```

---

### 6.3 Waybar

Status bar for Wayland compositors.

Displays:

- Workspaces
    
- CPU / RAM
    
- Network
    
- Battery
    
- Clock
    

```graph
Waybar
 ├─ CPU module
 ├─ Memory module
 ├─ Network module
 ├─ Clock module
 └─ Workspace module
```

---

## 7. UI Toolkits

### GTK

- Used by GNOME apps
    
- Used by Firefox
    
- Independent of GNOME
    

### Qt

- Used by KDE apps
    
- Independent of KDE
    

GTK and Qt apps can run on:

- GNOME
    
- KDE
    
- Hyprland
    

---

## 8. Package Management (Arch-based)

```graph
yay
 ├─ pacman (official repos)
 └─ AUR (community PKGBUILD)
```

### pacman

- Official Arch package manager
    
- Binary packages
    

### AUR

- User maintained
    
- Source-based builds
    

### yay

- Wrapper for pacman + AUR
    
- Automates builds
    

---

## 9. systemctl (Core DevOps Commands)

Purpose:

- Manage systemd services
    

### Common Commands

```bash
systemctl status nginx
systemctl start docker
systemctl stop docker
systemctl restart sshd
systemctl enable docker
systemctl disable docker
systemctl daemon-reload
```

### Service States

- active
    
- inactive
    
- failed
    
- enabled
    
- disabled
    

---

## 10. Hyprland Control Commands (hyprctl)

Used to:

- Control Hyprland runtime
    
- Debug
    
- Manage windows
    

### Common Commands

```bash
hyprctl monitors
hyprctl workspaces
hyprctl clients
hyprctl activewindow
hyprctl reload
hyprctl dispatch exit
```

---

## 11. How Everything Links (Final Graph)

```graph
ext4
 │
 ▼
FHS
 │
 ▼
Linux Kernel
 │
 ▼
Wayland
 │
 ▼
Hyprland
 │
 ├─ hyprpaper (wallpaper)
 │
 ├─ waybar (status bar)
 │
 └─ wofi (launcher)
 │
 ▼
GTK / Qt
 │
 ▼
Applications
```

---

## 12. Interview One-Line Explanations

- **Wayland**: Display protocol
    
- **Hyprland**: Wayland tiling compositor
    
- **Hyprpaper**: Wallpaper daemon for Hyprland
    
- **Wofi**: Wayland app launcher
    
- **Waybar**: Wayland status bar
    
- **KDE Plasma**: Qt-based desktop environment
    
- **systemctl**: systemd service manager
    
- **hyprctl**: Hyprland control utility
    

---

## 13. DevOps Relevance

Why DevOps cares:

- Headless servers still follow FHS
    
- systemctl manages services
    
- GUI stack knowledge helps debugging
    
- Wayland matters for modern Linux desktops
    
- Hyprland shows deep Linux understanding
    

---

If you want next:

- Linux boot process (BIOS → systemd → Wayland)
    
- Why Wayland is more secure than X11
    
- Containers vs systemd vs desktop services
    
- How display managers fit (gdm, sddm)
    

Just tell me.