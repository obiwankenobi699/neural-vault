# Joint, Marginal, and Conditional Probability

When working with more than one random variable simultaneously, you need three probability concepts: joint, marginal, and conditional. These form the backbone of multivariate probabilistic modelling.

## Joint Probability

The joint probability P(A ∩ B) or P(X=x, Y=y) is the probability that two events occur simultaneously. For independent variables: P(X, Y) = P(X) * P(Y). For dependent variables you cannot factorise like this.

The joint distribution fully describes the relationship between two variables. Everything else — marginal and conditional — is derived from it.

```python
import numpy as np
# Joint probability table for two binary variables
# Rows: X=0, X=1 | Cols: Y=0, Y=1
joint = np.array([[0.3, 0.1],
                  [0.2, 0.4]])
print("Sum:", joint.sum())   # must equal 1.0
```

## Marginal Probability

The marginal probability of X is the probability of X regardless of Y. You obtain it by summing (or integrating) the joint distribution over all values of Y — you are "marginalising out" Y.

```
P(X = x) = Σ_y P(X=x, Y=y)
```

```python
p_x = joint.sum(axis=1)   # sum over Y columns → marginal of X
p_y = joint.sum(axis=0)   # sum over X rows   → marginal of Y
print("P(X):", p_x)   # [0.4, 0.6]
print("P(Y):", p_y)   # [0.5, 0.5]
```

In deep learning, marginalising is what happens in variational autoencoders when you integrate over the latent space to get the data likelihood.

## Conditional Probability (Revisited)

Given the joint and marginal, conditional probability follows directly:
```
P(X=x | Y=y) = P(X=x, Y=y) / P(Y=y)
```

```python
# P(X=1 | Y=1) using the table above
p_x1_given_y1 = joint[1, 1] / p_y[1]   # 0.4 / 0.5 = 0.8
```

## Chain Rule of Probability

The joint distribution of many variables can be factored sequentially:
```
P(A, B, C) = P(A) * P(B|A) * P(C|A,B)
```

This is the chain rule. Language models use this exact factorisation — the probability of a sentence is the product of each word's conditional probability given all previous words.

## Independence vs Conditional Independence

X and Y are independent if P(X, Y) = P(X) * P(Y). They are conditionally independent given Z if P(X, Y | Z) = P(X|Z) * P(Y|Z). Conditional independence is more subtle and more useful. In Bayesian networks and graphical models, the entire model structure encodes conditional independence assumptions.

Proceed to `04_Bayes_Theorem.md`.
