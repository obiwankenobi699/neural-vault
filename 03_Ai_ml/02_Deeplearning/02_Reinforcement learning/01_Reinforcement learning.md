---
title: 01_Reinforcement learning
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

## 1. What Reinforcement Learning Is

Reinforcement Learning is a type of **machine learning** where an **agent** learns to make decisions by interacting with an **environment** to achieve a **goal**.

Instead of being told what to do, the agent **learns by trial and error** — receiving **rewards** or **penalties** for its actions.

---

## 2. The RL Framework

Reinforcement Learning follows this loop, called the **agent–environment interaction cycle**:

1. **State (S):**
   The agent observes the current situation from the environment.
   Example: The position of a robot, or the current game board.

2. **Action (A):**
   The agent chooses an action based on its policy (strategy).
   Example: Move left, accelerate, or jump.

3. **Reward (R):**
   After performing the action, the environment gives a numerical feedback (reward or penalty).
   Example: +1 for success, –1 for collision.

4. **Next State (S’):**
   The environment transitions to a new state depending on the action.

5. **Repeat:**
   This process continues until the goal is achieved or the episode ends.

This forms a **Markov Decision Process (MDP)**.

---

## 3. The Learning Objective

The goal of RL is to learn a **policy** π(a|s):

> “Given a state *s*, what action *a* should I take to maximize future reward?”

The agent’s objective is to **maximize cumulative reward** over time:
$$
[
G_t = R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + ...
]
$$
where ( \gamma ) is the discount factor (how much future rewards are valued).

---

## 4. Key Learning Mechanisms

### **a. Exploration**

* Trying **new or random actions** to discover unknown states and rewards.
* Example: The agent moves randomly in a maze to find the exit.
* It helps to **collect diverse experiences**.

### **b. Exploitation**

* Choosing the **best-known action** based on past experience.
* Example: Once it knows turning right gives a reward, it keeps turning right.

**Balance** between these two is crucial:

* Too much exploration → wasted time learning what you already know.
* Too much exploitation → agent may miss better strategies.

**ε-greedy policy** is the most common method:
$$
[
\text{With probability } \varepsilon: \text{explore randomly.}
]
$$
$$
[
\text{With probability } 1-\varepsilon: \text{exploit best-known action.}
]

$$
---

### **c. Interaction**

The agent **interacts with the environment** in each step:

* Observes → Acts → Receives Reward → Updates Policy.
  This ongoing interaction creates a **feedback loop** that drives learning.

---

### **d. Experience**

The agent stores its experiences as tuples:
$$
[
(S_t, A_t, R_{t+1}, S_{t+1})
]
$$
This is called a **transition**.

Modern RL algorithms (like Deep Q-Learning) use an **Experience Replay Buffer**:

* Stores past transitions.
* Randomly samples them to train neural networks.
* This **breaks correlation** between consecutive samples and improves learning stability.

---

## 5. Core Steps of RL in Summary

| Step | Process                             | Description                |
| ---- | ----------------------------------- | -------------------------- |
| 1    | **Initialize Policy or Q-values**   | Start with random behavior |
| 2    | **Observe State (S)**               | Get the current situation  |
| 3    | **Choose Action (A)**               | Using ε-greedy or policy   |
| 4    | **Perform Action & Get Reward (R)** | Environment gives feedback |
| 5    | **Update Knowledge**                | Adjust Q-values or policy  |
| 6    | **Move to Next State (S’)**         | Continue to next step      |
| 7    | **Repeat**                          | Until goal or convergence  |

---

## 6. How It “Learns” Over Time

Every interaction updates the agent’s understanding of which actions are best:

**Example (Q-learning update rule):**
$$
[
Q(S_t, A_t) \leftarrow Q(S_t, A_t) + \alpha [R_{t+1} + \gamma \max_{a'} Q(S_{t+1}, a') - Q(S_t, A_t)]
]
$$

Where:

* ( Q(S, A) ) = value of taking action A in state S.
* ( \alpha ) = learning rate.
* ( \gamma ) = discount factor.

Gradually, Q-values converge so the agent learns the **optimal policy**.

---

## 7. Real-Life Example: Self-Driving Car

1. **State:** Position, speed, nearby objects.
2. **Action:** Turn, brake, accelerate.
3. **Reward:** +10 for staying on road, –100 for crash.
4. **Exploration:** Tries new maneuvers.
5. **Exploitation:** Uses best-known driving pattern.
6. **Experience:** Stores all data, refines model.

Over time, it learns to drive safely and efficiently.

---

Would you like me to add **a visual diagram (agent ↔ environment loop)** for this process? It’ll help you visualize exploration, exploitation, and experience better.

