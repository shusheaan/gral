# Arch post-install hardware check

目标：新电脑已经完成 `archinstall`、第一次登录、`./arch/install.sh`、退出并重新登录之后，用一套可重复流程确认机器本身健康：主板/BIOS、CPU、RAM、GPU、NVMe/SSD、网络、蓝牙、音频、屏幕、键盘触控板、USB/显示输出都正常。

原则：先证明 **stock BIOS/default 设置稳定**，再开 EXPO/XMP、PBO/undervolt、独显高级设置等优化；每改一次硬件/BIOS 参数，都重跑至少 CPU/RAM + GPU + kernel log 检查。

## 文件分工

- `arch/check.md`：验机流程、通过标准、人工 checklist。
- `arch/check-tools.txt`：只用于验机的临时 pacman 包；不进入 `arch/packages.txt` baseline。
- `arch/hardware-check.sh`：自动采集硬件信息、SMART、kernel log，并跑 CPU/RAM、fio、GPU 压力测试。

## 0. 前置状态

确认已经完成：

```sh
cd ~/work/gral
./arch/install.sh
exit
# 重新登录一次；需要 GPU 图形测试时手动进入 Sway
sway
```

GPU 测试建议在 Sway/Foot 里跑；纯 TTY 下仍可跑 inventory、SMART、CPU/RAM、fio，但 `glmark2-wayland` 不一定能跑。

## 1. 安装临时验机工具

只安装一次：

```sh
cd ~/work/gral
./arch/hardware-check.sh --install-tools-only
```

等价手动命令：

```sh
awk 'NF && $1 !~ /^#/ { print $1 }' arch/check-tools.txt | xargs sudo pacman -Syu --needed
```

这些包是临时验机工具，和长期工作环境分开管理。验机完成后如果想清理：

```sh
awk 'NF && $1 !~ /^#/ { print $1 }' arch/check-tools.txt | xargs sudo pacman -Rns
```

如果你想长期保留 `smartmontools`、`nvme-cli` 或 `fio`，清理时从列表里手动排除。若已经把 MemTest86+ 写进 GRUB 菜单，清理后再运行一次 `sudo grub-mkconfig -o /boot/grub/grub.cfg`。

## 2. 自动全量测试

推荐第一次收机/新装后跑：

```sh
cd ~/work/gral
./arch/hardware-check.sh --full --smart-short
```

默认会生成报告目录：

```text
~/hardware-checks/YYYYmmdd-HHMMSS-hostname/
```

默认测试内容：

- 硬件枚举：`lscpu`、`lsblk`、`lspci -nnk`、`lsusb`、`dmidecode`、`sensors`。
- kernel log：测试前后抓 `dmesg`、`journalctl`，并 grep 硬件红旗。
- 存储健康：`nvme smart-log`、`smartctl -x`，可选 SMART short self-test。
- CPU/RAM：`stress-ng --cpu 0 --vm 1 --vm-bytes 70% --verify` 默认 20 分钟。
- Linux 内存测试：`memtester` 默认使用约 50% available memory 跑 1 pass。
- 存储读写：`fio` 默认 4G、5 分钟、文件级 randrw + CRC verify，非破坏性。
- GPU：`glxinfo -B`、`vulkaninfo --summary`、`glmark2-wayland --run-forever` 默认 10 分钟。

快速 smoke test：

```sh
./arch/hardware-check.sh --quick
```

只采集不压测：

```sh
./arch/hardware-check.sh --collect-only
```

手动调长测试：

```sh
GRAL_CHECK_CPU_MINUTES=60 \
GRAL_CHECK_GPU_MINUTES=30 \
GRAL_CHECK_FIO_MINUTES=15 \
GRAL_CHECK_FIO_SIZE=16G \
./arch/hardware-check.sh --full --smart-short
```

如果想跳过 `memtester`：

```sh
./arch/hardware-check.sh --full --memtester-mb 0
```

如果想指定 `memtester` 大小：

```sh
./arch/hardware-check.sh --full --memtester-mb 8192
```

## 3. 自动报告怎么看

先看：

```sh
latest=$(ls -td ~/hardware-checks/* | head -1)
less "$latest/summary.md"
less "$latest/failures.txt"
less "$latest/red-flags-summary.log"
```

再重点看这些 log：

```sh
less "$latest/kernel_red-flags-before.log"
less "$latest/kernel_red-flags-after.log"
less "$latest/sensors-monitor.log"
less "$latest/storage_nvme-smart-nvme0.log"
less "$latest/storage_smartctl-x-nvme0n1.log"
less "$latest/stress_stress-ng-cpu-vm.log"
less "$latest/gpu_glmark2-wayland.log"
```

不同机器设备名可能不同，用 `ls "$latest"` 找对应文件。

### 必须通过的硬标准

以下任意出现，新机现场就不要收，或者至少要求换机/换件后重测：

- 自动测试期间死机、重启、黑屏、GPU session 崩溃。
- `stress-ng` verify 失败。
- `memtester` 报 memory failure。
- `fio` verify 失败或出现 I/O error。
- NVMe/SSD 出现：`critical_warning != 0`、`media_errors != 0`、新盘明显非零 error log。
- kernel log 出现：`MCE`、`Machine Check`、`Hardware Error`、`EDAC` memory error、`I/O error`、`nvme reset`、`PCIe AER fatal`、`GPU HANG`、`NVRM Xid`、thermal shutdown。
- 压力测试下 CPU/GPU/NVMe 温度持续超过硬件临界值，或频繁 severe throttling。

### 可接受但要记录

- `journalctl` 里有少量 harmless firmware warning，但测试前后没有增加、没有功能异常。
- `sensors` 看不到某些风扇：很多笔记本/主板不会暴露所有 PWM/RPM。
- `glxinfo` 在纯 Wayland 下信息有限；以 `vulkaninfo`、`glmark2-wayland` 和 kernel log 为主。

## 4. 离线 RAM 测试：MemTest86+

Linux 里的 `stress-ng` / `memtester` 不能完全替代离线内存测试。新机或新内存建议至少跑 1 full pass，最好过夜。

安装工具已经包含 `memtest86+-efi`。把它加进 GRUB 菜单：

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

重启后在 GRUB 里选择 MemTest86+，至少跑：

```text
1 full pass：现场最低要求
overnight：回家长测，尤其是大内存/EXPO/XMP 后
```

任何 error 都不接受。若 stock 设置有 error，换内存/主板/CPU；若只在 EXPO/XMP 后有 error，说明该内存频率/时序/电压对这套平台不稳。

## 5. 人工硬件 checklist

自动脚本无法替你插拔端口、听声音、看屏幕。全量验机必须手测。

### BIOS / firmware / 基础信息

- [ ] BIOS/UEFI 能正常进入；时间、CPU、RAM、SSD 容量识别正确。
- [ ] 暂时关闭 EXPO/XMP/PBO/undervolt 等调参，用 stock 跑第一轮测试。
- [ ] 确认 Secure Boot、TPM、virtualization 设置符合你的需要。
- [ ] 若卖家/厂商现场允许，确认 BIOS 版本不是明显异常旧版；不要现场刷 BIOS，除非必须且有稳定供电。

### CPU / 散热 / 风扇

- [ ] `sensors` 能看到 CPU 温度。
- [ ] `stress-ng` 期间风扇会升速，温度能稳定在合理范围。
- [ ] 压测结束后温度能回落。
- [ ] 没有异响、啸叫、风扇刮擦。

### RAM

- [ ] `free -h` / `dmidecode -t memory` 容量、slot、频率大致符合购买配置。
- [ ] `memtester` 无 error。
- [ ] MemTest86+ 至少 1 full pass 无 error。

### GPU / 显示

- [ ] `lspci -nnk` 识别正确 GPU 和 driver。
- [ ] `vulkaninfo --summary` 能看到正确 GPU。
- [ ] `glmark2-wayland` 跑完没有黑屏、闪退、GPU reset。
- [ ] 外接显示器每个 HDMI/DP/USB-C DP Alt Mode 都测一次。
- [ ] 高刷新率用 `swaymsg -t get_outputs` / `wlr-randr` 能看到，并实际设置成功。
- [ ] 屏幕无明显坏点、亮斑、闪烁、异常色偏。

### NVMe / SSD

- [ ] `lsblk` 型号、容量符合购买配置。
- [ ] `nvme smart-log` / `smartctl -x` 无 media error、critical warning。
- [ ] `fio` 没有 verify failure / I/O error。
- [ ] 压测时 NVMe 温度不过热；没有反复 reset。

### 网络 / 蓝牙

- [ ] WiFi 能连接 2.4GHz/5GHz/6GHz 中你需要的网络。
- [ ] 下载大文件或 `pacman -Syu` 不掉线。
- [ ] Bluetooth 鼠标/键盘/耳机可配对、断开、重连。
- [ ] Tailscale 登录后从手机 Termius 能 SSH 回来。

### USB / Thunderbolt / 读卡器

- [ ] 每个 USB-A / USB-C 口都插 U 盘或 hub 测一次。
- [ ] USB-C 充电、视频输出、数据传输分别确认。
- [ ] 如果有 Thunderbolt/USB4，确认设备识别和热插拔。
- [ ] 如果有 SD/microSD 读卡器，确认读写。

### 音频 / 麦克风 / 摄像头

```sh
wpctl status
speaker-test -c 2 -t wav
arecord -l
```

- [ ] 内置扬声器左右声道正常。
- [ ] 3.5mm / USB-C / Bluetooth 耳机输出正常。
- [ ] 内置麦克风、外接麦克风能录音。
- [ ] 摄像头能被浏览器或测试页面识别。

### 键盘 / 触控板 / 电源

- [ ] 所有常用键、Fn、亮度、音量、Super/Mod 都正常。
- [ ] 触控板移动、点击、双指滚动正常。
- [ ] 合盖/开盖、睡眠/唤醒按你的预期工作。
- [ ] 电源适配器、USB-C PD、充电指示正常。
- [ ] 电池机器看 `upower -d` 或桌面电量显示，确认容量/充放电没有异常。

## 6. 验机节奏建议

现场时间有限：

```text
1. install.sh 完成并重新登录
2. 安装 check-tools
3. ./arch/hardware-check.sh --quick --smart-short
4. 手测屏幕、键盘、触控板、WiFi、蓝牙、USB、音频、外接显示
5. 看 failures.txt / red-flags-summary.log / kernel red-flags
```

回家长测：

```text
1. ./arch/hardware-check.sh --full --smart-short
2. MemTest86+ overnight
3. 如果要开 EXPO/XMP/PBO/undervolt，开启后重复 full test + MemTest86+
```

## 7. 参考

- ArchWiki: Stress testing — https://wiki.archlinux.org/title/Stress_testing
- ArchWiki: Benchmarking — https://wiki.archlinux.org/title/Benchmarking
- ArchWiki: lm_sensors — https://wiki.archlinux.org/title/Lm_sensors
- ArchWiki: Solid state drive/NVMe — https://wiki.archlinux.org/title/Solid_state_drive/NVMe
