---
title:
  "{ Title }":
tags:
  - ML
  - Applied
created:
  "{ date }":
updated:
  "{ date }":
---

## Activation Functions

Activation functions introduce non-linearity into neural networks so they can learn complex mappings. Below are common and widely used activation functions, grouped from simple to more advanced:

**Binary Step:** A threshold function that outputs 0 or 1 depending on whether the input is below or above a threshold. It is simple but non-differentiable at the threshold and has zero derivative elsewhere, so it is unusable with gradient-based learning.

**Linear:** A identity function that returns the input unchanged. Useful only for output layers in regression tasks because a network composed solely of linear activations is equivalent to a single linear transformation and cannot learn non-linear patterns.

**Sigmoid (Logistic):** Maps inputs to (0, 1) via 1 / (1 + e^-x). It is smooth and useful for binary-output layers but suffers from vanishing gradients for large magnitude inputs and is not zero-centered.

**Tanh (Hyperbolic Tangent):** Maps inputs to (-1, 1) and is zero-centered, often converging faster than sigmoid. It still suffers from the vanishing gradient problem for deep networks.

**ReLU (Rectified Linear Unit):** f(x) = max(0, x). It is computationally cheap, sparsifies activations, and mitigates vanishing gradients for positive inputs. ReLU can suffer from "dying ReLU" where neurons output zero for all inputs and stop learning.

**Leaky ReLU:** Similar to ReLU but allows a small, non-zero slope (e.g., 0.01x) for negative inputs. This reduces the dying ReLU issue while remaining simple to compute.

**PReLU (Parametric ReLU):** Like Leaky ReLU but the negative slope is a learned parameter per neuron, allowing the network to adapt the leakiness.

**ELU (Exponential Linear Unit):** Smooth for negative values, defined as x if x > 0 else α*(exp(x)-1). ELU tends to converge faster and produce mean activations closer to zero, which can speed up learning.

**SELU (Scaled ELU):** A scaled variant of ELU that, under certain conditions (specific initialization and architecture), leads to self-normalizing networks where activations maintain zero mean and unit variance.

**Softplus:** A smooth approximation of ReLU given by log(1 + e^x). It is differentiable everywhere and avoids hard zeroing but is more computationally expensive.

**GELU (Gaussian Error Linear Unit):** Uses a smooth gating mechanism approximating x * Φ(x) (Φ is Gaussian CDF). Popular in modern architectures (e.g., Transformers) for good empirical performance.

**Swish:** f(x) = x * sigmoid(βx) where β is a parameter (often 1). Swish is smooth and non-monotonic, showing improvements in some deep models.

**Softmax:** A multi-dimensional activation used in output layers for multi-class classification. It converts a vector of logits into a probability distribution that sums to 1 by exponentiating and normalizing.

When choosing an activation, consider model depth, task type (classification vs regression), the need for zero-centered outputs, and computational cost.

---

## Gradient Descent and Optimizers

Gradient descent is the family of algorithms used to minimize the loss by updating parameters opposite to the gradient. Variants trade off stability, speed, memory, and ability to escape poor minima.

**Batch Gradient Descent (BGD):** Computes the gradient using the entire training set and updates weights once per epoch. It provides stable, low-variance updates but is computationally expensive and memory-intensive on large datasets.

**Stochastic Gradient Descent (SGD):** Updates weights using one training example at a time. It is computationally efficient per update and can help escape shallow local minima due to noisy updates, but noise can cause high variance in the objective.

**Mini-Batch Gradient Descent:** Uses small batches (e.g., 32, 64, 128) each update. It is the standard practice in deep learning because it balances gradient estimate quality and computation efficiency, and it works well with modern hardware (GPUs).

**Momentum:** Accelerates SGD by adding a fraction of the previous update vector to the current update (velocity). This reduces oscillation in narrow valleys and speeds up convergence on gentle slopes.

**Nesterov Accelerated Gradient (NAG):** A variant of momentum that looks ahead by computing the gradient at the approximate future position. NAG often provides more responsive acceleration than standard momentum.

**AdaGrad:** Adapts the learning rate per parameter inversely proportional to the square root of the sum of squared historical gradients. It is good for sparse data, but its accumulated squared gradients can lead to excessively small learning rates over time.

**RMSProp:** Addresses AdaGrad’s diminishing learning rate by using a moving average of squared gradients to normalize updates. It maintains an adaptive learning rate per parameter and works well in non-stationary settings.

**Adadelta:** A refinement of AdaGrad that restricts windowed accumulation of past gradients and avoids manual learning rate selection by using ratios of accumulated updates and gradients.

**Adam (Adaptive Moment Estimation):** Combines momentum (first moment) and RMSProp-style scaling (second moment). It computes biased-corrected estimates of first and second moments of gradients, yielding fast and robust convergence in many settings. Adam is a widely used default optimizer.

**AdamW:** A variant of Adam that decouples weight decay (L2 regularization) from the adaptive gradient updates, which gives better generalization and corrects problematic regularization behavior in Adam.

**Nadam:** Adam with Nesterov momentum, blending NAG with Adam’s adaptive moments.

**AMSGrad:** A modification of Adam that maintains the maximum of past squared gradients to guarantee a non-increasing step size for each parameter, addressing some theoretical convergence issues.

**L-BFGS (Limited-memory BFGS):** A quasi-Newton second-order optimizer that approximates curvature (inverse Hessian) information. It can converge in fewer steps for small- to medium-sized problems but is memory- and compute-heavy for very large networks.

When selecting an optimizer consider dataset size, presence of sparse features, required stability, and desired speed; Adam or AdamW are common starting points for deep networks, while SGD with momentum is frequently used for large-scale training and when careful generalization is required.

---

## Delta Rule

The Delta Rule (also called the Least Mean Squares rule in some contexts) is a specific gradient-descent learning rule for single-layer networks or linear units. It updates each weight proportionally to the error (target minus output), the input, and the learning rate. The rule aims to minimize mean squared error and is straightforward to derive by differentiating the loss with respect to each weight. The Delta Rule forms the conceptual basis for learning via gradient descent but is limited to shallow networks and linear units.

---

## Generalized Delta Rule and Backpropagation

Backpropagation is the generalized delta rule that enables training of multi-layer (deep) networks. It uses the chain rule from calculus to propagate the output error backward through the network layers and compute gradients for every weight. These gradients are then used by any gradient-descent-based optimizer to perform parameter updates. Backpropagation consists of a forward pass (compute activations and loss) and a backward pass (compute gradients via error propagation). Efficiency is achieved by reusing computed partial derivatives during the backward pass. Backpropagation requires differentiable activation functions and is central to training modern deep neural networks.

---

## Vanishing and Exploding Gradients

During backpropagation, gradients can shrink (vanish) or grow (explode) exponentially across many layers depending on weight initialization and activation choices. **Vanishing gradients** make earlier layers learn very slowly; this is common with sigmoid/tanh activations and deep architectures. **Exploding gradients** cause unstable updates and numerical overflow. Remedies include using ReLU-like activations, careful weight initialization (e.g., Xavier/Glorot, He initialization), batch normalization, gradient clipping, and architectures that enable gradient flow (residual connections).

---

## Regularization and Practical Tips

Regularization techniques improve generalization: **L2 weight decay**, **L1 regularization**, **dropout**, **early stopping**, and **data augmentation**. Choosing batch size affects convergence and generalization: smaller batches add noise that can help escape poor minima, larger batches give stable gradients but may require learning rate scaling. Learning rate scheduling (step decay, cosine annealing, warm restarts) often improves final performance. Monitor training with loss curves and validation metrics to detect overfitting and optimization problems.

---

## How These Pieces Fit Together

Activation functions define non-linear transforms between layers; gradient-descent algorithms and optimizers compute parameter updates from gradients produced by backpropagation; the delta rule is the simple single-layer precursor to backpropagation; modern optimizers (Adam, RMSProp, SGD+momentum) adapt update magnitudes and directions to improve convergence. Proper choice of activations, optimizers, initialization, and regularization is critical to successful training of neural networks.

---
Regression loss functions

These functions are used when the model is predicting a continuous value, such as a house price or temperature. 

Mean Squared Error (MSE) / L2 Loss

- **How it works:** Calculates the average of the squared differences between predicted and actual values.
- **Best for:** Datasets where larger errors are particularly undesirable, as squaring penalizes them more heavily. It assumes the target outputs follow a normal distribution.
- **Limitations:** Highly sensitive to outliers, as they can disproportionately inflate the loss. 

Mean Absolute Error (MAE) / L1 Loss 

- **How it works:** Calculates the average of the absolute differences between predicted and actual values.
- **Best for:** Datasets with many outliers, as it is more robust and less sensitive to extreme values than MSE.
- **Limitations:** The gradient is not continuous or smooth at zero, which can make optimization more complex. 

Huber Loss

- **How it works:** A hybrid of MSE and MAE that is less sensitive to outliers. It behaves like MSE for smaller errors and like MAE for larger ones, with a tunable parameter (delta) controlling the transition point.
- **Best for:** Situations where you want the robustness of MAE but with a differentiable function for easier optimization.
- **Limitations:** Requires careful tuning of the delta parameter. 

Log-Cosh Loss

- **How it works:** A smooth approximation of MAE that penalizes large errors less aggressively than MSE but more smoothly than MAE.
- **Best for:** Regression tasks that need a differentiable and smooth function that is also somewhat robust to outliers.
- **Limitations:** Computationally more expensive than MSE or MAE. 

Classification loss functions

These functions are used when the model is predicting a discrete class, such as "spam" or "not spam". 

Binary Cross-Entropy Loss (Log Loss)

- **How it works:** Measures the dissimilarity between the predicted probability (between 0 and 1) and the actual binary label (0 or 1). It heavily penalizes predictions that are confidently wrong.
- **Best for:** Binary classification problems, like fraud detection or spam filtering. 

Categorical Cross-Entropy Loss

- **How it works:** A generalization of binary cross-entropy for multi-class classification. It compares the predicted probability distribution (using a softmax activation) with the one-hot encoded true labels.
- **Best for:** Multi-class classification problems, such as image recognition or sentiment analysis with multiple emotion categories.
- **Note:** Requires the true labels to be one-hot encoded vectors. 

Sparse Categorical Cross-Entropy Loss

- **How it works:** A variant of categorical cross-entropy that accepts integer-labeled classes directly, removing the need for one-hot encoding.
- **Best for:** Multi-class problems, especially those with a large number of classes where one-hot encoding would consume a lot of memory. 

Hinge Loss

- **How it works:** Originally developed for Support Vector Machines (SVMs). It aims to maximize the margin of separation between classes, penalizing predictions that fall within the margin. The true labels are mapped to `{-1, 1}`.
- **Best for:** "Maximum margin" binary classification problems, where you are more concerned with a robust decision boundary than the prediction probabilities. 

Other specialized loss functions

Kullback-Leibler (KL) Divergence

- **How it works:** Measures how one probability distribution (the predicted one) differs from a second, reference probability distribution (the true one).
- **Best for:** Applications where a model is meant to learn a full probability distribution, such as in variational autoencoders (VAEs). 

Focal Loss

- **How it works:** A modification of cross-entropy loss designed to address class imbalance. It reduces the weight of easy-to-classify examples and focuses training on hard-to-classify examples.
- **Best for:** Object detection tasks where there is a large number of background (easy) examples compared to foreground (hard) examples.