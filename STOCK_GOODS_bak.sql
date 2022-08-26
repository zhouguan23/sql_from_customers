
SELECT
t. 区域编码,
--t.日期,
SUM(t.库存数量) AS 库存数量,
SUM(t.库存成本) AS 库存成本
FROM(

SELECT 
d.GOODS_CODE AS 商品编码,
a.AREA_CODE AS 区域编码,
a.DDATE AS 日期,
SUM(STOCK_QTY) AS 库存数量,
SUM(NO_TAX_COST) AS 库存成本,
DECODE(b.GOODS_CODE,null,'否','是') AS DTP,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采') AS GATHER
FROM 
FACT_STOCK_GENERAL a
LEFT JOIN
DIM_NET_CATALOGUE_GENERAL_ALL c
ON
(
a.GOODS_CODE = c.GOODS_CODE
AND
a.AREA_CODE = c.AREA_CODE
AND
TO_CHAR(a.DDATE,'YYYY-MM') = c.CREATE_MONTH
--AND 
--C.new_ATTRIBUTE NOT IN ('集采DTP','集采品牌')
)
LEFT JOIN 
DIM_DTP b
ON
(
to_char(ADD_MONTHS(a.DDATE,-1),'YYYY-MM')=b.CREATE_MONTH
AND
a.GOODS_CODE = b.GOODS_CODE
AND
a.AREA_CODE = b.AREA_CODE
)
JOIN
DIM_DISABLE_CODE d
ON
a.GOODS_CODE = d.DISABLE_CODE 
WHERE

--C.new_ATTRIBUTE NOT IN ('集采DTP','集采品牌')
--AND
1=1 
${if(len(code)=0,""," and d.goods_code in ('"+code+"')")}
AND
a.DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--a.DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)




GROUP BY 
d.GOODS_CODE,
a.AREA_CODE,a.DDATE,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采')
,DECODE(b.GOODS_CODE,null,'否','是')
)t
WHERE

1=1 
${if(len(area)=0,""," and t.区域编码 in ('"+area+"')")}
AND
1=1 
${if(len(dtp)=0,""," and t.dTP = '"+dtp+"' ")}
AND
1=1 
${if(len(GATHER)=0,""," and t.gather  in ('"+GATHER+"')")}

GROUP BY
t. 区域编码
--,t.日期

SELECT '是' AS aa FROM DUAL
UNION ALL
SELECT '否' AS aa FROM DUAL


SELECT DISTINCT UNION_AREA_NAME,AREA_CODE, AREA_NAME 
FROM DIM_REGION

WHERE 
1=1 
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
order by AREA_CODE asc

SELECT DISTINCT b.GOODS_CODE,b.goods_code||'|'||C.goods_name goods_name

FROM DM_FACT_STOCK_SHOP a
LEFT JOIN 
DIM_DISABLE_CODE b
ON 
a.GOODS_CODE = b.DISABLE_CODE 
JOIN 
DIM_GOODS c
ON
a.GOODS_CODE = c.GOODS_CODE 
WHERE 
a.DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
and rownum<5000

UNION

SELECT DISTINCT b.GOODS_CODE, b.goods_code||'|'||C.goods_name goods_name

FROM FACT_STOCK_GENERAL a
LEFT JOIN 
DIM_DISABLE_CODE b
ON 
a.GOODS_CODE = b.DISABLE_CODE 
JOIN 
DIM_GOODS c
ON
a.GOODS_CODE = c.GOODS_CODE 
WHERE
a.DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
and rownum<5000

SELECT 
a.AREA_CODE,
c.AREA_NAME,
SUM(NO_TAX_COST) AS 无税成本,
SUM(STOCK_QTY) AS 库存数量
FROM
DM_FACT_STOCK_SHOP a
LEFT JOIN
DIM_REGION c
ON
a.AREA_CODE = c.AREA_CODE
LEFT JOIN
DIM_DISABLE_CODE b
ON
a.GOODS_CODE = b.DISABLE_CODE 
WHERE
ATTRIBUTE = '直营'
AND
1=1
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
1=1 
${if(len(dtp)=0,""," and DTP in ('"+dtp+"')")}
AND
1=1 
${if(len(code)=0,""," and b.goods_code in ('"+code+"')")}
AND
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND 
DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
GROUP BY a.AREA_CODE,c.AREA_NAME 

SELECT 
a.AREA_CODE,

SUM(NO_TAX_COST) AS 无税成本,
SUM(STOCK_QTY) AS 库存数量
FROM DM_FACT_STOCK_SHOP a
LEFT JOIN
DIM_DISABLE_CODE b
ON
a.GOODS_CODE = b.DISABLE_CODE 
WHERE
ATTRIBUTE = '直营'
AND
1=1
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
1=1 
${if(len(dtp)=0,""," and DTP in ('"+dtp+"')")}
AND
1=1 
${if(len(code)=0,""," and b.goods_code in ('"+code+"')")}
AND
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-12)
AND
a.DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))
GROUP BY a.AREA_CODE 

SELECT
t. 区域编码,
--t.日期,
SUM(t.库存数量) AS 库存数量,
SUM(t.库存成本) AS 库存成本
--,t.DTP,
--t.gather
FROM(

SELECT 
d.GOODS_CODE AS 商品编码,
a.AREA_CODE AS 区域编码,
a.DDATE AS 日期,
SUM(STOCK_QTY) AS 库存数量,
SUM(NO_TAX_COST) AS 库存成本,
DECODE(b.GOODS_CODE,null,'否','是') AS DTP,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采') AS GATHER
FROM 
--DIM_NET_CATALOGUE_GENERAL_ALL c,
FACT_STOCK_GENERAL a
LEFT JOIN
DIM_NET_CATALOGUE_GENERAL_ALL c
ON
(
a.GOODS_CODE = c.GOODS_CODE
AND
a.AREA_CODE = c.AREA_CODE
AND
TO_CHAR(a.DDATE,'YYYY-MM') = c.CREATE_MONTH
--AND
--C.new_ATTRIBUTE NOT IN ('集采DTP','集采品牌')
)
LEFT JOIN 
DIM_DTP b
ON
(
to_char(ADD_MONTHS(a.DDATE,-1),'YYYY-MM')=b.CREATE_MONTH
AND
a.GOODS_CODE = b.GOODS_CODE
AND
a.AREA_CODE = b.AREA_CODE
)
JOIN
DIM_DISABLE_CODE d
ON
a.GOODS_CODE = d.DISABLE_CODE 
WHERE
--a.GOODS_CODE = c.GOODS_CODE
--AND
--a.AREA_CODE = c.AREA_CODE

--AND
1=1 
${if(len(code)=0,""," and d.goods_code in ('"+code+"')")}
--AND 
--a.DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-12)
AND
a.DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-12))

--AND
--1=1 
--${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
--AND 
--a.DDATE >= TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD')
--AND
--a.DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
GROUP BY 
d.GOODS_CODE,
a.AREA_CODE,a.DDATE,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采')
,DECODE(b.GOODS_CODE,null,'否','是')
)t
WHERE
1=1 
${if(len(dtp)=0,""," and t.DTP = '"+dtp+"' ")}
AND
1=1 
${if(len(area)=0,""," and t.区域编码 in ('"+area+"')")}

AND
1=1 
${if(len(GATHER)=0,""," and t.gather in ('"+GATHER+"')")}

GROUP BY
t. 区域编码
--,t.日期
--,t.DTP,
--t.gather

SELECT
t. 区域编码,
--t.日期,
SUM(t.库存数量) AS 库存数量,
SUM(t.库存成本) AS 库存成本
FROM(

SELECT 
d.GOODS_CODE AS 商品编码,
a.AREA_CODE AS 区域编码,
a.DDATE AS 日期,
SUM(STOCK_QTY) AS 库存数量,
SUM(NO_TAX_COST) AS 库存成本,
DECODE(b.GOODS_CODE,null,'否','是') AS DTP,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采') AS GATHER
FROM 
--DIM_NET_CATALOGUE_GENERAL_ALL c,
FACT_STOCK_GENERAL a
LEFT JOIN
DIM_NET_CATALOGUE_GENERAL_ALL c
ON
(
a.GOODS_CODE = c.GOODS_CODE
AND
a.AREA_CODE = c.AREA_CODE
AND 
TO_CHAR(a.DDATE,'YYYY-MM') = c.CREATE_MONTH
--AND 
--C.new_ATTRIBUTE NOT IN ('集采DTP','集采品牌')
)
LEFT JOIN 
DIM_DTP b
ON
(
to_char(ADD_MONTHS(a.DDATE,-1),'YYYY-MM')=b.CREATE_MONTH
AND
a.GOODS_CODE = b.GOODS_CODE
AND
a.AREA_CODE = b.AREA_CODE
)
JOIN
DIM_DISABLE_CODE d
ON
a.GOODS_CODE = d.DISABLE_CODE 
WHERE
1=1 
${if(len(code)=0,""," and d.goods_code in ('"+code+"')")}
--AND 
--a.DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-1)
AND
a.DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))


GROUP BY 
d.GOODS_CODE,
a.AREA_CODE,a.DDATE,
DECODE(SUBSTR(c.NEW_ATTRIBUTE,0,2),'集采',c.NEW_ATTRIBUTE,'地采')
,DECODE(b.GOODS_CODE,null,'否','是')
)t
WHERE
1=1 
${if(len(dtp)=0,""," and t.DTP = '"+dtp+"' ")}
AND
1=1 
${if(len(area)=0,""," and t.区域编码 in ('"+area+"')")}

AND
1=1 
${if(len(GATHER)=0,""," and t.gather in ('"+GATHER+"')")}

GROUP BY
t. 区域编码
--,t.日期

SELECT 
a.AREA_CODE,

SUM(NO_TAX_COST) AS 无税成本,
SUM(STOCK_QTY) AS 库存数量
FROM DM_FACT_STOCK_SHOP a
LEFT JOIN
DIM_DISABLE_CODE b
ON
a.GOODS_CODE = b.DISABLE_CODE 

WHERE
ATTRIBUTE = '直营'
AND
1=1 
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
1=1 
${if(len(dtp)=0,""," and DTP in ('"+dtp+"')")}
AND
1=1 
${if(len(code)=0,""," and b.goods_code in ('"+code+"')")}
AND
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
--AND 
--DDATE >= ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),-1)
AND
DDATE = last_day(add_months(to_date('${date}'||'-01','yyyy-mm-dd'),-1))

GROUP BY a.AREA_CODE

SELECT DISTINCT AREA_CODE, AREA_NAME 
FROM DIM_REGION
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}





select   GOODS_CODE,GOODS_NAME from DIM_GOODS where rownum<50000

select distinct NEW_ATTRIBUTE from DIM_NET_CATALOGUE_GENERAL_ALL where CREATE_MONTH='${Date}' 
union select '地采' from  dual

SELECT  DISTINCT  
UNION_AREA_NAME
FROM 
DIM_REGION

