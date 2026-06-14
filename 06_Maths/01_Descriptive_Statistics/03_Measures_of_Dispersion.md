# Measures of Dispersion — Quantiles, Variance, IQR

Dispersion answers: how spread out is the data? Two datasets can have the same mean and wildly different behaviour. Dispersion is what separates them.

## Range

The simplest measure — maximum minus minimum. Completely dominated by outliers. Rarely used in practice beyond a quick sanity check.

## Variance and Standard Deviation

Variance is the average squared deviation from the mean. Standard deviation is its square root, returning the measure to the original unit.

```
variance = (1/n) * Σ (xᵢ - mean)²
std_dev  = √variance
```

Squaring deviations has two effects: it makes all deviations positive, and it amplifies large deviations. This is both a strength (sensitivity to spread) and a weakness (sensitivity to outliers). In ML, variance appears directly in the bias-variance tradeoff — high-variance models overfit.

```python
import numpy as np
data = [2, 4, 4, 4, 5, 5, 7, 9]
print(np.var(data))    # population variance: 4.0
print(np.std(data))    # population std dev:  2.0
# Use ddof=1 for sample variance (Bessel's correction)
print(np.var(data, ddof=1))  # 4.571...
```

## Percentiles and Quantiles

A percentile is the value below which a given percentage of observations fall. The 50th percentile is the median. Quantiles divide the distribution into equal-frequency buckets.

Quartiles divide into four equal parts:
- Q1 = 25th percentile
- Q2 = 50th percentile (median)
- Q3 = 75th percentile

```python
q1, q2, q3 = np.percentile(data, [25, 50, 75])
```

## Interquartile Range (IQR)

IQR = Q3 - Q1. It measures the spread of the middle 50% of the data and is immune to extreme values. This is the basis for the standard outlier detection rule:

```
Lower fence = Q1 - 1.5 * IQR
Upper fence = Q3 + 1.5 * IQR
Any point outside these fences is a candidate outlier.
```

This is exactly what a box plot visualises. The whiskers extend to the fences; points beyond them are plotted individually.

## Box Plot Anatomy

```
  |----[  Q1 |  Q2  | Q3  ]-----|  o  o
min  fence   box    box  fence  outliers
```

## ML Relevance

Feature scaling decisions depend on understanding dispersion. Min-max scaling uses range. Standard scaling uses std dev. Robust scaling uses IQR. Knowing which your data needs requires understanding which dispersion measure is trustworthy for it.

Proceed to `04_Skewness_and_Kurtosis.md`.
