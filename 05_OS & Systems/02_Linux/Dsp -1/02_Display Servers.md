# Wayland & Hyprland: Complete Technical Guide

## Table of Contents

1. [Understanding Display Servers](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#understanding-display-servers)
2. [Wayland Protocol](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#wayland-protocol)
3. [Hyprland Compositor](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#hyprland-compositor)
4. [Architecture Comparison](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#architecture-comparison)
5. [Configuration & Setup](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#configuration--setup)
6. [Workflow Integration](https://claude.ai/chat/9f17afd4-4015-4cbf-b605-e12dd3f24b0d#workflow-integration)

---

## Understanding Display Servers

### What is a Display Server?

A display server is the software that manages the communication between applications and the graphics hardware, handling window management, input devices, and rendering.

```
┌─────────────────────────────────────────────────────────────┐
│              DISPLAY SERVER EVOLUTION                       │
└─────────────────────────────────────────────────────────────┘

TRADITIONAL X11 (X.Org) ARCHITECTURE
════════════════════════════════════

    Applications Layer
    ┌──────────┐  ┌──────────┐  ┌──────────┐
    │ Firefox  │  │  Kitty   │  │ Neovim   │
    └────┬─────┘  └────┬─────┘  └────┬─────┘
         │             │             │
         └─────────────┼─────────────┘
                       │
                       ▼
         ┌─────────────────────────┐
         │   X Server (Xorg)       │  ← Central bottleneck
         │   • Window management   │
         │   • Event handling      │
         │   • Drawing primitives  │
         └────────────┬────────────┘
                      │
         ┌────────────┴────────────┐
         │                         │
         ▼                         ▼
    ┌─────────┐            ┌──────────────┐
    │   WM    │            │  Compositor  │
    │  (i3)   │            │   (picom)    │
    └─────────┘            └──────────────┘
         │                         │
         └────────────┬────────────┘
                      │
                      ▼
              ┌───────────────┐
              │  GPU/Display  │
              └───────────────┘

Problems with X11:
• Complex, monolithic codebase (30+ years old)
• Security issues (apps can snoop on each other)
• Performance overhead (client-server model)
• Screen tearing without compositor
• Difficult to maintain


MODERN WAYLAND ARCHITECTURE
═══════════════════════════

    Applications Layer
    ┌──────────┐  ┌──────────┐  ┌──────────┐
    │ Firefox  │  │  Kitty   │  │ Neovim   │
    └────┬─────┘  └────┬─────┘  └────┬─────┘
         │             │             │
         └─────────────┼─────────────┘
                       │
              Wayland Protocol
           (IPC/Unix Sockets)
                       │
                       ▼
         ┌─────────────────────────┐
         │   Wayland Compositor    │  ← Single component
         │     (Hyprland)          │
         │                         │
         │  • Window Manager       │
         │  • Compositor           │
         │  • Display Server       │
         │  • Input handling       │
         └────────────┬────────────┘
                      │
                      ▼
              ┌───────────────┐
              │  GPU/Display  │
              │  (DRM/KMS)    │
              └───────────────┘

Benefits of Wayland:
✓ Simpler, cleaner architecture
✓ Better security (app isolation)
✓ Smoother graphics (no tearing)
✓ Lower latency
✓ Modern codebase
```

### Key Terminology

**Protocol**: A set of rules/standards for communication (like HTTP for web) **Compositor**: Software that combines window contents and renders final output **Display Server**: Manages display, input, and window operations **Window Manager**: Controls window placement, sizing, and behavior

---

## Wayland Protocol

### What is Wayland?

Wayland is a **protocol specification**, not an implementation. Think of it as the rulebook that different compositors follow to communicate with applications.

```
┌─────────────────────────────────────────────────────────────┐
│           WAYLAND PROTOCOL ARCHITECTURE                     │
└─────────────────────────────────────────────────────────────┘

The Protocol (Specification)
═══════════════════════════
Defines how apps and compositors communicate:

    Client (Application)          Server (Compositor)
    ────────────────────          ──────────────────
         │                              │
         │  1. Create Surface           │
         ├─────────────────────────────>│
         │                              │
         │  2. Surface Created          │
         │<─────────────────────────────┤
         │                              │
         │  3. Attach Buffer (pixels)   │
         ├─────────────────────────────>│
         │                              │
         │  4. Commit (display frame)   │
         ├─────────────────────────────>│
         │                              │
         │  5. Frame Callback           │
         │<─────────────────────────────┤
         │                              │
         │  6. Input Event (keyboard)   │
         │<─────────────────────────────┤
         │                              │


Wayland Core Protocols
══════════════════════

wl_display     - Connection to compositor
wl_registry    - Global objects registry
wl_compositor  - Surface creation
wl_surface     - Window content area
wl_output      - Display information
wl_seat        - Input device group
wl_keyboard    - Keyboard input
wl_pointer     - Mouse/touchpad
wl_touch       - Touchscreen
wl_shm         - Shared memory buffers
```

### Wayland vs X11 Communication

```
X11 Communication Model
═══════════════════════

    ┌─────────────┐
    │ Application │
    └──────┬──────┘
           │ X11 Protocol (network-transparent)
           │ "Draw a line from (0,0) to (100,100)"
           ▼
    ┌─────────────┐
    │  X Server   │ ← Does the drawing
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │  Graphics   │
    └─────────────┘


Wayland Communication Model
═══════════════════════════

    ┌─────────────┐
    │ Application │ ← Does its own drawing
    └──────┬──────┘
           │ Wayland Protocol (local only)
           │ "Here's my rendered buffer"
           ▼
    ┌─────────────┐
    │ Compositor  │ ← Composites buffers
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │  Graphics   │
    └─────────────┘
```

### Popular Wayland Compositors

```
┌─────────────────────────────────────────────────────────────┐
│         WAYLAND COMPOSITOR ECOSYSTEM                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Compositor      │  Type        │  Desktop    │  Features   │
│  ────────────────┼──────────────┼─────────────┼────────────│
│  Hyprland        │  Tiling      │  Standalone │  Animations │
│                  │              │             │  Effects    │
│  ────────────────┼──────────────┼─────────────┼────────────│
│  Sway            │  Tiling      │  Standalone │  i3-like    │
│                  │              │             │  Minimal    │
│  ────────────────┼──────────────┼─────────────┼────────────│
│  KWin            │  Stacking    │  KDE Plasma │  Full DE    │
│                  │              │             │  Features   │
│  ────────────────┼──────────────┼─────────────┼────────────│
│  Mutter          │  Stacking    │  GNOME      │  Full DE    │
│                  │              │             │  Features   │
│  ────────────────┼──────────────┼─────────────┼────────────│
│  wlroots-based   │  Various     │  Custom     │  Flexible   │
│  (River, dwl)    │              │             │  Library    │
│                                                             │
└─────────────────────────────────────────────────────────────┘


        Application Compatibility
        
    ┌────────────────────────────┐
    │  Native Wayland Apps       │
    │  • Firefox (Wayland mode)  │
    │  • Kitty                   │
    │  • foot                    │
    │  • mpv                     │
    └────────────────────────────┘
                │
                │ Direct Wayland Protocol
                │
                ▼
    ┌────────────────────────────┐
    │  Wayland Compositor        │
    │  (Hyprland/Sway/etc)       │
    └──────────┬─────────────────┘
               │
               │ XWayland (X11 compatibility layer)
               │
               ▼
    ┌────────────────────────────┐
    │  Legacy X11 Apps           │
    │  • Discord                 │
    │  • Some Java apps          │
    │  • Older software          │
    └────────────────────────────┘
```

---

## Hyprland Compositor

### What is Hyprland?

Hyprland is a **dynamic tiling Wayland compositor** written in C++. It's not just a window manager—it's a complete display server implementation that follows the Wayland protocol.

```
┌─────────────────────────────────────────────────────────────┐
│              HYPRLAND ARCHITECTURE                          │
└─────────────────────────────────────────────────────────────┘

Core Components
═══════════════

    ┌─────────────────────────────────────────────┐
    │           HYPRLAND COMPOSITOR               │
    ├─────────────────────────────────────────────┤
    │                                             │
    │  ┌────────────────────────────────────┐    │
    │  │   Window Manager (Tiling Logic)    │    │
    │  │   • Dynamic layouts                │    │
    │  │   • Master-stack                   │    │
    │  │   • Dwindle (Fibonacci)            │    │
    │  └────────────────────────────────────┘    │
    │                                             │
    │  ┌────────────────────────────────────┐    │
    │  │   Compositor (Rendering)           │    │
    │  │   • OpenGL rendering               │    │
    │  │   • Buffer management              │    │
    │  │   • Damage tracking                │    │
    │  └────────────────────────────────────┘    │
    │                                             │
    │  ┌────────────────────────────────────┐    │
    │  │   Animation Engine                 │    │
    │  │   • Bezier curves                  │    │
    │  │   • Spring physics                 │    │
    │  │   • Custom animations              │    │
    │  └────────────────────────────────────┘    │
    │                                             │
    │  ┌────────────────────────────────────┐    │
    │  │   Input Manager                    │    │
    │  │   • libinput integration           │    │
    │  │   • Keybinds                       │    │
    │  │   • Mouse/touchpad                 │    │
    │  └────────────────────────────────────┘    │
    │                                             │
    │  ┌────────────────────────────────────┐    │
    │  │   IPC Server (hyprctl)             │    │
    │  │   • Unix socket                    │    │
    │  │   • Runtime control                │    │
    │  │   • Scripting support              │    │
    │  └────────────────────────────────────┘    │
    │                                             │
    └─────────────────┬───────────────────────────┘
                      │
                      │ Built on wlroots library
                      │
                      ▼
    ┌─────────────────────────────────────────────┐
    │              wlroots Library                │
    │  • DRM/KMS (kernel mode setting)            │
    │  • libinput (input devices)                 │
    │  • Wayland protocol implementation          │
    │  • EGL/OpenGL integration                   │
    └─────────────────┬───────────────────────────┘
                      │
                      ▼
    ┌─────────────────────────────────────────────┐
    │         Linux Kernel (DRM subsystem)        │
    └─────────────────────────────────────────────┘
```

### Hyprland Launch Process

```
BOOT TO HYPRLAND WORKFLOW
═════════════════════════

1. System Boot
   ├── GRUB/systemd-boot
   └── Linux Kernel loads
           │
           ▼
2. Init System (systemd)
   ├── Starts display manager
   └── SDDM/GDM/LightDM launches
           │
           ▼
3. Display Manager
   ├── Reads /usr/share/wayland-sessions/
   ├── Finds hyprland.desktop
   │   ┌──────────────────────────────┐
   │   │ [Desktop Entry]              │
   │   │ Name=Hyprland                │
   │   │ Comment=Dynamic tiling       │
   │   │ Exec=Hyprland                │
   │   │ Type=Application             │
   │   └──────────────────────────────┘
   └── User selects "Hyprland" session
           │
           ▼
4. Hyprland Startup
   ├── Reads ~/.config/hypr/hyprland.conf
   ├── Initializes wlroots
   ├── Sets up Wayland socket
   ├── Initializes DRM/KMS
   ├── Loads monitors configuration
   ├── Applies keybinds
   ├── Starts autostart apps
   └── Compositor ready
           │
           ▼
5. User Environment
   ├── Waybar (status bar) starts
   ├── Terminal (Kitty) ready
   ├── Launcher (wofi/rofi) available
   └── Applications launch via Wayland


Session File Location
═════════════════════
/usr/share/wayland-sessions/hyprland.desktop
/usr/share/xsessions/            ← X11 sessions
~/.config/hypr/hyprland.conf     ← User config
~/.config/hypr/hyprpaper.conf    ← Wallpaper
~/.config/waybar/config          ← Status bar
```

### Hyprland Features

```
┌─────────────────────────────────────────────────────────────┐
│              HYPRLAND KEY FEATURES                          │
└─────────────────────────────────────────────────────────────┘

1. TILING LAYOUTS
   ═════════════
   
   Master Layout
   ┌─────────┬─────┐
   │         │  2  │
   │    1    ├─────┤
   │ Master  │  3  │
   │         ├─────┤
   │         │  4  │
   └─────────┴─────┘
   
   Dwindle (Fibonacci)
   ┌─────────────────┐
   │  1    │    3    │
   │       ├────┬────┤
   │       │ 2  │ 4  │
   └───────┴────┴────┘


2. ANIMATIONS & EFFECTS
   ════════════════════
   
   • Window open/close animations
   • Workspace switching (slide/fade)
   • Border animations
   • Blur effects
   • Shadow effects
   • Rounded corners
   • Custom bezier curves
   
   animation=windows,1,7,default,slide
   animation=workspaces,1,6,default,slide


3. WORKSPACES
   ═══════════
   
   Traditional (per monitor)
   Monitor 1: [1] [2] [3] [4] [5]
   Monitor 2: [6] [7] [8] [9] [10]
   
   Special Workspaces (scratchpad)
   [special:term] - Hidden terminal
   [special:music] - Music player


4. IPC & SCRIPTING
   ═══════════════
   
   hyprctl commands:
   • hyprctl dispatch workspace 3
   • hyprctl clients (list windows)
   • hyprctl monitors (display info)
   • hyprctl keyword decoration:blur 1
   
   Unix Socket: /tmp/hypr/$INSTANCE/.socket.sock


5. INPUT HANDLING
   ══════════════
   
   • Per-device configuration
   • Touchpad gestures
   • Tablet support
   • Custom sensitivity curves
   • Keybind submaps
```

---

## Architecture Comparison

### X11 vs Wayland Stack

```
┌─────────────────────────────────────────────────────────────┐
│         COMPLETE ARCHITECTURE COMPARISON                    │
└─────────────────────────────────────────────────────────────┘

TRADITIONAL X11 STACK (Arch Linux Example)
═══════════════════════════════════════════

Layer 7: User Applications
┌────────────────────────────────────────────────────┐
│ Firefox │ Neovim │ Kitty │ Discord │ Spotify      │
└───────────────────────┬────────────────────────────┘
                        │ X11 Protocol (Xlib/XCB)
                        │
Layer 6: Window Manager & Compositor
┌───────────────────────┴────────────────────────────┐
│ i3-wm (tiling)     │     picom (compositing)       │
└───────────────────────┬────────────────────────────┘
                        │
Layer 5: X Display Server
┌───────────────────────┴────────────────────────────┐
│              Xorg Server (X.Org)                   │
│  • Event handling                                  │
│  • Window management coordination                  │
│  • Drawing primitives                              │
└───────────────────────┬────────────────────────────┘
                        │
Layer 4: Graphics Drivers
┌───────────────────────┴────────────────────────────┐
│  xf86-video-amdgpu  │  xf86-video-intel           │
└───────────────────────┬────────────────────────────┘
                        │
Layer 3: DRM/KMS (Direct Rendering Manager)
┌───────────────────────┴────────────────────────────┐
│           Linux Kernel Graphics Stack              │
└───────────────────────┬────────────────────────────┘
                        │
Layer 2: Hardware Abstraction
┌───────────────────────┴────────────────────────────┐
│  Mesa (OpenGL/Vulkan)  │  libdrm                   │
└───────────────────────┬────────────────────────────┘
                        │
Layer 1: Hardware
┌───────────────────────┴────────────────────────────┐
│         GPU (AMD/NVIDIA/Intel)                     │
└────────────────────────────────────────────────────┘


MODERN WAYLAND STACK (Arch + Hyprland)
═══════════════════════════════════════

Layer 5: User Applications
┌────────────────────────────────────────────────────┐
│ Firefox │ Neovim │ Kitty │ Waybar │ wofi          │
└───────────────────────┬────────────────────────────┘
                        │ Wayland Protocol
                        │
Layer 4: Wayland Compositor (All-in-One)
┌───────────────────────┴────────────────────────────┐
│              Hyprland Compositor                   │
│  ┌──────────────────────────────────────────────┐ │
│  │ Window Manager (tiling logic)               │ │
│  ├──────────────────────────────────────────────┤ │
│  │ Compositor (rendering, effects)              │ │
│  ├──────────────────────────────────────────────┤ │
│  │ Display Server (Wayland protocol)            │ │
│  ├──────────────────────────────────────────────┤ │
│  │ Input Manager (keyboard, mouse)              │ │
│  └──────────────────────────────────────────────┘ │
└───────────────────────┬────────────────────────────┘
                        │ Built on wlroots
                        │
Layer 3: wlroots Library
┌───────────────────────┴────────────────────────────┐
│  • Wayland protocol implementation                 │
│  • DRM/KMS interface                               │
│  • libinput integration                            │
│  • Renderer (OpenGL/Vulkan)                        │
└───────────────────────┬────────────────────────────┘
                        │
Layer 2: Kernel & Mesa
┌───────────────────────┴────────────────────────────┐
│  Linux Kernel DRM  │  Mesa (OpenGL/Vulkan)         │
└───────────────────────┬────────────────────────────┘
                        │
Layer 1: Hardware
┌───────────────────────┴────────────────────────────┐
│         GPU (AMD/NVIDIA/Intel)                     │
└────────────────────────────────────────────────────┘


LAYER REDUCTION VISUALIZATION
══════════════════════════════

X11 Stack:        Wayland Stack:
7 layers          5 layers
                  
┌──────┐          ┌──────┐
│ Apps │          │ Apps │
├──────┤          ├──────┤
│  WM  │          │      │
├──────┤          │Hypr- │ ← Combined
│ Comp │          │ land │
├──────┤          │      │
│ Xorg │          │      │
├──────┤          ├──────┤
│Driver│          │wlroot│
├──────┤          ├──────┤
│ DRM  │          │ DRM  │
├──────┤          ├──────┤
│ Mesa │          │ Mesa │
├──────┤          ├──────┤
│  GPU │          │  GPU │
└──────┘          └──────┘
```

### Performance Comparison

```
┌─────────────────────────────────────────────────────────────┐
│           PERFORMANCE METRICS                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Metric              │  X11 + i3    │  Hyprland (Wayland) │
│  ────────────────────┼──────────────┼──────────────────────│
│  Input Latency       │  ~15-30ms    │  ~8-15ms             │
│  Frame Latency       │  ~20-40ms    │  ~10-20ms            │
│  Screen Tearing      │  Yes (needs  │  No (sync by default)│
│                      │  compositor) │                      │
│  Security Isolation  │  Poor        │  Strong              │
│  HiDPI Support       │  Hacky       │  Native              │
│  Multi-monitor       │  Complex     │  Simpler             │
│  Memory Usage        │  ~50-100MB   │  ~40-80MB            │
│  CPU Usage (idle)    │  0.5-1%      │  0.3-0.8%            │
│                                                             │
└─────────────────────────────────────────────────────────────┘


Frame Rendering Path
════════════════════

X11 Workflow:
App → Xorg → Compositor → GPU  (3 steps)
 ↓     ↓        ↓
Buffer copies happen multiple times

Wayland Workflow:
App → Hyprland → GPU  (2 steps)
 ↓        ↓
Direct buffer sharing (zero-copy)
```

---

## Configuration & Setup

### Hyprland Configuration Structure

```
┌─────────────────────────────────────────────────────────────┐
│         HYPRLAND CONFIGURATION FILES                        │
└─────────────────────────────────────────────────────────────┘

~/.config/hypr/
├── hyprland.conf          ← Main config file
├── hyprpaper.conf         ← Wallpaper daemon
├── autostart.sh           ← Startup script (optional)
└── scripts/
    ├── screenshot.sh      ← Custom scripts
    └── volume.sh


Key Configuration Sections
═══════════════════════════

monitor    - Display configuration
input      - Keyboard, mouse, touchpad
general    - Border, gaps, layout
decoration - Blur, shadows, rounding
animations - Window/workspace transitions
dwindle    - Dwindle layout settings
master     - Master layout settings
bind       - Keybindings
windowrule - Per-window rules
exec-once  - Autostart applications
```

### Sample Configuration

```bash
# ~/.config/hypr/hyprland.conf

# ===== MONITOR SETUP =====
monitor=eDP-1,1920x1080@60,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1

# ===== AUTOSTART =====
exec-once = waybar &
exec-once = hyprpaper &
exec-once = dunst &
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# ===== INPUT =====
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =
    
    follow_mouse = 1
    sensitivity = 0 # -1.0 to 1.0
    
    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        disable_while_typing = yes
    }
}

# ===== GENERAL =====
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    
    layout = dwindle
}

# ===== DECORATION =====
decoration {
    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
        new_optimizations = true
    }
    
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# ===== ANIMATIONS =====
animations {
    enabled = yes
    
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# ===== LAYOUTS =====
dwindle {
    pseudotile = yes
    preserve_split = yes
}

master {
    new_is_master = true
}

# ===== KEYBINDINGS =====
$mainMod = SUPER

# Applications
bind = $mainMod, RETURN, exec, kitty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Vim-style focus
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5

# Move window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5

# Special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Mouse bindings
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# ===== WINDOW RULES =====
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$
windowrule = opacity 0.9 override 0.9 override, ^(kitty)$
windowrule = workspace 2, ^(firefox)$
windowrule = workspace 3, ^(discord)$
```

### IPC Control (hyprctl)

```
┌─────────────────────────────────────────────────────────────┐
│              HYPRCTL COMMAND REFERENCE                      │
└─────────────────────────────────────────────────────────────┘

# Get information
hyprctl monitors                 # List displays
hy
```