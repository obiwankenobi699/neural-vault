# Eigenvalues and Eigenvectors
Source: Session 19 of playlist (premium)
Watch: https://www.youtube.com/watch?v=5HDkRG5gQHM

## Definition

For a square matrix A, an eigenvector v and eigenvalue lambda satisfy: A times v = lambda times v. Applying A to v produces the same vector, only scaled by lambda. The direction is preserved; only the magnitude changes.

Eigenvectors are the special directions in space that the transformation does not rotate. They are the natural axes of the transformation.

## Computing Eigenvalues

The characteristic equation: det(A - lambda times I) = 0. Solving this polynomial gives the eigenvalues. Substituting each eigenvalue back into (A - lambda I) v = 0 gives the corresponding eigenvector.

```python
import numpy as np
A = np.array([[3, 1],
              [0, 2]])

eigenvalues, eigenvectors = np.linalg.eig(A)
print("Eigenvalues:", eigenvalues)        # [3., 2.]
print("Eigenvectors:\n", eigenvectors)    # columns are eigenvectors
```

## Eigenvalues of the Covariance Matrix

The covariance matrix is symmetric and positive semi-definite. Its eigenvectors point in the directions of maximum variance in the data. Its eigenvalues tell you how much variance exists in each direction.

The eigenvector corresponding to the largest eigenvalue is the first principal component — the direction of maximum variance. The second eigenvector (orthogonal to the first) is the second principal component, and so on. This is exactly what PCA computes.

```python
X = np.random.randn(100, 3)
cov = np.cov(X.T)
eigenvalues, eigenvectors = np.linalg.eigh(cov)   # eigh for symmetric matrices
# Sort descending
idx = np.argsort(eigenvalues)[::-1]
eigenvalues = eigenvalues[idx]
eigenvectors = eigenvectors[:, idx]
```

## Properties of Symmetric Matrices

For symmetric matrices (like covariance matrices): all eigenvalues are real numbers. Eigenvectors corresponding to different eigenvalues are orthogonal. These properties make symmetric matrices mathematically well-behaved and are why PCA works cleanly.

The trace of a matrix equals the sum of its eigenvalues. The determinant equals their product.

## ML Connection

PCA directly computes eigenvectors and eigenvalues of the covariance matrix. Google's PageRank algorithm is an eigenvector computation on the web link matrix. Spectral clustering uses eigenvectors of the graph Laplacian matrix. Neural network training dynamics are related to the eigenvalues of the Hessian of the loss function.

## Interview Questions

Define eigenvalue and eigenvector. What is the characteristic equation? What do the eigenvectors of a covariance matrix represent? What property do eigenvectors of a symmetric matrix have? What is the relationship between eigenvalues and variance in PCA?
