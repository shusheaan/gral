#!/usr/bin/env zsh
set -euo pipefail

# First reboot setup for Arch Linux.
# Run from the cloned gral repo after archinstall and first login:
#   cd ~/work/gral
#   ./arch/install.sh

ARCH="${0:A:h}"
GRAL="${ARCH:h}"

link_managed_path() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sfn "$source" "$target"
}

append_once() {
    local target="$1"
    local marker="$2"
    local body="$3"

    touch "$target"
    if ! grep -qF "$marker" "$target"; then
        printf '\n%s\n' "$body" >> "$target"
    fi
}

if [ "$(uname -s)" != "Linux" ]; then
    echo "arch/install.sh is for Arch/Linux only. Use ./mac/install on macOS."
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    echo "Run arch/install.sh as your normal user, not root. It uses sudo for pacman and links user dotfiles."
    exit 1
fi

install_packages() {
    local package_file="$ARCH/packages.txt"
    local -a packages

    if [ "${GRAL_SKIP_PACKAGES:-0}" = "1" ]; then
        echo "Skipping pacman package install because GRAL_SKIP_PACKAGES=1."
        return
    fi

    if [ ! -r "$package_file" ]; then
        echo "Package list not found: $package_file"
        return 1
    fi

    if ! command -v pacman >/dev/null 2>&1; then
        echo "pacman not found; package install is only available on Arch."
        return 1
    fi

    packages=("${(@f)$(awk 'NF && $1 !~ /^#/ { print $1 }' "$package_file")}")
    if [ ${#packages[@]} -eq 0 ]; then
        echo "No packages found in $package_file"
        return 1
    fi

    echo "Installing ${#packages[@]} packages from $package_file"
    sudo pacman -Syu --needed "${packages[@]}"
}


install_system_policy() {
    local logind_conf="$ARCH/systemd/logind.conf.d/10-gral-session.conf"

    if [ -r "$logind_conf" ]; then
        sudo install -Dm644 "$logind_conf" /etc/systemd/logind.conf.d/10-gral-session.conf
        sudo systemctl reload systemd-logind.service 2>/dev/null || \
            echo "systemd-logind reload failed; reboot will apply /etc/systemd/logind.conf.d/10-gral-session.conf"
    fi
}

enable_system_services() {
    if command -v systemctl >/dev/null 2>&1; then
        sudo systemctl enable --now NetworkManager.service || true
        sudo systemctl enable --now bluetooth.service || true
        sudo systemctl enable --now sshd.service || true
        sudo systemctl enable --now tailscaled.service || true
    fi

    if command -v loginctl >/dev/null 2>&1; then
        sudo loginctl enable-linger "$USER" || true
    fi
}

warm_neovim() {
    if [ "${GRAL_SKIP_NVIM_BOOTSTRAP:-0}" = "1" ]; then
        echo "Skipping Neovim bootstrap because GRAL_SKIP_NVIM_BOOTSTRAP=1."
        return
    fi

    if ! command -v nvim >/dev/null 2>&1; then
        echo "nvim not found; skipping Neovim bootstrap."
        return
    fi

    echo "Bootstrapping Neovim plugins and Mason tools."
    nvim --headless "+Lazy! sync" +qa
    nvim --headless "+MasonUpdate" +qa || true
}

install_packages
install_system_policy
enable_system_services

# Bare zsh as login shell; no Oh My Zsh on the Arch baseline.
if command -v zsh >/dev/null 2>&1; then
    zsh_path="$(command -v zsh)"
    if [ "${SHELL:-}" != "$zsh_path" ] && command -v chsh >/dev/null 2>&1; then
        chsh -s "$zsh_path" || echo "chsh failed; run manually: chsh -s $zsh_path"
    fi
fi

# Shell / terminal session.
link_managed_path "$ARCH/zshrc" "$HOME/.zshrc"
link_managed_path "$ARCH/tmux.conf" "$HOME/.tmux.conf"
link_managed_path "$ARCH/tmux-system-status.sh" "$HOME/.local/bin/tmux-system-status.sh"
link_managed_path "$ARCH/bin/sway-workbench-layout" "$HOME/.local/bin/sway-workbench-layout"
link_managed_path "$ARCH/bin/audio-output" "$HOME/.local/bin/audio-output"
link_managed_path "$ARCH/bin/whisper-dictation-setup" "$HOME/.local/bin/whisper-dictation-setup"
link_managed_path "$ARCH/bin/whisper-dictation-toggle" "$HOME/.local/bin/whisper-dictation-toggle"

# SSH client config for GitHub / RunPod-style remote hosts.
install -d -m 700 "$HOME/.ssh"
link_managed_path "$ARCH/ssh/config" "$HOME/.ssh/config"
chmod 700 "$HOME/.ssh"

# Vim / Neovim.
link_managed_path "$GRAL/nvim/vimrc" "$HOME/.vimrc"
link_managed_path "$GRAL/nvim" "$HOME/.config/nvim"

# TUI file manager configs stay shared from repo root for now.
link_managed_path "$GRAL/lf/lfrc" "$HOME/.config/lf/lfrc"
link_managed_path "$GRAL/lf/preview.sh" "$HOME/.config/lf/preview.sh"
link_managed_path "$GRAL/lf/pv.sh" "$HOME/.config/lf/pv.sh"

# Minimal Wayland GUI layer.
link_managed_path "$ARCH/sway/config" "$HOME/.config/sway/config"
link_managed_path "$ARCH/foot/foot.ini" "$HOME/.config/foot/foot.ini"
link_managed_path "$ARCH/fcitx5/config" "$HOME/.config/fcitx5/config"
link_managed_path "$ARCH/mako/config" "$HOME/.config/mako/config"
sudo install -Dm644 "$ARCH/chromium/policies/managed/10-gral-extensions.json" /etc/chromium/policies/managed/10-gral-extensions.json
for env_file in "$ARCH"/environment.d/*.conf(N); do
    link_managed_path "$env_file" "$HOME/.config/environment.d/${env_file:t}"
done

# Shared Claude/Codex AI config.
"$GRAL/sync-ai"

# Legacy/reference configs copied for convenience, not central to the Arch flow.

# Local TTY login: type plain `sway` to start the Wayland session.
append_once "$HOME/.zprofile" "# BEGIN GRAL ARCH SWAY ENV" '# BEGIN GRAL ARCH SWAY ENV
# Export simple KEY=VALUE files such as ~/.config/environment.d/90-fcitx5.conf.
for env_file in "$HOME"/.config/environment.d/*.conf(N); do
    set -a
    . "$env_file"
    set +a
done

if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ] && [ -n "${XDG_VTNR:-}" ]; then
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
fi
# END GRAL ARCH SWAY ENV'

# Rust baseline after archinstall packages are present.
if command -v rustup >/dev/null 2>&1; then
    rustup default stable
    rustup component add rust-analyzer rust-src
fi

# User services: these are no-ops if services are unavailable; package installation stays in arch/readme.md §3.
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service || true
fi

warm_neovim

cat <<MSG
Installed Arch package list and linked dotfiles from ./arch.
Chromium baseline: official pacman package plus managed extension policy.
Next:
  1. Log out of this TTY, then log back in once so ~/.zprofile and the zsh login shell are clean.
  2. Start GUI manually when needed: sway
  3. Sway should auto-start Foot/tmux and Chromium.
  4. Neovim plugins and Mason-managed LSP tools have been bootstrapped unless GRAL_SKIP_NVIM_BOOTSTRAP=1.
  5. Mod+Shift+Q exits Sway back to the TTY login prompt; tmux sessions stay detached.
  6. SSH is enabled; attach from another device with: tmux attach -t work
  7. Tailscale daemon is enabled; authenticate once with: sudo tailscale up --operator="$USER" --qr
  8. In Tailscale admin, disable key expiry for this machine.
  9. After Termius-over-Tailscale works, restrict SSH to tailscale0 with UFW per arch/readme.md.
MSG
