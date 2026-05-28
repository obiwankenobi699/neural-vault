
## Why MCP Exists — The N×M Problem

Before MCP, connecting AI models to external tools was a manual, bespoke job. The core challenge is the "N×M integration problem" — when integrating N tools (Slack, GitHub, databases) with M model frontends (ChatGPT, Gemini, Claude), every combination needs a unique adapter. Without a standard, you end up with N×M bespoke solutions.

Concrete example: 4 AI products × 5 tools = 20 custom integrations. Each one has its own authentication flow, its own way of passing parameters, its own error format, its own schema. When a tool's API changes, all the adapters break. When you add a new model, you rewrite all the tool connectors. This doesn't scale.

The secondary problem was that AI models had no way to **discover** tools at runtime. You had to hardcode which tools were available and exactly how to call them. There was no standard "menu" an AI could read to figure out what was possible.

---

## What MCP Is

MCP, introduced by Anthropic in November 2024, is an open standard that bridges AI assistants and the data-rich ecosystems they need to navigate. It eliminates patchy integrations by providing a universal framework for connecting tools and data sources.

The simplest analogy: MCP is the USB-C of AI integrations. Before USB-C every device had its own charging port. After USB-C you have one standard — any charger works with any device. MCP does the same for AI + tools.

What it is technically: a set of rules (a protocol) that standardises:

- how an AI app asks for available tools
- how tools describe themselves
- how tool calls are made and results returned
- how data and context are shared
- the format of all messages (JSON-RPC 2.0)

MCP's distinguishing feature is its AI-native design. Traditional APIs were optimised for static, predefined interactions, whereas MCP supports dynamic capability discovery. At runtime, an MCP client can query the server to learn which functions are available, enabling AI agents to adaptively incorporate new tools without hardcoded logic.

---

## Before MCP vs After MCP — How AI Agents Work

**Before MCP:**

- Developer writes custom integration code for each tool + each model pair
- The integration knows exactly what endpoints exist, how to authenticate, what parameters to send
- If the tool API changes, the integration breaks
- The AI has no way to discover what tools are available — it's told by the developer at build time
- Adding one new tool means writing new adapter code for every model you use

**After MCP:**

- Tool developers implement one MCP server that exposes their capabilities
- AI app developers build one MCP client that speaks the protocol
- At runtime, the client asks the server: "what tools do you have?" — the server replies with a list and schemas
- The LLM reads those schemas and decides when and how to use each tool, dynamically
- Adding a new tool = spin up one MCP server. Any MCP-compatible AI can use it immediately
- Enterprises can add new tools without modifying the core AI application.

---

## Architecture — The Three Components

### 1. MCP Host

The host is the application like Claude Desktop, an IDE, or a custom AI agent tool that wants to access data through MCP. Hosts orchestrate the overall flow between user requests, LLM processing, and external tools. Hosts are responsible for managing user interactions and permissions.

The host contains the LLM and the MCP client. It is the thing the user actually talks to. It decides which servers to connect to, manages auth and permissions, and controls what the user sees. Examples: Claude Desktop, Cursor IDE, a custom chatbot you build.

### 2. MCP Client

MCP clients are protocol clients that maintain dedicated one-to-one connections with MCP servers. Each client handles the protocol-level details of MCP communication and acts as an intermediary between the host's logic and external servers.

One MCP client per server — that is a hard rule. If your host connects to three servers (GitHub, Slack, database), it has three client instances, each maintaining its own session with its respective server. The client translates the host's intent into MCP protocol messages and sends them over JSON-RPC.

MCP's architecture lets hosts coordinate multiple client-driven workflows with external tools, all over a reliable, stateful JSON-RPC protocol, ensuring security, modularity, and advanced tool orchestration.

### 3. MCP Server

This is what tool/service developers build. A server wraps whatever external capability exists (a database, an API, a file system) and exposes it in MCP's standard format. MCP servers expose tools and resources through a standardised interface. This modular approach allows developers to add or update tools without reworking their entire system.

A server can run locally (as a process on the same machine, communicating via stdio) or remotely (on the internet, over HTTP with server-sent events for streaming).

---

## The Three Primitives — What a Server Exposes

Every MCP server exposes up to three types of things. This is where most confusion happens.

### Tools — model-controlled, action-oriented

Tools are executable functions — the AI calls a tool to take an action (run a query, write a record, call an API). They are model-controlled: the AI decides when to call them based on the task.

Tools have side effects. They change state in the world. They do things. The LLM reads the tool's schema (name, description, input parameters), decides when the tool is needed, constructs the arguments, and calls it. The model is in charge.

Examples:

- `create_issue(repo, title, body)` — creates a GitHub issue
- `send_message(channel, text)` — posts to Slack
- `run_query(sql)` — executes a database query
- `read_file(path)` — reads a file from disk

### Resources — application-controlled, data-oriented

Resources are read-only data sources — the AI reads from a resource to get context (a file, a database record, a knowledge base). They are application-controlled: the host decides when to surface them.

Resources don't take actions. They provide context. They are identified by URIs (like `repo://my-org/my-repo/README.md` or `db://customers/schema`). The host application decides when to load a resource and inject it into context — the model doesn't autonomously go fetch resources the way it calls tools.

Examples:

- `repo://org/repo` — the contents of a GitHub repository
- `schema://database/users` — the schema of a database table
- `file:///home/user/docs/notes.md` — a local file

### Prompts — user-controlled, template-oriented

Prompts are reusable interaction templates — pre-defined workflows or instruction structures that guide how the AI should use the server's tools and resources for a given task. They are user-controlled: exposed to the user as selectable options rather than triggered autonomously by the model.

Prompts are like macros. A GitHub MCP server might expose a prompt called "Review this PR" which already has all the right instructions and context injection built in. The user selects it, and the prompt takes over the interaction. The model doesn't decide to use a prompt on its own — the user picks it.

---

## Common Confusion — Cleared Up

**"Aren't tools just API calls?"** Yes and no. A tool is a function the model can call. That function might internally make an API call, run a query, or do anything else. But the difference from a raw API is that MCP tools come with a schema description that the model can read and reason about — the model discovers what the tool does and decides when to use it. Raw APIs have no such self-description for AI consumption.

**"What's the difference between a tool and a resource?"** The key is who controls the invocation and whether there's a side effect. Tools: model decides when to call them, they perform actions and change state. Resources: application or user decides when to load them, they are read-only data. If it writes, mutates, sends, or executes — it's a tool. If it just provides data to read — it's a resource.

**"When would I use a resource instead of a `read_file` tool?"** If the content is static context that should always be available (like a company knowledge base), make it a resource. If the reading is conditional and the model should decide when to fetch it, make it a tool. In practice, there's a grey area — the spec itself is ambiguous here, and many developers use tools for everything because tools are model-controlled and more flexible.

**"Is MCP the same as function calling?"** MCP builds on top of function calling — the primary method for calling APIs from LLMs — to make development simpler and more consistent. Function calling allows LLMs to invoke predetermined functions based on user requests, and is a well-established feature of modern AI models. MCP doesn't replace function calling — it standardises the layer around it. Capability discovery, session management, transport, authentication, and tool description format are all standardised by MCP on top of the underlying function calling mechanism.

**"Can one host connect to multiple servers?"** Yes. A host can have many MCP client instances, one per server. The LLM sees all tools from all connected servers merged into one tool list. It doesn't know which server a tool came from — it just sees the tool and calls it.

---

## How They All Interact — The Full Data Flow

1. User opens a host app (e.g. Claude Desktop) and types a request
2. The host connects to configured MCP servers. Each MCP client sends a `tools/list` request and gets back a list of available tools with their schemas
3. The host passes the user's query to the LLM along with the full list of available tools
4. LLM reads the tool schemas, reasons about what's needed, and emits a `tool_call` for the appropriate tool with constructed arguments
5. The MCP client receives the tool_call, formats it as a JSON-RPC request, and sends it to the right server
6. The server executes the underlying action (API call, DB query, file read) and sends back a JSON-RPC response
7. The MCP client hands the result back to the LLM as a `tool_result`
8. The LLM generates its final answer grounded in the tool result
9. The host displays the answer to the user

All messages between client and server use JSON-RPC 2.0. Local servers use stdio (stdin/stdout). Remote servers use HTTP with server-sent events for streaming.

---

## What Changed After MCP

||Before MCP|After MCP|
|---|---|---|
|Integration effort|N×M custom adapters|1 server per tool, works with any client|
|Tool discovery|Hardcoded at build time|Dynamic at runtime via `tools/list`|
|Adding a new model|Rewrite all integrations|Zero work — connects via MCP client|
|Adding a new tool|Write adapter for each model|Write one MCP server|
|Context sharing|Manual, bespoke|Resources exposed via standard URIs|
|Security|Per-integration, inconsistent|Standardised, session-isolated|
|Agent capability|Static, predetermined|Dynamic, compositional across servers|

MCP builds on existing concepts like tool use and function calling but standardises them. This reduces the need for custom connections for each new AI model and external system.