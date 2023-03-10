#!/bin/sh

. "$(dirname -- "$0")/csv_lib.sh"

_cell2() {
  printf '%s: %s\n' "$1" "$(_csv_shquote "$2")"
}

_csv_read || return 1
header=$ROW

while _csv_read; do
  eval "set -- $ROW"
  first=1
  for val do
    [ -n "$first" ] && { eval "set -- $header"; first=; } || shift
    _cell2 "$1" "$val"
  done
  echo
done

