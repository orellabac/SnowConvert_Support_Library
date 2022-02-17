-- <copyright file="STUFF_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE STUFF_UDF() FUNCTION DELETES A PART OF A STRING AND THEN INSERTS ANOTHER PART 
-- INTO THE STRING, STARTING AT A SPECIFIED POSITION.
-- EQUIVALENT: SQLSERVER'S STUFF(CHARACTER_EXPRESSION, START, LENGTH, REPLACEWITH_EXPRESSION)
-- PARAMETERS:
-- S : CHARACTER DATA.
-- STARTPOS : IS AN INTEGER VALUE THAT SPECIFIES THE LOCATION TO START DELETION AND INSERTION.
-- LENGTH : IS AN INTEGER THAT SPECIFIES THE NUMBER OF CHARACTERS TO DELETE.
-- NEWSTRING : CHARACTER DATA TO INSERT IN S.
-- RETURNS: S INPUT WITH NEWSTRING BETWEEN STARTPOS AND STARTPOS + LENGTH.
-- EXAMPLE:
--  SELECT STUFF_UDF('first_string', 2,3,'SECOND'); -- SELECT STUFF('first_string', 2,3,'SECOND');
--  RETURNS fSECONDt_string
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PUBLIC.STUFF_UDF(S string, STARTPOS int, LENGTH int, NEWSTRING string)
RETURNS STRING
LANGUAGE SQL
IMMUTABLE
AS 
$$
 left(S, STARTPOS - 1) || NEWSTRING || substr(S, STARTPOS + LENGTH) 
$$;