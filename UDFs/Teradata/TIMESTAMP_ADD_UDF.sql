-- <copyright file="TIMESTAMP_ADD_UDF.sql" company="Mobilize.Net">
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
-- DESCRIPTION: UDF THAT ALLOWS THE ADDITION OF 2 DIFFERENT TIMESTAMPS
-- EQUIVALENT: TERADATA'S TIMESTAMP + TIMESTAMP
-- PARAMETERS:
-- FIRST_DATE: TIMESTAMP_LTZ
-- SECOND_DATE: TIMESTAMP_LTZ
-- RETURNS: A TIMESTAMP RESULTING FROM THE ADDITION OF FIRST_DATE AND SECOND_DATE
-- =============================================
CREATE OR REPLACE FUNCTION PUBLIC.TIMESTAMP_ADD_UDF(FIRST_DATE TIMESTAMP_LTZ, SECOND_DATE TIMESTAMP_LTZ)
RETURNS TIMESTAMP
IMMUTABLE
AS
$$
	TIMESTAMPADD(YEAR, YEAR(SECOND_DATE), TIMESTAMPADD(MONTH, MONTH(SECOND_DATE), TIMESTAMPADD(DAY, DAY(SECOND_DATE), 
	TIMESTAMPADD(SECOND, SECOND(SECOND_DATE), TIMESTAMPADD(MINUTE, MINUTE(SECOND_DATE), TIMESTAMPADD(HOUR, HOUR(SECOND_DATE), FIRST_DATE))))))
$$;