# Arch Linux 迁移安装检查单（Btrfs + Snapper + Sway + Foot）

> 目标：从零安装 Arch Linux，并尽量无痛地迁移到接近当前 Mac/gral 工作状态：TTY 登录为主，需要图形时手动启动 `sway`；桌面只用 Sway + Foot；核心优先级是 **Terminal/zsh/tmux、Chrome、Citrix Workspace、WiFi、Bluetooth 鼠标/键盘/音频/mic、显示器、中文输入法、Btrfs 快照可回滚**。

> 当前版本：2026-05-14 初版骨架。后续边装边改，不改 `SOP.sh`，只参考它和本仓库 dotfiles。

## 0. 原则与非目标

- [ ] 先保证能上网、Terminal 可工作、Chrome/Citrix 可登录、Bluetooth 鼠标/键盘/音频/mic 与显示器稳定，再迁移编辑器/AI/开发环境。
- [ ] 使用 `archinstall` 简化安装；不要手写整套分区脚本，除非安装器无法满足 Btrfs/Snapper。
- [ ] 使用 Btrfs + Snapper + `snap-pac` + `grub-btrfs`：升级前后自动快照，GRUB 里能进入快照救急。
- [ ] 默认不装 Display Manager；登录后仍是命令行，需要图形时运行 `startsway` 或 `sway`。
- [ ] 不装 Xorg/i3/polybar/alacritty 新环境；仓库里的 `i3.conf` 只作为 Sway 配置迁移参考。
- [ ] 不直接修改 `SOP.sh`；`install` 目前仍有 i3/polybar/alacritty legacy link，先手动 link 关键 dotfiles，之后再专门改安装脚本。

## 1. 安装前准备

### 1.1 当前 Mac 基线（2026-05-14 本机盘点）

这段的目的不是把 macOS 逐字复制到 Arch，而是先锁定“必须能工作”的最小系统边界：Terminal、Chrome、Citrix Workspace、Bluetooth/audio/键鼠/显示器。

- 当前机器：`MacBook Air`，`MacBookAir10,1`，Apple M1，8 GB RAM。
- 当前系统：macOS `26.4.1`，Build `25E253`，`arm64`，shell 为 `/bin/zsh`，`zsh 5.9`。
- 当前 `$HOME/GitHub`：只发现 `~/GitHub/gral` 与 `~/GitHub/star`；本次检查两者 `main` 均 `ahead=0 behind=0`，且没有 `git status --short` 输出。迁移前仍要再跑一次验证。
- 当前值得关注的本机配置目录：`~/.ssh`、`~/.gnupg`、`~/.config`、`~/.zshrc`、`~/.zprofile`、`~/.zshenv`、`~/.gitconfig`、`~/.gitignore_global`、`~/.cargo`、`~/.rustup`、`~/.local`、`~/.npm`、`~/.claude`、`~/.codex`、`~/.agents`、`~/.docker`。
- 当前 `~/.config` 里存在并需要迁移/对照的配置：`nvim`、`karabiner`、`lf`、`yazi`、`git`、`fish`、`htop`、`coc`、`github-copilot`、`cagent`、`macmon.json`、legacy `i3/polybar/alacritty`。
- 当前 `~/Library` 里存在的关键 App 数据：
  - Chrome：`~/Library/Application Support/Google/Chrome`、`~/Library/Preferences/com.google.Chrome.plist`。
  - Citrix：`~/Library/Application Support/Citrix Receiver`、`~/Library/Application Support/Citrix Workspace`、`~/Library/Preferences/com.citrix.receiver.nomas.plist`。
  - Terminal/macOS 交互：`~/Library/Preferences/com.apple.Terminal.plist`、`~/Library/Fonts`、`~/Library/LaunchAgents`。
  - macOS 回滚/凭据：`~/Library/Keychains`、`~/Library/Accounts`、`~/Library/Group Containers`、`~/Library/Containers`、`~/Library/CloudStorage`、`~/Library/Mobile Documents`。

> 注意：`~/Library/Keychains`、Chrome profile、`~/.ssh`、`~/.gnupg`、AI/Cloud CLI 配置都可能含 token/cookie/private key。只备份到加密外置盘或加密磁盘镜像；不要传到普通云盘或 repo。

### 1.2 Mac 备份清单：按“必须恢复什么”分层

#### A. 必须备份：没有它们 Terminal/登录会断

- [ ] Git/SSH 身份：`~/.ssh`、`~/.gnupg`、`~/.gitconfig`、`~/.gitignore_global`。
- [ ] Shell/Terminal 工作流：`~/.zshrc`、`~/.zprofile`、`~/.zshenv`、`~/.profile`、`~/.bash_profile`、`~/.tmux.conf`、`~/.vimrc`、`~/.vim`、`~/.oh-my-zsh`。
- [ ] 主要项目：`~/GitHub/gral`、`~/GitHub/star`；迁移前必须确认没有 uncommitted / unpushed work。
- [ ] 编辑器与 TUI：`~/.config/nvim`、`~/.config/lf`、`~/.config/yazi`、`~/.config/git`、`~/.config/fish`、`~/.config/htop`。
- [ ] AI/agent 配置：`~/.claude`、`~/.claude.json`、`~/.codex`、`~/.agents`、`~/.cagent`、`~/.gemini`、`~/.copilot`、`~/.config/github-copilot`、`~/.config/cagent`。
- [ ] 开发工具状态：`~/.cargo`、`~/.rustup`、`~/.local`、`~/.npm`、`~/.bun`、`~/.docker`、`~/.vscode`、`~/.vscode-server`、`~/.gitnexus`。
- [ ] 许可证/本地数据：`~/gurobi.lic`、`~/Storage`；`~/Documents`、`~/Downloads`、`~/Desktop` 迁移前人工扫一遍。

#### B. 必须记录/导出：Linux 不能直接复用，但会影响工作连续性

- [ ] Chrome：确认 Google Sync / password manager / 2FA 可用；另导出 bookmarks；如果依赖本地 profile，再备份 `~/Library/Application Support/Google/Chrome`。
- [ ] Citrix：记录 Workspace/Store URL、公司登录方式、MFA 方式、是否需要公司 CA 证书、是否依赖 `.ica` 文件下载；备份 Citrix App Support 与 plist 只用于回滚 Mac，不保证能迁移到 Linux。
- [ ] 密码与 2FA：确认密码管理器可从新系统登录；若 2FA 在本机，先迁移到手机/硬件 key/备份码，不要只依赖 Chrome cookie 或 macOS Keychain。
- [ ] WiFi：记录 SSID、认证方式、密码；企业 WiFi 额外记录证书/用户名/域。
- [ ] Bluetooth：记录鼠标、键盘、耳机/音响、mic 的设备名；pairing key 不能可靠迁移，Arch 上按设备重新 pair/trust/connect。
- [ ] Keyboard：备份 `~/.config/karabiner/karabiner.json`；把必须保留的改键规则翻译成 Sway `input` / `bindsym`，不要指望 Karabiner 在 Linux 可用。
- [ ] Display：连接外接显示器时记录型号、分辨率、刷新率、缩放比例、左右位置；Arch 上用 `swaymsg -t get_outputs` / `wlr-randr` 重建。
- [ ] Audio：记录常用 speaker/headset/mic 名称、会议软件选择；Arch 上用 PipeWire/WirePlumber 重新设默认 sink/source。

#### C. 建议只做全盘回滚，不建议手工迁移

- [ ] `~/Library/Keychains`、`~/Library/Accounts`、`~/Library/Group Containers`、`~/Library/Containers`：如果未来可能回到 macOS，用 Time Machine 或加密全盘备份保留；不要把这些当作 Linux 可迁移配置。
- [ ] `~/Library/CloudStorage`、`~/Library/Mobile Documents`：确认云端同步完成；只备份真正离线/未上传文件。
- [ ] 不要备份：`~/.cache`、`~/Library/Caches`、`~/.Trash`、`.zcompdump*`、`~/.zsh_sessions`、浏览器 cache。

### 1.3 Mac 备份执行命令

先接入加密外置盘，设置一个备份根目录：

```sh
backup_root="/Volumes/<ENCRYPTED_DISK>/mac-pre-arch-$(date +%Y%m%d)"
mkdir -p "$backup_root/manifests" "$backup_root/home"
chmod 700 "$backup_root"
```

记录系统、硬件、App 与交互设备状态：

```sh
sw_vers > "$backup_root/manifests/sw_vers.txt"
uname -a > "$backup_root/manifests/uname.txt"
system_profiler SPHardwareDataType SPDisplaysDataType SPAudioDataType SPBluetoothDataType \
  > "$backup_root/manifests/system_profiler-hardware-display-audio-bt.txt"
find "$HOME" -maxdepth 1 -mindepth 1 -print | sort \
  > "$backup_root/manifests/home-top-level.txt"
find "$HOME/.config" -maxdepth 2 -mindepth 1 -print 2>/dev/null | sort \
  > "$backup_root/manifests/dot-config.txt"
```

迁移前再次确认 Git 状态；如果出现输出，先 commit/push/stash，不要 wipe：

```sh
for repo in "$HOME/GitHub/gral" "$HOME/GitHub/star"; do
  echo "== $repo =="
  git -C "$repo" status --short
  git -C "$repo" status --branch --short
done | tee "$backup_root/manifests/git-status.txt"
```

写入本次要复制的 home path 清单：

```sh
cat > "$backup_root/manifests/home-backup-paths.txt" <<'EOF_BACKUP_PATHS'
.ssh
.gnupg
.gitconfig
.gitignore_global
.zshrc
.zprofile
.zshenv
.profile
.bash_profile
.tmux.conf
.vimrc
.vim
.oh-my-zsh
.config/nvim
.config/karabiner
.config/lf
.config/yazi
.config/git
.config/fish
.config/htop
.config/coc
.config/github-copilot
.config/cagent
.config/macmon.json
.claude
.claude.json
.codex
.agents
.cagent
.gemini
.copilot
.cargo
.rustup
.local
.npm
.bun
.docker
.vscode
.vscode-server
.gitnexus
GitHub/gral
GitHub/star
gurobi.lic
Storage
Library/Application Support/Google/Chrome
Library/Preferences/com.google.Chrome.plist
Library/Application Support/Citrix Receiver
Library/Application Support/Citrix Workspace
Library/Preferences/com.citrix.receiver.nomas.plist
Library/Preferences/com.apple.Terminal.plist
Library/Fonts
Library/LaunchAgents
EOF_BACKUP_PATHS
```

用 `ditto` 保留 macOS metadata；缺失路径只记录，不中断：

```sh
while IFS= read -r rel; do
  src="$HOME/$rel"
  dst="$backup_root/home/$rel"
  if [ -e "$src" ]; then
    mkdir -p "$(dirname "$dst")"
    ditto "$src" "$dst"
  else
    echo "missing: ~/$rel" | tee -a "$backup_root/manifests/missing-paths.txt"
  fi
done < "$backup_root/manifests/home-backup-paths.txt"
```

抽样验收备份：

```sh
ls -la "$backup_root/home/.ssh"
ls -la "$backup_root/home/GitHub/gral"
ls -la "$backup_root/home/Library/Application Support/Google/Chrome"
ls -la "$backup_root/home/Library/Application Support/Citrix Workspace"
```

最后做一个回滚级备份：

- [ ] 如果继续保留 macOS：跑 Time Machine 或 APFS/磁盘工具备份，并确认能在另一台机器/恢复环境看到备份。
- [ ] 如果准备 wipe 当前 Mac：先确认 Apple ID、FileVault recovery key、password manager、2FA backup codes、公司 Citrix/MFA 都能在另一台设备上使用。

### 1.4 目标磁盘约定

下面命令里的设备名只是占位：

```sh
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
```

- 系统盘：`/dev/nvme0n1`（实际安装前必须用 `lsblk` 确认）
- EFI 分区：约 1 GiB，FAT32，挂载 `/boot`
- Root：Btrfs，使用 subvolumes
- Swap：优先 `zram`；如果需要 hibernate，再单独设计 swap partition（Btrfs root 内不要随便放 swapfile）

## 2. Arch ISO 启动后：先保证网络

### 2.1 WiFi 连接（ISO 环境）

```sh
loadkeys us
rfkill list
rfkill unblock wifi bluetooth

# 进入 iwd
iwctl
```

在 `iwctl` 里：

```text
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "<SSID>"
exit
```

验证：

```sh
ping -c 3 archlinux.org
timedatectl set-ntp true
timedatectl status
```

### 2.2 更新安装器/密钥

```sh
pacman -Sy archlinux-keyring archinstall
archinstall --version
```

## 3. `archinstall` 选择顺序

启动：

```sh
archinstall
```

推荐选择：

- [ ] Archinstall language：`English`
- [ ] Mirrors：`United States` / `Canada` / `Worldwide`，优先自动测速结果。
- [ ] Locales：
  - Keyboard：`us`
  - Locale：`en_US.UTF-8`
  - 之后手动启用 `zh_CN.UTF-8 UTF-8` 作为可选 locale。
- [ ] Disk configuration：选择目标系统盘，确认会 wipe 的盘 **绝对正确**。
  - Filesystem：`btrfs`
  - Btrfs subvolumes：选择安装器推荐/default layout。
  - Btrfs snapshots：如果菜单存在，选 `Snapper`。
  - Encryption：如果是随身笔记本，建议 LUKS；如果第一轮追求最少变量，可先不加密。
- [ ] Bootloader：选 `GRUB`（为了 `grub-btrfs` 快照启动菜单）。
- [ ] Swap：优先 `zram`；如需 hibernate 另开任务处理。
- [ ] Kernels：`linux` + `linux-lts`（滚动更新后有 fallback）。
- [ ] Profile：`Minimal` / `No profile`。不要选 GNOME/KDE，也先不要让安装器代装完整 Desktop。
- [ ] Audio：`PipeWire`。
- [ ] Network：`NetworkManager`。
- [ ] Additional packages（如果安装器支持空格分隔）：

```text
git neovim sudo zsh tmux fzf openssh rsync curl wget base-devel btrfs-progs snapper snap-pac grub-btrfs inotify-tools networkmanager ufw bluez bluez-utils pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol alsa-utils pamixer sway foot waybar swayidle swaylock wofi mako grim slurp wl-clipboard brightnessctl wlr-randr wev xorg-xwayland xdg-utils xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit usbutils pciutils noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-rime rime-luna-pinyin lf yazi bat eza fd ripgrep jq poppler unzip p7zip unrar highlight python python-pip rustup nodejs npm
```

- [ ] Users：创建普通用户，例如 `shu`，授予 sudo 权限。
- [ ] Root password：可以跳过/禁用 root 登录，日常用 sudo。
- [ ] Timezone：`America/Toronto`。
- [ ] Save configuration：可保存到 U 盘，便于下次复现。
- [ ] Install：最后再次确认磁盘名再继续。

## 4. 首次重启后：最优先三件事

登录普通用户后，先不要折腾 UI，先把网络、Bluetooth、中文输入法跑通。

### 4.1 WiFi / NetworkManager

```sh
sudo systemctl enable --now NetworkManager.service
nmcli radio wifi on
nmcli device status
nmcli device wifi rescan
nmcli device wifi list
sudo nmcli device wifi connect "<SSID>" password "<PASSWORD>"
nmcli connection show
sudo nmcli connection modify "<SSID>" connection.autoconnect yes connection.autoconnect-priority 100
ping -c 3 archlinux.org
```

排错：

```sh
rfkill list
sudo rfkill unblock wifi
journalctl -u NetworkManager -b --no-pager | tail -80
```

验收：

- [ ] 重启后自动连上 WiFi。
- [ ] `nmcli -t -f active,ssid dev wifi | grep '^yes'` 能看到当前 SSID。
- [ ] `ping -c 3 archlinux.org` 成功。

### 4.2 Bluetooth 鼠标 / 音响 / mic 自动连接

安装与服务：

```sh
sudo pacman -S --needed bluez bluez-utils pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol alsa-utils
sudo systemctl enable --now bluetooth.service
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
```

确保适配器默认开机启用：

```sh
sudoedit /etc/bluetooth/main.conf
```

确认或加入：

```ini
[Policy]
AutoEnable=true
```

重启 Bluetooth：

```sh
sudo systemctl restart bluetooth.service
bluetoothctl show
```

配对流程（每个鼠标/音响/headset 都做一次，重点是 `trust`）：

```sh
bluetoothctl
```

在 `bluetoothctl` 里：

```text
power on
agent on
default-agent
scan on
# 等设备出现后，用实际 MAC 替换
pair XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
info XX:XX:XX:XX:XX:XX
scan off
exit
```

如果 BLE 鼠标扫描不到：

```text
menu scan
transport le
back
scan on
```

音频/mic 测试：

```sh
wpctl status
wpctl set-default <speaker-sink-id>
wpctl set-default <mic-source-id>
speaker-test -c 2
arecord -d 5 -f cd /tmp/mic-test.wav && aplay /tmp/mic-test.wav
pavucontrol
```

验收：

- [ ] 重启后 Bluetooth adapter 自动 `Powered: yes`。
- [ ] 鼠标无需手动命令即可重新连接。
- [ ] 音响/headset 打开后会自动连；必要时 `bluetoothctl connect <MAC>` 能立即恢复。
- [ ] `wpctl status` 能看到 Bluetooth sink/source。
- [ ] mic 录音回放正常。

### 4.3 中文输入法（Fcitx5）

安装：

```sh
sudo pacman -S --needed fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-rime rime-luna-pinyin noto-fonts-cjk noto-fonts-emoji
```

设置用户环境变量：

```sh
mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/90-fcitx5.conf <<'EOF_FCITX'
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
EOF_FCITX
```

在 Sway 配置里启动 Fcitx5：

```sh
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
cat >> ~/.config/sway/config <<'EOF_SWAY_FCITX'

# Input method
exec fcitx5 -d
EOF_SWAY_FCITX
```

进入 Sway 后配置：

```sh
fcitx5-configtool
```

- [ ] Add Input Method：添加 `Pinyin`（来自 `fcitx5-chinese-addons`）或 `Rime`。
- [ ] 设置切换键：可先用默认 `Ctrl+Space`，之后再按习惯改。
- [ ] 如果 Rime 首次不可用，重启 `fcitx5` 或重新登录。

验收：

- [ ] `foot` 中能输入中文。
- [ ] `google-chrome-stable` 中能输入中文。
- [ ] `nvim` insert mode 中能输入中文。

### 4.4 键盘 / 鼠标 / 显示器 / Audio 稳定性检查

目标是先把“人机交互层”稳定下来，再继续迁移开发环境。不要等 dotfiles 全部迁完才发现鼠标、mic 或外接屏不可靠。

基础诊断包如果安装阶段漏掉，先补齐：

```sh
sudo pacman -S --needed wev wlr-randr xorg-xwayland xdg-utils usbutils pciutils pamixer pavucontrol
```

检查 Sway 看到的输入与输出：

```sh
swaymsg -t get_inputs
swaymsg -t get_outputs
wlr-randr
wev
```

显示器配置先写最小规则，确认稳定后再细调缩放/位置：

```sh
# 用 swaymsg -t get_outputs 看到的真实 output 名替换 <OUTPUT>
swaymsg output <OUTPUT> enable
swaymsg output <OUTPUT> scale 1
# 示例：swaymsg output HDMI-A-1 mode 2560x1440@60Hz pos 0 0 scale 1
```

键盘/鼠标先保持默认，必要时只加最小规则：

```conf
# ~/.config/sway/config
input type:keyboard {
    xkb_layout us
}
input type:touchpad {
    tap enabled
    natural_scroll enabled
}
```

音频默认设备检查：

```sh
wpctl status
wpctl set-default <speaker-sink-id>
wpctl set-default <mic-source-id>
pamixer --get-volume
pavucontrol
```

验收：

- [ ] 内建键盘/外接键盘按键无错位；必须保留的 Karabiner 改键已有 Sway 替代方案。
- [ ] 鼠标/触控板移动、滚动、点击稳定；重启 Sway 后仍可用。
- [ ] 外接显示器分辨率、刷新率、缩放、左右位置正确；拔插一次后可恢复。
- [ ] speaker/headset/mic 默认设备正确；会议前可用 `wpctl status` 快速确认。

## 5. Btrfs / Snapper / GRUB 快照

### 5.1 检查安装器是否已配置 Snapper

```sh
findmnt /
findmnt /.snapshots || true
sudo btrfs subvolume list /
sudo snapper list-configs || true
sudo snapper -c root list || true
```

如果 `archinstall` 已经创建 `root` 配置，跳到 5.2。

如果没有：

```sh
sudo pacman -S --needed snapper snap-pac grub-btrfs inotify-tools
sudo snapper -c root create-config /
sudo snapper -c root list
```

> 注意：如果 `/.snapshots` 已经是安装器创建的 subvolume，`create-config` 报错时不要硬删。先记录 `findmnt /.snapshots` 和 `sudo btrfs subvolume list /` 输出，再按实际 layout 调整。

### 5.2 自动快照与清理

```sh
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
sudo snapper -c root set-config TIMELINE_CREATE=yes
sudo snapper -c root set-config TIMELINE_LIMIT_HOURLY=10 TIMELINE_LIMIT_DAILY=7 TIMELINE_LIMIT_WEEKLY=4 TIMELINE_LIMIT_MONTHLY=3
sudo snapper -c root set-config NUMBER_LIMIT=50 NUMBER_LIMIT_IMPORTANT=10
```

`pacman` 自动 pre/post 快照由 `snap-pac` 提供。验证：

```sh
sudo pacman -Syu
sudo snapper -c root list | tail -20
```

### 5.3 GRUB 显示快照菜单

```sh
sudo pacman -S --needed grub-btrfs inotify-tools
sudo systemctl enable --now grub-btrfsd.service
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

如果要从 GRUB 进入快照后获得临时可写环境，检查 `mkinitcpio` 使用的是 busybox hook（不是 systemd initramfs），然后把 `grub-btrfs-overlayfs` 加到 `/etc/mkinitcpio.conf` 的 `HOOKS=(...)` 末尾：

```sh
sudoedit /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

验收：

- [ ] `sudo snapper -c root create --description "manual test snapshot"` 后，`sudo snapper -c root list` 能看到快照。
- [ ] 重启进入 GRUB，能看到 Btrfs snapshots 子菜单。
- [ ] 能从某个快照启动救急环境（如启用 overlayfs，则启动后临时可写，但改动不持久）。

### 5.4 升级前手动保险

日常升级用：

```sh
sudo snapper -c root create --description "manual pre-upgrade $(date -Iseconds)"
sudo pacman -Syu
sudo snapper -c root list | tail -20
```

或者让 Snapper 包住单条命令：

```sh
sudo snapper -c root create --command "pacman -Syu"
```

### 5.5 永久回滚骨架（先别盲跑）

先救急：从 GRUB 的 snapshot 菜单进旧系统继续干活。

永久替换 `@` 前必须先确认实际 subvolume 路径：

```sh
# Live USB 启动后
lsblk -f
sudo mount -o subvolid=5 /dev/<ROOT_PARTITION> /mnt
sudo btrfs subvolume list /mnt
ls /mnt
```

典型思路（占位命令，按实际 layout 改）：

```sh
sudo mv /mnt/@ /mnt/@.broken.$(date +%Y%m%d%H%M%S)
sudo btrfs subvolume snapshot /mnt/@snapshots/<SNAPSHOT_ID>/snapshot /mnt/@
sudo umount -R /mnt
reboot
```

## 6. Sway + Foot：最小可用图形层

### 6.1 安装 Wayland/Sway 基础包

```sh
sudo pacman -S --needed sway foot waybar swayidle swaylock wofi mako grim slurp wl-clipboard brightnessctl xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk polkit ttf-jetbrains-mono-nerd noto-fonts-cjk
```

### 6.2 只在需要时启动 Sway

创建启动脚本：

```sh
mkdir -p ~/.local/bin
cat > ~/.local/bin/startsway <<'EOF_STARTSWAY'
#!/bin/sh
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
exec dbus-run-session sway
EOF_STARTSWAY
chmod +x ~/.local/bin/startsway
```

之后从 TTY 登录后运行：

```sh
startsway
```

### 6.3 Foot 基础配置

```sh
mkdir -p ~/.config/foot
cat > ~/.config/foot/foot.ini <<'EOF_FOOT'
[main]
font=JetBrainsMono Nerd Font:size=9
pad=7x7

[colors]
background=282828
foreground=ebdbb2
regular0=282828
regular1=cc241d
regular2=98971a
regular3=d79921
regular4=458588
regular5=b16286
regular6=689d6a
regular7=a89984
bright0=928374
bright1=fb4934
bright2=b8bb26
bright3=fabd2f
bright4=83a598
bright5=d3869b
bright6=8ec07c
bright7=ebdbb2
EOF_FOOT
```

### 6.4 Sway 最小配置片段

先复制默认配置：

```sh
mkdir -p ~/.config/sway
cp /etc/sway/config ~/.config/sway/config
```

追加 gral 风格的最小绑定（后续再把 `i3.conf` 系统迁移过来）：

```sh
cat >> ~/.config/sway/config <<'EOF_SWAY'

# gral minimal Sway layer
set $mod Mod4
set $term foot -e tmux new-session -A -s work
font pango:JetBrainsMono Nerd Font 10

# Environment for portals/screen sharing/input method
exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
exec fcitx5 -d
exec mako

input * {
    xkb_layout us
    repeat_delay 300
    repeat_rate 30
}

# i3-like navigation
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# gral legacy Ctrl+Shift family
bindsym Control+Shift+t exec $term
bindsym Control+Shift+g exec google-chrome-stable
bindsym Control+Shift+f fullscreen toggle
bindsym Control+Shift+space floating toggle
bindsym Control+Shift+s reload
bindsym Control+Shift+q exit
bindsym Control+q kill
bindsym Control+Shift+0 exec sh -c 'mkdir -p "$HOME/Pictures/Screenshots"; grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"'

bar {
    swaybar_command waybar
}
EOF_SWAY
```

验收：

- [ ] TTY 登录后不会自动进图形。
- [ ] `startsway` 能进入 Sway。
- [ ] `Ctrl+Shift+t` 打开 Foot + tmux。
- [ ] `Ctrl+Shift+g` 打开 Chrome。
- [ ] `Ctrl+Shift+0` 可截图。

## 7. Chrome / Citrix Workspace / AUR

### 7.1 Chrome

Chrome 在 AUR：

```sh
sudo pacman -S --needed git base-devel
mkdir -p ~/builds
cd ~/builds
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome
less PKGBUILD
makepkg -si
```

验证：

```sh
google-chrome-stable --version
google-chrome-stable
```

> 如果 Wayland 下缩放/输入法异常，先用默认启动；后续再考虑 Chrome flags，不要第一轮增加变量。

### 7.2 Citrix Workspace（关键工作流）

当前 Mac 上的 Citrix Workspace 是 `26.03.0`。Arch 上不要把 Citrix 放到第一轮基础安装里；等 WiFi、Sway、PipeWire、Chrome 都验收后，再单独装并测试。

优先级：

1. 先确认公司是否允许 Linux Citrix Workspace；有些公司只支持 macOS/Windows，Linux client 即使能装也可能被策略挡住。
2. 如果公司 portal 支持 HTML5/Browser 入口，先用 Chrome 验证 browser fallback。
3. 如果必须 native client，再安装 AUR `icaclient`。

安装骨架：

```sh
sudo pacman -S --needed git base-devel xdg-utils xorg-xwayland gtk3 nss alsa-lib libpulse
mkdir -p ~/builds
cd ~/builds
git clone https://aur.archlinux.org/icaclient.git
cd icaclient
less PKGBUILD
makepkg -si
```

安装后检查 Citrix 自带 requirement checker（路径随版本可能变；不存在就用 `find /opt/Citrix -name checksystem.sh` 找）：

```sh
/opt/Citrix/ICAClient/util/checksystem.sh
/opt/Citrix/ICAClient/selfservice --icaroot /opt/Citrix/ICAClient
```

如果 portal 下载 `.ica` 文件但没有自动打开，先手动验证：

```sh
/opt/Citrix/ICAClient/wfica ~/Downloads/<file>.ica
xdg-mime query filetype ~/Downloads/<file>.ica
xdg-mime default wfica.desktop application/x-ica
```

如果遇到证书信任错误，只处理证书链，不要关闭 TLS 校验：

```sh
sudo cp /path/to/company-ca.crt /opt/Citrix/ICAClient/keystore/cacerts/
sudo /opt/Citrix/ICAClient/util/ctx_rehash
```

Citrix 验收：

- [ ] Chrome browser fallback 可以登录公司 portal。
- [ ] Native Citrix 能打开 Workspace/Store URL。
- [ ] `.ica` 文件能自动或手动用 `wfica` 打开。
- [ ] 远程桌面里键盘布局正确，复制粘贴可用。
- [ ] 远程桌面里 speaker/mic 可被识别；会议软件能选到正确设备。
- [ ] 外接显示器/多屏行为可接受；如果多屏不稳，先固定单屏工作流。

## 8. gral dotfiles 迁移

### 8.1 克隆仓库

```sh
sudo pacman -S --needed git openssh rsync
mkdir -p ~/GitHub ~/builds ~/.config
cd ~/GitHub
git clone https://github.com/shusheaan/gral.git
cd ~/GitHub/gral
```

### 8.2 先手动 link 核心配置

避免第一轮直接跑 `./install` 造成 i3/polybar/alacritty legacy 配置混入。先只 link 当前需要的：

```sh
cd ~/GitHub/gral

ln -sfn "$PWD/zshrc" "$HOME/.zshrc"
ln -sfn "$PWD/tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$PWD/vimrc" "$HOME/.vimrc"

rm -rf "$HOME/.config/nvim"
ln -sfn "$PWD/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/.config/lf"
ln -sfn "$PWD/lf.conf" "$HOME/.config/lf/lfrc"
ln -sfn "$PWD/lfpv.sh" "$HOME/.config/lf/preview.sh"

mkdir -p "$HOME/.config/yazi"
ln -sfn "$PWD/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
ln -sfn "$PWD/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -sfn "$PWD/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

mkdir -p "$HOME/.config/neofetch"
ln -sfn "$PWD/neofetch.conf" "$HOME/.config/neofetch/config.conf"
```

### 8.3 Zsh / Oh My Zsh

```sh
sudo pacman -S --needed zsh fzf zsh-completions zsh-syntax-highlighting zsh-autosuggestions
chsh -s "$(command -v zsh)"

# oh-my-zsh：用 git clone，避免 curl | sh
[ -d ~/.oh-my-zsh ] || git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/plugins ~/.oh-my-zsh/custom/themes
[ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ] || git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -sfn "$HOME/GitHub/gral/custom.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/custom.zsh-theme"
```

> 后续必须清理 `zshrc` 中的 macOS/Gurobi/硬编码 `/Users/shu`、敏感 token、以及最后 `cd ~/GitHub/star/` 这类机器特定内容。

### 8.4 Neovim / tmux / lf / yazi 依赖

```sh
sudo pacman -S --needed neovim tmux lf yazi bat eza fd ripgrep jq poppler unzip p7zip unrar highlight python python-pip nodejs npm rustup gcc make cmake clang gdb
rustup default stable
rustup component add rust-analyzer rust-src
```

首次打开：

```sh
nvim
```

在 Neovim 内检查：

```vim
:Lazy sync
:Mason
:checkhealth
```

### 8.5 AI 配置同步

```sh
cd ~/GitHub/gral
./sync-ai
```

验收：

- [ ] `zsh` 可启动，无明显报错。
- [ ] `tmux new -A -s work` 正常。
- [ ] `nvim` 插件可安装，`Telescope`/LSP 基本可用。
- [ ] `lf`/`yazi` preview 基本可用。
- [ ] `./sync-ai` 能同步 Claude/Codex 配置。

## 9. 防火墙与基础服务

```sh
sudo pacman -S --needed ufw
sudo systemctl enable --now ufw.service
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose
```

常用服务检查：

```sh
systemctl --failed
systemctl --user --failed
journalctl -p 3 -b --no-pager
```

## 10. 已知后续迁移任务

- [ ] 把 `i3.conf` 中真正有用的 keybinding 迁移到 `~/.config/sway/config`。
- [ ] 把 `alacritty.yml` 的 gruvbox/font/padding 转成 `foot.ini`。
- [ ] 更新仓库 `install`：新增 Sway/Foot link，避免默认 link i3/polybar/alacritty。
- [ ] 清理 `zshrc` 里的 macOS-only 环境变量、硬编码路径、敏感 token。
- [ ] 修 `tmux.conf` 中 `/Users/shu/.tmux-branch.sh` 这类 macOS 硬编码。
- [ ] 选择是否安装 `paru`；目前只手动构建 `google-chrome`。
- [ ] 如需要游戏/Steam/Zoom/蓝牙手柄，再单独开任务，不混进首轮系统稳定性。Citrix 已列为关键工作流，但必须在 Chrome/PipeWire/Sway 稳定后单独验收。

## 11. 总验收清单

### 启动与快照

- [ ] GRUB 正常启动 `linux`。
- [ ] GRUB 有 `linux-lts` fallback。
- [ ] `sudo snapper -c root list` 有快照。
- [ ] `sudo pacman -Syu` 前后自动生成 snap-pac 快照。
- [ ] GRUB 能显示 Btrfs snapshots 菜单。

### 网络 / Bluetooth / 中文

- [ ] WiFi 重启自动连接。
- [ ] Bluetooth 鼠标重启自动连接。
- [ ] Bluetooth 音响/headset 可自动或一条命令恢复连接。
- [ ] Bluetooth mic 可录音回放。
- [ ] Fcitx5 中文输入在 Foot、Chrome、Neovim 都可用。

### 图形 / 工作流

- [ ] 默认 TTY 登录。
- [ ] `startsway` 手动进入 Sway。
- [ ] Foot 默认打开 tmux 工作 session。
- [ ] Chrome 可启动。
- [ ] Citrix browser fallback 或 native `icaclient` 至少一种可进入公司远程桌面。
- [ ] 外接显示器、键盘、鼠标、speaker、mic 在日常工作流中稳定。
- [ ] gral dotfiles 已 link，`nvim`/`tmux`/`lf`/`yazi` 可用。

## 12. 参考链接

- Archinstall guided installer: https://archinstall.archlinux.page/installing/guided.html
- Archinstall releases（Btrfs snapshots support）: https://github.com/archlinux/archinstall/releases
- Snapper: https://wiki.archlinux.org/title/Snapper
- `grub-btrfs`: https://man.archlinux.org/man/grub-btrfs.8.en
- `snap-pac`: https://man.archlinux.org/man/extra/snap-pac/snap-pac.8.en
- PipeWire / Bluetooth audio: https://wiki.archlinux.org/title/PipeWire
- Bluetooth: https://wiki.archlinux.org/title/Bluetooth
- XDG Desktop Portal / Sway portal notes: https://wiki.archlinux.org/title/XDG_Desktop_Portal
- Fcitx5 packages: https://archlinux.org/groups/x86_64/fcitx5-im/
- Chinese addons package: https://archlinux.org/packages/extra/x86_64/fcitx5-chinese-addons/
- Google Chrome AUR: https://aur.archlinux.org/packages/google-chrome
- Citrix Workspace app for Linux downloads: https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
- Citrix Workspace app for Linux system requirements: https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/system-requirements.html
- Citrix Workspace app for Linux installation: https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/installation.html
- AUR `icaclient`: https://aur.archlinux.org/packages/icaclient
