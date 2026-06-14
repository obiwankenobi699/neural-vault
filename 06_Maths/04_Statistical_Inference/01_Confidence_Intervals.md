# Confidence Intervals

A confidence interval (CI) is a range of values that, with a specified probability, contains the true population parameter. It is the honest way to report an estimate — instead of a single point, you give a range that reflects estimation uncertainty.

## Construction

For a sample mean with known population standard deviation:
```
CI = x̄ ± z* * (σ / √n)
```

Where z* is the critical value from the standard normal distribution (1.96 for 95% CI).

In practice, σ is unknown and estimated from the sample (s), requiring the t-distribution:
```
CI = x̄ ± t* * (s / √n)
```

```python
import numpy as np
import scipy.stats as stats

data = np.random.normal(50, 10, size=30)
n = len(data)
mean = np.mean(data)
se = stats.sem(data)   # standard error = s/√n

ci_95 = stats.t.interval(0.95, df=n-1, loc=mean, scale=se)
print(f"95% CI: ({ci_95[0]:.2f}, {ci_95[1]:.2f})")
```

## What 95% Confidence Actually Means

A 95% CI does not mean "there is a 95% probability that the true parameter is in this interval." The true parameter is fixed — it either is or is not in the interval. The correct interpretation: if you repeated this sampling procedure many times and computed a CI each time, 95% of those intervals would contain the true parameter.

This is subtle but important. A single interval is either right or wrong; you just do not know which.

## Width of Confidence Intervals

The width of a CI depends on three factors. Larger sample size → narrower CI (more data, less uncertainty). Higher confidence level (99% vs 95%) → wider CI (more confidence requires a wider net). Higher variability in data → wider CI.

## Bootstrap Confidence Intervals

When the distribution of the estimator is unknown or non-normal, bootstrap CIs are a non-parametric alternative. You resample your data with replacement thousands of times, compute the statistic each time, and use the percentiles of that distribution as the CI bounds.

```python
import numpy as np

data = np.array([2, 4, 7, 1, 9, 5, 3])
bootstrap_means = [np.mean(np.random.choice(data, size=len(data), replace=True))
                   for _ in range(10000)]
ci_low = np.percentile(bootstrap_means, 2.5)
ci_high = np.percentile(bootstrap_means, 97.5)
print(f"Bootstrap 95% CI: ({ci_low:.2f}, {ci_high:.2f})")
```

## ML Application

When comparing two models, do not just compare point estimates of accuracy. Compute confidence intervals for each model's performance metric. If the CIs overlap substantially, the difference may not be meaningful. This is basic model evaluation rigour.

Proceed to `02_Hypothesis_Testing_Part1.md`.
