SELECT
t.area_code 区域编码,
SUM(t.dc_qty) AS 库存数量,
SUM(t.dc_cost) AS 库存成本,
SUM(t.zy_qty) AS 门店库存数量,
SUM(t.zy_cost) AS 门店库存成本
FROM

DAY_DM_STOCK_PERIOD_ALL t,
DIM_DISABLE_CODE d

WHERE t.GOODS_CODE = d.DISABLE_CODE(+) 
and 
1=1 
${if(len(area)=0,""," and t.area_code in ('"+area+"')")}
and
1=1 
${if(len(code)=0,""," and d.goods_code in ('"+code+"')")}
AND
1=1 
${if(len(dtp)=0,""," and t.dTP = '"+dtp+"' ")}
AND
1=1 
${if(len(GATHER)=0,""," and t.gather  in ('"+GATHER+"')")}

GROUP BY
t.area_code
order by t.area_code

SELECT '是' AS aa FROM DUAL
UNION ALL
SELECT '否' AS aa FROM DUAL


SELECT DISTINCT dr.UNION_AREA_NAME,dr.AREA_CODE, dr.AREA_NAME 
FROM DIM_REGION dr,USER_AUTHORITY  ua

WHERE 
1=1 
${if(len(AREA)=0,""," and dr.AREA_CODE in ('"+AREA+"')")}
and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
order by dr.AREA_CODE asc

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

SELECT DISTINCT dr.AREA_CODE, dr.AREA_NAME 
FROM DIM_REGION dr,USER_AUTHORITY  ua
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and dr.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}





select   GOODS_CODE,GOODS_NAME from DIM_GOODS where rownum<50000

select distinct NEW_ATTRIBUTE from DIM_NET_CATALOGUE_GENERAL_ALL where CREATE_MONTH='${Date}' 
union select '地采' from  dual

SELECT  DISTINCT  
UNION_AREA_NAME
FROM 
DIM_REGION

