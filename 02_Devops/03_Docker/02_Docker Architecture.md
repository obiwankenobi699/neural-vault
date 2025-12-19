---
title:
  "{ Title }":
tags:
  - DevOps
  - DocKer
created:
  "{ date }":
updated:
  "{ date }":
---


## Runtime, Engine, Images, Containers & OCI Standards

---

## 1. DOCKER RUNTIME: The Low-Level Executor

### Interview Q: "What is Docker runtime? How is it different from Docker Engine?"

**Your Answer:**

"Docker runtime is the **low-level component that actually runs containers**. It's separate from Docker Engine.

**Docker Runtime Components:**

```
User (you)
    ↓
Docker CLI (docker run, docker build)
    ↓
Docker Engine (daemon - dockerd)
    ↓
containerd (container runtime daemon) ← OCI-compliant
    ↓
runc (OCI runtime spec) ← Executes container
    ↓
Linux kernel (namespaces, cgroups)
```

**Docker Runtime = runc**

- Lightweight tool that reads OCI spec
- Creates container (calls kernel APIs)
- Manages container lifecycle
- One container = one runc process
- Written in Go, ~1MB executable

**containerd (Container Daemon)**

- Manages multiple containers
- Handles image pulling, storing, mounting
- Manages runc processes
- Decoupled from Docker Engine (can run standalone)
- **Important**: Docker now uses containerd by default (since Docker 20.10)

**Real difference:**

- **Docker Engine** = High-level: manages containers, images, networks, volumes
- **containerd** = Mid-level: manages container execution and image storage
- **runc** = Low-level: actually starts the container process"

### Follow-Up: "What happened with Docker and containerd? Why separate them?"

**Your Answer:**

"Docker donated containerd to CNCF (Cloud Native Computing Foundation) in 2017. Now:

**Old Docker (pre-20.10):**

```
Docker Client → Docker Daemon (dockerd) → docker-containerd → docker-runc → kernel
```

**Modern Docker (20.10+):**

```
Docker Client → Docker Daemon (dockerd) → containerd → runc → kernel
```

**Why?**

1. **Decoupling** = containerd can run without Docker (Kubernetes uses containerd directly)
2. **Standardization** = OCI spec (runc) became standard, not Docker proprietary
3. **Lighter** = Reduces dependencies in production
4. **Better for Kubernetes** = K8s uses containerd, not full Docker daemon

**Real scenario:** I deployed Kubernetes cluster using `containerd` runtime directly. Don't need Docker daemon running—saves resources and complexity."

---

## 2. DOCKER ENGINE: The High-Level Orchestrator

### Interview Q: "Explain Docker Engine and its components"

**Your Answer:**

"Docker Engine is the **complete system for managing containers and images**. It's client-server architecture:

```
┌─────────────────────────────────────────┐
│        Docker Engine                    │
├─────────────────────────────────────────┤
│                                         │
│  Docker CLI    Docker API   Docker Hub │
│  (docker cmd) (REST API)    (registry)  │
│        │          │              │     │
│        └─────────┬──────────────┘     │
│                  ↓                     │
│        Docker Daemon (dockerd)         │
│        • Image management              │
│        • Container lifecycle           │
│        • Network management            │
│        • Volume management             │
│        • Build system                  │
│                  ↓                     │
│        containerd (runtime)            │
│                  ↓                     │
│        runc (OCI runtime)              │
│                  ↓                     │
│        Linux kernel                    │
└─────────────────────────────────────────┘
```

**Docker Engine Components:**

1. **Docker Daemon (dockerd)**
    
    - Background service running on host
    - Listens on Unix socket (default: /var/run/docker.sock)
    - Manages all Docker operations
    - Can listen on TCP (security risk without TLS)
2. **Docker CLI (docker command)**
    
    - Command-line tool you use
    - Sends requests to daemon via REST API
    - Example: `docker run ubuntu:20.04 /bin/bash`
3. **Docker API (REST)**
    
    - HTTP/REST API exposed by daemon
    - Used by CLI, Docker Desktop, Docker Compose
    - Allows remote management
4. **Image Management**
    
    - Builds images from Dockerfile
    - Pulls images from registries
    - Stores images in local filesystem
    - Manages image layers and caching
5. **Container Management**
    
    - Creates containers from images
    - Manages container lifecycle (start, stop, pause)
    - Handles container resource limits
    - Manages logging
6. **Network Management**
    
    - Bridge network (default)
    - Host network
    - Overlay network (for Swarm/multi-host)
    - Custom networks with DNS

**Real example:**

````bash
$ docker run -d -p 8080:3000 --name web-app my-image:latest

What happens:
1. CLI parses command
2. Sends request to daemon via /var/run/docker.sock
3. Daemon pulls image if not exists
4. Daemon creates container with constraints
5. Daemon calls containerd to execute container
6. containerd calls runc
7. runc reads OCI spec, creates namespaces/cgroups
8. Process starts in container
9. Daemon sets up networking (port 8080:3000 mapping)
10. Returns container ID
```"

---

## 3. THE DOCKERFILE → IMAGE → CONTAINER JOURNEY

### Interview Q: "Walk me through how a Dockerfile becomes a running container"

**Your Answer (Step-by-Step):**

#### **STEP 1: DOCKERFILE (Blueprint)**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
````

**What is a Dockerfile?**

- Text file with instructions
- Declarative (not imperative)
- Each line = one operation
- Creates layers

#### **STEP 2: BUILD IMAGE (docker build)**

```bash
$ docker build -t my-app:1.0 .
```

**What happens during build:**

```
┌─────────────────────────────────────────────────┐
│ STEP 1: docker build -t my-app:1.0 .           │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ Parse Dockerfile                                │
│ • Validate syntax                              │
│ • Check each instruction                       │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 0: FROM python:3.11-slim                 │
│ ├─ Pull base image from registry               │
│ ├─ Size: ~150MB (python runtime + OS files)    │
│ ├─ Already built, just pulled                  │
│ └─ Cached (won't rebuild unless invalidated)   │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 1: WORKDIR /app                          │
│ ├─ Sets working directory                      │
│ ├─ Runs in container                           │
│ └─ Creates new layer (small)                   │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 2: COPY requirements.txt .               │
│ ├─ Copies file from build context to container│
│ ├─ Creates new layer                          │
│ └─ Size: ~1KB (small text file)               │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 3: RUN pip install -r requirements.txt  │
│ ├─ Executes command inside container          │
│ ├─ Installs Python packages from requirements │
│ ├─ Creates new layer                          │
│ ├─ Size: ~50MB (packages + dependencies)      │
│ └─ CANNOT be cached (code inside image)       │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 4: COPY app.py .                         │
│ ├─ Copies application code                    │
│ ├─ Creates new layer                          │
│ └─ Size: ~5KB                                 │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 5: EXPOSE 5000                           │
│ ├─ Documents port (metadata only)              │
│ ├─ Doesn't actually open port                 │
│ └─ Metadata layer                             │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ LAYER 6: CMD ["python", "app.py"]             │
│ ├─ Sets default command                       │
│ ├─ Metadata layer (doesn't run during build)  │
│ └─ Used when container starts                 │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ IMAGE CREATED                                   │
│ ├─ Name: my-app:1.0                           │
│ ├─ Total Size: ~200MB                         │
│ ├─ 7 layers (stacked)                         │
│ ├─ SHA256: abc123def456... (image ID)         │
│ └─ Stored in /var/lib/docker/layers/          │
└─────────────────────────────────────────────────┘
```

**Layer Optimization (Interview tip):**

```dockerfile
# ❌ BAD: Creates huge layer
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
    curl wget git vim nodejs npm postgresql

# ✅ GOOD: Only installs needed packages
FROM python:3.11-slim
RUN pip install flask requests

# ❌ BAD: Changes are cached, wastes layer
FROM node:18
COPY . .
RUN npm install
# Then you change app.py → entire npm install re-runs

# ✅ GOOD: Stable layers first
FROM node:18
COPY package.json package-lock.json .
RUN npm install
COPY . .

# ❌ BAD: 200 packages, creates 200MB layer
RUN apt-get install -y package1 package2 ... package200

# ✅ GOOD: Multi-stage build (production vs build)
FROM python:3.11 as builder
RUN pip install -r requirements.txt

FROM python:3.11-slim
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY app.py .
```

#### **STEP 3: IMAGE STORAGE**

```bash
$ docker images
REPOSITORY   TAG    IMAGE ID      CREATED       SIZE
my-app       1.0    abc123def456  2 min ago     200MB
python       3.11   xyz789...     2 weeks ago   150MB
```

**What is an image?**

- **Not a single file**: Collection of layers stored as tarballs
- **Union filesystem**: Layers stacked on top of each other
- **Read-only**: Image never changes after built
- **Stored in**: `/var/lib/docker/image/` (local filesystem)
- **Pushed to registry**: Docker Hub, ECR, Artifact Registry, etc.

**Image Structure:**

```
my-app:1.0 (Image)
├─ Layer 0: python:3.11-slim (base)
│   ├─ /usr/bin/python
│   ├─ /usr/lib/python3.11/
│   └─ ... (OS files)
├─ Layer 1: WORKDIR /app
├─ Layer 2: requirements.txt
├─ Layer 3: pip packages
├─ Layer 4: app.py
├─ Layer 5: EXPOSE metadata
└─ Layer 6: CMD metadata
```

#### **STEP 4: RUN CONTAINER (docker run)**

```bash
$ docker run -d -p 5000:5000 --name my-api my-app:1.0
```

**What happens when you run a container:**

```
┌──────────────────────────────────────────────┐
│ docker run -d -p 5000:5000 my-app:1.0       │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 1. Daemon reads image my-app:1.0            │
│    • Gets all layers                        │
│    • Creates union filesystem               │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 2. Creates writable layer (Container Layer) │
│    • Copy-on-write (CoW)                   │
│    • Changes written here, not image       │
│    • Deleted when container stops          │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 3. Calls containerd                         │
│    • Passes OCI spec                        │
│    • Container ID, image layers, mounts    │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 4. containerd calls runc                    │
│    • Reads OCI spec                        │
│    • Creates namespaces (PID, Net, Mnt)   │
│    • Creates cgroups (resource limits)     │
│    • Mounts filesystem                     │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 5. Linux kernel executes container         │
│    • Process starts with PID 1             │
│    • CMD runs: python app.py               │
│    • App listens on port 5000              │
│    • Containers sees only its own files    │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ 6. Daemon sets up networking               │
│    • Creates veth pair (virtual NIC)       │
│    • Connects to bridge network            │
│    • Maps port: 5000 (host) → 5000 (container)
│    • Container can reach outside world     │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ Container Running (PID, isolation, networking)
│ User code executing, handling requests     │
└──────────────────────────────────────────────┘
```

**Container Structure:**

```
Running Container (instance of image)
├─ Image Layers (read-only)
│  ├─ Layer 0: python runtime
│  ├─ Layer 1: WORKDIR /app
│  ├─ Layer 2-4: dependencies + code
│  └─ ...
├─ Container Layer (writable)
│  ├─ /app/data.log (log file created at runtime)
│  ├─ /tmp/cache (temp files)
│  └─ ... (changes not in image)
├─ Namespaces (isolation)
│  ├─ PID: sees only own process
│  ├─ Network: virtual NIC, own IP
│  ├─ Mount: sees only /app, /usr, /bin, etc
│  └─ ...
└─ cgroups (limits)
   ├─ CPU: 1 core max
   ├─ Memory: 512MB max
   └─ ...
```

---

## 4. ORCHESTRATION: Managing Containers at Scale

### Interview Q: "What is container orchestration? Why do we need it?"

**Your Answer:**

"Container orchestration = **Automated management of containers across multiple machines**.

**Problem without orchestration:**

- You have 100 containers to run
- Each needs CPU, memory, networking
- Some fail, need automatic restart
- Need to scale to 200 during peak load
- Need to push updates to all containers
- Manual management = impossible

**Orchestration solves:**

1. **Placement**: Which container on which server?
2. **Scaling**: Start/stop containers based on load
3. **Health**: Restart failed containers
4. **Updates**: Rolling deployment (no downtime)
5. **Networking**: Service discovery, load balancing
6. **Storage**: Persistent volumes across machines

**Popular Orchestrators:**

|Tool|Use Case|Status|
|---|---|---|
|**Kubernetes**|Production, complex apps, cloud-native|Industry standard|
|**Docker Swarm**|Simple, built-in, easy to learn|Less used, simpler|
|**Nomad**|Multi-workload (containers + VMs + batch)|HashiCorp, flexible|
|**ECS**|AWS-only, integrated with AWS services|AWS users|

**Real example: Without orchestration**

```bash
# Manual way (nightmare)
docker run -d my-app:1.0  # Server 1
docker run -d my-app:1.0  # Server 2
docker run -d my-app:1.0  # Server 3
# App crashes on Server 1 → manually restart
docker run -d my-app:1.0  # Server 1 again
# Need to update to v2.0 → stop all, restart all
# Traffic spike → need 10 more containers → manual on 5 new servers
# Networking nightmare → manual port management
```

**With Kubernetes (automated)**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3  # Always 3 running
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: my-app:2.0
        resources:
          limits:
            memory: "512Mi"
            cpu: "1"
```

**What Kubernetes does:**

- Starts 3 containers automatically
- If one dies → automatically restarts
- Load increases → scales to 10
- Load decreases → scales back to 3
- Update image to v2.0 → rolling update (1 at a time, no downtime)
- Service discovery → other apps find 'my-app' via DNS
- All automatic with declarative config"

### Follow-Up: "Kubernetes vs Docker Swarm?"

**Your Answer:**

|Aspect|Kubernetes|Docker Swarm|
|---|---|---|
|**Learning curve**|Steep|Easy|
|**Setup**|Complex (clusters, RBAC, etcd)|Built into Docker|
|**Scalability**|5000+ nodes|Hundreds of nodes|
|**Features**|Advanced (StatefulSets, Operators, etc)|Basic (Replicas, Services)|
|**Production ready**|Yes (industry standard)|Limited|
|**Community**|Massive|Small|
|**Production use**|95%+|Rarely|

**Real scenario:** I started with Docker Compose for dev, moved to Swarm for simple prod, scaled to Kubernetes for multi-region, high-availability."

---

## 5. OPEN CONTAINER INITIATIVE (OCI)

### Interview Q: "What is OCI? Why does it matter?"

**Your Answer:**

"OCI = **Open Container Initiative** - specification for containers created by Linux Foundation.

**Problem OCI solved:** Before OCI (2015), Docker format was proprietary. If Docker failed, no standard for containers. OCI created **vendor-neutral standards**.

**OCI Standards:**

1. **Image Specification (OCI Image Spec)**
    
    - Defines what a container image is
    - Layer format, metadata, config
    - Any tool can build OCI images: Docker, Podman, BuildKit, etc
2. **Runtime Specification (OCI Runtime Spec)**
    
    - Defines how to run a container
    - What runc must do
    - How to pass config, manage lifecycle
3. **Distribution Specification**
    
    - How to push/pull images from registries
    - Standardized API for registries

**Real structure (OCI Image):**

```
OCI Image
├─ Image Config (JSON)
│  ├─ Architecture: amd64
│  ├─ OS: linux
│  ├─ Environment variables
│  ├─ Working directory
│  ├─ Exposed ports
│  └─ CMD/ENTRYPOINT
├─ Layer 1 (tarball)
│  └─ Compressed filesystem
├─ Layer 2 (tarball)
├─ Layer 3 (tarball)
└─ Index/Manifest (lists layers)
```

**Why this matters:**

1. **Portability**: Image built with Docker runs with Podman, containerd, etc
2. **Standards**: Not locked to Docker
3. **Competition**: New tools can implement OCI standard
4. **Future-proof**: OCI will evolve, vendors will support it

**Real examples:**

```bash
# Docker builds OCI image
docker build -t my-app:1.0 .

# Podman can run it
podman run my-app:1.0

# containerd can run it
ctr run my-app:1.0

# All use same image format (OCI standard)
```

**Interview tip:** 'Docker doesn't own containers anymore—OCI does. This is why Kubernetes can use any runtime (Docker, containerd, CRI-O) as long as it implements OCI spec.'"

---

## 6. COMPLETE WORKFLOW: Production Example

### Interview Q: "Walk me through your development to production workflow"

**Your Answer:**

```
┌─────────────────────────────────┐
│ STEP 1: Local Development       │
│ • Write Python code             │
│ • Test locally with docker run  │
│ • Works ✓                       │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 2: Write Dockerfile        │
│ • Define image (FROM, RUN, COPY)│
│ • Optimize layers               │
│ • Multi-stage if needed         │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 3: Build Image             │
│ $ docker build -t my-app:1.0 .  │
│ • Creates OCI image             │
│ • Size: 200MB                   │
│ • Ready to distribute           │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 4: Test Image              │
│ $ docker run my-app:1.0         │
│ • Container runs locally        │
│ • Final check before push       │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 5: Push to Registry        │
│ $ docker push gcr.io/my-app:1.0 │
│ • Uploads OCI image to GCR      │
│ • Available for production      │
│ • Can pull from any machine     │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 6: Production (Kubernetes) │
│ • Kubectl applies deployment    │
│ • K8s scheduler picks nodes     │
│ • containerd pulls image        │
│ • runc creates containers       │
│ • Load balancer routes traffic  │
│ • App running ✓                 │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 7: Monitoring              │
│ • Prometheus scrapes metrics    │
│ • Alerts on failures            │
│ • Auto-restart on crash         │
│ • Logs aggregated (ELK)         │
└─────────────────────────────────┘
                ↓
┌─────────────────────────────────┐
│ STEP 8: Update (v2.0)           │
│ • Update code, rebuild          │
│ • $ docker build -t my-app:2.0  │
│ • Push to registry              │
│ • Update K8s deployment         │
│ • Rolling update (no downtime)  │
│ • Old containers → new ones     │
└─────────────────────────────────┘
```

**Real GitOps workflow (CI/CD):**

```
Developer pushes code to GitHub
        ↓
GitHub Actions triggered
        ↓
Docker build + test
        ↓
docker push gcr.io/my-app:sha-abc123
        ↓
Helm / Kustomize generates K8s manifests
        ↓
ArgoCD detects new image
        ↓
kubectl apply -f deployment.yaml (automated)
        ↓
K8s pulls image from GCR
        ↓
Containers run in production
        ↓
Production = Source of truth (declarative)
```

---

## 7. COMMON INTERVIEW QUESTIONS

### Q: "What's the difference between image and container?"

**Answer:** "Image = Blueprint (class), Container = Running instance (object). Image is static (stored), container is dynamic (memory, PID, network)."

### Q: "How do you reduce Docker image size?"

**Answer:**

```dockerfile
# Use slim base image (150MB instead of 500MB)
FROM python:3.11-slim

# Multi-stage build
FROM node:18 as builder
RUN npm install
FROM node:18-slim
COPY --from=builder /app .

# Minimize layers
RUN apt-get update && apt-get install curl && rm -rf /var/lib/apt/lists/*

# Don't copy unnecessary files (use .dockerignore)
```

### Q: "What is Docker layer caching?"

**Answer:** "Each layer is cached. If a layer doesn't change, Docker uses cached layer instead of rebuilding. Order matters: put stable things first (FROM, package install), dynamic things last (COPY app code)."

### Q: "Difference between ENTRYPOINT and CMD?"

**Answer:**

```dockerfile
# CMD can be overridden
ENTRYPOINT ["python"]
CMD ["app.py"]
# docker run image.py → runs: python app.py
# docker run script.py → runs: python script.py (CMD overridden)

# If only CMD
CMD ["python", "app.py"]
# docker run image → runs: python app.py
# docker run python script.py → runs: python script.py (CMD ignored)
```

### Q: "What happens when a container crashes?"

**Answer:** "Without orchestration: container stops, logs are there, nothing restarts it. With Kubernetes: container restarts immediately (kubelet detects via health check), if keeps crashing, pod enters CrashLoopBackOff, alerts trigger."

### Q: "How do containers handle persistent data?"

**Answer:** "Container layer is ephemeral. Use volumes:

- Volumes: Docker-managed storage (survives container death)
- Bind mounts: Host directory mounted in container
- tmpfs: In-memory storage (lost when container dies)

Best practice: Stateless containers + external database (PostgreSQL, S3)"

---

## 8. QUICK REFERENCE COMMANDS

```bash
# Build image
docker build -t my-app:1.0 -f Dockerfile .

# Run container
docker run -d -p 8080:3000 --name my-container my-app:1.0

# View running containers
docker ps

# View image layers
docker history my-app:1.0

# Inspect image
docker inspect my-app:1.0

# Push to registry
docker tag my-app:1.0 gcr.io/my-app:1.0
docker push gcr.io/my-app:1.0

# Check image size
docker images my-app

# View image config
docker image inspect --format='{{json .ContainerConfig}}' my-app:1.0 | jq

# OCI runtime info
docker info | grep -i runtime
```

---

## 9. PRODUCTION ARCHITECTURE (Interview Visual)

```
Developer
    ↓
GitHub (Code)
    ↓
GitHub Actions (CI)
    ├─ Dockerfile exists?
    ├─ docker build
    ├─ docker push gcr.io/my-app:v1.2.3
    └─ Triggers: ArgoCD / Flux
    ↓
Container Registry (GCR / ECR / Artifactory)
    ├─ OCI Images stored
    ├─ Versioned (v1.2.3, latest)
    └─ Pull-able from anywhere
    ↓
Kubernetes Cluster
    ├─ Deployment manifest references my-app:v1.2.3
    ├─ Scheduler places pods on nodes
    ├─ kubelet pulls image from registry
    ├─ containerd receives image
    ├─ runc creates container
    └─ App running with resource limits
    ↓
Load Balancer
    ├─ Routes traffic to pods
    ├─ Health checks
    └─ Auto-scale up/down based on metrics
    ↓
Monitoring (Prometheus / Grafana / ELK)
    ├─ Container metrics (CPU, RAM, Network)
    ├─ Application logs
    ├─ Error rates, latency
    └─ Alerts on failures
```

---
```
┌──────────────────────────────────────────────────────────────────────────┐
│                                USER LAYER                                 │
├──────────────────────────────────────────────────────────────────────────┤
│                          Docker CLI (Client)                               │
│        docker run | docker build | docker pull | docker ps                 │
└──────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                           SERVICE MANAGEMENT                               │
├──────────────────────────────────────────────────────────────────────────┤
│                        docker.service (systemd)                            │
│              - Starts / stops dockerd                                      │
│              - Manages daemon lifecycle                                    │
└──────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌══════════════════════════════════════════════════════════════════════════┐
║                         DOCKER ENGINE LAYER                               ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║   ┌──────────────────────────┐      ┌──────────────────────────┐        ║
║   │   Docker Daemon           │<---->│       containerd          │        ║
║   │        (dockerd)          │ gRPC │   (Container Runtime)    │        ║
║   │--------------------------│      │--------------------------│        ║
║   │ - REST API                │      │ - Image management       │        ║
║   │ - Build / Pull / Push     │      │ - Snapshotting           │        ║
║   │ - Network mgmt            │      │ - Container lifecycle    │        ║
║   │ - Volume mgmt             │      │ - CRI for Kubernetes     │        ║
║   └──────────────────────────┘      └──────────────┬───────────┘        ║
║                                                      │ OCI                ║
╚══════════════════════════════════════════════════════╧═══════════════════╝
                                                       │
                                                       ▼
┌══════════════════════════════════════════════════════════════════════════┐
║                          RUNTIME EXECUTION LAYER                          ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║   ┌──────────────────────────┐      ┌──────────────────────────┐        ║
║   │          runc             │      │     containerd-shim       │        ║
║   │      (OCI Runtime)        │      │--------------------------│        ║
║   │--------------------------│      │ - Keeps container alive   │        ║
║   │ - Create namespaces       │      │ - Handles STDIO          │        ║
║   │ - Apply cgroups           │      │ - Signal forwarding      │        ║
║   │ - Mount rootfs            │      │ - Exit status reporting  │        ║
║   │ - Start process           │      │                          │        ║
║   │ - Exits after start       │      │                          │        ║
║   └──────────────────────────┘      └──────────────────────────┘        ║
╚══════════════════════════════════════════════════════════════════════════╝
                                     │
                                     ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                              KERNEL LAYER                                 │
├──────────────────────────────────────────────────────────────────────────┤
│  Linux Kernel Features                                                     │
│  ────────────────────                                                     │
│  Namespaces : pid | net | mnt | uts | ipc | user                            │
│  cgroups    : cpu | memory | io | pids                                     │
│  FS         : OverlayFS                                                    │
└──────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                             HARDWARE LAYER                                │
├──────────────────────────────────────────────────────────────────────────┤
│                  CPU | RAM | Disk | Network                                │
└──────────────────────────────────────────────────────────────────────────┘

```