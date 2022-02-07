
# Definition and Usage
The INSTR_UDF() function returns the position of the first occurrence of a string in another string.

This function performs a case-insensitive search.

## Syntax
`INSTR_UDF(string1, string2)`

## Parameter Values
| Parameter	| Description |
|-----------|-------------|
| source	| Required. The string to search for in string1. If string2 is not found, this function returns 0
| target	| Required. The string that will be searched
| position  | Optional. The position where to start searching |
| occur     | Optional. The occurence to replace.

## Snowflake Implementation

> Credit goes to Zack Howe

```sql
CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING) 
RETURNS INT
IMMUTABLE
AS
$$
    POSITION(SEARCH_STRING, SOURCE_STRING)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING, POSITION INT) 
RETURNS INT
IMMUTABLE
AS
$$
    CASE WHEN POSITION >= 0 THEN POSITION(SEARCH_STRING, SOURCE_STRING, POSITION) ELSE 1 + LENGTH(SOURCE_STRING) - POSITION(SEARCH_STRING, REVERSE(SOURCE_STRING), ABS(POSITION)) END
$$;

CREATE OR REPLACE FUNCTION PUBLIC.INSTR_UDF(SOURCE_STRING STRING, SEARCH_STRING STRING, POSITION DOUBLE, OCCURRENCE DOUBLE)
RETURNS DOUBLE
LANGUAGE JAVASCRIPT
IMMUTABLE
AS
'
function INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION, N)
{
  var I = SOURCE_STRING.indexOf(SEARCH_STRING, POSITION);
  return(N == 1 ? I : INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, I + 1, N - 1));
}

function LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION, N)
{
  var I = SOURCE_STRING.lastIndexOf(SEARCH_STRING, POSITION);
  return(N == 1 ? I : LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, I - 1, N - 1));
}

function INSTR(SOURCE_STRING, SEARCH_STRING, POSITION, OCCURRENCE)
{
  if(OCCURRENCE < 1) return - 1;
  if(POSITION == 0) POSITION = 1;
  if(POSITION > 0) {
    var INDEX = INDEXOFNTH(SOURCE_STRING, SEARCH_STRING, POSITION - 1, OCCURRENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
  else {
    var INDEX = LASTINDEXOFNTH(SOURCE_STRING, SEARCH_STRING, SOURCE_STRING.length + POSITION, OCCURRENCE);
    return(INDEX == -1) ? INDEX : INDEX + 1;
  }
}

return INSTR(SOURCE_STRING, SEARCH_STRING, POSITION, OCCURRENCE);
';
```

 ## Examples 
 
```sql
select INSTR_UDF('abcda','a');        -- Returns 1
select INSTR_UDF('abcda','a',0);      -- Returns 1
select INSTR_UDF('abcda','a', 1);     -- Returns 1
select INSTR_UDF('abcda','a', 2);     -- Returns 5
select INSTR_UDF('abcda','a',  -1);   -- Returns 5
select INSTR_UDF('abcda','a',  0, 0); -- Returns -1
select INSTR_UDF('abcda','a',  0, 1); -- Returns 1
select INSTR_UDF('abcda','a',  0, 2); -- Returns 5
select INSTR_UDF('abcda','a',  1, 1); -- Returns 1
select INSTR_UDF('abcda','a',  1, 2); -- Returns 5
select INSTR_UDF('abcda','a', -1, 1); -- Returns 5
select INSTR_UDF('abcda','a', -1, 2); -- Returns 1
```
