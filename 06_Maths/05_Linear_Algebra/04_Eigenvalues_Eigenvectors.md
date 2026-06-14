# Eigenvalues and Eigenvectors [PREMIUM CONTENT]

Eigenvectors are the special directions in space that a matrix transformation does not rotate — it only scales them. Eigenvalues are the scale factors.

## Definition

For a square matrix A, an eigenvector v and eigenvalue λ satisfy:
```
A @ v = λ * v
```

Applying A to v produces the same vector, just scaled by λ. The direction is preserved; only the magnitude changes.

## Computing Eigenvalues

The characteristic equation: det(A - λI) = 0. Solving this polynomial gives the eigenvalues.

```python
import numpy as np

A = np.array([[3, 1],
              [0, 2]])

eigenvalues, eigenvectors = np.linalg.eig(A)
print("Eigenvalues:", eigenvalues)      # [3., 2.]
print("Eigenvectors:\n", eigenvectors)  # columns are eigenvectors
```

## Geometric Interpretation

Most vectors change direction when multiplied by A. Eigenvectors are the exceptions — they lie along the "natural axes" of the transformation. A positive eigenvalue means the vector is stretched (λ > 1) or compressed (0 < λ < 1). A negative eigenvalue means it is flipped and scaled.

## Eigenvalues of the Covariance Matrix

The covariance matrix is symmetric and positive semi-definite. Its eigenvectors point in the directions of maximum variance in the data. Its eigenvalues tell you how much variance is in each direction. This is precisely the information PCA extracts — it finds the eigenvectors of the covariance matrix and sorts them by eigenvalue magnitude.

The eigenvector with the largest eigenvalue is the first principal component: the direction of maximum variance.

```python
X = np.random.randn(100, 3)
cov = np.cov(X.T)
eigenvalues, eigenvectors = np.linalg.eigh(cov)  # eigh for symmetric matrices
# Sort by descending eigenvalue
idx = np.argsort(eigenvalues)[::-1]
eigenvalues = eigenvalues[idx]
eigenvectors = eigenvectors[:, idx]
```

## Properties

For a symmetric matrix (like a covariance matrix): all eigenvalues are real, and eigenvectors corresponding to different eigenvalues are orthogonal. These properties make symmetric matrices particularly well-behaved and are why PCA works cleanly.

The trace of a matrix equals the sum of its eigenvalues. The determinant equals their product. Both are invariants under change of basis.

Proceed to `05_Eigen_Decomposition_PCA.md`.
