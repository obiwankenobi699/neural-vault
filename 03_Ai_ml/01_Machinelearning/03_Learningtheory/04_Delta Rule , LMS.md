---
title: 04_Delta Rule, LMS
tags:
  - ML
  - Applied
created: 2025-11-07
updated:
  "{ date }":
---

---

### **Definition**

The **Delta Rule** is a supervised learning rule used to train a **single-layer neural network (like a perceptron)**.
It is based on the principle of **gradient descent**, where the model’s weights are updated in proportion to the **error** between the desired output and the actual output.

In simple words:

> The Delta Rule adjusts the weights to minimize the difference between predicted and actual outputs.

---

### **Mathematical Formula**

Let’s define the variables first:
[^1]
* $( \Delta w_i )$: change in weight for input ( i )
* $( \eta )$: learning rate (a small constant)
* $( (t - y) )$: error term, where

  * $( t )$ = target (true output)
  * ( y ) = predicted output
* $( x_i )$: input value for weight ( w_i )

Then the **Delta Rule** is written as:
$$
[
\Delta w_i = \eta (t - y) x_i
]

$$
And the **weight update** becomes:
$$
[
w_i^{\text{new}} = w_i^{\text{old}} + \eta (t - y) x_i
]

$$
---

### **Explanation of the Formula**

1. Compute the **error**: $( (t - y) )$ → how far the model’s output is from the expected output.
2. Multiply the error by the **input** $( x_i )$ — inputs with larger influence get larger adjustments.
3. Multiply by the **learning rate** $( \eta )$ — controls the step size of the update.
4. Add this correction term to the old weight to get the new weight.

This process repeats for every training sample until the total error becomes minimal.

---

### **Connection to Gradient Descent**

The Delta Rule is a **special case of gradient descent** applied to a single-layer perceptron with a continuous activation function (like linear or sigmoid).
It minimizes the **Mean Squared Error (MSE)** loss function:
$$
[
E = \frac{1}{2}(t - y)^2
]
$$
The derivative of (E) with respect to the weight (w_i) gives:
$$
[
\frac{\partial E}{\partial w_i} = -(t - y)x_i
]
$$
Substituting this in the gradient descent formula:
$$
[
w_i^{\text{new}} = w_i^{\text{old}} - \eta \frac{\partial E}{\partial w_i}
]
$$
yields exactly the **Delta Rule**.

---

### **Use Case**

The Delta Rule is mainly used for:

* **Training single-layer networks** (like Adaline).
* **Linear classification or regression problems.**
  It is not used for multi-layer networks because it doesn’t handle **nonlinear activation** or **hidden layers** — for that, we use **Backpropagation** (which extends the Delta Rule).

---

### **Difference Between Perceptron Rule and Delta Rule**

| Feature           | **Perceptron Learning Rule** | **Delta Rule**                        |
| ----------------- | ---------------------------- | ------------------------------------- |
| Activation        | Step (binary)                | Linear or continuous (e.g., Sigmoid)  |
| Error Calculation | Based on misclassification   | Based on numerical difference (t − y) |
| Works For         | Linearly separable data      | Linear and near-linear data           |
| Training Method   | Discrete weight updates      | Gradient-based weight updates         |
| Basis             | Heuristic                    | Derived from Gradient Descent         |

---

### **Example (Intuitive)**

Suppose:

* Input ( x = 2 )
* Target ( t = 1 )
* Predicted ( y = 0.4 )
* Learning rate ( \eta = 0.1 )
* Current weight ( w = 0.5 )

Then:
$$
[
\Delta w = 0.1 (1 - 0.4)(2) = 0.12
]
$$
So,
$$
[
w_{\text{new}} = 0.5 + 0.12 = 0.62
]
$$
The weight has been updated slightly toward reducing the prediction error.

---

### **Summary**

* **Delta Rule:** A weight update rule based on gradient descent.
$$
* **Formula:** ( \Delta w_i = \eta (t - y) x_i )
$$
* **Goal:** Minimize Mean Squared Error.
* **Use:** Trains single-layer networks like Adaline(Single layered NN used for regression and classification).
* **Limitation:** Doesn’t work for multi-layer nonlinear networks.

---
