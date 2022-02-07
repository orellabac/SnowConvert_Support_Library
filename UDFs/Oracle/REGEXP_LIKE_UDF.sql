-- <copyright file="REGEXP_LIKE_UDF.sql" company="Mobilize.Net">
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
-- Description: The REGEXP_LIKE_UDF() is created to achieve the functional equivalence in Snowflake 
-- of the REGEXP_LIKE oracle condition.
-- =========================================================================================================

CREATE OR REPLACE FUNCTION REGEXP_LIKE_UDF(COL STRING, PATTERN STRING, MATCHPARAM STRING) 
RETURNS BOOLEAN LANGUAGE JAVASCRIPT AS
$$
return COL.match(new RegExp(PATTERN, MATCHPARAM));
$$;

CREATE OR REPLACE FUNCTION REGEXP_LIKE_UDF(COL STRING, PATTERN STRING) 
RETURNS BOOLEAN LANGUAGE JAVASCRIPT AS
$$
return COL.match(new RegExp(PATTERN));
$$;
