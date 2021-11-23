-- <copyright file="ASCIISTR_UDF.sql" company="Mobilize.Net">
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
-- This functions emulates the behavior of the oracle function [ASCIIUDF](https://docs.oracle.com/database/121/SQLRF/functions015.htm#SQLRF00605)
-- =============================================

-- =============================================
-- Description: Emulates the behavior of the ASCIISTR function in Oracle
-- The input parameter should be a VARCHAR with an string
-- The output will be the string with any non-ascii char replaced as an UTF
-- Example:
-- Input:
-- In Oracle:
-- select ASCIISTR('A B C Ä Ê') from dual; -- Result: 'A B C \00C4 \00CA'
-- select ASCIISTR('A B C Õ Ø') from dual; -- Result: 'A B C \00D5 \00D8'
-- select ASCIISTR('A B C Ä Ê Í Õ Ø') from dual; -- Result: 'A B C \00C4 \00CA \00CD \00D5 \00D8'
-- SELECT ASCIISTR('ABÄCDE') FROM DUAL; -- Returns AB\00C4CDE  
-- In Snowflake
-- select ASCIISTR_UDF('A B C Ä Ê') from dual; -- Result: 'A B C \00C4 \00CA'
-- select ASCIISTR_UDF('A B C Õ Ø') from dual; -- Result: 'A B C \00D5 \00D8'
-- select ASCIISTR_UDF('A B C Ä Ê Í Õ Ø') from dual; -- Result: 'A B C \00C4 \00CA \00CD \00D5 \00D8'
-- SELECT ASCIISTR_UDF('ABÄCDE') FROM DUAL; -- Returns AB\00C4CDE  
-- =============================================
--  Credit for this UDF goes to Marco Carillo
CREATE OR REPLACE FUNCTION PUBLIC.ASCIISTR_UDF (VAL STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
    let NEW_VAL;
    let AUX;
    NEW_VAL = "";
    for (var i = 0; i < VAL.length; i++) {
        AUX = VAL[i].charCodeAt(0).toString(16).toUpperCase().padStart(4, '0');
        if(isNaN(AUX)){
            NEW_VAL = NEW_VAL+"\\"+AUX;
        }else{
            NEW_VAL = NEW_VAL+VAL[i];
        }
    }
    return NEW_VAL;
$$;
