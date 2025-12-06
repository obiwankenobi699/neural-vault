---
title: 03_RBFN
tags:
  - ML
  - Supervised_Classifcation
created: 2025-11-16
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

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

