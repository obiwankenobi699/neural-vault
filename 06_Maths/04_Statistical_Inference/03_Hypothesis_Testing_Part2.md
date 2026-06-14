# Hypothesis Testing Part 2 — p-values, t-tests, Practical Significance

## The p-value

The p-value is the probability of observing a test statistic at least as extreme as the one computed, assuming H₀ is true.

A small p-value means the observed data is very unlikely under H₀ — evidence against it. It does not measure the probability that H₀ is true, the size of the effect, or the practical importance of the result.

```python
from scipy import stats
import numpy as np

control = np.random.normal(50, 10, 30)
treatment = np.random.normal(55, 10, 30)

t_stat, p_value = stats.ttest_ind(control, treatment)
print(f"t = {t_stat:.3f}, p = {p_value:.4f}")
# p < 0.05 → reject H₀, conclude groups differ
```

## One-Sample t-test

Tests whether a sample mean equals a hypothesised population mean.

```python
data = np.random.normal(52, 10, 30)
t_stat, p = stats.ttest_1samp(data, popmean=50)
```

## Two-Sample t-test (Independent)

Tests whether two independent groups have the same mean. Assumes approximately equal variances (use Welch's t-test if variances differ significantly).

```python
t_stat, p = stats.ttest_ind(group_a, group_b, equal_var=False)  # Welch's
```

## Paired t-test

Tests whether the mean difference between paired observations is zero. Use when the same subjects are measured twice (before/after).

```python
before = np.array([80, 90, 85, 88, 76])
after  = np.array([82, 93, 87, 85, 79])
t_stat, p = stats.ttest_rel(before, after)
```

## Statistical vs Practical Significance

Statistical significance (p < 0.05) says: the effect probably exists. Practical significance says: the effect is large enough to matter.

With a sample size of 100,000, a 0.001-unit difference in model accuracy will be statistically significant. It is not practically significant.

The effect size measures practical significance independently of sample size. Cohen's d for two groups:

```python
def cohen_d(g1, g2):
    pooled_std = np.sqrt((np.std(g1, ddof=1)**2 + np.std(g2, ddof=1)**2) / 2)
    return (np.mean(g1) - np.mean(g2)) / pooled_std

d = cohen_d(group_a, group_b)
# d ≈ 0.2: small, d ≈ 0.5: medium, d ≈ 0.8: large
```

Always report both. A model comparison with p=0.001 and d=0.05 is statistically significant but practically negligible.

## Multiple Testing Problem

If you run 20 tests at α=0.05, you expect one false positive by chance. When evaluating many features or comparing many models, correct for multiple comparisons using Bonferroni correction (α/n) or Benjamini-Hochberg FDR control.

Proceed to `04_Chi_Square_Tests.md`.
