-- <copyright file="MONTHS_BETWEEN_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCES MONTHS_BETWEEN FUNCTIONALITY
-- PARAMETERS:
-- FIRST_DATE: TIMESTAMP_LTZ
-- SECOND_DATE: TIMESTAMP_LTZ
-- RETURNS: NUMBER OF MONTHS BETWEEN FIRST_DATE AND SECOND_DATE
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.MONTHS_BETWEEN_UDF(FIRST_DATE TIMESTAMP_LTZ, SECOND_DATE TIMESTAMP_LTZ)
RETURNS NUMBER(20,6)
AS
$$
CASE WHEN DAY(SECOND_DATE) <= DAY(FIRST_DATE) 
           THEN TIMESTAMPDIFF(MONTH,SECOND_DATE,FIRST_DATE) 
            ELSE TIMESTAMPDIFF(MONTH,SECOND_DATE,FIRST_DATE) - 1 
END + 
(CASE 
    WHEN DAY(SECOND_DATE) = DAY(FIRST_DATE) THEN 0
    WHEN DAY(SECOND_DATE) < DAY(FIRST_DATE) AND TO_TIME(SECOND_DATE) > TO_TIME(FIRST_DATE) THEN DAY(FIRST_DATE) - DAY(SECOND_DATE) - 1
    WHEN DAY(SECOND_DATE) <= DAY(FIRST_DATE) THEN DAY(FIRST_DATE) - DAY(SECOND_DATE) 
    ELSE 31 - DAY(SECOND_DATE) + DAY(FIRST_DATE) 
 END / 31) +
(CASE 
    WHEN DAY(SECOND_DATE) = DAY(FIRST_DATE) THEN 0
    WHEN HOUR(SECOND_DATE) <= HOUR(FIRST_DATE) THEN HOUR(FIRST_DATE) - HOUR(SECOND_DATE) 
    ELSE 24 - HOUR(SECOND_DATE) + HOUR(FIRST_DATE) 
END / (24*31)) +   
(CASE 
     WHEN DAY(SECOND_DATE) = DAY(FIRST_DATE) THEN 0   
     WHEN MINUTE(SECOND_DATE) <= MINUTE(FIRST_DATE) THEN MINUTE(FIRST_DATE) - MINUTE(SECOND_DATE) 
     ELSE 24 - HOUR(SECOND_DATE) + MINUTE(FIRST_DATE) 
        END / (24*60*31)) +
(CASE 
     WHEN DAY(SECOND_DATE) = DAY(FIRST_DATE) THEN 0   
     WHEN MINUTE(SECOND_DATE) <= MINUTE(FIRST_DATE) THEN MINUTE(FIRST_DATE) - MINUTE(SECOND_DATE) 
     ELSE 24 - HOUR(SECOND_DATE) + MINUTE(FIRST_DATE) 
END / (24*60*60*31))
$$
;