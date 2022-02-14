-- <copyright file="TIMESTAMP_DIFF_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: The TIMESTAMP_DIFF_UDF() is used to achieve the timestamps arithmetic operations
-- functional equivalence in Snowflake.
-- EQUIVALENT: Oracle TIMESTAMP - TIMESTAMP
-- NOTE: FOR OTHER CASES SUCH AS DATE - TIMESTAMP, DATE - DATE ETC PLEASE REFER TO DATE_DIFF_UDF()
-- PARAMETERS:
-- LEFT_TS: DATE OR TIMESTAMP
-- RIGHT_TS: DATE OR TIMESTAMP TO BE SUBSTRACTED FROM LEFT_TS
-- RETURNS: THE TIMESTAMP RESULT OF THE SUBSTRACTION BETWEEN THE INPUTS 
-- EXAMPLE:
--  SELECT TIMESTAMP_DIFF_UDF('2022-02-15 15:31:00', '2022-02-14 14:31:00'); -- SELECT TO_TIMESTAMP('2022-02-15 15:31:00','YYYY-MM-DD HH24:MI:SS') - TO_TIMESTAMP('2022-02-14 14:31:00','YYYY-MM-DD HH24:MI:SS') FROM DUAL; 
--  RETURNS '+000000001 01:00:00.00000000'
-- =========================================================================================================
CREATE OR REPLACE FUNCTION TIMESTAMP_DIFF_UDF(LEFT_TS TIMESTAMP, RIGHT_TS TIMESTAMP ) 
RETURNS VARCHAR 
LANGUAGE SQL 
IMMUTABLE
AS
$$
WITH RESULTS(days,hours,min,sec,millisecond,sign) AS
(
  SELECT
  TRUNC(x/1000/3600/24) days,
  TRUNC(x/1000/60 / 60)-trunc(x/1000/3600/24)*24 hours,
  TRUNC(MOD(x/1000,3600)/60) min,
  TRUNC(MOD(x/1000,60)) sec,
  TRUNC(MOD(x,1000)) millisecond,
  SIGN(x)
  FROM (SELECT TIMESTAMPDIFF(millisecond, RIGHT_TS, LEFT_TS) x ,SIGN(TIMESTAMPDIFF(millisecond, RIGHT_TS, LEFT_TS)) sign))
  SELECT
  IFF(SIGN>0,'+','-') || TRIM(TO_CHAR(days,'000000000')) || ' ' || TO_CHAR(hours,'00') || ':' || TRIM(TO_CHAR(min,'00')) || ':' || TRIM(TO_CHAR(sec,'00')) || '.' || TRIM(TO_CHAR(millisecond,'00000000'))
  from RESULTS
$$;