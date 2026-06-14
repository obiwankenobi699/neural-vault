# Correlation and Covariance

Covariance and correlation measure the linear relationship between two variables. They are the mathematical foundation for feature selection, dimensionality reduction (PCA), and regression.

## Covariance

Covariance measures how two variables change together. If they tend to increase together, covariance is positive. If one increases while the other decreases, it is negative.

```
cov(X, Y) = (1/n) * Σ (xᵢ - mean_x)(yᵢ - mean_y)
```

The problem with covariance is that its magnitude depends on the scale of the variables. Comparing covariances across different pairs of features is meaningless unless the scales are the same.

```python
import numpy as np
x = [1, 2, 3, 4, 5]
y = [2, 4, 5, 4, 5]
print(np.cov(x, y, ddof=1))   # returns 2x2 covariance matrix
```

## Pearson Correlation Coefficient

Correlation normalises covariance by the product of standard deviations, producing a dimensionless value in [-1, 1].

```
r = cov(X, Y) / (std_x * std_y)
```

r = 1: perfect positive linear relationship. r = -1: perfect negative linear relationship. r = 0: no linear relationship (but may have a nonlinear one).

```python
print(np.corrcoef(x, y)[0, 1])   # Pearson r
```

## Covariance Matrix

The covariance matrix generalises pairwise covariance to multiple features simultaneously. For n features, you get an n×n symmetric matrix where entry (i, j) is cov(feature_i, feature_j) and the diagonal is the variance of each feature.

```python
import pandas as pd
df = pd.DataFrame({'A': [1,2,3], 'B': [4,5,6], 'C': [7,8,9]})
print(df.cov())   # 3x3 covariance matrix
```

PCA operates directly on the covariance matrix. It finds the directions (eigenvectors) of maximum variance, which are the principal components. Understanding covariance matrices is therefore a prerequisite for understanding PCA.

## Correlation vs Causation

Correlation does not imply causation. Ice cream sales and drowning rates are positively correlated (both increase in summer) but one does not cause the other. Confounding variables drive both. In feature engineering, high correlation between a feature and the target is a useful signal, but a model that learns a spurious correlation will fail in production when the confound disappears.

## Spearman Correlation

Pearson correlation measures linear relationships. Spearman correlation measures monotonic relationships — whether one variable consistently increases as the other increases, even if not linearly. Use Spearman when data is ordinal or when the relationship is monotonic but not linear.

```python
from scipy.stats import spearmanr
rho, pval = spearmanr(x, y)
```

Proceed to `02_Probability_Theory/01_Probability_Fundamentals.md`.
