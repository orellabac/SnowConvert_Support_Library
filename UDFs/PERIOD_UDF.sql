-- <copyright file="PERIOD_UDF.cs" company="Mobilize.Net">
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
-- Description: UDF for handle Teradata's Cast expressions
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_END_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
AS
$$
 CAST(SUBSTR(PERIOD_VAL,POSITION('*',PERIOD_VAL)+1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: UDF for handle Teradata's Cast expressions
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.PERIOD_BEGIN_UDF(PERIOD_VAL VARCHAR(22))
RETURNS TIMESTAMP
AS
$$
 CAST(SUBSTR(PERIOD_VAL,1, POSITION('*',PERIOD_VAL)-1) AS TIMESTAMP)
$$;

-- =============================================
-- Description: UDF for handle Teradata's Cast expressions
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
-- Description: UDF for handle Teradata's Cast expressions
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
-- Description: UDF for handle Teradata's Cast expressions
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
