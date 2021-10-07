-- <copyright file="PERIOD_UDF.sql" company="Mobilize.Net">
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
-- This file holds UDFs with that have the objective of emulating the functions related with the Teradata period type and its functions
-- Snowflake does not support the period type or its related functions, for more information on how SnowConvert handles periods and how these UDFs work please refer to
-- https://app.gitbook.com/@mobilizenet/s/snowconvert/for-teradata/issues/mscewi2053
-- =============================================

-- =============================================
-- Description: Emulates the behavior of the END function from Teradata
-- The input parameter should be a VARCHAR representing a period in the form 'beginningBound*EndingBound' as specified in MSCEWI2053 documentation
-- Returns a timestamp representing the ending bound of the period
-- Example:
-- Input:
--      SELECT PUBLIC.PERIOD_END_UDF('2015-02-13 12:15:30*2020-02-13 08:45:15')
-- Returns:
--      A timestamp with value 2020-02-13 08:45:15.000
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_END_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
AS
$$
 CAST(SUBSTR(PERIOD_VAL,POSITION('*',PERIOD_VAL)+1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: Emulates the behavior of the BEGIN function from Teradata
-- The input parameter should be a VARCHAR representing a period in the form 'beginningBound*EndingBound' as specified in MSCEWI2053 documentation
-- Returns a timestamp representing the ending bound of the period
-- Example:
-- Input:
--      SELECT PUBLIC.PERIOD_BEGIN_UDF('2020-10-05*2021-09-27')
-- Returns:
--      A timestamp with value 2020-10-05 00:00:00.000
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_BEGIN_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
AS
$$
 CAST(SUBSTR(PERIOD_VAL,1, POSITION('*',PERIOD_VAL)-1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: Emulates the behavior of the LDIFF function from Teradata
-- Both parameters should be VARCHAR representing periods in the form 'beginningBound*EndingBound' as specified in MSCEWI2053 documentation
-- The result is either a period of the form 'beginningBound*EndingBound' that represensts the value of the RDIFF or null, check the Teradata documentation of LDIFF for more information on the results
-- Example:
-- Input:
--      SELECT PUBLIC.PERIOD_LDIFF_UDF('2020-08-28*2025-10-15', '2020-12-15*2023-05-18');
-- Returns:
--       '2020-08-28*2020-12-15'
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_LDIFF_UDF(PERIOD_1 VARCHAR(50), PERIOD_2 VARCHAR(50))
RETURNS VARCHAR
AS
$$
 CASE WHEN PUBLIC.PERIOD_OVERLAPS_UDF(PERIOD_2, PERIOD_1) = 'TRUE' 
            AND PUBLIC.PERIOD_BEGIN_UDF(PERIOD_1) < PUBLIC.PERIOD_BEGIN_UDF(PERIOD_2) 
       THEN
        SUBSTR(PERIOD_1,1, POSITION('*',PERIOD_1)-1) || '*' || SUBSTR(PERIOD_2,1, POSITION('*',PERIOD_2)-1)
       ELSE
         NULL
       END     
$$;

-- =============================================
-- Description: Emulates the behavior of the RDIFF function from Teradata
-- Both parameters should be VARCHAR representing periods in the form 'beginningBound*EndingBound' as specified in MSCEWI2053 documentation
-- The result is either a period of the form 'beginningBound*EndingBound' that represensts the value of the RDIFF or null, check the Teradata documentation of RDIFF for more information on the results
-- Example:
-- Input:
--      SELECT PUBLIC.PERIOD_RDIFF_UDF('2020-08-28*2025-10-15', '2020-12-15*2023-05-18');
-- Returns:
--      '2023-05-18*2025-10-15'
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_RDIFF_UDF(PERIOD_1 VARCHAR(50), PERIOD_2 VARCHAR(50))
RETURNS VARCHAR
AS
$$
CASE WHEN PUBLIC.PERIOD_OVERLAPS_UDF(PERIOD_2, PERIOD_1) = 'TRUE' 
            AND PUBLIC.PERIOD_END_UDF(PERIOD_1) > PUBLIC.PERIOD_END_UDF(PERIOD_2) 
       THEN
        SUBSTR(PERIOD_2,POSITION('*',PERIOD_2)+1) || '*' || SUBSTR(PERIOD_1,POSITION('*',PERIOD_1)+1)
       ELSE
         NULL
       END
$$;

-- =============================================
-- Description: Emulates the behavior of the OVERLAPS function from Teradata
-- Both parameters should be VARCHAR representing periods in the form 'beginningBound*EndingBound' as specified in MSCEWI2053 documentation
-- The result is a boolean that indicates if the two periods overlap, check the Teradata documentation of OVERLAPS for more information on the results
-- Example:
-- Input:
--      SELECT PUBLIC.PERIOD_OVERLAPS_UDF('2020-08-28*2025-10-15', '2020-12-15*2023-05-18');
-- Returns:
--      TRUE
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_OVERLAPS_UDF(PERIOD_1 VARCHAR(22), PERIOD_2 VARCHAR(22))
RETURNS BOOLEAN 
AS
$$
 CASE WHEN 
    (PUBLIC.PERIOD_END_UDF(PERIOD_1) >= PUBLIC.PERIOD_BEGIN_UDF(PERIOD_2) AND
     PUBLIC.PERIOD_BEGIN_UDF(PERIOD_1)  < PUBLIC.PERIOD_END_UDF(PERIOD_2))
    OR
    (PUBLIC.PERIOD_BEGIN_UDF(PERIOD_1) >= PUBLIC.PERIOD_BEGIN_UDF(PERIOD_2)AND
     PUBLIC.PERIOD_BEGIN_UDF(PERIOD_1) < PUBLIC.PERIOD_END_UDF(PERIOD_2)
    )
THEN
    TRUE
ELSE
    FALSE
END 
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(timestamp) value, used to emulate the Teradata Period Value Constructor Function.
-- This version generates the resulting string using the default format Snowflake has for representing timestamp values, if you require less or more precision
-- either change the session parameter TIMESTAMP_OUTPUT_FORMAT or use the three parameters version of this UDF 
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIMESTAMP_NTZ, D2 TIMESTAMP_NTZ)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(D2)
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(date) value, used to emulate the Teradata Period Value Constructor Function.
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 DATE, D2 DATE)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(D2)
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(time) value, used to emulate the Teradata Period Value Constructor Function.
-- This version generates the resulting string using the default format Snowflake has for representing timestamp values, if you require less or more precision
-- either change the session parameter TIME_OUTPUT_FORMAT or use the three parameters version of this UDF 
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIME, D2 TIME)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(D2)
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(timestamp) value, this version allows to define how many precision digits are
-- desired in the result (up to 9, however, please keep in mind Teradata maximum precision for timestamps is 6)
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIMESTAMP_NTZ, D2 TIMESTAMP_NTZ, PRECISIONDIGITS INT)
RETURNS STRING
AS
$$
CASE WHEN PRECISIONDIGITS <= 0 THEN
        TO_VARCHAR(D1, 'YYYY-MM-DD HH24:MI:SS') || '*' || TO_VARCHAR(D2, 'YYYY-MM-DD HH24:MI:SS')
     WHEN PRECISIONDIGITS > 9 THEN
        TO_VARCHAR(D1, 'YYYY-MM-DD HH24:MI:SS.FF9') || '*' || TO_VARCHAR(D2, 'YYYY-MM-DD HH24:MI:SS.FF9')
     ELSE
        TO_VARCHAR(D1, 'YYYY-MM-DD HH24:MI:SS.FF' || PRECISIONDIGITS) || '*' || TO_VARCHAR(D2, 'YYYY-MM-DD HH24:MI:SS.FF' || PRECISIONDIGITS)
END
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(time) value, this version allows to define how many precision digits are
-- desired in the result (up to 9, however, please keep in mind Teradata maximum precision for time is 6)
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIME, D2 TIME, PRECISIONDIGITS INT)
RETURNS STRING
AS
$$
CASE WHEN PRECISIONDIGITS <= 0 THEN
        TO_VARCHAR(D1, 'HH24:MI:SS') || '*' || TO_VARCHAR(D2, 'HH24:MI:SS')
     WHEN PRECISIONDIGITS > 9 THEN
        TO_VARCHAR(D1, 'HH24:MI:SS.FF9') || '*' || TO_VARCHAR(D2, 'HH24:MI:SS.FF9')
     ELSE
        TO_VARCHAR(D1, 'HH24:MI:SS.FF' || PRECISIONDIGITS) || '*' || TO_VARCHAR(D2, 'HH24:MI:SS.FF' || PRECISIONDIGITS)
END
$$;

-- =============================================
-- Description: Emulates the Teradata Period Value Constructor Function overload with a single timestamp parameter, in the original behavior Teradata adds one
-- to the smallest time part of the timestamp (up to microseconds at precision 6) but Snowflake timestamps default to precision 9 (nanoseconds), a microsecond is
-- added to match Teradata's maximum precision for timestamps so results might differ at lower precisions
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIMESTAMP_NTZ)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(DATEADD(MICROSECOND, 1, D1))
$$;

-- =============================================
-- Description: Emulates the Teradata Period Value Constructor Function overload with a single date parameter
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 DATE)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(DATEADD(DAY, 1, D1))
$$;

-- =============================================
-- Description: Emulates the Teradata Period Value Constructor Function overload with a single time parameter, in the original behavior Teradata adds one
-- to the smallest time part of the time type (up to microseconds at precision 6) but Snowflake time type defaults to precision 9 (nanoseconds), a microsecond is
-- added to match Teradata's maximum precision for time so results might differ at lower precisions
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 TIME)
RETURNS STRING
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(DATEADD(MICROSECOND, 1, D1))
$$;