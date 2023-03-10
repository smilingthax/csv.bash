#!/bin/bash
# csv_lib.sh shell library to parse csv
# (c) 2023 Tobias Hoffmann

_csv_delim=,
_csv_quote=$'"'

_csv_shquote() {
  printf '%s\n' "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

_csv_cell() {
  RET="$RET $(_csv_shquote "$1")"
}

_csv_read() {
  local line next qchar cell ws

  IFS= read -r -s line || [ -n "$line" ] || return 1

  RET=         # todo? _csv_begin() ?  - or: while _csv_start; _csv_read; do ...; done ?
#  [ -z "$line" ] && return  # no cell in completely empty line  # TODO?

  while
    next=${line#"${line%%[! ]*}"[$_csv_quote]}  # strip begin quote w/ leading whitespace
    if [ "$next" != "$line" ]; then
      qchar=${line:$((${#line}-${#next}-1)):1}
      line=$next
      cell=
      while
        while
          next=${line#*"$qchar"}
          [ "${next:0:1}" = "$qchar" ]   # double quotes
        do
          cell="$cell${line:0:$((${#line}-${#next}))}"
          line=${next:1}
        done
        [ "$next" = "$line" ]   # end of line inside quotes
      do
        cell="$cell$line"$'\n'
        IFS= read -r -s line || [ -n "$line" ] || {
          echo "Parse error: Missing end-quote at EOF" >&2
          return 2
        }
      done
      cell="$cell${line:0:$((${#line}-${#next}-1))}"
      line=${next%$'\r'}
      ws=${line%%[$_csv_delim]*}
      if [ "${ws#*[! ]}" != "$ws" ]; then
        echo "Parse error: Expected only whitespace after end-quote, got '${ws:0:20}'" >&2
        return 3
      fi
      next=${next:$((${#ws}+1))}
      _csv_cell "$cell"
      [ ${#line} -gt ${#ws} ]
    else
      cell=${line%%[$_csv_delim]*}
      if [ "${cell#*[$_csv_quote]}" != "$cell" ]; then
        echo "Parse error: Spurious quote in unquoted cell: '$cell'" >&2
        return 4
      fi
      next=${line:$((${#cell}+1))}
      _csv_cell "${cell%$'\r'}"
      [ ${#line} -gt ${#cell} ]
    fi
  do
    line=$next
  done
}


