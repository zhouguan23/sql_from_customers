SELECT 
A.AREA_CODE AS 区域编码,
A.CUS_CODE AS 客户编码,
SUM(A.SALE_AMOUNT) AS 销售金额
--A.MARKETING_CODE AS 交易方式,
FROM
FACT_SALE_PAY_TYPE A
LEFT JOIN 
DIM_MARKETING B 
ON 
A.MARKETING_CODE = B.MARKETING_CODE
LEFT JOIN 
DIM_CUS C 
ON 
A.AREA_CODE = C.AREA_CODE 
AND 
A.CUS_CODE = C.CUS_CODE 
WHERE
TO_CHAR(A.SALE_DATE,'YYYY-MM') = '${MONTH}'
/*
A.SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD')
AND
A.SALE_DATE  <= TO_DATE('${date2}','YYYY-MM-DD') 
*/
AND
1=1 
${if(len(attribute)=0,"", "and C.ATTRIBUTE in ('"+attribute+"')")}
AND 
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
AND 
1=1
${if(len(CLOSE)=0,"", "and decode(C.CLOSE_DATE,NULL,'否','是') in ('"+CLOSE+"')")}
AND 
1=1
${if(len(CUS)=0,"", "and A.cus_code in ('"+CUS+"')")} 
GROUP BY
A.AREA_CODE,
A.CUS_CODE 

SELECT 
AREA_CODE AS 区域编码,
CUS_CODE AS 客户编码,
COUNT(DISTINCT GOODS_CODE) AS SKU
FROM 
FACT_SALE
WHERE
SALE_DATE >= TO_DATE('${MONTH}'||'-01','YYYY-MM-DD')
AND
SALE_DATE <= LAST_DAY(TO_DATE('${MONTH}'||'-01','YYYY-MM-DD')) 
--SALE_DATE >= DATE'${DATE1}' AND SALE_DATE <= DATE'${DATE2}'
GROUP BY 
AREA_CODE,
CUS_CODE


SELECT 
A.CUS_CODE,
A.CUS_NAME,
A.AREA_CODE,
B.AREA_NAME,
A.ATTRIBUTE,
EMPLOYEE_NUMBER,
SHOP_AREA,
DECODE(A.CLOSE_DATE,NULL,ROUND((TRUNC(SYSDATE)-A.OPEN_DATE)/365,0),ROUND((A.CLOSE_DATE-A.OPEN_DATE)/365,0)) AS 店龄,
decode(A.CLOSE_DATE,NULL,'否','是') AS 是否关店,
SUM(A.STOCK_QTY) AS 库存数量,
SUM(A.DELIVERY_AMOUNT) AS 门店购进金额,
SUM(A.SALE_AMOUNT) AS 门店销售金额,
SUM(A.SALE_COST) AS 门店销售成本,
DECODE(SUM(A.SALE_AMOUNT),0,0,(SUM(A.SALE_AMOUNT) - SUM(A.SALE_COST))/ SUM(A.SALE_AMOUNT)) AS 门店毛利率,
SUM(A.STOCK_COST) AS 门店库存金额,
SUM(A.DTP_DELIVERY_AMOUNT) AS DTP购进金额,
SUM(A.DTP_SALE_AMOUNT) AS DTP销售金额,
SUM(A.DTP_SALE_COST) AS DTP成本,
DECODE(SUM(A.DTP_SALE_AMOUNT),0,0,(SUM(A.DTP_SALE_AMOUNT)-SUM(A.DTP_SALE_COST))/SUM(A.DTP_SALE_AMOUNT)) AS DTP毛利率,
SUM(A.DTP_STOCK_COST) AS DTP库存金额,
SUM(A.VIP_SALE_AMOUNT) AS 会员销售金额,
SUM(A.VIP_SALE_COST) AS 会员销售成本,
DECODE(SUM(A.VIP_SALE_AMOUNT),0,0,(SUM(A.VIP_SALE_AMOUNT) - SUM(A.VIP_SALE_COST))/SUM(A.VIP_SALE_AMOUNT)) AS 会员销售毛利率,
SUM(A.GATHER_STOCK_QTY) AS 高毛商品库存数量,
SUM(A.GATHER_SALE_AMOUNT) AS 高毛商品销售额,
SUM(A.GATHER_SALE_COST) AS 高毛商品销售成本,
DECODE(SUM(A.GATHER_SALE_AMOUNT),0,0,(SUM(A.GATHER_SALE_AMOUNT)- SUM(A.GATHER_SALE_COST))/SUM(A.GATHER_SALE_AMOUNT)) AS 高毛商品毛利率,
DECODE(SUM(A.SALE_AMOUNT),0,0,SUM(A.GATHER_SALE_AMOUNT)/SUM(A.SALE_AMOUNt)) AS 高毛商品销售占比

FROM 
DM_DELIVERY_SALE_STOCK A
LEFT JOIN 
DIM_REGION B
ON A.AREA_CODE = B.AREA_CODE
WHERE
TO_CHAR(DATE1,'YYYY-MM') = '${MONTH}'
/*
DATE1 >= TO_DATE('${date1}','YYYY-MM-DD')
AND
DATE1  <= TO_DATE('${date2}','YYYY-MM-DD') 
*/
AND
1=1 ${if(len(attribute)=0,"", "and A.ATTRIBUTE in ('"+attribute+"')")}
AND 
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
AND 
1=1
${if(len(CLOSE)=0,"", "and decode(A.CLOSE_DATE,NULL,'否','是') in ('"+CLOSE+"')")} 
AND 
1=1
${if(len(CUS)=0,"", "and A.cus_code in ('"+CUS+"')")} 
GROUP BY 
A.CUS_CODE,
A.CUS_NAME,
A.AREA_CODE,
B.AREA_NAME,
A.ATTRIBUTE,
EMPLOYEE_NUMBER,
SHOP_AREA,
DECODE(A.CLOSE_DATE,NULL,ROUND((TRUNC(SYSDATE)-A.OPEN_DATE)/365,0),ROUND((A.CLOSE_DATE-A.OPEN_DATE)/365,0)) ,
decode(A.CLOSE_DATE,NULL,'否','是') 
ORDER BY AREA_CODE,CUS_CODE

SELECT DISTINCT 
AREA_CODE,
AREA_NAME
FROM 
DIM_REGION

SELECT '直营' AS a FROM DUAL
UNION
SELECT '加盟' AS a FROM DUAL


SELECT '是' AS a
FROM DUAL

UNION

SELECT '否' As  a
FROM DUAL

SELECT 
A.AREA_CODE,
A.CUS_CODE,
SUM(A.TRAN_NUM) AS 交易笔次
FROM 
DM_TRANSACTION A
LEFT JOIN 
DIM_CUS B
ON 
A.AREA_CODE = B.AREA_CODE 
AND 
TO_CHAR(A.CUS_CODE) = b.CUS_CODE
WHERE
TO_CHAR(A.SALE_DATE,'YYYY-MM') = '${MONTH}'
/*
A.SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD')
AND
A.SALE_DATE  <= TO_DATE('${date2}','YYYY-MM-DD') 
*/
AND
1=1 ${if(len(attribute)=0,"", "and B.ATTRIBUTE in ('"+attribute+"')")}
AND 
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
AND 
1=1
${if(len(CLOSE)=0,"", "and decode(B.CLOSE_DATE,NULL,'否','是') in ('"+CLOSE+"')")}
AND 
1=1
${if(len(CUS)=0,"", "and A.cus_code in ('"+CUS+"')")} 
GROUP BY
A.AREA_CODE,
A.CUS_CODE 

SELECT 
A.AREA_CODE,
A.CUS_CODE,
SUM(A.TRAN_NUM) AS 交易笔次
FROM 
DM_TRANSACTION A
LEFT JOIN 
DIM_CUS B
ON 
A.AREA_CODE = B.AREA_CODE 
AND 
TO_CHAR(A.CUS_CODE) = b.CUS_CODE
WHERE
A.IS_VIP = 'Y'
AND
TO_CHAR(A.SALE_DATE,'YYYY-MM') = '${MONTH}'
/*
A.SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD')
AND
A.SALE_DATE  <= TO_DATE('${date2}','YYYY-MM-DD') 
*/
AND
1=1 ${if(len(attribute)=0,"", "and B.ATTRIBUTE in ('"+attribute+"')")}
AND 
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
AND 
1=1
${if(len(CLOSE)=0,"", "and decode(B.CLOSE_DATE,NULL,'否','是') in ('"+CLOSE+"')")}
AND 
1=1
${if(len(CUS)=0,"", "and A.cus_code in ('"+CUS+"')")} 
GROUP BY
A.AREA_CODE,
A.CUS_CODE 

