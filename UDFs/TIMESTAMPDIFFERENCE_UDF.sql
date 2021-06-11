-- <copyright file="TIMESTAMPDIFFERENCE_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCE DATETIME TERADATA'S SUBTRACTION
-- PARAMETERS:
--  DATE1 TIMESTAMP - "MINUED" TIMESTAMP
--  DATE2 TIMESTAMP - "SUBTRAHEND" TIMESTAMP
--  INPUT_PART VARCHAR - PARTS TO BE RETURNED (EQUIVALENT TO TERADATA'S INTERVAL)
-- RETURN: FORMATED VARCHAR WITH INPUT_PART REQUESTED 
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.TIMESTAMP_DIFFERENCE_UDF
(DATE1 TIMESTAMP, DATE2 TIMESTAMP, INPUT_PART VARCHAR)
RETURNS VARCHAR 
AS
$$
   DECODE(INPUT_PART,
           'YEAR',             TO_VARCHAR(DATEDIFF(YEAR, DATE2, DATE1)),
           'DAY',              TO_VARCHAR(TRUNC(DATEDIFF(SECONDS, DATE2, DATE1)/(86400))),
           'DAY TO HOUR',      TO_VARCHAR(TRUNC(DATEDIFF(SECONDS, DATE2, DATE1)/(86400))) || ' ' || PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'HOUR'),
           'DAY TO MINUTE',    TO_VARCHAR(TRUNC(DATEDIFF(SECONDS, DATE2, DATE1)/(86400))) || ' ' || PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'MINUTE'),
           'DAY TO SECOND',    TO_VARCHAR(TRUNC(DATEDIFF(SECONDS, DATE2, DATE1)/(86400))) || ' ' || PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'SECOND'),
           'HOUR',             TO_VARCHAR(DATEDIFF(HOUR, DATE2, DATE1)),
           'HOUR TO MINUTE',   TO_VARCHAR(DATEDIFF(HOUR, DATE2, DATE1)) || ':' || SPLIT_PART(PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'MINUTE'), ':', 2),
           'HOUR TO SECOND',   TO_VARCHAR(DATEDIFF(HOUR, DATE2, DATE1)) || ':' || SUBSTR(PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'SECOND'), -5),
           'MINUTE',           TO_VARCHAR(DATEDIFF(MINUTE, DATE2, DATE1)),
           'MINUTE TO SECOND', TO_VARCHAR( TRUNC(DATEDIFF(SECONDS, DATE2, DATE1)/60), 'FM9900') || ':' || SUBSTR(PUBLIC.TIME_DIFFERENCE(LEAST(DATE1,DATE2), GREATEST(DATE1, DATE2), 'SECOND'), -2),
           'SECOND',           TO_VARCHAR(DATEDIFF(SECOND, DATE2, DATE1), '9999')
            )
$$;


-- =============================================
-- DESCRIPTION: UDF THAT REPRODUCE EXTRACT 'DATE PART' FROM 'DATE TIME' SUBTRACTION
-- PARAMETERS:
--  INTERVAL_DATA VARCHAR - FORMATED VARCHAR RETURNED BY TIMESTAMP_DIFFERENCE
--  INPUT_PART VARCHAR - ORIGINAL REQUESTED PART (SAME AS TIMESTAMP_DIFFERENCE INPUT_PART)
--  REQUEST_PART VARCHAR - EXTRACT PART
-- RETURN: NUMBER OF REQUEST PART OF EXTRACT
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.EXTRACT_FROM_INTERVAL_UDF
(INTERVAL_DATA VARCHAR, INPUT_PART VARCHAR, REQUEST_PART VARCHAR)
RETURNS NUMBER 
AS
$$
    TO_NUMBER(DECODE(INPUT_PART,
           'DAY TO HOUR',     DECODE(REQUEST_PART,
                                     'DAY', SPLIT_PART(INTERVAL_DATA, ' ', 1),
                                     'HOUR',SPLIT_PART(INTERVAL_DATA, ' ', 2)
                                     ),
           'DAY TO MINUTE',   DECODE(REQUEST_PART,
                                     'DAY', SPLIT_PART(INTERVAL_DATA, ' ', 1),
                                     'HOUR', SPLIT_PART(SPLIT_PART(INTERVAL_DATA, ' ', 2), ':', 1),
                                     'MINUTE', SPLIT_PART(SPLIT_PART(INTERVAL_DATA, ' ', 2), ':', 2)
                                     ),
           'DAY TO SECOND',    DECODE(REQUEST_PART,
                                     'DAY', SPLIT_PART(INTERVAL_DATA, ' ', 1),
                                     'HOUR',SPLIT_PART(SPLIT_PART(INTERVAL_DATA, ' ', 2), ':', 1),
                                     'MINUTE', SPLIT_PART(SPLIT_PART(INTERVAL_DATA, ' ', 2), ':', 2),
                                     'SECOND', SPLIT_PART(SPLIT_PART(INTERVAL_DATA, ' ', 2), ':', 3)
                                     ),
           'HOUR TO MINUTE',   DECODE(REQUEST_PART,
                                     'HOUR', SPLIT_PART(INTERVAL_DATA, ':', 1),
                                     'MINUTE', SPLIT_PART(INTERVAL_DATA, ':', 2)
                                     ),
           'HOUR TO SECOND',   DECODE(REQUEST_PART,
                                     'HOUR', SPLIT_PART(INTERVAL_DATA, ':', 1),
                                     'MINUTE', SPLIT_PART(INTERVAL_DATA, ':', 2),
                                     'SECOND', SPLIT_PART(INTERVAL_DATA, ':', 3)
                                     ),
           'MINUTE TO SECOND', DECODE(REQUEST_PART,
                                     'MINUTE', SPLIT_PART(INTERVAL_DATA, ':', 1),
                                     'SECOND', SPLIT_PART(INTERVAL_DATA, ':', 2)
                                     )
            ))
$$;

-- =============================================
-- DESCRIPTION: UDF THAT GETS DIFFERENCE BETWEEN TWO TIMES 
-- PARAMETERS:
--  TIME1 TIME -"MINUED" TIMES
--  TIME2 TIME - "SUBTRAHEND" TIME
--  INPUT_PART VARCHAR - RETURN DATA UNTIL PART
-- RETURN: VARCHAR WITH TIME
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.TIME_DIFFERENCE_UDF
(TIME1 TIME, TIME2 TIME, INPUT_PART VARCHAR)
RETURNS VARCHAR 
AS
$$
DECODE(INPUT_PART,
        'HOUR',   CASE WHEN HOUR(TIME1) <= HOUR(TIME2) 
                    THEN TO_VARCHAR( HOUR(TIME2) - HOUR(TIME1)           , 'FM9900')
                    ELSE TO_VARCHAR( 24-ABS(HOUR(TIME1) - HOUR(TIME2))   , 'FM9900') END,
        'MINUTE', CASE WHEN HOUR(TIME1) < HOUR(TIME2) 
                    THEN TO_VARCHAR( CASE  WHEN  MINUTE(TIME1)>MINUTE(TIME2)  THEN  (HOUR(TIME2) - HOUR(TIME1)) - 1             ELSE  HOUR(TIME2) - HOUR(TIME1)            END, 'FM9900')
                    ELSE TO_VARCHAR( CASE  WHEN  MINUTE(TIME1)>MINUTE(TIME2)  THEN  (24-ABS(HOUR(TIME1) - HOUR(TIME2))) - 1     ELSE  24-ABS(HOUR(TIME1) - HOUR(TIME2))    END, 'FM9900')
                    END  || ':' ||
                  CASE WHEN MINUTE(TIME1) <= MINUTE(TIME2)
                    THEN TO_VARCHAR( MINUTE(TIME2) - MINUTE(TIME1)          , 'FM9900')
                    ELSE TO_VARCHAR( 60 - ABS(MINUTE(TIME1) - MINUTE(TIME2)), 'FM9900') END,
        'SECOND', CASE WHEN HOUR(TIME1) <= HOUR(TIME2)
                    THEN TO_VARCHAR( CASE WHEN MINUTE(TIME1) > MINUTE(TIME2)  THEN  (HOUR(TIME2) - HOUR(TIME1)) - 1             ELSE  HOUR(TIME2) - HOUR(TIME1)            END, 'FM9900')
                    ELSE TO_VARCHAR( CASE WHEN MINUTE(TIME1) > MINUTE(TIME2)  THEN  (24-ABS(HOUR(TIME1) - HOUR(TIME2))) - 1     ELSE  24-ABS(HOUR(TIME1) - HOUR(TIME2))    END, 'FM9900')
                    END || ':' ||
                  CASE WHEN MINUTE(TIME1) <= MINUTE(TIME2) 
                    THEN TO_VARCHAR( CASE WHEN SECOND(TIME1) > SECOND(TIME2)  THEN  (MINUTE(TIME2) - MINUTE(TIME1)) - 1         ELSE  MINUTE(TIME2) - MINUTE(TIME1)        END, 'FM9900')
                    ELSE TO_VARCHAR( CASE WHEN SECOND(TIME1) > SECOND(TIME2)  THEN  (60 - (MINUTE(TIME1) - MINUTE(TIME2))) - 1  ELSE  60 - (MINUTE(TIME1) - MINUTE(TIME2)) END, 'FM9900')
                    END || ':' ||
                  CASE WHEN SECOND(TIME1) <= SECOND(TIME2)
                    THEN TO_VARCHAR( SECOND(TIME2) - SECOND(TIME1),         'FM9900')
                    ELSE TO_VARCHAR( 60 - (SECOND(TIME1) - SECOND(TIME2)),  'FM9900')
                    END
      )
$$;