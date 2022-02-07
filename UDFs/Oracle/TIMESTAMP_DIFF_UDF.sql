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
-- Description: The TIMESTAMP_DIFF_UDF() is used to achieve the timestamps arithmetic operations
-- functional equivalence in Snowflake.
-- =========================================================================================================
CREATE OR REPLACE FUNCTION TIMESTAMP_DIFF_UDF(LEFT_TS TIMESTAMP, RIGHT_TS TIMESTAMP ) RETURNS VARCHAR LANGUAGE SQL AS
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