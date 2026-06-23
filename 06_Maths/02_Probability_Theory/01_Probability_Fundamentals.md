# Probability — Part 1: Fundamentals
Source: Session 13 of playlist (Master Probability Crash Course Part 1)
Watch: https://www.youtube.com/watch?v=DUT4WEUngt0

## What is Probability

Probability is a measure of the likelihood that a particular event will occur. It is a number between 0 and 1. Zero means impossible. One means certain. Everything in between represents degrees of likelihood.

The formal definition: probability of an event A = (number of favourable outcomes) / (total number of possible outcomes), provided all outcomes are equally likely.

## Sample Space and Events

The sample space S is the set of all possible outcomes of an experiment. Rolling a die: S = {1, 2, 3, 4, 5, 6}. Flipping a coin: S = {Head, Tail}.

An event is any subset of the sample space. Rolling an even number: E = {2, 4, 6}. P(E) = 3/6 = 0.5.

## Types of Events

Nitish covers these explicitly because they reappear throughout the probability sessions.

A simple event has exactly one outcome: rolling a 4. A compound event has two or more outcomes: rolling an even number.

Independent events: the outcome of one does not affect the other. Rolling a die twice — the result of the first roll has no bearing on the second.

Dependent events: the outcome of one affects the other. Drawing a card from a deck, not replacing it, then drawing again. The probability of the second draw depends on what was drawn first because the deck now has 51 cards.

Mutually exclusive events: two events that cannot both occur in the same trial. Rolling an odd number and rolling an even number on the same roll. They share no outcomes.

Exhaustive events: a set of events where at least one must occur. Rolling a die — the events {1}, {2}, {3}, {4}, {5}, {6} together are exhaustive because one of them must happen.

An impossible event has probability zero. A certain event has probability one.

## Basic Probability Rules

Addition rule for mutually exclusive events: P(A or B) = P(A) + P(B). If events share no outcomes you simply add.

General addition rule: P(A or B) = P(A) + P(B) - P(A and B). The intersection is subtracted to avoid counting it twice.

Complement rule: P(not A) = 1 - P(A). If P(rain tomorrow) = 0.3 then P(no rain) = 0.7. Often computing the complement is easier than computing the event directly.

## Conditional Probability

P(A given B) = P(A and B) / P(B). This is the probability of A occurring given that B has already occurred. The sample space is restricted to outcomes where B happened.

Nitish's card example: you draw a card from a 52-card deck. Probability of a spade is 13/52 = 0.25. Now suppose you are told the card is black. Given this information, P(spade given black) = 13/26 = 0.5. The condition changed the sample space from 52 to 26.

```python
# Verifying conditional probability numerically
p_spade = 13/52
p_black = 26/52
p_spade_and_black = 13/52   # spades are all black
p_spade_given_black = p_spade_and_black / p_black   # = 0.5
```

## Independence

Two events are independent if P(A and B) = P(A) times P(B). Equivalently, P(A given B) = P(A) — knowing B happened tells you nothing about A. Flipping a fair coin twice: P(H on flip 2 given H on flip 1) = 0.5 = P(H on flip 2). They are independent.

## ML Connection

The Naive Bayes classifier assumes all features are conditionally independent given the class label. This is the naive assumption. Logistic regression computes P(y=1 given X) — a conditional probability. Every probabilistic ML model is built on these foundational rules. Understanding independence vs dependence is essential for interpreting model assumptions.

## Interview Questions

What is the difference between independent and mutually exclusive events? Can two events be both mutually exclusive and independent? Define conditional probability and give a real-world example. What is Bayes' theorem and where is it used in ML?


### Scenario A: Remove 51 cards, never look at any of them

There is 1 card left on the table.

You ask:

> "What is the probability that the last remaining card is the Ace of Spades?"

The answer is still:

$$
152\frac{1}{52}521​
$$

Why?

Because from your perspective, the Ace could have been any of the 52 original positions. You have not learned anything. The last card is just one particular position out of 52.

---

### Scenario B: Reveal 51 cards and none is the Ace

Now you've learned a lot.

You know:

- The Ace is not card 1
- Not card 2
- ...
- Not card 51

Only one possibility remains:

$$
P(last card is Ace)=1P(\text{last card is Ace}) = 1P(last card is Ace)=1
$$

or

$$
11\frac{1}{1}11​
$$

---

This is a classic example of how **probability depends on information**.

The physical situation can be identical (one card left), but your probability differs:

| Information available          | Probability last card is Ace |
| ------------------------------ | ---------------------------- |
| 51 cards removed, unseen       | 1/521/521/52                 |
| 51 cards revealed, none is Ace | 111                          |