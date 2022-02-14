-- <copyright file="DATE_TO_JULIANDAYS_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: The DATE_TO_JULIANDAYS_UDF() takes a DATE and returns the number of days since January 1, 4712 BC. 
-- EQUIVALENT: Oracle TO_CHAR(DATE,'J')
-- PARAMETERS:
-- D : DATE
-- RETURNS: A STRING WITH NUMBERS OF DAYS SINCE JANUARY 1, 4712
-- EXAMPLE:
-- SELECT DATE_TO_JULIANDAYS_UDF(DATE '2020-01-01'); -- SELECT TO_CHAR(DATE '2020-01-01','J') from dual; -- returns 2458850
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DATE_TO_JULIANDAYS_UDF(D DATE) 
RETURNS STRING 
IMMUTABLE
AS
$$
  TRUNC(date_part('epoch',d) / 3600 / 24 + 2440588.0)::STRING
$$;