---
title: 03_Gradient Decent
tags:
  - ML
  - Applied
created: 2025-11-07
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---

### **What is Gradient Descent?**

**Gradient Descent** is an **optimization algorithm** used in machine learning and deep learning to minimize the **loss function** (or cost function). The goal of Gradient Descent is to adjust the model’s parameters (like weights and biases in an ANN) so that the predictions become as close as possible to the true output.

In simple words, Gradient Descent helps a model **learn by reducing its error** — just like a ball rolling down a hill tries to reach the lowest point.

---

### **Concept Behind Gradient Descent**

Imagine the loss function as a **curve** (a hill or valley) representing the model’s error for different weight values.

- The **x-axis** represents the weight parameters.
    
- The **y-axis** represents the loss (error).
    

The aim is to find the weight values where the loss is **minimum** — the bottom of the valley.

Gradient Descent does this by:

1. Calculating the **gradient** (slope) of the loss function with respect to each weight.
    
2. Moving the weights slightly in the **opposite direction** of the gradient (since gradient points toward the direction of maximum increase).
    
3. Repeating this process until the loss value converges to a minimum.
    

---

### **Mathematical Expression**

Let’s denote:
$$

- ( w ) = current weight
    
- ( L(w) ) = loss function
    
- ( \frac{dL}{dw} ) = gradient (slope) of the loss with respect to the weight
    
- ( \eta ) = learning rate
$$
    

Then the weight update rule is:  
$$
[  
w_{\text{new}} = w_{\text{old}} - \eta \times \frac{dL}{dw}  
]

$$
- If the slope (gradient) is **positive**, subtracting it decreases ( w ).
    
- If the slope is **negative**, subtracting it increases ( w ).
    
- This process continues iteratively until the slope approaches zero — meaning the model has reached the optimal weights.
    

---

### **Learning Rate (η)**

The **learning rate** is a small constant that controls how big the steps are during optimization:

- If **η is too large**, the model might overshoot the minimum and fail to converge.
    
- If **η is too small**, convergence becomes very slow.
    
- A good learning rate ensures smooth and stable convergence.
    

---

### **Types of Gradient Descent**

1. **Batch Gradient Descent:**
    
    - Uses the entire training dataset to compute the gradient for each step.
        
    - Very accurate but slow for large datasets because it updates weights only after one full pass (epoch).
        
2. **Stochastic Gradient Descent (SGD):**
    
    - Updates weights after each training example.
        
    - Much faster but has noisy updates (loss curve fluctuates).
        
    - Helps escape local minima due to randomness.
        
3. **Mini-Batch Gradient Descent:**
    
    - A compromise between batch and stochastic methods.
        
    - Uses small batches (e.g., 32 or 64 samples) to compute each update.
        
    - Efficient, stable, and widely used in modern deep learning frameworks.
        

---

### **Example Intuition**

Suppose you’re standing on a hill in thick fog and want to reach the lowest point (the valley).

- You can’t see far ahead, but you can **feel the slope** beneath your feet.
    
- You take a small step downhill (opposite direction of slope).
    
- You repeat this again and again — each time adjusting your direction slightly.  
    Eventually, you reach the bottom of the hill.  
    That’s exactly how **Gradient Descent** works — finding the “lowest error” by taking small steps guided by the gradient.
    

---

### **Variants of Gradient Descent (with Momentum & Adaptive Methods)**

Over time, several advanced versions of Gradient Descent were developed to improve convergence:

- **Momentum:** Adds a fraction of the previous update to the current one, helping accelerate learning and avoid oscillations.
    
- **RMSProp:** Adjusts the learning rate based on recent gradient magnitudes.
    
- **Adam (Adaptive Moment Estimation):** Combines Momentum and RMSProp — most widely used in deep learning.
    

---

### **Summary**

- **Goal:** Minimize the loss function by updating weights in the opposite direction of the gradient.
    
$$
- **Formula:** ( w_{\text{new}} = w_{\text{old}} - \eta \times \frac{dL}{dw} )
$$
    
- **Learning Rate:** Controls step size.
    
- **Types:** Batch, Stochastic, and Mini-Batch.
    
- **Variants:** Momentum, RMSProp, Adam.
    

---
