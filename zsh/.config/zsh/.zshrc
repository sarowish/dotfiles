bindkey -e

HISTSIZE=20000
SAVEHIST=20000
HISTFILE=$XDG_STATE_HOME/zsh/history

eval "$(starship init zsh)"
autoload -U compinit promptinit
compinit
promptinit;

compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

alias ip='ip -c'
alias clock='tty-clock -sc'
alias neovim='nvim'
alias n='nvim'
alias mix='pulsemixer'
alias neofetch='hyfetch'

eval "$(zoxide init zsh)"
source /usr/share/skim/key-bindings.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
source <(COMPLETE=zsh bawa)
