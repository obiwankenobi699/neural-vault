---
title: 02_Buffer
tags:
  - Typescript
  - Backend
created: 2025-11-17
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

### `encrypt-pipeline.ts`

```ts
import crypto from "crypto";
import zlib from "zlib";
import fs from "fs";
import { Transform, TransformCallback } from "stream";

// Custom Transform Stream for Encryption
class EncryptStream extends Transform {
    private key: Buffer;
    private vector: Buffer;
    private cipher: crypto.Cipher;

    constructor(key: Buffer, vector: Buffer) {
        super();
        this.key = key;
        this.vector = vector;

        // Create streaming-friendly cipher (AES-256-CTR)
        this.cipher = crypto.createCipheriv("aes-256-ctr", this.key, this.vector);
    }

    // Runs for every chunk of data
    _transform(chunk: Buffer, encoding: BufferEncoding, callback: TransformCallback) {
        try {
            const encrypted = this.cipher.update(chunk);
            this.push(encrypted);
            callback();
        } catch (err) {
            callback(err as Error);
        }
    }

    // Called at end of stream
    _flush(callback: TransformCallback) {
        try {
            const final = this.cipher.final();
            this.push(final);
            callback();
        } catch (err) {
            callback(err as Error);
        }
    }
}

// --- Generate Key & IV ---
const key = crypto.randomBytes(32);   // 256-bit AES key
const vector = crypto.randomBytes(16); // 128-bit IV

// --- Create Streams ---
const readStream = fs.createReadStream("input.txt");
const gzipStream = zlib.createGzip();
const encryptStream = new EncryptStream(key, vector);
const writeStream = fs.createWriteStream("input.txt.gz.enc");

// --- Pipeline: Read → Compress → Encrypt → Write ---
readStream
  .pipe(gzipStream)
  .pipe(encryptStream)
  .pipe(writeStream);

console.log("Encryption Complete");
```
---
## **1. Node.js Streams**

Node.js streams are built for handling **large data in chunks** instead of loading the full file in memory. They are extremely efficient for large files, network communication, logging systems, or videos. Streams reduce memory usage, improve performance, and allow pipe-based programming: `read → process → write`. There are four major types: Readable, Writable, Duplex, and Transform. Transform Streams are especially important because they modify data as it passes through (e.g., encryption, compression, parsing).

---

## **2. Why Use Transform Streams for Encryption**

Transform Streams allow us to take an incoming chunk of data, encrypt it, and push out the encrypted version. This avoids loading entire files into RAM and enables **streaming encryption**, which is scalable, fast, and suitable for production systems. Since encryption is CPU-intensive, Transform Streams help maintain stability by processing data gradually and efficiently.

---

## **3. Importing Required Modules**

We import the essential Node.js modules:

- **crypto** for AES-256 encryption.
    
- **zlib** for file compression (Gzip).
    
- **fs** for reading/writing files.
    
- **stream.Transform** for building the custom encryption stream.  
    Each module serves a specific purpose in a security pipeline where data must be compressed, encrypted, and safely stored.
    

---

## **4. Why Compression Before Encryption**

We apply Gzip compression _before_ encryption because **encrypted data cannot be compressed** (it becomes high-entropy random bytes). Compressing first reduces file size, speeds up I/O, and is the standard practice for secure pipelines. Order must always be:  
**Original → Compress → Encrypt → Save**

---

## **5. AES-256-CTR and Why It Is Used**

AES-256-CTR is a streaming-friendly cipher mode. Unlike block modes like CBC, CTR turns AES into a keystream generator, making it perfectly suited for processing arbitrary chunk sizes. CTR mode also avoids padding issues and allows chunk-by-chunk transformation without waiting for full blocks. This makes it ideal for large files, real-time encryption, and Transform Streams.

---

## **6. Key and IV Generation**

We generate a **32-byte (256-bit)** key for AES-256 and a **16-byte IV** for AES block alignment. These values provide high security and randomness. The key must be stored securely (e.g., environment variables, key vault), while the IV can be stored publicly along with the encrypted file. Proper key and IV usage prevents replay attacks and ensures safe encryption for every file.

---

## **7. Custom Encryption Transform Stream**

We create a custom class `EncryptStream` that extends `Transform`. In the constructor, we initialize a cipher using `crypto.createCipheriv`. The `_transform` method processes each chunk individually, applying encryption and pushing the encrypted output downstream. `_flush` handles the final bytes of encryption. This pattern is standard for implementing streaming cryptography using Node.js.

---

## **8. Data Pipeline: Read → Compress → Encrypt → Write**

This design pattern uses piping to connect multiple stages into a clean data flow.

1. `fs.createReadStream` reads the file in small chunks.
    
2. `zlib.createGzip` compresses those chunks.
    
3. `EncryptStream` encrypts the compressed data.
    
4. `fs.createWriteStream` writes the final encrypted file to disk.  
    This modular pipeline is efficient, scalable, and easy to extend or monitor.
    

---

## **9. Why This Architecture Matters (Interview Point)**

This approach demonstrates understanding of:

- Stream-based system design
    
- Memory-efficient encryption
    
- Real-world production pipelines
    
- Security best practices (AES, IVs, compression order)
    
- Applying object-oriented concepts (custom class, inheritance, method overriding)
    
---


### **1. `cipher.update()` — Encrypt Streaming Chunks**

- Processes each incoming chunk of data.
    
- Encrypts it **incrementally**, without finishing the cipher.
    
- Called repeatedly for every chunk that flows through the stream.
    

**Purpose:**  
Handle continuous/streaming encryption.

---

### **2. `cipher.final()` — Flush Remaining Encrypted Bytes**

- Called once at the end of the stream.
    
- Completes the encryption operation.
    
- Outputs any remaining buffered bytes needed to finish AES correctly.
    

**Purpose:**  
Close the cipher and ensure the final encrypted output is complete and valid.

---

### **3. `this.push()` — Send Processed Data to Next Stream**

- Outputs the transformed (encrypted) data to the next stage in the pipeline.
    
- Used both after `update()` and after `final()`.
    
- Without `push()`, nothing moves to the next `.pipe()`.
    

**Purpose:**  
Deliver encrypted data downstream and keep the stream pipeline flowing.

---
