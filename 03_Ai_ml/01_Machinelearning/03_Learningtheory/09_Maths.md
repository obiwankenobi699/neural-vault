---
title: Maths
tags:
  - ML
  - Applied
created: 2025-11-27
updated:
  "{ date }":
---

---

## 1. Neuron Model (Linear Combination + Activation)

### Weighted Sum

$$
[  
Z = \sum_{i=1}^{n} (w_i \cdot x_i) + b  
]
$$

Where:

- (x_i): Input
    
- (w_i): Weight
    
- (b): Bias
    
- (Z): Net input
    

### Activation Output

$$
[  
A = f(Z)  
]

$$
Common activation functions:

#### ReLU

$$
[  
f(Z) = \max(0, Z)  
]
$$

Derivative:  
$$
[  
f'(Z) =  
\begin{cases}  
1 & Z > 0 \  
0 & Z \le 0  
\end{cases}  
]
$$

#### Sigmoid

$$
[  
f(Z) = \frac{1}{1 + e^{-Z}}  
]
$$

Derivative:  
$$
[  
f'(Z) = f(Z)(1 - f(Z))  
]
$$

---

## 2. Forward Propagation (Layer-wise)

For layer (l):

### Weighted Sum

$$
[  
Z^{[l]} = W^{[l]} A^{[l-1]} + b^{[l]}  
]
$$

### Activation

$$
[  
A^{[l]} = f^{[l]}(Z^{[l]})  
]
$$

Final prediction:  
$$
[  
\hat{y} = A^{[L]}  
]
$$

---

## 3. Loss Functions

### Mean Squared Error (Regression)
$$

[  
L = \frac{1}{N} \sum_{i=1}^{N} \left( y^{(i)} - \hat{y}^{(i)} \right)^2  
]
$$

### Binary Cross-Entropy (Binary Classification)

$$
[  
L = -\frac{1}{N} \sum_{i=1}^{N} \left[  
y^{(i)} \log(\hat{y}^{(i)}) +  
(1 - y^{(i)}) \log(1 - \hat{y}^{(i)})  
\right]  
]

$$
---

## 4. Backpropagation (Gradient Computation)

Goal:  
$$
[  
\frac{\partial L}{\partial w_{ij}}  
]

$$
### Error Term for Output Layer (with Sigmoid + MSE)

$$
[  
\delta^{[L]} = ( \hat{y} - y ) \cdot f'(Z^{[L]})  
]
$$

### Error Term for Hidden Layers

For hidden layer (l):

$$
[  
\delta^{[l]} = f'(Z^{[l]}) \cdot \left( W^{[l+1]T} \delta^{[l+1]} \right)  
]
$$

---

## 5. Gradients for Weights and Biases

### Gradient for Weight Matrix

$$
[  
\frac{\partial L}{\partial W^{[l]}} = \delta^{[l]} \cdot A^{[l-1]T}  
]
$$

### Gradient for Bias Vector

$$
[  
\frac{\partial L}{\partial b^{[l]}} = \delta^{[l]}  
]
$$

---

## 6. Gradient Descent Update Rules

### Weight Update

$$
[  
W^{[l]}_{\text{new}} =  
W^{[l]}_{\text{old}} - \alpha \cdot \frac{\partial L}{\partial W^{[l]}}  
]
$$

### Bias Update

$$
[  
b^{[l]}_{\text{new}} =  
b^{[l]}_{\text{old}} - \alpha \cdot \frac{\partial L}{\partial b^{[l]}}  
]
$$

---

## 7. Full Training Cycle (Summary Formulas)

1. Forward Pass:  
$$
    [  
    Z^{[l]} = W^{[l]}A^{[l-1]} + b^{[l]}  
    ]  
$$
$$
    [  
    A^{[l]} = f^{[l]}(Z^{[l]})  
    ]
$$
    
2. Loss Calculation:  
$$
    [  
    L = \text{Loss}(y, \hat{y})  
    ]
$$
    
3. Backpropagation:  
$$
    [  
    \delta^{[L]} = (\hat{y} - y) \cdot f'(Z^{[L]})  
    ]  
$$
$$
    [  
    \delta^{[l]} = f'(Z^{[l]}) \cdot (W^{[l+1]T} \delta^{[l+1]})  
    ]
$$
    
4. Gradient Computation:  
$$
    [  
    \frac{\partial L}{\partial W^{[l]}} = \delta^{[l]} A^{[l-1]T}  
    ]  
$$
$$
    [  
    \frac{\partial L}{\partial b^{[l]}} = \delta^{[l]}  
    ]
$$
    
5. Weight Update:  
$$
    [  
    W^{[l]} \leftarrow W^{[l]} - \alpha \frac{\partial L}{\partial W^{[l]}}  
    ]
$$
    
6. Bias Update:  
$$
    [  
    b^{[l]} \leftarrow b^{[l]} - \alpha \frac{\partial L}{\partial b^{[l]}}  
    ]
$$
    

---