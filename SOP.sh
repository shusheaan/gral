# boot from flash disk as root@archiso
iwctl # iwd for wifi, ping to check
timedatectl set-ntp true # timedatectl status

# get partition and file systems ready in local disk
fdisk /dev/<nv...> # gbt table, 3 partitions, mpigntdw
fdisk -l # check table and partition types, p1 512M EFI, p2 8G swap (=RAM req by steam)

# TODO: extra ssd, one partition, linux filesystem, automount setting? mount under home

mkfs.ext4 /dev/<nv...p3> && mkswap /dev/<nv...p2> && mkfs.fat -F 32 /dev/<nv...p1>
mount /dev/<nv...p3> /mnt && swapon /dev/<nv...p2> && mount --mkdir /dev/<nv...p1> /mnt/boot
# debugging note: `sudo fsck /dev/<...>` to check file system in recovery mode if cannot boot
lsblk # check mounting points and swap

# installation and basic configs
vim /etc/pacman.d/mirrorlist # check/edit mirrors
pacman -Sy archlinux-keyring # package signiture issue, keyring pkg out-of-date
# https://wiki.archlinux.org/title/Pacman/Package_signing#Upgrade_system_regularly
pacstrap /mnt base linux linux-firmware sudo neovim git man-db man-pages tldr networkmanager
genfstab -U /mnt >> /mnt/etc/fstab # use unique UUID
arch-chroot /mnt # now in root dir as root
timedatectl set-timezone America/New_York # timedatectl list-timezones; 
hwclock --systohc # generate /etc/adjtime
nvim /etc/locale.gen # uncomment en_US.UTF-8 UTF-8
locale-gen
nvim /etc/locale.conf # add LANG=en_US.UTF-8
nvim /etc/hostname
passwd

# grub, nmcli, and add sudo user
pacman -S grub efibootmgr # efibootmgr for grub
mount --mkdir /dev/<nv...p1> /boot/efi # ignore fstab warnings
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m <username> && passwd <username> # --create-home
# sudo -lU <username> # check sudo privilege
usermod -aG wheel <username> # --append --groups 
nvim /etc/sudoers # uncomment %wheel ALL=(ALL) ALL
exit # check pwd at /
umount -R /mnt && reboot

# log in as normal user
sudo systemctl start NetworkManager.service # run status to check
sudo systemctl enable NetworkManager.service # auto connect
# nmcli device wifi list # show available wifi
# `rfkill list` and `rfkill unblock ...` if `nmcli device` shows unavailable
sudo nmcli device wifi connect <wifi_name> password <wifi_password> # ping
sudo pacman -Syu
sudo pacman -S neofetch && neofetch # enjoy

# essentials
# rmdir nl whereis locate find chmod df du free ln diff date grep wc ps watch
# sudo pacman -Q | less # explicitly installed pacman -Qe
sudo pacman -S htop zsh fzf tmux zip unzip curl wget yarn alacritty base-devel cmake clang gdb rustup julia coin-or-cbc
sudo pacman -S xorg xorg-xinit xorg-xmodmap xcape xclip i3-wm polybar scrot ttf-dejavu cantarell-fonts wqy-zenhei
sudo pacman -S exa bat highlight ripgrep procs pulseaudio pulseaudio-alsa pulsemixer # pulseaudio-bluetooth

# echo $SHELL # current # cat /etc/shells # installed shells
chsh -s /bin/zsh # zsh as default shell
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh # sammy
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# aur: chrome, lf, in $HOME/builds
git clone https://aur.archlinux.org/<pkg_name>.git && cd <pkg_name>
makepkg -si # provided by pacman, check content of PKGBUILD before this
# if asking for dependencies, use -s/--syncdeps and check pkg list
#   build, then sudo pacman -U <pkg_name>...zst to install

# deploy .files, in $HOME/repos
git clone https://github.com/shusheaan/gral # under ~/repos, cd, and ./install 
git config --global credential.helper store # store email, username, editor, and token (for repo)
# may need to reset timezone again
# deploy vimrc, install https://github.com/junegunn/vim-plug and :PlugInstall

# rust + coc.nvim
rustup default stable
rustup component add rust-analysis rust-src
# :CocInstall coc-rust-analyzer # allow coc to install rust-analyzer

# laptop hardware
# scrolling backlight see section in polybar config file
# trackpad:
#   sudo nvim /usr/share/X11/xorg.conf.d/40-libinput.conf
#   add Option "NaturalScrolling" "on"; Option "Tapping" "on";
#   Option "TappingDrag" "on" to touchpad sections

# steam
sudo vim /etc/pacman.conf # comment out multilib section
sudo pacman -Syu # update/sync 32bit database
sudo pacman -S xf86-video-intel mesa lib32-mesa lib32-systemd vulkan-intel lib32-vulkan-intel
sudo pacman -S wine wine-mono wqy-zenhei steam # use default providers
# reboot, proton will be installed by 'enable for all other titles'
# runtime wine/proton issue, crash immediately, solved: swap req
# screen tearing: https://wiki.archlinux.org/title/intel_graphics#Tearing

# xpadneo and bluetoothctl, power scan trust pair connect
pacman -S bluez bluez-utils dkms linux-headers
sudo modprobe btusb # load the kernel module btusb
sudo systemctl start bluetooth.service && sudo systemctl enable bluetooth.service
sudo vim /etc/bluetooth/main.conf # AutoEnable=true and DiscoverableTimeout=0
git clone https://github.com/atar-axis/xpadneo.git && cd xpadneo
sudo ./install.sh # with dkms, then bluetoothctl
