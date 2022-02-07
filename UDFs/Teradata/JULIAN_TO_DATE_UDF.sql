-- <copyright file="JULIAN_TO_DATE_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT TRANSFORMS A JULIAN DATE (YYYYDDD) INTO THE DATE IT REPRESENTS
-- PARAMETERS:
-- JULAN DATE: CHAR - THE JULIAN DATE TO TRANSFORM
-- RETURNS: THE DATE REPRESENTATION OF THE JULIAN DATE OR NULL IF CONVERSION IS NOT POSSIBLE
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.JULIAN_TO_DATE_UDF(JULIAN_DATE CHAR(7))
RETURNS DATE  
IMMUTABLE
AS
$$
  SELECT
    CASE 
        -- Assertion: Must be exactly 7 digits
        WHEN JULIAN_DATE NOT regexp '\\d{7}' THEN NULL
        -- Assertion: Don't accept 0 or negative days in DDD format
        WHEN RIGHT(JULIAN_DATE, 3)::INTEGER < 1 THEN NULL  
        -- Assertion: All years have 365 days 
        WHEN RIGHT(JULIAN_DATE, 3)::INTEGER <366 THEN ((LEFT(JULIAN_DATE, 4)||'-01-01')::DATE + RIGHT(JULIAN_DATE, 3)::INTEGER - 1)::DATE
        -- Assertion: If days part is 366, test for leap year (noting that the change of century is not a leap year, but the millenia is)
        WHEN RIGHT(JULIAN_DATE, 3)::INTEGER = 366 THEN
            CASE 
                WHEN SUBSTR(JULIAN_DATE, 2,3) = '000' THEN ((LEFT(JULIAN_DATE, 4)||'-01-01')::DATE + RIGHT(JULIAN_DATE, 3)::INTEGER - 1)::DATE -- valid millenia leap year
                WHEN SUBSTR(JULIAN_DATE, 3,2) = '00' THEN NULL -- Century years except millenia are not leap years
                WHEN MOD(LEFT(JULIAN_DATE,4)::INTEGER,4) = 0 THEN ((LEFT(JULIAN_DATE, 4)||'-01-01')::DATE + RIGHT(JULIAN_DATE, 3)::INTEGER - 1)::DATE -- valid leap year
            END
    ELSE -- days part is invalid
            NULL
    END
$$
;