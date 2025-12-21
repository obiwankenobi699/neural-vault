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

# Python
```
# Use lightweight Python image

FROM python:3.11-slim

  

# Set working directory

WORKDIR /app

  

# Copy dependency file first (layer caching)

COPY requirements.txt .

  

# Install dependencies

RUN pip install --no-cache-dir -r requirements.txt

  

# Copy application code

COPY src/ /app/

  

# Expose Flask port

EXPOSE 5000

  

# Run Flask app

CMD ["python", "app.py"]
```


# Java
```
# stable official Java runtime base image

FROM eclipse-temurin:17-jdk-alpine

  
  
  

# working directory

WORKDIR /app

  

# Copy source code into the container

COPY src/Main.java /app/Main.java

  

# Compile the Java code

RUN javac Main.java

  

# Run the Java application when the container starts

CMD ["java", "Main"]
```

# Node.js




# **docker-compose**

```
version: "3.8"

services:
  mysql:
    user: "${UID}:${GID}" 
    image: mysql:5.7
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: devops
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin
    volumes:
      - ./mysql-data:/var/lib/mysql
      - ./message.sql:/docker-entrypoint-initdb.d/message.sql  
    networks:
      - twotier
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-uroot", "-proot"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 60s

  flask-app:
    image: trainwithshubham/two-tier-flask-app:latest
    container_name: flask-app
    ports:
      - "5000:5000"
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: root
      MYSQL_DB: devops
    depends_on:
      - mysql
    networks:
      - twotier
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

networks:
  twotier:
```

