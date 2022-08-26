select 
case when a.门店编码 is null then b.门店编码 else a.门店编码 end as 门店编码,
case when a.门店名称 is null then b.门店名称 else a.门店名称 end as 门店名称,
case when a.区域编码 is null then b.区域编码 else a.区域编码 end as 区域编码,
case when a.区域名称 is null then b.区域名称 else a.区域名称 end as 区域名称,
case when a.合并区域名称 is null then b.合并区域名称 else a.合并区域名称 end as 合并区域名称,
a.无税金额,
a.无税成本,
b.无税金额 as 后无税金额,
b.无税成本 as 后无税成本
from
(
SELECT 
--GOODS_CODE AS 商品编码,

CUS_CODE AS 门店编码,
CUS_NAME as 门店名称,
A.AREA_CODE AS 区域编码,
B.AREA_NAME AS 区域名称,
B.UNION_AREA_NAME AS 合并区域名称,
--SALE_DATE AS 销售日期,
SUM(NO_TAX_AMOUNT) AS 无税金额,
SUM(NO_TAX_COST) AS 无税成本
--ATTRIBUTE1 AS  门店类型

FROM 
DM_DTP A 
LEFT JOIN 
DIM_REGION B 
ON 
A.AREA_CODE = B.AREA_CODE 
WHERE
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,"", "and B.UNION_AREA_NAME in ('"+UNION_AREA+"')")} 
${if(len(CUS)=0,"", "and CUS_CODE in ('"+CUS+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE1 in ('"+ATTRIBUTE+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE in ('"+ATTRIBUTE+"')")}
AND 
SALE_DATE >= DATE'${BEFORE1}'
AND
SALE_DATE <= DATE'${BEFORE2}'
GROUP BY 
A.AREA_CODE,
B.AREA_NAME,
B.UNION_AREA_NAME,
CUS_CODE,
CUS_NAME
)a
full join 
(
SELECT 
--GOODS_CODE AS 商品编码,

CUS_CODE AS 门店编码,
CUS_NAME as 门店名称,
A.AREA_CODE AS 区域编码,
B.AREA_NAME AS 区域名称,
B.UNION_AREA_NAME AS 合并区域名称,
--SALE_DATE AS 销售日期,
SUM(NO_TAX_AMOUNT) AS 无税金额,
SUM(NO_TAX_COST) AS 无税成本
--ATTRIBUTE1 AS  门店类型

FROM 
DM_DTP A 
LEFT JOIN 
DIM_REGION B 
ON 
A.AREA_CODE = B.AREA_CODE 
WHERE
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
${if(len(UNION_AREA)=0,"", "and B.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
${if(len(CUS)=0,"", "and CUS_CODE in ('"+CUS+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE1 in ('"+ATTRIBUTE+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE in ('"+ATTRIBUTE+"')")}
AND 
SALE_DATE >= DATE'${AFTER1}'
AND
SALE_DATE <= DATE'${AFTER2}'
GROUP BY 
A.AREA_CODE,
B.AREA_NAME,
B.UNION_AREA_NAME,
CUS_CODE,
CUS_NAME
)b on a.区域编码=b.区域编码 and a.门店编码=b.门店编码
order by 区域编码,门店编码

SELECT 
--GOODS_CODE AS 商品编码,

CUS_CODE AS 门店编码,
CUS_NAME as 门店名称,
A.AREA_CODE AS 区域编码,
B.AREA_NAME AS 区域名称,
--SALE_DATE AS 销售日期,
SUM(NO_TAX_AMOUNT) AS 无税金额,
SUM(NO_TAX_COST) AS 无税成本
--ATTRIBUTE1 AS  门店类型

FROM 
DM_DTP A 
LEFT JOIN 
DIM_REGION B 
ON 
A.AREA_CODE = B.AREA_CODE 
WHERE 
1=1
${if(len(AREA)=0,"", "and A.AREA_CODE in ('"+AREA+"')")} 
${if(len(CUS)=0,"", "and CUS_CODE in ('"+CUS+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE1 in ('"+ATTRIBUTE+"')")} 
${if(len(ATTRIBUTE)=0,"", "and ATTRIBUTE in ('"+ATTRIBUTE+"')")} 
AND 
SALE_DATE >= DATE'${AFTER1}'
AND
SALE_DATE <= DATE'${AFTER2}'
GROUP BY 
A.AREA_CODE,
B.AREA_NAME,
CUS_CODE,
CUS_NAME
ORDER bY 
A.AREA_CODE

SELECT 
DISTINCT 
AREA_CODE,
AREA_NAME
FROm 
DIM_REGION

select distinct
a.area_code,
cus_code,
cus_name,
cus_code||'|'||cus_name
from dim_cus a,dim_region b,(select * from USER_AUTHORITY) c
where 1=1 and a.area_code=b.area_code
and (b.UNION_AREA_NAME=c.UNION_AREA_NAME or c.UNION_AREA_NAME='ALL')
and ${"c.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and b.UNION_AREA_NAME in ('"+UNION_AREA+"')")}
order by area_code,cus_code

SELECT DISTINCT ATTRIBUTE1
FROM 
DM_DTP

SELECT DISTINCT AREA_NAME
FROM  
DIM_REGION 
WHERE  
AREA_CODE IN ('${AREA}')

