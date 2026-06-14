# Matrices
Source: Session 17 of playlist (premium)
Watch: https://www.youtube.com/watch?v=Y8UjSNSMeZ4

## What is a Matrix

A matrix is a 2D array of numbers arranged in rows and columns. An m x n matrix has m rows and n columns. Every dataset is a matrix: n samples as rows, p features as columns. The weight matrix of a neural network layer is an n x m matrix where n is input dimension and m is output dimension.

```python
import numpy as np
A = np.array([[1, 2, 3],
              [4, 5, 6]])   # 2x3 matrix
print(A.shape)   # (2, 3)
```

## Matrix Operations

Addition and subtraction are element-wise and require identical shapes. Scalar multiplication multiplies every element by the scalar.

Matrix multiplication (not element-wise): the (i, j) entry of the result is the dot product of row i of the left matrix with column j of the right matrix. For A (m x n) times B (n x p), the result is m x p. The inner dimensions must match.

```python
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
print(A @ B)   # [[19,22],[43,50]]
```

Matrix multiplication is not commutative: A @ B is generally not equal to B @ A.

## Transpose

Flipping rows and columns. Entry (i, j) of the transpose equals entry (j, i) of the original.

```python
print(A.T)
```

The covariance matrix is symmetric: C equals its own transpose. This symmetry has critical consequences for eigendecomposition.

## Rank

The rank of a matrix is the number of linearly independent rows (equal to the number of linearly independent columns). A full-rank matrix contains no redundant information. A rank-deficient matrix has at least one column that is a linear combination of others — this corresponds to multicollinearity in regression.

```python
print(np.linalg.matrix_rank(A))
```

## Determinant

The determinant of a square matrix encodes how the matrix scales volume when used as a linear transformation. Determinant = 0 means the matrix is singular and non-invertible — the transformation collapses space to a lower dimension. The OLS solution to linear regression requires (X transpose X) to be invertible, which requires non-zero determinant.

```python
print(np.linalg.det(A))
```

## Matrix Inverse

A inverse satisfies A times A inverse = I (identity matrix). Only square, full-rank matrices are invertible. The OLS solution is beta = (X^T X)^{-1} X^T y.

```python
A_inv = np.linalg.inv(A)
# In practice, solve a linear system directly instead:
x = np.linalg.solve(A, b)   # more numerically stable than inv
```

## Identity Matrix

The identity matrix I satisfies A times I = A. It is the matrix equivalent of the number 1.

```python
I = np.eye(3)
```

## ML Connection

Neural network layer: output = activation(W times x + b) where W is the weight matrix, x is the input vector. Batch computation: output = activation(X times W^T + b) where X is the batch matrix. The covariance matrix used in PCA is a square symmetric matrix. Invertibility of (X^T X) in OLS regression requires full rank — this breaks when features are perfectly collinear.

## Interview Questions

What is matrix multiplication and what are its shape requirements? When is a matrix non-invertible? What does matrix rank represent? What is the identity matrix? Why is it preferable to use np.linalg.solve rather than np.linalg.inv?
