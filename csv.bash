#!/bin/bash

. "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%x}}")/csv_lib.bash"

while _csv_read; do
  eval "set -- $ROW"
  for i do
    printf '_cell: %q\n' "$i"
  done
  echo
done

