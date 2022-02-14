-- <copyright file="REGEXP_LIKE_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: The REGEXP_LIKE_UDF() is created to achieve the functional equivalence in Snowflake 
-- of the REGEXP_LIKE oracle condition.
-- EQUIVALENT: Oracle REGEXP_LIKE
-- PARAMETERS:
-- 	COL: IS A CHARACTER EXPRESSION THAT SERVES AS THE SEARCH VALUE.
--  PATTERN: REGULAR EXPRESSION
--  MATCHPARAM: IS A TEXT LITERAL THAT LETS YOU CHANGE THE DEFAULT MATCHING BEHAVIOR OF THE FUNCTION ('g' is for global. 
--  'i' is for ignoreCase. 'm' is for multiline. 's' is for dotAll. 'y' is for sticky)
-- EXAMPLE:
--  Let's say table NAMES has a column called FIRST_NAME with the following values : ('Stephen','Steven','Steban','Esteven')
--  1:
--      SELECT FIRST_NAME FROM NAMES
--      WHERE REGEXP_LIKE_UDF (first_name, 'Ste(v|ph)en$');
--      RETURNS ('Stephen','Steven')
--  2:
--      SELECT FIRST_NAME FROM NAMES
--      WHERE REGEXP_LIKE_UDF (first_name, 'Ste(v|ph)en$','i');
--      RETURNS ('Stephen','Steven','Esteven') 
-- =========================================================================================================

CREATE OR REPLACE FUNCTION REGEXP_LIKE_UDF(COL STRING, PATTERN STRING, MATCHPARAM STRING) 
RETURNS BOOLEAN 
LANGUAGE JAVASCRIPT 
IMMUTABLE
AS
$$
return COL.match(new RegExp(PATTERN, MATCHPARAM));
$$;

CREATE OR REPLACE FUNCTION REGEXP_LIKE_UDF(COL STRING, PATTERN STRING) 
RETURNS BOOLEAN 
LANGUAGE JAVASCRIPT 
IMMUTABLE
AS
$$
return COL.match(new RegExp(PATTERN));
$$;
