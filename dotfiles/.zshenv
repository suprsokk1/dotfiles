# shellcheck disable=SC2059,SC2034,SC1090,SC2206,SC2053,SC2296
set -o allexport
. <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)

SHELLCHECK_OPTS="-e SC2059 -e SC2034 -e SC1090 -e SC2206 -e SC2053 -e SC2296"

path+=(${HOME}/{,{opt,.local}/}*/bin)
path=(${(u)path:#*.[0-9]*})

HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
EXTENDED_HISTORY=1

LS_COLORS=$(vivid generate catppuccin-mocha 2>/dev/null || printenv LS_COLORS)

zpath=($zpath "$HOME"/opt/zsh-*)

set +o allexport
