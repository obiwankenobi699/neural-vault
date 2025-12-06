---
title: 03_Q learning
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

### 1. Introduction to Q-Learning

Q-learning is a **fundamental algorithm in reinforcement learning** that allows an agent to learn how to act optimally in an environment through **trial and error**. It is a **model-free** approach, meaning it does not require prior knowledge of the environment’s transition probabilities or reward structure. Instead, it learns purely from interaction — by performing actions, observing results, and adjusting its strategy based on feedback. Q-learning is built on the framework of the **Markov Decision Process (MDP)**, which mathematically defines decision-making problems where outcomes are partly random and partly under the control of a decision-maker.

---

### 2. Relationship with Markov Decision Process (MDP)

An **MDP** consists of a set of states, actions, rewards, and transition probabilities. It assumes that the next state depends **only on the current state and action**, not on the history — this is called the **Markov property**. Q-learning operates within this framework but removes the need to know the transition probabilities ( P(s'|s,a) ). Instead of modeling the full MDP dynamics, Q-learning directly learns the **value of taking each action in each state**, known as the **Q-value**, by repeated interaction with the environment. Therefore, Q-learning can be seen as a **practical implementation of MDP concepts** when the environment’s model is unknown.

---

### 3. What is the Q-Function and Q-Value?

The **Q-function** (or **action-value function**) is the heart of Q-learning. It represents the **expected total reward** that an agent can obtain starting from a state ( s ), taking an action ( a ), and then following the optimal policy thereafter. Mathematically, it is expressed as:
$$
[
Q(s, a) = \mathbb{E}[R_t | s_t = s, a_t = a]
]
$$
The **Q-value** for a state-action pair ((s,a)) tells the agent how good it is to take that specific action in that specific state. As the agent explores and interacts with the environment, it updates these Q-values using the **Bellman Equation**, which connects current and future rewards:
$$
[
Q(s, a) \leftarrow Q(s, a) + \alpha [r + \gamma \max_{a'} Q(s', a') - Q(s, a)]
]
$$
Here, ( \alpha ) is the learning rate, ( \gamma ) is the discount factor (representing how much future rewards matter), and ( r ) is the immediate reward. Over time, Q-values converge to their optimal values.

---

### 4. Why It Is Called “Q” and Not “P”

The letter **“Q”** in Q-learning stands for **“Quality”** of an action — it measures the quality of taking a certain action in a particular state. On the other hand, **“P”** is often used to represent **probability** in mathematics and MDPs (for example, ( P(s'|s,a) ), the probability of moving to a new state). Since Q-learning focuses on **value estimation** rather than **probabilistic transitions**, the term “Q” is used to emphasize that it quantifies the quality of action decisions rather than modeling probabilities.

---

### 5. Exploration vs. Exploitation in Q-Learning

A key challenge in Q-learning is balancing **exploration** and **exploitation**.

* **Exploration** means trying out new or random actions to discover potentially better outcomes.
* **Exploitation** means using the best-known action (highest Q-value) to maximize immediate rewards.
  To manage this balance, an **ε-greedy strategy** is used: with probability ( \epsilon ), the agent explores randomly, and with probability ( 1 - \epsilon ), it exploits its current best Q-values. This allows the agent to learn efficiently while still discovering new strategies.

---

### 6. How Q-Learning Works (Learning Process)

Q-learning learns through **interaction**, **experience**, and **feedback**:

1. The agent starts in an initial state.
2. It chooses an action (using ε-greedy policy).
3. The environment returns a **reward** and a **new state**.
4. The agent updates its Q-value for that state-action pair using the Bellman update rule.
5. This process repeats for many episodes until the Q-values converge to optimal values.
$$
   Once training is complete, the agent can follow the **optimal policy** ( \pi^*(s) = \arg\max_a Q(s,a) ) to make decisions that yield the highest expected rewards.
$$

---

### 7. Applications of Q-Learning

Q-learning has wide applications in both academic research and real-world systems. It is used in:

* **Robotics:** for motion control and autonomous navigation.
* **Games:** such as training AI agents in chess, Go, or video games (e.g., Deep Q-Networks in Atari).
* **Traffic Control:** to optimize traffic light patterns and reduce congestion.
* **Finance:** for portfolio optimization and trading decisions.
* **Healthcare:** for adaptive treatment planning and personalized medicine.

---

### 8. Relation Between Reinforcement Learning and Q-Learning

Reinforcement Learning (RL) is the **broader paradigm** that deals with how agents learn optimal behavior through rewards and penalties. Q-learning is one of the **specific algorithms** within RL that implements this concept using the Q-function. In other words, **Q-learning is a practical realization of RL**, particularly suited for problems modeled as **Markov Decision Processes** where the agent learns the optimal policy without needing the full model of the environment.

---

### 9. Example of Q-Learning

Consider a robot navigating a grid world where some cells have rewards and others have penalties. Initially, the robot doesn’t know which moves are good or bad. As it explores, it tries moving in different directions, observes rewards or punishments, and updates its Q-values for each move. Over time, it learns that certain sequences of actions lead to higher cumulative rewards — this becomes its **optimal policy** for navigation.

---

