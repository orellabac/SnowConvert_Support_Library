-- <copyright file="ERROR_PROCEDURE_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE ERROR_PROCEDURE_UDF() RETURNS THE NAME OF THE STORED PROCEDURE OR TRIGGER WHERE AN ERROR OCCURS, IF THAT ERROR CAUSED THE CATCH BLOCK WITHIN THE EXEC HELPER.
-- EQUIVALENT: SQL SERVER'S ERROR_PROCEDURE()
-- =========================================================================================================

CREATE OR REPLACE FUNCTION ERROR_PROCEDURE_UDF() 
RETURNS STRING
LANGUAGE SQL 
IMMUTABLE
AS
$$
	SELECT GETVARIABLE('ERROR_PROCEDURE')
$$;
