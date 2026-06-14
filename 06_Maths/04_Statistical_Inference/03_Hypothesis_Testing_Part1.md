# Hypothesis Testing Part 1
Source: Session 45, DSMP 2023
Watch: https://www.youtube.com/watch?v=S94mx6OL7kM

## The Core Logic

Hypothesis testing is the formal procedure for making evidence-based decisions about population parameters using sample data. The logic: start with a default assumption (null hypothesis). Ask whether the sample data provides enough evidence to reject it. The burden of proof is entirely on the alternative hypothesis — you never prove the null, you only reject it or fail to reject it.

## Null and Alternative Hypotheses

H0 (null hypothesis): the conservative default claim. No effect, no difference, no improvement. H1 (alternative hypothesis): the claim you are trying to establish through evidence.

They must be mutually exclusive and together cover all possibilities. You state both before collecting data, never after.

Nitish's factory example from this session: a car manufacturing company produces 50 cars per day on average (mu = 50, sigma = 5). They introduce a training programme for employees. After training, a sample of 30 employees shows a sample mean of 53 cars per day.

H0: the training made no difference. Population mean is still 50. (mu = 50)
H1: the training improved productivity. Population mean is now greater than 50. (mu > 50)

## Type I and Type II Errors

Four possible outcomes exist in any hypothesis test.

If H0 is true and you fail to reject it: correct decision. If H0 is true but you reject it: Type I error (false positive). You concluded there was an effect when there was none. The significance level alpha is the maximum acceptable probability of a Type I error.

If H1 is true and you reject H0: correct decision (the power of the test). If H1 is true but you fail to reject H0: Type II error (false negative). You missed a real effect. Beta is the probability of a Type II error. Power = 1 - beta.

Reducing alpha makes Type I errors rarer but increases Type II errors. The only way to reduce both simultaneously is to increase sample size.

## Significance Level

Alpha (typically 0.05) is chosen before the test. Setting alpha after seeing the data — p-hacking — invalidates the entire test. Alpha = 0.05 means you accept a 5% chance of falsely concluding an effect exists.

## Test Statistic

A test statistic summarises how far the sample is from what H0 predicts. Large absolute values are evidence against H0.

For testing whether a sample mean equals a hypothesised value when sigma is known (z-test):

Z = (x-bar - mu0) / (sigma / sqrt(n))

Nitish's factory example:
Z = (53 - 50) / (5 / sqrt(30)) = 3 / 0.913 = 3.29

## Critical Value and Rejection Region

For a one-tailed test at alpha = 0.05: the critical value is 1.645. If Z > 1.645 you reject H0. If Z <= 1.645 you fail to reject H0.

Z = 3.29 > 1.645 therefore reject H0. The training programme significantly improved productivity.

## Five Steps of Hypothesis Testing (Nitish's Framework)

Step 1: State H0 and H1. Step 2: Choose the significance level alpha. Step 3: Check assumptions and select the appropriate test (z-test, t-test, etc.). Step 4: Calculate the test statistic. Step 5: Make the decision — compare test statistic to critical value or compute p-value.

```python
from scipy import stats
import numpy as np

mu0 = 50          # null hypothesis value
sigma = 5         # known population std dev
n = 30            # sample size
x_bar = 53        # sample mean

z_stat = (x_bar - mu0) / (sigma / np.sqrt(n))
print(f"Z statistic: {z_stat:.3f}")   # 3.286

# One-tailed p-value (H1: mu > 50)
p_value = 1 - stats.norm.cdf(z_stat)
print(f"p-value: {p_value:.4f}")      # 0.0005
```

## ML Connection

Model evaluation is hypothesis testing. Is my new model significantly better than the baseline? H0: both models have the same performance. H1: the new model is better. Every A/B test follows this exact framework. Feature importance tests in linear models output p-values from hypothesis tests on each coefficient.

## Interview Questions

What is the null hypothesis and why do we start with it? Define Type I and Type II errors. What is the significance level and why is it chosen before the test? What is a test statistic? Describe the five steps of hypothesis testing.
