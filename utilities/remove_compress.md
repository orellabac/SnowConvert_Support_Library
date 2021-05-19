# Remove Compress

This script can be used to remove COMPRESS clauses from Teradata `DDL_x*.sql` files. Compress clauses are not needed in snowflake and they could include Personal Identifiable Information or Business sensitive information.

## Usage:

```
usage: remove_compress.py [-h] --input INPUT --output OUTPUT

Teradata Compress statements are not needed in Snowflake. This script removed any matching COMPRESS expression from the original file.

optional arguments:
  -h, --help       show this help message and exit
  --input INPUT    Input DDL to check for DDL statements
  --output OUTPUT  modified file
```