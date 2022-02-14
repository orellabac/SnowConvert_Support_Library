-- <copyright file="JSDATE_UDF.cs" company="Mobilize.Net">
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
-- DESCRIPTION: The JSDATE_UDF() function takes a DATE in string format and returns the string as a date
-- with the specified format.  Is used to avoid a format error when the NLS_DATE_FORMAT has been changed
-- EQUIVALENT: (Contexto: Proc en Oracle, ALTER en DATE FORMAT a HOLANDES, CAMBIA TODAS LAS FECHAS) JS A JS PASANDO FECHAS 
-- PARAMETERS:
-- 	DATESTR: STRING TO BE FORMATTED AS DATE
-- EXAMPLE:
-- 	SELECT PUBLIC.JSDATE_UDF('2022-02-14T15:31:00.00'); returns '2022-02-14'
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.JSDATE_UDF(DATESTR STRING) 
RETURNS DATE 
LANGUAGE SQL 
IMMUTABLE
AS
$$
	SELECT TO_DATE(DATESTR,'YYYY-MM-DD"T"HH24:MI:SS.FF')
$$;