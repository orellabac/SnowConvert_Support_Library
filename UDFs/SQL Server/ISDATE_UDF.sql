-- <copyright file="ISDATE_UDF.cs" company="Mobilize.Net">
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

-- =======================================================================================================
-- DESCRIPTION: THE ISDATE_UDF() FUNCTION DETERMINES WHETHER AN EXPRESSION IS A VALID DATE TYPE. 
-- EQUIVALENT: SQLSERVER'S ISDATE(DATE)
-- PARAMETERS:
-- V : EXPRESSION TO BE EVALUATED
-- RETURNS: 1 WHEN THE INPUT EXPRESSION EVALUATES TO A VALID DATE DATA TYPE; OTHERWISE IT RETURNS 0.
-- EXAMPLE:
--  SELECT ISDATE_UDF('2022-02-14'); -- SELECT ISDATE('2022-02-14'); 
--  RETURNS 1
-- =======================================================================================================

CREATE OR REPLACE FUNCTION ISDATE_UDF(V VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS 
$$
    SELECT IFF(TRY_TO_DATE(V) IS NULL, 0, 1)
$$;
