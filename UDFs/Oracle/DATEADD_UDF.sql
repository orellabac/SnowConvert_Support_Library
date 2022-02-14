-- <copyright file="DATEADD_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: The DATEADD_UDF() is used as a template for all the cases when there is an addition
-- between a date type and an unknown type like a FLOAT.
-- EQUIVALENT: Oracle DATE + FLOAT , TIMESTAMP + FLOAT, FLOAT + DATE , FLOAT +TIMESTAMP
-- PARAMETERS:
-- SCENARIO 1:
--      FIRST_PARAM: DATE OR TIMESTAMP
--      SECOND_PARAM: FLOAT TO BE ADDED TO FIRST_PARAM, THE UNITS REPRESENT DAYS
--  RETURNS: THE DATE RESULT OF THE SUM OF THE INPUTS
--  EXAMPLE:
--      SELECT DATEADD_UDF('2022-02-14',6); -- SELECT TO_DATE('2022-02-14','YYYY-MM-DD') + 6 FROM DUAL; -- RETURNS '2022-02-20'
-- SCENARIO 2:
--      FIRST_PARAM: FLOAT TO BE ADDED TO SECOND_PARAM, THE UNITS REPRESENT DAYS
--      SECOND_PARAM: DATE OR TIMESTAMP
--  RETURNS: THE DATE RESULT OF THE SUM OF THE INPUTS
--  EXAMPLE:
--      SELECT DATEADD_UDF(6,'2022-02-14 15:31:00'); -- SELECT 6 + TO_TIMESTAMP('2022-02-14 15:31:00','YYYY-MM-DD HH24:MI:SS') FROM DUAL; -- RETURNS '2022-02-20'

-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM DATE, SECOND_PARAM FLOAT)
RETURNS DATE
LANGUAGE SQL
IMMUTABLE
AS
$$
SELECT FIRST_PARAM + SECOND_PARAM::NUMBER
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM FLOAT, SECOND_PARAM DATE)
RETURNS DATE
LANGUAGE SQL
IMMUTABLE
AS
$$
SELECT FIRST_PARAM::NUMBER + SECOND_PARAM
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM FLOAT)
RETURNS TIMESTAMP
LANGUAGE SQL
IMMUTABLE
AS
$$
SELECT DATEADD(day, SECOND_PARAM,FIRST_PARAM)
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM FLOAT, SECOND_PARAM TIMESTAMP)
RETURNS TIMESTAMP
LANGUAGE SQL
IMMUTABLE
AS
$$
SELECT DATEADD(day, FIRST_PARAM,SECOND_PARAM)
$$;