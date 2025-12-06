---
title:
  "{ Title }":
tags:
  - Typescript
  - Backend
created: 2025-11-30
updated:
  "{ date }":
---



> **Subject:** {{Subject}}  
> **Topic Type:** Concept / Process / Architecture / Example  
> **Related Topics:** 

---
## Advanced Cors

Use this file as `src/middleware/cors.ts` (or similar):

```ts
// src/middleware/cors.ts
import cors, { CorsOptions } from "cors";
import { Request, Response, NextFunction } from "express";

/**
 * Create and return CORS middleware with custom origin check.
 * Usage: app.use(createCorsMiddleware());
 */
export default function createCorsMiddleware() {
  const allowedOrigins = [
    "https://example.com",
    "https://www.example.com",
    "http://localhost:3000",
  ];

  const options: CorsOptions = {
    origin: (origin, callback) => {
      // If no origin (e.g. server-to-server request, curl, Postman), allow it.
      if (!origin) return callback(null, true);

      // If origin is in allowed list, allow it.
      if (allowedOrigins.indexOf(origin) !== -1) {
        return callback(null, true);
      }

      // Otherwise, block it.
      return callback(new Error("Not allowed by CORS"), false);
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    credentials: true, // if you want to allow cookies/auth
    allowedHeaders: ["Content-Type", "Authorization"],
  };

  return cors(options);
}
```

### How to use it in your server

In `src/server.ts` (or wherever you configure `app`):

```ts
import express from "express";
import createCorsMiddleware from "./middleware/cors.js"; // .js for compiled ESM
import app from "./app.js"; // if your app is exported separately

const appInstance = express();

// use body parsers, etc.
appInstance.use(express.json());

// register CORS middleware
appInstance.use(createCorsMiddleware());

/* register routes etc. */
appInstance.use("/", app); // or appInstance.use(app) depending on structure
```

### Notes / fixes I applied

- `origin` callback signature is `(origin, callback)` — you must call `callback(null, true)` to allow or `callback(new Error(...), false)` to reject.
    
- Use `allowedOrigins.indexOf(origin) !== -1` (not `indexof`).
    
- Use `new Error(...)` (capital E).
    
- `methods` should be an array of uppercase HTTP verbs.
    
- Return the configured `cors(options)` — that returns Express middleware.
    
- Export a factory (`createCorsMiddleware`) so you can create/configure per environment.
    
- I included `credentials` and `allowedHeaders` as optional useful settings.
    
- When using ESM + TypeScript, import compiled `.js` in runtime code (e.g. `./middleware/cors.js`), or run via `tsx` which supports `.ts` imports.
    

---

If you want, I can:

- Add environment-based `allowedOrigins` (read from `process.env.ALLOWED_ORIGINS`),
    
- Add TypeScript types for the `allowedOrigins` config,
    
- Show how to enable CORS only for specific routes.
    

Which would you like next?

---
---



## Advance Cors + Nginx

Cross-Origin Resource Sharing (CORS) controls which web origins (scheme + host + port) are allowed to access resources on a server. In microservice architectures CORS becomes a cross-cutting concern: multiple services, gateways, and clients require coordinated policies. These notes cover advanced patterns, secure defaults, implementation examples (Express/Node), gateway-based approaches, and testing/monitoring tips.

---

## Concepts and terminology

**Origin** — the tuple (scheme, host, port) that identifies a calling site (e.g., `https://app.example.com`).
**Simple request** — GET/POST with simple content-types; no preflight.
**Preflight request** — an OPTIONS request the browser issues before non-simple requests (e.g., custom headers, methods other than GET/POST).
**Credentials** — cookies, HTTP authentication, or client certificates. CORS controls whether credentials are allowed.
**Access-Control-Allow-Origin** — response header specifying allowed origin(s).
**Access-Control-Allow-Credentials** — when `true`, allows sending cookies/auth headers. Must not be combined with `Access-Control-Allow-Origin: *`.
**SameSite** — cookie attribute used together with CORS to prevent CSRF-like misuse.
**API Gateway** — recommended single point to centralize CORS for many microservices.

---

## Principles and secure defaults

* Centralize CORS decisions at the edge (API Gateway or web server) instead of scattering ad-hoc rules across services.
* Default to deny: only allow explicitly listed origins.
* Avoid `Access-Control-Allow-Origin: *` if credentials are used.
* Prefer exact origin matches or allow-list patterns; avoid open regex that matches `*.com`.
* Use short-lived tokens or scoped credentials rather than cookies when possible. If cookies needed, coordinate `SameSite=None; Secure; HttpOnly` and `Access-Control-Allow-Credentials: true`.
* Enforce HTTPS; do not allow insecure origins in production.
* Combine CORS with other controls: authentication, rate limits, CSP, and input validation.

---

## Common architecture patterns

### Gateway-first (recommended)

Place a reverse-proxy/API gateway (NGINX, Envoy, Kong, Traefik, AWS ALB/API Gateway, GCP API Gateway) in front of microservices. Implement CORS at the gateway and respond to OPTIONS preflight there. Advantages:

* Single place to configure and change CORS policies.
* reduces duplicate preflight processing across services.
* simplifies auditing and telemetry.

### Service-level fallback

When the gateway cannot fully decide (for example, dynamic rules per tenant), the gateway can forward `Origin` and allow services to respond with their own CORS headers. Ensure consistent policy or trust boundary.

### Hybrid: gateway validation + service assertion

Gateway validates origin and attaches an allowed-origin flag/header; services trust that header and set safe CORS headers. Use mTLS or a signed header to avoid spoofing.

---

## Matching strategies for allowed origins

* **Exact match list**: simplest and safest. Maintain a list of client origins per environment.
* **Subdomain pattern**: allow `https://*.example.com` via a strict regex and validate host segments.
* **Tenant-configured**: store allowed origins per tenant in DB; gateway queries or caches them. Use TTL caching for performance.
* **Environment separation**: disallow dev/staging origins in production.

---

## Handling preflight and actual requests

* Respond to `OPTIONS` preflight quickly at gateway; return:

  * `Access-Control-Allow-Origin: <origin or echo>`
  * `Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS`
  * `Access-Control-Allow-Headers: <requested headers or a safe subset>`
  * `Access-Control-Allow-Credentials: true|false` as needed
  * `Access-Control-Max-Age: <seconds>` to reduce preflight frequency
* For actual requests, return `Access-Control-Allow-Origin` and, if credentials used, `Access-Control-Allow-Credentials: true`.
* If you echo the `Origin` value back, ensure you validated it against an allow-list first.

---

## Express/Node advanced middleware example (TypeScript-style, factory + caching)

```ts
// createCors.ts
import cors, { CorsOptions } from "cors";
import { Request } from "express";

type OriginProvider = (origin: string | undefined) => boolean;

export function createCorsMiddleware(allowedOrigins: string[] | OriginProvider) {
  const isAllowed = (origin?: string) => {
    if (!origin) return true; // allow non-browser clients (Postman, server-to-server)
    if (Array.isArray(allowedOrigins)) {
      return allowedOrigins.indexOf(origin) !== -1;
    }
    return (allowedOrigins as OriginProvider)(origin);
  };

  const options: CorsOptions = {
    origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
      try {
        if (isAllowed(origin)) {
          callback(null, true);
        } else {
          callback(new Error("CORS policy: origin not allowed"), false);
        }
      } catch (err) {
        callback(err as Error, false);
      }
    },
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With", "X-Client-Id", "X-Tenant"],
    credentials: true,
    optionsSuccessStatus: 204,
    maxAge: 86400 // 24h
  };

  return cors(options);
}
```

Notes:

* `isAllowed` can check a database or cache. Keep it fast and cache results.
* Allow `undefined` origin only for server-to-server calls; audit such cases.
* `credentials: true` requires returning a concrete `Access-Control-Allow-Origin` value, not `*`.

---

## Gateway (NGINX) preflight example

Configure NGINX to handle CORS at the edge for a specific location:

```
# nginx.conf
map $http_origin $cors_allow_origin {
    default "";
    "https://app.example.com" $http_origin;
    "https://admin.example.com" $http_origin;
}

server {
    listen 443 ssl;
    server_name api.example.com;

    location / {
        if ($request_method = OPTIONS ) {
            add_header "Access-Control-Allow-Origin" $cors_allow_origin always;
            add_header "Access-Control-Allow-Methods" "GET,POST,PUT,PATCH,DELETE,OPTIONS" always;
            add_header "Access-Control-Allow-Headers" "Authorization,Content-Type,X-Requested-With" always;
            add_header "Access-Control-Allow-Credentials" "true" always;
            add_header "Access-Control-Max-Age" "86400" always;
            return 204;
        }

        proxy_pass http://upstream_service;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        add_header "Access-Control-Allow-Origin" $cors_allow_origin;
        add_header "Access-Control-Allow-Credentials" "true";
    }
}
```

Notes:

* NGINX `map` is efficient and safe for exact-origin matches.
* Never set `Access-Control-Allow-Origin: *` with credentials.

---

## Dynamic origin source example

When tenants have custom web apps, store allowed origins in a database and use an in-memory cache (LRU) in the gateway:

* Request arrives with `Origin`
* Gateway checks cache; on miss, queries config DB for tenant -> populate cache
* If allowed, gateway returns `Access-Control-Allow-Origin: <origin>` and forwards request
* Use short TTL and invalidation on tenant config changes

---

## Credentials, cookies and security

* If your frontend requires cookies for session: set cookie attributes:

  * `Set-Cookie: sid=<token>; Path=/; Secure; HttpOnly; SameSite=None`
* In responses set `Access-Control-Allow-Credentials: true` and echo validated origin (not `*`).
* Be aware of CSRF concerns when credentials are used; combine with CSRF tokens or double-submit cookie pattern.
* Prefer short-lived JWTs sent in `Authorization` header rather than cookies when possible (avoids SameSite complexity).

---

## Service-to-service communication and non-browser clients

* Server-to-server calls (no browser) do not enforce CORS; origin header may be absent. Use mTLS, API keys, or JWT for authentication.
* Do not rely on `Origin` header for authentication — it’s HTTP-level and client-controlled. Validate via stronger auth if required.

---

## Security pitfalls and anti-patterns

* Don’t use `*` when credentials are needed.
* Do not allow arbitrary `Origin` echoing without validation.
* Don’t whitelist user-provided origins without sanitization.
* Avoid overly broad regex that matches `http://*.example.*`.
* Be cautious exposing `Access-Control-Expose-Headers` — limit to needed headers only.

---

## Testing CORS

* Use browser devtools network tab to inspect `Origin`, `Access-Control-Allow-*` headers, and preflight (OPTIONS) responses.
* Use `curl` to simulate requests (note: curl doesn't enforce CORS but shows headers):

```
# simulate preflight
curl -i -X OPTIONS "https://api.example.com/resource" \
  -H "Origin: https://app.example.com" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: X-Requested-With, Content-Type"
```

* Automated tests: write an integration test that asserts gateway returns correct headers for allowed and denied origins.
* Check credentialed requests:

```
# actual fetch from browser must be tested in browser environment, e.g. a Cypress/E2E test.
```

---

## Observability and monitoring

* Log origin and CORS decision at gateway for audit trails (do not log sensitive tokens).
* Expose metrics: number of preflight requests, denied origins, error rates.
* Alert on spikes of denied origins (possible misconfiguration or attack).

---

## Migration checklist (introducing stricter CORS to a running microservices ecosystem)

1. Add gateway-level CORS with conservative allow-list and preflight handling.
2. Temporarily enable permissive mode for internal clients only, log decisions.
3. Roll out stricter policy gradually and monitor denied-origin logs.
4. Provide documentation for frontend teams with required origin(s).
5. For tenant-based apps, provide a UI/API for tenants to register origins; invalidate gateway cache on change.
6. Enforce HTTPS-only origins in production.

---

## Examples: quick rules-of-thumb

* If your API is consumed by third-party web apps: use gateway allow-list per client app (exact origin).
* If only same-organization apps consume API: restrict to subdomains and internal origins, prefer mTLS for service-to-service calls.
* If credentials needed: use `SameSite=None; Secure` cookie + `Access-Control-Allow-Credentials: true` + exact origin echo.

---

## Useful headers cheat-sheet

* Request header (browser): `Origin: https://app.example.com`
* Preflight request: `OPTIONS /resource` with `Access-Control-Request-Method` and `Access-Control-Request-Headers`.
* Preflight response: `Access-Control-Allow-Origin`, `Access-Control-Allow-Methods`, `Access-Control-Allow-Headers`, `Access-Control-Allow-Credentials`, `Access-Control-Max-Age`.
* Actual response: `Access-Control-Allow-Origin`, optionally `Access-Control-Allow-Credentials`, and `Access-Control-Expose-Headers` for exposing headers to JS.

---

## Further reading and references

* MDN CORS documentation: detailed behavior of preflight and headers.
* OWASP: CORS security considerations and misconfiguration examples.
* API gateway docs (NGINX, Envoy, Kong) for built-in CORS modules and best practices.

---

## Minimal recommended configuration (practical)

* Place CORS handling in the API gateway; set exact origin allow-list.
* Enable `Access-Control-Max-Age` to reduce preflight overhead (e.g., 1 day) for stable clients.
* If credentials are required: set `credentials: true` and echo a validated origin.
* Log and monitor denied origins.
* Use HTTPS everywhere.

---

## Quick template: Allowed-origin provider example (pseudo)

```
function isAllowedOrigin(origin) {
  if (!origin) return true; // non-browser allowed? decide based on use-case
  // exact match cache lookup
  const cached = cache.get(origin);
  if (cached !== undefined) return cached;
  const allowed = dbQueryOriginsForClient(origin) || allowedStaticList.includes(origin);
  cache.set(origin, allowed, ttl=300); // short TTL
  return allowed;
}
```

---

These notes can be pasted into Obsidian as-is. If you want, I can:

* produce a condensed checklist card,
* or generate an `nginx` + `express` + `envoy` example repository layout,
* or provide Cypress E2E test examples for CORS behavior. Which would you like next?
