# ~/.zshrc
systemctl --user import-environment CABAL_DIR CARGO_HOME EDITOR GOPATH LC_ALL LESS PAGER PIPX_HOME XDG_CONFIG_HOME ZSH ZSH_THEME

ZSH=${ZSH:-${HOME}/.oh-my-zsh}
ZSH_THEME=${ZSH_THEME:-simple}

export GOPATH=${GOPATH:-${HOME}/opt}/go}
export CARGO_HOME=${CARGO_HOME:-${HOME}/opt}/cargo}
export CABAL_DIR=${CABAL_DIR:-${HOME}/opt}/cabal}
export PIPX_HOME=${PIPX_HOME:-${HOME}/opt}/pipx}

export path=(${path} ${HOME}/opt/*/bin)
plugins=(fzf emacs tmux pip direnv docker gh)
