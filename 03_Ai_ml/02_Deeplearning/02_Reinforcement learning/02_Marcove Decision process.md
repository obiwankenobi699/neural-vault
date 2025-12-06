---
title: 02_Marcove Decision process
tags:
  - ML
  - DL
created: 2025-11-09
updated:
  "{ date }":
---

> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
A **Markov Decision Process (MDP)** is a **mathematical framework** used to describe **decision-making problems** where outcomes are **partly random** and **partly under the control of an agent**.
It forms the **foundation of Reinforcement Learning (RL)**.

---

### 1. **Definition**

An MDP is defined by a 5-tuple:
$$
[
(S, A, P, R, \gamma)
]
$$
where:

* **S (States):** All possible situations the agent can be in.
  Example: In a grid world, each cell position is a state.

* **A (Actions):** All possible moves the agent can take.
  Example: Up, down, left, right.

* **P (Transition Probability):**
  ( P(s'|s, a) ) = probability of moving to next state ( s' ) given current state ( s ) and action ( a ).
  This defines the *dynamics* of the environment.

* **R (Reward Function):**
  ( R(s, a) ) = immediate reward received after taking action ( a ) in state ( s ).
  This drives the learning goal.

* **γ (Discount Factor):**
  ( 0 \le \gamma \le 1 ) — determines how much the agent values future rewards.
  If γ = 0, only immediate rewards matter; if γ = 1, long-term rewards matter more.

---

### 2. **Process Flow**

The agent interacts with the environment in a loop:

1. The agent observes the **current state** $( s_t )$.
2. It chooses an **action** $( a_t )$.
3. The environment responds with:

   * A **reward** $( r_t = R(s_t, a_t) )$,
   * The **next state** $( s_{t+1} )$ with probability $( P(s_{t+1}|s_t, a_t) )$.
1. The agent updates its **policy** (its strategy) to maximize long-term expected reward.

---

### 3. **Policy (π)**

A **policy** is the agent’s behavior:
$$
[
\pi(a|s) = P(a_t = a | s_t = s)
]
$$
It defines how the agent chooses actions in each state.

The goal is to find the **optimal policy** ( \pi^* ) that maximizes the expected total discounted reward:
$$
[
\pi^* = \arg\max_\pi \mathbb{E}\left[\sum_{t=0}^\infty \gamma^t R(s_t, a_t)\right]
]

$$
---

### 4. **Value Functions**

Value functions estimate how good a state or action is under a given policy.

* **State-value function:**
  $( V^\pi(s) = \mathbb{E}*\pi[\sum*{t=0}^\infty \gamma^t R(s_t, a_t) | s_0 = s] )$

* **Action-value function (Q-function):**
  $( Q^\pi(s, a) = \mathbb{E}*\pi[\sum*{t=0}^\infty \gamma^t R(s_t, a_t) | s_0 = s, a_0 = a] )$

---

### 5. **Learning in RL**

Reinforcement learning algorithms **learn the MDP model** or directly learn the **optimal value functions/policy** via interaction:

* **Exploration:** Try new actions to discover better rewards.
* **Exploitation:** Choose actions that already seem best.
* **Experience:** Agent collects state–action–reward–next-state tuples to learn from.

Methods include:

* **Value Iteration / Policy Iteration** (Dynamic Programming)
* **Q-Learning**, **SARSA**
* **Deep Q-Networks (DQN)**
* **Policy Gradient methods**










