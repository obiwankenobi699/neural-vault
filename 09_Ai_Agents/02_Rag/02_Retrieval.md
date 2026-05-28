## What is Retrieval?

RAG stands for Retrieval-Augmented Generation. Before the LLM generates any answer, a retrieval system first fetches the most relevant documents or text chunks from your knowledge base. The LLM then uses those chunks as context. Without good retrieval, even the best LLM gives wrong or hallucinated answers — it simply won't have the right information in front of it.

There are two fundamentally different ways to retrieve: keyword-based and semantic/vector-based.

---

## 1. TF-IDF

TF-IDF is the foundation of keyword search. It gives every word in a document a numerical score that represents how important that word is.

**Term Frequency (TF)** How often does a word appear in this particular document, relative to the document's length?

```
TF = (number of times word appears in doc) / (total words in doc)
```

If the word "neural" appears 10 times in a 500-word document, TF = 10/500 = 0.02.

**Inverse Document Frequency (IDF)** How rare is this word across the entire corpus?

```
IDF = log(total number of documents / number of documents containing this word)
```

If "neural" appears in 10 out of 1000 documents: IDF = log(1000/10) = log(100) ≈ 4.6. A word like "the" appears in all 1000 documents: IDF = log(1000/1000) = log(1) = 0. Common words get zeroed out automatically.

**Final Score**

```
TF-IDF score = TF × IDF
```

You compute this score for every word in every document. When a query comes in, you compute TF-IDF for the query terms and rank documents by how high their scores are for those terms.

**The core problem with TF-IDF** — it is purely about token overlap. The word "automobile" in a query will score zero against a document that only uses the word "car", even though they mean the same thing.

---

## 2. BM25 (Best Matching 25)

BM25 originated from the Okapi IR system at City University London in the 1980s–1990s through several variations, with BM25 emerging as the most effective. The "25" is simply a label in the "Best Matching" family, not a reference to any specific parameter. It is the default ranking algorithm in *ElasticSearch, Lucene, and Solr.*

BM25 fixes two specific weaknesses of TF-IDF:

**Problem 1 — TF saturation** In raw TF-IDF, if a word appears 100 times vs 10 times, the score is 10× higher. But in reality, seeing a word 100 times in a document is not 10× more informative than seeing it 10 times. BM25 applies a saturation curve — extra occurrences keep helping but with diminishing returns. The parameter `k` controls this. Typical value: k = 1.2 to 2.0.

**Problem 2 — Document length bias** A 10,000-word document will naturally contain more occurrences of any word than a 500-word document, even if the short document is more relevant. TF-IDF unfairly rewards long documents. BM25 normalises for document length. The parameter `b` controls how strongly length is penalised (0 = no penalty, 1 = full normalisation). Typical value: b = 0.75.

**The BM25 formula in plain terms:**

```
Score = IDF × [ TF × (k+1) ] / [ TF + k × (1 - b + b × docLen/avgDocLen) ]
```

You don't need to memorise this. The key insight is: BM25 is a bag-of-words retrieval function — it doesn't look at term order, phrase structure, or proximity, only at which words appear and how frequently they occur.

Every part of the BM25 formula has a clear interpretation. When a result is surprising, you can trace why. When you need to tune for your domain, the parameters give you meaningful handles to turn. The interpretability is genuinely valuable.

**Where BM25 fails:** Synonyms, paraphrasing, semantic meaning. "What causes heart failure" vs a document about "cardiac arrest risk factors" — BM25 scores this near zero.

---
## 3. Keyword Search vs Semantic Search

| Feature               | Keyword Search (BM25 / TF-IDF) | Semantic Search (Vector Search)     |
| --------------------- | ------------------------------ | ----------------------------------- |
| Matching Method       | Exact token overlap            | Meaning in vector space             |
| Similarity Style      | `grep`-like matching           | Cosine similarity / vector distance |
| Handles Synonyms      | No                             | Yes                                 |
| Handles Abbreviations | Yes                            | Sometimes inconsistent              |
| Speed                 | Very fast                      | Fast with ANN indexing              |
| Interpretability      | High                           | Harder to trace                     |

**Keyword search is like grep** — fast, exact, transparent. If the word is there, it finds it. If not, it misses it completely. This is a hard ceiling.

**Semantic search** understands meaning. The query "feline health risks" correctly retrieves a document about "cat diseases" because their vector representations are close in space, even with zero word overlap.

Vector similarity search proves inadequate in certain scenarios, including matching abbreviations like GAN or LLaMA, identifying exact names like "Biden" or "Salvador Dali", and finding exact code snippets. In such cases, keyword search guarantees those terms stay on the radar while vector search ensures results are contextually relevant. This is exactly why hybrid search exists.

---

## 4. Embeddings — Converting Text to Vectors

An embedding is a fixed-size list of numbers (a vector) that represents the meaning of a piece of text. The key property: text with similar meaning produces vectors that are numerically close to each other in vector space.

**How a sentence transformer works step by step:**

1. Text is tokenised — broken into subword pieces (e.g., "running" → "run", "##ning")
2. Each token gets an initial vector from a learned lookup table
3. The transformer runs multiple attention layers — each token "looks at" every other token and updates its representation based on context. This is why "bank" in "river bank" and "bank account" produce different vectors even though the word is the same
4. After all attention layers, you have one vector per token. But you need one vector for the whole sentence
5. Mean pooling — average all token vectors into a single vector
6. Models like all-MiniLM-L12-v2 then compress embeddings to 384 dimensions using a projection layer after the transformer output, balancing performance and resource usage

**Training objective — how it learns meaning:** Sentence transformers are trained or fine-tuned with special loss functions that teach the model which sentence pairs belong together and which do not. The model is shown millions of pairs — (similar sentence A, similar sentence B) and (unrelated sentence A, unrelated sentence C) — and trained to push similar pairs close together and unrelated pairs far apart. After training on enough data, the geometry of the vector space encodes semantic relationships.

**The result:**

```
"cat"    → [0.21, -0.44, 0.87, 0.12, ...]  (384 numbers)
"feline" → [0.22, -0.43, 0.85, 0.11, ...]  (very similar numbers)
"bicycle" → [-0.55, 0.91, -0.23, 0.67, ...] (very different numbers)
```

**On dimensions:** Most commonly used pretrained models such as all-MiniLM-L6-v2 generate 384-dimensional vectors, while larger models like all-mpnet-base-v2 output 768 dimensions. The choice of dimensionality is a trade-off between computational efficiency, memory usage, and the model's ability to capture semantic nuances. More dimensions = richer representation but more storage and compute cost.

**Getting embeddings practically:**

- Local (free): `pip install sentence-transformers` → runs on CPU, 384-dim models work fine on a laptop
- OpenAI API (paid): `text-embedding-3-small` gives 1536 dims, `text-embedding-3-large` gives 3072 dims
- Both give you the same thing — an array of floats per input text

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')
embeddings = model.encode(["The cat sat on the mat", "A feline rested on the rug"])
# Shape: (2, 384)
```

The similarity between "The weather is lovely today" and "It's so sunny outside" is 0.666, while between those sentences and "He drove to the stadium" it drops to ~0.10 — showing the model clearly separates related from unrelated sentences.

---

## 5. Vector Similarity — The Maths

Once you have vectors, you need a way to measure how close two vectors are.

**Dot product:** Multiply corresponding numbers and add them all up.

```
A · B = A[0]×B[0] + A[1]×B[1] + ... + A[383]×B[383]
```

**Cosine similarity:** Normalise both vectors to length 1 first, then take the dot product.

```
cosine(A, B) = (A · B) / (|A| × |B|)
```

Result is between -1 and 1. Score of 1 = identical meaning. Score of 0 = unrelated. Score of -1 = opposite meaning. The nearer the outcome is to 1, the more similar the vectors are.

If vectors are already normalised (which sentence transformers typically do), cosine similarity and dot product give identical rankings, so you just do the faster dot product.

**Three distance metrics used in practice:**

- Cosine similarity — measures angle between vectors, ignores magnitude. Most common for text
- Euclidean distance — straight-line distance between points. Sensitive to vector length
- Dot product — cosine × magnitude. Used when magnitude carries information

---

## 6. Vector Databases and ANN Search

A vector DB stores all your embedded chunks and lets you search them fast.

**The naive approach — exact KNN (K-Nearest Neighbours):** Compare your query vector against every stored vector and return the top K closest. This is exact but scales linearly — if you have 10 million chunks, you do 10 million dot products per query. Too slow for production.

**ANN — Approximate Nearest Neighbour:** Accept a tiny loss of accuracy in exchange for massive speed gains. ANN with HNSW gets you sub-50ms search with 95%+ recall. Qdrant, Weaviate, and Elastic all report similar numbers on million-scale datasets. The few documents you miss are usually low-relevance ones that wouldn't pass filtering anyway.

**HNSW (Hierarchical Navigable Small World):** The most popular ANN algorithm. It builds a multi-layer graph where the top layers have long-range connections (for fast coarse navigation) and bottom layers have dense local connections (for fine-grained search). At query time, you navigate down the hierarchy to reach the nearest neighbours quickly without checking every vector.

**Popular vector DBs:** Pinecone (fully managed), Qdrant (open source, fast), Weaviate (built-in hybrid search), ChromaDB (lightweight, good for prototyping), FAISS (library, not a full DB — used inside other systems).

---

## 7. How Embeddings Fit into a RAG Pipeline

**Indexing time (done once, offline):**

1. Load your documents (PDFs, web pages, notes, etc.)
2. Split them into chunks (typically 256–512 tokens each)
3. Pass each chunk through an embedding model → get a vector
4. Store (vector, original text, metadata) in the vector DB

**Query time (every user request):**

1. User sends a query
2. Query goes through the same embedding model → query vector
3. Vector DB finds top-K chunks whose vectors are closest to the query vector
4. The actual text of those chunks is pulled out and inserted into the LLM prompt as context
5. LLM reads the context + the original question and generates an answer

**Important distinction:** The LLM reasons over text, not vectors. Embeddings are a retrieval tool only. When the LLM internally processes tokens, it also uses its own internal embeddings — but those are completely separate from your retrieval embeddings.

---

## 8. Hybrid Search — Best of Both Worlds

Pure keyword search misses synonyms. Pure vector search misses exact terms. Hybrid search improves recall by 17% over dense-only search. MRR improves from 0.68 to 0.84. Precision@10 goes from 72% to 88%. Even out-of-domain queries improve from 45% to 74%. The latency cost is minimal — hybrid search adds only 6ms to the p50 versus dense-only.

**The problem with merging scores:** BM25 scores are unbounded positive numbers (e.g., 12.7, 3.4). Cosine similarity scores are between -1 and 1. You can't add them directly — they're on completely different scales.

**Solution — RRF (Reciprocal Rank Fusion):** Instead of merging raw scores, merge the rank positions. If a document is ranked 3rd by BM25 and 5th by vector search, combine those ranks with a formula. This sidesteps the score-normalisation problem entirely and works well in practice. Most production systems use RRF.

**When to use each:**

|Situation|Use|
|---|---|
|Conceptual questions, paraphrased queries|Semantic/vector|
|Exact names, abbreviations, code, specific product IDs|Keyword/BM25|
|Most real-world production RAG|Hybrid (BM25 + vector + RRF)|

---

## 9. NLP Connection — Sentence Similarity

In NLP, measuring how similar two sentences are is a core task called Semantic Textual Similarity (STS). Sentence transformers were specifically designed for this — trained on NLI (Natural Language Inference) and STS benchmark datasets where human annotators rated sentence pair similarity. The result is a model whose vector space geometry directly encodes human judgements of meaning similarity. This is why it works so well for retrieval — you're essentially asking "which stored sentence is most semantically similar to the query?" and the model's training was literally optimised for that question. 