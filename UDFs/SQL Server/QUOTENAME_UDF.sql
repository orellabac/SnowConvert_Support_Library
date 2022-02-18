-- <copyright file="QUOTENAME_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE QUOTENAME_UDF() FUNCTION MAKES A VALID SQL SERVER DELIMITED IDENTIFIER BY RETURNING A
-- UNICODE STRING WITH THE DELIMITERS ADDED.
-- EQUIVALENT: SQLSERVER'S QUOTENAME(CHARACTER_STRING, QUOTE_CHARACTER)
-- PARAMETERS:
-- STR : CHARACTER DATA TO BE QUOTED.
-- QUOTECHAR: STRING TO USE AS THE DELIMITER.
-- RETURNS: STR INPUT WITHIN QUOTECHAR INPUT.
-- EXAMPLE:
--  SELECT QUOTENAME_UDF('MOBILIZE.NET','{}'); -- SELECT QUOTENAME('MOBILIZE.NET','{}');
--  RETURNS {MOBILIZE.NET}
-- =========================================================================================================

CREATE OR REPLACE FUNCTION QUOTENAME_UDF(STR VARCHAR) 
RETURNS VARCHAR 
LANGUAGE SQL 
IMMUTABLE
AS
$$
    select concat('"',STR,'"')
$$;

CREATE OR REPLACE FUNCTION QUOTENAME_UDF(STR VARCHAR,QUOTECHAR VARCHAR) 
RETURNS VARCHAR 
LANGUAGE SQL 
IMMUTABLE
AS
$$
    SELECT 
      CASE WHEN LEN(QUOTECHAR) = 1 THEN concat(QUOTECHAR, STR,QUOTECHAR)
      ELSE CONCAT(SUBSTR(QUOTECHAR,1,1),STR,SUBSTR(QUOTECHAR,2,1))
      END CASE
$$;