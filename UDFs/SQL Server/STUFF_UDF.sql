-- <copyright file="STUFF_UDF.cs" company="Mobilize.Net">
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
-- Description: The STUFF() function deletes a part of a string and then inserts another part 
---into the string, starting at a specified position.
-- =========================================================================================================

CREATE OR REPLACE FUNCTION PUBLIC.STUFF_UDF(S string, STARTPOS int, LENGTH int, NEWSTRING string)
RETURNS string
LANGUAGE SQL
AS 
$$
 left(S, STARTPOS) || NEWSTRING || substr(S, STARTPOS + LENGTH + 1) 
$$;