
## Why Chunking Exists

Embedding models and LLMs both have token limits. You can't embed an entire 100-page document into a single vector — the model can't process it, and even if it could, one vector representing 100 pages would be a useless blob that averages out all meaning. So you split documents into chunks, embed each chunk individually, and store them separately. Good chunking is the single biggest lever you have over RAG quality — bad chunks mean bad retrieval even with a perfect embedding model.

---

## The 4 Properties Every Good Chunk Must Have

Before the strategies, understand what you're optimising for:

**1. Quality** — does the chunk contain a complete, coherent thought? A chunk that cuts a sentence in half or mixes two unrelated ideas is a low-quality chunk. The embedding will be confused and noisy.

**2. Boundary** — where does the chunk start and end? The best boundaries are natural ones — end of a paragraph, end of a section, end of a sentence. The worst boundaries are arbitrary — mid-sentence, mid-table, mid-code block.

**3. Size** — chunk size is a trade-off. Too small: not enough context, the LLM can't reason from it. Too large: the embedding averages out multiple topics and becomes imprecise for retrieval. Most practitioners start at 512 tokens with 10–20% overlap and iterate from there based on evaluation results.

**4. Balance of context** — the chunk should be able to stand alone and make sense without the surrounding text. If someone reads only that chunk, they should understand what it's about. If it starts with "However, this means that..." — it's context-dependent and won't embed well.

---

## Types of Chunking

### 1. Fixed-Size Chunking

The simplest approach. Pick a number (say 512 tokens) and split every N tokens regardless of what's happening in the text.

**Example:**

Original text:

```
Neural networks are computational models inspired by the brain.
They consist of layers of interconnected nodes. Each node applies
a mathematical transformation to its input. The result is passed
to the next layer. This architecture allows networks to learn
complex patterns from data. Gradient descent is the algorithm
used to train them. It minimises a loss function by adjusting weights.
```

With fixed-size chunking at ~30 tokens:

```
Chunk 1: "Neural networks are computational models inspired by the brain.
          They consist of layers of interconnected nodes. Each node applies"

Chunk 2: "a mathematical transformation to its input. The result is passed
          to the next layer. This architecture allows networks to learn"

Chunk 3: "complex patterns from data. Gradient descent is the algorithm
          used to train them. It minimises a loss function by adjusting weights."
```

Notice Chunk 1 cuts "Each node applies" — the sentence continues in Chunk 2. The idea is split across boundaries. This is the core problem.

**Pros:** Fast, simple, easy to implement, predictable batch sizes. **Cons:** Splits text based on character, word, or token counts without considering meaning. Prioritises speed over accuracy. Cuts sentences mid-thought. **Use when:** Quick prototyping, uniform short documents, tight compute budget.

---

### 2. Sentence / Paragraph Chunking

Split at natural language boundaries — sentence ends (full stop, question mark) or paragraph breaks (`\n\n`).

**Example:**

Same text split by paragraph boundary:

```
Chunk 1: "Neural networks are computational models inspired by the brain.
          They consist of layers of interconnected nodes. Each node applies
          a mathematical transformation to its input. The result is passed
          to the next layer. This architecture allows networks to learn
          complex patterns from data."

Chunk 2: "Gradient descent is the algorithm used to train them.
          It minimises a loss function by adjusting weights."
```

Each chunk is now a complete thought. No sentence is broken.

**Pros:** Preserves sentence integrity, natural boundaries. **Cons:** Chunk sizes vary wildly. One paragraph might be 50 tokens, another 800 tokens. **Use when:** Clean prose documents, articles, books.

---

### 3. Recursive Character Text Splitting

Applies splitting rules in a stepwise fashion until each chunk fits within a defined size limit. It first splits by section headers, then by paragraphs, and finally by sentences. The process continues until each piece is manageable and within the predefined size.

This is the most commonly used method in practice (LangChain's `RecursiveCharacterTextSplitter`). The hierarchy of separators is:

```
["\n\n", "\n", ". ", " ", ""]
```

It tries to split at `\n\n` first. If the resulting chunk is still too big, it splits at `\n`. Still too big? Split at sentence boundary. Still too big? Split at space. Last resort: split mid-word.

**Pros:** Respects document structure as much as possible, predictable size, flexible. **Cons:** Still doesn't understand meaning, just structure. **Use when:** Most general-purpose RAG. This is the default safe choice.

---

### 4. Semantic Chunking

Instead of splitting by structure or size, split by meaning. Semantic chunking uses embedding similarity to identify conceptual boundaries, ensuring each chunk focuses on a single theme. This alignment with user intent significantly improves retrieval precision compared to rule-based splitting methods.

**How it works:**

1. Split the document into individual sentences
2. Embed every sentence
3. Compute cosine similarity between consecutive sentence pairs
4. Where similarity drops sharply, that's a topic shift — place a chunk boundary there
5. Merge sentences within a boundary into one chunk

**Example:**

```
S1: "The transformer architecture was introduced in 2017."       → [embed] ─┐ similarity: 0.91 → SAME TOPIC
S2: "It relies on self-attention instead of recurrence."         → [embed] ─┤
S3: "BERT and GPT are both based on transformers."               → [embed] ─┘ similarity: 0.87 → SAME TOPIC
                                                                              similarity: 0.21 → TOPIC SHIFT ← boundary here
S4: "Gradient descent minimises the loss function."              → [embed] ─┐ similarity: 0.88 → SAME TOPIC
S5: "Weights are updated by the derivative of the loss."         → [embed] ─┘
```

Result:

```
Chunk 1: S1 + S2 + S3  (all about transformers)
Chunk 2: S4 + S5        (all about training)
```

**Pros:** Each chunk contains exactly one coherent topic. Best quality embeddings. **Cons:** Requires embedding every sentence during indexing — slower and more expensive. Semantic chunking can improve recall by up to 9% over simpler methods, at the cost of embedding every sentence. **Use when:** High-quality retrieval is critical, compute budget allows it.

---

### 5. Hierarchical / Parent-Child Chunking

Two layers of chunks are maintained simultaneously. Large parent chunks (512–1024 tokens) preserve broad context. Small child chunks (64–128 tokens) are what actually gets embedded and searched.

**How it works:**

- Index: embed the small child chunks and store in vector DB
- Retrieval: find relevant child chunks via similarity search
- Generation: fetch the parent chunk those children belong to, and pass the full parent to the LLM

**Example:**

```
Parent Chunk (full section):
"The kidney filters blood and produces urine. It regulates fluid balance,
electrolyte levels, and blood pressure. The nephron is the functional unit
of the kidney. Each kidney contains about one million nephrons. The glomerulus
filters blood under pressure. The filtrate then passes through tubules where
useful substances are reabsorbed back into the blood."

Child Chunk A: "The kidney filters blood and produces urine."
Child Chunk B: "The nephron is the functional unit of the kidney."
Child Chunk C: "The glomerulus filters blood under pressure."
```

Query: "What filters blood in the kidney?" → Child C retrieved → Parent returned to LLM with full context.

**Pros:** Precise retrieval (small chunks) + rich context for generation (large chunks). Consistently ranks at the top of retrieval evaluation benchmarks. **Cons:** More complex to implement, two index layers to maintain. **Use when:** Production RAG, enterprise systems, long technical documents.

---

### 6. Document-Aware / Structural Chunking

Use the document's own structure — headings, subheadings, sections — as natural boundaries. A Markdown file's `##` headings, a PDF's table of contents, an HTML document's `<section>` tags.

**Example (Markdown):**

```markdown
## Introduction
This paper proposes a new method...

## Methodology
We collected data from...

## Results
The model achieved 94% accuracy...
```

Each section becomes one chunk, regardless of length.

**Pros:** Semantically coherent by definition — each chunk is a complete document section. **Cons:** Chunk sizes vary wildly. Requires clean structured input. **Use when:** Well-structured documents, technical manuals, legal docs, research papers.

---

### 7. Agentic Chunking

An LLM reads each document and decides where chunk boundaries should go, based on understanding of the content. Slow and expensive but produces the highest-quality chunks. **Use when:** Very high-value documents where quality matters more than speed.

---

## Overlap — What It Is and Why It's Needed

When you split a document into chunks, information that sits near a boundary gets split between two chunks. Neither chunk has the full picture. Overlap solves this by making consecutive chunks share some text.

**Without overlap:**

```
Chunk 1 (tokens 0–500):   "...The experiment ran for three days. The results showed—"
Chunk 2 (tokens 501–1000): "—a 40% improvement in accuracy. This was attributed to..."
```

The key result (40% improvement) is in Chunk 2 but the context ("three day experiment") is in Chunk 1. If only Chunk 2 is retrieved, the LLM doesn't know what experiment is being referenced.

**With 50-token overlap:**

```
Chunk 1 (tokens 0–500):   "...The experiment ran for three days. The results showed—"
Chunk 2 (tokens 450–950): "The results showed a 40% improvement in accuracy. This was attributed to..."
```

Now Chunk 2 contains both the result AND the transition from the experiment description. Retrieving it alone gives the LLM enough context.

**Typical overlap values:** 10–20% of chunk size. If chunk size is 512 tokens, overlap of 50–100 tokens. For prose and documentation use 10–15%, code use 5–10%, logs and structured data use zero or minimal overlap.

**Trade-off:** More overlap = more context preserved, but also more redundant data stored and higher index size.

---

## The Mixed-Class Problem — When One Chunk Has Multiple Topics

This is a real and serious problem. If a chunk contains text about three different things (say: Quality, Boundaries, and Size), the embedding model averages the meaning of all three into one vector. The resulting vector doesn't accurately represent any single topic.

Chunks that are too large often mix multiple ideas together, creating a noisy "averaged" embedding that doesn't clearly represent any single topic, making it hard for the vector retrieval step to find all the relevant context.

**Concrete example:**

```
Chunk: "Chunk quality depends on semantic coherence. Boundaries should fall at
        natural language breaks like paragraph ends. Size is typically 256–512
        tokens for most embedding models."
```

This chunk is about three distinct dimensions — quality, boundary, size. Its embedding is the average of all three. Now if a user asks "what is the right chunk size?" the vector DB has to match the query vector (which is about size) against this averaged vector (which is diluted with quality and boundary information). It may score lower than a focused chunk that only talks about size.

**Solutions:**

- Use smaller chunks so each covers only one idea
- Use semantic chunking to detect topic shifts and place boundaries there
- Use hierarchical chunking — small focused child chunks for retrieval, large parents for context
- Tag chunks with metadata about their topic so you can filter at retrieval time

---

## How Chunks Load into a Vector DB

This is the ingestion pipeline. It happens offline before any user queries.

**Step 1 — Load raw documents** Read your PDFs, text files, HTML pages, markdown files. Parse them into plain text. Remove noise (headers, footers, page numbers, boilerplate).

**Step 2 — Chunk** Apply your chosen chunking strategy. Each chunk is now an independent piece of text, say 50 to 600 tokens long.

**Step 3 — Embed each chunk** Pass every chunk through an embedding model. Each chunk becomes a vector of 384 or 768 or 1536 numbers. This is the most compute-heavy step.

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')

chunks = ["Kidney filters blood.", "Nephron is the functional unit.", ...]
vectors = model.encode(chunks)  # shape: (N, 384)
```

**Step 4 — Attach metadata** Each chunk needs metadata stored alongside its vector: source document name, page number, chunk index, section title, timestamp. This allows filtering during retrieval (e.g., "only search documents from 2024").

**Step 5 — Upsert into vector DB** "Upsert" = insert or update. You send (vector, original text, metadata) to the vector DB. The DB stores the vector and builds/updates its ANN index (e.g., HNSW graph).

```python
import qdrant_client

client = qdrant_client.QdrantClient("localhost", port=6333)

points = []
for i, (chunk_text, vector) in enumerate(zip(chunks, vectors)):
    points.append({
        "id": i,
        "vector": vector.tolist(),
        "payload": {
            "text": chunk_text,
            "source": "kidney_physiology.pdf",
            "page": 3,
            "chunk_index": i
        }
    })

client.upsert(collection_name="my_docs", points=points)
```

**Step 6 — Index is built** The vector DB builds its HNSW graph over all inserted vectors. Now it can answer nearest-neighbour queries in milliseconds.

**At query time:**

```
User query → embed → query vector → vector DB finds top-K nearest chunk vectors
→ returns chunk texts → injected into LLM prompt → LLM generates answer
```

---

## Summary — Which Strategy to Use

|Document type|Best chunking strategy|
|---|---|
|Quick prototype, uniform docs|Fixed-size with 15% overlap|
|General prose, articles|Recursive character splitting|
|High-quality retrieval, mixed topics|Semantic chunking|
|Long technical docs, manuals|Hierarchical parent-child|
|Structured markdown/PDF with sections|Document-aware / structural|
|High-value docs, production critical|Agentic (LLM-based)|

The most important practical rule: Recursive character splitting at 400–512 tokens with 10–20% overlap is the best default for most use cases. Start there. Measure retrieval quality. Only move to more complex strategies if evaluation shows it's needed.