# Sampling and the Central Limit Theorem

The Central Limit Theorem (CLT) is one of the most powerful results in statistics. It explains why the normal distribution appears so often in practice and why statistical inference works at all.

## Populations and Samples

A population is the entire set of entities you care about. A sample is the subset you actually observe. In ML, your training set is a sample from the true data distribution (the population). Generalisation is the inference problem: does what you learned from the sample hold for the population?

## Sampling Distribution

The sampling distribution is the distribution of a statistic (like the sample mean) computed across many different samples from the same population. If you draw 1000 different samples of size n and compute the mean of each, the distribution of those 1000 means is the sampling distribution of the mean.

```python
import numpy as np

population = np.random.exponential(scale=2, size=100000)  # skewed population
sample_means = [np.mean(np.random.choice(population, size=50)) for _ in range(1000)]
# sample_means will look approximately normal even though population is skewed
```

## Central Limit Theorem

For independent, identically distributed random variables X₁, X₂, ..., Xₙ with mean μ and finite variance σ²:

```
√n * (X̄ - μ) / σ  →  N(0, 1)  as n → ∞
```

In plain terms: the sample mean, when appropriately standardised, converges to a standard normal distribution as sample size grows — regardless of the shape of the original distribution.

The sampling distribution of the mean has:
- Mean = μ (same as population)
- Standard deviation = σ/√n (called the standard error)

As n increases, the standard error shrinks: larger samples give more precise estimates.

## Standard Error

```
SE = σ / √n
```

The standard error measures how much sample means vary around the true population mean. It is not the standard deviation of the data — it is the standard deviation of the estimator.

```python
import numpy as np
data = np.random.normal(loc=10, scale=3, size=100)
se = np.std(data, ddof=1) / np.sqrt(len(data))
print(f"Standard Error: {se:.4f}")
```

## Why CLT Matters for ML

Confidence intervals and hypothesis tests are built on the assumption that sample statistics are normally distributed — the CLT is the justification. Mini-batch gradient descent uses random samples from the training data at each step; the CLT underlies the expectation that gradient estimates converge to the true gradient.

## Rule of Thumb

The CLT approximation is generally acceptable for n ≥ 30 for unimodal distributions. Heavily skewed or multimodal distributions may require larger n. For the exponential distribution, n ≥ 50 is safer.

Proceed to `04_Distribution_Diagnostics.md`.
