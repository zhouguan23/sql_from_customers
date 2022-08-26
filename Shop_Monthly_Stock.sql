SELECT　DISTINCT　AREA_CODE,AREA_NAME　
FROM DIM_REGION

SELECT 
a.AREA_CODE AS 区域编码, 
b.AREA_NAME AS 区域名称,
SUM(NO_TAX_COST) AS 库存成本,
SUM(STOCK_QTY) AS 库存数量
FROM DM_FACT_STOCK_SHOP a
LEFT JOIN 
DIM_REGION b
ON 
a.AREA_CODE = b.AREA_CODE
WHERE
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND 
DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE,b.AREA_NAME 


SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
GATHER !='地采'
AND 
DDATE  = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE 


SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '过效期成本'
--AND 
--DDATE >= TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
DTP = '是'
AND 
DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT '直营' AS ATTRIBUTE  FROM DUAL
UNION
SELECT '加盟' AS ATTRIBUTE  FROM DUAL
UNION
SELECT '批发' AS ATTRIBUTE  FROM DUAL

SELECT 
AREA_CODE AS 区域编码, 
SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '近效期成本'
--AND 
--DDATE >= TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 
SUM(NO_TAX_COST) AS 库存成本,
SUM(STOCK_QTY) AS 库存数量
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-1)
AND
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本,
SUM(STOCK_QTY) AS 库存数量
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-12)
AND
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
DTP = '是'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))
--AND
--DDATE < TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
DTP = '是'
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-12)
AND
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE 

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
GATHER !='地采'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))
--AND
--DDATE < TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
GATHER !='地采'
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-12)
AND
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 
SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '过效期成本'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))
--AND
--DDATE < TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '过效期成本'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-11)
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '近效期成本'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))
--AND
--DDATE < TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT 
AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DM_FACT_STOCK_SHOP
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '近效期成本'
AND 
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-11)
AND
1=1
${if(len(type)=0,""," and ATTRIBUTE in ('"+type+"')")}
GROUP BY AREA_CODE

SELECT　DISTINCT　AREA_CODE,AREA_NAME　
FROM DIM_REGION
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
order by AREA_CODE asc

