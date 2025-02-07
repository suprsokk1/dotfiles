ZSH=${HOME}/.oh-my-zsh
ZSH_THEME=simple

plugins=( git fzf tmux pip direnv docker gh )

# bash completion
plugins+=( compleat )

# fast-syntax-highlighting
plugins+=( fast-syntax-highlighting )

# pyvenv
plugins+=( pyvenv )

# initiate oh-my-zsh
. "$ZSH"/oh-my-zsh.sh

## my custom stuff
. ~/.aliases

# global aliases
alias -g T='python -m trace --ignore-dir=$(python -c "import sys; print(*sys.path[1:], sep=\":\")")'
alias -g G=grep
alias -g R=rg
alias -g W='whence -f'

alias -s git='git -C $HOME/opt clone --depth=1'

zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

