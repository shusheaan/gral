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
    if [ "$(id -u)" -eq 0 ]; then
        pacman -Syu --needed "${packages[@]}"
    else
        sudo pacman -Syu --needed "${packages[@]}"
    fi
}

install_packages

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
link_managed_path "$ARCH/bin/whisper-dictation-setup" "$HOME/.local/bin/whisper-dictation-setup"
link_managed_path "$ARCH/bin/whisper-dictation-toggle" "$HOME/.local/bin/whisper-dictation-toggle"

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
link_managed_path "$ARCH/mako/config" "$HOME/.config/mako/config"
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

cat <<MSG
Installed Arch package list and linked dotfiles from ./arch.
Next:
  1. source ~/.zprofile
  2. test terminal tools: zsh, tmux, nvim, lf
  3. log out/in if chsh changed your shell
  4. start GUI manually when needed: sway
MSG
