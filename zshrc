# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit promptinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode # with vi-mode added in plugin list
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="sammy"

# for vim colorscheme showing in tmux
# problem: using screen-256 color will print the command
# solved: using xterm-256color will be fine
export TERM=xterm-256color

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)
# autoload -U compinit && compinit # run outside

# syntax highlighting
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $ZSH/oh-my-zsh.sh
# source ~/.bash_profile

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim

# auto in tmux work ssh in
if command -v tmux >/dev/null 2>&1; then
  if [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && [ -t 1 ]; then
    exec tmux new-session -A -s work
  fi
fi

# gurobi
export GUROBI_HOME="/Library/gurobi1301/macos_universal2"
export PATH="${GUROBI_HOME}/bin:${PATH}"
export DYLD_LIBRARY_PATH="${GUROBI_HOME}/lib:${DYLD_LIBRARY_PATH}"
export CPATH="${GUROBI_HOME}/include:${CPATH}"
export LIBRARY_PATH="${GUROBI_HOME}/lib:${LIBRARY_PATH}"

# tch-rs
export LIBTORCH=/Users/shu/Library/Python/3.9/lib/python/site-packages/torch
export LIBTORCH_USE_PYTORCH=1
export LIBTORCH_BYPASS_VERSION_CHECK=1
# export DYLD_LIBRARY_PATH="${LIBTORCH}/lib:${DYLD_LIBRARY_PATH}" # segmentation fault for pytest

# python: centralize caches to avoid per-folder pollution
export MYPY_CACHE_DIR="$HOME/.cache/mypy"
export PYTHONPYCACHEPREFIX="$HOME/.cache/pycache"
export RUFF_CACHE_DIR="$HOME/.cache/ruff"

# sys
alias yo='sudo pacman -Syu && neofetch'
alias fl='fdisk -l'
alias refresh='source ~/.zshrc'
alias kb='~/.xmodmap.sh'
alias gc='google-chrome-stable'
alias pm='pulsemixer'
alias bt='bluetoothctl'
alias sus='systemctl suspend'

# fzf, dep, using fzf in lf
# alias f='fo=`find . | fzf`'
# alias ef='echo $fo'
# alias vf='nvim $fo'
# alias cf='cd $fo'
# export FZF_DEFAULT_OPTS="--layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

# tmux
alias tls='tmux ls'
alias tatt='tmux attach -t'
alias tdet='tmux detach -t'
alias ttk='tmux kill-server'
alias ttr='tmux resize-pane -R 20'
alias ttl='tmux resize-pane -L 20'

_tnew_attach() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "=$1"
  else
    tmux attach-session -t "=$1"
  fi
}

tnew() {
  if [ $# -ne 1 ]; then
    echo "usage: tnew <session>" >&2
    return 2
  fi

  local session="$1"
  local -a size_args
  local width="${COLUMNS:-}"
  local height="${LINES:-}"

  size_args=()

  if [ -n "$TMUX" ]; then
    width="$(tmux display-message -p '#{client_width}')" || return
    height="$(tmux display-message -p '#{client_height}')" || return
  fi

  if [[ "$width" = <-> && "$height" = <-> ]]; then
    size_args=(-x "$width" -y "$height")
  fi

  if tmux has-session -t "=$session" 2>/dev/null; then
    _tnew_attach "$session"
    return
  fi

  tmux new-session -d -s "$session" "${size_args[@]}" || return
  _tnew_attach "$session"
}

# workmux
alias wls='workmux ls'
alias wadd='workmux add'
alias wopen='workmux open'
alias wrm='workmux rm --keep-branch'
alias wopen='workmux open'
alias wdb='workmux dashboard'
alias wmerge='workmux merge'

# auto change directory for lf
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
alias lf=lfcd

# dual-monitor setup
# alias monitor-single='xrandr --output HDMI1 --off'
# alias monitor-mini='xrandr --output HDMI1 --off; xrandr --output DP1 --mode 2560x1440'
# alias monitor-game='xrandr --output HDMI1 --off; xrandr --output DP1 --mode 1280x720'
# alias monitor-dual='xrandr --output HDMI1 --mode 2560x1440 --pos 0x0; xrandr --output DP1 --mode 3840x2160 --pos 2560x0'
# alias monitor-dm='xrandr --output HDMI1 --mode 2560x1440 --pos 0x0; xrandr --output DP1 --mode 2560x1440 --pos 2560x0'
alias monitor-dalt='xrandr --output HDMI1 --rotate left --mode 2560x1440 --pos 0x0; xrandr --output DP1 --mode 3840x2160 --pos 1440x150'
alias monitor-dam='xrandr --output HDMI1 --rotate left --mode 2560x1440 --pos 0x0; xrandr --output DP1 --mode 2560x1440 --pos 1440x300'

# autoclick
alias clk='xdotool click --repeat 600 --delay 60000 1'
alias qclk='xdotool click --repeat 600 --delay 5000 1'

# cargo test
alias ct='cargo test -- --nocapture'
alias cb='cargo build && rust-gdb $PWD/target/debug/$(basename "$PWD") --silent'
export RUST_BACKTRACE=full

# julia
alias jl='julia --project=.'

# cmatrix
alias cm='cmatrix -C cyan'

# utrp
alias utrp='~/downloads/utrp'

# mute/unmute
alias mute='amixer set Capture nocap'
alias unmute='amixer set Capture cap'

# citrix
alias citrix='/opt/Citrix/ICAClient/wfica'

# cliclick
alias clk='watch -n 55 cliclick c:800,800'
alias qclk='watch -n 5 cliclick c:1000,500'

# claude-code
alias cc='claude'
alias ca='claude agents'

# influx db token
export INFLUXDB_TOKEN=s4pUaWzvwLeU1L0TF7EtvQuUwc16Y4voU8X4GQcrFo4f0CCdtRBhBzMKnpJROj0AdStJW7jmYN6g67xsC72OTg==

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/shu/.bun/_bun" ] && source "/Users/shu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# r2
export R2_ACCOUNT_ID="9247b5c66f294ba9e3a6e3a959653387"
export R2_BUCKET="star-dvc"
export R2_ACCESS_KEY_ID="4e4012d720ceddd50cb2a535771aa322"
export R2_SECRET_ACCESS_KEY="7b5eaab6862683a8b848d6f452c2df711c712893975e7dd128ef66e01c7df1d7"

# starting dir
cd ~/GitHub/star/
