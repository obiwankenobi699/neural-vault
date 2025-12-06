---
title:
  "{ Title }":
tags:
  - ML
  - DL
created: 2025-11-08
updated:
  "{ date }":
---

---

### **1. Input Layer**

The **input layer** is the starting point of any neural network. It takes the raw data — such as pixel values, sensor readings, or tabular features — and passes it into the network. This layer does not perform learning; it only receives and distributes the input values to the next (hidden) layer. Each node in this layer represents one feature of the data. The main goal here is to properly format and normalize data so that later layers can efficiently learn patterns.

---

### **2. Forward Propagation**

Once the data enters the network, the **forward propagation** process begins. Each neuron in the next layer multiplies the input values by their corresponding **weights**, adds a **bias**, and then sends the result through an **activation function**. This process continues from one layer to the next, propagating information forward until the final output layer is reached. The output at this stage is the model’s current prediction based on its existing weights.

---

### **3. Hidden Layer and Activation Function**

The **hidden layers** are where the real learning happens. Each neuron in these layers receives inputs from the previous layer, computes a weighted sum, and then applies an **activation function**.
Activation functions — such as **ReLU**, **Sigmoid**, or **Tanh** — introduce **non-linearity** into the network. Without them, the network would only learn simple linear relationships.

* **ReLU (Rectified Linear Unit)** outputs `0` for negative values and passes positive values unchanged, making learning faster and reducing vanishing gradient problems.
* **Sigmoid** squashes outputs between 0 and 1, often used in binary classification.
* **Tanh** squashes between −1 and +1, keeping values centered.
  Thus, the hidden layers transform input data into more complex and meaningful internal representations step by step.

---

### **4. Output Layer**

The **output layer** produces the final result of the network after all transformations. The type of output depends on the problem:

* For **regression**, the output might be a single continuous value.
* For **classification**, it often uses **Softmax** (for multi-class) or **Sigmoid** (for binary) activation to convert the network’s outputs into probabilities.
  This layer’s output is compared with the true label to determine how correct the network’s prediction is.
---

### **5. Loss Function in the Output Layer**

* After **forward propagation**, the network produces a prediction ((y_{\text{pred}})) in the **output layer**.
* The **loss function** compares this predicted output with the **true label** ((y_{\text{true}})) to measure **how wrong the network is**.
* Common loss functions:

  * **Mean Squared Error (MSE)** for regression:
$$
    [
    L = \frac{1}{2}(y_{\text{true}} - y_{\text{pred}})^2
    ]
$$
  * **Cross-Entropy Loss** for classification:
$$
    [
    L = - \sum_i y_i \log(y_{\text{pred},i})
    ]
$$

> So yes — the **output layer** is where the **loss is calculated**.

---

### **. Backpropagation Uses the Loss**

* Once the loss is computed, **backpropagation** starts.
* Backpropagation calculates the **gradient of the loss** with respect to each weight in the network:
$$
  [
  \frac{\partial L}{\partial w_{ij}}
  ]
$$
* These gradients tell the network **how much each weight contributed to the error**.
* Gradients are computed **layer by layer, starting from the output layer and moving backward**.

---

### **. Gradient Descent Updates Weights**

* Using the gradients from backpropagation, **gradient descent** updates the weights:
$$
  [
  w_{\text{new}} = w_{\text{old}} - \eta \frac{\partial L}{\partial w}
  ]
$$
* This reduces the loss, meaning the network gets **closer to the correct output**.

---

### **6. Backpropagation**

After the loss is calculated, the **backpropagation algorithm** begins. It works backward through the network, starting from the output layer and moving toward the input layer. Using **the chain rule of calculus**, it computes **gradients** — the partial derivatives of the loss with respect to every weight and bias. These gradients tell the network how much each weight contributed to the total error. In simple terms, backpropagation finds *who is responsible for how much of the error*.

---

### **7. Gradient Descent**

Once gradients are computed, the **gradient descent algorithm** updates the network’s weights to reduce the error. Each weight is adjusted slightly in the direction that decreases the loss:
$$
[
w_{\text{new}} = w_{\text{old}} - \eta \frac{\partial \text{Loss}}{\partial w}
]
$$
Here, ( \eta ) is the **learning rate**, controlling how big the update step should be. If it’s too large, learning becomes unstable; if too small, learning becomes slow. Gradient descent is the **core optimization engine** that moves the learning process forward by continually updating weights to minimize the loss.

---

### **8. Iteration and Learning**

The entire cycle — forward propagation, loss calculation, backpropagation, and gradient descent — happens repeatedly for many **epochs** (iterations over the dataset). With each cycle, the network’s weights are refined, the loss becomes smaller, and predictions become more accurate. This iterative improvement is what we call **training** the neural network.

---
``
### **Summary Flow**

1. **Input Layer** → receives data.
2. **Forward Propagation** → computes predictions.
3. **Hidden Layers** → apply weighted sums + activation functions.
4. **Output Layer** → produces final predicted value.
5. **Loss Function** → measures prediction error.
6. **Backpropagation** → calculates gradients of loss w.r.t weights.
7. **Gradient Descent** → updates weights to reduce error.
8. **Repeat** → network learns over many epochs.

```
              Input Layer
         x1 ---------\
                        \
         x2 -----------> (Hidden Layer neuron 1)
                        /  z1 = w11*x1 + w12*x2 + b1
         x3 ---------/
                           a1 = f(z1)   <-- Activation function (ReLU/Sigmoid/Tanh)

         x1 ---------\
                        \
         x2 -----------> (Hidden Layer neuron 2)
                        /  z2 = w21*x1 + w22*x2 + b2
         x3 ---------/
                           a2 = f(z2)   <-- Activation function (ReLU/Sigmoid/Tanh)

             Hidden Layer outputs
              a1 ----\
                      \
                       \       Output Layer neuron
              a2 -----> z3 = w31*a1 + w32*a2 + b3
                               y_pred = f_out(z3)  <-- Sigmoid/Softmax/Linear

                              Loss Function
                              L = 1/2 * (y_true - y_pred)^2  (MSE)
```

---

### **Forward Pass Formulas**

1. **Hidden layer weighted sum:**
$$
   [
   z_j = \sum_i w_{ji} x_i + b_j
   ]
$$

2. **Hidden layer activation:**
$$
   [
   a_j = f(z_j)
   ]
$$

3. **Output layer weighted sum:**
$$
   [
   z_k = \sum_j w_{kj} a_j + b_k
   ]
$$

4. **Output activation (prediction):**
$$
   [
   y_k = f_{\text{out}}(z_k)
   ]
$$

5. **Loss (error) function:**
$$
   [
   L = \frac{1}{2} \sum_k (y_k - t_k)^2
   ]
$$

---

### **Backpropagation Formulas**

1. **Output layer error term:**
$$
   [
   \delta_k = (y_k - t_k) \cdot f'_{\text{out}}(z_k)
   ]

$$
1. **Hidden layer error term:**
$$
   [
   \delta_j = f'(z_j) \cdot \sum_k \delta_k w_{kj}
   ]

$$
1. **Gradient of weights:**
$$
   [
   \frac{\partial L}{\partial w_{kj}} = \delta_k \cdot a_j
   ]
$$
$$
   [
   \frac{\partial L}{\partial w_{ji}} = \delta_j \cdot x_i
   ]
$$

---

### **Gradient Descent Weight Update**

$$
[
w_{new} = w_{old} - \eta \cdot \frac{\partial L}{\partial w}
]
$$

* ( \eta ) = learning rate
* Update applies to **all weights**: input → hidden, hidden → output
* Biases are updated similarly:
$$
  [
  b_{new} = b_{old} - \eta \cdot \delta
  ]
$$

---

### **Stepwise Flow**

1. Input → compute weighted sum ( z ) → apply activation → produce ( a )
2. Hidden layer outputs → compute output $( y_{pred} )$
3. Compare $( y_{pred} )$ with $( y_{true} )$ → compute loss ( L )
4. Backpropagate errors → compute δ for output and hidden layers
5. Update all weights and biases using gradient descent
6. Repeat for each training sample$/ epoch$

---

