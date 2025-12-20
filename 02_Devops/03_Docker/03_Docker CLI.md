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
## Docker + systemd notes

## Units

- `docker.service` → actual Docker daemon (`dockerd`).
    
- `docker.socket` → lightweight listener on `/var/run/docker.sock` that auto‑starts `docker.service` when any `docker` command hits the socket.[docker+2](https://docs.docker.com/engine/daemon/start/)​
    

---

## Common commands

bash

`# Status sudo systemctl status docker sudo systemctl status docker.socket # Start / stop daemon sudo systemctl start docker sudo systemctl stop docker sudo systemctl restart docker # Start / stop socket sudo systemctl start docker.socket sudo systemctl stop docker.socket sudo systemctl restart docker.socket # Enable / disable daemon at boot sudo systemctl enable docker sudo systemctl disable docker # Enable / disable socket at boot sudo systemctl enable docker.socket sudo systemctl disable docker.socket`

---

## Recommended laptop/dev setup

On a dev machine (Arch/Ubuntu etc.):

bash

`# 1) Enable on‑demand startup via socket sudo systemctl enable docker.socket sudo systemctl start docker.socket # 2) Do NOT keep full daemon always-on (optional but nice) sudo systemctl disable docker sudo systemctl stop docker`

- On boot, only `docker.socket` is active (very light).
    
- First `docker ps` / `docker run` call hits the socket → systemd auto‑starts `docker.service`.​
    

---

## Why keep only `docker.socket` active?

- **On‑demand startup**: Docker daemon runs only when you actually use Docker; less background RAM/CPU.
    
- **Same UX**: you still just run `docker ...`; systemd transparently starts the daemon.
    
- **Good dev‑machine trade‑off**: fast access to Docker without paying the cost of a long‑running service after every boot.[sleeplessbeastie+2](https://sleeplessbeastie.eu/2020/09/11/how-to-start-docker-service-at-system-boot/)​
