#!/bin/sh

. "$(dirname -- "$0")/csv_lib.sh"

while _csv_read; do
  eval "set -- $ROW"
  for i do
    printf '_cell: %s\n' "$(_csv_shquote "$i")"
  done
  echo
done

