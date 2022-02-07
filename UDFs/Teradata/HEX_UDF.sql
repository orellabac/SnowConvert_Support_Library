-- <copyright file="HEX_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S CHAR2HEXINT FUNCTIONALITY
-- PARAMETERS:
-- INPUT_STRING: VARCHAR - STRING TO CONVERT
-- RETURNS: HEXADECIMAL REPRESENTATION OF THE STRING
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.CHAR2HEXINT_UDF (INPUT_STRING VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
IMMUTABLE
AS $$
  return INPUT_STRING.split('').map( e => "00" + e.charCodeAt(0).toString(16) ).join('');
$$
;