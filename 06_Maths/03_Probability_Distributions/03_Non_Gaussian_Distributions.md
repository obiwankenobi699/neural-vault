# Non-Gaussian Probability Distributions
Source: Session 42, DSMP 2023
Watch: https://www.youtube.com/watch?v=U6QCc_3zgUk

## Why Study Non-Gaussian Distributions

Real-world data is rarely normal. Counts, binary outcomes, waiting times, income, and many other phenomena follow completely different shapes. Applying normal-distribution tools to non-normal data produces wrong results. Identifying the correct distribution family lets you use the right tools.

## Bernoulli Distribution

The simplest discrete distribution. One trial, two outcomes: success with probability p, failure with probability 1-p. PMF: P(X=1) = p, P(X=0) = 1-p. Mean = p. Variance = p(1-p).

Nitish's example: a student sees a course on CampusX. Either they enrol or they do not. Each individual student's decision is a Bernoulli trial.

```python
from scipy.stats import bernoulli
rv = bernoulli(p=0.3)
print(rv.pmf(1))   # 0.3
print(rv.pmf(0))   # 0.7
```

Every binary classification problem produces Bernoulli-distributed predictions. Binary cross-entropy loss is the negative log-likelihood of a Bernoulli PMF.

## Binomial Distribution

N independent Bernoulli trials. Models the count of successes. Parameters: n (trials), p (success probability per trial). Mean = np. Variance = np(1-p).

Nitish's example: showing a YouTube video to 3 viewers each with 0.5 probability of liking it. What is the probability exactly 2 out of 3 like it? P(X=2) = C(3,2) times 0.5 squared times 0.5 = 3 times 0.25 times 0.5 = 0.375.

The key condition: trials must be independent and the probability p must be fixed across all trials.

```python
from scipy.stats import binom
print(binom.pmf(k=2, n=3, p=0.5))    # 0.375
print(binom.cdf(k=5, n=10, p=0.5))   # P(at most 5 heads in 10 flips)
```

When n is large and p is not too extreme, the binomial distribution approaches the normal distribution — a direct consequence of the Central Limit Theorem.

## Poisson Distribution

Models the number of events occurring in a fixed time interval when events happen at a constant average rate and are independent of each other. Single parameter: lambda (the average rate). Mean = Variance = lambda. This equality is a diagnostic — if your count data has approximately equal mean and variance, Poisson is a candidate.

PMF: P(X=k) = (lambda to the k times e to the negative lambda) / k factorial.

Real examples: number of customers arriving per hour, number of server requests per second, number of goals in a football match, number of defects per square metre of fabric.

```python
from scipy.stats import poisson
lam = 3
print(poisson.pmf(k=2, mu=lam))   # P(exactly 2 events)
print(poisson.cdf(k=4, mu=lam))   # P(at most 4 events)
```

## Log-Normal Distribution

If X is normally distributed, then Y = e to the X is log-normally distributed. Equivalently: if you take the log of a log-normal variable you get a normal variable.

Shape: right-skewed, only positive values, long right tail. Real examples: income and wealth distribution, stock prices, house prices, file sizes. Nitish mentions this is why log-transforming a right-skewed feature before training a linear model is standard practice — after the transform the feature is approximately normal and linear model assumptions are better satisfied.

```python
import numpy as np
data = np.random.lognormal(mean=0, sigma=1, size=1000)
log_data = np.log(data)   # log_data is now approximately Normal(0,1)
```

Nitish notes this as an interview question: how would you check if a random variable is log-normally distributed? Take the log of it and check if the result is normal using a QQ plot or Shapiro-Wilk test.

## Uniform Distribution

Every value in the range [a, b] has equal probability. Continuous uniform PDF: f(x) = 1/(b-a). Mean = (a+b)/2.

```python
from scipy.stats import uniform
rv = uniform(loc=0, scale=10)   # Uniform on [0, 10]
print(rv.pdf(5))    # 0.1 = 1/10
```

Used in random weight initialisation, random train/test splits, hyperparameter random search.

## Exponential Distribution

Models time between consecutive events in a Poisson process. If events arrive at rate lambda, waiting time follows Exp(lambda). Mean = 1/lambda. The memoryless property: the probability of waiting at least s+t more time, given you have already waited s, equals the probability of waiting t from the start. The distribution has no memory of past waiting time.

```python
from scipy.stats import expon
rv = expon(scale=1/2)   # lambda=2, mean wait = 0.5 time units
print(rv.mean())
```

## Choosing the Right Distribution

Binary single trial: Bernoulli. Count of successes in N trials: Binomial. Count of events in fixed interval: Poisson. Positive continuous right-skewed: Log-Normal. Time between events: Exponential. Symmetric continuous: Normal. Bounded continuous equal probability: Uniform.

## ML Connection

Bernoulli and Binomial: binary classification loss functions. Poisson: regression for count data, predicting accident rates or page views. Log-Normal: motivation for log-transforming skewed features. Exponential: survival analysis, reinforcement learning reward decay. Uniform: weight initialisation, random sampling, hyperparameter search.

## Interview Questions

What is the difference between Bernoulli and Binomial distributions? What distinguishes the Poisson distribution from others for count data? What is the memoryless property of the exponential distribution? How would you check if data is log-normally distributed? When is it appropriate to log-transform a feature?
