# gral

Dotfiles for macOS and Arch Linux. Configs are symlinked to `$HOME` via the `install` scripts.

## From-Zero Setup (macOS)

### 1. Clone and bootstrap

```bash
# Install Xcode Command Line Tools + Homebrew + core packages + oh-my-zsh
git clone https://github.com/<your-user>/gral.git ~/GitHub/gral
cd ~/GitHub/gral
./mac/dependencies.sh
```

### 2. Install CLI tools needed by Neovim

```bash
# Required: used by telescope, lf, yazi, nvim plugins
brew install neovim fd ripgrep fzf bat lf yazi jq eza

# Node.js (required by some LSPs, e.g. basedpyright)
brew install node

# Formatters & linters (used by conform.nvim and nvim-lint)
brew install stylua taplo           # Lua, TOML formatters
go install github.com/google/yamlfmt/cmd/yamlfmt@latest  # YAML formatter (needs Go)
pip install mypy                    # Python type checker (nvim-lint)
# rustfmt and clippy come with rustup
# ruff and basedpyright are auto-installed by mason.nvim
```

### 3. Install Rust toolchain

```bash
# Install rustup + stable toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Or use the full Rust dependencies script:
./mac/rust_dep.sh
# Installs: stable/nightly/beta toolchains, rustfmt, clippy, rust-src,
# rust-analyzer, cross-compilation targets, cargo tools (cargo-edit,
# cargo-watch, cargo-nextest, cargo-audit, cargo-deny, bacon, sccache, just)
```

### 4. Install a Nerd Font

Nerd Font is required for icons in nvim (nvim-web-devicons, lualine) and other TUI tools.

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

Then set it in your terminal:

- **VSCode terminal**: Settings → `terminal.integrated.fontFamily` → `"JetBrainsMono Nerd Font"`
- **macOS Terminal.app**: Preferences → Profiles → Text → Font → `JetBrainsMono Nerd Font Mono`
- **Alacritty**: set `font.normal.family: "JetBrainsMono Nerd Font"` in alacritty.yml (already configured)
- **iTerm2**: Profiles → Text → Font → `JetBrainsMono Nerd Font`

### 5. Symlink configs

```bash
cd ~/GitHub/gral
./mac/install
```

This creates symlinks for: zshrc, tmux.conf, vimrc, nvim config directory, yazi config, workmux config, lf config, custom zsh theme.

### 6. Open Neovim

On first launch, lazy.nvim auto-downloads all plugins, mason.nvim installs LSP servers (basedpyright, ruff, lua_ls), and treesitter installs parsers. Just run `nvim` and wait.

## From-Zero Setup (Linux / Arch)

```bash
# Install equivalents via pacman/yay
sudo pacman -S neovim fd ripgrep fzf bat lf yazi jq eza stylua taplo

# Clone and install
git clone https://github.com/<your-user>/gral.git ~/GitHub/gral
cd ~/GitHub/gral
./install
```

The Linux install script also symlinks: xinitrc, xmodmap, i3, polybar, neofetch, alacritty configs.

## From-Zero Setup (Cloud GPU — RunPod)

```bash
# Build and push the Docker image (from local machine)
cd ~/GitHub/gral/pod
docker build -t <your-user>/gral-pod .
docker push <your-user>/gral-pod

# On the pod instance
./env.sh && zsh && ./install
```

The pod Dockerfile is based on `runpod/pytorch` with CUDA, and includes: neovim, tmux, zsh, ripgrep, fd, fzf, bat, Rust toolchain, PyTorch Geometric.

## Dependencies Summary

| Tool | Purpose | Install |
|------|---------|---------|
| **neovim** >= 0.11 | Editor | `brew install neovim` |
| **fd** | File finder (telescope, yazi, lf) | `brew install fd` |
| **ripgrep** (rg) | Content search (telescope live grep) | `brew install ripgrep` |
| **fzf** | Fuzzy finder (yazi, lf, shell) | `brew install fzf` |
| **bat** | Syntax-highlighted preview (yazi, lf, fzf) | `brew install bat` |
| **eza** | Modern ls (yazi preview, lf preview) | `brew install eza` |
| **yazi** | Terminal file manager (modern) | `brew install yazi` |
| **lf** | Terminal file manager (legacy, still in nvim) | `brew install lf` |
| **node** | Required by basedpyright LSP | `brew install node` |
| **jq** | JSON formatter (conform.nvim) | `brew install jq` |
| **stylua** | Lua formatter (conform.nvim) | `brew install stylua` |
| **taplo** | TOML formatter (conform.nvim) | `brew install taplo` |
| **yamlfmt** | YAML formatter (conform.nvim) | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| **mypy** | Python type checker (nvim-lint) | `pip install mypy` |
| **rustup** | Rust toolchain (rustfmt, clippy, rust-analyzer, cargo) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| **Nerd Font** | Icons in nvim, lualine | `brew install --cask font-jetbrains-mono-nerd-font` |

Auto-installed by mason.nvim (no manual install needed): basedpyright, ruff, lua_ls.

Auto-installed by rustaceanvim/mason: codelldb (Rust debugger).

## Neovim Tech Stack

| Component | Tool | Notes |
|-----------|------|-------|
| Plugin Manager | **lazy.nvim** | Lazy-loading, lock file, auto-deps |
| Completion | **blink.cmp v1** | Rust SIMD fuzzy matcher, built-in LSP/path/buffer/snippet sources |
| LSP Framework | **mason + nvim-lspconfig** | Auto-install and configure LSP servers (nvim 0.11 native API) |
| Rust | **rustaceanvim v6** | Enhanced rust-analyzer, clippy on save, inlay hints, DAP integration |
| Python Type Check | **basedpyright** | Standard type checking via LSP |
| Python Lint/Format | **ruff** (LSP) | Fast linter + formatter, replaces flake8/isort/black |
| Python Lint | **mypy** (via nvim-lint) | Additional type checking |
| Lua LSP | **lua_ls** | For editing nvim config |
| Fuzzy Finder | **telescope.nvim** | Floating window, live preview, fzf-native backend |
| File Manager | **lf** (native lua) | Floating terminal in nvim, no plugin dependency |
| AI Completion | **copilot.lua** | GitHub Copilot ghost text, Tab to accept |
| Git Commands | **vim-fugitive** | `:Git` commands |
| Git Diff/PR Review | **diffview.nvim** | Side-by-side diff, branch comparison, file history |
| Git Signs | **gitsigns.nvim** | Inline +/~/- markers, hunk navigation |
| Debugger | **nvim-dap + dap-ui** | Breakpoints, step-through, variables, call stack |
| Rust Debug | **codelldb** (via rustaceanvim) | LLDB-based Rust debugging |
| Python Debug | **debugpy** (via dap-python) | Python debugging |
| Formatting | **conform.nvim** | Auto-format on save (rustfmt, ruff, stylua, jq, taplo, yamlfmt) |
| Linting | **nvim-lint** | Async linting (mypy for Python) |
| Syntax Highlight | **nvim-treesitter** | AST-based highlighting, text objects, incremental selection |
| Colorscheme | **gruvbox.nvim** | Gruvbox dark -- unified across nvim, tmux, alacritty |
| Status Line | **lualine.nvim** | Git branch, diagnostics, LSP status, file info |
| Key Hints | **which-key.nvim** | Shows available keybindings after leader press (0.5s delay) |
| CSV | **csv.vim** | Column alignment, auto-sort, auto-arrange |
| Undo History | **undotree** | Visual undo tree |

## Neovim LSP Features

| Feature | Status | How |
|---------|--------|-----|
| **Inlay hints** (type annotations) | Enabled | Auto-enabled on LspAttach for supported servers |
| **Semantic highlighting** | Enabled | Via rust-analyzer/LSP semantic tokens + treesitter |
| **Go to definition** | `gd` | `vim.lsp.buf.definition` |
| **Go to type definition** | `gD` | `vim.lsp.buf.type_definition` |
| **Go to implementation** | `gi` | `vim.lsp.buf.implementation` |
| **Find references** | `gr` | Telescope UI |
| **Hover documentation** | `gk` | `vim.lsp.buf.hover` |
| **Rename symbol** | `<Space>cr` | `vim.lsp.buf.rename` |
| **Code actions** | `<Space>ca` | `vim.lsp.buf.code_action` |
| **Format buffer** | `<Space>cf` | `vim.lsp.buf.format` (also auto-format on save via conform) |
| **Diagnostics** | Virtual text | `"●"` prefix, rounded float borders, severity-sorted |
| **LSP health check** | `<Space>ci` | Shows attached LSP clients for current buffer |

### Rust-Analyzer Settings

```lua
check.command = "clippy"                    -- Use clippy instead of cargo check
cargo.allFeatures = true                    -- Enable all Cargo features
inlayHints.typeHints = true                 -- Show variable types inline
inlayHints.parameterHints = true            -- Show parameter names at call sites
inlayHints.chainingHints = true             -- Show types in method chains
inlayHints.closingBraceHints = true         -- Show closing brace hints (min 10 lines)
inlayHints.closureReturnTypeHints = "always"-- Always show closure return types
inlayHints.maxLength = 100                  -- Cap hint length
```

## Core Workflow

The entire editing loop revolves around four keys (all prefixed with `<Space>` leader):

```
  Space o     open LF file manager -> browse/select file
     |
  Space f     fuzzy find any file by name
     |
  Space Space jump back to a recent file
     |
  gd          jump to definition
  gD          jump to type definition
  gi          jump to implementation
  Ctrl-o      jump back
  Ctrl-i      jump forward
```

**Typical session:**
1. `Space o` -- open LF, visually browse the project, pick a file
2. `gd` on a symbol -- jump to its definition
3. `Ctrl-o` -- jump back to where you were
4. `Space f` -- quickly open another file by name
5. `Space Space` -- flip back to the file you just left
6. `Space p` -- grep the whole project for a string
7. `gr` -- find all references of the symbol under cursor

Everything fans out from **open -> find -> recent -> jump -> jump back**.

## Keybindings

Leader key: `<Space>` (hold 0.5s to see all keybindings via which-key)

### Find & Open

| Key | Action |
|-----|--------|
| `<leader>o` | **LF file manager** (current file dir) -- browse, preview, select |
| `<leader>O` | LF file manager (project root) |
| `<leader>f` | **Find files** by name (telescope, fd) |
| `<leader><leader>` | **Recent files** (oldfiles, cwd only) |
| `<leader>p` | **Project grep** -- search any text across all files |
| `<leader>w` | Grep word under cursor across project |

### Jump (LSP)

| Key | Action |
|-----|--------|
| `gd` | **Go to definition** |
| `gD` | **Go to type definition** |
| `gi` | **Go to implementation** |
| `gr` | **Find all references** (telescope UI) |
| `gk` | Hover documentation |
| `Ctrl+o` | **Jump back** (after gd, gr, etc.) |
| `Ctrl+i` | **Jump forward** |
| `[g` / `]g` | Previous / next diagnostic |

### Code Actions (LSP)

| Key | Action |
|-----|--------|
| `<leader>cr` | Rename symbol (across project) |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Line diagnostics (floating window) |
| `<leader>ci` | LSP health check (see which servers are running) |

### Windows & Navigation

| Key | Action |
|-----|--------|
| `<leader>q` | Quit |
| `<leader>/` | Toggle search highlight |
| `<leader>[ ]` | Page up / down |
| `<leader>s` / `<leader>a` | Horizontal / vertical split |
| `<leader>hjkl` | Move to window |
| `<leader>HJKL` | Move window position |
| `<leader>= - , .` | Resize window |

### Git

| Key | Action |
|-----|--------|
| `gs` | Git status (fugitive) -- `s` to stage, `cc` to commit |
| `gh` / `gl` | Diffget ours / theirs (merge conflicts) |
| `<leader>gd` | Diffview (working changes) |
| `<leader>gD` | Diffview vs main (PR review) |
| `<leader>gh` | File git history |
| `<leader>gH` | Repo git history |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Blame line |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gx` | Close diffview |

### Debug (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | DAP REPL |
| `<leader>dl` | Run last |
| `<leader>dx` | Terminate |

### Completion & Copilot

| Key | Action |
|-----|--------|
| `Tab` | Accept Copilot suggestion -> next completion -> snippet forward |
| `S-Tab` | Previous completion / snippet backward |
| `CR` | Accept completion |
| `Ctrl+Space` | Show/toggle completion docs |
| `Ctrl+u` / `Ctrl+d` | Scroll documentation up / down |
| `Ctrl+e` | Cancel completion |
| `Alt+]` / `Alt+[` | Next / previous Copilot suggestion |
| `Ctrl+]` | Dismiss Copilot suggestion |

### Treesitter Selection

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Init / expand selection (node incremental) |
| `Backspace` | Shrink selection (node decremental) |

### Misc

| Key | Action |
|-----|--------|
| `<leader>u` | Undotree |
| `<leader>le/ld/lt/li` | Rust log macros (error/debug/trace/info) |

### LF File Manager (inside lf)

| Key | Action |
|-----|--------|
| `q` / `Esc` | Quit |
| `J` / `K` | Jump 10 lines |
| `{` / `}` | Half page scroll |
| `F` | FZF directory jump |
| `R` | Ripgrep search |
| `gp/gs/gl` | Git pull/status/log |

### Yazi File Manager (standalone)

| Key | Action |
|-----|--------|
| `q` / `Esc` | Quit |
| `J` / `K` | Jump 10 lines |
| `{` / `}` | Half page scroll |
| `a` | Rename (cursor at end) |
| `D` | Trash selected files |
| `!` | Open shell |
| `x` | Execute file |
| `F` | FZF directory jump |
| `R` | Ripgrep search |
| `gp/gs/gl` | Git pull/status/log |

### tmux

Prefix: **None** (no prefix key -- all bindings are direct)

| Key | Action |
|-----|--------|
| `C-n` | New window |
| `C-t` | Split pane (horizontal) |
| `C-h` | Previous window |
| `C-l` | Next window |
| `Escape` | Enter copy mode (vim keys) |

### Shell (zsh)

**tmux:**

| Alias | Command |
|-------|---------|
| `tls` | `tmux ls` |
| `tnew <name>` | `tmux new -s` |
| `tatt <name>` | `tmux attach -t` |
| `tdet <name>` | `tmux detach -t` |
| `ttk` | `tmux kill-server` |

**workmux:**

| Alias | Command |
|-------|---------|
| `wls` | `workmux ls` |
| `wadd` | `workmux add` |
| `wopen` | `workmux open` |
| `wrm` | `workmux rm --keep-branch` |
| `wdb` | `workmux dashboard` |
| `wmerge` | `workmux merge` |

**cargo:**

| Alias | Command |
|-------|---------|
| `ct` | `cargo test -- --nocapture` |
| `cb` | `cargo build && rust-gdb` |

**misc:**

| Alias | Command |
|-------|---------|
| `lf` | `lfcd` (lf with auto-cd on exit) |
| `jl` | `julia --project=.` |
| `refresh` | `source ~/.zshrc` |

## Nvim Options

| Option | Value | Notes |
|--------|-------|-------|
| Tab width | 4 spaces | `tabstop=4 shiftwidth=4 expandtab` |
| Line numbers | Relative | `number + relativenumber` |
| Cursor line | Insert mode only | Autocmd toggles on InsertEnter/Leave |
| Sign column | Always visible | For diagnostics, git signs |
| Command height | 0 | Hidden cmdline |
| Scroll offset | 8 lines | `scrolloff=8` |
| Clipboard | System | `unnamedplus` |
| Undo | Persistent | `~/.vim/undodir` |
| Fold | Indent-based | Level 99 (all open by default) |
| Leader timeout | 10s | `timeoutlen=10000` |
| Update time | 300ms | For CursorHold events |

## Colorscheme

**Gruvbox dark** is used consistently across all tools:

| Tool | Config |
|------|--------|
| Neovim | `gruvbox.nvim` (transparent=false, SignColumn bg=NONE) |
| tmux | Custom gruvbox palette (#1d2021 bg, #ebdbb2 fg) |
| Alacritty | Gruvbox palette (#282828 bg) |
| Yazi | Custom gruvbox theme (`yazi/theme.toml`) |
| Lualine | `theme = "gruvbox"` |

## Terminal Font Config

Font is **JetBrainsMono Nerd Font**, configured per terminal emulator:

| Terminal | Font Size | Letter Spacing | Line Spacing |
|----------|-----------|---------------|-------------|
| Alacritty | 7.5 | 0 (`offset.x`) | 2 (`offset.y`) |
| VS Code | `terminal.integrated.fontSize` | `terminal.integrated.letterSpacing` | `terminal.integrated.lineHeight` |
| iTerm2 | Profiles → Text | Character Spacing | Line Spacing |

Neovim (terminal) inherits font settings from the terminal emulator. `vim.opt.linespace` only works in GUI clients (Neovide, etc.).

## Workmux

[Workmux](https://github.com/pommee/workmux) is a tmux workspace manager for git worktree workflows. Config at `workmux/config.yaml`.

- Mode: window (creates windows within the current tmux session)
- Default pane layout: opens a Claude Code agent (`claude --permission-mode acceptEdits`)
- Aliases: `wls`, `wadd`, `wopen`, `wrm`, `wdb`, `wmerge`

## Directory Structure

```
gral/
├── nvim/                    # Neovim config (Lua)
│   ├── init.lua             # Entry point: leader key, lazy.nvim bootstrap
│   └── lua/
│       ├── config/          # Core settings
│       │   ├── lazy.lua     # Lazy.nvim bootstrap (stable branch, gruvbox default)
│       │   ├── options.lua  # Editor options (tabs, numbers, diagnostics)
│       │   ├── keymaps.lua  # Leader-based keybindings
│       │   └── autocmds.lua # LSP attach, cursorline, CSV formatting
│       └── plugins/         # Plugin specs (one file per concern)
│           ├── colorscheme.lua  # Gruvbox
│           ├── completion.lua   # blink.cmp
│           ├── copilot.lua      # GitHub Copilot
│           ├── dap.lua          # Debug Adapter Protocol
│           ├── format-lint.lua  # conform.nvim + nvim-lint
│           ├── git.lua          # fugitive, gitsigns, diffview
│           ├── lf.lua           # LF file manager (native lua integration)
│           ├── lsp.lua          # mason, lspconfig, rustaceanvim
│           ├── telescope.lua    # Fuzzy finder
│           ├── treesitter.lua   # Syntax highlighting
│           └── ui.lua           # lualine, which-key, undotree, csv, devicons
├── yazi/                    # Yazi file manager config
│   ├── yazi.toml            # Manager settings, openers, MIME rules
│   ├── keymap.toml          # Custom keybindings (lf-style)
│   └── theme.toml           # Gruvbox color theme
├── workmux/                 # Workmux (tmux workspace manager)
│   └── config.yaml
├── mac/                     # macOS-specific
│   ├── install              # macOS symlink script
│   ├── dependencies.sh      # Homebrew + oh-my-zsh bootstrap
│   ├── rust_dep.sh          # Rust toolchain + cargo tools
│   ├── tmux.conf            # macOS tmux variant
│   ├── zshrc                # macOS zshrc
│   ├── vimrc                # macOS Vim fallback
│   ├── lfrc                 # macOS lf config
│   ├── pv.sh                # macOS lf previewer
│   ├── notes.md             # Setup notes
│   └── custom.zsh-theme     # Custom zsh prompt theme
├── pod/                     # RunPod (cloud GPU) configuration
│   ├── dockerfile           # Docker image (PyTorch + CUDA + Rust + dev tools)
│   ├── env.sh               # Environment setup script
│   ├── install              # Pod symlink script
│   └── notes.md             # Pod setup instructions
├── backups/                 # Old configs and reference files
│   ├── misc/                # xbindkeys, compton, etc.
│   └── remap/               # HHKB, Karabiner, xmodmap configs
├── alacritty.yml            # Alacritty terminal (gruvbox, JetBrains Mono, tmux auto-start)
├── tmux.conf                # tmux (no prefix, gruvbox, vim copy mode)
├── zshrc                    # Zsh (oh-my-zsh, vi-mode, aliases, env vars)
├── vimrc                    # Minimal Vim fallback (no plugins)
├── install                  # Linux symlink script (includes i3, polybar, alacritty)
├── i3.conf                  # i3 window manager (Linux)
├── polybar.conf             # Polybar status bar (Linux)
├── neofetch.conf            # Neofetch system info (Linux)
├── xinitrc                  # X11 init (Linux)
├── xmodmap.conf             # Key remapping (Linux)
├── xmodmap.sh               # Key remapping script (Linux)
├── lfrc                     # lf config (Linux)
├── lf.conf                  # lf config (symlinked as lfrc)
├── pv.sh                    # lf previewer script (macOS)
├── lfpv.sh                  # lf previewer script (Linux)
├── custom.zsh-theme         # Zsh prompt theme
└── SOP.sh                   # Standard operating procedure script
```

## Zsh Config

- **Framework**: oh-my-zsh with `sammy` theme
- **Plugins**: git, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting
- **Mode**: vi-mode (`bindkey -v`) with vim keys in tab-complete menu
- **TERM**: `xterm-256color` (for colorscheme in tmux)
- **History**: 10000 entries
- **Auto-tmux**: On SSH login, auto-attaches to `work` session

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `GUROBI_HOME` | Gurobi optimizer |
| `LIBTORCH` | PyTorch C++ bindings (tch-rs) |
| `INFLUXDB_TOKEN` | InfluxDB access |
| `NVM_DIR` | Node Version Manager |
| `BUN_INSTALL` | Bun JavaScript runtime |
| `RUST_BACKTRACE=full` | Full Rust backtraces |

## tmux Config

- **Prefix**: None (all bindings are direct, no prefix key)
- **Mouse**: Enabled
- **Copy mode**: Vim keys, `Escape` to enter
- **Window numbering**: Starts at 1
- **Status bar**: Gruvbox colors, session name (left), date-time (right; macOS variant has no clock)
- **Terminal**: `xterm-256color` with RGB override
