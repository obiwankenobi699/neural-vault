# Confidence Intervals
Source: Session 44, DSMP 2023
Watch: https://www.youtube.com/watch?v=X52HK2qkiIE

## Point Estimate and Its Limitation

Nitish wants to know the average age of his 77,000 YouTube subscribers. He cannot survey all of them. He takes the live class students as a sample and gets a single number — say 28 years. That is the point estimate.

The problem: a single exact number is almost certainly wrong for the population. Nitish's analogy: betting that MS Dhoni scores exactly 25 runs in a match — the probability of the exact number is tiny. But betting he scores between 20 and 35 — much more probable. A range is more honest and more useful than a single point.

## What a Confidence Interval Is

A confidence interval is a range of plausible values for the population parameter, computed from sample data, with an associated confidence level. CI = Point Estimate plus or minus Margin of Error. The confidence level (90%, 95%, 99%) tells you how confident you are that the procedure captures the true parameter.

Nitish points out: those black vertical lines you see at the top of seaborn bar chart bars are confidence interval error bars. Now you know exactly what they represent.

## Correct Interpretation

The correct interpretation of a 95% CI is: if this sampling and interval-calculation procedure were repeated 100 times, approximately 95 of the resulting intervals would contain the true population parameter. The true parameter is fixed — it either is or is not in any specific interval. The 95% refers to the long-run behaviour of the procedure, not to a single interval.

## Z-Procedure (Population Sigma Known)

Three assumptions required: random sample, population standard deviation sigma is known, and either the population is normal or n >= 30 (CLT applies).

CI = x-bar plus or minus z-star times sigma/sqrt(n)

For 95% CI z-star = 1.96. For 99% CI z-star = 2.576. For 90% CI z-star = 1.645.

Why 1.96 for 95%? Because norm.cdf(1.96) = 0.975. The area between -1.96 and +1.96 under the standard normal is exactly 0.95.

```python
import numpy as np
from scipy.stats import norm

x_bar = 28.5
sigma = 5   # known population std dev
n = 100

se = sigma / np.sqrt(n)
z_star = norm.ppf(0.975)   # 1.96
ci = (x_bar - z_star * se, x_bar + z_star * se)
print(f"95% CI: {ci}")
```

## T-Procedure (Population Sigma Unknown)

In practice sigma is almost never known. You estimate it from the sample using s (sample standard deviation with ddof=1). When sigma is unknown you use the t-distribution instead of the standard normal.

The t-distribution has heavier tails than the normal distribution, accounting for the additional uncertainty from estimating sigma. Its shape depends on degrees of freedom = n - 1. As n increases, the t-distribution converges to the standard normal.

CI = x-bar plus or minus t-star times s/sqrt(n)

```python
from scipy import stats
import numpy as np

sample = np.array([22, 25, 28, 30, 24, 27, 31, 26, 29, 23])
n = len(sample)
x_bar = np.mean(sample)
se = stats.sem(sample)   # s / sqrt(n)

ci = stats.t.interval(0.95, df=n-1, loc=x_bar, scale=se)
print(f"95% CI: ({ci[0]:.2f}, {ci[1]:.2f})")
```

Use t-procedure in practice. When n is large the difference from z-procedure is negligible.

## Effect of Sample Size and Confidence Level

Larger n gives narrower intervals — more data means more precision. Higher confidence level (99% vs 95%) gives wider intervals — more confidence requires a wider net. To halve the CI width you need four times the sample size because of the sqrt(n) in the denominator.

```python
for n in [10, 30, 100, 500]:
    se = 10 / np.sqrt(n)   # assuming std dev = 10
    ci = stats.t.interval(0.95, df=n-1, loc=50, scale=se)
    print(f"n={n:4d}: width={ci[1]-ci[0]:.2f}")
```

## ML Connection

Never report model accuracy as a single point estimate. Compute a confidence interval: for 1000 test samples and 92% accuracy, SE = sqrt(0.92 times 0.08 / 1000) = 0.0086. 95% CI = (0.903, 0.937). If two models' CIs overlap substantially, the performance difference may not be real. Bootstrap confidence intervals work for any metric without distributional assumptions.

```python
def bootstrap_ci(scores, n_boot=10000):
    boots = [np.mean(np.random.choice(scores, len(scores), replace=True)) for _ in range(n_boot)]
    return np.percentile(boots, [2.5, 97.5])
```

## Interview Questions

What is the correct interpretation of a 95% confidence interval? When do you use the t-distribution instead of the normal distribution? What is the standard error and how does it affect CI width? How does sample size affect confidence interval width? How would you report model performance with uncertainty?
