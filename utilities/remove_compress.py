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


def replace_compress(match):
    print ("Match found at {start}-{end}: {match}".format(start = match.start( ), end = match.end(), match = match.group()))
    return ""

new_file_contents = file_contents

# compress pattern compress 00.00
regex = r"(\bCOMPRESS\s+\d+(.)?(\d+)?)"
new_file_contents = re.sub(regex, replace_compress, new_file_contents, flags=re.DOTALL | re.MULTILINE )

# compress pattern compress 'xxx'
regex = r"(\bCOMPRESS\s+'[^']+')"
new_file_contents = re.sub(regex, replace_compress, new_file_contents, flags=re.DOTALL | re.MULTILINE )


# compress pattern compress ( value1, ... ) using
#regex = r"\bCOMPRESS\b\s*\(.*?\)(\s+COMPRESS\s+USING\s+\w+)?(\s+DECOMPRESS\s+USING\s+\w+)?"
#new_file_contents = re.sub(regex, replace_compress, new_file_contents, flags=re.DOTALL | re.MULTILINE )

# compress ( values... )
def replace_compress2(match):
    print ("Match found at {start}-{end}: {match}".format(start = match.start( ), end = match.end(), match = match.group()))
    return ","
regex = r"(\bCOMPRESS\s+\(.*?\s*,$)"
new_file_contents = re.sub(regex, replace_compress2, new_file_contents, flags=re.DOTALL | re.MULTILINE )


def replace_compress(match):
    print ("MatchX found at {start}-{end}: {match}".format(start = match.start( ), end = match.end(), match = match.group()))
    return match.group(2)

regex = r"((CHARACTER\sSET\s.*?)COMPRESS)"
new_file_contents = re.sub(regex, replace_compress, new_file_contents, flags=re.DOTALL | re.MULTILINE )

regex = r"((TIMESTAMP(.*?))\s+COMPRESS)"
def replace_compress_timestamp(match):
    print ("Match found at {start}-{end}: {match}".format(start = match.start( ), end = match.end(), match = match.group()))
    return match.group(2)
new_file_contents = re.sub(regex, replace_compress_timestamp, new_file_contents, flags=re.DOTALL | re.MULTILINE )

regex = r"((DECIMAL(.*?))\s+COMPRESS)"
def replace_compress_decimal(match):
    print ("Match found at {start}-{end}: {match}".format(start = match.start( ), end = match.end(), match = match.group()))
    return match.group(2)
new_file_contents = re.sub(regex, replace_compress_decimal, new_file_contents, flags=re.DOTALL | re.MULTILINE )


with open(arguments.output,"w") as f:
    f.write(new_file_contents)
    
print("Done!")
