#############
### Zinit ###
#############
## Zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

## Download Zinit
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

## Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

###############
### History ###
###############
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTDUP=erase

##############
### Colors ###
##############
autoload -U colors && colors	# Load colors
stty stop undef		        # Disable ctrl-s to freeze terminal.

#######################
### Un-/set options ###
#######################
setopt autocd
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt interactive_comments
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt prompt_subst

unsetopt beep

###################
### Completions ###
###################
## Load/Setup
autoload -Uz compinit && compinit
zmodload zsh/complist
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)	# Include hidden files.

zinit cdreplay -q

## Style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

###############
### Keymaps ###
###############
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history

####################
### Source files ###
####################
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

###############
### Plugins ###
###############
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::termsupport.zsh

zinit snippet OMZT::robbyrussell

####################
### Integrations ###
####################
eval "$(fzf --zsh)"
