# Neovim & NvChad Complete Step-by-Step Guide

---

## Table of Contents

1. [Understanding the Basics](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#understanding-the-basics)
2. [Package Manager - Lazy.nvim](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#package-manager---lazynvim)
3. [Installation Guide](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#installation-guide)
4. [How Plugins Work](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#how-plugins-work)
5. [Adding & Managing Plugins](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#adding--managing-plugins)
6. [Vim Meta Accessors](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#vim-meta-accessors)
7. [Configuration Workflow](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#configuration-workflow)
8. [Keybinding Reference](https://claude.ai/chat/607261bc-c435-4531-ba14-e695a595220c#keybinding-reference)

---

## Understanding the Basics

### What is Neovim

```
Editor Core
├── Vim (1991)
└── Neovim (2014) - Fork with:
    ├── Lua scripting
    ├── Built-in LSP
    ├── Async I/O
    └── Plugin API
```

### What is NvChad

NvChad is NOT an editor. It's a pre-configured setup for Neovim.

```
┌───────────────────────────────────┐
│   You (User)                      │
├───────────────────────────────────┤
│   NvChad (Config Framework)       │
│   ├── Pre-made configs            │
│   ├── Default plugins             │
│   └── Custom overrides            │
├───────────────────────────────────┤
│   Lazy.nvim (Plugin Manager)      │
│   └── Downloads & manages plugins │
├───────────────────────────────────┤
│   Neovim (The actual editor)      │
└───────────────────────────────────┘
```

---

## Package Manager - Lazy.nvim

### What is Lazy.nvim

Lazy.nvim is the plugin manager that:

- Downloads plugins from GitHub
- Manages plugin versions
- Lazy loads plugins (only loads when needed)
- Handles dependencies
- Updates plugins

### How Lazy.nvim Works

```lua
-- This is THE most important function
require('lazy').setup(plugins, opts)
```

**Breaking it down:**

1. `require('lazy')` - Loads the lazy.nvim module
2. `.setup()` - Function that initializes the plugin manager
3. `plugins` - Table/list of plugins to install
4. `opts` - Optional configuration for lazy.nvim itself

**Example:**

```lua
require('lazy').setup({
  -- Plugin 1
  {
    "neovim/nvim-lspconfig",  -- GitHub repo: username/repo-name
    config = function()
      -- Code to run after plugin loads
    end,
  },
  
  -- Plugin 2
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },  -- This plugin needs plenary
  },
}, {
  -- Options for lazy.nvim itself
  ui = {
    border = "rounded",
  },
})
```

### Plugin Table Structure

```lua
{
  "username/repo-name",           -- REQUIRED: GitHub repository
  
  branch = "main",                -- Git branch (optional)
  commit = "abc123",              -- Specific commit (optional)
  version = "1.0.0",              -- Version tag (optional)
  
  lazy = true,                    -- Don't load on startup
  event = "VeryLazy",             -- Load on this event
  cmd = "CommandName",            -- Load when command is run
  keys = "<leader>f",             -- Load when key pressed
  ft = "python",                  -- Load for filetype
  
  dependencies = {                -- Other plugins this needs
    "user/other-plugin"
  },
  
  config = function()             -- Setup after loading
    require("plugin").setup()
  end,
  
  build = "make",                 -- Command to run after install
  
  enabled = true,                 -- Enable/disable plugin
  
  init = function()               -- Run before loading
    vim.g.plugin_setting = 1
  end,
}
```

### What is "build" / "local build"

**build** runs shell commands after installing/updating a plugin.

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",  -- Run this Neovim command after install
}

{
  "telescope.nvim",
  build = "make",  -- Run 'make' in terminal
}

-- Local build means compiling C/C++ code on your machine
-- Some plugins have native extensions for speed
```

**When you need build:**

- Plugins with compiled components (C/Rust code)
- Plugins needing external tools compiled
- Treesitter parsers

---

## Installation Guide

### Step 1: Install Neovim

```bash
# Check version (need 0.9.0+)
nvim --version

# Ubuntu/Debian
sudo apt install neovim

# Or download latest
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
```

### Step 2: Install Dependencies

```bash
# Required
sudo apt install git curl

# Recommended (for Telescope fuzzy finding)
sudo apt install ripgrep fd-find

# For clipboard support
sudo apt install xclip  # or xsel
```

### Step 3: Backup Old Config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### Step 4: Install NvChad

```bash
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
```

### Step 5: First Launch

```bash
nvim
# Lazy.nvim will automatically:
# 1. Download itself
# 2. Download all NvChad's default plugins
# 3. Install them
# Wait for it to finish (2-5 minutes)
```

**What happens behind the scenes:**

```
nvim launches
    ↓
Loads ~/.config/nvim/init.lua
    ↓
Calls require('lazy').setup(...)
    ↓
Lazy.nvim checks ~/.local/share/nvim/lazy/
    ↓
Downloads missing plugins from GitHub
    ↓
Runs build commands if specified
    ↓
Loads plugins based on lazy-loading rules
    ↓
Editor ready
```

### Step 6: Create Custom Config

```bash
mkdir -p ~/.config/nvim/lua/custom
cd ~/.config/nvim/lua/custom
```

**Create file structure:**

```
~/.config/nvim/
├── init.lua                    # NvChad's entry point (DON'T EDIT)
├── lazy-lock.json              # Plugin versions (auto-generated)
├── lua/
│   ├── core/                   # NvChad core (DON'T EDIT)
│   └── custom/                 # YOUR custom config HERE
│       ├── chadrc.lua          # Main config
│       ├── init.lua            # Custom init
│       ├── mappings.lua        # Keybindings
│       ├── plugins.lua         # Plugin list
│       └── configs/            # Plugin configs
│           ├── lspconfig.lua
│           └── null-ls.lua
```

---

## How Plugins Work

### The Plugin Lifecycle

```
1. DECLARE
   └─> You list plugin in plugins.lua

2. DOWNLOAD
   └─> Lazy.nvim clones from GitHub to ~/.local/share/nvim/lazy/

3. LOAD
   └─> Plugin code is loaded into memory (when triggered)

4. SETUP
   └─> Plugin's setup() function configures it

5. USE
   └─> Plugin features are available
```

### Example: Installing Telescope

**Step 1: Declare in lua/custom/plugins.lua**

```lua
local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.5',
    dependencies = { 
      "nvim-lua/plenary.nvim"  -- Telescope needs this
    },
    cmd = "Telescope",  -- Lazy load when :Telescope command used
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules" }
        }
      })
    end,
  },
}

return plugins
```

**Step 2: Install the plugin**

```vim
:Lazy sync
" This downloads and installs new plugins
```

**Step 3: Use it**

```vim
:Telescope find_files
```

### Understanding require()

```lua
-- require() loads Lua modules

-- This:
require("telescope")

-- Looks for files in this order:
-- 1. ~/.config/nvim/lua/telescope.lua
-- 2. ~/.config/nvim/lua/telescope/init.lua
-- 3. ~/.local/share/nvim/lazy/telescope.nvim/lua/telescope.lua

-- Dot notation:
require("custom.configs.lspconfig")
-- Looks for: ~/.config/nvim/lua/custom/configs/lspconfig.lua
```

---

## Adding & Managing Plugins

### Workflow: Add a New Plugin

**Example: Add a file tree plugin**

**1. Find plugin on GitHub:** `nvim-tree/nvim-tree.lua`

**2. Add to lua/custom/plugins.lua:**

```lua
local plugins = {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup()
    end,
  },
}

return plugins
```

**3. Sync plugins:**

```vim
:Lazy sync
```

**4. Use it:**

```vim
:NvimTreeToggle
```

### Common Plugin Patterns

**Pattern 1: Plugin with Global Reference (BEST PRACTICE)**

```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  config = function()
    require("telescope").setup()
    -- Store in global table for easy keymap access
    _G.builtin = require("telescope.builtin")
  end,
}
```

**Why use _G?**

- No need to require() in every keymap
- Cleaner keybinding code
- Plugin loaded once, reference used everywhere

**Pattern 2: Simple Plugin (no config needed)**

```lua
{
  "numToStr/Comment.nvim",
  keys = { "gc", "gb" },  -- Load when these keys pressed
  config = function()
    require("Comment").setup()
  end,
}
```

### Using Global References (_G Pattern)

**Why this pattern is best:**

```lua
-- WITHOUT _G (bad - requires plugin every time)
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()  -- Loads every keypress
end)

-- WITH _G (good - plugin loaded once)
-- In plugin config:
_G.builtin = require("telescope.builtin")

-- In keymap:
vim.keymap.set("n", "<leader>ff", function()
  _G.builtin.find_files()  -- Just references, no reload
end)
```

**Complete Example with Multiple Plugins:**

```lua
-- lua/custom/plugins.lua
local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" }
        }
      })
      -- Global reference
      _G.builtin = require("telescope.builtin")
    end,
  },
  
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup()
      -- Global reference
      _G.tree = require("nvim-tree.api").tree
    end,
  },
  
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
      require("trouble").setup()
      -- Global reference
      _G.trouble = require("trouble")
    end,
  },
}

return plugins
```

**Now use in keymaps (lua/custom/mappings.lua):**

```lua
local M = {}

M.telescope = {
  n = {
    ["<leader>ff"] = {
      function() _G.builtin.find_files() end,
      "Find files"
    },
    ["<leader>fg"] = {
      function() _G.builtin.live_grep() end,
      "Live grep"
    },
    ["<leader>fb"] = {
      function() _G.builtin.buffers() end,
      "Find buffers"
    },
  },
}

M.nvimtree = {
  n = {
    ["<C-n>"] = {
      function() _G.tree.toggle() end,
      "Toggle tree"
    },
    ["<leader>e"] = {
      function() _G.tree.focus() end,
      "Focus tree"
    },
  },
}

M.trouble = {
  n = {
    ["<leader>xx"] = {
      function() _G.trouble.toggle() end,
      "Toggle diagnostics"
    },
  },
}

return M
```

**Pattern 3: Plugin with Dependencies**

```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  cmd = "Telescope",
}
```

**Pattern 3: Plugin with Custom Config File**

```lua
{
  "neovim/nvim-lspconfig",
  config = function()
    require("custom.configs.lspconfig")
  end,
}
```

**Pattern 4: Plugin Needing Build**

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "python", "javascript" },
    })
  end,
}
```

### Lazy Loading Triggers

|Trigger|When Plugin Loads|Example|
|---|---|---|
|`lazy = false`|On startup|Core plugins|
|`event = "VeryLazy"`|After UI loads|Non-critical plugins|
|`event = "BufReadPre"`|Before opening file|File-specific|
|`cmd = "Command"`|When command run|`:Telescope`|
|`keys = "<leader>f"`|When key pressed|Fuzzy finder|
|`ft = "python"`|For filetype|Python LSP|

### Managing Plugins

**Open Lazy UI:**

```vim
:Lazy
```

**Lazy UI Commands:**

|Key|Action|
|---|---|
|`I`|Install missing plugins|
|`U`|Update plugins|
|`S`|Sync (clean + install + update)|
|`C`|Check for updates|
|`X`|Clean (remove unused)|
|`L`|View log|
|`R`|Restore from lockfile|

**Update all plugins:**

```vim
:Lazy sync
```

**Update specific plugin:**

```vim
:Lazy update telescope.nvim
```

**Remove unused plugins:**

```vim
:Lazy clean
```

---

## Vim Meta Accessors

### 1. vim.opt - Set Editor Options

**What it does:** Sets Neovim options (like :set in Vim)

```lua
-- Boolean options
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative numbers
vim.opt.wrap = false               -- No line wrap

-- Numeric options
vim.opt.tabstop = 4               -- Tab = 4 spaces
vim.opt.shiftwidth = 4            -- Indent = 4 spaces
vim.opt.scrolloff = 8             -- 8 lines above/below cursor

-- String options
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.encoding = "utf-8"

-- List options (append/remove)
vim.opt.shortmess:append("c")     -- Add 'c' flag
vim.opt.iskeyword:append("-")     -- Add '-' to word chars
```

**Scopes:**

```lua
vim.opt        -- Smart (buffer/window/global)
vim.opt_local  -- Buffer-local
vim.opt_global -- Force global
```

### 2. vim.g - Global Variables

**What it does:** Sets global Vim variables

```lua
-- Leader keys
vim.g.mapleader = " "          -- Space as leader
vim.g.maplocalleader = ","     -- Comma as local leader

-- Plugin variables
vim.g.loaded_netrw = 1         -- Disable netrw
vim.g.loaded_netrwPlugin = 1   

-- Custom variables
vim.g.my_custom_var = "value"
```

### 3. vim.cmd - Execute Vim Commands

**What it does:** Runs Ex commands from Lua

```lua
-- Single command
vim.cmd("colorscheme gruvbox")

-- Multiple commands
vim.cmd([[
  set noswapfile
  set nobackup
  highlight Comment cterm=italic
]])

-- When no Lua API exists
vim.cmd("PackerSync")
```

### 4. vim.keymap.set - Keybindings

**Syntax:**

```lua
vim.keymap.set(mode, lhs, rhs, opts)
```

**Parameters:**

```lua
mode  -- String or table: "n", "i", "v", {"n", "v"}
lhs   -- Left-hand side: the key you press
rhs   -- Right-hand side: what happens
opts  -- Table of options
```

**Examples:**

```lua
-- Normal mode: save file
vim.keymap.set("n", "<leader>w", ":w<CR>", 
  { desc = "Save file", silent = true })

-- Insert mode: escape with jk
vim.keymap.set("i", "jk", "<ESC>", 
  { desc = "Exit insert mode" })

-- Multiple modes
vim.keymap.set({"n", "v"}, "<leader>y", '"+y',
  { desc = "Copy to clipboard" })

-- Function callback
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })
```

**Options table:**

```lua
{
  desc = "Description",      -- For which-key
  silent = true,             -- No echo
  noremap = true,            -- Non-recursive (default)
  expr = false,              -- Expression mapping
  buffer = 0,                -- Buffer-local (0 = current)
  nowait = false,            -- Don't wait for more keys
}
```

### 5. vim.api - Neovim API

**What it does:** Low-level Neovim functions

```lua
-- Create autocmd
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Set highlight
vim.api.nvim_set_hl(0, "Comment", { 
  italic = true, 
  fg = "#888888" 
})

-- Buffer operations
vim.api.nvim_buf_set_lines(0, 0, -1, false, {"New line"})
```

### 6. vim.fn - Vim Functions

**What it does:** Calls built-in Vim functions

```lua
-- Get file extension
local ext = vim.fn.expand("%:e")

-- Check if file exists
if vim.fn.filereadable("file.txt") == 1 then
  print("File exists")
end

-- Get current line
local line = vim.fn.getline(".")
```

### 7. vim.loop (vim.uv) - Async I/O

**What it does:** Libuv bindings for async operations

```lua
-- Timer
local timer = vim.loop.new_timer()
timer:start(1000, 0, function()
  print("After 1 second")
end)

-- File system
vim.loop.fs_stat("file.txt", function(err, stat)
  if not err then
    print(stat.size)
  end
end)
```

---

## Configuration Workflow

### Understanding init.lua vs custom configs

**What happens when you open nvim:**

```
1. Neovim loads ~/.config/nvim/init.lua
   │
2. init.lua loads NvChad core
   │
3. NvChad core loads ~/.config/nvim/lua/custom/init.lua (if exists)
   │
4. Lazy.nvim setup() is called
   │
5. Plugins from lua/custom/plugins.lua are loaded
   │
6. Plugin configs run (setting _G variables)
   │
7. Mappings from lua/custom/mappings.lua are set
   │
8. Editor ready
```

**File structure with _G pattern:**

```
~/.config/nvim/
├── init.lua                           # DON'T TOUCH (NvChad entry)
├── lua/
│   ├── custom/
│   │   ├── init.lua                  # Custom settings
│   │   ├── chadrc.lua                # NvChad config
│   │   ├── plugins.lua               # Plugin list (_G here)
│   │   ├── mappings.lua              # Use _G here
│   │   └── configs/
│   │       └── lspconfig.lua
│   └── core/                          # NvChad core
```

### Method 1: Using NvChad Structure (Recommended)

**File: lua/custom/chadrc.lua**

```lua
---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "onedark",
  transparency = false,
}

M.plugins = "custom.plugins"      -- Points to plugins.lua
M.mappings = require("custom.mappings")  -- Load mappings

return M
```

**File: lua/custom/plugins.lua**

```lua
local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { width = 0.9 },
        }
      })
      -- Set global reference
      _G.builtin = require("telescope.builtin")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
      })
      -- Set global reference
      _G.tree = require("nvim-tree.api").tree
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },
}

return plugins
```

**File: lua/custom/mappings.lua**

```lua
local M = {}

M.general = {
  n = {
    ["<C-s>"] = { ":w<CR>", "Save file" },
    ["<leader>q"] = { ":q<CR>", "Quit" },
  },
  i = {
    ["jk"] = { "<ESC>", "Exit insert" },
  },
}

-- Use _G variables from plugins.lua
M.telescope = {
  n = {
    ["<leader>ff"] = {
      function() _G.builtin.find_files() end,
      "Find files"
    },
    ["<leader>fg"] = {
      function() _G.builtin.live_grep() end,
      "Live grep"
    },
    ["<leader>fb"] = {
      function() _G.builtin.buffers() end,
      "Buffers"
    },
    ["<leader>fh"] = {
      function() _G.builtin.help_tags() end,
      "Help tags"
    },
  },
}

M.nvimtree = {
  n = {
    ["<C-n>"] = {
      function() _G.tree.toggle() end,
      "Toggle file tree"
    },
    ["<leader>e"] = {
      function() _G.tree.focus() end,
      "Focus tree"
    },
  },
}

return M
```

**File: lua/custom/init.lua**

```lua
-- Custom vim options
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

-- Custom autocommands
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Remove trailing whitespace on save
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.js" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

### Method 2: Using Plain init.lua (Without NvChad structure)

**If you want everything in one init.lua:**

```lua
-- ~/.config/nvim/init.lua

-- Set leader before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup()
      _G.builtin = require("telescope.builtin")  -- Global reference
    end,
  },
  
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle" },
    config = function()
      require("nvim-tree").setup()
      _G.tree = require("nvim-tree.api").tree  -- Global reference
    end,
  },
})

-- Keymaps (using _G references)
vim.keymap.set("n", "<leader>ff", function()
  _G.builtin.find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
  _G.builtin.live_grep()
end, { desc = "Live grep" })

vim.keymap.set("n", "<C-n>", function()
  _G.tree.toggle()
end, { desc = "Toggle tree" })

-- Autocommands
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

### Why _G Pattern is Better

**Comparison:**

```lua
-- BAD: Plugin required on every keypress
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()  -- Slow
end)

-- GOOD: Plugin loaded once, referenced many times
-- In plugin config:
_G.builtin = require("telescope.builtin")

-- In keymap:
vim.keymap.set("n", "<leader>ff", function()
  _G.builtin.find_files()  -- Fast
end)

-- ALTERNATIVE: Local variable (only works in same file)
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files()  -- Won't work across files
end)
```

**Benefits:**

1. Plugin loaded only once
2. Keymaps are cleaner
3. Works across all config files
4. No performance penalty
5. Easy to access in commands

**Common _G patterns:**

```lua
-- Telescope
_G.builtin = require("telescope.builtin")

-- NvimTree
_G.tree = require("nvim-tree.api").tree

-- LSP
_G.lsp = vim.lsp.buf

-- Trouble
_G.trouble = require("trouble")

-- Harpoon
_G.harpoon = require("harpoon")

-- Usage in keymaps
vim.keymap.set("n", "<leader>ff", function() _G.builtin.find_files() end)
vim.keymap.set("n", "<C-n>", function() _G.tree.toggle() end)
vim.keymap.set("n", "gd", function() _G.lsp.definition() end)
```

### Production-Ready Example

**Full working setup with _G pattern and best practices:**

**File: lua/custom/chadrc.lua**

```lua
---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "onedark",
  transparency = false,
  
  statusline = {
    theme = "default",
    separator_style = "block",
  },
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

return M
```

**File: lua/custom/plugins.lua**

```lua
local plugins = {
  -- Telescope with _G reference
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })
      _G.builtin = require("telescope.builtin")
    end,
  },

  -- NvimTree with _G reference
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
      })
      _G.tree = require("nvim-tree.api").tree
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
      _G.lsp = vim.lsp.buf
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua", "vim", "python", "javascript", "typescript",
        "html", "css", "json", "markdown",
      },
    },
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "pyright",
        "black",
      },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    enabled = true,
  },
}

return plugins
```

**File: lua/custom/configs/lspconfig.lua**

```lua
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = { "pyright", "tsserver", "lua_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
```

**File: lua/custom/mappings.lua**

```lua
local M = {}

M.general = {
  n = {
    ["<C-s>"] = { ":w<CR>", "Save file" },
    ["<leader>q"] = { ":q<CR>", "Quit" },
  },
  i = {
    ["jk"] = { "<ESC>", "Exit insert" },
  },
}

-- Using _G references from plugins.lua
M.telescope = {
  n = {
    ["<leader>ff"] = {
      function() _G.builtin.find_files() end,
      "Find files"
    },
    ["<leader>fg"] = {
      function() _G.builtin.live_grep() end,
      "Live grep"
    },
    ["<leader>fb"] = {
      function() _G.builtin.buffers() end,
      "Buffers"
    },
  },
}

M.nvimtree = {
  n = {
    ["<C-n>"] = {
      function() _G.tree.toggle() end,
      "Toggle tree"
    },
    ["<leader>e"] = {
      function() _G.tree.focus() end,
      "Focus tree"
    },
  },
}

M.lsp = {
  n = {
    ["gd"] = {
      function() _G.lsp.definition() end,
      "Go to definition"
    },
    ["gr"] = {
      function() _G.lsp.references() end,
      "References"
    },
    ["K"] = {
      function() _G.lsp.hover() end,
      "Hover doc"
    },
    ["<leader>ca"] = {
      function() _G.lsp.code_action() end,
      "Code actions"
    },
  },
}

return M
```

**File: lua/custom/init.lua**

```lua
-- Custom options
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

-- Auto-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

---

## Keybinding Reference

### Default NvChad Keybindings

**Leader: Space**

|Mode|Key|Action|
|---|---|---|
|N|`<leader>ff`|Find files|
|N|`<leader>fa`|Find all|
|N|`<leader>fw`|Live grep|
|N|`<leader>fb`|Buffers|
|N|`<leader>fh`|Help tags|
|N|`<leader>fo`|Old files|
|N|`<leader>th`|Theme picker|
|N|`<leader>ch`|Cheatsheet|
|N|`<C-n>`|Toggle file tree|
|N|`<Tab>`|Next buffer|
|N|`<S-Tab>`|Prev buffer|
|N|`<leader>x`|Close buffer|
|N|`<C-h/j/k/l>`|Window navigation|
|N|`<A-i>`|Float terminal|
|N|`<A-h>`|H-term|
|N|`<A-v>`|V-term|
|I|`jk`|Exit insert (if enabled)|

### LSP Keybindings

|Key|Action|
|---|---|
|`gd`|Go to definition|
|`gr`|References|
|`gi`|Implementation|
|`K`|Hover doc|
|`<leader>ca`|Code actions|
|`<leader>rn`|Rename|
|`[d`|Prev diagnostic|
|`]d`|Next diagnostic|

---

## Commands Reference

### Lazy.nvim Commands

```vim
:Lazy              " Open UI
:Lazy sync         " Install + update + clean
:Lazy install      " Install missing
:Lazy update       " Update all
:Lazy clean        " Remove unused
:Lazy check        " Check for updates
:Lazy log          " View log
:Lazy restore      " Restore from lockfile
:Lazy profile      " View startup time
```

### Mason Commands

```vim
:Mason             " Open LSP installer
:MasonInstall pyright
:MasonUninstall pyright
:MasonUpdate
```

### NvChad Commands

```vim
:NvCheatsheet      " Keybinding help
:NvChadUpdate      " Update NvChad
:Telescope themes  " Theme picker
```

### Useful Neovim Commands

```vim
:checkhealth       " System check
:LspInfo           " LSP status
:messages          " View messages
:map <leader>      " See mappings
:verbose map <key> " Check key mapping
```

---

## Quick Start Checklist

### Day 1: Installation

```bash
# 1. Install Neovim
nvim --version  # Check >= 0.9.0

# 2. Backup old config
mv ~/.config/nvim ~/.config/nvim.backup

# 3. Install NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# 4. Launch (auto-installs plugins)
nvim
```

### Day 2: Basic Customization

```bash
# Create custom directory
mkdir -p ~/.config/nvim/lua/custom

# Create files
touch ~/.config/nvim/lua/custom/chadrc.lua
touch ~/.config/nvim/lua/custom/plugins.lua
touch ~/.config/nvim/lua/custom/mappings.lua
touch ~/.config/nvim/lua/custom/init.lua
```

**Minimal setup:**

```lua
-- chadrc.lua
local M = {}
M.ui = { theme = "onedark" }
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")
return M

-- plugins.lua
return {}

-- mappings.lua
local M = {}
M.general = {
  n = {
    ["<C-s>"] = { ":w<CR>", "Save" }
  }
}
return M

-- init.lua
vim.opt.relativenumber = true
```

### Day 3: Add First Plugin

```lua
-- plugins.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require("telescope").setup()
      _G.builtin = require("telescope.builtin")
    end,
  },
}

-- mappings.lua (add to existing M)
M.telescope = {
  n = {
    ["<leader>ff"] = {
      function() _G.builtin.find_files() end,
      "Find files"
    },
  },
}
```

Then run `:Lazy sync` in nvim.

---

## Summary: The _G Pattern

**Problem:** Loading plugins repeatedly is slow

```lua
-- BAD: Loads telescope module every time you press keys
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end)
```

**Solution:** Load once, reference many times

```
Flow with _G pattern:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. nvim starts
   ↓
2. Lazy.nvim loads plugins.lua
   ↓
3. Plugin config runs ONCE:
   ┌──────────────────────────────────┐
   │ config = function()              │
   │   require("telescope").setup()   │
   │   _G.builtin = require(...)      │ ← Stored in memory
   │ end                              │
   └──────────────────────────────────┘
   ↓
4. Keymaps load from mappings.lua
   ↓
5. You press <leader>ff
   ↓
6. Keymap function runs:
   ┌──────────────────────────────────┐
   │ function()                       │
   │   _G.builtin.find_files()        │ ← Uses stored reference
   │ end                              │     (no require() = fast)
   └──────────────────────────────────┘
```

**Implementation:**

```lua
-- STEP 1: In plugins.lua config
config = function()
  require("telescope").setup()
  _G.builtin = require("telescope.builtin")  -- Store globally
end

-- STEP 2: In mappings.lua
vim.keymap.set("n", "<leader>ff", function()
  _G.builtin.find_files()  -- Use stored reference
end)
```

**Why it works:**

```
Without _G:
  Press key → require() → Load module → Execute → Slow
  Press key → require() → Load module → Execute → Slow
  Press key → require() → Load module → Execute → Slow

With _G:
  Startup  → require() → Store in _G.builtin → Done
  Press key → _G.builtin → Execute → Fast
  Press key → _G.builtin → Execute → Fast
  Press key → _G.builtin → Execute → Fast
```

**Key points:**

1. Set `_G.name` in plugin's `config = function()`
2. Use `_G.name` in keymaps
3. Works across all config files
4. Plugin loaded only once
5. Fast and clean

**Common globals:**

|Plugin|Global|Usage|
|---|---|---|
|Telescope|`_G.builtin`|`_G.builtin.find_files()`|
|NvimTree|`_G.tree`|`_G.tree.toggle()`|
|LSP|`_G.lsp`|`_G.lsp.definition()`|
|Trouble|`_G.trouble`|`_G.trouble.toggle()`|

**Alternative (local variable - only works in same file):**

```lua
-- Only works in one file
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files()  -- Won't work in mappings.lua
end)
```


My Way 

init.lua is entry opint so 
make keybind.lua and plugin.lua require both now 

in plugin.lua require 
lazy Mackage manager 

```

require('lazy').setup(plugins, opt)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
    "nvim-tree/nvim-tree.lua",
    version = "*",  -- Add this!
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- Icons!
    config = function()
        require("nvim-tree").setup({
            view = { width = 30 }
        })
    end
},
{
    'nvim-telescope/telescope.nvim', 
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup()
        _G.builtin = require('telescope.builtin')  -- ← PUT HERE
    end
}

}
local opt = {} -- Fixed: was empty but wor

```

lazy have 2 parameter plugins and opts so we make touple of these two 

Plugin touple
in plugin touple we call our plugin and than gave then  _G.builtin = require(that module in plugin) 

but after requiring that module we have to map that module function in keybind when we press that keybind it call that function of the module 

example :-
Teliscope have find fine , recent file ect so each is a function inside module 
using function in keybinds 
```
vim.keymap.set('n', '<leader>ff', _G.builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', _G.builtin.live_grep, { desc = 'Live grep' })
```

Inbuild features like treetoggle is used directly in our keybinds 
