---
title:
  "{ Title }":
tags:
  - DevOps
  - k8s
created:
  "{ date }":
updated:
  "{ date }":
---
## Understanding the Architecture

### What is Kubeadm?

Kubeadm is a tool that helps you bootstrap a production-grade Kubernetes cluster. Unlike Minikube (single-node, automated) or Kind (Docker-based, simulated multi-node), kubeadm creates a **real, distributed multi-machine cluster**.

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          AWS VPC                                 │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              CONTROL PLANE (MASTER NODE)                   │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │  Control Plane Components (Static Pods)             │  │ │
│  │  │  ├─ kube-apiserver (Port 6443)                      │  │ │
│  │  │  ├─ etcd (Cluster Database)                         │  │ │
│  │  │  ├─ kube-scheduler                                   │  │ │
│  │  │  └─ kube-controller-manager                          │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │  Node Components                                      │  │ │
│  │  │  ├─ kubelet (Port 10250)                             │  │ │
│  │  │  └─ containerd (Container Runtime)                   │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                  WORKER NODE 1                             │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │  ├─ kubelet (Port 10250)                             │  │ │
│  │  │  ├─ containerd (Container Runtime)                   │  │ │
│  │  │  └─ Pods (Your Applications)                         │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                  WORKER NODE 2                             │ │
│  │  ┌──────────────────────────────────────────────────────┐  │ │
│  │  │  ├─ kubelet (Port 10250)                             │  │ │
│  │  │  ├─ containerd (Container Runtime)                   │  │ │
│  │  │  └─ Pods (Your Applications)                         │  │ │
│  │  └──────────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Differences from Minikube and Kind

|Feature|Kubeadm|Minikube|Kind|
|---|---|---|---|
|**Setup Complexity**|Manual (You install everything)|Automated|Automated|
|**Container Runtime**|You install (containerd/Docker)|Pre-installed|Uses host Docker|
|**Multi-Node**|Real separate machines|Single VM|Simulated (Docker containers)|
|**Production Use**|Yes|No (dev only)|No (testing only)|
|**Networking**|You install CNI plugin|Pre-configured|Pre-configured|
|**Resource Usage**|Multiple VMs/machines|Single VM|Single machine|

**Why Manual Setup?**

- Production environments need customization
- You control every component
- Understanding how Kubernetes actually works
- Security and compliance requirements

---

## Prerequisites

### Hardware Requirements

|Component|Minimum|Recommended|
|---|---|---|
|**Master Node**|t2.medium (2 vCPU, 4GB RAM)|t2.large (2 vCPU, 8GB RAM)|
|**Worker Nodes**|t2.small (1 vCPU, 2GB RAM)|t2.medium (2 vCPU, 4GB RAM)|
|**Disk Space**|20GB|40GB+|

### Software Requirements

- Ubuntu 20.04 LTS or later (Xenial or newer)
- Root/sudo access on all nodes
- Internet connectivity
- Unique hostname for each node
- Unique MAC address for each node

### Why These Requirements?

- **t2.medium for master**: etcd + API server are memory-intensive
- **Ubuntu Xenial+**: Systemd support (required by kubelet)
- **Root access**: Kubernetes modifies kernel parameters, iptables, system services
- **Unique hostnames**: Cluster identification and node registration
- **Internet**: Download container images and Kubernetes components

---

## Setup Flow Diagram

```
START
  │
  ├─→ AWS Infrastructure Setup (All Nodes)
  │    ├─→ Create Security Group
  │    ├─→ Configure Inbound Rules
  │    └─→ Launch EC2 Instances
  │
  ├─→ Common Setup (All Nodes: Master + Workers)
  │    ├─→ Disable Swap
  │    ├─→ Load Kernel Modules
  │    ├─→ Configure Sysctl Parameters
  │    ├─→ Install Container Runtime (containerd)
  │    └─→ Install Kubernetes Components (kubelet, kubeadm, kubectl)
  │
  ├─→ Master Node Only Setup
  │    ├─→ Initialize Cluster (kubeadm init)
  │    ├─→ Configure kubectl
  │    ├─→ Install Network Plugin (Calico)
  │    └─→ Generate Join Command
  │
  └─→ Worker Nodes Only Setup
       ├─→ Reset Previous Configurations
       └─→ Join Cluster (kubeadm join)
```

---

## STEP 1: AWS Infrastructure Setup

### 1.1 Create Security Group

**Purpose**: Control network traffic to your Kubernetes cluster

**Steps**:

1. Login to AWS Console → EC2 Dashboard
2. Navigate to: **Network & Security** → **Security Groups**
3. Click: **Create Security Group**

**Configuration**:

```
Name: Kubernetes-Cluster-SG
Description: Security group for Kubernetes cluster nodes
VPC: Select your VPC (default is fine)
```

### 1.2 Configure Inbound Rules

**Required Ports Explanation**:

|Port|Component|Purpose|Source|
|---|---|---|---|
|22|SSH|Remote management|Your IP or 0.0.0.0/0|
|6443|kube-apiserver|API server communication|Same SG or VPC CIDR|
|10250|kubelet|Kubelet API|Same SG|
|10259|kube-scheduler|Scheduler health check|Same SG|
|10257|kube-controller-manager|Controller health check|Same SG|
|2379-2380|etcd|etcd server client API|Same SG|
|30000-32767|NodePort Services|External service access|0.0.0.0/0 (optional)|

**Configure Rules**:

**Rule 1 - SSH Access**:

```
Type: SSH
Protocol: TCP
Port Range: 22
Source: 0.0.0.0/0 (or your specific IP for security)
Description: SSH access for management
```

**Rule 2 - Kubernetes API Server**:

```
Type: Custom TCP
Protocol: TCP
Port Range: 6443
Source: Same Security Group ID (sg-xxxxx)
Description: Kubernetes API server
```

**Rule 3 - Kubelet API**:

```
Type: Custom TCP
Protocol: TCP
Port Range: 10250
Source: Same Security Group ID
Description: Kubelet API
```

**Rule 4 - etcd**:

```
Type: Custom TCP
Protocol: TCP
Port Range: 2379-2380
Source: Same Security Group ID
Description: etcd server client API
```

**Rule 5 - NodePort Services (Optional)**:

```
Type: Custom TCP
Protocol: TCP
Port Range: 30000-32767
Source: 0.0.0.0/0
Description: NodePort Services
```

### 1.3 Launch EC2 Instances

**Master Node**:

```
AMI: Ubuntu 20.04 LTS
Instance Type: t2.medium
Storage: 20GB+ gp3
Security Group: Kubernetes-Cluster-SG
Tag Name: k8s-master
```

**Worker Nodes** (repeat for each worker):

```
AMI: Ubuntu 20.04 LTS
Instance Type: t2.small or t2.medium
Storage: 20GB+ gp3
Security Group: Kubernetes-Cluster-SG
Tag Name: k8s-worker-1, k8s-worker-2, etc.
```

**Important**: Note down the **private IP addresses** of all instances.

---

## STEP 2: Common Setup (Execute on ALL Nodes)

> **Critical**: Run these commands as root or with sudo on BOTH Master and Worker nodes

### 2.1 Disable Swap

**Why**: Kubernetes requires swap to be disabled because:

- kubelet refuses to start if swap is enabled
- Memory management conflicts with cgroups
- Unpredictable pod performance

**Command**:

```bash
sudo swapoff -a
```

**Explanation**:

- `swapoff -a` disables all swap devices temporarily
- Changes revert after reboot

**Make Permanent**:

```bash
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

**Explanation**:

- `sed` edits `/etc/fstab` file
- Comments out any line containing "swap"
- Prevents swap from re-enabling on reboot

**Verify**:

```bash
free -h
```

Look for "Swap: 0B" in output

---

### 2.2 Load Kernel Modules

**Why**: Kubernetes networking requires specific kernel modules:

- **overlay**: Container filesystem driver
- **br_netfilter**: Bridge netfilter for iptables rules on bridge traffic

**Step 1: Create Module Configuration**:

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

**Explanation**:

- Creates file `/etc/modules-load.d/k8s.conf`
- Ensures modules load automatically on boot
- `tee` writes to file while displaying output

**Step 2: Load Modules Immediately**:

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

**Explanation**:

- `modprobe` loads kernel modules
- Takes effect immediately without reboot

**Step 3: Verify Modules Loaded**:

```bash
lsmod | grep br_netfilter
lsmod | grep overlay
```

**Expected Output**:

```
br_netfilter           28672  0
overlay               151552  0
```

---

### 2.3 Configure Sysctl Parameters

**Why**: Configure kernel networking parameters for Kubernetes:

**Parameters Explained**:

```
net.bridge.bridge-nf-call-iptables  = 1
→ Allow iptables to process bridge traffic (Pod networking)

net.bridge.bridge-nf-call-ip6tables = 1
→ Allow ip6tables for IPv6 bridge traffic

net.ipv4.ip_forward = 1
→ Enable IP forwarding (required for pod-to-pod communication)
```

**Step 1: Create Sysctl Configuration**:

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```

**Step 2: Apply Settings**:

```bash
sudo sysctl --system
```

**Explanation**:

- Reloads all sysctl configuration files
- Applies changes immediately

**Step 3: Verify Settings**:

```bash
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
sysctl net.ipv4.ip_forward
```

**Expected Output**:

```
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
```

---

### 2.4 Install Container Runtime (containerd)

**Why containerd?**

- Kubernetes removed native Docker support (v1.24+)
- containerd is CRI (Container Runtime Interface) compliant
- Lighter and more efficient than Docker
- Industry standard for Kubernetes

**Installation Flow**:

```
Update System → Add Docker GPG Key → Add Docker Repository → Install containerd → Configure containerd → Restart Service
```

**Step 1: Update Package Index**:

```bash
sudo apt-get update
```

**Step 2: Install Prerequisites**:

```bash
sudo apt-get install -y ca-certificates curl
```

**Explanation**:

- `ca-certificates`: SSL/TLS certificate verification
- `curl`: Download files from internet

**Step 3: Create Keyrings Directory**:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

**Explanation**:

- Creates directory for GPG keys
- `0755` = read/execute for all, write for owner

**Step 4: Download Docker GPG Key**:

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
```

**Explanation**:

- Downloads Docker's official GPG key
- `-fsSL`: fail silently, silent, show error, follow redirects

**Step 5: Set Key Permissions**:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

**Explanation**:

- Makes key readable by all users
- Required for apt to verify packages

**Step 6: Add Docker Repository**:

```bash
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

**Explanation**:

- `$(dpkg --print-architecture)`: Gets system architecture (amd64, arm64)
- `$VERSION_CODENAME`: Ubuntu version codename (focal, jammy)
- Adds Docker repository to apt sources

**Step 7: Update Package Index Again**:

```bash
sudo apt-get update
```

**Step 8: Install containerd**:

```bash
sudo apt-get install -y containerd.io
```

**Step 9: Configure containerd for Kubernetes**:

```bash
containerd config default | \
sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' \
-e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' | \
sudo tee /etc/containerd/config.toml
```

**Critical Configuration Explained**:

**SystemdCgroup = true**:

- kubelet uses systemd as cgroup driver
- containerd must match this
- **Mismatch causes**: NodeNotReady, pod failures

**sandbox_image = "registry.k8s.io/pause:3.9"**:

- Updates pause container image
- Pause container holds network namespace for pod
- Version match ensures compatibility

**Step 10: Restart containerd**:

```bash
sudo systemctl restart containerd
```

**Step 11: Verify containerd Running**:

```bash
sudo systemctl status containerd
```

**Expected Output**:

```
● containerd.service - containerd container runtime
   Loaded: loaded (/lib/systemd/system/containerd.service; enabled)
   Active: active (running) since ...
```

---

### 2.5 Install Kubernetes Components

**Components to Install**:

- **kubelet**: Node agent that runs on each node
- **kubeadm**: Tool to bootstrap cluster
- **kubectl**: Command-line tool to interact with cluster

**Installation Flow**:

```
Update System → Add Kubernetes GPG Key → Add Kubernetes Repository → Install Components → Hold Versions
```

**Step 1: Install Prerequisites**:

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```

**Explanation**:

- `apt-transport-https`: Download packages over HTTPS
- `gpg`: GNU Privacy Guard for key management

**Step 2: Download Kubernetes GPG Key**:

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

**Explanation**:

- Downloads Kubernetes v1.29 repository key
- `gpg --dearmor`: Converts ASCII key to binary format
- Stores in `/etc/apt/keyrings/`

**Step 3: Add Kubernetes Repository**:

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list
```

**Explanation**:

- Adds Kubernetes v1.29 repository
- `signed-by`: Specifies GPG key for verification

**Step 4: Update Package Index**:

```bash
sudo apt-get update
```

**Step 5: Install Kubernetes Components**:

```bash
sudo apt-get install -y kubelet kubeadm kubectl
```

**Component Roles**:

- **kubelet**: Runs on every node, manages pods and containers
- **kubeadm**: Initializes and manages cluster
- **kubectl**: CLI for cluster management (optional on workers)

**Step 6: Hold Package Versions**:

```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

**Why Hold Versions?**

- Prevents automatic updates
- Cluster components must be same version
- Manual upgrade control
- Avoids version mismatch issues

**Verify Installation**:

```bash
kubeadm version
kubelet --version
kubectl version --client
```

**Expected Output**:

```
kubeadm version: v1.29.x
kubelet version: v1.29.x
kubectl version: v1.29.x
```

---

## STEP 3: Master Node Only Setup

> **Important**: Execute these commands ONLY on the Master Node

### 3.1 Initialize Kubernetes Cluster

**Command**:

```bash
sudo kubeadm init
```

**What Happens Internally** (Detailed Breakdown):

```
┌─────────────────────────────────────────────────────────────┐
│  PHASE 1: Pre-flight Checks                                 │
│  ├─ Check if running as root                                │
│  ├─ Verify system requirements (CPU, memory)                │
│  ├─ Check swap is disabled                                  │
│  ├─ Verify required ports are available (6443, 10250, etc.) │
│  ├─ Check containerd is running                             │
│  └─ Validate kubelet version compatibility                  │
└─────────────────────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────────────────────┐
│  PHASE 2: Generate Certificates                             │
│  ├─ Create Certificate Authority (CA)                       │
│  ├─ Generate API server certificate                         │
│  ├─ Generate controller-manager certificate                 │
│  ├─ Generate scheduler certificate                          │
│  ├─ Generate kubelet client certificate                     │
│  └─ Store in /etc/kubernetes/pki/                           │
└─────────────────────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────────────────────┐
│  PHASE 3: Generate kubeconfig Files                         │
│  ├─ admin.conf (cluster admin credentials)                  │
│  ├─ kubelet.conf (kubelet credentials)                      │
│  ├─ controller-manager.conf                                 │
│  ├─ scheduler.conf                                          │
│  └─ Store in /etc/kubernetes/                               │
└─────────────────────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────────────────────┐
│  PHASE 4: Start Control Plane Components (Static Pods)     │
│  ├─ etcd (cluster database)                                 │
│  ├─ kube-apiserver (Port 6443)                              │
│  ├─ kube-controller-manager                                 │
│  └─ kube-scheduler                                          │
│  Location: /etc/kubernetes/manifests/                       │
└─────────────────────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────────────────────┐
│  PHASE 5: Mark Control Plane Node                          │
│  ├─ Add node to cluster                                     │
│  ├─ Label as control-plane                                  │
│  └─ Taint to prevent pod scheduling (by default)            │
└─────────────────────────────────────────────────────────────┘
        ↓
┌─────────────────────────────────────────────────────────────┐
│  PHASE 6: Generate Bootstrap Token                          │
│  ├─ Create token for worker nodes to join                   │
│  ├─ Token valid for 24 hours                                │
│  └─ Generate join command                                   │
└─────────────────────────────────────────────────────────────┘
```

**Expected Output**:

```
[init] Using Kubernetes version: v1.29.x
[preflight] Running pre-flight checks
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
...
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd
[wait-control-plane] Waiting for the kubelet to boot up the control plane
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf"
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!
```

**Important Files Created**:

```
/etc/kubernetes/
├── admin.conf              # Cluster admin credentials
├── kubelet.conf            # Kubelet credentials
├── controller-manager.conf
├── scheduler.conf
├── manifests/              # Static pod definitions
│   ├── etcd.yaml
│   ├── kube-apiserver.yaml
│   ├── kube-controller-manager.yaml
│   └── kube-scheduler.yaml
└── pki/                    # TLS certificates
    ├── ca.crt
    ├── ca.key
    └── ...
```

---

### 3.2 Configure kubectl Access

**Why**: kubectl needs credentials to communicate with API server

**Step 1: Create .kube Directory**:

```bash
mkdir -p "$HOME"/.kube
```

**Explanation**:

- Creates hidden directory in user's home
- `-p`: creates parent directories if needed
- `$HOME`: environment variable for home directory

**Step 2: Copy Admin Configuration**:

```bash
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
```

**Explanation**:

- Copies cluster admin credentials
- `-i`: prompts before overwriting existing file
- `admin.conf`: full cluster administrator access

**Step 3: Change File Ownership**:

```bash
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
```

**Explanation**:

- `$(id -u)`: current user's UID
- `$(id -g)`: current user's GID
- Makes file owned by current user (not root)

**Verify Configuration**:

```bash
kubectl cluster-info
```

**Expected Output**:

```
Kubernetes control plane is running at https://<master-ip>:6443
CoreDNS is running at https://<master-ip>:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

**Check Node Status** (will be NotReady until CNI installed):

```bash
kubectl get nodes
```

**Expected Output**:

```
NAME         STATUS     ROLES           AGE   VERSION
k8s-master   NotReady   control-plane   1m    v1.29.x
```

---

### 3.3 Install Network Plugin (Calico CNI)

**Why Network Plugin is Mandatory**:

Without CNI plugin:

- Nodes remain in "NotReady" state
- Pods cannot communicate with each other
- Services don't work
- DNS resolution fails
- Cluster is non-functional

**What is CNI (Container Network Interface)?**

- Creates virtual network for pods
- Assigns IP addresses to pods
- Enables pod-to-pod communication across nodes
- Implements Network Policies

**Why Calico?**

- Production-grade networking
- Supports Network Policies
- Good performance
- Wide adoption
- Works with kubeadm out-of-the-box

**Command**:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
```

**What Gets Installed**:

```
┌─────────────────────────────────────────────────────────────┐
│  Calico Components                                           │
│  ├─ calico-node (DaemonSet - runs on every node)            │
│  │   ├─ Manages pod networking                              │
│  │   ├─ Configures routing                                  │
│  │   └─ Enforces network policies                           │
│  │                                                           │
│  ├─ calico-typha (Deployment - API proxy)                   │
│  │   └─ Reduces load on Kubernetes API                      │
│  │                                                           │
│  └─ calico-kube-controllers (Deployment)                    │
│      └─ Watches Kubernetes resources                        │
└─────────────────────────────────────────────────────────────┘
```

**Verify Installation**:

```bash
kubectl get pods -n kube-system
```

**Expected Output** (wait for all pods to be Running):

```
NAME                                       READY   STATUS    RESTARTS   AGE
calico-kube-controllers-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
calico-node-xxxxx                          1/1     Running   0          1m
coredns-xxxxxxxxxx-xxxxx                   1/1     Running   0          5m
coredns-xxxxxxxxxx-xxxxx                   1/1     Running   0          5m
etcd-k8s-master                            1/1     Running   0          5m
kube-apiserver-k8s-master                  1/1     Running   0          5m
kube-controller-manager-k8s-master         1/1     Running   0          5m
kube-proxy-xxxxx                           1/1     Running   0          5m
kube-scheduler-k8s-master                  1/1     Running   0          5m
```

**Check Node Status Again**:

```bash
kubectl get nodes
```

**Expected Output** (Status changes to Ready):

```
NAME         STATUS   ROLES           AGE   VERSION
k8s-master   Ready    control-plane   5m    v1.29.x
```

---

### 3.4 Generate Join Command for Worker Nodes

**Command**:

```bash
kubeadm token create --print-join-command
```

**What This Does**:

- Creates a new bootstrap token (valid for 24 hours)
- Generates complete join command with token and CA cert hash
- Prints command that worker nodes will use

**Example Output**:

```bash
kubeadm join 172.31.10.15:6443 --token abcdef.1234567890abcdef \
--discovery-token-ca-cert-hash sha256:1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
```

**Command Breakdown**:

- `172.31.10.15:6443`: Master node's private IP and API server port
- `--token`: Authentication token for joining
- `--discovery-token-ca-cert-hash`: Verifies API server's CA certificate

**Important**:

- Save this entire command
- You'll need it for worker nodes
- Token expires in 24 hours
- Generate new token if expired: `kubeadm token create --print-join-command`

---

## STEP 4: Worker Nodes Only Setup

> **Important**: Execute these commands ONLY on Worker Nodes

### 4.1 Reset Previous Kubeadm Configurations (If Any)

**Why**: Ensures clean state before joining

**Command**:

```bash
sudo kubeadm reset pre-flight checks
```

**What This Does**:

- Removes previous kubeadm configurations
- Cleans up kubernetes directories
- Stops kubelet service
- Safe to run even on fresh nodes

---

### 4.2 Join Worker Node to Cluster

**Command Template**:

```bash
sudo kubeadm join <MASTER_PRIVATE_IP>:6443 \
--token <TOKEN> \
--discovery-token-ca-cert-hash sha256:<HASH> \
--cri-socket unix:///run/containerd/containerd.sock \
--v=5
```

**Flag Explanations**:

|Flag|Purpose|Value|
|---|---|---|
|`<MASTER_PRIVATE_IP>`|Master node's private IP|e.g., 172.31.10.15|
|`--token`|Authentication token|From join command|
|`--discovery-token-ca-cert-hash`|Verify master's CA cert|From join command|
|`--cri-socket`|Container runtime socket|`unix:///run/containerd/containerd.sock`|
|`--v=5`|Verbose logging level|Helps with troubleshooting|

**Why --cri-socket is Needed**:

- Tells kubelet which container runtime to use
- Required when multiple runtimes are present