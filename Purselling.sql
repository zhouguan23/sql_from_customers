SELECT DISTINCT PRDPD
FROM PRODUCT t
WHERE t.CATN  in ('${CATN}') 




SELECT c.CATN FROM PRODUCT c

SELECT
	SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME
FROM
	DW_DEPT_SALE
WHERE 1=1
AND BUYERAREANAME IS NOT NULL
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(PRDN) == 0,"","and PRDN in ('" + PRDN + "')")}
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${EDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME

SELECT DISTINCT BUYERAREANAME FROM DW_DEPT_SALE WHERE BUYERAREANAME IS NOT NULL

SELECT
	BUYERAREANAME,
	ROUND(SUM (MONTH_PRICE),2) AS MONTH_PRICE,
     ROUND(SUM (MONTH_PRICE/UNITPRICE),2) AS MONTH_QTY
FROM
	AREANAME_TARGET_PRICE A
 LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE flag='纯销'  
AND BUYERAREANAME <>'电商事业部' 
--AND (dept,sale_type,flag) not in (select '销售大区' dept,'商销' sale_type,'部门' flag from dual)
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR('${SDATE}',1,4)=DATES
AND SUBSTR('${SDATE}',6,2)<=MONTHS
AND SUBSTR('${EDATE}',6,2)>=MONTHS
GROUP BY  BUYERAREANAME

SELECT D.BUYERAREANAME,D.TARGET_PRICE,B.TOTAL_PRICE,QTY,
TARGET_QTY AS TARGET_QTY
--,TOTAL_PRICE/TARGET_PRICE  RATE,QTY/TARGET_QTY  AS QTY_RATE
FROM (
   SELECT A.BUYERAREANAME, ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,
     ROUND(SUM (MONTH_PRICE/UNITPRICE),2) AS TARGET_QTY
FROM AREANAME_TARGET_PRICE A 
 LEFT JOIN  PRODUCT  C ON A.PRDN=C.PRDN
WHERE flag='纯销' 
--AND (dept,sale_type,flag) not in (select '销售大区' dept,'商销' sale_type,'部门' flag from dual) 
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and C.PRDPD in ('" + PRDPD + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
GROUP BY  BUYERAREANAME) D
LEFT JOIN 
(SELECT SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME
FROM DW_PUR_SELLING A
 LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
 left join TABLE_STRATEGIC C on a.catn=C.VARIETIES
WHERE 1=1
AND BUYERAREANAME <>'电商事业部' 
${if(len(ZL) == 0,"","and  C.STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')
GROUP BY BUYERAREANAME) B ON D.BUYERAREANAME=B.BUYERAREANAME

SELECT
TOTAL_PRICE/TARGET_PRICE RATE
FROM (
   SELECT
	ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,1 AS FLAG
     ---ROUND(SUM (MONTH_PRICE/UNITPRICE),0) AS MONTH_QTY
FROM AREANAME_TARGET_PRICE A   
 LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE 1=1
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
) A

LEFT JOIN 

(SELECT
	ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE, 1 AS FLAG
FROM
	DW_DEPT_SALE A
	 LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE 1=1

${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')
)
B 
ON A.FLAG=B.FLAG

SELECT SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME
FROM DW_PUR_SELLING a left join TABLE_STRATEGIC B on a.catn=B.VARIETIES
LEFT JOIN  PRODUCT C ON A.PRDN=C.PRDN
WHERE 1=1 AND BUYERAREANAME IS NOT NULL  
AND BUYERAREANAME <>'电商事业部' 
${if(len(ZL) == 0,"","and  B.STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(CATN) == 0,"","and a.CATN in ('" + CATN + "')")}
--and a.PRDN in ('消5贴-委托处方版') 
${if(len(PRDPD) == 0,"","and C.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
${if(qwe='全国',""," and A.BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
${if(cwe='全国',""," OR a.CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
GROUP BY BUYERAREANAME

SELECT DISTINCT CHANNEL_TYPE FROM PURE_SELLING

select distinct BUYERAREANAME from (
SELECT BUYERAREANAME
FROM DW_PUR_SELLING a left join TABLE_STRATEGIC B on a.catn=B.VARIETIES
LEFT JOIN  PRODUCT C ON A.PRDN=C.PRDN
WHERE 1=1 AND BUYERAREANAME IS NOT NULL  
AND BUYERAREANAME <>'电商事业部'  
${if(len(ZL) == 0,"","and  B.STRATEGICCHANNEL in ('" + ZL + "')")}
--${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
${if(len(CATN) == 0,"","and a.CATN in ('" + CATN + "')")}
--and a.PRDN in ('消5贴-委托处方版') 
${if(len(PRDPD) == 0,"","and C.PRDPD in ('" + PRDPD + "')")}
${if(qwe='全国',""," and A.BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
${if(cwe='全国',""," OR a.CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
GROUP BY BUYERAREANAME
union all
SELECT A.BUYERAREANAME
FROM AREANAME_TARGET_PRICE A 
 LEFT JOIN  PRODUCT  C ON A.PRDN=C.PRDN
WHERE flag='纯销'  AND BUYERAREANAME <>'电商事业部'
--AND (dept,sale_type,flag) not in (select '销售大区' dept,'商销' sale_type,'部门' flag from dual) 
${if(len(ZL) == 0,"","and  CHANNEL_TYPE in ('" + ZL + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and C.PRDPD in ('" + PRDPD + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
GROUP BY  BUYERAREANAME
)
