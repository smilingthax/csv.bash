# Bash/Shell CSV library

* also works with Bash 3 and ZSH (MacOS)

* `_csv_read` will read from stdin and output to `$RET`, which can be used by `eval "set -- $RET"`.

* Example use in `csv.sh` and `csv_header.sh` (treats first line as header / key)

* For generating csv, there is `_csv_quote some_string` (-> `"some_string"`) resp. `_csv_quote_smart` (only quotes where needed).

TODO? add bash4 version returning an (associative) array?

Copyright (c) 2023 Tobias Hoffmann

License: https://opensource.org/licenses/MIT

