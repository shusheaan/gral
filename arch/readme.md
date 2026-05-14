# Arch Linux setup for gral

目标：Arch 首轮只做一个稳定、可回滚、低 bloat 的工作环境：TTY 登录，手动 `sway` 进入 GUI；GUI 只服务两个主 app：`foot`/`tmux` 和 Chrome。状态常驻在 `tmux`，桌面层只负责窗口、输入法、音频/亮度通知。

## 当前原则

- 不装 Display Manager；登录后默认还是 shell，需要 GUI 时手动运行 `sway`。
- Arch 图形层只保留 Sway + Foot + Mako + Fcitx5；历史 X11 WM/bar/terminal/editor-extension 配置不进入 Arch flow。
- `Mod`/Super 是桌面级快捷键；`Ctrl` 留给 `tmux`、Nvim、Chrome/Citrix 内容区。
- `mac/` 是当前 Mac 快照；Arch 修改只放在 `arch/`，共享项只使用 repo root 的 `nvim/`、`lf/`、`claude/`、`codex/`。
- Citrix native 依赖单独安装；如果 Chrome 网页版能解决快捷键/音频，就不装 native client。

## 目录布局

- `install.sh`：第一次重启后安装 `arch/packages.txt`，再 link Arch 配置。
- `packages.txt`：首轮 pacman 包清单；避免在 `archinstall` 里手打长 list。
- `sway/config`：单工作区 Foot + Chrome 配置；包含方向键/移动/resize、Gruvbox border、隐藏 bar、音量/亮度通知。
- `foot/foot.ini`：Foot 终端配置；Gruvbox dark medium，与 `nvim/lua/plugins/colorscheme.lua` 保持一致。
- `mako/config`：通知样式。
- `environment.d/90-fcitx5.conf`：输入法环境变量。
- `environment.d/91-whisper.conf`：本地 Whisper dictation 默认模型/任务配置。
- `zshrc`、`tmux.conf`、`tmux-system-status.sh`：Arch terminal baseline。
- repo root 共享：`nvim/`（含 `nvim/vimrc`）、`lf/`、`claude/`、`codex/`。

## 光速安装策略：不要在 archinstall 里手打大表

推荐做法：`archinstall` 里只填最小 bootstrap，第一次登录后让 `./arch/install.sh` 从 `arch/packages.txt` 一次性安装完整包清单。

`archinstall` 的 Additional packages 只需要：

```text
git sudo zsh neovim networkmanager openssh curl
```

如果你在 `archinstall` 的 Network 选项里已经选了 NetworkManager，`networkmanager` 也可以不重复填。关键是第一轮要有 `git`、`sudo`、`zsh`，这样重启后能 clone repo 并直接跑 `./arch/install.sh`。

裸机 TTY 如果不方便粘贴，也可以在 Arch ISO 里先开 SSH，从 Mac 终端连进去运行 `archinstall`，这样粘贴长文本会很顺：

```sh
# Arch ISO live TTY
passwd
systemctl start sshd
ip -brief addr

# Mac 终端
ssh root@<arch-iso-ip>
archinstall
```

## archinstall 关键选择

- Mirrors：United States / Canada / Worldwide，按测速结果选。
- Locale：`en_US.UTF-8`；之后可加 `zh_CN.UTF-8 UTF-8`。
- Disk：确认目标盘无误；建议 `btrfs`。
- Snapshots：如果 installer 菜单提供，启用 Snapper。
- Bootloader：`GRUB`，方便配合 `grub-btrfs` 从快照启动。
- Swap：优先 `zram`；hibernate 之后单独做。
- Kernels：`linux` + `linux-lts`。
- Profile：Minimal / No profile。
- Audio：PipeWire。
- Network：NetworkManager。

## Packages list：一个带中文 comment 的唯一清单

唯一包清单是 `arch/packages.txt`：

- 人看：每行包名后面有中文说明。
- 脚本用：`arch/install.sh` 读取同一个文件，忽略空行和 `#` comment，只把第一列包名传给 `pacman`。

查看：

```sh
less arch/packages.txt
```

手动等价安装命令：

```sh
awk 'NF && $1 !~ /^#/ { print $1 }' arch/packages.txt | xargs sudo pacman -Syu --needed
```

## 第一次重启后

```sh
mkdir -p ~/work
cd ~/work
git clone https://github.com/shusheaan/gral.git
cd ~/work/gral
./arch/install.sh
source ~/.zprofile
```

`arch/install.sh` 会：

- 先执行 `sudo pacman -Syu --needed` 安装 `arch/packages.txt` 中的完整包清单；如果只想重 link 配置，可运行 `GRAL_SKIP_PACKAGES=1 ./arch/install.sh`。
- link `arch/zshrc`、`arch/tmux.conf`、`arch/tmux-system-status.sh`。
- link shared `nvim/`、`nvim/vimrc`、`lf/`。
- link `arch/sway/config`、`arch/foot/foot.ini`、`arch/mako/config`、`arch/environment.d/*.conf`。
- best-effort 设置 login shell 为 zsh。
- 调用 root `./sync-ai`，让 Mac/Arch 共用 `claude/` 与 `codex/`。
- 初始化 Rust stable + `rust-analyzer`/`rust-src`。
- 尝试启用 PipeWire user services。

之后需要 GUI 时手动运行：

```sh
sway
```

## Foot 配置

实际配置只维护在 `arch/foot/foot.ini`。它使用 JetBrainsMono Nerd Font、Gruvbox dark medium，颜色与 `nvim/lua/plugins/colorscheme.lua` 对齐；不做透明。

## Sway 配置

实际配置只维护在 `arch/sway/config`。工作模型是一个 workspace，两个 floating app：Foot/tmux 与 Chrome；Sway 只负责启动、摆放、切换、移动/resize、音量/亮度通知，常驻状态放在 `tmux`。

首次进入后检查真实 app id/class：

```sh
swaymsg -t get_tree | jq '.. | objects | select(.type? == "con") | {name, app_id, class}'
```

外接屏幕与窗口位置按真实输出调整：

```sh
swaymsg -t get_outputs
swaymsg resize set width 1450 px height 950 px
swaymsg move position 160 100
```

## Mako 通知

实际配置只维护在 `arch/mako/config`。通知位置是 `anchor=top-center`，也就是屏幕水平居中、靠上弹出；`margin=24` 控制离屏幕顶部的距离。Whisper 录音、音量、麦克风、亮度都会走这个通知样式。

配置改完后，在 Sway 里 reload：

```sh
makoctl reload
```

如果 reload 不生效，就重启一次 daemon：

```sh
pkill mako
mako &
```

## Fcitx5 / Rime

环境变量由 `arch/environment.d/90-fcitx5.conf` 管理，并由 `~/.zprofile` 读取。输入法安装在大表内，Rime 明月拼音方案是 `rime-luna-pinyin`。

## Local Whisper dictation：Ctrl+F 录音转文字到剪贴板

目标：在 Sway 里用全局 `Ctrl+F` 做本地语音转文字。第一次按开始录音，`mako` 在屏幕中心靠上提示“正在录音”；第二次按停止录音，`mako` 提示“录音已停止，正在本地转写...”，然后本地 Whisper 转写并自动写入 Wayland 全局剪贴板。

### 需要什么

- 麦克风：PipeWire 能看到默认 input device。
- Arch 包：已经在 `arch/packages.txt` 统一管理，不要另外写一份安装清单。
  - `pipewire` / `wireplumber`：提供音频服务和 `pw-record` 录音。
  - `ffmpeg`：`openai-whisper` 读取/转码音频必需。
  - `wl-clipboard`：提供 `wl-copy`，把转写结果写进剪贴板。
  - `mako` + `libnotify`：提供通知 daemon 和 `notify-send`。
  - `python` + `uv`：创建本地 Python venv 并安装 `openai-whisper`。
- 磁盘/内存：默认 `large-v3` 准确率优先，模型缓存约数 GB；第一次 setup 会下载依赖和模型。
- GPU：可选。脚本能用 CUDA 就用 CUDA，否则自动 CPU；GPU driver / PyTorch wheel 跟硬件强相关，先不进默认大表。

### 相关文件

- `arch/environment.d/91-whisper.conf`：默认配置。
  - `WHISPER_MODEL=large-v3`：优先准确率。
  - `WHISPER_TASK=transcribe`：保留原始中文/英文；不是翻译。
  - `WHISPER_LANGUAGE=`：留空，适合中英文混合自动识别。
- `arch/bin/whisper-dictation-setup`：创建 `uv` venv、安装 `openai-whisper`、预下载模型。
- `arch/bin/whisper-dictation-toggle`：录音/停止/转写/`wl-copy`。
- `arch/sway/config`：`bindsym Control+f exec $HOME/.local/bin/whisper-dictation-toggle`。

### 配置过程

1. 第一次重启后先跑 Arch install：

   ```sh
   cd ~/work/gral
   ./arch/install.sh
   source ~/.zprofile
   ```

2. 确认基础命令都在：

   ```sh
   command -v ffmpeg pw-record wl-copy notify-send uv
   ```

3. 确认 PipeWire 和麦克风：

   ```sh
   systemctl --user status pipewire pipewire-pulse wireplumber
   wpctl status
   ```

   如果默认输入设备不对，用 `pavucontrol` 选 input device，或者用 `wpctl` 调默认 source。

4. 第一次使用前跑 setup；这一步会下载 Python 依赖和 Whisper 模型：

   ```sh
   whisper-dictation-setup
   ```

   输出里看这一行：

   ```text
   torch_cuda_available= True/False
   ```

   - `True`：PyTorch 看到了 CUDA，会用 GPU。
   - `False`：仍然能用 CPU，只是 `large-v3` 会慢；等确认 GPU 型号后再单独处理 driver / PyTorch wheel。

5. 进 Sway 或 reload Sway：

   ```sh
   sway
   # 已经在 Sway 里则用：
   swaymsg reload
   ```

6. 使用：

   - 按 `Ctrl+F`：开始录音，Mako 提示正在录音。
   - 说话。
   - 再按 `Ctrl+F`：停止录音并开始本地转写。
   - 等 Mako 提示“已复制到剪贴板”，然后在任意地方粘贴。

### 调整配置

默认配置在 `arch/environment.d/91-whisper.conf`，这是永久配置；因为 install 后是 symlink，直接改 repo 里的这个文件即可。改完后重新 `source ~/.zprofile`，再重新启动 `sway` 或从 shell 里手动测试。换模型后要重新跑一次 `whisper-dictation-setup`，让模型先下载到本地缓存。

临时降低模型大小、换速度：

```sh
WHISPER_MODEL=medium whisper-dictation-setup
WHISPER_MODEL=medium whisper-dictation-toggle
```

强制中文：

```sh
WHISPER_LANGUAGE=zh whisper-dictation-toggle
```

翻译成英文，而不是保留原文：

```sh
WHISPER_TASK=translate whisper-dictation-toggle
```

注意：`Ctrl+F` 是 Sway 全局快捷键，会被桌面层先吃掉；在 Chrome/Nvim 里就不能再用它做 find。如果这点烦，再把 `arch/sway/config` 里的 binding 改成别的组合。

### Debug

```sh
ls "$XDG_RUNTIME_DIR/gral-whisper-dictation"
cat "$XDG_RUNTIME_DIR/gral-whisper-dictation/whisper.log"
```

常见问题：

- `missing venv`：还没跑 `whisper-dictation-setup`。
- `missing ffmpeg`：`arch/packages.txt` 没装完整，重跑 `./arch/install.sh`。
- 没录到声音：先检查 `wpctl status` / `pavucontrol` 的默认 input device。
- 转写太慢：先用 `WHISPER_MODEL=medium`；GPU 确认后再处理 CUDA/ROCm。

## Chrome / Citrix

优先尝试 Chrome 网页版 Workspace。若网页版能传 Escape、Ctrl 等关键键并且音频可用，就不安装 native Citrix。若必须 native client，再单独安装 AUR `icaclient` 及其 runtime 依赖；这些依赖不进入大表。

Chrome Wayland 启动命令在 Sway 里是：

```sh
google-chrome-stable --ozone-platform=wayland
```

## 风扇/温度

- 首选主板 BIOS/UEFI fan curve：最稳定，不依赖 OS 服务。
- Linux 侧先用 `lm_sensors`：`sudo sensors-detect` 后用 `sensors` 观察。
- 如果硬件暴露 PWM，才考虑 `pwmconfig` + `fancontrol`；不支持就不要强行软件控速。

## 验收清单

- [ ] TTY 登录后不会自动进图形；需要时手动 `sway`。
- [ ] `zsh`、`tmux`、`nvim`、`lf` 可启动。
- [ ] `~/.vimrc` 指向 shared `nvim/vimrc`。
- [ ] Foot 使用 JetBrainsMono Nerd Font；颜色与 Nvim Gruvbox dark 一致；无透明背景。
- [ ] Sway 自动打开 Foot/tmux + Chrome；`$mod+Tab` 在两个 app 间切换。
- [ ] `$mod+Shift+t` 打开 Foot/tmux；`$mod+Shift+g` 打开 Chrome。
- [ ] `$mod+h/j/k/l` focus；`$mod+Shift+h/j/k/l` move；`$mod+Shift+r` 进入 resize mode。
- [ ] 音量/静音/亮度快捷键可用，并通过 Mako 弹出临时通知。
- [ ] `fcitx5` 可输入中文；Chrome/Foot/Nvim 中都可用。
- [ ] Bluetooth 鼠标/键盘/耳机/mic 可连接并能在 PipeWire 中切换。
- [ ] Snapper 快照和 `grub-btrfs` 可用，升级前后有快照。
- [ ] Star storage：`rclone` 可访问 R2/S3；项目 Python/Rust 工具链可跑基本命令。
