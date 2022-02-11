-- <copyright file="SUBSTR_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT REPRODUCES TERADATA'S SUBSTR FUNCTIONALITY
-- PARAMETERS:
-- BASE_EXPRESSION: STRING - THE EXPRESSION FROM WHICH THE SUBSTRING IS TO BE EXTRACTED
-- START_POSITION: FLOAT - THE STARTING POSITION OF THE SUBSTRING TO EXTRACT FROM
-- LENGTH (Optional): FLOAT - THE STARTING POSITION OF THE SUBSTRING TO EXTRACT FROM
-- RETURNS: FORMATTED DATE
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.SUBSTR_UDF(BASE_EXPRESSION STRING, START_POSITION FLOAT, LENGTH FLOAT)
RETURNS STRING
LANGUAGE JAVASCRIPT
IMMUTABLE
AS
$$
  if (START_POSITION > 0) {
      return BASE_EXPRESSION.SUBSTR(START_POSITION -1, LENGTH);
  } else if (START_POSITION == 0 ) {
      return BASE_EXPRESSION.SUBSTR(START_POSITION, LENGTH - 1);
  } else {
      return BASE_EXPRESSION.SUBSTR(0, LENGTH + START_POSITION - 1);
  }
$$
;

CREATE OR REPLACE FUNCTION PUBLIC.SUBSTR_UDF(BASE_EXPRESSION STRING, START_POSITION FLOAT)
RETURNS STRING
LANGUAGE JAVASCRIPT
IMMUTABLE
AS
$$
  return START_POSITION > 0 ? BASE_EXPRESSION.substr(START_POSITION - 1) : BASE_EXPRESSION.substr(0);
$$
;