# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit
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
export TERM=tmux-256color

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

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
HISTFILE=~/.cache/zsh/history

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
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

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# sys
alias yo='sudo pacman -Syu && neofetch'
alias fl='fdisk -l'
alias refresh='source ~/.zshrc'
alias la='exa -la'
alias lla='exa --long --tree'
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
alias tta='tmux attach -t'
alias ttk='tmux kill-server'
alias ttr='tmux resize-pane -R 20'
alias ttl='tmux resize-pane -L 20'

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

# dua-monitor setup
alias monitor-single='xrandr --output HDMI1 --off'
alias monitor-mini='xrandr --output HDMI1 --off; xrandr --output DP1 --mode 2560x1440'
alias monitor-dual='xrandr --output HDMI1 --mode 2560x1440 --pos 0x0; xrandr --output DP1 --mode 3840x2160 --pos 2560x0'

# autoclick
alias autoclick='xdotool click --repeat 600 --delay 60000 1'

# cargo test
alias ct='cargo test -- --nocapture | less'
alias cb='cargo build && rust-gdb $PWD/target/debug/$(basename "$PWD") --silent'

# julia
alias jl='julia --project=.'
