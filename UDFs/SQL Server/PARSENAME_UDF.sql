-- <copyright file="PARSENAME_UDF.cs" company="Mobilize.Net">
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
-- Description: The PARSENAME() function gets the PART_Number index of a String
-- separated by '.'.
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PARSENAME_UDF(STR VARCHAR, PART_NUMBER INT)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
  SELECT SPLIT_PART(STR,'.', -1 * PART_NUMBER)
$$;