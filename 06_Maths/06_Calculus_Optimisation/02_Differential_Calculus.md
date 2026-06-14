# Differential Calculus for ML
Source: Session 23 of playlist (premium)
Watch: https://www.youtube.com/watch?v=-siBIGUREjw

## The Derivative

The derivative f'(x) at a point is the instantaneous rate of change — the slope of the function at that exact point. For ML, the derivative of the loss with respect to a parameter tells you how much the loss increases when you increase that parameter by a tiny amount. This is the signal gradient descent uses.

## Key Rules

Power rule: derivative of x to the n is n times x to the n-1.

Chain rule: derivative of f(g(x)) = f'(g(x)) times g'(x). The chain rule is the single most important calculus rule for deep learning — backpropagation is the chain rule applied repeatedly from output to input through a neural network.

## Partial Derivatives

When a function has multiple inputs (a loss function with millions of parameters), the partial derivative with respect to parameter i measures how the loss changes when only that parameter changes, holding all others constant.

```python
def partial_derivative(f, params, i, h=1e-5):
    params_plus = params.copy()
    params_plus[i] += h
    return (f(params_plus) - f(params)) / h
```

## The Gradient

The gradient is the vector of all partial derivatives. It points in the direction of steepest ascent of the function. Negating it gives the direction of steepest descent — hence gradient descent steps in the direction of the negative gradient.

## Backpropagation

Backpropagation computes gradients in a neural network by applying the chain rule layer by layer from output back to input. For a network with loss L, hidden layer output h = g(x), and final output f(h):

dL/dx = (dL/df) times (df/dh) times (dh/dx)

Modern frameworks (PyTorch, TensorFlow) do this automatically via automatic differentiation. Understanding that they are applying the chain rule is essential for debugging gradient issues.

```python
import torch
x = torch.tensor(3.0, requires_grad=True)
y = (x - 2) ** 2
y.backward()
print(x.grad)   # 2*(3-2) = 2.0 — gradient computed automatically
```

## Vanishing and Exploding Gradients

If each layer multiplies the gradient by a value less than 1, the gradient shrinks exponentially as it propagates backward — vanishing gradients. Deep networks trained with sigmoid activations suffer from this because the sigmoid derivative is at most 0.25 and approaches zero at both extremes.

If each layer multiplies by a value greater than 1, the gradient grows exponentially — exploding gradients.

```python
import numpy as np
def sigmoid(x):      return 1 / (1 + np.exp(-x))
def sigmoid_grad(x): return sigmoid(x) * (1 - sigmoid(x))

print(sigmoid_grad(0))    # 0.25 — maximum gradient of sigmoid
print(sigmoid_grad(10))   # ~4.5e-5 — nearly zero, gradient vanishes

def relu_grad(x): return float(x > 0)
print(relu_grad(10))   # 1.0 — full gradient passes through for positive input
```

ReLU does not saturate for positive inputs — this is the primary reason ReLU replaced sigmoid as the default activation in deep networks.

Solutions to vanishing gradients: ReLU activations, He/Xavier weight initialisation, batch normalisation, residual connections (ResNets).

Solutions to exploding gradients: gradient clipping, careful initialisation.

## ML Connection

Every training step of every neural network is one application of backpropagation (the chain rule) followed by one step of gradient descent. Batch normalisation stabilises the gradient magnitudes across layers. Learning rate warmup schedules start with small steps to avoid large gradient updates at the start of training. Understanding gradient flow is the basis for diagnosing why a network is not learning.

## Interview Questions

What is the chain rule and why is it central to backpropagation? What is the vanishing gradient problem and what causes it? Why does ReLU help with vanishing gradients compared to sigmoid? What is gradient clipping and when is it used? What is automatic differentiation and how does PyTorch implement it?
