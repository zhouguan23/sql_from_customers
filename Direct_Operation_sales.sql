select  a.旬报,a.子公司编码,a.子公司,a.无税销售额/b.天数 as 日均销售额
from (
SELECT DISTINCT
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数
FROM
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND  

1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
AND
TO_CHAR(SALE_DATE，'YYYY-MM') = SUBSTR('${date}',1,7)
GROUP BY a.AREA_CODE,b.AREA_NAME,
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END) a,
(SELECT DISTINCT
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
count(1) AS 天数
FROM
DIM_DAY
WHERE 


 
month_id='${date}'
and ddate<trunc(sysdate)
GROUP BY 
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END
) b
where a.旬报=b.旬报
order by 2

select  a.旬报,a.子公司编码,a.子公司,a.无税销售额/b.天数 as 日均销售额 from 

(SELECT DISTINCT
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数,
SUM(NO_TAX_AMOUNT)/COUNT(1) AS 日均销售额
FROM
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND
TO_CHAR(SALE_DATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-1),'YYYY-MM')
AND 
1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
GROUP BY a.AREA_CODE,b.AREA_NAME,
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END
)a,
(SELECT DISTINCT
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
count(1) AS 天数
FROM
DIM_DAY
WHERE 


1=1
 
AND
TO_CHAR(DDATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-1),'YYYY-MM')
GROUP BY 
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END
) b
where a.旬报=b.旬报


select  a.旬报,a.子公司编码,a.子公司,a.无税销售额/b.天数 as 日均销售额 from 

(SELECT DISTINCT
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数,
SUM(NO_TAX_AMOUNT)/COUNT(1) AS 日均销售额
FROM
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND
TO_CHAR(SALE_DATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-12),'YYYY-MM')
AND 
1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
GROUP BY a.AREA_CODE,b.AREA_NAME,
CASE WHEN 
TO_CHAR(SALE_DATE,'DD') >='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END
)a,
(SELECT DISTINCT
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,
count(1) AS 天数
FROM
DIM_DAY
WHERE 


1=1
 
AND
TO_CHAR(DDATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-12),'YYYY-MM')
GROUP BY 
CASE WHEN 
TO_CHAR(DDATE,'DD') >='01' and TO_CHAR(DDATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(DDATE,'DD')>='11' and TO_CHAR(DDATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END
) b
where a.旬报=b.旬报


SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION

Select area_code,area_name from DIM_REGION 
WHERE 
1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN ('"+UNION_AREA+"') ")}

ORDER BY AREA_CODE ASC



SELECT 
a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数,
SUM(NO_TAX_AMOUNT)/c.天数 AS 日均销售额
FROM
(SELECT 
count(1) AS 天数
FROM
DIM_DAY
WHERE 
month_id='${date}'
and ddate<trunc(sysdate)
) c,
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND  

1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
AND
TO_CHAR(SALE_DATE，'YYYY-MM') = SUBSTR('${date}',1,7)
GROUP BY a.AREA_CODE,b.AREA_NAME,c.天数
order by a.AREA_CODE asc

SELECT 

a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数,
SUM(NO_TAX_AMOUNT)/c.天数 AS 日均销售额
FROM
(SELECT 
count(1) AS 天数
FROM
DIM_DAY
WHERE 
1=1
AND
TO_CHAR(DDATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-1),'YYYY-MM')
) c,
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND
TO_CHAR(SALE_DATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-1),'YYYY-MM')
AND 
1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
GROUP BY a.AREA_CODE,b.AREA_NAME,c.天数
order by a.AREA_CODE asc

SELECT 

a.AREA_CODE AS 子公司编码,
b.AREA_NAME AS 子公司,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
count(1) AS 天数,
SUM(NO_TAX_AMOUNT)/c.天数 AS 日均销售额
FROM
(SELECT 
count(1) AS 天数
FROM
DIM_DAY
WHERE 
1=1
AND
TO_CHAR(DDATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-12),'YYYY-MM')
) c,
DM_MONTHLY_SALE a
LEFT JOIN
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE 
ACCOUNTNAME = '直营常规'
AND
TO_CHAR(SALE_DATE,'YYYY-MM') = to_char(add_months(to_date('${date}'||'-01','YYYY-MM-DD'),-12),'YYYY-MM')
AND 
1=1
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 

${if(len(AREA)=0,"","and A.AREA_CODE in('"+AREA+"')")}  
GROUP BY a.AREA_CODE,b.AREA_NAME,c.天数
order by a.AREA_CODE asc

