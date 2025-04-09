# shellcheck disable=SC2059,SC2034,SC1090,SC2206,SC2053,SC2296
set -o allexport
. <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
LS_COLORS=$(vivid generate catppuccin-mocha 2>/dev/null || printenv LS_COLORS)
SHELLCHECK_OPTS="-e SC2059 -e SC2034 -e SC1090 -e SC2206 -e SC2053 -e SC2296"
FZF_API_KEY="$(head -c 32 /dev/urandom | base64)"
path+=( $HOME/opt/*/bin $HOME/.local/bin )

set +o allexport

unset FZF_DEFAULT_OPTS
