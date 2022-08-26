SELECT
	ROUND(SUM(QTY)/10000,2) AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,
CASE WHEN BUYERAREANAME ='' OR BUYERAREANAME IS NULL THEN '空' ELSE BUYERAREANAME
END AS BUYERAREANAME,
CASE WHEN AREANAME ='' OR AREANAME IS NULL THEN '空' ELSE AREANAME
END AS AREANAME,
CASE WHEN PROVINCE ='' OR PROVINCE IS NULL THEN '空' ELSE PROVINCE
END AS PROVINCE,
CASE WHEN CATN ='' OR CATN IS NULL THEN '空' ELSE CATN
END AS CATN,
CASE WHEN PRDN  ='' OR PRDN  IS NULL THEN '空' ELSE PRDN 
END AS PRDN 
FROM
	DW_DEPT_SALE 
WHERE 1=1
${if(len(ZL) == 0,"","and STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}


AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${EDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,AREANAME,CATN,PRDN,PROVINCE



SELECT
CASE WHEN BUYERAREANAME ='' OR BUYERAREANAME IS NULL THEN '空' ELSE BUYERAREANAME
END AS BUYERAREANAME,
CASE WHEN AREANAME ='' OR AREANAME IS NULL THEN '空' ELSE AREANAME
END AS AREANAME,
CASE WHEN PROVINCE ='' OR PROVINCE IS NULL THEN '空' ELSE PROVINCE
END AS PROVINCE,
CASE WHEN A.CATN ='' OR A.CATN IS NULL THEN '空' ELSE A.CATN
END AS CATN,
CASE WHEN A.PRDN  ='' OR A.PRDN  IS NULL THEN '空' ELSE A.PRDN 
END AS PRDN ,
	ROUND(SUM (MONTH_PRICE),2) AS MONTH_PRICE,
	ROUND(SUM (MONTH_PRICE/UNITPRICE),2) AS TARGET_QTY
FROM
	AREANAME_TARGET_PRICE A
LEFT JOIN 
(SELECT DISTINCT PRDN, UNITPRICE FROM PRODUCT) C
ON A.PRDN=C.PRDN
WHERE 1=1
AND FLAG='部门'
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and A.PRDN in ('" + PRDN + "')")}
AND SUBSTR('${SDATE}',1,4)=DATES
AND SUBSTR('${SDATE}',6,2)<=MONTHS
AND SUBSTR('${EDATE}',6,2)>=MONTHS
GROUP BY  	
  BUYERAREANAME,
  AREANAME,
  PROVINCE,
  CATN,
  A.PRDN


SELECT DISTINCT AREANAME FROM DIM_AREANAME_CHANNEL

SELECT DISTINCT VARIETIES AS CATN FROM TABLE_STRATEGIC 
WHERE 1=1
${if(len(awe)==0,""," and VARIETIES IN ('"+SUBSTITUTE(awe,",","','")+"')")}
	ORDER BY VARIETIES DESC


	SELECT
	DISTINCT PRDN
FROM
	PRODUCT
	WHERE CATN  
	 in ('${CATN}') 




SELECT DISTINCT MANAGEMENT_MODEL FROM DW_DEPT_SALE A WHERE MANAGEMENT_MODEL IS NOT NULL

SELECT
D.BUYERAREANAME,
D.AREANAME,
D.PROVINCE,
D.PRDN,
D.TARGET_PRICE,
B.TOTAL_PRICE,
QTY,
TARGET_QTY/10000 AS TARGET_QTY,
TOTAL_PRICE/DECODE(TARGET_PRICE,0,0.001,TARGET_PRICE)  RATE,
QTY/DECODE(TARGET_QTY,0,0.0001,TARGET_QTY)  AS QTY_RATE
FROM (
   SELECT
	A.BUYERAREANAME,
     A.AREANAME,
     A.PRDN,
     A.PROVINCE,
	ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,
     ROUND(SUM (MONTH_PRICE*10000/UNITPRICE),2) AS TARGET_QTY
FROM AREANAME_TARGET_PRICE A 
LEFT JOIN 
(SELECT DISTINCT PRDN, UNITPRICE FROM PRODUCT) C
ON A.PRDN=C.PRDN
WHERE 1=1
AND FLAG='部门'
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and A.PRDN in ('" + PRDN + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
GROUP BY  BUYERAREANAME,  A.AREANAME,A.PRDN,A.PROVINCE) D

LEFT JOIN 

(SELECT
	SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME,AREANAME,PRDN,PROVINCE
FROM
	DW_DEPT_SALE
WHERE 1=1
${if(len(ZL) == 0,"","and STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')

GROUP BY BUYERAREANAME,AREANAME,PRDN,PROVINCE)
B 
ON D.BUYERAREANAME=B.BUYERAREANAME
AND D.PROVINCE=B.PROVINCE
AND  D.AREANAME=B.AREANAME
AND D.PRDN=B.PRDN


SELECT 
A.BUYERAREANAME,
A.AREANAME,
A.PROVINCE,
TOTAL_PRICE,
QTY,
HIS_TOTAL_PRICE,
HIS_QTY,
(TOTAL_PRICE-HIS_TOTAL_PRICE)/DECODE(HIS_TOTAL_PRICE,0,1,HIS_TOTAL_PRICE) AS PRICE_RATE,    --同比增长
(QTY-HIS_QTY)/DECODE(HIS_QTY,0,1,HIS_QTY) AS QTY_RATE
FROM
(
SELECT
	SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME,C.AREANAME,C.PROVINCE,C.CATN
FROM
	DW_DEPT_SALE C
WHERE 1=1
AND BUYERAREANAME IS NOT NULL   
${if(len(ZL) == 0,"","and  STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,C.AREANAME,C.PROVINCE,C.CATN
) A
LEFT JOIN
(SELECT
	SUM(QTY) AS HIS_QTY,ROUND(SUM(TOTAL_PRICE),2) AS HIS_TOTAL_PRICE,BUYERAREANAME,D.AREANAME,D.PROVINCE,D.CATN
FROM
	FILL_SALE_HISTORY  D
WHERE FLAG='部门'
AND BUYERAREANAME IS NOT NULL
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND MONTHS>=SUBSTR('${SDATE}',6,2)
AND YEARS=SUBSTR('${EDATE}',1,4)-1
AND MONTHS<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,D.AREANAME,D.PROVINCE,D.CATN
) B
ON A.BUYERAREANAME=B.BUYERAREANAME
AND A.AREANAME=B.AREANAME
AND A.PROVINCE=B.PROVINCE
AND A.CATN=B.CATN

SELECT
	SUM(QTY) AS HIS_QTY,ROUND(SUM(TOTAL_PRICE),6) AS HIS_TOTAL_PRICE,
CASE WHEN BUYERAREANAME ='' OR BUYERAREANAME IS NULL THEN '空' ELSE BUYERAREANAME
END AS BUYERAREANAME,
CASE WHEN AREANAME ='' OR AREANAME IS NULL THEN '空' ELSE AREANAME
END AS AREANAME,
CASE WHEN PROVINCE ='' OR PROVINCE IS NULL THEN '空' ELSE PROVINCE
END AS PROVINCE,
CASE WHEN CATN ='' OR CATN IS NULL THEN '空' ELSE CATN
END AS CATN
---因为空和空对应不上，需要展示所有同期，必须将其可以关联对应到
	FROM FILL_SALE_HISTORY F
	LEFT JOIN TABLE_STRATEGIC C
    ON F.CATN=C.VARIETIES
WHERE FLAG='部门'
${if(len(ZL) == 0,"","and C.STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and TRIM(BUYERAREANAME) in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
AND MONTHS>=SUBSTR('${SDATE}',6,2)
AND YEARS=SUBSTR('${EDATE}',1,4)-1
AND MONTHS<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,AREANAME,PROVINCE,CATN


SELECT * FROM (
SELECT 
DISTINCT 
CASE WHEN BUYERAREANAME ='' OR BUYERAREANAME IS NULL THEN '空' ELSE BUYERAREANAME
END AS BUYERAREANAME,
CASE WHEN AREANAME ='' OR AREANAME IS NULL THEN '空' ELSE AREANAME
END AS AREANAME,
CASE WHEN PROVINCE ='' OR PROVINCE IS NULL THEN '空' ELSE PROVINCE
END AS PROVINCE,
CASE WHEN CATN ='' OR CATN IS NULL THEN '空' ELSE CATN
END AS CATN,
CASE WHEN PRDN  ='' OR PRDN  IS NULL THEN '空' ELSE PRDN 
END AS PRDN 
FROM DIM_AREANAME_ZLCHANNEL
WHERE 1=1
${if(len(ZL) == 0,"","and STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}

${if(qwe='全国',""," and BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
${if(awe='全国',""," OR AREANAME IN ('"+SUBSTITUTE(awe,",","','")+"')")}

)
WHERE 1=1
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(cwe)==0,""," and CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}




SELECT
    TOTAL_PRICE,
    TARGET_PRICE,
	ROUND (TOTAL_PRICE /DECODE(TARGET_PRICE,0,1,TARGET_PRICE), 4) RATE,
	ROUND (QTY / DECODE(TARGET_QTY,0,1,TARGET_QTY), 4) AS QTY_RATE
FROM
	(
		SELECT
			1 AS FLAG,
			ROUND (SUM(MONTH_PRICE), 2) AS TARGET_PRICE,
			ROUND (SUM (MONTH_PRICE * 10000 / UNITPRICE),0) AS TARGET_QTY
		FROM
			AREANAME_TARGET_PRICE A
		LEFT JOIN (SELECT DISTINCT PRDN,UNITPRICE FROM  PRODUCT) C ON A .PRDN = C.PRDN
		WHERE DATES = TO_CHAR (SYSDATE, 'YYYY')
		AND FLAG='部门'
		${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
		${if(len(ZL) == 0,"","and CHANNEL_TYPE in ('" + ZL + "')")}
		${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}
          ${if(len(PROVINCE) == 0,"","and PROVINCE in ('" + PROVINCE + "')")}	
          ${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
         
          ${if(len(cwe)==0,""," AND CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
          ${if(len(PRDN) == 0,"","and A.PRDN in ('" + PRDN + "')")}
	) A
LEFT JOIN

 (
	SELECT
		1 AS FLAG,
		SUM (QTY) AS QTY,
		ROUND (SUM(TOTAL_PRICE) / 10000, 2) AS TOTAL_PRICE
	FROM
		DW_DEPT_SALE A
	WHERE SUBSTR (POSTDATE, 1, 4) = TO_CHAR (SYSDATE, 'YYYY')
     ${if(len(ZL) == 0,"","and A.STRATEGICCHANNEL in ('" + ZL + "')")}
	${if(len(PROVINCE) == 0,"","and PROVINCE in ('" + PROVINCE + "')")}
	${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
	${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
     ${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
     
     ${if(len(cwe)==0,""," AND CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
     ${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}	
) B 
ON A.FLAG=B.FLAG

SELECT DISTINCT AREANAME FROM DW_DEPT_SALE WHERE 1=1
${if(awe='全国',""," OR AREANAME IN ('"+SUBSTITUTE(awe,",","','")+"')")}

