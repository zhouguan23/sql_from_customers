	SELECT
	DISTINCT PRDN
FROM
	PRODUCT
	WHERE CATN  
	 in ('${CATN}') 




SELECT DISTINCT VARIETIES FROM TABLE_STRATEGIC 
WHERE 1=1
${if(len(ZL) == 0,"","and STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(awe)==0,""," and VARIETIES IN ('"+SUBSTITUTE(awe,",","','")+"')")}
	ORDER BY VARIETIES DESC




SELECT DISTINCT BUYERAREANAME FROM DW_DEPT_SALE WHERE BUYERAREANAME IS NOT NULL
${if(qwe='全国',""," and A.BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}

SELECT
	TRIM(BUYERAREANAME) AS BUYERAREANAME,
	ROUND(SUM (MONTH_PRICE),2) AS MONTH_PRICE,
     ROUND(SUM (MONTH_PRICE/UNITPRICE),4) AS MONTH_QTY
FROM
	AREANAME_TARGET_PRICE A
 LEFT JOIN  (SELECT DISTINCT PRDN, UNITPRICE FROM PRODUCT)  B
ON A.PRDN=B.PRDN
WHERE 1=1
AND FLAG='部门'
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and A.PRDN in ('" + PRDN + "')")}
AND SUBSTR('${SDATE}',1,4)=DATES
AND SUBSTR('${SDATE}',6,2)<=MONTHS
AND SUBSTR('${EDATE}',6,2)>=MONTHS
GROUP BY  BUYERAREANAME

SELECT
D.BUYERAREANAME,
D.TARGET_PRICE,
B.TOTAL_PRICE,
QTY,
TARGET_QTY/10000 AS TARGET_QTY,
TOTAL_PRICE/DECODE(TARGET_PRICE ,0,1,TARGET_PRICE) AS RATE,
QTY*10000/DECODE(TARGET_QTY,0,1,TARGET_QTY)  AS QTY_RATE
FROM (
   SELECT
	A.BUYERAREANAME,
	ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,
     ROUND(SUM (MONTH_PRICE*10000/UNITPRICE),2) AS TARGET_QTY
FROM AREANAME_TARGET_PRICE A 
LEFT JOIN 
(SELECT DISTINCT PRDN, UNITPRICE FROM PRODUCT) C
ON A.PRDN=C.PRDN
WHERE 1=1
AND FLAG='部门'
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and A.PRDN in ('" + PRDN + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
GROUP BY  BUYERAREANAME) D

LEFT JOIN 

(SELECT
	SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME
FROM
	DW_DEPT_SALE C
WHERE 1=1
${if(len(ZL) == 0,"","and  STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and C.CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and C.PRDN in ('" + PRDN + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')

GROUP BY BUYERAREANAME)
B 
ON D.BUYERAREANAME=B.BUYERAREANAME

SELECT
TOTAL_PRICE/TARGET_PRICE RATE
FROM (
   SELECT
	ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,1 AS FLAG
     ---ROUND(SUM (MONTH_PRICE/UNITPRICE),0) AS MONTH_QTY
FROM AREANAME_TARGET_PRICE A   WHERE 1=1
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
) A

LEFT JOIN 

(SELECT
	ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE, 1 AS FLAG
FROM
	DW_DEPT_SALE
WHERE 1=1
${if(len(ZL) == 0,"","and  STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')
)
B 
ON A.FLAG=B.FLAG

SELECT 
F.BUYERAREANAME,
TOTAL_PRICE,
QTY,
HIS_TOTAL_PRICE,
HIS_QTY,
(TOTAL_PRICE-HIS_TOTAL_PRICE)/DECODE(HIS_TOTAL_PRICE,0,1,HIS_TOTAL_PRICE) AS PRICE_RATE,    --同比增长
(QTY-HIS_QTY)/DECODE(HIS_QTY,0,1,HIS_QTY) AS QTY_RATE
FROM
(SELECT DISTINCT BUYERAREANAME FROM DIM_AREANAME_ZLCHANNEL WHERE 1=1
${if(len(ZL) == 0,"","and  STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and TRIM(BUYERAREANAME) in ('" + BUYERAREANAME + "')")}	
 ${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(qwe='全国',""," and TRIM(BUYERAREANAME) IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
 ) F
LEFT JOIN 
(
SELECT
	SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME
FROM  
	DW_DEPT_SALE  S
WHERE 1=1
AND BUYERAREANAME IS NOT NULL   
${if(len(ZL) == 0,"","and  STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(BUYERAREANAME) == 0,"","and TRIM(BUYERAREANAME) in ('" + BUYERAREANAME + "')")}
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
${if(qwe='全国',""," and BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}

AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME
) A
ON  F.BUYERAREANAME=A.BUYERAREANAME
LEFT JOIN
(SELECT
	SUM(QTY) AS HIS_QTY,ROUND(SUM(TOTAL_PRICE),6) AS HIS_TOTAL_PRICE,BUYERAREANAME
	FROM FILL_SALE_HISTORY F
	LEFT JOIN TABLE_STRATEGIC C
    ON F.CATN=C.VARIETIES
WHERE FLAG='部门'
${if(len(ZL) == 0,"","and C.STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and TRIM(BUYERAREANAME) in ('" + BUYERAREANAME + "')")}	
${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(qwe='全国',""," and TRIM(BUYERAREANAME) IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
AND MONTHS>=SUBSTR('${SDATE}',6,2)
AND YEARS=SUBSTR('${EDATE}',1,4)-1
AND MONTHS<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME
) B
ON F.BUYERAREANAME=B.BUYERAREANAME
WHERE F.BUYERAREANAME!='销售大区'
--AND A.BUYERAREANAME IS NOT NULL
--AND A.BUYERAREANAME !='空'



------------------------执行进度----
SELECT
    TOTAL_PRICE,
    TARGET_PRICE,
	ROUND (TOTAL_PRICE /DECODE(TARGET_PRICE,0,1,TARGET_PRICE),4) RATE,
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
		${if(len(ZL) == 0,"","and CHANNEL_TYPE in ('" + ZL + "')")}
		${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}
          ${if(len(PROVINCE) == 0,"","and PROVINCE in ('" + PROVINCE + "')")}	
          ${if(len(BUYERAREANAME) == 0,"","and A.BUYERAREANAME in ('" + BUYERAREANAME + "')")}
          ${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
          ${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
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
     ${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
	${if(len(PROVINCE) == 0,"","and PROVINCE in ('" + PROVINCE + "')")}
     ${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
     ${if(len(awe)==0,""," and CATN IN ('"+SUBSTITUTE(awe,",","','")+"')")}
     ${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
     ${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}	
) B 
ON A.FLAG=B.FLAG

