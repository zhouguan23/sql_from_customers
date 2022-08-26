
SELECT 

(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-dd'),-12) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-dd'),-12)


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= TO_DATE('${date1}','YYYY-MM-dd') AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-dd')



SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-dd')
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-dd')
AND 
AREA_CODE != '00'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '否'
AND
ATTribute = '加盟'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD') 
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-DD')


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-dd'),-1) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-dd'),-1)



SELECT 

(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-dd'),-12) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-dd'),-12)
AND
AREA_CODE != '00'


SELECT 

(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-dd'),-1) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-dd'),-1)
AND 
AREA_CODE != '00'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
ATTRIBUTE = '直营'
AND
OTO = '否'
AND 
DTP = '否'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD') 
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-DD')

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '否'
AND
ATTribute = '加盟'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-1) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-1)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '否'
AND
ATTribute = '加盟'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-12) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-12)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= TO_DATE('${DATE1}','YYYY-MM-dd') 
AND  
SALE_DATE <= TO_DATE('${DATE2}','YYYY-MM-dd')
AND 
ATTRIBUTE = '批发'
AND
RELATED_PARTY_TRNSACTION = '否'
AND
AREA_CODE != '00'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-1) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-1)
AND 
AREA_CODE != '00'
AND 
ATTRIBUTE = '批发'
AND
RELATED_PARTY_TRNSACTION = '否'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-12) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-12)
AND 
AREA_CODE != '00'
AND 
ATTRIBUTE = '批发'
AND
RELATED_PARTY_TRNSACTION = '否'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-dd') 
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-dd')

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-1) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-1)


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
DTP = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-12) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-12)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
OTO = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= TO_DATE('${DATE1}','YYYY-MM-dd') 
AND  
SALE_DATE <= TO_DATE('${DATE2}','YYYY-MM-dd')


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
OTO = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-1) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-1)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
OTO = '是' 
AND 
AREA_CODE != '00'
AND 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-12) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-12)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
ATTribute = '直营'
AND
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-12) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-12)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
ATTRIBUTE = '直营'
AND
DTP = '否'
AND 
OTO = '否'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-1) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-1)

SELECT DISTINCT
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END AS COMPARE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税成本，
SUM(NO_TAX_AMOUNT)-SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
 AS 无税毛利率
FROM
DM_SHOP_COMPANY
WHERE
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(TO_DATE('${DATE1}','YYYY-MM-DD'),'YYYY-MM-DD')
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(TO_DATE('${DATE2}','YYYY-MM-DD'),'YYYY-MM-DD')
GROUP BY 
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END

SELECT DISTINCT
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END AS COMPARE,
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_SHOP_COMPANY 
WHERE  
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'

AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-12),'YYYY-MM-DD')
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-12),'YYYY-MM-DD')
GROUP BY 
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END
--,a.AREA_CODE

SELECT DISTINCT
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END AS COMPARE,
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_SHOP_COMPANY 
WHERE  

TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-1),'YYYY-MM-DD')
and
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-1),'YYYY-MM-DD')
GROUP BY 
CASE WHEN
TIME = '新店'
THEN
'新店'
WHEN
TIME = '次新店'
THEN
'次新店'
ELSE
'可比店'
END

SELECT 
DISTINCT
TIME AS 年限,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税成本，
SUM(NO_TAX_AMOUNT)-SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
 AS 无税毛利率
FROM
DM_SHOP_COMPANY 
WHERE  
TIME in ('第三年店','第四年店','第五年以上店')
and
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(TO_DATE('${DATE1}','YYYY-MM-DD'),'YYYY-MM-DD')
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(TO_DATE('${DATE2}','YYYY-MM-DD'),'YYYY-MM-DD')
GROUP BY 
TIME

SELECT DISTINCT
TIME AS 年限,
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_SHOP_COMPANY 
WHERE  
TIME in ('第三年店','第四年店','第五年以上店')
and
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-12),'YYYY-MM-DD')
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-12),'YYYY-MM-DD')
GROUP BY 
TIME

SELECT DISTINCT
TIME AS 年限,
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_SHOP_COMPANY
WHERE  
TIME in ('第三年店','第四年店','第五年以上店')
AND
DTP = '否'
AND
OTO = '否'
AND 
AREA_CODE != '00'
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') >= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-DD'),-1),'YYYY-MM-DD')
AND
TO_CHAR(SALE_DATE,'YYYY-MM-DD') <= TO_CHAR(ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-DD'),-1),'YYYY-MM-DD')
GROUP BY 
TIME


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-dd')
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-dd')
AND AREA_CODE= '00'
GROUP BY AREA_CODE



SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-12) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-12)
AND AREA_CODE= '00'
GROUP BY AREA_CODE,AREA_NAME

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-1) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-1)
AND AREA_CODE= '00'
GROUP BY AREA_CODE


SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-12) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-12)
AND 
AREA_CODE != '00'
AND 
ATTRIBUTE = '批发'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${DATE2}'-DATE'${DATE1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= ADD_MONTHS(TO_DATE('${DATE1}','YYYY-MM-dd'),-1) AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${DATE2}','YYYY-MM-dd'),-1)
AND 
AREA_CODE != '00'
AND 
ATTRIBUTE = '批发'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM DM_MONTHLY_COMPANY
WHERE 
SALE_DATE >= TO_DATE('${DATE1}','YYYY-MM-dd') 
AND  
SALE_DATE <= TO_DATE('${DATE2}','YYYY-MM-dd')
AND 
ATTRIBUTE = '批发'
AND
AREA_CODE != '00'

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) AS 无税毛利额,
SUM(NO_TAX_AMOUNT) as 无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率

FROM
DM_MONTHLY_COMPANY
WHERE
ATTRIBUTE = '直营'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= TO_DATE('${date1}','YYYY-MM-DD') 
AND  
SALE_DATE <= TO_DATE('${date2}','YYYY-MM-DD')

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
ATTRIBUTE = '直营'
AND
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-1) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-1)

SELECT 
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}'))
AS 日均无税毛利额,
SUM(NO_TAX_AMOUNT)/
ROUND(TO_NUMBER(DATE'${date2}'-DATE'${date1}')) as 日均无税销售额,
CASE WHEN 
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/SUM(NO_TAX_AMOUNT) 
END
AS 毛利率
FROM
DM_MONTHLY_COMPANY
WHERE
ATTribute = '直营'
AND 
AREA_CODE != '00'
and  
SALE_DATE >= ADD_MONTHS(TO_DATE('${date1}','YYYY-MM-DD'),-12) 
AND  
SALE_DATE <= ADD_MONTHS(TO_DATE('${date2}','YYYY-MM-DD'),-12)
