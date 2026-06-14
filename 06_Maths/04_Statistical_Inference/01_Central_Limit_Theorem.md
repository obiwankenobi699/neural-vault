# Central Limit Theorem
Source: Session 43, DSMP 2023
Watch: https://www.youtube.com/watch?v=-WmJDYBor7c

## Why CLT is the Most Important Theorem in Statistics

The CLT explains why the normal distribution appears everywhere, why sampling works, and why statistical inference is possible at all. Without it, confidence intervals and hypothesis tests have no foundation.

## Sampling Distribution

Take a population. Draw a random sample of size n and compute the mean. Draw another sample, compute another mean. Repeat 1000 times. The distribution of those 1000 sample means is called the sampling distribution of the mean.

Nitish demonstrates this with a coin-flip experiment: he runs 10 flips, counts heads, repeats 1000 times, and plots the histogram. Even though individual flips are Bernoulli (non-normal), the distribution of counts looks like a bell curve. He then changes p to 0.7 and shows the bell shifts right. With p=0.2 it shifts left.

```python
import numpy as np, matplotlib.pyplot as plt
population = np.random.exponential(scale=2, size=100000)  # non-normal
sample_means = [np.mean(np.random.choice(population, 30)) for _ in range(1000)]
plt.hist(sample_means, bins=40)
# Result looks normal even though population is exponential
```

## Statement of CLT

For independent, identically distributed random variables with mean mu and finite variance sigma squared, as n approaches infinity the distribution of the sample mean approaches N(mu, sigma squared / n).

In plain terms: take any population (any shape — skewed, uniform, bimodal, anything). Draw large enough random samples. Compute the mean of each sample. The distribution of those sample means will be approximately normal, regardless of the original population shape.

The sampling distribution of the mean has mean = mu (same as population) and standard deviation = sigma divided by sqrt(n). This standard deviation of the sample mean is called the Standard Error.

Standard Error = sigma / sqrt(n)

As n increases, standard error decreases. Larger samples give more precise estimates of the population mean. To halve the standard error you need four times the sample size.

```python
pop_std = np.std(population)
for n in [5, 30, 100, 500]:
    means = [np.mean(np.random.choice(population, n)) for _ in range(2000)]
    print(f"n={n}: Empirical SE={np.std(means):.3f}, Theory SE={pop_std/np.sqrt(n):.3f}")
```

## Required Sample Size

For most distributions n >= 30 is sufficient. For heavily skewed distributions n >= 50 is safer. For populations that are already normal, CLT holds for any n.

## Applications

Confidence intervals are built directly on CLT: because the sample mean is approximately normal, you can compute CI = x-bar plus or minus z-star times sigma/sqrt(n). Every t-test and z-test assumes the test statistic is normally distributed — CLT justifies this. Evaluating a model on a test set computes a sample statistic (accuracy, F1). CLT guarantees this estimate is approximately normally distributed, allowing you to attach meaningful uncertainty to it.

```python
from scipy import stats
import numpy as np
data = np.random.normal(50, 10, 100)
mean = np.mean(data)
se = stats.sem(data)
ci = stats.t.interval(0.95, df=len(data)-1, loc=mean, scale=se)
print(f"95% CI: {ci}")
```

## ML Connection

Mini-batch gradient descent takes a random sample of training data each step. The gradient computed on the batch is a sample estimate of the true gradient. CLT guarantees that as batch size grows this estimate converges to the true gradient. Reporting model accuracy with a confidence interval rather than a point estimate is applied CLT.

## Interview Questions

State the Central Limit Theorem. What is the standard error and how does it differ from standard deviation? What sample size is typically needed for CLT to apply? How does CLT justify using t-tests and z-tests?
