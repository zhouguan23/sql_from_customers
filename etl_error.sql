SELECT
	LOG_DATE,
	TRANSNAME,
	STEPNAME,
	ERRORS,
	RESULT
FROM
	huafa_ods.dbo.ETL_JOBDTL
	WHERE CONVERT(VARCHAR(10),LOG_DATE,120)='${sdate}'
	ORDER BY TRANSNAME,LOG_DATE

