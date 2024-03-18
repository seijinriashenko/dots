# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## History settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTDUP=erase

## Enable colors
autoload -U colors && colors	# Load colors
stty stop undef		            # Disable ctrl-s to freeze terminal.

## Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
zmodload zsh/complist
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)		# Include hidden files.

## Un-/set options
setopt autocd
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt interactive_comments
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt prompt_subst

unsetopt beep

## Bind keys
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


## Git Settings
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git:*' stagedstr "+ "
zstyle ':vcs_info:git:*' unstagedstr "✗ "
zstyle ':vcs_info:git:*' formats "%{$fg_bold[blue]%}%s:(%{$fg_bold[red]%}%b%{$fg_bold[blue]%}) %{$fg_bold[yellow]%}%u%{$fg_bold[yellow]%}%c"
# zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
#
# +vi-git-untracked() {
#   if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#      git status --porcelain | grep -m 1 '^??' &>/dev/null
#   then
#     hook_com[misc]='?'
#   fi
# }
#
# function +vi-git-st() {
#     local ahead behind
#     local -a gitstatus
#
#     # for git prior to 1.7
#     # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
#     ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
#     (( $ahead )) && \
#         # gitstatus+=( "+${ahead}" )
#         gitstatus+=( "↑" )
#
#     # for git prior to 1.7
#     # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
#     behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
#     (( $behind )) && \
#         # gitstatus+=( "-${behind}" )
#         gitstatus+=( "↓" )
#
#     hook_com[misc]+=${(j:/:)gitstatus}
# }

## Prompt
PROMPT='%{$fg_bold[yellow]%}%c%{$reset_color%} ${vcs_info_msg_0_}%(?:%{$fg_bold[blue]%}%1{→%}:%{$fg_bold[red]%}%1{→%}) '

## Load aliases
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/dirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/dirrc"
# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/filerc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/filerc"

## Source plugins
[ -d "/usr/share/zsh/plugins/zsh-vi-mode" ] && source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
[ -d "/usr/share/zsh/plugins/fast-syntax-highlighting" ] && source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
[ -d "/usr/share/zsh/plugins/zsh-autosuggestions" ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
# [ -d "/usr/share/zsh-theme-powerlevel10k" ] && source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/seijin/.local/bin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/seijin/.local/bin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/seijin/.local/bin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/seijin/.local/bin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

