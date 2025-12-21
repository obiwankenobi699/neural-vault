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
