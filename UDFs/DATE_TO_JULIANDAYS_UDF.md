
# Definition and Usage
The DATE_TO_JULIANDAYS_UDF() function takes a DATE and returns the number of days since January 1, 4712 BC. This function is equivalent to the Oracle TO_CHAR(DATE,'J')

## Syntax
`DATE_TO_JULIANDAYS_UDF(date)`

## Parameter Values
| Parameter	    | Description |
|---------------|-------------|
| date	        | Required. The date to transform.

## Snowflake Implementation


```sql
CREATE OR REPLACE FUNCTION DATE_TO_JULIANDAYS_UDF(D DATE) RETURNS STRING AS
$$
  TRUNC(date_part('epoch',d) / 3600 / 24 + 2440588.0)::STRING
$$;
```

 ## Examples 

```sql
SELECT DATE_TO_JULIANDAYS_UDF(DATE '2020-01-01'); -- SELECT TO_CHAR(DATE '2020-01-01','J') from dual; -- returns 2458850
SELECT DATE_TO_JULIANDAYS_UDF(DATE '1900-12-31'); -- SELECT TO_CHAR(DATE '1900-12-31','J') from dual; -- returns 2415385
SELECT DATE_TO_JULIANDAYS_UDF(DATE '1904-02-29'); -- SELECT TO_CHAR(DATE '1904-02-29','J') from dual; -- returns 2416540
SELECT DATE_TO_JULIANDAYS_UDF(DATE '1903-03-01'); -- SELECT TO_CHAR(DATE '1903-03-01','J') from dual; -- returns 2416175
SELECT DATE_TO_JULIANDAYS_UDF(DATE '2000-12-31'); -- SELECT TO_CHAR(DATE '2000-12-31','J') from dual; -- returns 2451910
```
