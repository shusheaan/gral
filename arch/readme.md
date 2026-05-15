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
- `ssh/config`：Arch outbound SSH client config，默认包含 GitHub，RunPod 留 template。
- `systemd/logind.conf.d/10-gral-session.conf`：本地退出后保留 tmux、禁止自动 sleep 的 session policy。
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
- Disk：确认目标盘无误；使用 `btrfs` + LUKS 全盘加密。
  - 为什么要 LUKS：防止别人拿到机器/硬盘后直接读 `~/.ssh`、Chrome profile、repo、token/cache。
  - 代价：断电或 reboot 后，远程 SSH/Tailscale 不会自动回来，必须本地输入 LUKS 密码完成开机解锁。这个 tradeoff 接受；机器正常开着时仍然 always-on。
- Snapshots：如果 installer 菜单提供，启用 Snapper。
- Bootloader：`GRUB`，方便配合 `grub-btrfs` 从快照启动。
- Swap：优先 `zram`；hibernate 之后单独做。
- Kernels：`linux` + `linux-lts`。
- Profile：Minimal / No profile。
- Audio：PipeWire。
- Network：NetworkManager。
- User：创建普通用户，并给 sudo/wheel 权限。`./arch/install.sh` 要用普通用户运行，不要 `sudo ./arch/install.sh`；脚本内部会自己 `sudo pacman`，而 AUR `makepkg` 不能用 root 跑。

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
# Then log out of this TTY and log back in once.
exit
```

`arch/install.sh` 会：

- 先执行 `sudo pacman -Syu --needed` 安装 `arch/packages.txt` 中的完整包清单；如果只想重 link 配置，可运行 `GRAL_SKIP_PACKAGES=1 ./arch/install.sh`。
- 从 AUR 构建安装 `google-chrome`；如果只想跳过 Chrome，可运行 `GRAL_SKIP_CHROME=1 ./arch/install.sh`。
- link `arch/zshrc`、`arch/tmux.conf`、`arch/tmux-system-status.sh`。
- link `arch/ssh/config` 到 `~/.ssh/config`。
- link shared `nvim/`、`nvim/vimrc`、`lf/`。
- link `arch/sway/config`、`arch/foot/foot.ini`、`arch/mako/config`、`arch/environment.d/*.conf`。
- best-effort 设置 login shell 为 zsh。
- 调用 root `./sync-ai`，让 Mac/Arch 共用 `claude/` 与 `codex/`。
- 初始化 Rust stable + `rust-analyzer`/`rust-src`。
- 尝试启用 PipeWire user services。
- 启用 `sshd.service`，方便手机/其他机器 SSH 回来 attach tmux。
- 启用 `tailscaled.service`；第一次还需要你手动 `sudo tailscale up --operator="$USER" --qr` 登录 tailnet。
- 安装 `/etc/systemd/logind.conf.d/10-gral-session.conf`：本地 logout 后不杀用户进程，并忽略自动 idle/lid sleep。

`install.sh` 不会强制把你踢出当前 TTY。完成后你手动 logout/login 一次：

```sh
exit
```

重新登录后，之后需要 GUI 时手动运行：

```sh
sway
```

预期结果：`install.sh` 结束后，`foot`、`tmux`、`google-chrome-stable` 都应该已经可用；第一次进入 Sway 会自动打开 Foot/tmux 和 Chrome。

## 本地退出 / 远程继续跑任务

目标行为：

- 开机后只到 TTY login prompt。
- 你输入密码登录，需要 GUI 时才手动 `sway`。
- `sway` 启动后自动打开 Foot/tmux 和 Chrome，并按 `arch/sway/config` 摆好位置。
- `Mod+Shift+Q` 退出整个 Sway session：Foot 和 Chrome 关闭，回到 TTY login prompt。
- tmux server/session 保留；后台任务继续跑。
- 手机或其他机器可以 SSH 回来；`arch/zshrc` 会自动 attach `work` tmux session，如果没有自动 attach，就手动：

  ```sh
  ssh <user>@<host>
  tmux attach -t work
  ```

关键实现：

- `arch/zshrc` 把 `sway` 定义成 function，内部执行 `exec /usr/bin/sway`。所以退出 Sway 后不会回到一个已解锁 shell，而是结束本地登录 session，回到 TTY login prompt。
- `arch/sway/config` 的 `Mod+Shift+Q` 是 `exit`，它会退出 Sway/compositor；Wayland clients 会随之关闭。
- Foot 关闭只会断开 tmux client；tmux server 继续保留 session。
- `install.sh` 会启用 `sshd.service`，并 `loginctl enable-linger "$USER"`。
- `/etc/systemd/logind.conf.d/10-gral-session.conf` 明确 `KillUserProcesses=no`，并忽略 idle/lid 自动 sleep。需要关机/重启时你手动执行 `poweroff` 或 `reboot`。

注意：如果你离开电脑但没有按 `Mod+Shift+Q`，当前 Sway session 仍然是打开的；本方案是“退出到登录口”，不是锁屏器。

### 忘记退出 Sway 时，从手机远程退出本地 GUI

如果你离开机器时忘了按 `Mod+Shift+Q`，手机仍然可以通过 Tailscale + Termius SSH 进去，然后让本地 Sway 退出到 TTY login prompt。

SSH 进去后如果已经自动 attach 到 `work` tmux session，在任意 tmux pane 里执行：

```sh
exitsway
```

`exitsway` 是 `arch/zshrc` 里的 function，优先执行：

```sh
swaymsg exit
```

如果 SSH/tmux pane 没继承 `SWAYSOCK`，`exitsway` 会自动从 `/run/user/$UID/sway-ipc.*.sock` 找当前 Sway socket 再退出。

效果和本地按 `Mod+Shift+Q` 一样：

- 本地 Sway/compositor 退出。
- Chrome 和 Foot 关闭。
- 本地屏幕回到 TTY login prompt。
- 当前手机 SSH 连接和 tmux session 继续存在。
- tmux 后台任务继续跑。

手动等价命令：

```sh
ls /run/user/$UID/sway-ipc.*.sock
SWAYSOCK="$(ls /run/user/$UID/sway-ipc.*.sock | head -n 1)" swaymsg exit
```

## Tailscale + 手机 Termius SSH

目标：只要 Arch 机器开着并联网，手机就能通过 Tailscale tailnet SSH 回来；本地屏幕可以停在 TTY login prompt，tmux 后台任务继续跑。

### 模型

```text
Arch machine
  system service: tailscaled
  system service: sshd
  user process: tmux server/session

iPhone/Android
  Tailscale app: 连接同一个 tailnet
  Termius: 连接 Arch 的 Tailscale IP / MagicDNS，端口 22
```

关键点：

- 这里用的是标准 OpenSSH over Tailscale，不依赖 Tailscale SSH；Termius 仍然按普通 SSH client 配置。
- Linux 上 Tailscale 是 system daemon；不是 GUI app，不依赖你本地是否登录。
- `sshd.service` 也是 system service；TTY 是否登录、Sway 是否退出，不影响远程 SSH。
- 手机锁屏可能会让手机 SSH client 自己断线；这不影响 Arch 上的 tmux 任务。重新打开 Termius 再 SSH，attach tmux 即可。

### Arch 端第一次配置

`tailscale` 已在 `arch/packages.txt`，`install.sh` 会 enable/start `tailscaled.service`。第一次登录 tailnet：

```sh
sudo tailscale up --operator="$USER" --qr
```

- `--qr`：TTY 下直接扫二维码登录，适合没有浏览器的 first setup。
- `--operator="$USER"`：之后普通用户可以执行 `tailscale status` / `tailscale ip` 等管理命令。

确认：

```sh
tailscale status
tailscale ip -4
systemctl status tailscaled sshd
```

必须在 Tailscale admin console 里给这台机器关掉 key expiry：Machines -> 这台机器 -> Disable key expiry。这样它更像家里的 always-on server，不会过期后要求重新登录。这个不能可靠地从本机 `install.sh` 自动完成，因为它属于 tailnet 管理策略。

### Termius 端配置

手机上装两个 app：

1. Tailscale：登录同一个账号/tailnet，并保持 VPN connected。
2. Termius：新建 Host。

Termius Host：

- Address：
  - 优先用 MagicDNS，例如 `<arch-hostname>.<tailnet>.ts.net`
  - 或者直接用 `tailscale ip -4` 输出的 `100.x.y.z`
- Port：`22`
- Username：你的 Arch 用户名
- Key：Termius 里生成/导入的 SSH private key

### 把手机 Termius public key 放进 Arch

推荐 key login，不靠 password。Termius 里生成 `ed25519` key，然后复制 public key；在 Arch TTY 本地执行：

```sh
install -d -m 700 ~/.ssh
nvim ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

把 Termius 的 public key 粘成一整行，形如：

```text
ssh-ed25519 AAAA... termius-phone
```

如果你已经把自己的常用 public keys 加到 GitHub，也可以从 GitHub 拉下来，减少手打：

```sh
install -d -m 700 ~/.ssh
curl -fsSL https://github.com/shusheaan.keys >> ~/.ssh/authorized_keys
sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

先测试：

```sh
ssh <user>@<tailscale-ip>
tmux attach -t work
```

确认 key login OK 后，再考虑把 SSH password login 关掉：

```sh
sudo install -d -m 755 /etc/ssh/sshd_config.d
sudo tee /etc/ssh/sshd_config.d/20-gral-hardening.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
EOF
sudo systemctl reload sshd
```

### 只允许 Tailscale 上的 SSH

原则：SSH 最终只应该从 `tailscale0` 进来，不要长期暴露在普通 LAN/WiFi 上。先确保 Termius 通过 Tailscale 已经能登录，再收紧防火墙；不要反过来做，避免把自己锁在外面。

等 Termius 通过 Tailscale 能连进去以后，再开 UFW 限制 SSH 只从 `tailscale0` 进来：

```sh
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 22 proto tcp
sudo ufw enable
sudo ufw status verbose
```

不要在 Tailscale 还没连通前开这组规则，避免把自己从 LAN SSH 里锁出去。

确认 UFW 生效后，普通 LAN IP 不应该能 SSH，Tailscale IP 应该能 SSH：

```sh
tailscale ip -4
sudo ufw status verbose
```

## SSH key：GitHub / RunPod

本机 outbound SSH 配置在 `arch/ssh/config`，安装后 link 到 `~/.ssh/config`。

### 生成 Arch 本机 key

```sh
install -d -m 700 ~/.ssh
ssh-keygen -t ed25519 -C "$USER@$(hostname)-arch" -f ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### GitHub

把 public key 复制出来：

```sh
cat ~/.ssh/id_ed25519.pub
```

在 GitHub -> Settings -> SSH and GPG keys -> New SSH key 添加。测试：

```sh
ssh -T git@github.com
```

之后 repo 可以用 SSH URL：

```sh
git clone git@github.com:shusheaan/gral.git
```

### RunPod / rented GPU host

RunPod 这类机器一般会给一个 `ssh root@<host> -p <port>`。把它写进 `~/.ssh/config`：

```sshconfig
Host runpod-main
  HostName <runpod-host-or-ip>
  User root
  Port <runpod-ssh-port>
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
  ServerAliveInterval 30
  ServerAliveCountMax 3
```

然后：

```sh
ssh runpod-main
```

手机 Termius 连接 RunPod 也是同一个逻辑：Host 填 provider 给的 host，Port 填 provider 给的 port，Username 通常是 `root`，Key 用你放到 RunPod 的 private/public key pair。

## Foot 配置

实际配置只维护在 `arch/foot/foot.ini`。它使用 JetBrainsMono Nerd Font、Gruvbox dark medium，颜色与 `nvim/lua/plugins/colorscheme.lua` 对齐；不做透明。

## Zsh completion / plugins

自动完成、历史建议、语法高亮不是 Oh My Zsh 独有。Arch baseline 仍然是 bare zsh，不装 Oh My Zsh、不装 plugin manager；只用 pacman 官方包：

- `zsh-completions`：更多命令 completion。
- `zsh-autosuggestions`：根据历史命令给灰色建议。
- `zsh-syntax-highlighting`：命令行语法高亮。

这些包在 `arch/packages.txt` 里，`arch/zshrc` 会直接从 `/usr/share/zsh/plugins/...` source；如果某个包没装，也会安静跳过，不影响 shell 启动。

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

## NVIDIA / CUDA / Python GPU dev baseline：RTX 5060 Ti 机器单独跑

目标：GPU 相关包很大、强依赖硬件，不进入首轮 `arch/packages.txt`；确认这台机器有 NVIDIA GPU（例如 RTX 5060 Ti）后，单独跑：

```sh
cd ~/work/gral
./arch/python-gpu-dev.sh
```

脚本做三层配置：

- 系统层：通过 `pacman` 安装 `nvidia-open-dkms`、`nvidia-utils`、`opencl-nvidia`、`cuda`、`cudnn`、`nccl`，并按已安装 kernel 自动补 `linux-headers` / `linux-lts-headers`。
- Arch Python 层：安装 `python-pytorch-cuda`、`python-openai-whisper`、`python-polars`、`pytest`/`hypothesis`、`mypy`、`ruff` 等机器级 Python 基础包。
- 共享 venv 层：创建 `/opt/gral-python-gpu`，使用 `--system-site-packages` 读取 Arch 的 CUDA PyTorch，再用 `uv` 安装 `openmm[cuda13]`。如果 OpenMM 的 CUDA 13 wheel 有兼容问题，可改用：

  ```sh
  GRAL_OPENMM_CUDA_EXTRA=cuda12 ./arch/python-gpu-dev.sh
  ```

脚本还会写入：

```text
~/.config/environment.d/92-gral-python-gpu.conf
```

里面设置：

```sh
GRAL_PYTHON_GPU_VENV=/opt/gral-python-gpu
WHISPER_VENV=/opt/gral-python-gpu
```

所以重新登录后，Sway 里的 `whisper-dictation-toggle` 会直接用共享 GPU Python，不再走每个用户目录里的 CPU fallback venv。

常用验证：

```sh
nvidia-smi
torch-test-gpu
python-gpu -m openmm.testInstallation
python-gpu -c 'import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0))'
```

注意：

- 如果脚本刚安装了 NVIDIA driver/DKMS，先 reboot 一次再判断 CUDA 是否正常；第一次运行时 `nvidia-smi` 失败通常只是 kernel module 还没加载。
- 默认会预下载 `WHISPER_MODEL`（缺省 `large-v3`）。不想下载模型可用 `GRAL_SKIP_WHISPER_PREFETCH=1 ./arch/python-gpu-dev.sh`。
- OpenMM 可用 `GRAL_SKIP_OPENMM=1` 跳过安装，或用 `GRAL_SKIP_OPENMM_TEST=1` 跳过官方安装测试。

## Local Whisper dictation：Ctrl+F 录音转文字到剪贴板

目标：在 Sway 里用全局 `Ctrl+F` 做本地语音转文字。第一次按开始录音，`mako` 在屏幕中心靠上提示 `Recording... press Ctrl+F again to stop`；第二次按停止录音，`mako` 提示 `Recording stopped; transcribing locally...`，然后本地 Whisper 转写并自动写入 Wayland 全局剪贴板。

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
   # Then log out of this TTY and log back in once.
   exit
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

   - 按 `Ctrl+F`：开始录音，Mako 提示 `Recording... press Ctrl+F again to stop`。
   - 说话。
   - 再按 `Ctrl+F`：停止录音并开始本地转写，Mako 提示 `Recording stopped; transcribing locally...`。
   - 等 Mako 提示 `Copied to clipboard: ...`，然后在任意地方粘贴。

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

Chrome 不是 pacman 官方仓库包，所以不放进 `arch/packages.txt`。`arch/install.sh` 会直接从 AUR `google-chrome` checkout 到 `~/.cache/gral-aur/google-chrome`，然后用 `makepkg -si --noconfirm` 安装。这样不引入 `yay` 这类 AUR helper，保持最小。

优先尝试 Chrome 网页版 Workspace。若网页版能传 Escape、Ctrl 等关键键并且音频可用，就不安装 native Citrix。若必须 native client，再单独安装 AUR `icaclient` 及其 runtime 依赖；这些依赖不进入大表。

Chrome Wayland 启动命令在 Sway 里是：

```sh
google-chrome-stable --ozone-platform=wayland
```

如果 Chrome AUR 构建失败，单独重试：

```sh
cd ~/.cache/gral-aur/google-chrome
makepkg -si
```

如果只是想先跳过 Chrome、把 terminal 环境跑起来：

```sh
GRAL_SKIP_CHROME=1 ./arch/install.sh
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
