#!/usr/bin/env bash
set -euo pipefail

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[err]\033[0m %s\n' "$*" >&2; }

BREW_PACKAGES=(
  git
  htop
  fzf
  lf
  neovim
  node
  watch
  cliclick
  wget
  bat
  eza
  jq
  poppler
  typst
  cmake  
  sdl2
  ffmpeg
  pipx
)

OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

append_block_if_missing() {
  local file="$1"
  local start_marker="$2"
  local end_marker="$3"
  local block="$4"

  mkdir -p "$(dirname "$file")"
  touch "$file"

  if ! grep -Fq "$start_marker" "$file"; then
    {
      printf '\n%s\n' "$start_marker"
      printf '%s\n' "$block"
      printf '%s\n' "$end_marker"
    } >> "$file"
    ok "Updated $file"
  else
    ok "Block already present in $file"
  fi
}

clone_or_update_plugin() {
  local repo_url="$1"
  local target_dir="$2"

  if [[ -d "$target_dir/.git" ]]; then
    log "Updating plugin: $target_dir"
    git -C "$target_dir" pull --ff-only
  else
    log "Cloning plugin: $repo_url"
    git clone --depth=1 "$repo_url" "$target_dir"
  fi
}

replace_or_append_plugins_line() {
  local zshrc="$1"
  local plugins_line='plugins=(git zsh-completions zsh-syntax-highlighting zsh-autosuggestions)'

  touch "$zshrc"

  if grep -qE '^[[:space:]]*plugins=' "$zshrc"; then
    # macOS BSD sed
    sed -i '' -E "s|^[[:space:]]*plugins=.*|$plugins_line|" "$zshrc"
    ok "Patched plugins line in $zshrc"
  else
    {
      printf '\n# Plugins managed by bootstrap_macos_cli.sh\n'
      printf '%s\n' "$plugins_line"
    } >> "$zshrc"
    ok "Added plugins line to $zshrc"
  fi
}

main() {
  log "Checking Apple Command Line Tools..."
  if ! xcode-select -p >/dev/null 2>&1; then
    warn "Apple Command Line Tools not found."
    warn "Triggering installer now..."
    xcode-select --install || true
    warn "Please finish the Apple Command Line Tools installation, then rerun this script."
    exit 1
  fi
  ok "Apple Command Line Tools detected"

  log "Installing Homebrew if needed..."
  if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  log "Loading Homebrew into current shell..."
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    BREW_BIN="/usr/local/bin/brew"
  else
    err "Homebrew was not found after installation."
    exit 1
  fi
  ok "Using Homebrew at: $BREW_BIN"

  append_block_if_missing \
    "$HOME/.zprofile" \
    "# >>> bootstrap_macos_cli: brew >>>" \
    "# <<< bootstrap_macos_cli: brew <<<" \
'if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi'

  log "Updating Homebrew metadata..."
  brew update

  log "Installing CLI packages..."
  brew install "${BREW_PACKAGES[@]}"
  ok "CLI packages installed"

  log "Installing Oh My Zsh if needed..."
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL "$OMZ_INSTALL_URL")" "" --unattended
    ok "Oh My Zsh installed"
  else
    ok "Oh My Zsh already installed"
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$zsh_custom/plugins"

  clone_or_update_plugin \
    "https://github.com/zsh-users/zsh-completions" \
    "$zsh_custom/plugins/zsh-completions"

  clone_or_update_plugin \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$zsh_custom/plugins/zsh-syntax-highlighting"

  clone_or_update_plugin \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$zsh_custom/plugins/zsh-autosuggestions"

  if [[ ! -f "$HOME/.zshrc" && -f "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" ]]; then
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    ok "Created ~/.zshrc from Oh My Zsh template"
  fi

  replace_or_append_plugins_line "$HOME/.zshrc"

  # Optional: make `code` available if VS Code.app exists
  if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
    append_block_if_missing \
      "$HOME/.zprofile" \
      "# >>> bootstrap_macos_cli: vscode-code >>>" \
      "# <<< bootstrap_macos_cli: vscode-code <<<" \
'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"'
    ok "VS Code 'code' command path added to ~/.zprofile"
  else
    warn "VS Code.app not found in /Applications; skipped adding 'code' to PATH"
  fi

  log "Bootstrap complete."
  cat <<'EOF'

Next steps:
  1) Restart Terminal / VS Code terminal, or run:
       exec zsh

  2) Verify:
       brew --version
       zsh --version
       nvim --version
       lf -version || lf --version
       node --version
       code --version   # only if VS Code is installed

  3) Then clone your dotfiles repo yourself:
       git clone <YOUR_DOTFILES_REPO_URL> ~/dotfiles

  4) Enter your repo and run your own installer:
       cd ~/dotfiles
       ./install
     (If your own script requires sudo, then run it the way your repo expects.)

EOF
}

main "$@"