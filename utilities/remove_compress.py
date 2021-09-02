import argparse
import re
import os

import io
import string



arguments = argparse.ArgumentParser(description="Teradata Compress statements are not needed in Snowflake. This script removed any matching COMPRESS expression from the original file.")
arguments.add_argument("--input", required=True, help="Input DDL to check for DDL statements")
arguments.add_argument("--output", required=True, help="modified file")

arguments = arguments.parse_args()

if not os.path.exists(arguments.input):
    print(f"Error: Input file [{arguments.input}] could not be found")
    exit(100)

# open and read file. try some encondings in case it fails
try:
   file_contents = open(arguments.input,"r").read()
except UnicodeDecodeError:
    try:
        file_contents = open(arguments.input,"r", encoding="latin1").read()
    except:
        try:
            file_contents = open(arguments.input, "r", encoding="iso-8859-1").read()
        except:
            print("Error opening file. Please review the file encoding")
            exit(1)

max = len(file_contents)
i = 0
result = ""

def eat_number(str):
    global i
    after_first_number = False
    decimal_points_count = 0
    while str[i].isnumeric() or (after_first_number and decimal_points_count == 0 and str[i]=='.'):
        if str[i].isnumeric():
            after_first_number = True
        if str[i]=='.':
            decimal_points_count = decimal_points_count + 1
        i = i + 1
    pass

def eat_string(str):
    global i
    i = i + 1
    if str[i]=="'" and str[i+1]=="'":
        print("a")
    while str[i] != "'" and i < max:
        if str[i] == "'" and str[i+1] == "'": # this is an escaped string just skip
            i = i + 2
        else:
            i = i + 1
    i = i + 1
    pass

def eat_until_next_comma(str):
    global i
    global max
    while i < max and str[i]!=',' and str[i]!=')':
        i = i + 1

def eat_until_closing_parenthesis(str):
    global i
    while str[i] != ')' and i < max:
        classified=False
        if str[i] == "'":
            classified=True
            eat_string(str)
        if str[i].isnumeric():
            classified=True
            eat_number(str)
        if str[i].isspace():
            classified=True
            eat_whitespace(str)
        if str[i] == ',':
            classified=True
            i = i + 1
        if not classified:
            # this is something unbalanced
            eat_until_next_comma(str)
    if str[i] == ')':
        i = i + 1

def eat_whitespace(str):
    global i
    while str[i].isspace() and i < max:
        i = i + 1

def eat_compress(str):
    global i
    eat_whitespace(str)
    if str[i]=='(':
        i = i + 1
        eat_until_closing_parenthesis(str)
    else:
        if str[i]=="'":
            eat_string(str)


def process_file(file_contents):
    global i
    global result
    with open(arguments.output,"w",buffering=10000) as f:
        while i < max:
            if i % 100 == 0:
                print(f"offset at {i}\r",end="")
            if    (i + 8 < max) and file_contents[i  ]=='C' and file_contents[i+1]=='O' and file_contents[i+2]=='M' \
            and file_contents[i+3]=='P' and file_contents[i+4]=='R' \
            and file_contents[i+5]=='E' and file_contents[i+6]=='S' and file_contents[i+7]=='S' \
            and not file_contents[i+8].isalpha():
                    i = i + 8
                    # we only eat the character after compress if it was an space
                    # that is in case the user wrote COMPRESS'12' or COMPRESS('12')
                    if file_contents[i].isspace():
                        i = i + 1
                    eat_compress(file_contents)
            else:
                #result = result + file_contents[i]
                f.write(file_contents[i])
                i = i + 1


process_file(file_contents)

    
print("\n\nDone!")