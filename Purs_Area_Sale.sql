SELECT ROUND(SUM(QTY)/10000,2) AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME,AREANAME,PROVINCE,A.CATN,B.PRDPD
FROM DW_PUR_SELLING A LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE 1=1
AND BUYERAREANAME <>'电商事业部' 
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}	
${if(len(MANAGEMENT_MODEL) == 0,"","and MANAGEMENT_MODEL in ('" + MANAGEMENT_MODEL + "')")}
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${SDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)>=SUBSTR('${SDATE}',6,2)
AND SUBSTR(POSTDATE,1,4)=SUBSTR('${EDATE}',1,4)
AND SUBSTR(POSTDATE,6,2)<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,AREANAME,A.CATN,B.PRDPD,PROVINCE

SELECT BUYERAREANAME,AREANAME,PROVINCE,A.CATN,B.PRDPD,ROUND(SUM (MONTH_PRICE),2) AS MONTH_PRICE,ROUND(SUM (MONTH_PRICE/UNITPRICE),2) AS TARGET_QTY
FROM AREANAME_TARGET_PRICE A
LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
--LEFT JOIN (SELECT DISTINCT PRDN, UNITPRICE FROM PRODUCT) C ON A.PRDN=C.PRDN
WHERE flag='纯销'
AND BUYERAREANAME <>'电商事业部' 
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR('${SDATE}',1,4)=DATES
AND SUBSTR('${SDATE}',6,2)<=MONTHS
AND SUBSTR('${EDATE}',6,2)>=MONTHS
GROUP BY  BUYERAREANAME,AREANAME,PROVINCE,A.CATN,B.PRDPD

SELECT DISTINCT AREANAME FROM DIM_AREANAME_CHANNEL

SELECT CATN FROM PRODUCT

SELECT DISTINCT PRDPD
FROM PRODUCT WHERE CATN  in ('${CATN}') 




SELECT DISTINCT MANAGEMENT_MODEL FROM DW_DEPT_SALE A WHERE MANAGEMENT_MODEL IS NOT NULL

SELECT D.BUYERAREANAME,D.AREANAME,D.PROVINCE,D.CATN,D.PRDPD,D.TARGET_PRICE,B.TOTAL_PRICE,QTY,
TARGET_QTY/10000 AS TARGET_QTY,TOTAL_PRICE/DECODE(TARGET_PRICE,0,0.001,TARGET_PRICE)  RATE,QTY/(DECODE(TARGET_QTY,0,0.0001,TARGET_QTY)/10000)  AS QTY_RATE
FROM (
   SELECT A.BUYERAREANAME,A.AREANAME,A.CATN,B.PRDPD,A.PROVINCE,ROUND(SUM (MONTH_PRICE),2) AS TARGET_PRICE,ROUND(SUM (MONTH_PRICE*10000/UNITPRICE),2) AS TARGET_QTY
FROM AREANAME_TARGET_PRICE A 
LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE flag='纯销' 
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and SALE_TYPE in ('" + CHANNEL_TYPE + "')")}	
${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND DATES=TO_CHAR(SYSDATE,'YYYY') 
GROUP BY  BUYERAREANAME,  A.AREANAME,A.CATN,B.PRDPD,A.PROVINCE) D
LEFT JOIN 
(SELECT SUM(QTY)/10000 AS QTY,ROUND(SUM(TOTAL_PRICE)/10000,2) AS TOTAL_PRICE,BUYERAREANAME,AREANAME,A.CATN,B.PRDPD,PROVINCE
FROM DW_PUR_SELLING A
LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
WHERE 1=1
AND BUYERAREANAME <>'电商事业部' 
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	${if(len(CATN) == 0,"","and A.CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and B.PRDPD in ('" + PRDPD + "')")}
AND SUBSTR(POSTDATE,1,4)=TO_CHAR(SYSDATE,'YYYY')
GROUP BY BUYERAREANAME,AREANAME,A.CATN,B.PRDPD,PROVINCE) B 
ON D.BUYERAREANAME=B.BUYERAREANAME
AND D.PROVINCE=B.PROVINCE
AND  D.AREANAME=B.AREANAME
AND D.PRDPD=B.PRDPD

SELECT
	SUM(QTY) AS HIS_QTY,ROUND(SUM(TOTAL_PRICE),6) AS HIS_TOTAL_PRICE,BUYERAREANAME,AREANAME,PROVINCE,F.CATN
	FROM FILL_SALE_HISTORY F
	LEFT JOIN TABLE_STRATEGIC C
    ON F.CATN=C.VARIETIES
WHERE FLAG='部门'
${if(len(ZL) == 0,"","and C.STRATEGICCHANNEL in ('" + ZL + "')")}
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(len(BUYERAREANAME) == 0,"","and TRIM(BUYERAREANAME) in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and F.CATN in ('" + CATN + "')")}
AND MONTHS>=SUBSTR('${SDATE}',6,2)
AND YEARS=SUBSTR('${EDATE}',1,4)-1
AND MONTHS<=SUBSTR('${EDATE}',6,2)
GROUP BY BUYERAREANAME,AREANAME,PROVINCE,F.CATN

select * from (
select distinct BUYERAREANAME,AREANAME,PROVINCE,catn,PRDPD from
(
SELECT distinct CHANNEL_TYPE STRATEGICCHANNEL,BUYERAREANAME,AREANAME,PROVINCE,sale_type CHANNEL_TYPE,A.catn,B.PRDPD 
FROM AREANAME_TARGET_PRICE A LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
union all
SELECT distinct STRATEGICCHANNEL,BUYERAREANAME,AREANAME,PROVINCE,CHANNEL_TYPE,A.CATN,B.PRDPD 
FROM DW_PUR_SELLING A LEFT JOIN  PRODUCT B ON A.PRDN=B.PRDN
left join TABLE_STRATEGIC C on a.catn=C.VARIETIES
)
where 1=1 
AND BUYERAREANAME <>'电商事业部' 
${if(len(CHANNEL_TYPE) == 0,"","and CHANNEL_TYPE in ('" + CHANNEL_TYPE + "')")}
${if(qwe='全国',""," and BUYERAREANAME IN ('"+SUBSTITUTE(qwe,",","','")+"')")}
${if(awe='全国',""," OR AREANAME IN ('"+SUBSTITUTE(awe,",","','")+"')")}
${if(cwe='全国',""," OR CATN IN ('"+SUBSTITUTE(cwe,",","','")+"')")}
) where 1=1 

${if(len(BUYERAREANAME) == 0,"","and BUYERAREANAME in ('" + BUYERAREANAME + "')")}	
${if(len(CATN) == 0,"","and CATN in ('" + CATN + "')")}
${if(len(PRDPD) == 0,"","and PRDPD in ('" + PRDPD + "')")}


