#!/bin/bash -e
pushd $(git rev-parse --show-toplevel) || exit
set - ${*} --files-from=etc/import-files.txt --relative --mkpath --ignore-missing-args --copy-links --munge-links -- "${HOME}" dotfiles
command rsync --dry-run "${@}"
# shellcheck disable=2093
exec rsync --verbose "${@}"

### TODO vvvvvvvvv TODO
set - -i -f etc/files.txt -r "${HOME}" -l dotfiles

source ${0%/*}/rsync-wrapper.sh
