-- <copyright file="PATINDEX_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE PATINDEX_UDF() FUNCTION RETURNS THE STARTING POSITION OF THE FIRST OCCURRENCE OF A PATTERN 
-- IN A SPECIFIED EXPRESSION OR ZEROS IF THE PATTERN IS NOT FOUND
-- EQUIVALENT: SQLSERVER'S PATINDEX('%PATTERN%' , EXPRESSION)
-- PARAMETERS:
-- PATTERN : CHARACTER EXPRESSION THAT CONTAINS THE SEQUENCE TO BE FOUND.
-- EXPRESSION: COLUMN OR EXPRESSION THAT IS SEARCHED FOR THE SPECIFIED PATTERN
-- RETURNS: NUMBER WITH THE STARTING POSITION OF THE FIRST OCCURRENCE OF A PATTERN IN A SPECIFIED EXPRESSION OR ZEROS IF THE PATTERN IS NOT FOUND.
-- EXAMPLE:
--  SELECT PATINDEX_UDF('%.net%','Mobilize.net'); -- SELECT PATINDEX('%.net%','Mobilize.net');
--  RETURNS 9
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PATINDEX_UDF(PATTERN VARCHAR, EXPRESSION VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS
$$
  SELECT CHARINDEX(TRIM(PATTERN, '%'), EXPRESSION)
$$;