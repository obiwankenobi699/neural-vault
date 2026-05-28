---
title:
  "{ Title }":
tags:
  - Agentic_ai
  - Rag
created:
  "{ date }":
updated:
  "{ date }":
---
  Retrieval-Augmented Generation (RAG)

## Introduction

Retrieval-Augmented Generation (RAG) is an AI architecture that combines **information retrieval systems** with **Large Language Models (LLMs)** to generate accurate, context-aware, and up-to-date responses. Instead of relying only on the data learned during training, a RAG system retrieves external knowledge from documents, databases, APIs, vector stores, or enterprise data sources before generating a response.

RAG is widely used in modern AI systems because LLMs alone suffer from problems such as hallucination, outdated knowledge, lack of domain-specific understanding, and inability to access private organizational data. By integrating retrieval mechanisms, RAG enables AI 
applications to answer questions using real-time or proprietary information.


## Core Idea of RAG

The fundamental principle behind RAG is:

1. **Retrieve relevant information**
2. **Inject retrieved context into the prompt**
3. **Generate a grounded response**

Instead of asking the model to answer purely from memory, the model first searches for related documents and then generates responses using those documents as context.


## Why RAG is Important

Traditional LLMs have several limitations:

| Problem in LLMs           | How RAG Solves It                |
| ------------------------- | -------------------------------- |
| Hallucination             | Uses retrieved factual documents |
| Outdated training data    | Retrieves latest information     |
| No access to private data | Connects to internal databases   |
| Expensive fine-tuning     | No retraining required           |
| Limited domain expertise  | Uses domain-specific documents   |

RAG is therefore considered one of the most practical architectures for production AI systems.


```

                +------------------+
                |   User Query     |
                +---------+--------+
                          |
                          v
                +------------------+
                | Query Embedding  |
                +---------+--------+
                          |
                          v
                +------------------+
                | Vector Database  |
                | Similarity Search|
                +---------+--------+
                          |
             Retrieved Relevant Chunks
                          |
                          v
                +------------------+
                | Prompt Builder   |
                +---------+--------+
                          |
                          v
                +------------------+
                | Large Language   |
                | Model (LLM)      |
                +---------+--------+
                          |
                          v
                +------------------+
                | Generated Answer |
                +------------------+
                
```


## Retrieval

it is a way to access the relavent data orr finding the document 
we use two searching algoruthm 
BM25
TF-IDF

what inside these algo in short and cut to cut 
how these algo work in rag 

vector search vs sementic search 
keysearch it is like grep search


what smart thing done here is embedding of our search and how embedding is done it it dynamic how vector group with similar meaning 

in ml we have nlp which cover a part of sentence similarity 

we have sentence transformers it maps sentences & paragraphs to a 384 dimensional dense vector space and can be used for tasks like clustering or semantic search


embedding s converting text into vector and these vectors now used to my llm for reasoning ?

384 Dimension generally have so we use maths and do dot product multiply add normalize    

we can get embedding form open ai api and from local llm 

pure keyword based search are yield to show less relavent result 



