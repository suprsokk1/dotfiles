#!/bin/bash -a
NO_COLOR=1

rm -f res paste

trap main EXIT

parse (){
  wl-paste > paste

  debug=false

  if gron -u < paste > res 2>/dev/null
  then ${debug:-false} && notify-send "clipboard:is gron"
  else :
  fi

  if yj < paste > res 2>/dev/null
  then ${debug:-false} && notify-send "clipboard:is yaml"
  else :
  fi

  if yj -tj < paste > res 2>/dev/null
  then ${debug:-false} && notify-send "clipboard:is toml"
  else :
  fi

  if pkl eval - < paste > res 2>/dev/null
  then ${debug:-false} && notify-send "clipboard:is pkl"
  else :
  fi

  if jq < paste > res 2>/dev/null
  then ${debug:-false} && notify-send "clipboard:is json"
  else :
  fi

}

main() {
  # notify-send "$0" "$LINENO"
  case "${$}${*}" in
    "${$}")                       # `default'

      if true ; then
        grep -E  $'\x40(source|action|submenu)'  "$0"|
          grep -Po '[^\x22-\x29]{4,}' |
          tr $'\x3f' ' ' |
          sed -E '/\x40(source|action|submenu)/d' |
          grep .
      else
        (
          gawk 'BEGIN{RS="";ORS="\n";OFS=""}/\x40(source|action|submenu)/'
        ) < "$0"
      fi

      ;;

    *:clipboard:*)
      # REVIEW
      ;;

    "${$}"Clipboard?pipe?to?...)  # @submenu
      echo TODO 'Clipboard pipe to ...'
      ;;

    "${$}"Clipboard?ungron)  # @submenu
      notify-send "${0##*/}" "$(wl-paste)"
      wl-paste | tee paste | gron -u > res
      if grep --silent . res
      then wl-copy < res
      else wl-copy < paste
      fi
      sleep .3s
      notify-send "${0##*/}" "$(wl-paste)"
      ;;

    "${$}"Clipboard?clean?ANSI?escapese)  # @submenu
      wl-paste | ansifilter | wl-copy
      ;;

    "${$}"Fooo)
      parse
      ;;

    "${$}"Clipboard?transform?from?...)  # @submenu
      pushd "$(mktemp -d)" &>/dev/null || exit
      find -type f -empty -printf '%P\n' -delete | sed -E 's/.res//' | tr '[:lower:]' '[:upper:]'

      ;;

    "${$}"[TYJP][OASK][MOL][LN_])
      case ${*#"${$}"} in
        JSON)

        ;;

        YAML)

        ;;

      esac
      ;;

    "${$}"Clipboard?YAML?to?PKL)  # @action
      wl-paste |
        pkl eval "${HOME}"/opt/pkl-pantry/packages/pkl.pipe/yaml.pkl -x 'pipe' |
        pkl eval - |
        wl-copy

      ;;

    "${$}"Clipboard?JSON?to?PKL)  # @action
      wl-paste | pkl eval "${HOME}"/opt/pkl-pantry/packages/pkl.pipe/json.pkl -x 'pipe' | grep -Po '(?<=new\sDynamic\s\x7b).*(?=\x7d)' | pkl eval - | tee res| wl-copy
      notify-send "${0##*/}" "$( < res)"

      ;;

    "${$}"Projects)               # @source

      ;;

    "${$}"Projects)               # @source

      ;;

    *)

      # grep -Po '(?<=@submenu)\)' "$0"

  esac | sort -u | sed '/^ /d' | sed 's/./@\0/'
  # | sed -E 's/.*/|\0|/'

}
