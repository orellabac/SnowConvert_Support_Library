# Generate Copy Intos from dumps

```
usage: copy_into_from_dumps.py [-h] --inputFolder INPUTFOLDER --copyintoFolder COPYINTOFOLDER [--database DATABASE]

Generate COPY Into scripts from Teradata DataDumps. Given a folder with some DataDumps a set of COPY INTO scripts to load into snowflake are generated

optional arguments:
  -h, --help            show this help message and exit
  --inputFolder INPUTFOLDER
                        Folder with Datadumps
  --copyintoFolder COPYINTOFOLDER
                        Folder for copyinto files
  --database DATABASE   Teradata Database to filter. If missing all databases in the dump will be considered
```