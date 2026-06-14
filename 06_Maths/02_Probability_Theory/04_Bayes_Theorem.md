# Bayes' Theorem

Bayes' theorem is the mathematical rule for updating beliefs when new evidence arrives. It is the foundation of Bayesian statistics and probabilistic machine learning.

## The Formula

```
P(H | E) = [ P(E | H) * P(H) ] / P(E)
```

Each term has a name:
- P(H) — Prior: your belief about hypothesis H before seeing evidence
- P(E | H) — Likelihood: probability of observing evidence E if H is true
- P(H | E) — Posterior: updated belief after seeing evidence
- P(E) — Marginal likelihood (evidence): normalising constant

## Intuition

Suppose you test positive for a rare disease. The test is 99% accurate. The disease affects 0.1% of the population. What is the actual probability you have the disease?

Most people say ~99%. Bayes says otherwise:

```python
p_disease = 0.001        # prior — disease is rare
p_pos_given_disease = 0.99  # likelihood — test is accurate
p_pos_given_no_disease = 0.01  # false positive rate

# P(positive) by law of total probability
p_positive = p_pos_given_disease * p_disease + p_pos_given_no_disease * (1 - p_disease)

# Posterior
p_disease_given_pos = (p_pos_given_disease * p_disease) / p_positive
print(f"{p_disease_given_pos:.3f}")   # ~0.090 — only 9%
```

The prior dominates when it is very strong and the evidence is not overwhelming. This is why rare disease diagnosis requires multiple confirming tests.

## Naive Bayes Classifier

The Naive Bayes classifier is a direct ML application of Bayes' theorem. For a classification problem:

```
P(class | features) ∝ P(features | class) * P(class)
```

The "naive" assumption is that all features are conditionally independent given the class:
```
P(f1, f2, ..., fn | class) = P(f1|class) * P(f2|class) * ... * P(fn|class)
```

This simplification makes the computation tractable and works surprisingly well for text classification (spam detection, sentiment analysis).

## Bayesian vs Frequentist

Frequentist statistics treats parameters as fixed unknown constants. It does not assign probabilities to hypotheses. Bayesian statistics treats parameters as random variables with probability distributions. The prior encodes prior knowledge; the posterior is updated as data arrives. Most modern deep learning is technically frequentist (maximum likelihood), but Bayesian thinking underlies how you interpret uncertainty in model outputs.

Proceed to `03_Probability_Distributions/01_Normal_Distribution.md`.
