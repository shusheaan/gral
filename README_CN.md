# gral

macOS 和 Arch Linux 的 dotfiles 配置文件。所有配置通过 `install` 脚本软链接到 `$HOME`。

## 从零开始搭建 (macOS)

### 1. 克隆并初始化

```bash
# 安装 Xcode 命令行工具 + Homebrew + 核心包 + oh-my-zsh
git clone https://github.com/<your-user>/gral.git ~/GitHub/gral
cd ~/GitHub/gral
./mac/dependencies.sh
```

### 2. 安装 Neovim 所需的 CLI 工具

```bash
# 必需：用于 telescope、lf、yazi、nvim 插件
brew install neovim fd ripgrep fzf bat lf yazi jq eza

# Node.js（部分 LSP 依赖，如 basedpyright）
brew install node

# 格式化工具和 Linter（用于 conform.nvim 和 nvim-lint）
brew install stylua taplo           # Lua、TOML 格式化
go install github.com/google/yamlfmt/cmd/yamlfmt@latest  # YAML 格式化（需要 Go）
pip install mypy                    # Python 类型检查（nvim-lint）
# rustfmt 和 clippy 随 rustup 安装
# ruff 和 basedpyright 由 mason.nvim 自动安装
```

### 3. 安装 Rust 工具链

```bash
# 安装 rustup + stable 工具链
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 或使用完整的 Rust 依赖脚本：
./mac/rust_dep.sh
# 安装内容：stable/nightly/beta 工具链、rustfmt、clippy、rust-src、
# rust-analyzer、交叉编译目标、cargo 工具（cargo-edit、
# cargo-watch、cargo-nextest、cargo-audit、cargo-deny、bacon、sccache、just）
```

### 4. 安装 Nerd Font

Nerd Font 是 nvim 图标（nvim-web-devicons、lualine）和其他 TUI 工具所必需的。

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

然后在终端中设置：

- **VSCode 终端**: 设置 → `terminal.integrated.fontFamily` → `"JetBrainsMono Nerd Font"`
- **macOS Terminal.app**: 偏好设置 → 描述文件 → 文本 → 字体 → `JetBrainsMono Nerd Font Mono`
- **Alacritty**: 在 alacritty.yml 中设置 `font.normal.family: "JetBrainsMono Nerd Font"`（已配置）
- **iTerm2**: 描述文件 → 文本 → 字体 → `JetBrainsMono Nerd Font`

### 5. 建立软链接

```bash
cd ~/GitHub/gral
./mac/install
```

创建以下软链接：zshrc、tmux.conf、vimrc、nvim 配置目录、yazi 配置、workmux 配置、lf 配置、自定义 zsh 主题。

### 6. 打开 Neovim

首次启动时，lazy.nvim 会自动下载所有插件，mason.nvim 安装 LSP 服务器（basedpyright、ruff、lua_ls），treesitter 安装语法解析器。直接运行 `nvim` 等待即可。

## 从零开始搭建 (Linux / Arch)

```bash
# 通过 pacman/yay 安装等效包
sudo pacman -S neovim fd ripgrep fzf bat lf yazi jq eza stylua taplo

# 克隆并安装
git clone https://github.com/<your-user>/gral.git ~/GitHub/gral
cd ~/GitHub/gral
./install
```

Linux 安装脚本还会软链接：xinitrc、xmodmap、i3、polybar、neofetch、alacritty 配置。

## 从零开始搭建 (云 GPU — RunPod)

```bash
# 构建并推送 Docker 镜像（在本地机器上）
cd ~/GitHub/gral/pod
docker build -t <your-user>/gral-pod .
docker push <your-user>/gral-pod

# 在 Pod 实例上
./env.sh && zsh && ./install
```

Pod 的 Dockerfile 基于 `runpod/pytorch`（含 CUDA），包含：neovim、tmux、zsh、ripgrep、fd、fzf、bat、Rust 工具链、PyTorch Geometric。

## 依赖一览

| 工具 | 用途 | 安装方式 |
|------|------|----------|
| **neovim** >= 0.11 | 编辑器 | `brew install neovim` |
| **fd** | 文件查找（telescope、yazi、lf） | `brew install fd` |
| **ripgrep** (rg) | 内容搜索（telescope live grep） | `brew install ripgrep` |
| **fzf** | 模糊查找（yazi、lf、shell） | `brew install fzf` |
| **bat** | 语法高亮预览（yazi、lf、fzf） | `brew install bat` |
| **eza** | 现代 ls（yazi 预览、lf 预览） | `brew install eza` |
| **yazi** | 终端文件管理器（现代） | `brew install yazi` |
| **lf** | 终端文件管理器（旧版，仍在 nvim 中使用） | `brew install lf` |
| **node** | basedpyright LSP 依赖 | `brew install node` |
| **jq** | JSON 格式化（conform.nvim） | `brew install jq` |
| **stylua** | Lua 格式化（conform.nvim） | `brew install stylua` |
| **taplo** | TOML 格式化（conform.nvim） | `brew install taplo` |
| **yamlfmt** | YAML 格式化（conform.nvim） | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| **mypy** | Python 类型检查（nvim-lint） | `pip install mypy` |
| **rustup** | Rust 工具链（rustfmt、clippy、rust-analyzer、cargo） | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| **Nerd Font** | nvim、lualine 图标 | `brew install --cask font-jetbrains-mono-nerd-font` |

由 mason.nvim 自动安装（无需手动安装）：basedpyright、ruff、lua_ls。

由 rustaceanvim/mason 自动安装：codelldb（Rust 调试器）。

## Neovim 技术栈

| 组件 | 工具 | 说明 |
|------|------|------|
| 插件管理 | **lazy.nvim** | 懒加载、锁文件、自动依赖 |
| 补全 | **blink.cmp v1** | Rust SIMD 模糊匹配，内置 LSP/路径/缓冲区/代码片段源 |
| LSP 框架 | **mason + nvim-lspconfig** | 自动安装和配置 LSP 服务器（nvim 0.11 原生 API） |
| Rust | **rustaceanvim v6** | 增强版 rust-analyzer，保存时运行 clippy，内联提示，DAP 集成 |
| Python 类型检查 | **basedpyright** | 标准类型检查（LSP） |
| Python Lint/格式化 | **ruff**（LSP） | 快速 linter + 格式化，替代 flake8/isort/black |
| Python Lint | **mypy**（通过 nvim-lint） | 额外的类型检查 |
| Lua LSP | **lua_ls** | 编辑 nvim 配置用 |
| 模糊查找 | **telescope.nvim** | 浮动窗口、实时预览、fzf-native 后端 |
| 文件管理 | **lf**（原生 Lua） | nvim 内浮动终端，无插件依赖 |
| AI 补全 | **copilot.lua** | GitHub Copilot 幽灵文本，Tab 接受 |
| Git 命令 | **vim-fugitive** | `:Git` 命令 |
| Git Diff/PR 审查 | **diffview.nvim** | 并排对比、分支比较、文件历史 |
| Git 标记 | **gitsigns.nvim** | 行内 +/~/- 标记，hunk 导航 |
| 调试器 | **nvim-dap + dap-ui** | 断点、单步执行、变量、调用栈 |
| Rust 调试 | **codelldb**（通过 rustaceanvim） | 基于 LLDB 的 Rust 调试 |
| Python 调试 | **debugpy**（通过 dap-python） | Python 调试 |
| 格式化 | **conform.nvim** | 保存时自动格式化（rustfmt、ruff、stylua、jq、taplo、yamlfmt） |
| Linting | **nvim-lint** | 异步 lint（Python 用 mypy） |
| 语法高亮 | **nvim-treesitter** | 基于 AST 的高亮、文本对象、增量选择 |
| 配色方案 | **gruvbox.nvim** | Gruvbox 深色 -- 统一用于 nvim、tmux、alacritty |
| 状态栏 | **lualine.nvim** | Git 分支、诊断信息、LSP 状态、文件信息 |
| 按键提示 | **which-key.nvim** | leader 键按下后显示可用快捷键（0.5 秒延迟） |
| CSV | **csv.vim** | 列对齐、自动排序、自动排列 |
| 撤销历史 | **undotree** | 可视化撤销树 |

## Neovim LSP 功能

| 功能 | 状态 | 方式 |
|------|------|------|
| **内联提示**（类型标注） | 已启用 | 在 LspAttach 时为支持的服务器自动启用 |
| **语义高亮** | 已启用 | 通过 rust-analyzer/LSP 语义标记 + treesitter |
| **跳转到定义** | `gd` | `vim.lsp.buf.definition` |
| **跳转到类型定义** | `gD` | `vim.lsp.buf.type_definition` |
| **跳转到实现** | `gi` | `vim.lsp.buf.implementation` |
| **查找引用** | `gr` | Telescope UI |
| **悬浮文档** | `gk` | `vim.lsp.buf.hover` |
| **重命名符号** | `<Space>cr` | `vim.lsp.buf.rename` |
| **代码操作** | `<Space>ca` | `vim.lsp.buf.code_action` |
| **格式化缓冲区** | `<Space>cf` | `vim.lsp.buf.format`（也通过 conform 保存时自动格式化） |
| **诊断信息** | 虚拟文本 | `"●"` 前缀，圆角浮动边框，按严重性排序 |
| **LSP 健康检查** | `<Space>ci` | 显示当前缓冲区已连接的 LSP 客户端 |

### Rust-Analyzer 配置

```lua
check.command = "clippy"                    -- 用 clippy 替代 cargo check
cargo.allFeatures = true                    -- 启用所有 Cargo 功能
inlayHints.typeHints = true                 -- 行内显示变量类型
inlayHints.parameterHints = true            -- 调用处显示参数名称
inlayHints.chainingHints = true             -- 方法链中显示类型
inlayHints.closingBraceHints = true         -- 显示闭合花括号提示（最小 10 行）
inlayHints.closureReturnTypeHints = "always"-- 始终显示闭包返回类型
inlayHints.maxLength = 100                  -- 提示最大长度
```

## 核心工作流

整个编辑循环围绕四个键展开（均以 `<Space>` leader 键为前缀）：

```
  Space o     打开 LF 文件管理器 -> 浏览/选择文件
     |
  Space f     按名称模糊查找任意文件
     |
  Space Space 跳回最近打开的文件
     |
  gd          跳转到定义
  gD          跳转到类型定义
  gi          跳转到实现
  Ctrl-o      跳回
  Ctrl-i      跳前
```

**典型会话：**
1. `Space o` -- 打开 LF，可视化浏览项目，选择文件
2. `gd` 在符号上 -- 跳转到其定义
3. `Ctrl-o` -- 跳回之前的位置
4. `Space f` -- 按名称快速打开另一个文件
5. `Space Space` -- 翻回刚才离开的文件
6. `Space p` -- 在整个项目中搜索字符串
7. `gr` -- 查找光标下符号的所有引用

一切围绕 **打开 -> 查找 -> 最近 -> 跳转 -> 跳回** 展开。

## 快捷键

Leader 键：`<Space>`（按住 0.5 秒通过 which-key 查看所有快捷键）

### 查找与打开

| 按键 | 操作 |
|------|------|
| `<leader>o` | **LF 文件管理器**（当前文件目录）-- 浏览、预览、选择 |
| `<leader>O` | LF 文件管理器（项目根目录） |
| `<leader>f` | **查找文件**（按名称，telescope + fd） |
| `<leader><leader>` | **最近文件**（oldfiles，仅当前工作目录） |
| `<leader>p` | **项目搜索** -- 在所有文件中搜索文本 |
| `<leader>w` | 在项目中搜索光标下的单词 |

### 跳转 (LSP)

| 按键 | 操作 |
|------|------|
| `gd` | **跳转到定义** |
| `gD` | **跳转到类型定义** |
| `gi` | **跳转到实现** |
| `gr` | **查找所有引用**（telescope UI） |
| `gk` | 悬浮文档 |
| `Ctrl+o` | **跳回**（gd、gr 等之后） |
| `Ctrl+i` | **跳前** |
| `[g` / `]g` | 上一个 / 下一个诊断 |

### 代码操作 (LSP)

| 按键 | 操作 |
|------|------|
| `<leader>cr` | 重命名符号（跨项目） |
| `<leader>ca` | 代码操作 |
| `<leader>cf` | 格式化缓冲区 |
| `<leader>cd` | 行诊断信息（浮动窗口） |
| `<leader>ci` | LSP 健康检查（查看正在运行的服务器） |

### 窗口与导航

| 按键 | 操作 |
|------|------|
| `<leader>q` | 退出 |
| `<leader>/` | 切换搜索高亮 |
| `<leader>[ ]` | 上翻页 / 下翻页 |
| `<leader>s` / `<leader>a` | 水平分屏 / 垂直分屏 |
| `<leader>hjkl` | 移动到窗口 |
| `<leader>HJKL` | 移动窗口位置 |
| `<leader>= - , .` | 调整窗口大小 |

### Git

| 按键 | 操作 |
|------|------|
| `gs` | Git 状态（fugitive）-- `s` 暂存，`cc` 提交 |
| `gh` / `gl` | Diffget ours / theirs（合并冲突） |
| `<leader>gd` | Diffview（工作区变更） |
| `<leader>gD` | Diffview 对比 main（PR 审查） |
| `<leader>gh` | 文件 git 历史 |
| `<leader>gH` | 仓库 git 历史 |
| `<leader>gp` | 预览 hunk |
| `<leader>gs` | 暂存 hunk |
| `<leader>gr` | 重置 hunk |
| `<leader>gb` | 显示行 blame |
| `]h` / `[h` | 下一个 / 上一个 hunk |
| `<leader>gx` | 关闭 diffview |

### 调试 (DAP)

| 按键 | 操作 |
|------|------|
| `<leader>db` | 切换断点 |
| `<leader>dB` | 条件断点 |
| `<leader>dc` | 继续 / 开始 |
| `<leader>do` | 单步跳过 |
| `<leader>di` | 单步进入 |
| `<leader>dO` | 单步跳出 |
| `<leader>du` | 切换 DAP UI |
| `<leader>dr` | DAP REPL |
| `<leader>dl` | 运行上次 |
| `<leader>dx` | 终止 |

### 补全与 Copilot

| 按键 | 操作 |
|------|------|
| `Tab` | 接受 Copilot 建议 -> 下一个补全 -> 代码片段前进 |
| `S-Tab` | 上一个补全 / 代码片段后退 |
| `CR` | 接受补全 |
| `Ctrl+Space` | 显示/切换补全文档 |
| `Ctrl+u` / `Ctrl+d` | 上下滚动文档 |
| `Ctrl+e` | 取消补全 |
| `Alt+]` / `Alt+[` | 下一个 / 上一个 Copilot 建议 |
| `Ctrl+]` | 关闭 Copilot 建议 |

### Treesitter 选择

| 按键 | 操作 |
|------|------|
| `Ctrl+Space` | 初始化 / 扩展选择（节点增量） |
| `Backspace` | 缩小选择（节点减量） |

### 杂项

| 按键 | 操作 |
|------|------|
| `<leader>u` | 撤销树 |
| `<leader>le/ld/lt/li` | Rust 日志宏（error/debug/trace/info） |

### LF 文件管理器 (lf 内部)

| 按键 | 操作 |
|------|------|
| `q` / `Esc` | 退出 |
| `J` / `K` | 跳 10 行 |
| `{` / `}` | 半页滚动 |
| `F` | FZF 目录跳转 |
| `R` | Ripgrep 搜索 |
| `gp/gs/gl` | Git pull/status/log |

### Yazi 文件管理器 (独立使用)

| 按键 | 操作 |
|------|------|
| `q` / `Esc` | 退出 |
| `J` / `K` | 跳 10 行 |
| `{` / `}` | 半页滚动 |
| `a` | 重命名（光标在末尾） |
| `D` | 删除选中文件到回收站 |
| `!` | 打开 shell |
| `x` | 执行文件 |
| `F` | FZF 目录跳转 |
| `R` | Ripgrep 搜索 |
| `gp/gs/gl` | Git pull/status/log |

### tmux

前缀键：**无**（无前缀键 -- 所有绑定都是直接的）

| 按键 | 操作 |
|------|------|
| `C-n` | 新建窗口 |
| `C-t` | 分割面板（水平） |
| `C-h` | 上一个窗口 |
| `C-l` | 下一个窗口 |
| `Escape` | 进入复制模式（vim 按键） |

### Shell (zsh)

**tmux：**

| 别名 | 命令 |
|------|------|
| `tls` | `tmux ls` |
| `tnew <name>` | `tmux new -s` |
| `tatt <name>` | `tmux attach -t` |
| `tdet <name>` | `tmux detach -t` |
| `ttk` | `tmux kill-server` |

**workmux：**

| 别名 | 命令 |
|------|------|
| `wls` | `workmux ls` |
| `wadd` | `workmux add` |
| `wopen` | `workmux open` |
| `wrm` | `workmux rm --keep-branch` |
| `wdb` | `workmux dashboard` |
| `wmerge` | `workmux merge` |

**cargo：**

| 别名 | 命令 |
|------|------|
| `ct` | `cargo test -- --nocapture` |
| `cb` | `cargo build && rust-gdb` |

**杂项：**

| 别名 | 命令 |
|------|------|
| `lf` | `lfcd`（lf 退出时自动 cd） |
| `jl` | `julia --project=.` |
| `refresh` | `source ~/.zshrc` |

## Nvim 选项

| 选项 | 值 | 说明 |
|------|------|------|
| 缩进宽度 | 4 空格 | `tabstop=4 shiftwidth=4 expandtab` |
| 行号 | 相对行号 | `number + relativenumber` |
| 光标行 | 仅插入模式 | Autocmd 在 InsertEnter/Leave 时切换 |
| 标记列 | 始终可见 | 用于诊断信息、git 标记 |
| 命令行高度 | 0 | 隐藏命令行 |
| 滚动偏移 | 8 行 | `scrolloff=8` |
| 剪贴板 | 系统剪贴板 | `unnamedplus` |
| 撤销 | 持久化 | `~/.vim/undodir` |
| 折叠 | 基于缩进 | Level 99（默认全部展开） |
| Leader 超时 | 10 秒 | `timeoutlen=10000` |
| 更新时间 | 300ms | 用于 CursorHold 事件 |

## 配色方案

**Gruvbox 深色** 在所有工具中统一使用：

| 工具 | 配置 |
|------|------|
| Neovim | `gruvbox.nvim`（transparent=false，SignColumn bg=NONE） |
| tmux | 自定义 gruvbox 调色板（#1d2021 bg，#ebdbb2 fg） |
| Alacritty | Gruvbox 调色板（#282828 bg） |
| Yazi | 自定义 gruvbox 主题（`yazi/theme.toml`） |
| Lualine | `theme = "gruvbox"` |

## 终端字体配置

字体为 **JetBrainsMono Nerd Font**，按终端模拟器配置：

| 终端 | 字号 | 字符间距 | 行间距 |
|------|------|----------|--------|
| Alacritty | 7.5 | 0（`offset.x`） | 2（`offset.y`） |
| VS Code | `terminal.integrated.fontSize` | `terminal.integrated.letterSpacing` | `terminal.integrated.lineHeight` |
| iTerm2 | 描述文件 → 文本 | 字符间距 | 行间距 |

Neovim（终端）继承终端模拟器的字体设置。`vim.opt.linespace` 仅在 GUI 客户端（Neovide 等）中有效。

## Workmux

[Workmux](https://github.com/pommee/workmux) 是 git worktree 工作流的 tmux 工作区管理器。配置文件在 `workmux/config.yaml`。

- 模式：window（在当前 tmux 会话中创建窗口）
- 默认面板布局：打开 Claude Code agent（`claude --permission-mode acceptEdits`）
- 别名：`wls`、`wadd`、`wopen`、`wrm`、`wdb`、`wmerge`

## 目录结构

```
gral/
├── nvim/                    # Neovim 配置（Lua）
│   ├── init.lua             # 入口：leader 键、lazy.nvim 引导
│   └── lua/
│       ├── config/          # 核心设置
│       │   ├── lazy.lua     # Lazy.nvim 引导配置（stable 分支，gruvbox 默认）
│       │   ├── options.lua  # 编辑器选项（缩进、行号、诊断）
│       │   ├── keymaps.lua  # 基于 Leader 的快捷键
│       │   └── autocmds.lua # LSP 附加、光标行、CSV 格式化
│       └── plugins/         # 插件规格（每个关注点一个文件）
│           ├── colorscheme.lua  # Gruvbox
│           ├── completion.lua   # blink.cmp
│           ├── copilot.lua      # GitHub Copilot
│           ├── dap.lua          # Debug Adapter Protocol
│           ├── format-lint.lua  # conform.nvim + nvim-lint
│           ├── git.lua          # fugitive、gitsigns、diffview
│           ├── lf.lua           # LF 文件管理器（原生 Lua 集成）
│           ├── lsp.lua          # mason、lspconfig、rustaceanvim
│           ├── telescope.lua    # 模糊查找
│           ├── treesitter.lua   # 语法高亮
│           └── ui.lua           # lualine、which-key、undotree、csv、devicons
├── yazi/                    # Yazi 文件管理器配置
│   ├── yazi.toml            # 管理器设置、opener、MIME 规则
│   ├── keymap.toml          # 自定义快捷键（lf 风格）
│   └── theme.toml           # Gruvbox 配色主题
├── workmux/                 # Workmux（tmux 工作区管理器）
│   └── config.yaml
├── mac/                     # macOS 专用
│   ├── install              # macOS 软链接脚本
│   ├── dependencies.sh      # Homebrew + oh-my-zsh 引导
│   ├── rust_dep.sh          # Rust 工具链 + cargo 工具
│   ├── tmux.conf            # macOS tmux 变体
│   ├── zshrc                # macOS zshrc
│   ├── vimrc                # macOS Vim 后备
│   ├── lfrc                 # macOS lf 配置
│   ├── pv.sh                # macOS lf 预览器
│   ├── notes.md             # 安装笔记
│   └── custom.zsh-theme     # 自定义 zsh 提示符主题
├── pod/                     # RunPod（云 GPU）配置
│   ├── dockerfile           # Docker 镜像（PyTorch + CUDA + Rust + 开发工具）
│   ├── env.sh               # 环境设置脚本
│   ├── install              # Pod 软链接脚本
│   └── notes.md             # Pod 安装说明
├── backups/                 # 旧配置和参考文件
│   ├── misc/                # xbindkeys、compton 等
│   └── remap/               # HHKB、Karabiner、xmodmap 配置
├── alacritty.yml            # Alacritty 终端（gruvbox、JetBrains Mono、tmux 自动启动）
├── tmux.conf                # tmux（无前缀键、gruvbox、vim 复制模式）
├── zshrc                    # Zsh（oh-my-zsh、vi-mode、别名、环境变量）
├── vimrc                    # 最小化 Vim 后备（无插件）
├── install                  # Linux 软链接脚本（含 i3、polybar、alacritty）
├── i3.conf                  # i3 窗口管理器（Linux）
├── polybar.conf             # Polybar 状态栏（Linux）
├── neofetch.conf            # Neofetch 系统信息（Linux）
├── xinitrc                  # X11 初始化（Linux）
├── xmodmap.conf             # 键位映射（Linux）
├── xmodmap.sh               # 键位映射脚本（Linux）
├── lfrc                     # lf 配置（Linux）
├── lf.conf                  # lf 配置（软链接为 lfrc）
├── pv.sh                    # lf 预览器脚本（macOS）
├── lfpv.sh                  # lf 预览器脚本（Linux）
├── custom.zsh-theme         # Zsh 提示符主题
└── SOP.sh                   # 标准操作流程脚本
```

## Zsh 配置

- **框架**: oh-my-zsh，使用 `sammy` 主题
- **插件**: git、zsh-autosuggestions、zsh-completions、zsh-syntax-highlighting
- **模式**: vi-mode（`bindkey -v`），tab 补全菜单中使用 vim 按键
- **TERM**: `xterm-256color`（tmux 中的配色方案需要）
- **历史记录**: 10000 条
- **自动 tmux**: SSH 登录时自动连接到 `work` 会话

### 环境变量

| 变量 | 用途 |
|------|------|
| `GUROBI_HOME` | Gurobi 优化器 |
| `LIBTORCH` | PyTorch C++ 绑定（tch-rs） |
| `INFLUXDB_TOKEN` | InfluxDB 访问 |
| `NVM_DIR` | Node 版本管理器 |
| `BUN_INSTALL` | Bun JavaScript 运行时 |
| `RUST_BACKTRACE=full` | 完整 Rust 回溯 |

## tmux 配置

- **前缀键**: 无（所有绑定都是直接的，没有前缀键）
- **鼠标**: 已启用
- **复制模式**: Vim 按键，`Escape` 进入
- **窗口编号**: 从 1 开始
- **状态栏**: Gruvbox 配色，会话名（左），日期时间（右；macOS 变体无时钟）
- **终端**: `xterm-256color`，带 RGB 覆盖
