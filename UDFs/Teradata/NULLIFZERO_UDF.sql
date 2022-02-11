-- <copyright file="NULLIFZERO_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S NULLIFZERO FUNCTIONALITY
-- PARAMETERS:
-- NUMBER_TO_VALIDATE: NUMBER - INPUT NUMBER THAT WILL BE CHECKED.
-- RETURNS: NULL IF THE NUMBER IS ZERO, OTHERWISE THE NUMBER
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.NULLIFZERO_UDF(NUMBER_TO_VALIDATE NUMBER)
RETURNS NUMBER
LANGUAGE SQL
IMMUTABLE
AS
$$
    DECODE(NUMBER_TO_VALIDATE , 0, NULL, NUMBER_TO_VALIDATE)
$$;
