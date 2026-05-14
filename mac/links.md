# macOS link manifest

目的：把这台 Mac 当前正在使用、且来自 `gral` 仓库的 live config 收口到 `mac/`，这样后续修改 Arch/Linux 配置时不会误伤当前 macOS 工作环境。

## 原则

- `mac/install` 默认链接 `mac/` 下的 Mac-frozen snapshot；`nvim/vimrc`、`lf/`、`claude/`、`codex/` 是明确共享例外。
- `~/.config/nvim` 也已冻结到 `mac/nvim/`；root `nvim/` 后续可以作为 Arch/Linux 版本演进，不会影响当前 Mac。
- root `install` 后续可以改成 Arch/Linux 入口；不要在 Mac 上继续运行 root `./install`。
- `nvim/vimrc`、`lf/`、`claude/`、`codex/` 由 Mac 和 Arch 共用，避免重复维护两套。

## mac/install 管理的链接

| Target | Source |
| --- | --- |
| `~/.zshrc` | `mac/zshrc` |
| `~/.tmux.conf` | `mac/tmux.conf` |
| `~/.oh-my-zsh/custom/themes/custom.zsh-theme` | `mac/custom.zsh-theme` |
| `~/.xinitrc` | `mac/xinitrc` |
| `~/.xmodmap.sh` | `mac/xmodmap.sh` |
| `~/.xmodmap.conf` | `mac/xmodmap.conf` |
| `~/.vimrc` | `nvim/vimrc` shared |
| `~/.config/nvim` | `mac/nvim/` |
| `~/.config/yazi/yazi.toml` | `mac/yazi/yazi.toml` |
| `~/.config/yazi/keymap.toml` | `mac/yazi/keymap.toml` |
| `~/.config/yazi/theme.toml` | `mac/yazi/theme.toml` |
| `~/.config/lf/lfrc` | `lf/lfrc` shared |
| `~/.config/lf/preview.sh` | `lf/preview.sh` shared |
| `~/.config/lf/pv.sh` | `lf/pv.sh` shared |
| `~/.config/i3/config` | `mac/i3.conf` |
| `~/.config/alacritty/alacritty.yml` | `mac/alacritty.yml` |
| `~/.claude/*` | `claude/*` shared via `sync-ai` |
| `~/.codex/*` | `codex/*` and `claude/*` shared via `sync-ai` |
| `~/.agents/skills/*` | `claude/skills/*` shared via `sync-ai` |

## `mac/` 内部运行时引用

这些不是额外 `$HOME` symlink，但会被上面的配置运行时调用，所以也必须留在 `mac/` 内：

- `mac/tmux.conf` 调用 `mac/tmux-system-status.sh`。
- shared `claude/settings.json` 调用 `claude/statusline.py`。
- shared `codex/hooks.json` 调用 `codex/agent_status.py`。

## 操作

```sh
./mac/install
```

运行后，当前 Mac 的 gral-managed symlink 应该指向 `mac/`，只有 `nvim/vimrc`、`lf/`、`claude/`、`codex/` 这几个明确共享项会指向 repo root。
