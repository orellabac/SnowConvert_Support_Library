-- <copyright file="PATINDEX_UDF.cs" company="Mobilize.Net">
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
-- Description: The PATINDEX function returns the starting position of the first occurrence of a pattern 
-- in a specified expression or zeros if the pattern is not found
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PATINDEX_UDF(PATTERN VARCHAR, EXPRESSION VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  SELECT CHARINDEX(TRIM(PATTERN, '%'), EXPRESSION)
$$;