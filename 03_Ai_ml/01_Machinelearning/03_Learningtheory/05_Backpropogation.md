---
title: 05_Backprop
tags:
  - ML
  - Applied
created:
  "{ date }":
updated:
  "{ date }":
---


> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 
---

## **1. What is Backpropagation?**

**Backpropagation** (short for _“backward propagation of errors”_) is a **supervised learning algorithm** used to train **multilayer neural networks**.

It works by **calculating the error** at the output layer and **propagating it backward** through the network to update the weights, so the model gradually learns to make more accurate predictions.

Essentially, backpropagation combines:

- **Forward propagation** (computing output from input)
    
- **Backward propagation** (updating weights using gradients via chain rule)
    

It’s the **extension of the Delta Rule** for multilayer networks.

---

## **2. The Main Idea**

Backpropagation aims to **minimize the error (loss)** between predicted output ((y)) and actual target ((t)).  
It uses **Gradient Descent** to adjust weights in the direction that reduces the loss function.

Mathematically, we minimize:  
$$
[  
E = \frac{1}{2} \sum (t - y)^2  
]  
$$
where (E) is the total error.

The weights are updated using:  
$$
[  
w_{ij}^{\text{new}} = w_{ij}^{\text{old}} - \eta \frac{\partial E}{\partial w_{ij}}  
]  
$$
Here,

$$
- ( \eta ) = learning rate,
$$
    
$$
- ( \frac{\partial E}{\partial w_{ij}} ) = derivative of error with respect to weight (gradient).
$$
    

---

## **3. Steps of Backpropagation Algorithm**

### **Step 1: Forward Pass**

- Input data is fed into the network.
    
- Each neuron computes:  
$$
    [  
    z_j = \sum_i (w_{ij} x_i) + b_j  
    ]  
    [  
    y_j = f(z_j)  
    ]  
$$
    where (f) is the activation function (like ReLU, Sigmoid, or Tanh).
    
- Continue this process layer by layer until the **output layer** gives predictions (y).
    

---

### **Step 2: Compute Error at Output Layer**

Compare the predicted output with the actual target using a loss function:  
$$
[  
E = \frac{1}{2} (t - y)^2  
]
$$

This measures how far the network’s output is from the true label.

---

### **Step 3: Backward Pass (Error Propagation)**

Now, we move **backward** through the network to adjust the weights.

1. **Output Layer Error (δ for output neuron):**  
    For a neuron (k) in the output layer:  
$$
    [  
    \delta_k = (t_k - y_k) \cdot f'(z_k)  
    ]  
$$
    Here, (f'(z_k)) is the derivative of the activation function.
    
2. **Hidden Layer Error:**  
    For a hidden neuron (j):  
$$
    [  
    \delta_j = f'(z_j) \sum_k \delta_k w_{jk}  
    ]  
$$
    This means each hidden layer’s error depends on the errors of the next layer.
    

---

### **Step 4: Update Weights and Biases**

Once we have the error terms (δ), we update each weight:  
$$
[  
\Delta w_{ij} = \eta \cdot \delta_j \cdot y_i  
]  
$$
and update the weight:  
$$
[  
w_{ij}^{\text{new}} = w_{ij}^{\text{old}} + \Delta w_{ij}  
]  
$$
Bias is updated similarly:  
$$
[  
b_j^{\text{new}} = b_j^{\text{old}} + \eta \cdot \delta_j  
]
$$

---

### **Step 5: Repeat**

The entire process (forward + backward) is repeated for many **epochs** (iterations over all data) until:

- The error is minimal, or
    
- The model reaches acceptable accuracy.
    

---

## **4. Example (Simple Intuition)**

Imagine a network with:

- 2 input neurons
    
- 2 hidden neurons
    
- 1 output neuron
    

During training:

1. Input passes forward → produces prediction 0.8
    
2. Actual target = 1 → error = (1 - 0.8) = 0.2
    
3. This error flows backward → small weight corrections are made in hidden and input layers.
    
4. After many iterations, output becomes 0.99 (close to target).
    

---

## **5. Role of Activation Function Derivative**

The derivative ( f'(z) ) tells **how sensitive** a neuron’s output is to its input — helping the network adjust the right amount during weight updates.  
For example:

$$
- Sigmoid derivative: ( f'(z) = f(z)(1 - f(z)) )
$$
    
$$
- ReLU derivative: ( f'(z) = 1 ) if (z > 0), else (0)
$$
    

---

## **6. Key Points**

- **Forward pass:** Compute outputs.
    
- **Backward pass:** Compute gradients using chain rule.
    
- **Weight update:** Apply gradient descent.
    
- **Goal:** Reduce overall loss.
    

---

## **7. Advantages**

- Enables **multi-layer networks** (deep learning).
    
- Efficient and mathematically elegant (uses chain rule).
    
- Works well with differentiable activation functions.
    

---

## **8. Limitations**

- Can get stuck in **local minima**.
    
- Suffers from **vanishing or exploding gradients** (especially with deep networks and sigmoid/tanh).
    
- Requires differentiable activation functions.
    
- Sensitive to learning rate choice.
    

---

## **9. Summary Table**

| Step | Description         | Formula                                             |
| ---- | ------------------- | --------------------------------------------------- |
| 1    | Forward Propagation | ( y = f(Wx + b) )                                   |
| 2    | Compute Error       | ( E = \frac{1}{2}(t - y)^2 )                        |
| 3    | Output Error        | ( \delta_k = (t_k - y_k)f'(z_k) )                   |
| 4    | Hidden Error        | ( \delta_j = f'(z_j)\sum_k \delta_k w_{jk} )        |
| 5    | Weight Update       | ( w_{ij}^{new} = w_{ij}^{old} + \eta \delta_j y_i ) |

---

## **10. Real-World Use Cases**

- Image recognition and classification (CNNs use backprop).
    
- Speech recognition systems.
    
- Natural Language Processing (NLP).
    
- Medical image diagnosis.
    
- Game-playing agents and reinforcement learning models.
    

---
