#!/bin/bash
# csv_lib.sh shell library to parse csv
# (c) 2023 Tobias Hoffmann

_csv_delim=,
_csv_quote=$'"'

_csv_shquote() {
  printf '%s\n' "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

_csv_cell() {
  ROW="$ROW $(_csv_shquote "$1")"
}

_csv_read() {
  local line next qchar cell ws

  IFS= read -r -s line || [ -n "$line" ] || return 1

  ROW=         # todo? _csv_begin() ?  - or: while _csv_start; _csv_read; do ...; done ?
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

# -- csv output

_csv_quote() {
  local qchar=${_csv_quote:0:1}
  printf '%s%s%s' "$qchar" "$(printf '%s' "$1" | sed "s/[$qchar]/&&/g")" "$qchar"
}

_csv_quote_smart() {
  if [ "${1#*[$'\n'$_csv_delim$_csv_quote]}" != "$1" ]; then
    _csv_quote "$1"
  else
    printf '%s' "$1"
  fi
}

_csv_write_smart() {
  local val first=1
  for val do
    [ -z "$first" ] && printf ',' || first=
    _csv_quote_smart "$val"
  done
  printf '\n'
}

_csv_write() { (_csv_quote_smart() { _csv_quote "$@"; }; _csv_write_smart "$@"); }

