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
# Required: used by telescope, lf, nvim plugins
brew install neovim fd ripgrep fzf bat lf jq

# Node.js (required by some LSPs, e.g. basedpyright)
brew install node
# Currently using Homebrew node (no nvm). If you need nvm:
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Formatters & linters (used by conform.nvim and nvim-lint)
brew install stylua taplo           # Lua, TOML formatters
go install github.com/google/yamlfmt/cmd/yamlfmt@latest  # YAML formatter (needs Go)
pip install mypy                    # Python type checker (nvim-lint)
# rustfmt and clippy come with rustup
# ruff and basedpyright are auto-installed by mason.nvim
```

### 3. Install a Nerd Font

Nerd Font is required for icons in nvim (nvim-web-devicons, lualine) and other TUI tools.

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

Then set it in your terminal:

- **VSCode terminal**: Settings → `terminal.integrated.fontFamily` → `"JetBrainsMono Nerd Font"`
- **macOS Terminal.app**: Preferences → Profiles → Text → Font → `JetBrainsMono Nerd Font Mono`
- **Alacritty**: set `font.normal.family: "JetBrainsMono Nerd Font"` in alacritty.yml
- **iTerm2**: Profiles → Text → Font → `JetBrainsMono Nerd Font`

### 4. Symlink configs

```bash
cd ~/GitHub/gral
# macOS
./mac/install
# Linux
./install
```

### 5. Open Neovim

On first launch, lazy.nvim auto-downloads all plugins, mason.nvim installs LSP servers (basedpyright, ruff, lua_ls), and treesitter installs parsers. Just run `nvim` and wait.

### From-Zero Setup (Linux / Arch)

```bash
# Install equivalents via pacman/yay
sudo pacman -S neovim fd ripgrep fzf bat lf jq stylua taplo
# Then:
cd ~/GitHub/gral && ./install
```

## Dependencies Summary

| Tool | Purpose | Install |
|------|---------|---------|
| **neovim** ≥ 0.11 | Editor | `brew install neovim` |
| **fd** | File finder (telescope, lf) | `brew install fd` |
| **ripgrep** (rg) | Content search (telescope live grep) | `brew install ripgrep` |
| **fzf** | Fuzzy finder (lf keybindings, shell) | `brew install fzf` |
| **bat** | Syntax-highlighted preview (lf, fzf) | `brew install bat` |
| **lf** | Terminal file manager | `brew install lf` |
| **node** | Required by basedpyright LSP | `brew install node` |
| **jq** | JSON formatter (conform.nvim) | `brew install jq` |
| **stylua** | Lua formatter (conform.nvim) | `brew install stylua` |
| **taplo** | TOML formatter (conform.nvim) | `brew install taplo` |
| **yamlfmt** | YAML formatter (conform.nvim) | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| **mypy** | Python type checker (nvim-lint) | `pip install mypy` |
| **rustup** | Rust toolchain (rustfmt, clippy, cargo) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| **Nerd Font** | Icons in nvim, lualine | `brew install --cask font-jetbrains-mono-nerd-font` |

Auto-installed by mason.nvim (no manual install needed): basedpyright, ruff, lua_ls.

Auto-installed by rustaceanvim/mason: codelldb (Rust debugger).

## Neovim Tech Stack (2026)

| Component | Tool | Notes |
|-----------|------|-------|
| Plugin Manager | **lazy.nvim** | Lazy-loading, lock file, auto-deps |
| Completion | **blink.cmp v1** | Rust SIMD fuzzy matcher, built-in LSP/path/buffer/snippet sources |
| LSP Framework | **mason + nvim-lspconfig** | Auto-install and configure LSP servers (nvim 0.11 native API) |
| Rust | **rustaceanvim** | Enhanced rust-analyzer, clippy on save, inlay hints, DAP integration |
| Python Type Check | **basedpyright** | Strict type checking via LSP |
| Python Lint/Format | **ruff** (LSP) | Fast linter + formatter, replaces flake8/isort/black |
| Python Lint | **mypy** (via nvim-lint) | Additional type checking |
| Lua LSP | **lua_ls** | For editing nvim config |
| Fuzzy Finder | **telescope.nvim** | Floating window, live preview, fzf-native backend |
| File Manager | **lf** (native lua) | Floating terminal, no plugin dependency |
| AI Completion | **copilot.lua** | GitHub Copilot ghost text, Tab to accept |
| Git Commands | **vim-fugitive** | `:Git` commands |
| Git Diff/PR Review | **diffview.nvim** | Side-by-side diff, branch comparison, file history |
| Git Signs | **gitsigns.nvim** | Inline +/~/- markers, hunk navigation |
| Debugger | **nvim-dap + dap-ui** | Breakpoints, step-through, variables, call stack |
| Rust Debug | **codelldb** (via rustaceanvim) | LLDB-based Rust debugging |
| Python Debug | **debugpy** (via dap-python) | Python debugging |
| Formatting | **conform.nvim** | Auto-format on save (rustfmt, ruff, stylua) |
| Syntax Highlight | **nvim-treesitter** | AST-based highlighting, text objects |
| Colorscheme | **gruvbox.nvim** | Gruvbox dark — unified across nvim, VS Code, tmux, alacritty |
| Status Line | **lualine.nvim** | Git branch, diagnostics, file info |
| Key Hints | **which-key.nvim** | Shows available keybindings after leader press |
| CSV | **csv.vim** | Column alignment, sorting |
| Undo History | **undotree** | Visual undo tree |

## Keybindings

Leader key: `<Space>` (hold 0.5s to see all keybindings via which-key)

### Find & Search

| Key | Action |
|-----|--------|
| `<leader>f` | Find files (frecency — recent/frequent first) |
| `<leader><Tab>` | Recent files |
| `<leader>p` | Project search — grep any text across all files |
| `<leader>w` | Grep word under cursor across project |
| `<leader>o` | LF file manager (current file dir) |
| `<leader>O` | LF file manager (project root) |

### Code Navigation (LSP)

| Key | Action |
|-----|--------|
| `gd` | **Smart jump** — definition → type → implementation (one key does all) |
| `gr` | **Find all references** — telescope UI showing every usage in project |
| `gk` | Hover documentation |
| `<leader>cr` | Rename symbol (across project) |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Line diagnostics |
| `[g` / `]g` | Previous / next diagnostic |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward (after gd, gr, etc.) |

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
| `gs` | Git status (fugitive) — `s` to stage, `cc` to commit |
| `gh` / `gl` | Diffget ours / theirs (merge conflicts) |
| `<leader>gd` | Diffview (working changes) |
| `<leader>gD` | Diffview vs main (PR review) |
| `<leader>gh` | File git history |
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
| `<leader>dx` | Terminate |

### Misc

| Key | Action |
|-----|--------|
| `<leader>u` | Undotree |
| `<leader>le/ld/lt/li` | Rust log macros (error/debug/trace/info) |
| `Tab` | Accept Copilot suggestion / next completion |
| `Alt+]` / `Alt+[` | Next / previous Copilot suggestion |

### LF File Manager (inside lf)

| Key | Action |
|-----|--------|
| `q` / `Esc` | Quit |
| `J` / `K` | Jump 10 lines |
| `{` / `}` | Half page scroll |
| `F` | FZF directory jump |
| `R` | Ripgrep search |
| `gp/gs/gl` | Git pull/status/log |

### tmux

| Key | Action |
|-----|--------|
| `C-n` | New window |
| `C-t` | Split pane |
| `C-h` | Previous window |
| `C-l` | Next window |

### Shell (zsh)

| Alias | Command |
|-------|---------|
| `tls` | tmux ls |
| `tnew <name>` | tmux new -s |
| `tatt <name>` | tmux attach -t |
| `ttk` | tmux kill-server |

## Directory Structure

```
gral/
├── nvim/                    # Neovim config (Lua)
│   ├── init.lua
│   └── lua/
│       ├── config/          # Core: options, keymaps, autocmds, lazy bootstrap
│       └── plugins/         # Plugin specs (one file per concern)
├── lfrc                     # lf file manager config
├── mac/lfrc                 # lf config (macOS)
├── pv.sh                    # lf previewer script
├── vimrc                    # Minimal Vim fallback (no plugins)
├── mac/                     # macOS-specific configs
│   ├── install              # macOS symlink script
│   └── vimrc                # macOS Vim fallback
├── install                  # Linux symlink script
├── tmux.conf
├── zshrc
└── ...
```
