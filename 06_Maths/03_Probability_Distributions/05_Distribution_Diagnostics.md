# Distribution Diagnostics

Before selecting a distribution to model your data or applying a transformation, you need tools to assess what distribution your data actually follows. Distribution diagnostics are that toolkit.

## Histogram

The most basic diagnostic. Plot frequency vs value. Visually identifies modality, skew, and rough shape.

```python
import matplotlib.pyplot as plt
import numpy as np

data = np.random.normal(0, 1, 1000)
plt.hist(data, bins=30, edgecolor='black')
plt.title('Histogram')
plt.show()
```

## Kernel Density Estimate (KDE)

A KDE is a smooth version of a histogram. It places a small kernel (usually Gaussian) at each data point and sums them. The result is a continuous probability density estimate that does not depend on bin width choices.

```python
import seaborn as sns
sns.kdeplot(data, fill=True)
```

KDE is used to visually compare the empirical distribution of a feature to a theoretical distribution, and to detect multimodality that a histogram might obscure with poor bin choices.

## QQ Plot (Quantile-Quantile Plot)

A QQ plot compares the quantiles of your data to the quantiles of a theoretical distribution (usually normal). If the data follows the theoretical distribution, points fall along the diagonal line. Systematic deviations reveal the nature of the mismatch:
- S-curve deviation: lighter or heavier tails than normal
- Points curving up at the right end: right skew
- Points curving down at the left end: left skew

```python
import scipy.stats as stats
stats.probplot(data, dist="norm", plot=plt)
plt.title("QQ Plot")
plt.show()
```

## Shapiro-Wilk Test

A formal statistical test for normality. The null hypothesis is that the data is normally distributed.

```python
from scipy.stats import shapiro
stat, p = shapiro(data)
print(f"p-value: {p:.4f}")
# p > 0.05 → fail to reject normality
# p < 0.05 → reject normality
```

Note: the Shapiro-Wilk test is sensitive to sample size. With very large samples it will reject normality for trivially small deviations that have no practical significance. Use it alongside visual inspection, not as a binary decision gate.

## Kolmogorov-Smirnov Test

Tests whether a sample comes from a specified distribution (one-sample) or whether two samples come from the same distribution (two-sample). More general than Shapiro-Wilk.

```python
from scipy.stats import kstest
stat, p = kstest(data, 'norm', args=(np.mean(data), np.std(data)))
```

## Practical Workflow

1. Plot histogram and KDE — get visual intuition about shape.
2. Check skewness and kurtosis numerically — quantify the shape.
3. Use QQ plot — identify which distributional assumption is violated.
4. Run Shapiro-Wilk or KS test — formalise the assessment.
5. Apply transformation if needed (see `05_Transformations.md`).

Proceed to `05_Transformations.md`.
