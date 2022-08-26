SELECT DISTINCT CUS_CODE,CUS_NAME
FROM  DM_DELIVERY_SALE_STOCK
WHERE 
AREA_CODE = '${AREA_CODE}'
--1=1
--${if(len(AREA_CODE)=0,"", "and AREA_CODE in ('"+AREA_CODE+"')")} 



SELECT DISTINCT
DDATE AS 日期, 
WEEK_ID AS 第几周,
MONTH_ID||WEEK_ID as NEW_ID,
case when WEEK_DESC='星期一' then 'Mon'
	when WEEK_DESC='星期二' then 'Tue'
	when WEEK_DESC='星期三' then 'Wed'
	when WEEK_DESC='星期四' then 'Thu'	
	when WEEK_DESC='星期五' then 'Fri'	
	when WEEK_DESC='星期六' then 'Sat'
	when WEEK_DESC='星期日' then 'Sun' end AS 星期几,
YEAR_ID AS 年份,
MONTH_ID AS 月份,
to_char(DDATE,'MM') as 月,
TO_CHAR(DDATE,'MM-dd') AS 日月日期
FROM DIM_DAY 
WHERE 
YEAR_ID = TO_CHAR(DATE'${DATE2}','YYYY')
AND DDATE >= 
(
select min(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE1}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE1}','YYYY-MM-DD'))
)

and DDATE <= 
(
select max(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE2}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE2}','YYYY-MM-DD'))
)
ORDER BY DDATE



SELECT DISTINCT
DDATE AS 日期, 
WEEK_ID AS 第几周,
case when WEEK_DESC='星期一' then 'Mon'
	when WEEK_DESC='星期二' then 'Tue'
	when WEEK_DESC='星期三' then 'Wed'
	when WEEK_DESC='星期四' then 'Thu'	
	when WEEK_DESC='星期五' then 'Fri'	
	when WEEK_DESC='星期六' then 'Sat'
	when WEEK_DESC='星期日' then 'Sun' end AS 星期几,
YEAR_ID AS 年份,
MONTH_ID AS 月份,
to_char(DDATE,'MM') as 月,
TO_CHAR(DDATE,'MM-dd') AS 日月日期
FROM DIM_DAY 
WHERE 
YEAR_ID = TO_CHAR(ADD_MONTHS(DATE'${DATE1}',-12),'YYYY')
--AND 
--DDATE <= ADD_MONTHS(DATE'${DATE1}',-12)
ORDER BY DDATE


SELECT 
SALE_DATE AS 日期,
ROUND(SUM(NO_TAX_AMOUNT),2) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税成本,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
SUM(SALE_QTY) AS 销售数量
FROM 
DM_SALE_TMP a,DIM_DAY b
WHERE 
AREA_CODE = '${AREA_CODE}'
AND
--TO_CHAR(CUS_CODE) = '${CUS}'
CUS_CODE = '${CUS}'

--1=1
--${if(len(CUS)=0,"", "and CUS_CODE in ('"+CUS+"')")} 
--${if(len(AREA_CODE)=0,"", "and AREA_CODE in ('"+AREA_CODE+"')")}
and a.SALE_DATE=b.DDATE
AND 
b.YEAR_ID= SUBSTR('${DATE1}',1,4)

GROUP BY SALE_DATE

SELECT 
--A.CUS_CODE,
SALE_DATE,
SUM(A.TRAN_NUM) AS 交易笔次
FROM 
DIM_DAY ss,DM_TRANSACTION A
LEFT JOIN 
DIM_CUS B
ON 
A.AREA_CODE = B.AREA_CODE 
AND 
TO_CHAR(A.CUS_CODE) = b.CUS_CODE
WHERE
A.AREA_CODE = '${AREA_CODE}'
AND
TO_CHAR(A.CUS_CODE) = '${CUS}'

--1=1
--${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
--${if(len(AREA_CODE)=0,"", "and A.AREA_CODE in ('"+AREA_CODE+"')")}
--AND
--SALE_DATE <= DATE'${DATE1}'

and A.SALE_DATE=ss.DDATE
and 
ss.YEAR_ID = SUBSTR('${DATE1}',1,4)
GROUP BY
SALE_DATE 
ORDER BY 
SALE_DATE

SELECT 
SALE_DATE AS 日期,
ROUND(SUM(NO_TAX_AMOUNT),2) AS 无税销售额,
SUM(NO_TAX_COST) AS 无税成本,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
SUM(SALE_QTY) AS 销售数量
FROM 
DM_SALE_TMP a,DIM_DAY b
WHERE 
AREA_CODE = '${AREA_CODE}'
AND
CUS_CODE = '${CUS}'
--1=1
--${if(len(CUS)=0,"", "and CUS_CODE in ('"+CUS+"')")} 
--${if(len(AREA_CODE)=0,"", "and AREA_CODE in ('"+AREA_CODE+"')")} 
and a.SALE_DATE=b.DDATE
AND 
b.YEAR_ID= SUBSTR('${DATE1}',1,4)-1

GROUP BY SALE_DATE

SELECT 
--A.CUS_CODE,
SALE_DATE,
SUM(A.TRAN_NUM) AS 交易笔次
FROM 
DIM_DAY ss,DM_TRANSACTION A
LEFT JOIN 
DIM_CUS B
ON 
A.AREA_CODE = B.AREA_CODE 
AND 
TO_CHAR(A.CUS_CODE) = b.CUS_CODE 
WHERE
A.AREA_CODE = '${AREA_CODE}'
AND
TO_CHAR(A.CUS_CODE) = '${CUS}'
--1=1
--${if(len(CUS)=0,"", "and A.CUS_CODE in ('"+CUS+"')")} 
--${if(len(AREA_CODE)=0,"", "and A.AREA_CODE in ('"+AREA_CODE+"')")}
--AND
--SALE_DATE <= DATE'${DATE1}'

and  
A.SALE_DATE=ss.DDATE 
and  
ss.YEAR_ID = SUBSTR('${DATE1}',1,4)-1
GROUP BY
SALE_DATE 
ORDER BY 
SALE_DATE

SELECT DISTINCT
DDATE AS 日期, 
WEEK_ID AS 第几周,
MONTH_ID||WEEK_ID as NEW_ID,
WEEK_DESC AS 星期几,
YEAR_ID AS 年份,
MONTH_ID AS 月份,
TO_CHAR(DDATE,'MM-dd') AS 日月日期
FROM DIM_DAY 
WHERE 
YEAR_ID = TO_CHAR(DATE'${DATE1}','YYYY')
AND 
DDATE <= (select max(DDATE) from DIM_DAY where  YEAR_ID = TO_CHAR(DATE'${DATE1}','YYYY') 
and WEEK_ID=(select WEEK_ID from DIM_DAY where DDATE=to_date('${DATE1}','YYYY-MM-DD')))
ORDER BY DDATE



SELECT 
SALE_DATE,
SUM(NO_TAX_AMOUNT) as 无税销售额
FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= 
(
select min(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE1}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE1}','YYYY-MM-DD'))
)
AND  
SALE_DATE <= 
(
select max(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE2}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE2}','YYYY-MM-DD'))
)
AND
RELATED_PARTY_TRNSACTION = '否'
group by SALE_DATE

SELECT 
SALE_DATE,
SUM(NO_TAX_AMOUNT) as 无税销售额
FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(DATE'${DATE1}',-13) AND  
SALE_DATE <= ADD_MONTHS(DATE'${DATE2}',-11)
AND
RELATED_PARTY_TRNSACTION = '否'
group by SALE_DATE



SELECT 
SUM(NO_TAX_AMOUNT) as 无税销售额,
SALE_DATE
FROM
DM_MONTHLY_COMPANY A,DIM_REGION B
WHERE
A.AREA_CODE = B.AREA_CODE
and 
ATTribute = '直营'
AND
OTO = '否'
AND 
DTP = '否'
and 
A.AREA_CODE != '00'
and  
SALE_DATE >= 
(
select min(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE1}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE1}','YYYY-MM-DD'))
)
AND  
SALE_DATE <= 
(
select max(DDATE) 
from DIM_DAY 
where  
YEAR_ID = TO_CHAR(DATE'${DATE2}','YYYY') 
and 
WEEK_ID=
(select WEEK_ID from DIM_DAY 
where DDATE=to_date('${DATE2}','YYYY-MM-DD'))
)
group by SALE_DATE



SELECT 
SUM(NO_TAX_AMOUNT) as 无税销售额,
SALE_DATE
FROM
DM_MONTHLY_COMPANY A,DIM_REGION B
WHERE
A.AREA_CODE = B.AREA_CODE
and 
ATTribute = '直营'
AND
OTO = '否'
AND 
DTP = '否'
and 
A.AREA_CODE != '00'

and  
SALE_DATE >= ADD_MONTHS(DATE'${DATE1}',-13) 
AND  
SALE_DATE <= ADD_MONTHS(DATE'${DATE2}',-11)
group by SALE_DATE

SELECT 
substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) as month,
SUM(NO_TAX_AMOUNT) as 无税销售额
FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= date'2019-01-01' AND  
SALE_DATE <= TO_DATE('${DATE2}','YYYY-MM-dd')
AND
RELATED_PARTY_TRNSACTION = '否'
group by substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7)

SELECT 
substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) as month,
SUM(NO_TAX_AMOUNT) as 无税销售额
FROM DM_MONTHLY_COMPANY
WHERE SALE_DATE >= ADD_MONTHS(DATE'2019-01-01',-12) AND  
SALE_DATE <= ADD_MONTHS(DATE'${DATE2}',-12)
AND
RELATED_PARTY_TRNSACTION = '否'
group by substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7)


SELECT 
SUM(NO_TAX_AMOUNT) as 无税销售额,
substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) as month
FROM
DM_MONTHLY_COMPANY A,DIM_REGION B
WHERE
A.AREA_CODE = B.AREA_CODE
and 
ATTribute = '直营'
AND
OTO = '否'
AND 
DTP = '否'
and 
A.AREA_CODE != '00'
AND  
SALE_DATE >= date'2019-01-01'
AND  
SALE_DATE <= TO_DATE('${DATE2}','YYYY-MM-DD')
group by substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) 



SELECT 
SUM(NO_TAX_AMOUNT) as 无税销售额,
substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) as month
FROM
DM_MONTHLY_COMPANY A,DIM_REGION B
WHERE
A.AREA_CODE = B.AREA_CODE
and 
ATTribute = '直营'
AND
OTO = '否'
AND 
DTP = '否'
and 

A.AREA_CODE != '00'
AND
SALE_DATE >= ADD_MONTHS(DATE'2019-01-01',-12) 
AND  
SALE_DATE <= ADD_MONTHS(DATE'${DATE2}',-12)
group by substr(TO_char(SALE_DATE,'YYYY-MM-dd'),1,7) 



select 
distinct
MONTH_ID,
to_char(DDATE,'MM') as 月
from 
dim_day
where 
YEAR_ID = TO_CHAR(DATE'${DATE2}','YYYY')
and DDATE <= DATE'${DATE2}'

order by MONTH_ID

select 
distinct
MONTH_ID,
to_char(DDATE,'MM') as 月
from 
dim_day
where 
YEAR_ID = TO_CHAR(ADD_MONTHS(DATE'${DATE2}',-12),'YYYY')
and DDATE <= ADD_MONTHS(DATE'${DATE2}',-12)

order by MONTH_ID

