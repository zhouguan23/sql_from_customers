SELECT　DISTINCT　AREA_CODE,AREA_NAME　
FROM DIM_REGION

SELECT 
a.AREA_CODE AS 区域编码, 
b.AREA_NAME AS 区域名称,
SUM(NO_TAX_COST) AS 库存成本,
SUM(STOCK_QTY) AS 库存数量
FROM DAY_DM_STOCK_SHOP_DETAIL a
LEFT JOIN 
DIM_REGION b
ON 
a.AREA_CODE = b.AREA_CODE
left join dim_cus dc
on a.AREA_CODE = dc.AREA_CODE and a.cus_code=dc.cus_code
WHERE
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
--AND DDATE = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and dc.ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE,b.AREA_NAME 


SELECT 
a.AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DAY_DM_STOCK_SHOP_DETAIL a,dim_cus dc
WHERE a.area_code=dc.area_code and a.cus_code=dc.cus_code and 
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND
GATHER !='地采'
--AND DDATE  = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and dc.ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE 

SELECT 
a.AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DAY_DM_STOCK_SHOP_DETAIL a,dim_cus dc
WHERE a.area_code=dc.area_code and a.cus_code=dc.cus_code and 
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '过效期成本'
--AND DDATE  = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and dc.ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE 

SELECT 
a.AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DAY_DM_STOCK_SHOP_DETAIL a,dim_cus dc
WHERE a.area_code=dc.area_code and a.cus_code=dc.cus_code and 
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND
DTP = '是'
--AND DDATE  = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and dc.ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE 

SELECT '直营' AS ATTRIBUTE  FROM DUAL
UNION
SELECT '加盟' AS ATTRIBUTE  FROM DUAL
UNION
SELECT '批发' AS ATTRIBUTE  FROM DUAL

SELECT 
a.AREA_CODE AS 区域编码, 

SUM(NO_TAX_COST) AS 库存成本
FROM DAY_DM_STOCK_SHOP_DETAIL a,dim_cus dc
WHERE a.area_code=dc.area_code and a.cus_code=dc.cus_code and 
1=1 
${if(len(area)=0,""," and a.AREA_CODE in ('"+area+"')")}
AND
EFFECTIVE = '近效期成本'
--AND DDATE  = last_day(to_date('${date}'||'-01','yyyy-mm-dd'))
--AND
--DDATE < ADD_MONTHS(TO_DATE(CONCAT('${date}',-01),'YYYY-MM-DD'),+1)
AND
1=1
${if(len(type)=0,""," and dc.ATTRIBUTE in ('"+type+"')")}
GROUP BY a.AREA_CODE 

SELECT　DISTINCT　dr.AREA_CODE,dr.AREA_NAME　
FROM DIM_REGION dr,USER_AUTHORITY  ua
WHERE
1=1 
${if(len(area)=0,""," and AREA_CODE in ('"+area+"')")}
and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
order by dr.AREA_CODE asc

 select add_months(to_date('${Date}', 'YYYY-MM'),1) -to_date('${Date}', 'YYYY-MM') now_day,
        add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-12) -add_months(to_date('${Date}', 'YYYY-MM'),-12) last_year_day, 
        add_months(add_months(to_date('${Date}', 'YYYY-MM'),1),-1) -add_months(to_date('${Date}', 'YYYY-MM'),-1) last_day from dual

select aa.area_code,aa.no_tax_cost from 
 
(select a.area_code,sum(a.no_tax_cost) no_tax_cost from 
dm_sale_tmp a,dim_cus b

where a.area_code=b.area_code
and  a.cus_code=b.cus_code
and to_char(sale_date,'yyyy-mm') = '${Date}'
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(type)=0,""," and b.attribute in ('"+type+"')")}
--AND 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by a.area_code) aa

