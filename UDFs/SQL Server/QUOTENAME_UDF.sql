-- <copyright file="QUOTENAME_UDF.cs" company="Mobilize.Net">
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
-- Description: The QUOTENAME() function makes a valid  SQL Server delimited identifier by returning a
-- Unicode string with the delimiters added.
-- =========================================================================================================

CREATE OR REPLACE FUNCTION QUOTENAME_UDF(STR VARCHAR) RETURNS VARCHAR LANGUAGE SQL AS
$$
    select concat('"',STR,'"')
$$;

CREATE OR REPLACE FUNCTION QUOTENAME_UDF(STR VARCHAR,QUOTECHAR VARCHAR) RETURNS VARCHAR LANGUAGE SQL AS
$$
    SELECT 
      CASE WHEN LEN(QUOTECHAR) = 1 THEN concat(QUOTECHAR, STR,QUOTECHAR)
      ELSE CONCAT(SUBSTR(QUOTECHAR,1,1),STR,SUBSTR(QUOTECHAR,2,1))
      END CASE
$$;