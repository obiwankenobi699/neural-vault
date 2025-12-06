---
title: KNN
tags:
  - ML
  - Supervised_Classifcation
created: 2025-11-16
updated:
  "{ date }":
---

> **Subject:** ML
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
Sure! Here’s a well-structured and complete explanation of **KNN** and **Locally Weighted Regression (LWR)** — including formulas, topics, paragraphs, and clearly separated **Advantages** and **Key Features** sections.

---

## **K-Nearest Neighbors (KNN)**

### **Overview**

K-Nearest Neighbors (KNN) is a **supervised, instance-based learning algorithm** used for both **classification** and **regression**. The main idea is that data points with similar features tend to belong to the same class or have similar output values. KNN does not build a model during training; instead, it memorizes the dataset and makes predictions only when a new instance is given.

When predicting, the algorithm identifies the **K closest data points (neighbors)** in the training set and makes a decision based on them — **majority voting** in classification or **averaging** in regression.

---

### **Mathematical Formula**

For a test instance ( x ), the **Euclidean Distance** to each training instance ( x_i ) is calculated as:

$$ d(x, x_i) = \sqrt{ \sum_{j=1}^{n} (x_j - x_{ij})^2 } $$

- $( n )$: Number of features
    
- $( x_j )$: Feature value of test instance
    
- $( x_{ij} )$: Feature value of training instance
    

After finding the K nearest neighbors:

- **Classification:** Choose the class with the highest frequency among neighbors.  
    $$ \hat{y} = \text{mode}(y_i) \quad \text{for} \quad x_i \in K $$
    
- **Regression:** Take the average of the target values of the K neighbors.  
$$ \hat{y} = \frac{1}{K} \sum_{i=1}^{K} y_i $$

---

### **Key Features of KNN**

- **Non-parametric:** No assumption about data distribution.
    
- **Lazy learner:** No explicit training phase; computation happens at prediction time.
    
- **Distance-based:** Uses Euclidean, Manhattan, or Minkowski distance to find nearest neighbors.
    
- **Versatile:** Works for both classification and regression tasks.
    

---

### **Advantages of KNN**

- **Simplicity:** Easy to understand and implement.
    
- **Adaptability:** Handles multi-class problems well.
    
- **Effective for small datasets:** Performs well when data has clear separation between classes.
    
- **No training time:** Since KNN stores data, it’s fast to set up.
    

---

## **Locally Weighted Regression (LWR)**

### **Overview**

Locally Weighted Regression (LWR), or **Locally Weighted Linear Regression**, is an **instance-based regression algorithm**. Unlike global models that fit one function across the entire dataset, LWR fits a **local linear model** around the query point. It assigns higher weights to nearby data points and smaller weights to distant ones, thus giving more importance to local data structure.

---

### **Mathematical Formula**

For a given query point  $xqx_qxq$​, the prediction $y^(xq)\hat{y}(x_q)y^​(xq​)$ is computed as:

$$ \hat{y}(x_q) = \theta^T x_q $$

where the parameter vector θ\thetaθ is estimated using **Weighted Least Squares**:

$$ \theta = (X^T W X)^{-1} X^T W y $$

Here:

- XXX: Matrix of training features
    
- yyy: Vector of target outputs
    
- WWW: **Weight matrix**, where each diagonal element wiw_iwi​ represents the weight for training instance iii:
    

$$ w_i = \exp\left(-\frac{(x_i - x_q)^2}{2\tau^2}\right) $$

- $τ\tauτ$: **Bandwidth parameter** controlling how quickly the weight decreases with distance.
---

### **Key Features of LWR**

- **Local fitting:** Builds a separate model for each query point.
    
- **Weighted influence:** Nearby data points influence the prediction more than distant ones.
    
- **Captures non-linearity:** Effective for data with local variations and patterns.
    
- **No global training:** The model is computed at prediction time.
    
	**Memory Based**:Due To Model Based It also have a general  Memory
---

### **Advantages of LWR**

- **High flexibility:** Adapts to complex and non-linear relationships.
    
- **Smooth predictions:** Produces smooth and continuous regression curves.
    
- **Handles local irregularities:** Performs well when global models fail to generalize.
    
- **Theoretical grounding:** Based on well-defined optimization and distance metrics.
    

---
## **Kernel Density Estimation (KDE)**

### **Overview**

Kernel Density Estimation (KDE) is a **non-parametric method** used to estimate the **probability density function (PDF)** of a random variable. Unlike parametric models (which assume a fixed distribution like Gaussian or Poisson), KDE **does not assume any specific data distribution**. It’s often used for **data visualization**, **density estimation**, and **anomaly detection**.

KDE works by placing a smooth, symmetric function (called a **kernel**) over each data point. These kernels are then summed to produce a continuous probability density curve. The smoothness of this curve is controlled by a parameter called the **bandwidth (h)**.

---

### **Mathematical Formula**
$$
$
For a dataset with 
n
n samples 
(x1,x2,...,xn)
(x
1
	​

,x
2
	​

,...,x
n
	​

), the KDE at a point 
x
x is given by:

f^(x)=1nh∑i=1nK(x−xih)
f
^
	​

(x)=
nh
1
	​

i=1
∑
n
	​

K(
h
x−x
i
	​

	​

)

Where:

f^(x)
f
^
	​

(x) → Estimated probability density at point 
x
x

K
K → Kernel function (commonly Gaussian):

K(u)=12πe−u22
K(u)=
2π
$


$$

---

### **Key Features of KDE**

- **Non-parametric:** No assumption about data distribution.
    
- **Flexible:** Can model complex, multi-modal distributions.
    
- **Smooth estimation:** Produces continuous and differentiable curves.
    
- **Used in visualization:** Commonly used in seaborn’s `kdeplot()` and density-based clustering.
    

---

### **Advantages of KDE**

- **Adaptive density modeling:** Works well for irregular data.
    
- **Visualization-friendly:** Helps understand data distribution intuitively.
    
- **Useful for outlier detection:** Low-density regions often indicate anomalies.
    
- **Simple concept:** Easy to compute and interpret.
    

---

## **Case-Based Learning (CBL)**

### **Overview**

Case-Based Learning (CBL), also known as **Case-Based Reasoning (CBR)**, is an **instance-based learning approach** that solves new problems based on the **solutions of previously encountered similar problems** (called “cases”).

Instead of learning an explicit global model, CBL stores a collection of past experiences. When a new problem arises, it searches for the **most similar case(s)**, adapts the previous solution, and applies it to the current context. This approach mimics **human reasoning**, where decisions are made by recalling similar past experiences.

---

### **Process of Case-Based Learning**

1. **Retrieve:** Identify and retrieve similar past cases from memory.
    
2. **Reuse:** Apply the solutions of retrieved cases to the new problem.
    
3. **Revise:** Adapt and refine the solution based on the new situation.
    
4. **Retain:** Store the new problem and its solution as a new case for future reference.
    

---

### **Mathematical View**

Although CBL is conceptual, the similarity between a new case ( x_q ) and a stored case ( x_i ) can be computed using a **distance function**, typically:

$$
[  
\text{Similarity}(x_q, x_i) = \frac{1}{1 + \sqrt{\sum_{j=1}^{n}(x_{qj} - x_{ij})^2}}  
]

$$
The higher the similarity, the more relevant that past case is considered.

---

### **Key Features of CBL**

- **Memory-based:** Stores and retrieves experiences instead of learning rules.
    
- **Human-like reasoning:** Mimics expert decision-making.
    
- **Incremental learning:** Improves over time as new cases are added.
    
- **Adaptable:** Works well in dynamic and real-world problem settings.
    

---

### **Advantages of CBL**

- **Interpretable:** Easy to explain and justify decisions using previous cases.
    
- **Continuous learning:** System grows more intelligent as it accumulates cases.
    
- **Flexible:** Can handle unstructured and context-specific problems.
    
- **Domain-independent:** Used in medicine, law, helpdesk systems, and diagnostics.
    

---

### **Comparison Note:**

|Aspect|KNN / LWR|KDE|Case-Based Learning|
|---|---|---|---|
|Type|Instance-based|Non-parametric density estimation|Instance-based reasoning|
|Purpose|Prediction / Regression|Estimate data distribution|Problem solving using past cases|
|Model|Lazy (no training)|No model; probabilistic function|Knowledge-based memory|
|Output|Label or value|Probability density|Adapted solution|

---
Sure — here’s a clean, **fully theoretical explanation of Radial Basis Function Network (RBFN)** in paragraph form, suitable for your **college notes or Obsidian**, with all layers clearly explained and math formulas in `$$` blocks.  
(No emojis, no icons — just academic format.)


Got it — I’ll pick the most useful one for your earlier question: **KDE for X = number of heads (0, 1, 2)**.  
Below is an improved ASCII “KDE-style” plot that shows the discrete probability masses (o) at 0,1,2 heads and a smoothed kernel curve (*) that interpolates between them.

```
Density
0.60 |                               *                                
0.55 |                              ***                               
0.50 |              *            *******            *                  
0.45 |             ***          *********          ***                
0.40 |            *****        ***********        *****               
0.35 |           *******      *************      *******              
0.30 |         ***********  ***************  ***********            
0.25 |  o      ****************************************     o       
0.20 |  |       **************************************       |       
0.15 |  |        ************************************        |      
0.10 |  |          ******************************          |       
0.05 |  |            ************************          |         
0.00 +--------------------------------------------------------------
         0.0        0.5         1.0         1.5         2.0
                     X = number of heads (discrete)

Marks:
  o  = exact probability mass (P(X=0)=0.25, P(X=1)=0.50, P(X=2)=0.25)
  |  = vertical stem under each mass
  *  = KDE-style smooth curve (artistic approximation of smoothing)
```

Short notes:

- Exact probabilities are: P(0)=1/4, P(1)=1/2, P(2)=1/4 — shown as `o` at heights ≈0.25 and 0.50.
    
- The `*` curve is a visual Gaussian-kernel smoothing of those masses to illustrate how a KDE would look on a small discrete support.
    
- If you want a plain ASCII histogram (no smoothing) or the categorical KDE over the four outcomes {HH, HT, TH, TT}, I can produce that next.
---

## Radial Basis Function Network (RBFN)

A **Radial Basis Function Network (RBFN)** is a type of **artificial neural network** that uses radial basis functions as activation functions in its hidden layer. It is mainly used for **classification**, **regression**, and **function approximation** problems. The network is particularly effective for learning non-linear relationships because it combines the advantages of local approximation (through radial functions) and linear output mapping.

---

### Structure of RBFN

The RBFN is composed of **three main layers** — the input layer, the hidden layer, and the output layer. Each of these layers plays a specific role in transforming the input data into an output prediction.

1. **Input Layer:**  
    The input layer receives the feature vector from the dataset. It does not perform any computation; its main role is to pass the input data to the hidden layer. For example, if the input has features ( (x_1, x_2, ..., x_n) ), then each neuron in the input layer corresponds to one feature.
    
2. **Hidden Layer:**  
    The hidden layer is the core of the RBFN. It contains neurons that use **radial basis functions** (commonly Gaussian functions) as activation functions. Each hidden neuron represents a “center” or center of a cluster or cluster center   in the input space and computes the distance between the input vector and its center.  
    The activation of each hidden neuron is determined by how close the input is to its center, using the following Gaussian function:
    
    $$  
    \phi_i(| x - c_i |) = \exp\left(-\frac{| x - c_i |^2}{2\sigma_i^2}\right)  
    $$
    
    Here, ( c_i ) represents the center of the ( i^{th} ) neuron, and ( \sigma_i ) is the spread (or width) that controls how far the neuron’s influence extends in the input space.
    
3. **Output Layer:**  
    The output layer produces the final output by taking a **weighted linear combination** of the activations from the hidden layer. This combination allows the network to approximate complex mappings between inputs and outputs.  
    The mathematical representation of the RBF network output is:
    
    $$  
    \hat{y}(x) = \sum_{i=1}^{N} w_i , \phi_i(| x - c_i |)  
    $$
    
    In this formula:
    
    - ( N ) is the number of hidden neurons.
        
    - ( w_i ) is the weight associated with the ( i^{th} ) hidden neuron.
        
    - ( \phi_i(| x - c_i |) ) is the activation value of the ( i^{th} ) neuron.
        

---

### Working Principle

When an input vector ( x ) is fed to the network, the hidden layer computes the radial basis activation for each neuron based on its distance from the center. The neurons closer to the input point produce higher activation values, while distant ones contribute less. The output layer then combines these activations linearly to produce the final prediction.

The RBFN thus acts as a **localized learner**, meaning that each hidden neuron focuses on a specific region of the input space. This makes RBFN particularly effective for problems where the data exhibits local clusters or regions of similarity.

---

### Learning Process

Training an RBFN typically involves three steps:

1. **Choosing Centers (( c_i ))** — The centers of the radial functions are often chosen using clustering methods such as **K-means**.
    
2. **Determining Spread (( \sigma_i ))** — The spread of each radial function is calculated based on the distance between centers. A small spread makes the function sensitive to local changes, while a large spread creates smoother approximations.
    
3. **Learning Output Weights (( w_i ))** — The weights are learned using **linear regression** or **least squares** methods to minimize the difference between the predicted and actual output values.
    

---

### Advantages of RBFN

Radial Basis Function Networks offer several advantages:

- They train faster compared to other neural networks, as only the output layer weights are learned.
    
- They perform well for **non-linear** function approximation.
    
- They handle **local patterns** effectively and are suitable when data is grouped into clusters.
    
- The model is **interpretable** and mathematically elegant.
    

---

### Limitations of RBFN

Despite their benefits, RBFNs also have some limitations:

- The performance highly depends on the **selection of centers** and the **spread** values.
    
- For high-dimensional or complex data, the network might require a **large number of hidden neurons**, which increases computational cost.
    
- They are sensitive to the **choice of the kernel width** ( \sigma_i ), which affects the smoothness of the approximation.
    

---


