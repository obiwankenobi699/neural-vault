# Joint, Marginal, Conditional Probability and Bayes Theorem
Source: Session 14 of playlist
Watch: https://www.youtube.com/watch?v=ndHDsvqmbuI

## Joint Probability

Joint probability is the probability of two events occurring simultaneously: P(A and B). Nitish builds this from a contingency table in the session — he takes a dataset, creates all combinations of two variables, counts occurrences, and divides by total to get the joint probability distribution.

The joint probability distribution contains the probability for every possible combination of outcomes of two random variables. All entries in the table must sum to 1.

```python
import numpy as np
# Joint probability table — rows: X, columns: Y
joint = np.array([[0.30, 0.10],
                  [0.20, 0.40]])
print(joint.sum())   # must equal 1.0
```

## Marginal Probability

Marginal probability is the probability of a single event regardless of any other event. You get it by summing the joint probabilities across all values of the other variable — you are marginalising out the variable you do not care about.

P(X = x) = sum over all y of P(X = x, Y = y).

```python
p_x = joint.sum(axis=1)   # sum across columns — marginal of X
p_y = joint.sum(axis=0)   # sum across rows — marginal of Y
print(p_x)   # [0.4, 0.6]
print(p_y)   # [0.5, 0.5]
```

Nitish connects this directly to the chi-square test they covered elsewhere: when testing independence between two categorical features, you compute joint and marginal probabilities from a contingency table, exactly as shown here.

## Conditional Probability from the Table

Given joint and marginal: P(X = x given Y = y) = P(X = x, Y = y) / P(Y = y).

```python
# P(X=1 given Y=1)
p_x1_given_y1 = joint[1, 1] / p_y[1]   # 0.4 / 0.5 = 0.8
```

## Bayes Theorem

Bayes theorem is the rule for updating beliefs when new evidence arrives.

P(H given E) = P(E given H) times P(H) / P(E)

Each term: P(H) is the prior — your belief about hypothesis H before seeing any evidence. P(E given H) is the likelihood — probability of observing this evidence if H is true. P(H given E) is the posterior — your updated belief after seeing the evidence. P(E) is the marginal likelihood, a normalising constant that ensures the posterior sums to 1.

Nitish's medical test example in this session: a disease affects 0.1 percent of the population. A test for it is 99 percent accurate (correctly identifies 99 percent of those who have it). You test positive. What is the actual probability you have the disease?

Most people say approximately 99 percent. Bayes says otherwise.

```python
p_disease = 0.001           # prior: disease is rare
p_pos_given_disease = 0.99  # likelihood: test is good
p_pos_given_no_disease = 0.01  # false positive rate

# P(positive) by law of total probability
p_positive = (p_pos_given_disease * p_disease +
              p_pos_given_no_disease * (1 - p_disease))

# Posterior
p_disease_given_pos = (p_pos_given_disease * p_disease) / p_positive
print(f"{p_disease_given_pos:.3f}")   # approximately 0.09 — only 9 percent
```

The prior dominates. The disease is so rare that even a highly accurate positive test leaves only a 9 percent posterior probability. This is why doctors require confirming tests for rare diseases.

## Naive Bayes Classifier

The Naive Bayes classifier is a direct ML application of Bayes theorem. For classification:

P(class given features) is proportional to P(features given class) times P(class)

The naive assumption: all features are conditionally independent given the class. This means P(f1, f2, ..., fn given class) = product of P(fi given class). Despite the strong independence assumption being almost always violated in real data, Naive Bayes works well for text classification — spam detection, sentiment analysis, document categorisation.

```python
from sklearn.naive_bayes import GaussianNB
model = GaussianNB()
model.fit(X_train, y_train)
```

## ML Connection

Joint distributions are the foundation of generative models — models that learn the joint distribution P(X, Y) rather than just the conditional P(Y given X). Variational autoencoders and diffusion models involve marginalising over latent variables. Bayesian optimisation for hyperparameter tuning uses Bayes theorem to update beliefs about which hyperparameters are promising given observed results.

## Interview Questions

What is the difference between joint and marginal probability? State Bayes theorem and explain each term. What is the naive assumption in Naive Bayes? Give an example where Naive Bayes would work well despite the independence assumption being violated. Why does the prior matter so much in Bayes theorem for rare events?
