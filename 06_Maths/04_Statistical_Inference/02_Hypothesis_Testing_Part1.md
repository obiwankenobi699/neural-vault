# Hypothesis Testing Part 1 — Logic and Framework

Hypothesis testing is the formal procedure for making decisions about population parameters using sample data. Every time you ask "is this model better than that model" or "does this feature matter", you are performing hypothesis testing, whether you formalise it or not.

## The Core Logic

You start with a default assumption — the null hypothesis H₀ — and ask whether the data provides enough evidence to reject it in favour of an alternative hypothesis H₁. The burden of proof is on the alternative.

This asymmetry is deliberate. You never "accept" the null hypothesis — you either reject it or fail to reject it. Absence of evidence is not evidence of absence.

## Defining Hypotheses

H₀ is always the conservative claim: no effect, no difference, no relationship. H₁ is the claim you are trying to establish. They must be mutually exclusive and cover all possibilities.

Example: you want to know if a new drug lowers blood pressure.
- H₀: mean blood pressure is unchanged (μ = μ₀)
- H₁: mean blood pressure is lower (μ < μ₀)

## Type I and Type II Errors

There are two ways to be wrong in hypothesis testing.

Type I error (false positive, α): you reject H₀ when it is actually true. You conclude there is an effect when there is none. The significance level α is the maximum acceptable probability of a Type I error.

Type II error (false negative, β): you fail to reject H₀ when H₁ is actually true. You miss a real effect. The power of a test is 1 - β — the probability of correctly detecting a real effect.

```
              H₀ True         H₁ True
Reject H₀   Type I error      Correct (Power)
Fail to reject   Correct       Type II error
```

Reducing α makes Type I errors rarer but increases Type II errors — these trade off against each other. The only way to reduce both is to increase sample size.

## Significance Level

The significance level α (typically 0.05) is the threshold at which you reject H₀. It is chosen before the test, not after seeing the data. Setting α after seeing results — "p-hacking" — invalidates the test.

α = 0.05 means you are willing to accept a 5% chance of a false positive.

## Test Statistic

A test statistic is a number computed from the sample that summarises how far the sample is from what H₀ predicts. Large test statistics (in absolute value) are evidence against H₀.

For testing whether a sample mean equals a hypothesised value:
```
t = (x̄ - μ₀) / (s / √n)
```

Under H₀, this follows a t-distribution with n-1 degrees of freedom.

Proceed to `03_Hypothesis_Testing_Part2.md`.
