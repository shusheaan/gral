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
# Required: used by telescope, yazi, nvim plugins
brew install neovim fd ripgrep fzf bat yazi jq

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

Nerd Font is required for icons in nvim (nvim-web-devicons, lualine), yazi, and other TUI tools.

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
sudo pacman -S neovim fd ripgrep fzf bat yazi jq stylua taplo
# Then:
cd ~/GitHub/gral && ./install
```

## Dependencies Summary

| Tool | Purpose | Install |
|------|---------|---------|
| **neovim** ≥ 0.10 | Editor | `brew install neovim` |
| **fd** | File finder (telescope, yazi) | `brew install fd` |
| **ripgrep** (rg) | Content search (telescope live grep) | `brew install ripgrep` |
| **fzf** | Fuzzy finder (yazi keybindings, shell) | `brew install fzf` |
| **bat** | Syntax-highlighted preview (yazi, fzf) | `brew install bat` |
| **yazi** | Terminal file manager | `brew install yazi` |
| **node** | Required by basedpyright LSP | `brew install node` |
| **jq** | JSON formatter (conform.nvim) | `brew install jq` |
| **stylua** | Lua formatter (conform.nvim) | `brew install stylua` |
| **taplo** | TOML formatter (conform.nvim) | `brew install taplo` |
| **yamlfmt** | YAML formatter (conform.nvim) | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| **mypy** | Python type checker (nvim-lint) | `pip install mypy` |
| **rustup** | Rust toolchain (rustfmt, clippy, cargo) | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| **Nerd Font** | Icons in nvim, yazi, lualine | `brew install --cask font-jetbrains-mono-nerd-font` |

Auto-installed by mason.nvim (no manual install needed): basedpyright, ruff, lua_ls.

Auto-installed by rustaceanvim/mason: codelldb (Rust debugger).

## Neovim Tech Stack (2026)

| Component | Tool | Notes |
|-----------|------|-------|
| Plugin Manager | **lazy.nvim** | Lazy-loading, lock file, auto-deps |
| Completion | **blink.cmp v1** | Rust SIMD fuzzy matcher, built-in LSP/path/buffer/snippet sources |
| LSP Framework | **mason + nvim-lspconfig** | Auto-install and configure LSP servers |
| Rust | **rustaceanvim** | Enhanced rust-analyzer, clippy on save, inlay hints, DAP integration |
| Python Type Check | **basedpyright** | Strict type checking via LSP |
| Python Lint/Format | **ruff** (LSP) | Fast linter + formatter, replaces flake8/isort/black |
| Python Lint | **mypy** (via nvim-lint) | Additional type checking |
| Lua LSP | **lua_ls** | For editing nvim config |
| Fuzzy Finder | **telescope.nvim** | Floating window, live preview, fzf-native backend |
| File Manager | **yazi.nvim** | Rust-based terminal file manager, async previews, replaces lf |
| Git Commands | **vim-fugitive** | `:Git` commands |
| Git Diff/PR Review | **diffview.nvim** | Side-by-side diff, branch comparison, file history |
| Git Signs | **gitsigns.nvim** | Inline +/~/- markers, hunk navigation |
| Debugger | **nvim-dap + dap-ui** | Breakpoints, step-through, variables, call stack |
| Rust Debug | **codelldb** (via rustaceanvim) | LLDB-based Rust debugging |
| Python Debug | **debugpy** (via dap-python) | Python debugging |
| Formatting | **conform.nvim** | Auto-format on save (rustfmt, ruff, stylua) |
| Syntax Highlight | **nvim-treesitter** | AST-based highlighting, text objects |
| Colorscheme | **gruvbox.nvim** | Gruvbox dark — unified across nvim, VS Code, tmux, yazi, alacritty |
| Status Line | **lualine.nvim** | Git branch, diagnostics, file info |
| Key Hints | **which-key.nvim** | Shows available keybindings after leader press |
| CSV | **csv.vim** | Column alignment, sorting |
| Undo History | **undotree** | Visual undo tree |

## Keybindings

Leader key: `<Space>`

### Navigation & Windows

| Key | Action |
|-----|--------|
| `<leader>q` | Quit |
| `<leader>/` | Toggle search highlight |
| `<leader>[ ]` | Page up / down |
| `<leader>s` / `<leader>a` | Horizontal / vertical split |
| `<leader>hjkl` | Move to window |
| `<leader>HJKL` | Move window position |
| `<leader>= - , .` | Resize window |

### Find (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fo` | Recent files |
| `<leader>fr` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fg` | Git files |
| `<leader>fs` | LSP symbols |
| `<leader>fd` | Diagnostics |
| `<leader>fw` | Grep word under cursor |
| `<leader>fc` | Git commits |

### Code (LSP)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `gk` | Hover documentation |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Line diagnostics |
| `[g` / `]g` | Previous / next diagnostic |

### Git

| Key | Action |
|-----|--------|
| `gs` | Git status (fugitive) |
| `gh` / `gl` | Diffget ours / theirs |
| `<leader>gd` | Diffview (working changes) |
| `<leader>gD` | Diffview vs main (PR review) |
| `<leader>gh` | File git history |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gb` | Blame line |
| `]h` / `[h` | Next / previous hunk |

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

### File Manager & Misc

| Key | Action |
|-----|--------|
| `<leader>f` | Yazi (current file) |
| `<leader>F` | Yazi (cwd) |
| `<leader>u` | Undotree |
| `<leader>le/ld/lt/li` | Rust log macros (error/debug/trace/info) |

## Directory Structure

```
gral/
├── nvim/                    # Neovim config (Lua)
│   ├── init.lua
│   └── lua/
│       ├── config/          # Core: options, keymaps, autocmds, lazy bootstrap
│       └── plugins/         # Plugin specs (one file per concern)
├── yazi/                    # Yazi file manager config
│   ├── yazi.toml            # Settings (migrated from lfrc)
│   ├── keymap.toml          # Custom keybindings
│   └── theme.toml           # Gruvbox theme
├── vimrc                    # Minimal Vim fallback (no plugins)
├── mac/                     # macOS-specific configs
│   ├── install              # macOS symlink script
│   └── vimrc                # macOS Vim fallback
├── install                  # Linux symlink script
├── lfrc                     # lf config (legacy)
├── pv.sh                    # lf previewer (legacy)
├── tmux.conf
├── zshrc
└── ...
```
