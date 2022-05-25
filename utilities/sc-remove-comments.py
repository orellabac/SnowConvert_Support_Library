#!/usr/bin/env python3

# ---------------------------------------------------------------------------------------------------------------------
# Change history
#   20211013-MJF:
#     Created 
#
# Future enhancements:
#   - Read a directory structure of files and write to output directory
# ---------------------------------------------------------------------------------------------------------------------

import re
import argparse

# Define arguements
arguments_parser = argparse.ArgumentParser(description = "SnowConvert comment removal (single file)", add_help = False)

required_args = arguments_parser.add_argument_group("Required arguments")
required_args.add_argument("-in","--input_file", required = True, 
    help = "File to be parsed for SnowConvet comments.")
required_args.add_argument("-out","--output_file", required = True, 
    help = "File to be created after comments are removed.")

optional_args = arguments_parser.add_argument_group("Optional arguments")
optional_args.add_argument("-h","--help", action="help",
    help = "Displays this information.")

arguments = arguments_parser.parse_args()

print("\n---------------------------------------------")
print("  SnowConvert comment removal (single file)")
print("---------------------------------------------\n")

# Parse required arguments
input_file = arguments.input_file
output_file = arguments.output_file

regex_comment = r"([' '{1}])?(/\*{3}\s)+(MSC{1})+([^*]+)+(\*{3}/)"
regex_emptyLine = r"\S"

# Read complete source file
print(" Opening source file: " + input_file)
sourceFile = open(input_file, 'r')
lines = sourceFile.readlines()
sourceFile.close()

# Open file handle for target file
print(" Opening taget file: " + output_file)
targetFile = open(output_file,'w')

# Line counter
i = 0

#  Comment counter
c = 0

# Strips comments and removes blank lines writing each line to target file
print(" Searching each line of source file for SnowConvert comment...")
for line in lines:
    i += 1
    if re.search(regex_comment, line):
        c += 1
        line = re.sub(regex_comment, '', line)
        if not re.search(regex_emptyLine, line):
            line = line.strip()
    targetFile.write(line)

# CLose target file handle
targetFile.close()
print("\n     " + str(c) + " lines with comments cleansed")
print("     " + str(i) + " lines processed and written to target file")

print("\n Done")