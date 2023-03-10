#!/bin/bash

source csv_lib.sh

while _csv_read; do
  eval "set -- $RET"
  for i do printf '_cell: %q\n' "$i"; done
  echo
done

