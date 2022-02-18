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
-- DESCRIPTION: THE JSDATE_UDF() FUNCTION TAKES A DATE IN STRING FORMAT AND RETURNS THE STRING AS A DATE WITH FORMAY 'YYYY-MM-DD'.
-- IS USED TO AVOID A FORMAT ERROR WHEN THE NLS_DATE_FORMAT HAS BEEN CHANGED, OR WHEN USING THE DATE OUTPUT OF A QUERY OR FUNCTION WITHIN A JS PROCEDURE AS AN
-- INPUT TO THER QUERY, OR FUNCTION
-- EQUIVALENT:
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