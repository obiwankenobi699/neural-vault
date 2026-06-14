# Matrix Intuition — Linear Transformations as Geometry
Source: Session 18 of playlist (premium)
Watch: https://www.youtube.com/watch?v=7IV56bGTJTQ

## The Geometric View

Every matrix encodes a geometric transformation of space. When you multiply a matrix A by a vector v, you apply a transformation that moves v to a new position. The columns of A tell you exactly where the standard basis vectors land.

Column 1 is where [1, 0] maps to. Column 2 is where [0, 1] maps to. The transformation of any other vector is determined by these two.

```python
import numpy as np

A = np.array([[2, 0],
              [0, 3]])    # stretches x by 2, y by 3
v = np.array([1, 1])
print(A @ v)   # [2, 3] — each component stretched independently
```

## Types of Transformations

A scaling matrix stretches or compresses along axes. A rotation matrix rotates all vectors by a fixed angle — it has determinant 1 and its transpose equals its inverse. A shear matrix slants space without changing area.

```python
theta = np.pi / 4   # 45 degrees
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])
print(R @ np.array([1, 0]))   # rotated 45 degrees
```

## Column Space and Null Space

The column space of A is the set of all vectors that can be produced by A times v for some v — it is the reachable region of the transformation. The null space is all vectors v such that A times v = 0 — these are the vectors that get collapsed to the origin.

A full-rank matrix maps to the full output space and collapses nothing. A rank-deficient matrix compresses some dimensions to zero.

## What Neural Network Layers Do

Each linear layer applies a matrix transformation to its input. The following activation function (ReLU, sigmoid) then bends and folds the transformed space. Deep networks stack these transformations. Each layer adds another geometric transformation that progressively separates classes in higher-dimensional space. This is why depth increases expressiveness — more transformations mean more complex decision boundaries.

## ML Connection

Understanding transformations geometrically helps debug and design networks. Batch normalisation restores a sensible geometric structure after transformations stretch or skew the distribution. Attention mechanisms in transformers apply learned linear transformations to queries, keys, and values before computing similarity.

## Interview Questions

What does it mean geometrically to multiply a vector by a matrix? What is the column space of a matrix? What does the null space represent? Why does adding more layers to a neural network increase its expressiveness?
