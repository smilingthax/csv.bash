#!/bin/zsh

. "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%x}}")/csv_lib.bash"

_csv_header_cell() {
  header+=("$1")
}

_csv_row_cell() {
  row+=("$1")
}

header=()
_csv_read _csv_header_cell || return 1

declare -A keyval
while
  row=()
  _csv_read _csv_row_cell
do
  keyval=()
  for ((idx=0; idx<${#row[@]}; ++idx)); do
    # NOTE: zsh ${header[1]} would be bash ${header[0]}...
    keyval[${header[@]:$idx:1}]=${row[@]:$idx:1}
  done
  declare -p keyval
done

