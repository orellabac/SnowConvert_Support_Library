-- <copyright file="UPDATE_ERROR_VARS_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: THE UPDATE_ERROR_VARS_UDF() WILL BE IN CHARGE OF UPDATING SOME ENVIRONMENT VARIABLES WITH THE ERROR VALUES SET UP IN THE EXEC CATCH BLOCK,
-- SUCH AS MESSAGE_TEXT, SQLCODE, SQLSTATE,  PROC_NAME AND ERROR_LINE, IN ORDER TO EMULATE THE SQL SERVER ERROR_LINE, ERROR_MESSAGE, ERROR_NUMBER, 
-- ERROR_PROCEDURE AND ERROR_STATE BUILT IN FUNCTIONS BEHAVOUR AND FINALLY HAVE ACCESS TO THEM IN THE SQL SCOPE. 
-- EQUIVALENT: HAVE ACCESS IN THE SQL SCOPE TO QL SERVER ERROR_LINE, ERROR_MESSAGE, ERROR_NUMBER, 
-- ERROR_PROCEDURE AND ERROR_STATE BUILT IN FUNCTIONS BEHAVOUR
-- =========================================================================================================

CREATE OR REPLACE FUNCTION UPDATE_ERROR_VARS_UDF(LINE STRING,CODE STRING, STATE STRING, MESSAGE STRING, PROC_NAME STRING, SEVERITY STRING) 
RETURNS STRING
LANGUAGE SQL
IMMUTABLE
AS
$$
	select
	SETVARIABLE('ERROR_LINE',LINE) ||
	SETVARIABLE('ERROR_NUMBER',CODE) ||
	SETVARIABLE('ERROR_STATE',STATE) ||
	SETVARIABLE('ERROR_MESSAGE',MESSAGE) ||
	SETVARIABLE('ERROR_PROCEDURE',PROC_NAME) ||
	SETVARIABLE('ERROR_SEVERITY',SEVERITY)
$$;

CREATE OR REPLACE FUNCTION UPDATE_ERROR_VARS_UDF(MESSAGE STRING, SEVERITY STRING, STATE STRING) 
RETURNS STRING
LANGUAGE SQL
IMMUTABLE
AS
$$
	select
	SETVARIABLE('ERROR_STATE',STATE) ||
	SETVARIABLE('ERROR_MESSAGE',MESSAGE) ||
	SETVARIABLE('ERROR_SEVERITY',SEVERITY)
$$;