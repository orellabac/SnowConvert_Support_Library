-- <copyright file="PARSENAME_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE PARSENAME_UDF() FUNCTION GETS THE PART_NUMBER INDEX OF A STRING SEPARATED BY '.'.
-- EQUIVALENT: SQLSERVER'S PARSENAME(OBJECT_NAME,OBJECT_PIECE)
-- PARAMETERS:
-- STR : NAME OF THE OBJECT, DB_NAME.SCHEMA_NAME.OBJECT_NAME
-- PART_NUMBER: IS THE OBJECT PART TO RETURN. 1 = OBJECT NAME, 2 = SCHEMA NAME, 3 = DATABASE NAME
-- RETURNS: PART OF THE INPUT NAME ACCORDING TO THE PART_NUMBER.
-- EXAMPLE:
--  SELECT PARSENAME_UDF('DATABASE1.SCHEMA2.TABLE3',3); -- SELECT PARSENAME('DATABASE1.SCHEMA2.TABLE3',3);
--  RETURNS 'DATABASE1'
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PARSENAME_UDF(STR VARCHAR, PART_NUMBER INT)
RETURNS VARCHAR
LANGUAGE SQL
IMMUTABLE
AS
$$
  SELECT SPLIT_PART(STR,'.', -1 * PART_NUMBER)
$$;