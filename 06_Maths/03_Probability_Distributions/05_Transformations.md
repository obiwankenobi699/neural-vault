# Transformations — Making Data Usable

When a feature is skewed, non-normal, or spans multiple orders of magnitude, many algorithms perform poorly or produce biased results. Transformations correct for this without changing the underlying information content.

## Why Transform?

Linear models assume linearity between features and target. Residuals in linear regression should be normally distributed. Gradient descent converges faster when features are on similar scales. KDE and probabilistic models are more accurate when data is roughly symmetric. Transformations address all of these by reshaping the distribution.

## Log Transform

The most common transformation for right-skewed positive data. Compresses large values, expands small values.

```python
import numpy as np
import pandas as pd

data = np.array([1, 5, 10, 50, 100, 500, 10000])
log_data = np.log(data)          # natural log
log1p_data = np.log1p(data)      # log(1+x) — safe when data contains zeros
```

Use `log1p` when data contains zeros to avoid log(0) = -∞. After a log transform, right-skewed income data becomes approximately normal.

## Square Root Transform

Milder than log. Useful for count data (Poisson-distributed) where log is too aggressive.

```python
sqrt_data = np.sqrt(data)
```

## Box-Cox Transform

A family of power transformations parameterised by λ. Automatically finds the best λ to make the data most normal.

```
y(λ) = (x^λ - 1) / λ    if λ ≠ 0
y(λ) = log(x)            if λ = 0
```

λ=0 recovers log transform. λ=0.5 is square root. λ=1 is no transform.

```python
from scipy.stats import boxcox
transformed, lam = boxcox(data)   # finds optimal lambda
print(f"Optimal lambda: {lam:.3f}")
```

Box-Cox requires strictly positive data. For data with zeros or negatives, use the Yeo-Johnson transform.

## Yeo-Johnson Transform

Extension of Box-Cox that handles zero and negative values.

```python
from sklearn.preprocessing import PowerTransformer
pt = PowerTransformer(method='yeo-johnson')
X_transformed = pt.fit_transform(X.reshape(-1, 1))
```

## When Not to Transform

Tree-based models (Random Forest, XGBoost, LightGBM) are invariant to monotonic transformations because they split on rank order, not absolute values. Transforming features before feeding them to a tree-based model is unnecessary and adds complexity without benefit.

Neural networks with batch normalisation are largely robust to input scale issues, though log-transforming extremely skewed inputs can still help convergence.

## Summary

| Transform | Use Case | Constraint |
|-----------|----------|------------|
| Log | Right-skewed, positive data | x > 0 |
| Log1p | Same, but with zeros | x ≥ 0 |
| Square Root | Count data, mild skew | x ≥ 0 |
| Box-Cox | Optimal power transform | x > 0 |
| Yeo-Johnson | Optimal, handles negatives | No constraint |

Proceed to `04_Statistical_Inference/01_Confidence_Intervals.md`.
