
███╗      ███╗    ██╗     ██╗  ██╗   ██ ╗    ██╗     ██╗  ██╗     
████╗ ████║    ██║     ██║  ██║  ██╔╝   ██║   ██║    ██║     
██╔████╔██║  ██║     ██║  █████╔╝     ██║    ██║   ██║     
██║╚██╔╝██║  ██║     ██║  ██ ╔═██╗    ██║   ██║   ██║     
██║ ╚═╝    ██║╚██████╔╝ ██ ║  ██╗      ██████╔╝███████╗
╚═╝            ╚═╝ ╚═════╝       ╚═╝ ╚═╝         ╚═════╝  ╚══════╝



Node.js Event Loop & Routing - Complete Topic List:

**Google Routing Discovery**

- [www.google.com](http://www.google.com/) → homepage (DNS → IP → load)
    
- [www.google.com/maps](http://www.google.com/maps) → Google Maps (path routing via reverse proxy)
    
- [www.google.com/drive](http://www.google.com/drive) → Google Drive
    
- [www.google.com/images](http://www.google.com/images) → Images search
    
- [www.google.com/translate](http://www.google.com/translate) → Translate tool
    
- Reverse proxy reads path → routes to specialized backend servers
    

**Path-Based Routing (No Docker)**

- Nginx `location /maps { proxy_pass localhost:3000; }`
    
- Caddy `reverse_proxy /maps localhost:3000`
    
- Express.js `app.use('/maps', handler)`
    

**Node.js Architecture**

- Single main thread + event loop (libuv)
    
- Thread pool (4 threads default) for blocking I/O only
    
- Non-blocking for network/file operations
    

**Execution Order (Thumb Rule)**

- 1. SYNC code first (CPU heavy loops block everything)
        
- 2. MICROTASKS (`.then()`, `.catch()`, `process.nextTick()`)
        
- 3. MACROTASKS/Event Loop phases (timers, I/O callbacks)
        

**Microtasks vs Macrotasks**

text

`Microtasks: Promise.resolve().then(), queueMicrotask(), process.nextTick() Macrotasks: setTimeout(0), setImmediate(), I/O callbacks`

**Promises Breakdown**

text

`Creator: new Promise((resolve, reject) => { ... }) Consumer: promise.then().catch() ← both = microtasks API calls: fetch().then().catch() ← same microtask queue`

**Event Loop Phases** (6 stages)

1. timers (`setTimeout`, `setInterval`)
    
2. pending callbacks (I/O)
    
3. idle/prepare
    
4. poll (new I/O events)
    
5. check (`setImmediate`)
    
6. close callbacks
    

**Test Output Pattern**

javascript

`console.log('1-sync'); heavyLoop(); setTimeout(() => console.log('4-timer'), 0); Promise.resolve().then(() => console.log('3-micro')); console.log('2-sync'); // Prints: 1 → heavy → 2 → 3 → 4`

**Your Arch Linux Stack Fit**

- Express routing + event loop = perfect for Google-style proxy
    
- No Docker = native systemd + pacman installs
    
- Single binary deploy (Caddy/Nginx) or `npm start`