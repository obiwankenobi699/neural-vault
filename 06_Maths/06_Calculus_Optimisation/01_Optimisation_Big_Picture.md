# Optimisation — The Big Picture
Source: Session 22 of playlist (premium)
Watch: https://www.youtube.com/watch?v=T2f8249569Q

## What Machine Learning Optimisation Is

When a model learns, it is adjusting its parameters to minimise a cost function. The parameters are the weights and biases. The cost function measures how wrong the model is on training data. Learning is finding the parameters theta-star that minimise L(theta).

theta-star = argmin L(theta)

The cost function is a surface in parameter space. For a model with millions of parameters this surface lives in millions of dimensions. You cannot visualise it but calculus applies regardless.

## Loss Functions

The choice of loss function defines what wrong means.

Mean Squared Error for regression: average of squared differences between predictions and true values. Penalises large errors heavily due to squaring. Equivalent to maximum likelihood under Gaussian noise assumption.

```python
def mse(y_true, y_pred):
    return ((y_true - y_pred) ** 2).mean()
```

Binary Cross-Entropy for binary classification: negative average log-likelihood of Bernoulli PMF.

```python
import numpy as np
def binary_cross_entropy(y_true, y_pred):
    return -np.mean(y_true * np.log(y_pred + 1e-9) +
                    (1 - y_true) * np.log(1 - y_pred + 1e-9))
```

## Gradient Descent

Gradient descent navigates the loss surface by repeatedly stepping in the direction of steepest descent — the negative gradient.

theta = theta - eta times gradient of L with respect to theta

eta (learning rate) controls step size. Too large: oscillates or diverges. Too small: converges very slowly.

```python
theta = 0.5
lr = 0.01
for _ in range(1000):
    grad = 2 * (theta - 3)   # gradient of (theta-3)^2
    theta -= lr * grad
print(f"Converged to theta = {theta:.4f}")   # ~3.0
```

## Variants

Batch gradient descent computes the gradient on the entire training set per step — exact gradient but expensive for large datasets. Stochastic gradient descent uses one random sample per step — fast but noisy. Mini-batch gradient descent (the standard) uses a random batch of 32 to 512 samples — balances accuracy and computational cost.

## Local vs Global Minima

Convex loss surfaces (linear regression, logistic regression) have only one minimum — gradient descent finds it. Non-convex surfaces (neural networks) have many local minima. In practice most local minima in deep networks have similar loss values to the global minimum, so this is less problematic than theory suggests.

## ML Connection

Every ML model training procedure is gradient descent on a loss function. Adam, RMSProp, Adagrad are adaptive variants of gradient descent that adjust the learning rate per parameter. Learning rate schedulers reduce eta during training. Regularisation (L1, L2) adds a penalty term to the loss function — the gradient of the penalty shrinks weights during training.

## Interview Questions

What is the role of the loss function in ML? Describe gradient descent in your own words. What are the differences between batch, stochastic, and mini-batch gradient descent? What is the learning rate and what happens when it is too large or too small? Why does gradient descent work well for neural networks despite non-convex loss surfaces?
