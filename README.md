# Shell CSV library

* `csv_lib.bash` works with Bash 3 and ZSH (MacOS);  
  `csv_lib.sh` even works with dash / posix (w/ `local`).

* `_csv_read` will read from stdin and output to `$ROW`, which can be used via `eval "set -- $ROW"`.

* RFC 4180 uses solely "CRLF" as line ending; `_csv_read` also supports just "LF".

* Defaults are `_csv_delim=,` and `_csv_quote=\"`.

* Example use in `csv.sh` / `csv.bash` and `csv_header.sh` / `csv_header.zsh` (treats first line as header / key).  
  `csv_header.zsh` works with Bash 4 / ZSH and shows how to use indexed / associative arrays instead of `eval`.

* For generating csv, there is `_csv_quote some_string` (-> `"some_string"`) resp. `_csv_quote_smart` (only quotes where needed),
  as well as `_csv_write "$@"` / `_csv_write_smart`.

Copyright (c) 2023 Tobias Hoffmann

License: https://opensource.org/licenses/MIT

