---
title: 02_Sampling Data,Filtering,Distinct element in Stream
tags:
  - ML
  - DA
created: 2025-11-11
updated:
  "{ date }":
---

> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 
---

## **Data Stream Sampling and Processing Techniques**

### **1. Introduction**

In data stream systems, it is often **impossible to store or process the entire stream** due to its continuous and high-volume nature.  
Hence, techniques such as **sampling**, **filtering**, and **approximate counting** are used to extract meaningful insights efficiently with limited resources.

---

## **2. Sampling Data in a Stream**

**Sampling** is the process of selecting a small representative subset of data items from a continuous data stream.  
It enables efficient estimation of overall stream properties without processing every element.

Sampling is critical when:

- The data stream is too large to store.
    
- Quick approximate results are needed.
    
- The system operates under memory or time constraints.
    

---

### **2.1 Random Sampling**

In **Random Sampling**, each element in the stream has an **equal probability of being selected**.  
It helps maintain an unbiased sample representing the overall distribution of data.

**Example:**  
If data items arrive continuously, we may randomly pick 1 out of every _n_ elements to represent the stream.

**Use Case:** Estimating average temperature from sensor streams.

---

### **2.2 Systematic Sampling**

In **Systematic Sampling**, elements are selected at **regular intervals** rather than randomly.  
After choosing a random starting point, every _kth_ element is included in the sample.

**Example:**  
Select every 100th data record from the stream after a random start.

**Advantages:**

- Simple and easy to implement.
    
- Works well when data is uniformly distributed.
    

---

### **2.3 Stratified Sampling**

In **Stratified Sampling**, the stream is divided into **subgroups or strata** based on a characteristic (e.g., region, type, category), and random samples are drawn from each stratum.

**Example:**  
For a network monitoring stream, separate samples can be taken from video, audio, and text data streams.

**Benefits:**

- Reduces variance.
    
- Ensures representation from all categories.
    

---

### **2.4 Priority Sampling**

**Priority Sampling** assigns a **priority score** to each data item based on its importance or weight.  
Only elements with higher priority are kept in the sample.

**Example:**  
In financial transaction streams, large-value transactions may be given higher priority.

**Advantage:** Focuses resources on more significant data.

---

### **2.5 Reservoir Sampling**

**Reservoir Sampling** is a classic algorithm for random sampling from an **infinite or unknown-length stream**.  
If we need to maintain a sample of size _k_ from an incoming stream:

1. Fill the reservoir with the first _k_ elements.
    
2. For each new element (i > k), replace an existing element with probability _k/i_.
    

**Result:** Each element has an equal chance of being included.

---

## **3. Filtering in Streams**

**Filtering** reduces the data volume by removing irrelevant or unnecessary data before processing.

---

### **3.1 Time-Based Filtering**

Only data that **arrives within a specific time window** is processed.  
Older data is discarded automatically.

**Example:**  
Keep only data from the last 10 minutes in a real-time analytics dashboard.

**Use Case:** Sliding window queries, recent trend detection.

---

### **3.2 Probabilistic Filtering**

Data is included or discarded based on a **probability function**.  
This is useful when the system must manage high data rates but can tolerate approximations.

**Example:**  
Include each data point with a probability _p_ (e.g., 0.2 means 20% of data is kept).

---

### **3.3 Content-Based Filtering**

The filtering decision depends on the **content or value** of each data record.  
Only records that match certain patterns or attributes are processed.

**Example:**  
Filter only “error” logs from a continuous stream of system messages.

**Use Case:** Intrusion detection, event-based monitoring.

---

## **4. Counting Distinct Elements**

In stream processing, it’s often necessary to estimate the **number of distinct elements** (like unique users or IP addresses) without storing all of them.

### **4.1 Hashing Technique**

A **hash function** maps each element to a unique bit position.  
By observing which bits are set to 1, the system estimates the number of unique elements.

However, this method is memory-intensive for large data.

---

### **4.2 HyperLogLog Algorithm**

**HyperLogLog (HLL)** is a **probabilistic algorithm** for estimating the number of distinct elements in a stream using very little memory.

**Working Principle:**

- Each element is hashed to a binary value.
    
- The algorithm records the position of the **leftmost 1-bit** in each hash.
    
- The maximum observed position helps estimate the cardinality.
    

**Advantages:**

- High accuracy with low memory usage (a few kilobytes).
    
- Ideal for large-scale analytics (used in Redis, Google BigQuery).
    

---

## **5. Estimating Moments**

Moments describe statistical properties of a distribution, such as **mean**, **variance**, and **skewness**.  
In streaming systems, we estimate these moments without storing all data.

### **5.1 AMS Algorithm (Alon–Matias–Szegedy)**

The **AMS Algorithm** estimates frequency moments (Fn) of a data stream using random sampling and hashing.

- **F₁** → Total count of elements.
    
- **F₂** → Sum of squares of frequencies (used to estimate variance).
    
- **F₀** → Number of distinct elements.
    

**Key Idea:**  
Use random variables and hash functions to approximate these values with small space and constant time per element.

---

## **6. Counting Ones in a Window**

In some cases, we need to count the number of **1’s (or specific events)** in the most recent _N_ data items.

A **sliding window** approach is used:

- Maintain a fixed-size window of the last _N_ events.
    
- As new data arrives, old data is dropped.
    
- Count or sum is updated dynamically.
    

**Use Case:** Network packet monitoring, clickstream analytics.

---

## **7. Decaying Window**

A **Decaying Window** assigns **more weight to recent data** and less weight to older data.  
Instead of a hard cut-off, older events gradually lose influence over time.

**Example:**  
Recent user activities influence recommendations more than older ones.

**Mathematically:**  
Weight = exp(−λ * age), where λ controls decay rate.

**Use Case:** Real-time trend analysis, adaptive learning models.

---

## **8. Summary Table**

|**Concept**|**Purpose**|**Key Idea**|
|---|---|---|
|**Random Sampling**|Select random data points|Equal chance for each element|
|**Systematic Sampling**|Regular interval sampling|Fixed periodic selection|
|**Stratified Sampling**|Group-wise sampling|Ensures all categories represented|
|**Priority Sampling**|Weighted by importance|Keeps high-value data|
|**Reservoir Sampling**|Sample from infinite stream|Maintains equal probability|
|**Time-Based Filtering**|Filter by time window|Keeps recent data only|
|**Probabilistic Filtering**|Random discard|Manages overload probabilistically|
|**Content-Based Filtering**|Based on data content|Filters relevant records|
|**HyperLogLog**|Estimate distinct items|Hash-based probabilistic counting|
|**AMS Algorithm**|Estimate statistical moments|Hash-based approximation|
|**Counting Ones**|Count events in window|Sliding window counter|
|**Decaying Window**|Prioritize recent data|Exponential time decay|

---



