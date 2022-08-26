SELECT  DISTINCT  
AREA_CODE,
AREA_NAME 
FROM 
DIM_REGION

SELECT  DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DM_DTP
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}


SELECT  DISTINCT ATTRIBUTE1 
FROM 
DM_DTP

SELECT DISTINCT
D.GOODS_CODE, 
B.GOODS_NAME,
D.GOODS_CODE||'|'||B.GOODS_NAME
FROM
DIM_GOODS B, 
DM_DTP A

LEFT JOIN 
DIM_DISABLE_CODE D
ON 
A.GOODS_CODE = D.DISABLE_CODE

WHERE 
D.GOODS_CODE= B.GOODS_CODE
AND
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}
${if(len(CUS)=0,"", "AND CUS_CODE IN ('"+CUS+"')")}
order by D.GOODS_CODE

select
case when a.商品编码 is null then b.商品编码 else a.商品编码 end as 商品编码,
case when a.客户编码 is null then b.客户编码 else a.客户编码 end as 客户编码,
case when a.客户名称 is null then b.客户名称 else a.客户名称 end as 客户名称,
case when a.商品名称 is null then b.商品名称 else a.商品名称 end as 商品名称,
case when a.厂家 is null then b.厂家 else a.厂家 end as 厂家,
case when a.SPECIFICATION is null then b.SPECIFICATION else a.SPECIFICATION end as SPECIFICATION,
case when a.区域编码 is null then b.区域编码 else a.区域编码 end as 区域编码,
case when a.区域名称 is null then b.区域名称 else a.区域名称 end as 区域名称,
a.销售数量,
a.无税销售额,
a.无税销售成本,
a.无税毛利额,
a.无税毛利率,
b.销售数量 as 后销售数量,
b.无税销售额 as 后无税销售额,
b.无税销售成本 as 后无税销售成本,
b.无税毛利额 as 后无税毛利额,
b.无税毛利率 as 后无税毛利率
from
(
SELECT  
D.GOODS_CODE AS 商品编码,
A.CUS_CODE AS 客户编码,
A.CUS_NAME AS 客户名称,
B.GOODS_NAME AS 商品名称,
B.MANUFACTURER AS 厂家,
B.SPECIFICATION,
A.AREA_CODE AS 区域编码,
C.AREA_NAME AS 区域名称,
--A.SALE_DATE AS 销售日期,
sum(SALE_QTY) as 销售数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税销售成本,
SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE 
(SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END AS 无税毛利率
FROM 
DM_DTP A 

LEFT JOIN 
DIM_DISABLE_CODE D
ON 
A.GOODS_CODE = D.DISABLE_CODE



LEFT JOIN 
DIM_GOODS B 
ON 
D.GOODS_CODE = B.GOODS_CODE

LEFT JOIN DIM_REGION C
ON 
A.AREA_CODE = C.AREA_CODE


WHERE 
1=1
${if(len(AREA)=0,""," and A.AREA_CODE IN ('"+AREA+"') ")}
${if(len(CUS)=0,""," and A.CUS_CODE IN ('"+CUS+"') ")}
${if(len(GOODS)=0,""," and D.GOODS_CODE IN ('"+GOODS+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE1 IN ('"+ATTRIBUTE+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE IN ('"+ATTRIBUTE+"') ")}
AND 
A.SALE_DATE >= DATE '${BEFORE1}'
AND
A.SALE_DATE <= DATE '${BEFORE2}'



GROUP BY
D.GOODS_CODE,
A.CUS_CODE,
A.CUS_NAME,
A.AREA_CODE, 
--A.SALE_DATE,
B.GOODS_NAME ,
B.MANUFACTURER,
B.SPECIFICATION, 
C.AREA_NAME 
ORDER BY 
A.AREA_CODE
)a 
full join 
(
SELECT  
D.GOODS_CODE AS 商品编码,
A.CUS_CODE AS 客户编码,
A.CUS_NAME AS 客户名称,
B.GOODS_NAME AS 商品名称,
B.MANUFACTURER AS 厂家,
B.SPECIFICATION,
A.AREA_CODE AS 区域编码,
C.AREA_NAME AS 区域名称,
--A.SALE_DATE AS 销售日期,
sum(SALE_QTY) as 销售数量,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税销售成本,
SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE 
(SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END AS 无税毛利率
FROM 
DM_DTP A 

LEFT JOIN 
DIM_DISABLE_CODE D
ON 
A.GOODS_CODE = D.DISABLE_CODE



LEFT JOIN 
DIM_GOODS B 
ON 
D.GOODS_CODE = B.GOODS_CODE

LEFT JOIN DIM_REGION C
ON 
A.AREA_CODE = C.AREA_CODE


WHERE 
1=1
${if(len(AREA)=0,""," and A.AREA_CODE IN ('"+AREA+"') ")}
${if(len(CUS)=0,""," and A.CUS_CODE IN ('"+CUS+"') ")}
${if(len(GOODS)=0,""," and D.GOODS_CODE IN ('"+GOODS+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE1 IN ('"+ATTRIBUTE+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE IN ('"+ATTRIBUTE+"') ")}
AND 
A.SALE_DATE >= DATE '${AFTER1}'
AND
A.SALE_DATE <= DATE '${AFTER2}'



GROUP BY
D.GOODS_CODE,
A.CUS_CODE,
A.CUS_NAME,
A.AREA_CODE, 
--A.SALE_DATE,
B.GOODS_NAME ,
B.MANUFACTURER,
B.SPECIFICATION, 
C.AREA_NAME 
ORDER BY 
A.AREA_CODE
)b on a.商品编码=b.商品编码 and a.客户编码=b.客户编码 and a.厂家=b.厂家 and a.SPECIFICATION=b.SPECIFICATION and a.区域编码=b.区域编码
order by 区域编码,客户编码,商品编码


SELECT  
D.GOODS_CODE AS 商品编码,
A.CUS_CODE AS 客户编码,
A.CUS_NAME AS 客户名称,
B.GOODS_NAME AS 商品名称,
B.MANUFACTURER AS 厂家,
B.SPECIFICATION,
A.AREA_CODE AS 区域编码,
C.AREA_NAME AS 区域名称,
--A.SALE_DATE AS 销售日期,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税销售成本,
SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE 
(SUM(NO_TAX_AMOUNT)- SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END AS 无税毛利率
FROM 
DM_DTP A 

LEFT JOIN 
DIM_DISABLE_CODE D
ON 
A.GOODS_CODE = D.DISABLE_CODE



LEFT JOIN 
DIM_GOODS B 
ON 
D.GOODS_CODE = B.GOODS_CODE

LEFT JOIN DIM_REGION C
ON 
A.AREA_CODE = C.AREA_CODE


WHERE 
1=1
${if(len(AREA)=0,""," and A.AREA_CODE IN ('"+AREA+"') ")}
${if(len(CUS)=0,""," and A.CUS_CODE IN ('"+CUS+"') ")}
${if(len(GOODS)=0,""," and D.GOODS_CODE IN ('"+GOODS+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE1 IN ('"+ATTRIBUTE+"') ")}
${if(len(ATTRIBUTE)=0,""," and A.ATTRIBUTE IN ('"+ATTRIBUTE+"') ")}
AND 
A.SALE_DATE >= DATE '${AFTER1}'
AND
A.SALE_DATE <= DATE '${AFTER2}'



GROUP BY
D.GOODS_CODE,
A.CUS_CODE,
A.CUS_NAME,
A.AREA_CODE, 
--A.SALE_DATE,
B.GOODS_NAME ,
B.MANUFACTURER,
B.SPECIFICATION, 
C.AREA_NAME 
ORDER BY 
A.AREA_CODE




SELECT  
A.AREA_CODE ,
A.AREA_NAME
FROM
DIM_REGION A,
(
SELECT A.AREA_CODE,A.AREA_NAME,B.area_code as area_dict 
from  DIM_REGION A join gygd_logdb.fr_t_user B on A.area_code=B.area_code
WHERE
B."username" = '${fr_username}'
) B 


SELECT  DISTINCT  
AREA_CODE,
AREA_NAME 
FROM 
DIM_REGION
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}

SELECT  DISTINCT  
CUS_CODE,
CUS_NAME 
FROM 
DM_DTP
WHERE  
1=1
${if(len(AREA)=0,"", "AND AREA_CODE IN ('"+AREA+"')")}

${if(len(CUS)=0,"", "AND CUS_CODE IN ('"+CUS+"')")}

