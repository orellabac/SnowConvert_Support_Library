-- <copyright file="TIMESTAMP_CONVERTER_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT ALLOWS GETTING THE COMPLETE DAY NAME GIVEN A TIMESTAMP
-- EQUIVALENT:
-- PARAMETERS:
-- INPUT_DATE: DATE
-- RETURNS: THE DAY NAME (IN ENGLISH)
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.DAY_OF_WEEK_LONG_UDF(INPUT_DATE TIMESTAMP)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
IMMUTABLE
AS
$$
    DECODE(DAYNAME(INPUT_DATE), 'Sun' , 'Sunday'
         , 'Mon' ,'Monday'
         , 'Tue' ,'Tuesday'
         , 'Wed' ,'Wednesday'
         , 'Thu' ,'Thursday'
         , 'Fri','Friday'
         , 'Sat' ,'Saturday'
         ,'None')
$$;

-- =============================================
-- DESCRIPTION: UDF THAT ALLOWS GETTING THE COMPLETE MONTH NAME GIVEN A TIMESTAMP
-- EQUIVALENT:
-- PARAMETERS:
-- INPUT_DATE: DATE
-- RETURNS: THE MONTH NAME (IN ENGLISH)
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.MONTH_NAME_LONG_UDF(INPUT_DATE TIMESTAMP)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
IMMUTABLE
AS
$$
    DECODE(MONTHNAME(INPUT_DATE)
         , 'Jan' ,'January'
         , 'Feb' ,'February'
         , 'Mar' ,'March'
         , 'Apr' ,'April'
         , 'May' ,'May'
         , 'Jun' ,'June'
         , 'Jul' ,'July'
         , 'Aug' ,'August'
         , 'Sep' ,'September'
         , 'Oct' ,'October'
         , 'Nov' ,'November'
         , 'Dec' ,'December'
         ,'None')
$$;