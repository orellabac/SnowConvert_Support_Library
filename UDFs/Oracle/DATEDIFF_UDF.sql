-- <copyright file="DATEDIFF_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: The DATEDIFF_UDF() is used as a template for all the cases when there is a substraction
-- between a date type and an unknown type and all the cases to get the differences between 2 DATES, or TIMESTAMPS.
-- EQUIVALENT: Oracle DATE - DATE , DATE - FLOAT, TIMESTAMP - FLOAT
-- NOTE: FOR TIMESTAMP - TIMESTAMP PLEASE REFER TO TIMESTAMP_DIFF_UDF()
-- NOTE: TO REPLICATE ORACLE DATE - TIMESTAMP, TIMESTAMP - DATE, USE TIMESTAMP_DIFF_UDF()
-- PARAMETERS:
-- SCENARIO 1:
-- 		FIRST_PARAM: DATE
-- 		SECOND_PARAM: DATE TO BE SUBSTRACTED FROM FIRST_PARAM (FOR TIMESTAMP - TIMESTAMP, DATE - TIMESTAMP, TIMESTAMP - DATE PLEASE REFER TO TIMESTAMP_DIFF_UDF())
--  RETURNS: THE NUMBER RESULT OF THE SUBSTRACTION BETWEEN THE INPUTS 
--  EXAMPLE:
-- 		SELECT DATEDIFF_UDF('2022-02-20','2022-02-14'); -- SELECT TO_DATE('2022-02-20','YYYY-MM-DD') - TO_DATE('2022-02-14','YYYY-MM-DD') FROM DUAL; -- RETURNS 6
-- SCENARIO 2:
--      FIRST_PARAM: DATE OR TIMESTAMP
--      SECOND_PARAM: FLOAT TO BE SUBSTRACTED TO SECOND_PARAM, THE UNITS REPRESENT DAYS
--  RETURNS: THE DATE RESULT OF THE SUBSTRACTION OF THE INPUTS
--  EXAMPLE:
--    	SELECT DATEDIFF_UDF('2022-02-14 15:31:00',6); -- SELECT TO_TIMESTAMP('2022-02-14 15:31:00','YYYY-MM-DD HH24:MI:SS') - 6 FROM DUAL; -- RETURNS '2022-02-08'
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM DATE)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	FIRST_PARAM - SECOND_PARAM
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM TIMESTAMP)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	FIRST_PARAM - SECOND_PARAM::DATE
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM DATE, SECOND_PARAM INTEGER)
RETURNS DATE
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEADD(day,SECOND_PARAM*-1 ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM TIMESTAMP)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEDIFF(day,SECOND_PARAM ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM DATE)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEDIFF(day,SECOND_PARAM ,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEDIFF_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM NUMBER)
RETURNS TIMESTAMP
LANGUAGE SQL
IMMUTABLE
AS
$$
	DATEADD(day,SECOND_PARAM*-1,FIRST_PARAM)
$$;