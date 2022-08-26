SELECT  
  DAY_NUM,   -- 在销天数
  REAL_AMOUNT,
  ORGI_AMOUNT,
  TRANS_AMOUNT,
  REAL_PRICE,
  REAL_QTY,
  A.ORG_NAME,
  A.ORG_CODE,
  NUM,
  BRAND_NAME,
  ATTRI_ORG_LEVEL,
  ATTRI_ORG_AREA,
  ORG_DOMAIN_NAME,
  sub_company_name,
  ATTRI_MANAGE_REGION,
  MANAGE_REGION_NAME,
  open_date,
  real_open_date,
  AD
FROM 
(
-- 取自销售表的组织编码
  SELECT
    B.ORG_CODE,
    B.ORG_NAME
  FROM
    FACT_S_SALE_SHOP  A,
    DIM_S_SHOP  B,
    (
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in(select POST FROM FILL_POST)
      union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.DOMAIN
      and a.POST in('督导')
      union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.AD
      and a.POST in('城市经理')
   ) f
  WHERE
  A.org_code = B.ORG_CODE
  and A.ORG_CODE=f.ORG_CODE
  AND (A.CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  --AND CREATE_DATE>=DATE_FORMAT(CONCAT('${CREATE_MONTH}','-01'),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE>=TO_CHAR(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
  --AND CREATE_DATE<=DATE_FORMAT(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE<=TO_CHAR(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd hh24:mi:ss')
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
-- 取自月末库存的组织编码
  UNION
  SELECT 
    B.ORG_CODE,
    B.ORG_NAME 
  FROM 
    FACT_S_STOCK_SHOP  A,
    DIM_S_SHOP  B,
  (
    select distinct 
      c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
    b.ID=a.USER_ID 
    and b.username='${fr_username}'
    and a.POST in(select POST FROM FILL_POST)
    union 
    select distinct 
      c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
    b.ID=a.USER_ID 
    and b.username='${fr_username}'
    and b.ID=c.DOMAIN
    and a.POST in('督导')
    union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.AD
      and a.POST in('城市经理')
    ) f
  WHERE 
  A.ORG_CODE=B.ORG_CODE
  and A.ORG_CODE=f.ORG_CODE
  AND (A.CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  --AND CREATE_DATE=DATE_FORMAT(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE=LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd hh24:mi:ss'))
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
-- 取自在途表的组织编码
  UNION
  select 
    B.ORG_CODE,
    B.ORG_NAME 
  FROM 
    FACT_ON_PASSAGE_ITEM  A,
    DIM_S_SHOP  B,
  (
    select distinct c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c,FILL_USER_BRAND  d
where b.ID=a.USER_ID and b.username='${fr_username}'
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
and c.BRAND_NAME=d.BRAND_NAME and c.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(sub_company_name)=0,"","and c.SUB_COMPANY_NAME IN ('"+sub_company_name+"')")}
and to_char(b.ID)=d.USER_ID
    union 
    select distinct 
      c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
    b.ID=a.USER_ID 
    and b.username='${fr_username}'
    and b.ID=c.DOMAIN
    and a.POST in('督导')
    union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.AD
      and a.POST in('城市经理')
    ) f
  WHERE 
  A.ORG_CODE = B.ORG_CODE
  and A.ORG_CODE=f.ORG_CODE
  AND (A.CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  --AND A.CREATE_DATE=DATE_SUB(DATE_ADD(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 MONTH),INTERVAL 1 DAY)
  AND A.CREATE_DATE=TO_CHAR(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd')
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
-- 取自配送表的组织编码
  union 
  SELECT
    B.ORG_CODE,
    B.ORG_NAME
  FROM
    FACT_ON_REGULAR_MONTH  A,
    DIM_S_SHOP  B,
    (
      select distinct c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c,FILL_USER_BRAND  d
where b.ID=a.USER_ID and b.username='${fr_username}'
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
and c.BRAND_NAME=d.BRAND_NAME and c.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
and TO_CHAR(b.ID)=d.USER_ID
      union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.DOMAIN
      and a.POST in('督导')
      union 
      select distinct 
        c.ORG_CODE 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_S_SHOP  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.AD
      and a.POST in('城市经理')
   ) f
  WHERE
  A.ORG_CODE = B.ORG_CODE
  and A.ORG_CODE=f.ORG_CODE
  AND BRAND_NAME = '${BRAND_NAME}'
  AND (A.CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")}) 
  ${IF(LEN(sub_company_name)==0,""," AND sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  AND CREATE_MONTH = '${CREATE_MONTH}'
  )  A
LEFT JOIN
-- 销售数据
(
  SELECT
    COUNT(CREATE_DATE)  DAY_NUM,
    SUM(A.REAL_AMOUNT)  REAL_AMOUNT,
    decode(SUM(REAL_QTY) ,'0','',SUM(A.REAL_AMOUNT)/SUM(REAL_QTY))  REAL_PRICE,
    SUM(A.ORGI_AMOUNT)  ORGI_AMOUNT,
    SUM(A.TRANS_AMOUNT)  TRANS_AMOUNT,
    SUM(A.REAL_QTY)  REAL_QTY,
    B.ORG_NAME,
    B.ORG_CODE,
    sum(A.NUM)  NUM,
    B.BRAND_NAME,
    ATTRI_ORG_LEVEL,
    ATTRI_ORG_AREA,
    ORG_DOMAIN_NAME,
    B.sub_company_name,
    ATTRI_MANAGE_REGION,
    MANAGE_REGION_NAME,
    open_date,
    real_open_date,
    AD
  FROM
    FACT_S_SALE_SHOP  A,
    DIM_S_SHOP  B
  WHERE
  A.org_code = B.ORG_CODE  --AND CREATE_DATE>=DATE_FORMAT(CONCAT('${CREATE_MONTH}','-01'),'%Y-%m-%d %H:%i:%S')  
  AND CREATE_DATE>=TO_CHAR(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),'yyyy-mm-dd hh24:mi:ss')
  --AND CREATE_DATE<=DATE_FORMAT(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE<=TO_CHAR(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd hh24:mi:ss')
  AND BRAND_NAME = '${BRAND_NAME}' 
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  GROUP BY B.ORG_NAME,B.BRAND_NAME,B.ORG_CODE,B.ATTRI_ORG_LEVEL,B.ATTRI_ORG_AREA,B.ORG_DOMAIN_NAME,
    B.sub_company_name,B.ATTRI_MANAGE_REGION,B.MANAGE_REGION_NAME,B.open_date,B.real_open_date,B.AD
  )  B
ON A.ORG_CODE = B.ORG_CODE 
order by REAL_AMOUNT desc


SELECT
	COUNT(CREATE_DATE)  DAY_NUM,
	SUM(A.REAL_AMOUNT)  REAL_AMOUNT,
	SUM(A.ORGI_AMOUNT)  ORGI_AMOUNT,
	SUM(A.TRANS_AMOUNT)  TRANS_AMOUNT,
	SUM(A.REAL_QTY)  REAL_QTY,
	--A.org_name,
	A.org_code,
	sum(A.NUM)  NUM,
	B.BRAND_NAME,
	ATTRI_ORG_LEVEL,
	ATTRI_ORG_AREA,
	ORG_DOMAIN_NAME,
	B.sub_company_name,
	ATTRI_MANAGE_REGION,
	MANAGE_REGION_NAME,
	open_date
FROM
	FACT_S_SALE_SHOP  A,
	DIM_S_SHOP  B
WHERE
	A.org_code = B.ORG_CODE
	AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	--AND CREATE_DATE>=DATE_FORMAT(DATE_SUB(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 MONTH),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE>=TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),-1),'yyyy-mm-dd hh24:mi:ss')
	--AND CREATE_DATE<=DATE_FORMAT(DATE_SUB(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),INTERVAL 1 MONTH),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE<=TO_CHAR(ADD_MONTHS(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),-1),'yyyy-mm-dd hh24:mi:ss')
AND BRAND_NAME = '${BRAND_NAME}' 
${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
--and a.org_code='003892'
GROUP BY --A.org_name,
   A.org_code,B.BRAND_NAME,
	B.ATTRI_ORG_LEVEL,B.ATTRI_ORG_AREA,B.ORG_DOMAIN_NAME,
	B.sub_company_name,B.ATTRI_MANAGE_REGION,B.MANAGE_REGION_NAME,B.open_date


SELECT
	COUNT(CREATE_DATE)  DAY_NUM,
	SUM(A.REAL_AMOUNT)  REAL_AMOUNT,
	SUM(A.ORGI_AMOUNT)  ORGI_AMOUNT,
	SUM(A.TRANS_AMOUNT)  TRANS_AMOUNT,
	SUM(A.REAL_QTY)  REAL_QTY,
  B.org_name,
  B.org_code,
  sum(A.NUM)  NUM,
  B.BRAND_NAME,
  ATTRI_ORG_LEVEL,
  ATTRI_ORG_AREA,
  ORG_DOMAIN_NAME,
  B.sub_company_name,
  ATTRI_MANAGE_REGION,
  MANAGE_REGION_NAME,
  open_date
FROM
  FACT_S_SALE_SHOP A,
  DIM_S_SHOP  B
WHERE
  A.org_code = B.ORG_CODE
  AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})  --AND CREATE_DATE>=DATE_FORMAT(DATE_SUB(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 YEAR),'%Y-%m-%d %H:%i:%S')
  AND A.CREATE_DATE>=TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),-12),'yyyy-mm-dd hh24:mi:ss')
  --AND CREATE_DATE<=DATE_FORMAT(DATE_SUB(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),INTERVAL 1 YEAR),'%Y-%m-%d %H:%i:%S')
  AND A.CREATE_DATE<=TO_CHAR(ADD_MONTHS(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),-12),'yyyy-mm-dd hh24:mi:ss')
AND BRAND_NAME = '${BRAND_NAME}' 
${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
GROUP BY B.org_name,B.org_code,B.BRAND_NAME,B.ATTRI_ORG_LEVEL,B.ATTRI_ORG_AREA,B.ORG_DOMAIN_NAME,
  B.sub_company_name,B.ATTRI_MANAGE_REGION,B.MANAGE_REGION_NAME,B.open_date


select 
  SALE_INDEX ,
  ORG_CODE 
FROM 
  FACT_S_SALE_INDEX
WHERE 
  CREATE_MONTH = '${CREATE_MONTH}'
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})

SELECT  
  STOCK_AMOUNT, 
  STOCK_QTY,
  A.ORG_CODE 
FROM 
  FACT_S_STOCK_SHOP  A,
  DIM_S_SHOP  B
WHERE 
  A.ORG_CODE=B.ORG_CODE
  --AND CREATE_DATE=DATE_FORMAT(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),'%Y-%m-%d %H:%i:%S')
  AND CREATE_DATE=LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd hh24:mi:ss'))
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})


Select 
--TIMESTAMPDIFF(day,CONCAT('${CREATE_MONTH}','-01'),(DATE_add(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 month)))  
 ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),1)-TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')                
as DATE_NUM From dual

Select 
--TIMESTAMPDIFF(day,DATE_SUB(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 YEAR),(DATE_add(DATE_SUB(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 YEAR),INTERVAL 1 month)))
 ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),-11)-ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),-12)                      

as DATE_NUM From dual

select distinct 
  b.BRAND_NAME  BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from FILL_USER_BRAND  a, FR_T_USER  b
  where a.USER_ID=to_char(b.id) 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 
-- 品牌维度


select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(BRAND_NAME)==0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a, FR_T_USER  b
  where a.USER_ID=TO_CHAR(b.id) and b.username='${fr_username}'
)
-- 分公司维度


select distinct c.ATTRI_MANAGE_REGION, c.MANAGE_REGION_NAME
  from FILL_USER_POST    a,
       FR_T_USER  b,
       DIM_S_SHOP        c,
       FILL_USER_BRAND   d
 where b.ID = a.USER_ID
   and b.username = '${fr_username}'
   AND c.BRAND_NAME = '${BRAND_NAME}'
   and a.POST in (select POST FROM FILL_POST)
   and c.BRAND_NAME = d.BRAND_NAME
   and c.SUB_COMPANY_NAME = d.SUB_COMPANY_NAME
   and c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
   and TO_CHAR(b.ID) = d.USER_ID
union
select distinct ATTRI_MANAGE_REGION, MANAGE_REGION_NAME
  from FILL_USER_POST  a,
       FR_T_USER  b,
       DIM_S_SHOP c
 where b.ID = a.USER_ID
   and b.username = '${fr_username}'
   and c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
   and b.ID = c.DOMAIN
   AND c.BRAND_NAME = '${BRAND_NAME}'
   and a.POST in ('督导')
union
select distinct ATTRI_MANAGE_REGION, MANAGE_REGION_NAME
  from FILL_USER_POST a,
       FR_T_USER b, 
       DIM_S_SHOP c
 where b.ID = a.USER_ID
   and b.username = '${fr_username}'
   and c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
   and b.ID = c.AD
   AND c.BRAND_NAME = '${BRAND_NAME}'
   and a.POST in ('城市经理')


select 
  CREATE_DATE,
  SUM(REAL_QTY) AS REAL_QTY,
  SUM(VALID_AMOUNT) AS VALID_AMOUNT,
  ATTRI_MANAGE_REGION,
  MANAGE_REGION_NAME,
  sub_company_name,
  A.ORG_CODE 
FROM 
  FACT_ON_PASSAGE_ITEM  A,
  DIM_S_SHOP B
WHERE 
  A.ORG_CODE = B.ORG_CODE  --AND A.CREATE_DATE=DATE_SUB(DATE_ADD(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 MONTH),INTERVAL 1 DAY)
  AND A.CREATE_DATE=TO_CHAR(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd')
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY   A.CREATE_DATE,
  B.ATTRI_MANAGE_REGION,
  B.MANAGE_REGION_NAME,
  B.sub_company_name,
  A.ORG_CODE 

select
  a.ORG_CODE 
from 
  DIM_SHOP_SALE_DAYS  a,
  DIM_SHOP_SALE_DAYS  b
where 
  a.ORG_CODE=b.ORG_CODE 
  and a.CREATE_MONTH='${CREATE_MONTH}'
  --and b.CREATE_MONTH=DATE_FORMAT(DATE_SUB(CONCAT('${CREATE_MONTH}','-01'),INTERVAL 1 MONTH),'%Y-%m') 
  and b.CREATE_MONTH=TO_CHAR(ADD_MONTHS(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd'),-1),'yyyy-mm')
  and a.SALE_DAYS>=20 
  and b.SALE_DAYS>=20

SELECT
	A.ORG_CODE,
	ATTRI_MANAGE_REGION,
	BRAND_NAME,
	CREATE_MONTH,
	sub_company_name,
	SUM(REAL_AMOUNT) AS REAL_AMOUNT,
	SUM(REAL_QTY) AS REAL_QTY
FROM
	FACT_ON_REGULAR_MONTH  A,
	DIM_S_SHOP  B
WHERE
	A.ORG_CODE = B.ORG_CODE
	AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
AND BRAND_NAME = '${BRAND_NAME}' 
${IF(LEN(sub_company_name)==0,""," AND sub_company_name in ('"+sub_company_name+"')")}
${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
AND CREATE_MONTH = '${CREATE_MONTH}'
GROUP BY
  A.ORG_CODE,
  A.ORG_CODE,
	B.ATTRI_MANAGE_REGION,
	B.BRAND_NAME,
	B.sub_company_name,A.CREATE_MONTH
	

SELECT 
  SUM(STOCK_INDEX_VALUE) AS STOCK_INDEX_VALUE,
  A.ORG_CODE FROM FACT_STOCK_INDEX_MONTH  A,
  DIM_S_SHOP B
WHERE 
  A.ORG_CODE = B.ORG_CODE
  AND CREATE_MONTH='${CREATE_MONTH}'
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY A.ORG_CODE

SELECT * FROM VBI_ORG_LEVEL

select id,concat(username,realname) as name from FR_T_USER 

SELECT 
 * 
FROM 
 VBI_CURRENCY
-- 币种

SELECT  
  STOCK_AMOUNT, 
  STOCK_QTY,
  A.ORG_CODE 
FROM 
  FACT_S_STOCK_SHOP  A,
  DIM_S_SHOP  B
WHERE 
  A.ORG_CODE=B.ORG_CODE 
  --AND CREATE_DATE=DATE_SUB(DATE_FORMAT(LAST_DAY(CONCAT('${CREATE_MONTH}','-01')),'%Y-%m-%d %H:%i:%S'),INTERVAL 1 YEAR)
  AND CREATE_DATE=ADD_MONTHS(LAST_DAY(TO_DATE(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd hh24:mi:ss')),-12)
  AND BRAND_NAME = '${BRAND_NAME}' 
  ${IF(LEN(sub_company_name)==0,""," AND B.sub_company_name in ('"+sub_company_name+"')")}
  ${IF(LEN (ATTRI_MANAGE_REGION) == 0,""," AND B.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')") }
  AND (CURRENCY = '${currency}'
  ${IF(currency='人民币',"OR CURRENCY IS NULL","")})


SELECT * FROM FACT_S_SALE_SHOP where org_code='001443'
and CREATE_DATE>='2017-12-01 00:00:00' and  CREATE_DATE<='2017-12-31 00:00:00'


select A.*,B.BRAND_NAME_ALL,B.SUB_COMPANY_NAME,B.ATTRI_MANAGE_REGION,
		B.MANAGE_REGION_NAME
 from
(select CREATE_MONTH,ORG_CODE,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,sum(TRANS_AMOUNT) AS TRANS_AMOUNT,decode(max(MONTH_DAY),0,'',sum(STOCK_AMOUNT)/max(MONTH_DAY)) AS A3
,max(MONTH_DAY)  as MONTH_DAY
	from FACT_STOCK_SMALL_MONTH 
	
	where CREATE_MONTH= '${CREATE_MONTH}'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND substr(SMALL_CATE_CODE,0,2)<>'20'
	AND substr(SMALL_CATE_CODE,0,2)<>'21'
	AND substr(SMALL_CATE_CODE,0,2)<>'22'
	group by CREATE_MONTH,ORG_CODE) A,
 (select 
		ORG_CODE,
		BRAND_NAME_ALL,
		SUB_COMPANY_NAME,
		ATTRI_MANAGE_REGION,
		MANAGE_REGION_NAME
	from DIM_SHOP_DAY
	
	where CREATE_DATE = to_char(LAST_DAY(to_date(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd hh24:mi:ss')
	and 
	SUB_COMPANY_NAME NOT LIKE '%电商%'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND BRAND_NAME_ALL= '${BRAND_NAME}' 
	GROUP BY ORG_CODE,BRAND_NAME_ALL,
		SUB_COMPANY_NAME,
		ATTRI_MANAGE_REGION,
		MANAGE_REGION_NAME ) B
WHERE A.ORG_CODE = B.ORG_CODE 



select A.*,B.BRAND_NAME_ALL,B.SUB_COMPANY_NAME,B.ATTRI_MANAGE_REGION,
		B.MANAGE_REGION_NAME
 from
(select CREATE_MONTH,ORG_CODE,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,sum(TRANS_AMOUNT) AS TRANS_AMOUNT,sum(STOCK_AMOUNT)/MONTH_DAY AS A3,MONTH_DAY
	from FACT_STOCK_SMALL_MONTH 
	
	where CREATE_MONTH= '${CREATE_MONTH}'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND substr(SMALL_CATE_CODE,0,2)<>'20'
	AND substr(SMALL_CATE_CODE,0,2)<>'21'
	AND substr(SMALL_CATE_CODE,0,2)<>'22'
	group by CREATE_MONTH,ORG_CODE,MONTH_DAY) A,
 (select 
		ORG_CODE,
		BRAND_NAME_ALL,
		SUB_COMPANY_NAME,
		ATTRI_MANAGE_REGION,
		MANAGE_REGION_NAME
	from DIM_SHOP_DAY
	
	where CREATE_DATE = to_char(LAST_DAY(to_date(CONCAT('${CREATE_MONTH}','-01'),'yyyy-mm-dd')),'yyyy-mm-dd hh24:mi:ss')
	and 
	SUB_COMPANY_NAME NOT LIKE '%电商%'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND BRAND_NAME_ALL= '${BRAND_NAME}' 
	GROUP BY ORG_CODE,BRAND_NAME_ALL,
		SUB_COMPANY_NAME,
		ATTRI_MANAGE_REGION,
		MANAGE_REGION_NAME ) B
WHERE A.ORG_CODE = B.ORG_CODE 


select A.*,B.BRAND_NAME_ALL,B.SUB_COMPANY_NAME,B.ATTRI_MANAGE_REGION,
		B.MANAGE_REGION_NAME
 from
(select CREATE_MONTH,ORG_CODE,sum(STOCK_AMOUNT) AS STOCK_AMOUNT,sum(TRANS_AMOUNT) AS TRANS_AMOUNT,sum(STOCK_AMOUNT)/MONTH_DAY AS A3,MONTH_DAY
	from FACT_STOCK_SMALL_MONTH 
	
	where CREATE_MONTH= '${CREATE_MONTH}'
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	AND substr(SMALL_CATE_CODE,0,2)<>'20'
	AND substr(SMALL_CATE_CODE,0,2)<>'21'
	AND substr(SMALL_CATE_CODE,0,2)<>'22'
	group by CREATE_MONTH,ORG_CODE,MONTH_DAY) A,DIM_S_SHOP B
	where BRAND_NAME_ALL= '${BRAND_NAME}' 
AND A.ORG_CODE = B.ORG_CODE 
	

