# 🚢 LINUX STORAGE MASTER CHEATSHEET 🚢
*Quick reference for disk management, filesystems, and boot configuration*

---

## 📦 DISK DISCOVERY

```bash
# Quick Overview
lsblk                          # Tree view of all disks/partitions
lsblk -f                       # Add filesystem type and UUID
df -h                          # Space usage (human readable)
sudo fdisk -l                  # Detailed disk listing

# Detailed Info
sudo parted -l                 # GNU parted listing
blkid                          # UUIDs and filesystem types
lshw -class disk               # Hardware information
smartctl -a /dev/sda          # Disk health (SMART)
```

---

## 💾 SPACE ANALYSIS

```bash
# Directory Size
du -sh /path/*                 # Size of each item in directory
du -h --max-depth=1 / | sort -hr | head -20  # Top 20 largest dirs
ncdu /                         # Interactive disk usage (best!)

# Filesystem Space
df -h                          # All filesystems
df -h /                        # Root filesystem only
df -i                          # Inode (file count) usage

# Find Large Files
find / -type f -size +1G 2>/dev/null         # Files > 1GB
find /home -type f -size +500M -exec ls -lh {} \;
```

---

## 🔧 PARTITIONING

```bash
# Check Partition Table Type
lsblk -d -o NAME,PTTYPE        # MBR or GPT?
sudo parted /dev/sda print | grep "Partition Table"

# Interactive Partitioning
sudo fdisk /dev/sda            # MBR partitions
sudo gdisk /dev/sda            # GPT partitions
sudo cfdisk /dev/sda           # Curses-based (user-friendly)
sudo parted /dev/sda           # GNU parted

# GUI Tools (from live USB)
sudo gparted                   # GNOME partition editor
```

### FDISK Quick Commands
```
p    - Print partition table
n    - New partition
d    - Delete partition
t    - Change partition type
w    - Write changes and exit
q    - Quit without saving
```

---

## 📂 FILESYSTEM OPERATIONS

```bash
# Create Filesystems
sudo mkfs.ext4 /dev/sda2       # Ext4
sudo mkfs.btrfs /dev/sda3      # Btrfs
sudo mkfs.xfs /dev/sda4        # XFS
sudo mkfs.fat -F32 /dev/sda1   # FAT32 (for /boot)

# Check Filesystem Type
lsblk -f
df -T
file -sL /dev/sda2

# Filesystem Check/Repair (UNMOUNT FIRST!)
sudo e2fsck -f /dev/sda2       # Ext4
sudo xfs_repair /dev/sda4      # XFS
sudo btrfs check /dev/sda3     # Btrfs

# Resize Filesystems
sudo resize2fs /dev/sda2       # Ext4 (after partition resize)
sudo xfs_growfs /mnt           # XFS (while MOUNTED)
sudo btrfs filesystem resize max /mnt  # Btrfs
```

---

## 🎛️ LVM (LOGICAL VOLUME MANAGER)

```bash
# Check LVM Status
lvs                            # List logical volumes
vgs                            # List volume groups
pvs                            # List physical volumes
sudo pvdisplay                 # Detailed PV info

# Extend Logical Volume
sudo lvextend -L +20G /dev/vg0/root          # Add 20GB
sudo lvextend -l +100%FREE /dev/vg0/root     # Use all free space
sudo resize2fs /dev/vg0/root                 # Resize filesystem
# OR ONE-LINER:
sudo lvextend -r -L +20G /dev/vg0/root       # Extend + resize

# Reduce Logical Volume (⚠️ DANGEROUS!)
sudo resize2fs /dev/vg0/home 100G            # Shrink filesystem first
sudo lvreduce -L 100G /dev/vg0/home          # Then reduce LV

# Create New LV
sudo lvcreate -L 50G -n newvol vg0           # 50GB volume
sudo mkfs.ext4 /dev/vg0/newvol
```

---

## 💧 SWAP MANAGEMENT

```bash
# Check Swap
swapon --show                  # Current swap devices
free -h                        # RAM + swap usage

# Create Swap File (8GB example)
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab

# Create Swap Partition
sudo mkswap /dev/sda3
sudo swapon /dev/sda3
# Add to /etc/fstab: /dev/sda3 none swap defaults 0 0

# Tune Swappiness (0-100, lower = less swap)
sudo sysctl vm.swappiness=10
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Remove Swap
sudo swapoff /swapfile
sudo rm /swapfile
# Remove line from /etc/fstab
```

---

## 🚀 BOOTLOADER (GRUB)

```bash
# Install GRUB
sudo grub-install /dev/sda     # BIOS
sudo grub-install --target=x86_64-efi --efi-directory=/boot \
  --bootloader-id=GRUB         # UEFI

# Update GRUB Config
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo update-grub               # Debian/Ubuntu shortcut

# Edit GRUB Settings
sudo nano /etc/default/grub
# Common settings:
# GRUB_TIMEOUT=5
# GRUB_DEFAULT=0
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
# GRUB_GFXMODE=1920x1080

# GRUB Rescue Mode
grub rescue> ls                           # List partitions
grub rescue> set root=(hd0,gpt2)         # Set root partition
grub rescue> insmod normal
grub rescue> normal

# Reinstall GRUB (if broken)
sudo mount /dev/sda2 /mnt
sudo mount /dev/sda1 /mnt/boot
sudo arch-chroot /mnt
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
```

---

## 🗺️ PARTITION TABLE CONVERSION

```bash
# Convert MBR to GPT (⚠️ BACKUP FIRST!)
sudo gdisk /dev/sda
  r      # Recovery menu
  g      # Convert to GPT
  w      # Write changes

# OR using sgdisk:
sudo sgdisk -g /dev/sda

# After conversion, reinstall bootloader:
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi \
  --bootloader-id=GRUB /dev/sda
```

---

## 🧹 DISK CLEANUP (ARCH LINUX)

```bash
# Pacman Cache
sudo pacman -Sc                # Remove uninstalled packages
sudo pacman -Scc               # Remove ALL cached packages

# Orphaned Packages
sudo pacman -Rns $(pacman -Qtdq)

# Journal Logs
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=2weeks

# Old Kernels
sudo pacman -Rns $(pacman -Qq | grep '^linux' | grep -v $(uname -r | cut -d- -f1))

# AUR Build Cache
sudo rm -rf ~/.cache/yay/
sudo rm -rf /tmp/makepkg*

# Docker
docker system prune -a

# Temporary Files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Find Large Files
sudo find / -type f -size +1G 2>/dev/null
```

---

## 📊 FILESYSTEM COMPARISON

| Filesystem | Max File | Max FS   | Snapshots | Compression | Best For        |
|------------|----------|----------|-----------|-------------|-----------------|
| **ext4**   | 16 TB    | 1 EB     | ✗         | ✗           | General purpose |
| **btrfs**  | 16 EB    | 16 EB    | ✓         | ✓           | Modern desktop  |
| **xfs**    | 8 EB     | 8 EB     | ✗         | ✗           | Large files     |
| **f2fs**   | 3.94 TB  | 16 TB    | ✗         | ✗           | Flash/SSD       |
| **zfs**    | 16 EB    | 256 ZB   | ✓         | ✓           | Servers/NAS     |

---

## 🎯 COMMON SCENARIOS

### "My root partition is 96% full!"
```bash
# 1. Find what's eating space
sudo ncdu /
sudo du -sh /* | sort -hr | head -10

# 2. Clean up
sudo pacman -Sc                    # Clear pacman cache
sudo journalctl --vacuum-size=50M  # Trim logs
sudo rm -rf ~/.cache/*             # Clear user cache

# 3. If still full, resize partition (see partitioning section)
```

### "I want to resize my root partition"
```bash
# NON-LVM:
# 1. Boot from live USB
# 2. sudo gparted
# 3. Resize/Move partitions
# 4. Apply changes

# LVM:
sudo lvextend -r -L +20G /dev/vg0/root  # Add 20GB
```

### "I need to create a swap file"
```bash
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
```

### "GRUB broke after update"
```bash
# Boot from Arch USB
sudo mount /dev/sda2 /mnt          # Root partition
sudo mount /dev/sda1 /mnt/boot     # Boot partition
sudo arch-chroot /mnt
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
reboot
```

---

## ⚠️ GOLDEN RULES

1. **ALWAYS BACKUP BEFORE RESIZING/CONVERTING**
2. Unmount filesystems before checking/repairing
3. Know your partition table type (MBR vs GPT)
4. Use LVM for easy resizing
5. Swap file > swap partition (easier to resize)
6. Read `man` pages when unsure: `man lsblk`

---

## 🔗 USEFUL RESOURCES

- ArchWiki: https://wiki.archlinux.org/
- GRUB Manual: https://www.gnu.org/software/grub/manual/
- LVM Guide: https://wiki.archlinux.org/title/LVM
- Btrfs Wiki: https://btrfs.wiki.kernel.org/

---

**Created with ⚓ by the SS Arch Linux**
*Last updated: January 2026*