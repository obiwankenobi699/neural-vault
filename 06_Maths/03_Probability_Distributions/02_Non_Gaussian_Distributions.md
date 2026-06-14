# Non-Gaussian Probability Distributions

Real-world data is rarely Gaussian. Counts, binary outcomes, waiting times, and fat-tailed phenomena all require different distributional models. This file covers the distributions you will encounter most frequently in ML and data science.

## Bernoulli Distribution

The Bernoulli distribution models a single binary outcome: success (1) with probability p, failure (0) with probability 1-p.

```
PMF(x) = p^x * (1-p)^(1-x)   for x ∈ {0, 1}
```

Every binary classification problem produces Bernoulli-distributed outputs. The cross-entropy loss function is the negative log-likelihood of a Bernoulli distribution.

## Binomial Distribution

The Binomial distribution models the number of successes in n independent Bernoulli trials.

```python
from scipy.stats import binom
# P(exactly 3 heads in 10 fair coin flips)
print(binom.pmf(k=3, n=10, p=0.5))   # ~0.117
# P(at most 3 heads)
print(binom.cdf(k=3, n=10, p=0.5))   # ~0.172
```

## Poisson Distribution

The Poisson distribution models the number of events occurring in a fixed interval when events happen at a constant average rate λ and are independent of each other.

```
PMF(k) = (λ^k * e^(-λ)) / k!
Mean = Variance = λ
```

Use cases: number of customer arrivals per hour, number of defects per unit, number of clicks per minute. If your count data has mean approximately equal to variance, Poisson is a reasonable model.

```python
from scipy.stats import poisson
lam = 5   # average 5 events per interval
print(poisson.pmf(k=3, mu=lam))   # P(exactly 3 events)
```

## Exponential Distribution

The Exponential distribution models the time between events in a Poisson process. If events arrive at rate λ, waiting time follows Exp(λ).

```
PDF(x) = λ * e^(-λx)   for x ≥ 0
Mean = 1/λ,  Variance = 1/λ²
```

The exponential distribution has the memoryless property: P(X > s+t | X > s) = P(X > t). Past waiting time gives no information about future waiting time.

## Log-Normal Distribution

If ln(X) is normally distributed, then X is log-normally distributed. Income, stock prices, and many biological measurements are log-normal. Taking the log of a log-normal variable gives you a normal distribution — which is why log-transforming skewed features is such a common preprocessing step.

## Uniform Distribution

Every value in the interval [a, b] is equally likely. Used in random initialisation and random sampling.

```python
from scipy.stats import uniform
samples = uniform.rvs(loc=0, scale=1, size=1000)  # Uniform(0,1)
```

## Choosing the Right Distribution

| Data Type | Candidate Distribution |
|-----------|----------------------|
| Binary outcome (yes/no) | Bernoulli |
| Count of successes in n trials | Binomial |
| Count of rare events in interval | Poisson |
| Time between events | Exponential |
| Positive, right-skewed continuous | Log-Normal |
| Symmetric, continuous | Normal |
| Bounded continuous | Uniform |

Proceed to `03_Sampling_and_CLT.md`.
