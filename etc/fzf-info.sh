#!/usr/bin/env bash
# notify-send "$0" "$#:$*" &>/dev/null

grep -Poz '(?<=bind..)[^\x22]+' ${HOME}/.fzfrc |
  grep -z0v -e change.preview  |
  head -c -1 |
  sed 'y/:\x0/ |/' |
  head -c -1

 #  | grep -Poz '^.{80}' | xargs -0n1 | head -1
# grep -Po '(?<=bind..)[^"]+' "${HOME}"/.fzfrc
