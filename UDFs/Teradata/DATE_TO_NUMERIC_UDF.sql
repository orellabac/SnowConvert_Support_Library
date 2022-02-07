-- <copyright file="DATE_TO_NUMERIC_UDF.sql" company="Mobilize.Net">
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

-- =============================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S DATE-TO-NUMERIC FUNCTIONALITY
-- PARAMETERS:
--  DATE_TO_CONVERT: DATE
-- RETURNS: INPUT DATE CONVERTED INTO NUMERIC DATATYPE 
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.DATE_TO_INT_UDF(DATE_TO_CONVERT DATE)
RETURNS INT
IMMUTABLE
AS
$$
SELECT  (EXTRACT(YEAR FROM DATE_TO_CONVERT) - 1900) * 10000 + (EXTRACT(MONTH FROM DATE_TO_CONVERT) * 100) + (EXTRACT(DAY FROM DATE_TO_CONVERT))
$$;

-- =============================================
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S NUMERIC-TO-DATE FUNCTIONALITY
-- PARAMETERS:
-- NUMERIC_EXPRESSION: INTEGER - NUMBER TO CONVERT
-- RETURNS: INPUT NUMBER CONVERTED INTO DATE DATATYPE 
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.INT_TO_DATE_UDF(NUMERIC_EXPRESSION INTEGER)
RETURNS DATE
IMMUTABLE
AS
$$
TO_DATE(CAST(NUMERIC_EXPRESSION+19000000 AS CHAR(8)), 'YYYYMMDD')
$$;
