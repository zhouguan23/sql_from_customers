SELECT
CASE WHEN 
TO_CHAR(TO_DATE(SALE_DATE,'DD'))>='01' and TO_CHAR(TO_DATE(SALE_DATE,'DD'))< '11'
THEN '上旬'
WHEN
TO_CHAR(TO_DATE(SALE_DATE,'DD'))>='11' and TO_CHAR(TO_DATE(SALE_DATE,'DD'))< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报
FROM 
FACT_SALE



SELECT 
DISTINCT 
COUNT(b.CUS_CODE) AS 门店数,
b.area_CODE,
a.AREA_NAME
FROM 
DIM_CUS b
LEFT JOIN
DIM_REGION a
on
a.AREA_CODE = b.AREA_CODE
 join (select area_code,cus_code ,age_store,row_number() over (partition by area_code,cus_code order by date1 desc ) rn from age_store ) s
on b.area_code=s.area_code
and b.cus_code=s.cus_code
and s.rn=1

WHERE 
(b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否')
AND
b.open_date < ADD_MONTHS(TO_DATE(CONCAT('${date}','-01'),'YYYY-MM-DD'),+1)
AND
(
b.CLOSE_DATE IS NULL
Or
b.CLOSE_DATE >= ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${date}',1,7),'-01'),'YYYY-MM-DD'),+1)
)
and b.attribute in('直营','加盟')
and nvl(s.age_store,'NULL') not in ('直营（关）','非直营（关）','虚拟（关）','虚拟','非直营(关)')
GROUP BY b.AREA_CODE,a.AREA_NAME
ORDER BY b.AREA_CODE



SELECT 
DISTINCT 
COUNT(b.CUS_CODE) AS 门店数,
b.AREA_CODE,
a.AREA_NAME
FROM 
DIM_CUS b
LEFT JOIN
DIM_REGION a
on
a.AREA_CODE = b.AREA_CODE
 join age_store s
on b.area_code=s.area_code
and b.cus_code=s.cus_code
and date1=CONCAT(SUBSTR('${date}',0,4)-1,'-12')
WHERE 
(b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否')
AND
b.open_date <= TO_DATE(CONCAT(SUBSTR('${date}',0,4),'-01-01'),'YYYY-MM-DD')
AND
(
b.CLOSE_DATE IS NULL
OR
b.CLOSE_date >= TO_DATE(CONCAT(SUBSTR('${date}',0,4),'-01-01'),'YYYY-MM-DD')
)
and length(b.area_code)=2
and b.attribute in('直营','加盟')
and nvl(s.age_store,'NULL') not in ('直营（关）','非直营（关）','调整沈阳','虚拟（关）','虚拟','非直营(关)')
GROUP BY b.AREA_CODE,a.AREA_NAME
ORDER BY b.AREA_CODE


SELECT
DISTINCT a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', nvl(no_tax_amount,0)-nvl(no_tax_cost,0), 0)) else sum(no_tax_amount)-sum(no_tax_cost) end  AS 毛利额,
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0)) else sum(no_tax_cost) end AS 无税成本,
CASE WHEN
SUM(NO_TAX_AMOUNT) = 0
THEN 0 
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
as 毛利率
FROM DM_MONTHLY_COMPANY a
LEFT JOIN
DIM_REGION b
on 
a.AREA_CODE = b.AREA_CODE
WHERE 
--VIRTUAL_SHOP != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = '${date}'
GROUP BY a.AREA_CODE,b.AREA_NAME

SELECT
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', nvl(no_tax_amount,0)-nvl(no_tax_cost,0), 0)) else sum(no_tax_amount)-sum(no_tax_cost) end AS 无税毛利额, 
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0)) else sum(no_tax_cost)  end as 总成本,
CASE WHEN
SUM(NO_TAX_AMOUNT) = 0
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/
SUM(NO_TAX_AMOUNT) 
END
as 毛利率
FROM DM_MONTHLY_COMPANY 
WHERE
--VIRTUAL_SHOP != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = '${date}'

SELECT
DISTINCT 
a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
 case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end  as 无税销售额
FROM DM_MONTHLY_COMPANY a
LEFT JOIN 
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE
--VIRTUAL_SHOP != '是'
--AND
--RELATED_PARTY_TRNSACTION != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = '${date}'
GROUP BY a.AREA_CODE,b.AREA_NAME

SELECT
DISTINCT a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 无税环比销售额
FROM DM_MONTHLY_COMPANY a
LEFT JOIN 
DIM_REGION b
ON 
a.AREA_CODE = b.AREA_CODE
WHERE
--VIRTUAL_SHOP != '是'
--AND
--RELATED_PARTY_TRNSACTION != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT('${date}','-01'),'YYYY-MM-DD'),-1),'YYYY-MM')
GROUP BY a.AREA_CODE,b.AREA_NAME

SELECT
DISTINCT a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 无税环比销售额
FROM DM_MONTHLY_COMPANY a
LEFT JOIN 
DIM_REGION b
ON 
a.AREA_CODE = b.AREA_CODE
WHERE
--VIRTUAL_SHOP != '是'
--AND
--RELATED_PARTY_TRNSACTION != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT('${date}','-01'),'YYYY-MM-DD'),-12),'YYYY-MM')
GROUP BY a.AREA_CODE,b.AREA_NAME

SELECT
DISTINCT 
a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
CASE WHEN 
TO_CHAR(SALE_DATE,'DD')>='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END AS 旬报,

  case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
end  as 无税销售额
FROM DM_MONTHLY_COMPANY a
LEFT JOIN DIM_REGION b
ON
A.AREA_CODE = b.AREA_CODE
WHERE
--RELATED_PARTY_TRNSACTION != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY-MM') = SUBSTR('${date}',1,7)
GROUP BY 
a.AREA_CODE,
b.AREA_NAME,
CASE WHEN 
TO_CHAR(SALE_DATE,'DD')>='01' and TO_CHAR(SALE_DATE,'DD')< '11'
THEN '上旬'
WHEN
TO_CHAR(SALE_DATE,'DD')>='11' and TO_CHAR(SALE_DATE,'DD')< '21'
THEN '中旬'
ELSE 
'下旬'
END

SELECT 
DISTINCT 
COUNT(b.CUS_CODE) AS 门店数,
b.AREA_CODE,
a.AREA_NAME
FROM 
DIM_CUS b
LEFT JOIN
DIM_REGION a
on
a.AREA_CODE = b.AREA_CODE
 join age_store s
on b.area_code=s.area_code
and b.cus_code=s.cus_code
and date1=CONCAT(SUBSTR('${date}',0,4)-1,'-12')
WHERE 
(b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否')
AND
b.open_date <= TO_DATE(CONCAT(SUBSTR('${date}',0,4),'-01-01'),'YYYY-MM-DD')
AND
(
b.CLOSE_DATE IS NULL
OR
b.CLOSE_date >= TO_DATE(CONCAT(SUBSTR('${date}',0,4),'-01-01'),'YYYY-MM-DD')
)
and length(b.area_code)=2
and b.attribute ='直营'
and nvl(s.age_store,'NULL') not in ('直营（关）','非直营（关）','调整沈阳','虚拟（关）','虚拟','非直营(关)')
GROUP BY b.AREA_CODE,a.AREA_NAME
ORDER BY b.AREA_CODE


SELECT 
DISTINCT 
COUNT(b.CUS_CODE) AS 门店数,
b.area_CODE,
a.AREA_NAME
FROM 
DIM_CUS b
LEFT JOIN
DIM_REGION a
on
a.AREA_CODE = b.AREA_CODE
 join (select area_code,cus_code ,age_store,row_number() over (partition by area_code,cus_code order by date1 desc ) rn from age_store ) s
on b.area_code=s.area_code
and b.cus_code=s.cus_code
and s.rn=1

WHERE 
(b.VIRTUAL_SHOP is null or b.VIRTUAL_SHOP='否')
AND
b.open_date < ADD_MONTHS(TO_DATE(CONCAT('${date}','-01'),'YYYY-MM-DD'),+1)
AND
(
b.CLOSE_DATE IS NULL
Or
b.CLOSE_DATE >= ADD_MONTHS(TO_DATE(CONCAT(SUBSTR('${date}',1,7),'-01'),'YYYY-MM-DD'),+1)
)
and b.attribute ='直营'
and nvl(s.age_store,'NULL') not in ('直营（关）','非直营（关）','虚拟（关）','虚拟','非直营(关)')
GROUP BY b.AREA_CODE,a.AREA_NAME
ORDER BY b.AREA_CODE



SELECT
DISTINCT a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
SUM(NO_TAX_AMOUNT) as 无税销售额
FROM DM_MONTHLY_COMPANY a
LEFT JOIN 
DIM_REGION b
ON
a.AREA_CODE = B.AREA_CODE
WHERE
ATTRIBUTE = '直营'
--AND
--VIRTUAL_SHOP != '是'
AND
TO_CHAR(SALE_DATE,'YYYY-MM') = '${date}'
GROUP BY a.AREA_CODE,b.AREA_NAME

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.sorted from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.area_code in (select distinct area_code from dm_monthly_company where TO_CHAR(SALE_DATE,'YYYY-MM') = '${date}')
ORDER BY a.sorted

SELECT  
AREA_CODE AS 区域编码,
CREATE_MONTH AS 销售指标,
VALUE AS 指标值

FROM 

FACT_SALE_INDEX 
WHERE 
CREATE_MONTH = substr('${date}',0,4)
and 1=1 ${if(len(AREA)=0,""," and area_code in ('"+AREA+"')")} 

SELECT   
DISTINCT   
UNION_AREA_NAME  
FROM  
DIM_REGION   


SELECT   
*
FROM  
DIM_REGION 
WHERE   
1=1
${if(len(UNION_AREA)==0,"","AND UNION_AREA_NAME in ('"+UNION_AREA+"')")}
order by sorted


SELECT
DISTINCT 
a.AREA_CODE as 子公司编码,
b.AREA_NAME AS 子公司, 
    case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 无税销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', nvl(no_tax_amount,0)-nvl(no_tax_cost,0), 0)) else sum(no_tax_amount)-sum(no_tax_cost) end  AS 毛利额,
case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0)) else sum(no_tax_cost) end AS 无税成本
FROM DM_MONTHLY_COMPANY a
LEFT JOIN 
DIM_REGION b
ON
a.AREA_CODE = b.AREA_CODE
WHERE
--RELATED_PARTY_TRNSACTION != '是'
--AND
TO_CHAR(SALE_DATE,'YYYY') = SUBSTR('${date}',1,4)
GROUP BY a.AREA_CODE,b.AREA_NAME

SELECT   
* 
FROM  
DIM_REGION   
order by sorted


