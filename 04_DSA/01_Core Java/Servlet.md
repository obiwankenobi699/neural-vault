# Servlet Work on Server Side

A servlet is a Java class that runs on the web server and handles client requests. When a client (typically a web browser) sends an HTTP request to the server, the servlet processes that request and generates a dynamic response.

## How Servlets Work on the Server Side

When a request arrives at the web server, the servlet container (like Apache Tomcat, Jetty, or GlassFish) manages the servlet's execution. The container receives the HTTP request, determines which servlet should handle it based on URL mappings, and then invokes the appropriate servlet method. The servlet processes the request, potentially interacting with databases or other resources, and generates an HTTP response that gets sent back to the client.

```
┌─────────────┐                                    ┌───────────────────────────┐
│   Client    │                                    │      Web Server           │
│  (Browser)  │                                    │                           │
└──────┬──────┘                                    │  ┌─────────────────────┐  │
       │                                           │  │ Servlet Container   │  │
       │  1. HTTP Request                          │  │                     │  │
       │  (GET /app/servlet)                       │  │  ┌──────────────┐   │  │
       ├──────────────────────────────────────────>│──┼─>│   Servlet    │   │  │
       │                                           │  │  │   Instance   │   │  │
       │                                           │  │  │              │   │  │
       │                                           │  │  │  doGet()     │   │  │
       │                                           │  │  │  doPost()    │   │  │
       │                                           │  │  │              │   │  │
       │                                           │  │  └──────┬───────┘   │  │
       │                                           │  │         │           │  │
       │                                           │  │         │ 2. Process│  │
       │                                           │  │         │   Request │  │
       │                                           │  │         ▼           │  │
       │                                           │  │  ┌──────────────┐   │  │
       │                                           │  │  │   Database   │   │  │
       │                                           │  │  │  /Resources  │   │  │
       │                                           │  │  └──────┬───────┘   │  │
       │                                           │  │         │           │  │
       │  4. HTTP Response                         │  │         │ 3. Generate│  │
       │  (HTML/JSON/XML)                          │  │         │   Response│  │
       │<──────────────────────────────────────────┼──┼─────────┘           │  │
       │                                           │  │                     │  │
       │                                           │  └─────────────────────┘  │
       │                                           │                           │
└──────┴──────┘                                    └───────────────────────────┘
```

The servlet container provides the runtime environment for servlets, handling tasks like request routing, thread management, session tracking, and security. This allows developers to focus on business logic rather than low-level HTTP protocol details.

# Servlet Lifecycle

The servlet lifecycle consists of several distinct phases that the servlet container manages:

```
                    SERVLET LIFECYCLE
                    
    ┌────────────────────────────────────────┐
    │   1. LOADING & INSTANTIATION           │
    │                                        │
    │   • Container loads servlet class      │
    │   • Creates servlet instance           │
    │   • Happens at first request or        │
    │     server startup                     │
    └────────────┬───────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────────────────┐
    │   2. INITIALIZATION                    │
    │                                        │
    │   init()  ← Called ONCE                │
    │                                        │
    │   • Load configuration                 │
    │   • Establish DB connections           │
    │   • Initialize resources               │
    └────────────┬───────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────────────────┐
    │   3. REQUEST HANDLING (Ready State)    │
    │                                        │
    │   service() ← Called for EACH request  │
    │        │                               │
    │        ├──> doGet()                    │
    │        ├──> doPost()                   │
    │        ├──> doPut()                    │
    │        └──> doDelete()                 │
    │                                        │
    │   [Multiple threads handle concurrent  │
    │    requests simultaneously]            │
    │                                        │
    │         ↺ Repeats for each request     │
    └────────────┬───────────────────────────┘
                 │
                 │ (Server shutdown or
                 │  servlet removal)
                 ▼
    ┌────────────────────────────────────────┐
    │   4. DESTRUCTION                       │
    │                                        │
    │   destroy() ← Called ONCE              │
    │                                        │
    │   • Close DB connections               │
    │   • Release resources                  │
    │   • Save persistent state              │
    └────────────┬───────────────────────────┘
                 │
                 ▼
         [Garbage Collection]
```

## 1. Loading and Instantiation

The servlet container loads the servlet class and creates an instance of it. This typically happens when the first request for the servlet arrives, though it can be configured to occur at server startup using the `<load-on-startup>` element in web.xml.

## 2. Initialization (init method)

After instantiation, the container calls the `init()` method exactly once. This method allows the servlet to perform one-time setup tasks like loading configuration data, establishing database connections, or initializing resources. The servlet cannot service any requests until initialization completes successfully.

## 3. Request Handling (service method)

Once initialized, the servlet is ready to handle client requests. For each request, the container calls the `service()` method, which examines the HTTP request type (GET, POST, PUT, DELETE, etc.) and dispatches it to the appropriate method like `doGet()`, `doPost()`, `doPut()`, or `doDelete()`. Multiple threads may execute the service method concurrently to handle simultaneous requests, so thread safety is important.

## 4. Destruction (destroy method)

When the servlet container decides to remove the servlet from service (during server shutdown or redeployment), it calls the `destroy()` method once. This gives the servlet a chance to clean up resources like closing database connections, saving state, or releasing file handles. After `destroy()` completes, the servlet instance becomes eligible for garbage collection.

# Common Gateway Interface (CGI)

CGI is an early standard protocol that enables web servers to execute external programs and return their output to web clients. When a web server receives a request for a CGI program, it creates a new process to run that program, passes request data through environment variables and standard input, and captures the program's output to send back as the HTTP response.

## How CGI Works

```
┌──────────┐         ┌─────────────────────────────────────┐
│  Client  │         │         Web Server                  │
│ (Browser)│         │                                     │
└────┬─────┘         │                                     │
     │               │                                     │
     │ HTTP Request  │                                     │
     ├──────────────>│  1. Receive Request                 │
     │               │     /cgi-bin/script.cgi?param=value │
     │               │                                     │
     │               │  2. Create NEW Process              │
     │               │     for each request                │
     │               │          │                          │
     │               │          ▼                          │
     │               │  ┌───────────────────┐              │
     │               │  │   CGI Program     │              │
     │               │  │   (Perl/Python/   │              │
     │               │  │    C/Shell)       │              │
     │               │  │                   │              │
     │               │  │  • Read ENV vars  │              │
     │               │  │  • Process data   │              │
     │               │  │  • Generate output│              │
     │               │  └─────────┬─────────┘              │
     │               │            │                        │
     │               │  3. Capture output (STDOUT)         │
     │               │            │                        │
     │               │  4. Process terminates              │
     │               │     (Resources released)            │
     │               │            │                        │
     │  HTTP Response│            ▼                        │
     │<──────────────┼────────────┘                        │
     │               │                                     │
     │               │  [New process created for EVERY     │
     │               │   subsequent request]               │
└────┴─────┘         └─────────────────────────────────────┘
```

The web server receives an HTTP request for a resource identified as a CGI script. The server spawns a new process to execute the script, setting environment variables with request information like query parameters, HTTP headers, and request method. The CGI program reads this data, performs its processing, and writes the response (including HTTP headers) to standard output. The server captures this output and forwards it to the client.

## CGI vs Servlets - Performance Comparison

```
        CGI ARCHITECTURE                    SERVLET ARCHITECTURE
                                    
┌──────────────────────────────┐   ┌─────────────────────────────┐
│  Request 1  →  New Process   │   │      Single JVM Process     │
│                               │   │                             │
│  Request 2  →  New Process   │   │  Request 1 → Thread 1 ─┐    │
│                               │   │                        │    │
│  Request 3  →  New Process   │   │  Request 2 → Thread 2 ─┤    │
│                               │   │                        ├─→  │
│  Request 4  →  New Process   │   │  Request 3 → Thread 3 ─┤ Servlet│
│                               │   │                        │ Instance│
│  [Heavy overhead]             │   │  Request 4 → Thread 4 ─┘    │
│  [No resource sharing]        │   │                             │
│  [No state persistence]       │   │  [Lightweight threads]      │
│                               │   │  [Shared resources]         │
└──────────────────────────────┘   │  [Connection pooling]       │
                                    │  [Session management]       │
         ❌ SLOW                     └─────────────────────────────┘
      (Process per request)                  ✅ FAST
                                         (Thread per request)
```

## Limitations of CGI

CGI has significant performance limitations because it creates a new process for every single request. Process creation is expensive in terms of both time and system resources, making CGI unsuitable for high-traffic websites. Additionally, CGI programs cannot maintain state between requests without external mechanisms like files or databases, and they cannot share resources or cached data across multiple requests.

## CGI vs Servlets

Servlets were designed to overcome CGI's limitations. While CGI creates a new process per request, servlets use threads within a single process, making them much more efficient. Servlets remain in memory and can be reused across multiple requests, whereas CGI programs start fresh each time. The servlet container manages connection pooling, session tracking, and other optimizations that would need custom implementation in CGI. This makes servlets significantly faster and more scalable than traditional CGI programs, which is why servlets became the preferred technology for Java-based web applications.