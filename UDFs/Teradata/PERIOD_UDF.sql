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
-- Description: Emulates the behavior of the END function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_END_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
IMMUTABLE
AS
$$
 CAST(SUBSTR(PERIOD_VAL,POSITION('*',PERIOD_VAL)+1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: Emulates the behavior of the BEGIN function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_BEGIN_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
IMMUTABLE
AS
$$
 CAST(SUBSTR(PERIOD_VAL,1, POSITION('*',PERIOD_VAL)-1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: Emulates the behavior of the LDIFF function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_LDIFF_UDF(PERIOD_1 VARCHAR(50), PERIOD_2 VARCHAR(50))
RETURNS VARCHAR
IMMUTABLE
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
-- Description: Emulates the behavior of the RDIFF function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_RDIFF_UDF(PERIOD_1 VARCHAR(50), PERIOD_2 VARCHAR(50))
RETURNS VARCHAR
IMMUTABLE
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
-- Description: Emulates the behavior of the OVERLAPS function
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_OVERLAPS_UDF(PERIOD_1 VARCHAR(22), PERIOD_2 VARCHAR(22))
RETURNS BOOLEAN
IMMUTABLE
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
IMMUTABLE
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(D2)
$$;

-- =============================================
-- Description: Generates a varchar representation of the two bounds of a period(date) value, used to emulate the Teradata Period Value Constructor Function.
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 DATE, D2 DATE)
RETURNS STRING
IMMUTABLE
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
IMMUTABLE
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
IMMUTABLE
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
IMMUTABLE
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
IMMUTABLE
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(DATEADD(MICROSECOND, 1, D1))
$$;

-- =============================================
-- Description: Emulates the Teradata Period Value Constructor Function overload with a single date parameter
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_UDF(D1 DATE)
RETURNS STRING
IMMUTABLE
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
IMMUTABLE
AS
$$
TO_VARCHAR(D1) || '*' || TO_VARCHAR(DATEADD(MICROSECOND, 1, D1))
$$;