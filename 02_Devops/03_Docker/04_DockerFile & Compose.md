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
# Docker Compose - Complete Installation & Usage Guide

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║    ██████╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ███████╗      ║
║   ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗██╔════╝      ║
║   ██║     ██║   ██║██╔████╔██║██████╔╝██║   ██║███████╗      ║
║   ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║╚════██║      ║
║   ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝███████║      ║
║    ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝ ╚══════╝      ║
║                                                                ║
║          Multi-Container Orchestration Tool                   ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## Table of Contents

1. [What is Docker Compose](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#what-is-docker-compose)
2. [Installation Guide](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#installation-guide)
3. [Compose File Structure](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#compose-file-structure)
4. [Service Configuration](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#service-configuration)
5. [Environment Variables](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#environment-variables)
6. [Networks and Volumes](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#networks-and-volumes)
7. [Health Checks and Dependencies](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#health-checks-and-dependencies)
8. [Dockerfile Templates](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#dockerfile-templates)
9. [Complete Examples](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#complete-examples)
10. [Compose Commands](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#compose-commands)
11. [Production Patterns](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#production-patterns)
12. [Interview Preparation](https://claude.ai/chat/ccc747c5-c7ba-45c1-8ef0-6f9e4b64f666#interview-preparation)

---

## What is Docker Compose

### Definition

Docker Compose is a declarative orchestration tool for defining and running multi-container Docker applications using a single YAML configuration file.

**Core Purpose:**

- Replace multiple `docker run` commands with single configuration
- Automate network creation and service discovery
- Manage multi-container application lifecycle
- Enable reproducible development environments
- Simplify complex deployment scenarios

### The Problem Docker Compose Solves

```ascii
┌────────────────────────────────────────────────────────────┐
│              WITHOUT DOCKER COMPOSE                        │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  # Create network                                          │
│  docker network create app_net                             │
│                                                            │
│  # Start database                                          │
│  docker run -d --name mysql --network app_net \           │
│    -e MYSQL_ROOT_PASSWORD=secret \                        │
│    -e MYSQL_DATABASE=appdb mysql:8                        │
│                                                            │
│  # Wait for database to be ready                           │
│  sleep 30                                                  │
│                                                            │
│  # Start application                                       │
│  docker run -d --name app --network app_net \             │
│    -e DB_HOST=mysql \                                     │
│    -e DB_USER=root \                                      │
│    -e DB_PASSWORD=secret \                                │
│    -p 5000:5000 myapp:latest                              │
│                                                            │
│  Problems:                                                 │
│  ❌ Manual network management                              │
│  ❌ No dependency ordering                                 │
│  ❌ Environment variable repetition                        │
│  ❌ Error-prone startup sequence                           │
│  ❌ Difficult to reproduce                                 │
│                                                            │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│               WITH DOCKER COMPOSE                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  # docker-compose.yml                                      │
│  version: "3.9"                                            │
│  services:                                                 │
│    mysql:                                                  │
│      image: mysql:8                                        │
│      environment:                                          │
│        MYSQL_ROOT_PASSWORD: secret                         │
│        MYSQL_DATABASE: appdb                               │
│    app:                                                    │
│      build: .                                              │
│      ports:                                                │
│        - "5000:5000"                                       │
│      depends_on:                                           │
│        - mysql                                             │
│                                                            │
│  # Single command                                          │
│  docker compose up -d                                      │
│                                                            │
│  Benefits:                                                 │
│  ✓ Automatic network creation                             │
│  ✓ Dependency management                                  │
│  ✓ Centralized configuration                              │
│  ✓ Reproducible deployments                               │
│  ✓ Easy to version control                                │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Docker Compose Architecture

```mermaid
graph TB
    A[docker-compose.yml] --> B[Docker Compose CLI]
    C[.env] --> B
    D[Dockerfile] --> B
    
    B --> E[Docker Engine]
    
    E --> F[Create Networks]
    E --> G[Create Volumes]
    E --> H[Build Images]
    E --> I[Start Containers]
    
    F --> J[Default Network]
    G --> K[Named Volumes]
    H --> L[Custom Images]
    I --> M[Service Containers]
    
    M --> N[Service 1]
    M --> O[Service 2]
    M --> P[Service N]
    
    style A fill:#f39c12
    style B fill:#3498db
    style E fill:#2ecc71
```

### Compose vs Manual Docker

```markmap
# Docker Compose vs Manual
## Manual Docker Commands
### Imperative approach
### Multiple commands required
### Manual network management
### No dependency handling
### Error-prone
### Hard to reproduce
### Good for learning
## Docker Compose
### Declarative approach
### Single command deployment
### Automatic network creation
### Built-in dependencies
### Reproducible
### Version controllable
### Production-ready
## Use Cases
### Manual: Learning, debugging, CI steps
### Compose: Development, testing, staging
### Production: Kubernetes, Docker Swarm
```

---

## Installation Guide

### Version Check

```bash
# Check if Docker Compose is installed
docker compose version

# Expected output:
# Docker Compose version v2.23.0
```

### Compose V1 vs V2

```ascii
╔════════════════════════════════════════════════════════════╗
║           DOCKER COMPOSE VERSION HISTORY                   ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  V1 (Deprecated - docker-compose)                          ║
║  ─────────────────────────────────                         ║
║  • Standalone Python application                           ║
║  • Command: docker-compose                                 ║
║  • Separate installation required                          ║
║  • Legacy, no longer maintained                            ║
║                                                            ║
║  V2 (Current - docker compose)                             ║
║  ──────────────────────────────                            ║
║  • Docker CLI plugin                                       ║
║  • Command: docker compose                                 ║
║  • Integrated with Docker Desktop                          ║
║  • Written in Go (faster performance)                      ║
║  • Better integration with Docker Engine                   ║
║  • Active development and support                          ║
║                                                            ║
║  Migration: Replace "docker-compose" with "docker compose" ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### Installation on Linux

#### Arch Linux

```bash
# Check Docker installation
docker --version

# Install Compose plugin
sudo pacman -S docker-compose-plugin

# Verify installation
docker compose version

# Alternative: Install standalone (V1 - not recommended)
sudo pacman -S docker-compose
```

#### Ubuntu / Debian

```bash
# Update package index
sudo apt update

# Install Docker Compose plugin
sudo apt install docker-compose-plugin

# Verify installation
docker compose version

# Alternative: Manual installation (latest version)
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### RHEL / CentOS / Fedora

```bash
# Install Docker Compose plugin
sudo dnf install docker-compose-plugin

# Verify installation
docker compose version

# For older systems using yum
sudo yum install docker-compose-plugin
```

#### Generic Linux (Manual Installation)

```bash
# Download latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Create symbolic link (optional)
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verify installation
docker-compose --version
```

### Installation on macOS

```bash
# Docker Compose is included with Docker Desktop
# Verify installation
docker compose version

# If using Homebrew
brew install docker-compose

# Verify
docker compose version
```

### Installation on Windows

```powershell
# Docker Compose is included with Docker Desktop
# Verify installation
docker compose version

# If needed, install via Chocolatey
choco install docker-compose

# Verify
docker compose version
```

### Post-Installation Verification

```bash
# Check version
docker compose version

# Test with sample application
mkdir compose-test
cd compose-test

# Create test compose file
cat > docker-compose.yml << EOF
version: "3.9"
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
EOF

# Start services
docker compose up -d

# Check status
docker compose ps

# Stop and remove
docker compose down

# Cleanup
cd ..
rm -rf compose-test
```

---

## Compose File Structure

### File Anatomy

```yaml
# docker-compose.yml structure breakdown

version: "3.9"                    # Compose file format version

services:                         # Container definitions
  service_name:                   # Service identifier
    image: image:tag              # Image to use
    build: ./path                 # Build configuration
    container_name: name          # Container name
    ports:                        # Port mappings
      - "host:container"
    environment:                  # Environment variables
      KEY: value
    volumes:                      # Volume mounts
      - volume_name:/path
    networks:                     # Network attachments
      - network_name
    depends_on:                   # Service dependencies
      - other_service

networks:                         # Network definitions
  network_name:
    driver: bridge

volumes:                          # Volume definitions
  volume_name:
    driver: local
```

### Version History

```ascii
┌────────────────────────────────────────────────────────────┐
│              COMPOSE FILE VERSION GUIDE                    │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Version  │ Docker Engine  │ Status       │ Notes         │
│  ─────────────────────────────────────────────────────     │
│                                                            │
│  3.9      │ 19.03.0+       │ Recommended  │ Latest stable │
│  3.8      │ 19.03.0+       │ Stable       │ Production    │
│  3.7      │ 18.06.0+       │ Stable       │ Widely used   │
│  3.0-3.6  │ 1.13.0+        │ Legacy       │ Still works   │
│  2.x      │ 1.10.0+        │ Deprecated   │ Avoid         │
│  1.x      │ 1.9.1+         │ Obsolete     │ Don't use     │
│                                                            │
│  Recommendation: Use version "3.9" for new projects       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Basic File Example

```yaml
version: "3.9"

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    networks:
      - frontend

  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
    networks:
      - frontend
      - backend
    depends_on:
      - database

  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  db_data:
```

### Project Structure

```
project-root/
│
├── docker-compose.yml          # Main orchestration file
├── .env                        # Environment variables
├── .dockerignore               # Build exclusions
│
├── services/
│   ├── frontend/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── src/
│   │
│   ├── backend/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── app/
│   │
│   └── database/
│       └── init.sql
│
├── config/
│   ├── nginx.conf
│   └── postgres.conf
│
└── scripts/
    ├── deploy.sh
    └── backup.sh
```

---

## Service Configuration

### Image vs Build

```yaml
# Using pre-built image
services:
  mysql:
    image: mysql:8                # Pull from registry
    
  nginx:
    image: nginx:alpine           # Official image

# Building from Dockerfile
services:
  app:
    build: .                      # Build from current directory
    
  api:
    build:
      context: ./backend          # Build context
      dockerfile: Dockerfile.prod # Custom Dockerfile
      args:
        - NODE_ENV=production     # Build arguments
```

### Port Mapping

```yaml
services:
  web:
    image: nginx
    ports:
      # Short syntax
      - "80:80"                   # HOST:CONTAINER
      - "443:443"
      
      # Long syntax
      - target: 8080              # Container port
        published: 8080           # Host port
        protocol: tcp             # tcp or udp
        mode: host                # host or ingress
```

### Container Naming

```yaml
services:
  database:
    image: postgres:15
    container_name: my_postgres   # Fixed container name
    # Without container_name, Docker generates: 
    # <project>_<service>_<replica>
```

### Restart Policies

```yaml
services:
  app:
    image: myapp
    restart: no                   # Never restart (default)
    
  web:
    image: nginx
    restart: always               # Always restart
    
  api:
    image: api
    restart: on-failure           # Restart on error
    
  worker:
    image: worker
    restart: unless-stopped       # Restart unless manually stopped
```

### Resource Limits

```yaml
services:
  app:
    image: myapp
    deploy:
      resources:
        limits:
          cpus: '0.50'            # 50% of one CPU
          memory: 512M            # 512 MB RAM
        reservations:
          cpus: '0.25'            # Minimum 25% CPU
          memory: 256M            # Minimum 256 MB
```

### Command Override

```yaml
services:
  app:
    image: python:3.11
    command: python app.py        # Override CMD
    
  worker:
    image: python:3.11
    command: ["python", "worker.py", "--verbose"]
    
  shell:
    image: alpine
    command: sh -c "while true; do sleep 30; done"
```

### Working Directory

```yaml
services:
  app:
    image: node:18
    working_dir: /app             # Set working directory
    volumes:
      - ./src:/app
    command: npm start
```

### User Configuration

```yaml
services:
  app:
    image: myapp
    user: "1000:1000"             # UID:GID
    
  nginx:
    image: nginx
    user: nginx                   # Username
```

---

## Environment Variables

### Inline Environment Variables

```yaml
services:
  app:
    image: myapp
    environment:
      NODE_ENV: production
      DB_HOST: database
      DB_PORT: 5432
      DEBUG: "false"
```

### Environment from .env File

```yaml
# docker-compose.yml
services:
  app:
    image: myapp
    environment:
      - NODE_ENV
      - DB_HOST
      - DB_USER
      - DB_PASSWORD
```

```bash
# .env file
NODE_ENV=production
DB_HOST=postgres
DB_USER=admin
DB_PASSWORD=secretpass
```

### Environment File

```yaml
services:
  app:
    image: myapp
    env_file:
      - ./config/common.env       # Common variables
      - ./config/production.env   # Environment-specific
```

```bash
# common.env
NODE_ENV=production
LOG_LEVEL=info

# production.env
DB_HOST=postgres-prod.example.com
DB_PORT=5432
```

### Variable Substitution

```yaml
# docker-compose.yml
services:
  app:
    image: myapp:${APP_VERSION:-latest}    # Default to 'latest'
    ports:
      - "${APP_PORT:-3000}:3000"           # Default to 3000
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}/${DB_NAME}
```

```bash
# .env
APP_VERSION=1.0.0
APP_PORT=8080
DB_USER=admin
DB_PASS=secret
DB_HOST=postgres
DB_NAME=myapp
```

### Environment Priority

```ascii
┌────────────────────────────────────────────────────────────┐
│           ENVIRONMENT VARIABLE PRIORITY                    │
│                   (Highest to Lowest)                      │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. Shell environment variables                            │
│     export DB_HOST=override                                │
│     docker compose up                                      │
│                                                            │
│  2. environment: section in docker-compose.yml             │
│     environment:                                           │
│       DB_HOST: postgres                                    │
│                                                            │
│  3. env_file: in docker-compose.yml                        │
│     env_file:                                              │
│       - .env.production                                    │
│                                                            │
│  4. .env file in project root                              │
│     DB_HOST=postgres                                       │
│                                                            │
│  5. Dockerfile ENV instruction                             │
│     ENV DB_HOST=localhost                                  │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Networks and Volumes

### Default Network Behavior

```yaml
# Without explicit network definition
services:
  web:
    image: nginx
  app:
    image: myapp

# Docker Compose creates:
# - Network named: <project>_default
# - Both services attached to it
# - DNS resolution: web → 172.18.0.2, app → 172.18.0.3
```

### Custom Networks

```yaml
services:
  web:
    image: nginx
    networks:
      - frontend

  app:
    image: myapp
    networks:
      - frontend
      - backend

  database:
    image: postgres
    networks:
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true              # No external access
```

### Network Configuration

```yaml
networks:
  custom:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: custom_br0
    ipam:
      driver: default
      config:
        - subnet: 172.28.0.0/16
          gateway: 172.28.0.1
```

### Named Volumes

```yaml
services:
  database:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    image: myapp
    volumes:
      - app_data:/app/data
      - app_logs:/app/logs

volumes:
  postgres_data:                # Named volume (Docker-managed)
  app_data:
  app_logs:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /mnt/app_logs
```

### Bind Mounts

```yaml
services:
  web:
    image: nginx
    volumes:
      # Bind mount
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/usr/share/nginx/html

  app:
    build: .
    volumes:
      # Source code for development
      - ./src:/app/src
      # Node modules from image
      - /app/node_modules
```

### Volume Permissions

```yaml
services:
  app:
    image: myapp
    volumes:
      - data:/app/data:rw       # Read-write (default)
      - config:/app/config:ro   # Read-only
      - cache:/app/cache:rw,Z   # SELinux label
    user: "1000:1000"           # Run as specific UID

volumes:
  data:
  config:
  cache:
```

---

## Health Checks and Dependencies

### Health Check Configuration

```yaml
services:
  database:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s             # Check every 10 seconds
      timeout: 5s               # Timeout after 5 seconds
      retries: 5                # Fail after 5 retries
      start_period: 30s         # Grace period on startup

  mysql:
    image: mysql:8
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 3

  web:
    image: nginx
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 3s
      retries: 3
```

### Service Dependencies

```yaml
services:
  app:
    image: myapp
    depends_on:
      - database              # Wait for database to start
      - cache
    
  database:
    image: postgres:15
    
  cache:
    image: redis:7
```

### Health-Based Dependencies (Compose V2.1+)

```yaml
version: "3.9"

services:
  app:
    image: myapp
    depends_on:
      database:
        condition: service_healthy    # Wait for health check
      cache:
        condition: service_started    # Wait for start only

  database:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 5s
      timeout: 3s
      retries: 5

  cache:
    image: redis:7
```

### Wait-for-it Pattern

```yaml
services:
  app:
    image: myapp
    command: >
      sh -c "
        while ! nc -z database 5432; do
          echo 'Waiting for database...';
          sleep 2;
        done;
        echo 'Database is ready!';
        python app.py
      "
    depends_on:
      - database

  database:
    image: postgres:15
```

### Health Check Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Starting: Container starts
    Starting --> Healthy: Health check passes (start_period + interval)
    Starting --> Unhealthy: Health check fails (retries exhausted)
    Healthy --> Unhealthy: Health check fails
    Unhealthy --> Healthy: Health check passes
    Unhealthy --> [*]: Container stopped/removed
    Healthy --> [*]: Container stopped
    
    note right of Starting
        Grace period: start_period
        First check after: interval
    end note
    
    note right of Unhealthy
        After retries * interval
        Container may restart
        based on policy
    end note
```

---

## Dockerfile Templates

### Python / Flask Application

```dockerfile
# Dockerfile for Flask application
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ /app/

# Create non-root user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose application port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD python -c "import requests; requests.get('http://localhost:5000/health')"

# Run application
CMD ["python", "app.py"]
```

```txt
# requirements.txt
flask==3.0.0
mysql-connector-python==8.2.0
python-dotenv==1.0.0
gunicorn==21.2.0
requests==2.31.0
```

### Java Spring Boot Application

```dockerfile
# Multi-stage build for Java application
FROM eclipse-temurin:17-jdk-alpine AS build

# Set working directory
WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY src ./src

# Build application
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

# Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -D -u 1000 -G appgroup appuser

WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Change ownership
RUN chown appuser:appgroup app.jar

USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Node.js Application

```dockerfile
# Dockerfile for Node.js application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Build application (if needed)
RUN npm run build

# Production stage
FROM node:18-alpine

# Install dumb-init
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1000 nodejs && \
    adduser -D -u 1000 -G nodejs nodejs

WORKDIR /app

# Copy dependencies and built app
COPY --from=build --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nodejs:nodejs /app/dist ./dist
COPY --from=build --chown=nodejs:nodejs /app/package*.json ./

USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Run with dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/server.js"]
```

```json
// package.json
{
  "name": "myapp",
  "version": "1.0.0",
  "scripts": {
    "start": "node dist/server.js",
    "build": "tsc",
    "dev": "ts-node src/server.ts"
  },
  "dependencies": {
    "express": "^4.18.0",
    "pg": "^8.11.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/express": "^4.17.0"
  }
}
```

---

## Complete Examples

### Example 1: Flask + MySQL Application

```yaml
# docker-compose.yml
version: "3.9"

services:
  mysql:
    image: mysql:8
    container_name: mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 60s

  flaskapp:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: flaskapp
    restart: unless-stopped
    ports:
      - "${FLASK_PORT:-5000}:5000"
    environment:
      FLASK_HOST: 0.0.0.0
      FLASK_PORT: 5000
      DB_HOST: mysql
      DB_USER: ${MYSQL_USER}
      DB_PASSWORD: ${MYSQL_PASSWORD}
      DB_NAME: ${MYSQL_DATABASE}
    volumes:
      - app_logs:/app/logs
    networks:
      - backend
    depends_on:
      mysql:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 30s

networks:
  backend:
    driver: bridge

volumes:
  mysql_data:
    driver: local
  app_logs:
    driver: local
```

```bash
# .env
MYSQL_ROOT_PASSWORD=rootpass123
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=apppass123
FLASK_PORT=5000
```

```sql
-- init.sql
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES 
    ('Admin User', 'admin@example.com'),
    ('Test User', 'test@example.com');
```

### Example 2: Full-Stack Application

```yaml
# docker-compose.yml - Complete full-stack setup
version: "3.9"

services:
  # Database
  postgres:
    image: postgres:15-alpine
    container_name: postgres_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 5s
      timeout: 3s
      retries: 5

  # Cache
  redis:
    image: redis:7-alpine
    container_name: redis_cache
    restart: unless-stopped
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  # Backend API
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: backend_api
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      PORT: 3000
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
      JWT_SECRET: ${JWT_SECRET}
    volumes:
      - api_logs:/app/logs
    networks:
      - frontend
      - backend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 10s
      timeout: 5s
      retries: 3

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      args:
        REACT_APP_API_URL: http://localhost:3000/api
    container_name: frontend_app
    restart: unless-stopped
    ports:
      - "80:80"
    networks:
      - frontend
    depends_on:
      - api
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: nginx_proxy
    restart: unless-stopped
    ports:
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    networks:
      - frontend
    depends_on:
      - frontend
      - api

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  postgres_data:
  redis_data:
  api_logs:
```

### Example 3: Microservices Architecture

```yaml
# docker-compose.yml - Microservices setup
version: "3.9"

services:
  # API Gateway
  gateway:
    build: ./gateway
    ports:
      - "8080:8080"
    environment:
      - USER_SERVICE_URL=http://user-service:3001
      - ORDER_SERVICE_URL=http://order-service:3002
      - PRODUCT_SERVICE_URL=http://product-service:3003
    networks:
      - frontend
      - backend
    depends_on:
      - user-service
      - order-service
      - product-service

  # User Service
  user-service:
    build: ./services/user
    environment:
      - DB_HOST=postgres
      - DB_NAME=users
      - REDIS_HOST=redis
    networks:
      - backend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started

  # Order Service
  order-service:
    build: ./services/order
    environment:
      - DB_HOST=postgres
      - DB_NAME=orders
      - RABBITMQ_URL=amqp://rabbitmq:5672
    networks:
      - backend
    depends_on:
      postgres:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy

  # Product Service
  product-service:
    build: ./services/product
    environment:
      - DB_HOST=postgres
      - DB_NAME=products
      - REDIS_HOST=redis
    networks:
      - backend
    depends_on:
      postgres:
        condition: service_healthy

  # PostgreSQL Database
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init:/docker-entrypoint-initdb.d
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 5s
      timeout: 3s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    networks:
      - backend

  # RabbitMQ Message Broker
  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports:
      - "15672:15672"  # Management UI
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD}
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    networks:
      - backend
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

networks:
  frontend:
  backend:
    internal: true

volumes:
  postgres_data:
  redis_data:
  rabbitmq_data:
```

---

## Compose Commands

### Basic Lifecycle Commands

```bash
# Start all services
docker compose up

# Start in detached mode (background)
docker compose up -d

# Start specific services
docker compose up database cache

# Start and rebuild images
docker compose up --build

# Force recreate containers
docker compose up --force-recreate

# Stop services
docker compose stop

# Stop specific services
docker compose stop web

# Stop and remove containers, networks
docker compose down

# Remove containers, networks, volumes
docker compose down -v

# Remove containers, networks, volumes, images
docker compose down --rmi all -v
```

### Container Management

```bash
# List running services
docker compose ps

# List all containers (including stopped)
docker compose ps -a

# View logs
docker compose logs

# Follow logs (live)
docker compose logs -f

# Logs for specific service
docker compose logs -f web

# Tail last 100 lines
docker compose logs --tail=100

# Execute command in service
docker compose exec web sh

# Execute as root
docker compose exec --user root web sh

# Run one-off command
docker compose run web npm install

# Run and remove container after
docker compose run --rm web python manage.py migrate
```

### Service Control

```bash
# Start services
docker compose start

# Start specific service
docker compose start database

# Restart services
docker compose restart

# Restart specific service
docker compose restart web

# Pause services
docker compose pause

# Unpause services
docker compose unpause

# Stop services gracefully
docker compose stop

# Stop with timeout
docker compose stop -t 30

# Kill services immediately
docker compose kill
```

### Scaling Services

```bash
# Scale service to multiple instances
docker compose up -d --scale web=3

# Scale multiple services
docker compose up -d --scale web=3 --scale worker=5

# Note: Cannot scale services with container_name set
```

### Validation and Debugging

```bash
# Validate compose file
docker compose config

# Validate and view resolved config
docker compose config --resolve-image-digests

# Convert to JSON
docker compose config --format json

# Check which env variables will be used
docker compose config --env

# View service images
docker compose images

# View service ports
docker compose port web 80

# View service processes
docker compose top

# View service resource usage
docker compose stats
```

### Build Commands

```bash
# Build all services
docker compose build

# Build with no cache
docker compose build --no-cache

# Build specific service
docker compose build web

# Pull latest images
docker compose pull

# Pull and build
docker compose up --build --pull

# Push images to registry
docker compose push
```

---

## Production Patterns

### Environment-Specific Configuration

```bash
# Development
docker-compose.yml
docker-compose.override.yml    # Auto-merged

# Production
docker-compose.yml
docker-compose.prod.yml

# Usage
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**Benefits:**

- DRY principle (Don't Repeat Yourself)
- Environment-specific settings
- Easier configuration management
- Version control friendly

**Example structure:**

```yaml
# docker-compose.yml (base)
services:
  app:
    image: myapp
    
# docker-compose.override.yml (dev - auto-loaded)
services:
  app:
    volumes:
      - ./src:/app/src    # Live reload
    ports:
      - "3000:3000"
      
# docker-compose.prod.yml (production)
services:
  app:
    restart: always
    environment:
      NODE_ENV: production
```

### Decision Tree: Compose vs Kubernetes

```mermaid
graph TD
    A[Container Orchestration Need] --> B{Number of hosts?}
    B -->|Single host| C{Scale requirement?}
    B -->|Multi-host| D[Kubernetes]
    
    C -->|< 10 containers| E{Complexity?}
    C -->|> 10 containers| D
    
    E -->|Simple| F[Docker Compose]
    E -->|Complex| G{Budget/Team size?}
    
    G -->|Small/Limited| F
    G -->|Enterprise| D
    
    F --> H[Development/Testing]
    D --> I[Production]
    
    style F fill:#2ecc71
    style D fill:#3498db
    style I fill:#e74c3c
```

### Compose Workflow Best Practices

```markmap
# Docker Compose Best Practices
## File Organization
### docker-compose.yml in project root
### .env for environment variables
### .dockerignore for build optimization
### Separate configs per environment
## Service Design
### One process per container
### Use health checks always
### Set restart policies
### Define resource limits
## Security
### Run as non-root user
### Use read-only filesystems
### Drop unnecessary capabilities
### Never commit secrets
## Development
### Use volumes for live reload
### Override files for dev config
### Named volumes for data
### Bind mounts for code
## Production
### Use specific image tags
### Set memory/CPU limits
### Enable logging drivers
### Implement monitoring
### Use secrets management
```

### Common Pitfalls and Solutions

```ascii
┌────────────────────────────────────────────────────────────┐
│              COMMON DOCKER COMPOSE MISTAKES                │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. Using 'latest' tag in production                       │
│     ❌ image: postgres:latest                              │
│     ✓ image: postgres:15.3                                 │
│                                                            │
│  2. Not using health checks                                │
│     ❌ depends_on: - database                              │
│     ✓ depends_on:                                          │
│         database:                                          │
│           condition: service_healthy                       │
│                                                            │
│  3. Hardcoding secrets in compose file                     │
│     ❌ environment:                                         │
│         DB_PASSWORD: hardcoded123                          │
│     ✓ environment:                                         │
│         DB_PASSWORD: ${DB_PASSWORD}                        │
│                                                            │
│  4. Not using volumes for data persistence                 │
│     ❌ Database without volumes                            │
│     ✓ volumes:                                             │
│         - postgres_data:/var/lib/postgresql/data           │
│                                                            │
│  5. Exposing unnecessary ports                             │
│     ❌ ports:                                              │
│         - "5432:5432"  # Database publicly exposed        │
│     ✓ No ports: - only expose application layer           │
│                                                            │
│  6. Using bind mounts in production                        │
│     ❌ volumes:                                            │
│         - ./data:/app/data                                 │
│     ✓ volumes:                                             │
│         - app_data:/app/data                               │
│                                                            │
│  7. Not setting restart policies                          │
│     ❌ No restart policy                                   │
│     ✓ restart: unless-stopped                              │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Quick Reference

### Command Cheat Sheet

|Task|Command|
|---|---|
|Start services|`docker compose up -d`|
|Stop services|`docker compose down`|
|View logs|`docker compose logs -f`|
|Restart service|`docker compose restart <service>`|
|Rebuild and start|`docker compose up --build`|
|Scale service|`docker compose up -d --scale web=3`|
|Execute command|`docker compose exec <service> <cmd>`|
|View status|`docker compose ps`|
|Remove volumes|`docker compose down -v`|
|Validate config|`docker compose config`|

### Compose File Syntax Reference

```yaml
version: "3.9"

services:
  service_name:
    image: image:tag               # Pre-built image
    build:                         # Build configuration
      context: ./dir
      dockerfile: Dockerfile
      args:
        - ARG_NAME=value
    container_name: name           # Fixed container name
    hostname: hostname             # Container hostname
    ports:                         # Port mappings
      - "host:container"
    expose:                        # Internal ports
      - "port"
    environment:                   # Environment variables
      KEY: value
      - KEY=value
    env_file:                      # Environment file
      - .env
    volumes:                       # Volume mounts
      - volume:/path
      - ./host:/container
      - /container/anonymous
    networks:                      # Network attachments
      - network_name
    depends_on:                    # Dependencies
      service:
        condition: service_healthy
    command: ["cmd", "arg"]        # Override CMD
    entrypoint: ["entry"]          # Override ENTRYPOINT
    restart: always                # Restart policy
    user: "uid:gid"                # Run as user
    working_dir: /path             # Working directory
    healthcheck:                   # Health check
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:                        # Resource limits
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
    labels:                        # Metadata labels
      - "key=value"
    logging:                       # Logging config
      driver: json-file
      options:
        max-size: "10m"

networks:
  network_name:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16

volumes:
  volume_name:
    driver: local
```

### Environment Variable Syntax

```yaml
# Method 1: Key-value pairs
environment:
  KEY: value
  MULTI_LINE: |
    line1
    line2

# Method 2: Array format
environment:
  - KEY=value
  - ANOTHER_KEY=another_value

# Method 3: Reference from .env
environment:
  - DATABASE_URL    # Uses value from .env

# Method 4: Default values
environment:
  PORT: ${PORT:-3000}    # Default to 3000 if not set

# Method 5: From file
env_file:
  - ./common.env
  - ./production.env
```

---

## Summary

### Key Takeaways

```ascii
╔════════════════════════════════════════════════════════════╗
║           DOCKER COMPOSE ESSENTIAL CONCEPTS                ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  1. Declarative multi-container orchestration             ║
║     Single YAML file replaces multiple docker commands    ║
║                                                            ║
║  2. Automatic networking and service discovery            ║
║     Services communicate via service names                 ║
║                                                            ║
║  3. Environment-based configuration                       ║
║     .env files and multiple compose files                  ║
║                                                            ║
║  4. Health checks enable reliable dependencies            ║
║     Wait for services to be ready, not just started        ║
║                                                            ║
║  5. Volumes provide data persistence                      ║
║     Named volumes survive container lifecycle              ║
║                                                            ║
║  6. Single-host limitation                                ║
║     Use Kubernetes for multi-host production               ║
║                                                            ║
║  7. Perfect for development and testing                   ║
║     Reproducible environments, version controlled          ║
║                                                            ║
║  8. Production requires additional considerations         ║
║     Security, monitoring, secrets management               ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### When to Use What

|Scenario|Tool|Reason|
|---|---|---|
|Local development|Docker Compose|Easy setup, reproducible|
|Integration testing|Docker Compose|Multiple services, isolated|
|Small staging env|Docker Compose|Quick deployment, cost-effective|
|Single-host production|Docker Compose|Simple apps, limited scale|
|Multi-host production|Kubernetes|Auto-scaling, high availability|
|Microservices at scale|Kubernetes|Service mesh, load balancing|
|Learning containers|Manual Docker|Understanding fundamentals|
|CI/CD pipelines|Docker Compose|Consistent test environments|

### Migration Path

```mermaid
graph LR
    A[Manual Docker Commands] --> B[Docker Compose]
    B --> C[Docker Swarm]
    B --> D[Kubernetes]
    
    subgraph "Learning Phase"
        A
    end
    
    subgraph "Development"
        B
    end
    
    subgraph "Production Options"
        C
        D
    end
    
    style A fill:#e74c3c
    style B fill:#f39c12
    style D fill:#2ecc71
    
    note1[Manual: Understanding basics]
    note2[Compose: Team development]
    note3[K8s: Enterprise production]
    
    A -.-> note1
    B -.-> note2
    D -.-> note3
```

### Production Deployment Checklist

```ascii
┌────────────────────────────────────────────────────────────┐
│         PRODUCTION DOCKER COMPOSE CHECKLIST                │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  [ ] Use specific image tags (not 'latest')                │
│  [ ] Implement health checks for all services             │
│  [ ] Set restart policies (restart: unless-stopped)       │
│  [ ] Configure resource limits (CPU, memory)              │
│  [ ] Use named volumes for persistence                    │
│  [ ] Externalize all secrets (.env, not in compose file)  │
│  [ ] Set up logging drivers and rotation                  │
│  [ ] Run containers as non-root users                     │
│  [ ] Enable read-only filesystems where possible          │
│  [ ] Implement monitoring and alerting                    │
│  [ ] Set up automated backups for volumes                 │
│  [ ] Document deployment procedures                       │
│  [ ] Test disaster recovery process                       │
│  [ ] Use internal networks for backend services           │
│  [ ] Implement proper error handling                      │
│  [ ] Version control compose files                        │
│  [ ] Set up CI/CD pipelines                               │
│  [ ] Plan for zero-downtime updates                       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Interview One-Liners

```ascii
┌────────────────────────────────────────────────────────────┐
│            DOCKER COMPOSE INTERVIEW ONE-LINERS             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  • "Docker Compose is a declarative tool for defining     │
│    and running multi-container applications"               │
│                                                            │
│  • "Compose automates network creation and provides       │
│    DNS-based service discovery"                            │
│                                                            │
│  • "depends_on controls start order, health checks        │
│    ensure service readiness"                               │
│                                                            │
│  • "Use Compose for development; use Kubernetes for       │
│    production multi-host deployments"                      │
│                                                            │
│  • "Multiple compose files enable environment-specific    │
│    configurations without duplication"                     │
│                                                            │
│  • "Named volumes provide data persistence independent    │
│    of container lifecycle"                                 │
│                                                            │
│  • "Environment variables follow strict precedence:       │
│    shell > compose > env_file > .env > Dockerfile"        │
│                                                            │
│  • "Health checks are critical for reliable service       │
│    dependencies and zero-downtime deployments"             │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Practical Deployment Example

### Complete Project Setup

```bash
# Project structure
my-app/
├── docker-compose.yml
├── docker-compose.prod.yml
├── .env
├── .env.example
├── .dockerignore
├── .gitignore
├── Dockerfile
├── requirements.txt
├── init.sql
└── src/
    ├── app.py
    └── templates/
        └── index.html

# .env.example (commit to git)
MYSQL_ROOT_PASSWORD=changeme
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=changeme
FLASK_PORT=5000

# .gitignore
.env
__pycache__/
*.pyc
.DS_Store
mysql-data/
logs/

# Deployment commands
cp .env.example .env
# Edit .env with actual values

# Development
docker compose up -d

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Monitor logs
docker compose logs -f

# Check health
docker compose ps

# Backup volumes
docker compose exec mysql mysqldump -u root -p --all-databases > backup.sql

# Update application
docker compose build
docker compose up -d

# Cleanup
docker compose down
# Or with volumes
docker compose down -v
```

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Target Audience:** DevOps Engineers, Backend Developers, System Administrators  
**Complexity Level:** Beginner to Advanced  
**Focus Areas:** Multi-container orchestration, Development workflows, Production deployment  
**Related Topics:** Docker networking, Volumes, Kubernetes migration  
**Recommended Review:** Before multi-container projects, team standardization, DevOps interviewsyml up -d

````

```yaml
# docker-compose.yml (base)
version: "3.9"
services:
  app:
    image: myapp
    environment:
      NODE_ENV: development

# docker-compose.override.yml (development - auto-loaded)
version: "3.9"
services:
  app:
    volumes:
      - ./src:/app/src    # Live code reloading
    ports:
      - "3000:3000"       # Expose for debugging

# docker-compose.prod.yml (production)
version: "3.9"
services:
  app:
    restart: always
    environment:
      NODE_ENV: production
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
````

### Multi-Stage Deployment

```yaml
# docker-compose.staging.yml
version: "3.9"

services:
  app:
    image: myapp:${VERSION}
    environment:
      DATABASE_URL: ${STAGING_DB_URL}
      REDIS_URL: ${STAGING_REDIS_URL}
    networks:
      - staging
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

networks:
  staging:
    driver: bridge
```

### Production Security

```yaml
version: "3.9"

services:
  app:
    image: myapp:latest
    read_only: true               # Read-only root filesystem
    security_opt:
      - no-new-privileges:true    # Prevent privilege escalation
    cap_drop:
      - ALL                       # Drop all capabilities
    cap_add:
      - NET_BIND_SERVICE          # Add only needed capabilities
    user: "1000:1000"             # Run as non-root
    tmpfs:
      - /tmp                      # Writable temp storage
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### Monitoring and Logging

```yaml
version: "3.9"

services:
  app:
    image: myapp
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
        labels: "production,myapp"
    labels:
      - "prometheus.scrape=true"
      - "prometheus.port=9090"

  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

---

## Interview Preparation

### Critical Concepts Checklist

```ascii
╔════════════════════════════════════════════════════════════╗
║        DOCKER COMPOSE INTERVIEW CHECKLIST                  ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  [ ] Compose vs manual Docker commands                    ║
║  [ ] Service dependencies and depends_on                  ║
║  [ ] Health checks and wait strategies                    ║
║  [ ] Environment variable precedence                      ║
║  [ ] Network creation and DNS resolution                  ║
║  [ ] Volume persistence patterns                          ║
║  [ ] Multi-stage Dockerfiles                              ║
║  [ ] Production vs development configurations             ║
║  [ ] Scaling limitations                                  ║
║  [ ] Compose file versions                                ║
║  [ ] Security best practices                              ║
║  [ ] When to use Compose vs Kubernetes                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### Common Interview Questions

#### Q1: What is Docker Compose and when should you use it?

**Answer:** Docker Compose is a declarative orchestration tool for defining and running multi-container Docker applications using YAML configuration files. It automates container lifecycle management, networking, and volume creation through a single command interface.

**Use Compose for:**

- Development environments requiring multiple services
- Integration testing with dependent services
- Local staging environments
- Small-scale deployments (single host)
- CI/CD pipeline testing

**Don't use Compose for:**

- Production multi-host deployments (use Kubernetes)
- Auto-scaling requirements
- Multi-region deployments
- Complex orchestration needs

#### Q2: Explain the difference between depends_on and health checks

**Answer:** `depends_on` only controls the startup order - it ensures one container starts before another, but doesn't wait for the service to be ready:

```yaml
services:
  app:
    depends_on:
      - database    # Starts database first, but may not be ready
```

Health checks verify a service is actually ready and functional:

```yaml
services:
  app:
    depends_on:
      database:
        condition: service_healthy    # Waits for health check to pass
  
  database:
    healthcheck:
      test: ["CMD", "pg_isready"]
```

**Production pattern:** Always combine health checks with depends_on for reliable startup.

#### Q3: How does environment variable precedence work in Docker Compose?

**Answer:** Environment variables follow this priority (highest to lowest):

1. Shell environment: `export DB_HOST=override; docker compose up`
2. `environment:` in docker-compose.yml
3. `env_file:` specified files
4. `.env` file in project root
5. Dockerfile `ENV` instructions

**Example:**

```bash
# .env
DB_HOST=postgres

# docker-compose.yml
environment:
  DB_HOST: mysql    # This overrides .env

# Shell
export DB_HOST=localhost
docker compose up   # localhost wins
```

#### Q4: What happens when you run `docker compose down` vs `docker compose down -v`?

**Answer:**

**`docker compose down`:**

- Stops all containers
- Removes containers
- Removes networks
- Keeps volumes intact
- Data persists for next startup

**`docker compose down -v`:**

- Stops all containers
- Removes containers
- Removes networks
- **Removes all volumes**
- All data is lost

**Production warning:** Never use `-v` flag unless you intentionally want to delete all data.

#### Q5: How do you handle secrets in Docker Compose?

**Answer:** Use Docker secrets (Swarm mode) or environment variables from external files:

**Method 1: Docker Secrets (Swarm)**

```yaml
services:
  app:
    image: myapp
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

**Method 2: Environment Variables**

```yaml
services:
  app:
    env_file:
      - secrets.env    # Not in version control
```

**Best practices:**

- Never commit secrets to git
- Use `.gitignore` for secret files
- Use external secret management (Vault, AWS Secrets Manager)
- Encrypt secrets at rest

#### Q6: Can you scale services with Docker Compose?

**Answer:** Yes, but with limitations:

```bash
docker compose up -d --scale web=3
```

**Requirements:**

- Remove `container_name` (prevents scaling)
- Use port ranges or no host port mapping
- Services must be stateless

**Limitations:**

- Single host only
- No load balancing built-in
- Manual port management
- No auto-scaling

**Production alternative:** Use Kubernetes for true horizontal scaling with load balancing and auto-scaling.

#### Q7: Explain the purpose of multiple Compose files

**Answer:** Multiple compose files enable environment-specific configurations:

```bash
# Base configuration
docker-compose.yml

# Development overrides (auto-loaded)
docker-compose.override.yml

# Production configuration
docker-compose.prod.yml

# Usage
docker compose -f docker-compose.yml -f docker-compose.prod.
```


