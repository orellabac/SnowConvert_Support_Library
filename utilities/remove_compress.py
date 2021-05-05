import argparse
import re
import os

arguments = argparse.ArgumentParser(description="Teradata Compress statements are not needed in Snowflake. This script removed any matching COMPRESS expression from the original file.")
arguments.add_argument("--input", required=True, help="Input DDL to check for DDL statements")
arguments.add_argument("--output", required=True, help="modified file")

arguments = arguments.parse_args()

if not os.path.exists(arguments.input):
    print(f"Error: Input file [{arguments.input}] could not be found")
    exit(100)
    
file_contents = open(arguments.input,"r").read()
regex = r"\bCOMPRESS\b\s*\(.*?\)(\s+COMPRESS\s+USING\s+\w+)?(\s+DECOMPRESS\s+USING\s+\w+)?"


def replace_compress(match):
    print ("Match found at {start}-{end}: {match}".format(start = match.start(), end = match.end(), match = match.group()))
    return ""
    
new_file_contents = re.sub(regex, replace_compress, file_contents, flags=re.DOTALL | re.MULTILINE )

with open(arguments.output,"w") as f:
    f.write(new_file_contents)
    
print("Done!")
