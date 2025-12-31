---
title: 07_EM algo
tags:
  - ML
  - Applied
created: 2025-11-15
updated:
  "{ date }":
---

# **Expectation–Maximization (EM) Algorithm**

### **Introduction**

The **Expectation–Maximization (EM) Algorithm** is an iterative method used to estimate parameters of statistical models when the data contains **missing values**, **hidden (latent) variables**, or **incomplete information**. It is widely used in clustering (especially Gaussian Mixture Models), density estimation, and probabilistic modeling. EM alternates between estimating missing data and re-optimizing the model parameters until convergence.

---

# **Purpose of the EM Algorithm**

In many real-world problems, we cannot directly compute maximum likelihood estimates because some part of the data is hidden or incomplete. EM overcomes this by:

- Guessing the missing/hidden variables,
    
- Computing expected likelihood,
    
- Updating parameters to maximize this likelihood.
    

This allows EM to solve complex optimization problems that cannot be solved analytically.

---

# **Basic Idea**

EM algorithm repeatedly performs two steps until convergence:

1. **E-Step (Expectation Step):**  
    Estimate the expected value of the hidden variables using current parameter values.
    
2. **M-Step (Maximization Step):**  
    Update the model parameters by maximizing the expected log-likelihood computed in the E-step.
    

This process is repeated until the parameters stop changing significantly.

---

# **Mathematical Form**

### **1. E-Step**

Compute the expectation of the log-likelihood with respect to the unknown latent variables ( Z ):

$$
[  
Q(\theta | \theta^{(t)}) = \mathbb{E}_{Z | X, \theta^{(t)}} [\log P(X, Z | \theta)]  
]
$$

Here,

- ( X ) = observed data
    
- ( Z ) = unobserved/hidden variables
    
- ( \theta ) = model parameters
    

### **2. M-Step**

Update parameters by maximizing the expected log-likelihood:

$$
[  
\theta^{(t+1)} = \arg\max_{\theta} Q(\theta | \theta^{(t)})  
]
$$

---

# **How EM Works Step-by-Step (Conceptually)**

1. **Initialize** model parameters randomly
    
2. **E-Step:**
    
    - Using the current model, estimate the probability of hidden variables
        
    - Assign soft responsibilities (soft clustering)
        
3. **M-Step:**
    
    - Recompute model parameters using these responsibilities
        
4. **Check Convergence:**
    
    - If parameters change very little → stop
        
    - Otherwise → repeat E and M steps
        

---

# **Example: Gaussian Mixture Model (GMM)**

EM is commonly used to estimate parameters for a GMM, where the hidden variable indicates which Gaussian component generated each data point.

### **E-step:**

Compute the probability that point ( x_i ) belongs to cluster ( k ).

### **M-step:**

Update:

- Mean of cluster ( k )
    
- Variance of cluster ( k )
    
- Mixing weight of cluster ( k )
    

---

# **Advantages**

- Works even when data is incomplete or has hidden structure.
    
- Usually converges quickly.
    
- Extremely useful in unsupervised learning (e.g., clustering).
    

---

# **Limitations**

- Can converge to **local maxima**, not always global optimum.
    
- Sensitive to initial parameters.
    
- Requires careful selection of number of components (e.g., for GMM).
    

---

# **Applications**

- Gaussian Mixture Models (GMM)
    
- Soft clustering
    
- Missing data problems
    
- Hidden Markov Models (Baum–Welch algorithm)
    
- Medical imaging segmentation
    
- Speech recognition
    

---
Great — here is the **numerical example of EM Algorithm**, step-by-step, using a **Gaussian Mixture Model (GMM) with 2 clusters**.  
This is the **most common exam question**, and I’ll explain it in a simple + clear way.

---

# ✅ **EM Algorithm – Numerical Example (Gaussian Mixture Model)**

We have data points:

[  
X = {2, 4, 5, 7}  
]

Assume the data comes from **two Gaussian clusters**.  
We must estimate:

- Means: ( \mu_1, \mu_2 )
    
- Variances: ( \sigma_1^2, \sigma_2^2 ) (we will assume equal variance to simplify)
    
- Mixing weights: ( \pi_1, \pi_2 )
    

---

# ✔ Step 1: **Initialize Parameters**

Let’s choose initial values:

$$
[  
\mu_1^{(0)} = 3,\quad \mu_2^{(0)} = 8  
]  
$$
$$
[  
\pi_1^{(0)} = 0.5,\quad \pi_2^{(0)} = 0.5  
]
$$

Variance is assumed fixed:  
$$
[  
\sigma^2 = 1  
]
$$

---

# ✔ Step 2: **E-Step — Compute Responsibilities**

For each data point (x_i), compute the probability that it belongs to cluster 1 or 2.

Formula (Gaussian density):

$$
[  
\gamma_{ik} = \frac{\pi_k \cdot N(x_i | \mu_k, \sigma^2)}  
{\sum_{j=1}^{2} \pi_j \cdot N(x_i | \mu_j, \sigma^2)}  
]
$$

We compute only the numerator because denominator is normalization.

---

### **Compute for each data point**

### 🔹 For ( x = 2 )**

Gaussian with mean 3:  
$$
[  
N(2|3,1) = e^{-(2-3)^2/2} = e^{-0.5} = 0.607  
]
$$

Gaussian with mean 8:  
$$
[  
N(2|8,1) = e^{-(2-8)^2/2} = e^{-18} \approx 0  
]
$$

Responsibilities:  
$$
[  
\gamma_{1}(2) = 1,\quad \gamma_{2}(2) = 0  
]
$$

---

### 🔹 For ( x = 4 )**

Cluster 1:  
$$
[  
N(4|3,1) = e^{-0.5} = 0.607  
]
$$

Cluster 2:  
$$
[  
N(4|8,1) = e^{-8} = 0.0003  
]
$$

Responsibilities:  
$$
[  
\gamma_{1}(4) = 0.995,\quad \gamma_{2}(4) = 0.005  
]
$$

---

### 🔹 For ( x = 5 )**

Cluster 1:  
$$
[  
N(5|3,1) = e^{-2} = 0.135  
]
$$

Cluster 2:  
[  
N(5|8,1) = e^{-4.5} = 0.011  
]

Responsibilities:  
[  
\gamma_{1}(5) = 0.925,\quad \gamma_{2}(5) = 0.075  
]

---

### 🔹 For ( x = 7 )**

Cluster 1:  
[  
N(7|3,1) = e^{-8} = 0.0003  
]

Cluster 2:  
[  
N(7|8,1) = e^{-0.5} = 0.607  
]

Responsibilities:  
[  
\gamma_{1}(7) = 0.0005,\quad \gamma_{2}(7) = 0.9995  
]

---

# ✔ Step 3: **M-Step — Update Parameters**

### **Update Means**

Formula:  
[  
\mu_k = \frac{\sum_i \gamma_{ik} x_i}{\sum_i \gamma_{ik}}  
]

---

### For cluster 1:

$$
[  
\sum \gamma_{i1} x_i =  
1\cdot2 +  
0.995\cdot4 +  
0.925\cdot5 +  
0.0005\cdot7  
]  
[  
= 2 + 3.98 + 4.625 + 0.0035 = 10.6085  
]

[  
\sum \gamma_{i1} = 1 + 0.995 + 0.925 + 0.0005 = 2.9205  
]

[  
\mu_1^{new} = \frac{10.6085}{2.9205} \approx 3.63  
]

$$
---

### For cluster 2:

[  
\sum \gamma_{i2} x_i =  
0\cdot 2 +  
0.005\cdot4 +  
0.075\cdot5 +  
0.9995\cdot7  
]  
[  
= 0 + 0.02 + 0.375 + 6.9965 = 7.3915  
]

[  
\sum \gamma_{i2} = 0 + 0.005 + 0.075 + 0.9995 = 1.0795  
]

[  
\mu_2^{new} = \frac{7.3915}{1.0795} \approx 6.85  
]

---

# ✔ Step 4: **Update Mixing Weights**

[  
\pi_k = \frac{1}{n} \sum_i \gamma_{ik}  
]

For cluster 1:

[  
\pi_1 = \frac{2.9205}{4} = 0.73  
]

For cluster 2:

[  
\pi_2 = \frac{1.0795}{4} = 0.27  
]

---

# ✔ Step 5: **New Parameters After One EM Iteration**

[  
\mu_1 = 3.63,\quad \mu_2 = 6.85  
]  
[  
\pi_1 = 0.73,\quad \pi_2 = 0.27  
]

---

# ✔ Step 6: **Repeat E-step and M-step**

Continue until parameters stop changing (convergence).

---

