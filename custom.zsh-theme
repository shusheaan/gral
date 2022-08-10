if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg_bold[$NCOLOR]%}%n%{$reset_color%}@%{$fg_bold[cyan]%}%m\
%{$reset_color%}:%{$fg_bold[magenta]%}%~\
$(git_prompt_info) \
%{$fg_bold[cyan]%}%(!.# %{$reset_color%} '
PROMPT2='%{$fg_bold[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}~%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[yellow]%})%{$reset_color%}"
