-- <copyright file="ISNUMERIC_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE ISNUMERIC() FUNCTION DETERMINES WHETHER AN EXPRESSION IS A VALID NUMERIC TYPE. 
-- EQUIVALENT: SQLSERVER'S ISNUMERIC(NUMBER)
-- PARAMETERS:
-- V : EXPRESSION TO BE EVALUATED
-- RETURNS: 1 WHEN THE INPUT EXPRESSION EVALUATES TO A VALID NUMERIC DATA TYPE; OTHERWISE IT RETURNS 0.
-- EXAMPLE:
--  SELECT ISNUMERIC_UDF(10.5); -- SELECT ISNUMERIC(10.5); 
--  RETURNS 1
-- =========================================================================================================

CREATE OR REPLACE FUNCTION ISNUMERIC_UDF(V VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
IMMUTABLE
AS 
$$
    SELECT CASE WHEN TRY_TO_NUMERIC(V) IS NULL THEN 0 ELSE 1 END
$$;
