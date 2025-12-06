---
title: 01_ANN
tags:
  - ML
  - DL
created: 2025-11-07
updated:
  "{ date }":
---
---

### **Artificial Neural Network (ANN)**

An **Artificial Neural Network (ANN)** is a computational model inspired by how biological neurons in the human brain work. It consists of interconnected nodes (called **neurons**) organized in layers. Each neuron processes input data, applies a weight, passes it through an activation function, and sends the output to the next layer. ANNs learn patterns and relationships within data through training, making them powerful tools for tasks like classification, regression, and pattern recognition.

During training, an ANN adjusts its internal weights using algorithms such as **backpropagation** and **gradient descent** to minimize the difference between predicted and actual outputs.

---

### **Layers in ANN**

ANNs are structured into **three main types of layers**, each serving a specific purpose:

1. **Input Layer:**
   This is the first layer where the data enters the network. Each neuron in this layer represents one feature of the input dataset (for example, pixel values in an image or attributes in a dataset). It doesn’t perform computations—just forwards data to the next layer.

2. **Hidden Layers:**
   These are the intermediate layers where computation occurs. Each hidden layer neuron multiplies its input by weights, adds a bias, and applies an **activation function** (such as ReLU, Sigmoid, or Tanh). The number of hidden layers and neurons in each can vary depending on the problem’s complexity. Deeper networks can learn more abstract features.

3. **Output Layer:**
   The final layer produces the result of the ANN. For a classification task, it might use a **Softmax** activation function to produce class probabilities. For regression tasks, it could produce a single continuous value.

---

### **Use Cases of ANN**

ANNs are widely used across various domains, such as:

* **Image Recognition:** Detecting and classifying objects in images (e.g., face or handwriting recognition).
* **Speech Processing:** Speech-to-text systems and voice assistants.
* **Medical Diagnosis:** Identifying diseases from medical images like X-rays or MRI scans.
* **Financial Forecasting:** Predicting stock prices or credit risks.
* **Natural Language Processing:** Machine translation, chatbots, and sentiment analysis.
* **Autonomous Vehicles:** Detecting objects and making real-time driving decisions.

---

### **Perceptron**

A **Perceptron** is the simplest type of artificial neuron and forms the foundation of more complex neural networks. It was introduced by **Frank Rosenblatt** in 1958.

The perceptron takes multiple inputs, assigns weights to them, sums them, adds a **bias**, and then applies an **activation function** to produce an output. It is primarily used for **binary classification** problems (e.g., classifying inputs into 0 or 1).

Mathematically,
$$
[
y = f(w_1x_1 + w_2x_2 + ... + w_nx_n + b)
]
$$
where:

* $(x_1, x_2, ..., x_n)$ are input features,
* $(w_1, w_2, ..., w_n)$ are weights,
* $(b)$ is the bias, and
* $(f)$ is the activation function (e.g., step function).

If the weighted sum is above a certain threshold, the output is 1; otherwise, it’s 0.

---

### **Parameters of a Perceptron**

1. **Weights (w):**
   Each input feature is multiplied by its corresponding weight. The weight determines how important that input is for the decision.

2. **Bias (b):**
   The bias allows the activation function to shift left or right, improving flexibility in decision boundaries.

3. **Activation Function (f):**
   Determines whether a neuron should activate or not. Common functions include:

   * **Step Function:** Used in basic perceptrons for binary output.
   * **Sigmoid:** Smoothly maps values between 0 and 1.
   * **ReLU (Rectified Linear Unit):** Outputs 0 for negative inputs and the same value for positive ones.
   * **Tanh:** Maps inputs between -1 and 1.

4. **Learning Rate (η):**
   Controls how much the weights are updated during training. Too high a rate may overshoot optimal weights; too low may slow learning.

5. **Epochs:**
   The number of complete passes through the training dataset during learning.

---
