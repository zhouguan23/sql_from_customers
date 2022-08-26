SELECT '1月' AS month FROM DUAL 
UNION ALL
SELECT '2月' AS month FROM DUAL
UNION ALL
SELECT '3月' AS month FROM DUAL
UNION ALL
SELECT '4月' AS month FROM DUAL
UNION ALL
SELECT '5月' AS month FROM DUAL
UNION ALL
SELECT '6月' AS month FROM DUAL
UNION ALL
SELECT '6月' AS month FROM DUAL
UNION ALL
SELECT '7月' AS month FROM DUAL
UNION ALL
SELECT '8月' AS month FROM DUAL
UNION ALL
SELECT '9月' AS month FROM DUAL
UNION ALL
SELECT '10月' AS month FROM DUAL
UNION ALL
SELECT '11月' AS month FROM DUAL
UNION ALL
SELECT '12月' AS month FROM DUAL

SELECT  
AREA_CODE,AREA_NAME, 
UNION_AREA_NAME
FROM DIM_REGION
WHERE 
1=1 
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 

ORDER BY sorted

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND

SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND

SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0  as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1  as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END )
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
 AND ATTRIBUTE='销售直营'
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
 AND ATTRIBUTE='销售直营'
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END   
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END   

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND ATTRIBUTE='销售直营'
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END   
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份
,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份

FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE
,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END


union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份
,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份

FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE
,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
AND
RELATED_PARTY_TRNSACTION = '否'
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
${if(len(SUB_CATEGORY)=0,""," and SUB_CATEGORY in ('"+SUB_CATEGORY+"')")}
${if(len(GATHER)=0,""," and GATHER in ('"+GATHER+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

SELECT DISTINCT SUB_CATEGORY 
FROM  DM_PURCHASE_RATE

SELECT  DISTINCT GATHER 
FROM  
DM_PURCHASE_RATE

SELECT DISTINCT 
AREA_CODE,AREA_NAME,
UNION_AREA_NAME
FROM DIM_REGION
WHERE 
1=1 
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME in ('"+UNION_AREA+"')")} 

ORDER BY AREA_CODE


select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
SALE_DATE AS 销售月份,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
--GATHER = '集采高毛'
--AND
ATTRIBUTE = '销售直营' 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")}
AND
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
GROUP BY
AREA_CODE,
SALE_DATE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

SELECT DISTINCT 
SUBSTR(SALE_DATE,1,4) as 实际值,
SUBSTR(SALE_DATE,1,4)||'年' AS 年份
FROM DM_PURCHASE_RATE
ORDER BY SUBSTR(SALE_DATE,1,4)

SELECT DISTINCT 
UNION_AREA_NAME
FROM DIM_REGION


select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),0),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END   
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END  
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND

SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END  

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 
AND

SUBSTR(SALE_DATE,1,4) = SUBSTR('${MONTH}',1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

select * from(
SELECT 
0 as flag,
AREA_CODE AS 区域编号,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 

union all

SELECT 
1 as flag,
AREA_CODE AS 区域编号,
SUM(TAX_AMOUNT) AS 无税销售额,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END AS 月份
FROM
DM_PURCHASE_RATE 
WHERE
1=1
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")} 
${if(len(DTP)=0,""," and DTP in ('"+DTP+"')")} 

AND
SUBSTR(SALE_DATE,1,4) = SUBSTR(TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${MONTH}',1,4),'-01-01'),'YYYY-MM-DD'),-12),'YYYY-MM-DD'),1,4)
AND
RELATED_PARTY_TRNSACTION = '否'
and ATTRIBUTE IN ('销售直营','销售加盟','配送批发')
GROUP BY
AREA_CODE,
CASE WHEN
SUBSTr(SALE_DATE,6,7) < '10'
AND  
SUBSTr(SALE_DATE,6,7)  >= '01'
THEN
CONCAT(SUBSTr(SALE_DATE,7,7),'月') 
ELSE
CONCAT(SUBSTr(SALE_DATE,6,7),'月')
END 
)
where 1=1
${if(len(flag)=0,"","and flag IN ('"+flag+"')")} 

