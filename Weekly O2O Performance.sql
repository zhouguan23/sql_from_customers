select distinct area_code,area_name from DIM_REGION

select distinct cus_code,cus_name from DIM_CUS
WHERE 
1=1
${if(len(area)=0,""," and area_Code in ('"+area+"')")}

SELECT  
--A.AREA_CODE AS 区域,
--A.CUS_CODE AS 门店,
B.WEEK_ID AS 周序号,
SUM(SALE_QTY) AS 数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额
FROM  
DM_SALE_TMP A, DIM_DAY B 
WHERE 
1=1
${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
--A.AREA_CODE,
--A.CUS_CODE,
B.WEEK_ID
ORDER BY 
B.WEEK_ID

SELECT  
--A.AREA_CODE AS 区域,
--A.CUS_CODE AS 门店,
B.MONTH_ID AS 月序号,
SUM(SALE_QTY) AS 数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额
FROM  
DM_SALE_TMP A, DIM_DAY B 
WHERE 
1=1
${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
--A.AREA_CODE,
--A.CUS_CODE,
B.MONTH_ID
ORDER BY 
B.MONTH_ID

SELECT 
B.WEEK_ID AS 周序号,
SUM(TRAN_NUM) AS 交易笔次
FROM  DM_TRANSACTION  A,
DIM_DAY B
WHERE 
1=1
${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
B.WEEK_ID 


SELECT 
B.MONTH_ID AS 月序号,
SUM(TRAN_NUM) AS 交易笔次
FROM  DM_TRANSACTION  A,
DIM_DAY B
WHERE 
1=1
${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
B.MONTH_ID 

SELECT 
DDATE AS 日期,
WEEK_ID AS 星期序号,
MONTH_ID AS 年月,
YEAR_ID AS 年份
FROM 
DIM_DAY
WHERE 
YEAR_ID = SUBSTR('${YEAR}',1,4)
AND 
DDATE <= DATE'${YEAR}'
ORDER  BY 
DDATE


SELECT  
--A.AREA_CODE AS 区域,
--A.CUS_CODE AS 门店,
B.WEEK_ID AS 周序号,
SUM(SALE_QTY) AS 数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额
FROM  
DM_SALE_TMP A, DIM_DAY B 
WHERE 
1=1

${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
AND 
OTO = '是'
GROUP BY 
--A.AREA_CODE,
--A.CUS_CODE,
B.WEEK_ID
ORDER BY 
B.WEEK_ID

SELECT  
--A.AREA_CODE AS 区域,
--A.CUS_CODE AS 门店,
B.MONTH_ID AS 月序号,
SUM(SALE_QTY) AS 数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额
FROM  
DM_SALE_TMP A, DIM_DAY B 
WHERE 
1=1

${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
AND 
OTO = '是'
GROUP BY 
--A.AREA_CODE,
--A.CUS_CODE,
B.MONTH_ID
ORDER BY 
B.MONTH_ID

SELECT 
B.WEEK_ID AS 周序号,
SUM(TRAN_NUM) AS 交易笔次
FROM  DM_TRANSACTION_OTO  A,
DIM_DAY B
WHERE 
1=1

${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
B.WEEK_ID 


SELECT 
B.MONTH_ID AS 月序号,
SUM(TRAN_NUM) AS 交易笔次
FROM  DM_TRANSACTION_OTO  A,
DIM_DAY B
WHERE 
1=1

${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
AND
TO_CHAR(A.SALE_DATE,'YYYY') = SUBSTR('${YEAR}',1,4)
AND
A.SALE_DATE <= DATE'${YEAR}'
AND
A.SALE_DATE =  B.DDATE
GROUP BY 
B.MONTH_ID 

