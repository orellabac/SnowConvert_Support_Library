-- <copyright file="DATEADD_UDF_INTERVAL.sql" company="Mobilize.Net">
--        Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
-- 
--        This file is part of the Mobilize Frameworks, which is
--        proprietary and confidential.
-- 
--        NOTICE:  All information contained herein is, and remains
--        the property of Mobilize.Net Corporation.
--        The intellectual and technical concepts contained herein are
--        proprietary to Mobilize.Net Corporation and may be covered
--        by U.S. Patents, and are protected by trade secret or copyright law.
--        Dissemination of this information or reproduction of this material
--        is strictly forbidden unless prior written permission is obtained
--        from Mobilize.Net Corporation.
-- </copyright>

-- =========================================================================================================
-- DESCRIPTION: THIS DATEADD_UDF() IS USED AS A TEMPLATE FOR ALL THE CASES WHEN THERE IS AN ADDITION
-- BETWEEN AN UNKNOWN TYPE AND AN INTERVAL
-- PARAMETERS:
--  RETURNS: THE DATE OR TIMESTAMP RESULT OF APPLYING THE GIVEN INTERVAL
--  EXAMPLE:
--      SELECT DATEADD_UDF(6,'2022-02-14 15:31:00'); -- SELECT 6 + TO_TIMESTAMP('2022-02-14 15:31:00','YYYY-MM-DD HH24:MI:SS') FROM DUAL; -- RETURNS '2022-02-20'
--      SELECT DATE_ADD_UDF('2020-01-01','INTERVAL 2 DAY'); -- EQUALS 2020-01-03
--      SELECT DATE_ADD_UDF('2020-01-01','INTERVAL 2 DAY'); -- EQUALS 2020-01-03
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL ''3 hour''');  --EQUALS 2013-04-05 02:02:03.000 -0700
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL 1 min');       --EQUALS 2013-04-05 01:03:03.000 -0700
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL 30 sec');      --EQUALS 2013-04-05 01:02:33.000 -0700
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL 2 week');      --EQUALS 2013-04-19 01:02:03.000 -0700
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL 3 month');     --EQUALS 2013-07-05 01:02:03.000 -0700
--      SELECT DATE_ADD_UDF(to_timestamp_tz('2013-04-05 01:02:03'),'INTERVAL ''1 month, 2 DAY, 3 hour'''); --EQUALS 2013-05-07 04:02:03.000 -0700
-- =========================================================================================================
CREATE OR REPLACE FUNCTION DATE_ADD_UDF(D TIMESTAMP_TZ(9),INTERVAL VARCHAR) RETURNS TIMESTAMP_TZ(9)
LANGUAGE JAVASCRIPT AS
$$
var add_years        =(dt,n) => new Date(dt.setFullYear(dt.getFullYear() + n));
var add_month        =(dt,n) => new Date(dt.setMonth(dt.getMonth()+n));
var add_hours        =(dt,n) => new Date(dt.setTime(dt.getTime() + (n*60*60*1000)));
var add_minutes      =(dt,n) => new Date(dt.setMinutes(dt.getMinutes()+n));
var add_seconds      =(dt,n) => new Date(dt.setSeconds(dt.getSeconds() + n));
var add_milliseconds =(dt,n) => new Date(dt.setMilliseconds(dt.setMilliseconds() + n));
var add_weeks        =(dt,n) => new Date(dt.setDate(dt.getDate() + n * 7));
var add_days         =(dt,n) => new Date(dt.setDate(dt.getDate() + n));

// Regex to determine if this is an interval
const interval_regex = /(INTERVAL)\s*(.*)/gm;
// Regex to split interval fragment
const fragment_regex = /\s*(\d+)\s*(\w+)/gm;
if (m = interval_regex.exec(INTERVAL))
{
    //Remove spaces and quotes
    var interval_spec = m[2].trim().replace("'","");
    var interval_parts = interval_spec.split(",").map((x)=>x.trim());
    for (var part of interval_parts) 
    {   
        fragment_regex.lastIndex = 0;
        f = fragment_regex.exec(part.toUpperCase());
        var quantity =  Number.parseInt(f[1]);
        var unit =f[2];
        switch(unit) {
            case "S":
            case "SEC":
            case "SECS":
            case "SECOND":
            case "SECONDS":
                D = add_seconds(D,quantity);
                break;
  
            case "M":
            case "MI":
            case "MIN":
            case "MINS":
            case "MINUTE":
            case "MINUTES":
                D = add_minutes(D,quantity);
                break;

            case "H":
            case "HH":
            case "HRS":
            case "HOUR":
            case "HOURS":
                D = add_hours(D,quantity);
                break;
            case "D":
            case "DD":
            case "DAY":
            case "DAYS":
                D = add_days(D, quantity);
                break;
            case "W":
            case "WK":
            case "WOY":
            case "WY":
            case "WEEK":
            case "WEEKS":
            case "WEEKOFYEAR":
                D = add_weeks(D, quantity);
                break;              
            case "MM":
            case "MON":
            case "MONS":
            case "MONTH":
            case "MONTHS":
                D = add_month(D,quantity);
                break;
            case "Y":
            case "YY":
            case "YYYY":
            case "YR":
            case "YRS":
            case "YEAR":
            case "YEARS":
                D = add_years(D, quantity);
                break;
            default:
                throw new Error(unit + " not supported");
        }
    }
    return D;
}
$$;

CREATE OR REPLACE FUNCTION DATE_ADD_UDF(D DATE,INTERVAL VARCHAR) RETURNS DATE
LANGUAGE SQL AS
$$
   DATEADD_UDF(D::TIMESTAMP_TZ(9),INTERVAL)::DATE
$$;


