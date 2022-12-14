
SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${Month}',1,4),'-03-01'),'YYYY-MM-DD'),-12),'YYYY')

GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END


SELECT DISTINCT SUB_CATEGORY FROM DIM_GOODS
union 
select 'NONE' from DUAL

SELECT
'1月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'2月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'3月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'4月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'5月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'6月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'7月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'8月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'9月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'10月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'11月'  AS 月份
FROM DUAL
UNION ALL
SELECT
'12月'  AS 月份
FROM DUAL

SELECT DISTINCT
CONCAT(SUBSTR(SALE_DATE,1,4),'年') AS 年份
FROM
DM_PURCHASE_GROUP_BY_AREA
ORDER bY 
CONCAT(SUBSTR(SALE_DATE,1,4),'年')


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
AND GATHER != '地采'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${Month}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY')
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE IN ('销售直营','配送批发','销售加盟')
AND 
RELATED_PARTY_TRNSACTION = '否'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
--AND GATHER = '是'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${Month}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY')
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE IN ('销售直营','配送批发','销售加盟')
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
AND GATHER != '地采'
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${Month}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY')
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT
a.区域编码,
a.区域名称,
a.销售月份,
(a.无税销售额 - b.无税销售额)/b.无税销售额 AS 同比增长率
FROM
(
SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
a.SALE_DATE AS 销售月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
and DTP = '否'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}

GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
a.SALE_DATE
) a,


(
SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
a.SALE_DATE AS 销售月份,
TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(a.SALE_DATE,'-01'),'YYYY-MM-DD'),-1),'YYYY-MM') AS 同比销售月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
and DTP = '否'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}

GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
a.SALE_DATE,
TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(a.SALE_DATE,'-01'),'YYYY-MM-DD'),-1),'YYYY-MM')
) b
WHERE 
a.区域编码 = b.区域编码
AND
a.销售月份 = b.销售月份
--GROUP BY
--a.区域编码,a.区域名称,a.销售月份

SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(a.SALE_DATE,'-01'),'YYYY-MM-DD'),-1),'YYYY-MM') AS 同比销售月份,
SUM(NO_TAX_AMOUNT) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
and DTP = '否'
AND
a.SALE_DATE = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(a.SALE_DATE,'-01'),'YYYY-MM-DD'),-1),'YYYY-MM')
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}

GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(a.SALE_DATE,'-01'),'YYYY-MM-DD'),-1),'YYYY-MM')


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
a.SALE_DATE AS 销售月份,
ROUND(SUM(NO_TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
and DTP = '否'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}

GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
a.SALE_DATE


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'

${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}

AND
SUBSTR(a.SALE_DATE,1,4) = SUBSTR('${Month}',1,4)
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END


SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE IN ('销售直营','配送批发','销售加盟')
AND 
RELATED_PARTY_TRNSACTION = '否'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
--AND GATHER = '是'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) =SUBSTR('${Month}',1,4)
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT DISTINCT AREA_CODE,AREA_NAME,UNION_AREA_NAME
FROM 
DIM_REGION
WHERE 
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
order by AREA_CODE asc

SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE = '销售直营'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
AND GATHER != '地采'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = SUBSTR('${Month}',1,4)
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT 
a.AREA_CODE AS 区域编码,
b.AREA_NAME AS 区域名称,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份,
ROUND(SUM(TAX_AMOUNT)/10000,4) AS 无税销售额
FROM DM_PURCHASE_GROUP_BY_AREA a

LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE

WHERE
ATTRIBUTE IN ('销售直营','配送批发','销售加盟')
AND
RELATED_PARTY_TRNSACTION = '否'
${if(len(DTP)=0,""," and a.DTP in ('"+DTP+"')")}
AND GATHER != '地采'
AND
1=1 
${if(len(SUB_CATEGORY)=0,""," and a.SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(a.SALE_DATE,1,4) = SUBSTR('${Month}',1,4)
and 1=1
${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

SELECT DISTINCT AREA_CODE,AREA_NAME
,
UNION_AREA_NAME 
FROM 
DIM_REGION
WHERE
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")}
order by AREA_CODE asc

SELECT DISTINCT 
AREA_CODE,AREA_NAME,UNION_AREA_NAME
FROM  
DIM_REGION

SELECT  DISTINCT  UNION_AREA_NAME 
FROM
DIM_REGION


select distinct gather from DM_PURCHASE_GROUP_BY_AREA

