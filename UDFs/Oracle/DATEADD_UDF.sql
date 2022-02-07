-- <copyright file="DATEADD_UDF.sql" company="Mobilize.Net">
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
-- Description: The DATEADD_UDF() is used as a template for all the cases when there is an addition
-- between a date type and an unknown type.
-- =========================================================================================================
CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM DATE, SECOND_PARAM FLOAT) 
RETURNS VARIANT LANGUAGE SQL AS
$$
	NULL
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM FLOAT, SECOND_PARAM DATE) 
RETURNS VARIANT LANGUAGE SQL AS
$$
	NULL
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM TIMESTAMP, SECOND_PARAM FLOAT) 
RETURNS VARIANT LANGUAGE SQL AS
$$
	NULL
$$;

CREATE OR REPLACE FUNCTION PUBLIC.DATEADD_UDF(FIRST_PARAM FLOAT, SECOND_PARAM TIMESTAMP) 
RETURNS VARIANT LANGUAGE SQL AS
$$
	NULL
$$;