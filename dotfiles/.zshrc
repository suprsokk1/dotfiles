ZSH=${HOME}/.oh-my-zsh
ZSH_THEME=simple

plugins=( git gh fzf tmux pip direnv docker )

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

if [[ $TMUX_PANE ]]
then if [[ $(\tmux list-windows | awk -F: 'END{print $1}') -eq 1 ]]
     then if neofetch --version &>/dev/null
          then neofetch
          fi
     fi
fi

# completion
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# pkl
if ! [[ -s ~/.pklpipe ]]
then pkl eval package://pkg.pkl-lang.org/pkl-pantry/pkl.pipe@1.0.0#/shellshortcuts.pkl > ~/.pklpipe
fi

. ~/.pklpipe

pipe-yaml2pkl() {
    if [ -t 0 ]
    then wl-paste
    fi | pyq "pipe${*:+.}${*}" | grep -Po '(?<=\{).+(?=\})'| pkl eval -
}

# global aliases
alias -g ,python-trace='python -m trace --ignore-dir=$(python -c "import sys; print(*sys.path[1:], sep=\":\")")'
alias -g ,G='| grep'
alias -g ,R='| rg'
alias -g ,W='whence -f'

# extension aliases
alias -s git='command git -C $HOME/opt clone --depth=1'
alias -s pkl='command pkl eval'

if nomino --version &>/dev/null
then alias -- rename='noglob nomino --no-extension --mkdir --generate $HOME/Backup/_nomino-map_${EPOCHSECONDS}_`date -I`-${RANDOM}.map --regex'
     alias -- rename-test='noglob nomino --dry-run --no-extension --mkdir --generate $HOME/Backup/_nomino-map_${EPOCHSECONDS}_`date -I`-${RANDOM}.map --regex'
     alias -- ren=rename
fi

if fd --version &>/dev/null
then alias -- fd='command fd --no-ignore-vcs'
     alias -- fs2json='fd -uuu -tf -X jo {}=@{} --base-directory'
fi

if gron --version &>/dev/null
then alias -- gron='command gron ${INSIDE_EMACS:+--colorize}'
fi

if exa --version &>/dev/null
then alias -- ls='command exa --git --group-directories-first'
fi

if bat --version &>/dev/null
then alias -- cat='command bat'
fi

if jc --version &>/dev/null
then alias -- jc='command jc'
fi

if tldr --version &>/dev/null
then alias -- man='command tldr'
fi

if yj -v &>/dev/null
then alias -- yj='command yj -yj'
     alias -- yt='command yj -yt'
     alias -- jy='command yj -jy'
     alias -- jt='command yj -jt'
     alias -- ty='command yj -ty'
     alias -- tj='command yj -tj'
fi

unset FZF_DEFAULT_OPTS
