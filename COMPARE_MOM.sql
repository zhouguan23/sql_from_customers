SELECT
  a.CREATE_MONTH,           -- 月
  SUM(a.REAL_AMOUNT) REAL_AMOUNT     -- 销售额  
FROM
  FACT_SALE_REGULAR_MONTH  a,
  DIM_SHOP  b
  

WHERE
  a.ORG_CODE = b.ORG_CODE 
AND b.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and b.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND b.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND b.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=concat('${year}','-01') and CREATE_MONTH<=concat('${year}','-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and b.BRAND_NAME=c.BRAND_NAME
--AND b.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and b.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
	a.CREATE_MONTH,
	SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
	FACT_SALE_REGULAR_MONTH a,
	DIM_SHOP b
	

WHERE
	a.ORG_CODE = b.ORG_CODE 
AND b.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and b.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND b.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND b.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=('${year}'-1||'-01') and CREATE_MONTH<=('${year}'-1||'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and b.BRAND_NAME=c.BRAND_NAME
--AND b.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and b.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

select distinct b.BRAND_NAME as BRAND_NAME from (
select BRAND_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) 
${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 

select * from (
select distinct 
         c.REGULAR_CODE,
         c.REGULAR_CODE||c.REGULAR_NAME REGULAR_NAME 
      from 
        FILL_USER_POST  a,
        FR_T_USER b,
        DIM_ITEM  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      union 
      select distinct 
        d.REGULAR_CODE,
        d.REGULAR_CODE||d.REGULAR_NAME REGULAR_NAME   
      from 
        FILL_USER_POST a,
        FR_T_USER b,
        DIM_SMALL_BUYER c,
        DIM_ITEM d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
 
      union 
      select distinct 
        d.REGULAR_CODE,
        (d.REGULAR_CODE||d.REGULAR_NAME) REGULAR_NAME  
      from 
        FILL_USER_POST a,
         FR_T_USER  b,
        DIM_SMALL_BUYER  c,
        DIM_ITEM  d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST ='商品AD'
      and c.STAFF_POSITION ='商品AD'
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
) a where REGULAR_CODE in 
(
select distinct 
  REGULAR_CODE
from 
DIM_ITEM_INFO_ALL 
where BRAND_NAME='${BRAND_NAME}'
)

order by REGULAR_CODE

-- 规整类维度

select DISTINCT SUB_COMPANY_NAME from DIM_S_SHOP 
WHERE 1=1
${if(len(BRAND_NAME)==0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
and SUB_COMPANY_NAME in (select SUB_COMPANY_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) and b.username='${fr_username}')

select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union  
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')


select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
${IF(LEN(MANAGE_REGION_NAME)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+MANAGE_REGION_NAME+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
${IF(LEN(MANAGE_REGION_NAME)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+MANAGE_REGION_NAME+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union  
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'
${IF(LEN(MANAGE_REGION_NAME)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+MANAGE_REGION_NAME+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')

SELECT '01'  from dual
UNION
SELECT '02'  from dual
UNION
SELECT '03'  from dual
UNION
SELECT '04'  from dual
UNION
SELECT '05'  from dual
UNION
SELECT '06'  from dual
UNION
SELECT '07'  from dual
UNION
SELECT '08'  from dual
UNION
SELECT '09'  from dual
UNION
SELECT '10'   from dual
UNION
SELECT '11'  from dual
UNION
SELECT '12'  from dual

SELECT
  a.CREATE_MONTH,
  SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM  FACT_SALE_REGULAR_MONTH a,
  DIM_SHOP  b
  

WHERE
  a.ORG_CODE = b.ORG_CODE 
AND b.BRAND_NAME =  '${BRAND_NAME}'
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
${if(len(SUB_COMPANY_NAME)==0,"","and b.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND b.ORG_NAME in ('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND b.ATTRI_MANAGE_REGION in( '"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=concat('${year}'-2,'-01') and CREATE_MONTH<=concat('${year}'-2,'-12')
--and b.BRAND_NAME=c.BRAND_NAME
--AND b.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and b.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
	a.CREATE_MONTH,
	SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
	 FACT_SALE_REGULAR_MONTH a,
	 DIM_SHOP b
	
WHERE
  a.ORG_CODE = b.ORG_CODE 
AND b.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and b.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND b.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND b.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in ( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=(${year}-3||'-01') and CREATE_MONTH<=(${year}-3||'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and b.BRAND_NAME=c.BRAND_NAME
--AND b.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and b.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT              -- 年月日
COUNT(DISTINCT A.ORG_CODE) NUM,      -- 店铺数
A.CREATE_MONTH M,        -- 月
substr(A.CREATE_MONTH,6,2) D        -- 日
FROM 
FACT_SALE_REGULAR_MONTH A 
WHERE 
A.ORG_CODE in (select  B.ORG_CODE from DIM_SHOP B,
  (
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) c
where  B.BRAND_NAME =  '${BRAND_NAME}'
and B.BRAND_NAME=c.BRAND_NAME
AND B.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")})
and A.CREATE_MONTH>=('${year}'||'-01') and A.CREATE_MONTH<=('${year}'||'-12')
${if(len(REGULAR_CODE)==0,"","AND A.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY A.CREATE_MONTH

SELECT              -- 年月日
COUNT(DISTINCT A.ORG_CODE) NUM,      -- 店铺数
A.CREATE_MONTH M,        -- 月
substr(A.CREATE_MONTH,6,2) D        -- 日
FROM 
FACT_SALE_REGULAR_MONTH A 
WHERE 
A.ORG_CODE in (select  B.ORG_CODE from DIM_SHOP B,
  (
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) c
where  B.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
and B.BRAND_NAME=c.BRAND_NAME
AND B.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")})
and A.CREATE_MONTH>=('${year}'-1||'-01') and A.CREATE_MONTH<=('${year}'-1||'-12')
${if(len(REGULAR_CODE)==0,"","AND A.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY A.CREATE_MONTH

SELECT              -- 年月日
COUNT(DISTINCT A.ORG_CODE) NUM,      -- 店铺数
A.CREATE_MONTH M,        -- 月
substr(A.CREATE_MONTH,6,2) D        -- 日
FROM 
FACT_SALE_REGULAR_MONTH A 
WHERE 
A.ORG_CODE in (select  B.ORG_CODE from DIM_SHOP B,
  (
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) c
where  B.BRAND_NAME =  '${BRAND_NAME}'
and B.BRAND_NAME=c.BRAND_NAME
AND B.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")})
and A.CREATE_MONTH>=concat('${year}'-2,'-01') and A.CREATE_MONTH<=concat('${year}'-2,'-12')
${if(len(REGULAR_CODE)==0,"","AND A.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY A.CREATE_MONTH

SELECT              -- 年月日
COUNT(DISTINCT A.ORG_CODE) NUM,      -- 店铺数
A.CREATE_MONTH M,        -- 月
substr(A.CREATE_MONTH,6,2) D        -- 日
FROM 
FACT_SALE_REGULAR_MONTH A 
WHERE 
A.ORG_CODE in (select  B.ORG_CODE from DIM_SHOP B,
  (
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) c
where  B.BRAND_NAME =  '${BRAND_NAME}'
and B.BRAND_NAME=c.BRAND_NAME
AND B.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")})
and A.CREATE_MONTH>=concat('${year}'-3,'-01') and A.CREATE_MONTH<=concat('${year}'-3,'-12')
${if(len(REGULAR_CODE)==0,"","AND A.REGULAR_CODE in ('"+REGULAR_CODE+"')")}
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
GROUP BY A.CREATE_MONTH

SELECT
	a.CREATE_MONTH,
	SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
	FACT_S_SALE_REGULAR_REGION_M a
		

WHERE
 a.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and a.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND a.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=('${year}'||'-01') and CREATE_MONTH<=('${year}'||'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and a.BRAND_NAME=c.BRAND_NAME
--AND a.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and a.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
	a.CREATE_MONTH,
	SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
	FACT_S_SALE_REGULAR_REGION_M a
		
WHERE
 a.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and a.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND a.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=('${year}'-1||'-01') and CREATE_MONTH<=('${year}'-1||'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
-- and a.BRAND_NAME=c.BRAND_NAME
--AND a.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and a.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
  a.CREATE_MONTH,
  SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
  FACT_S_SALE_REGULAR_REGION_M a
    
WHERE
   a.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and a.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND a.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=concat('${year}'-2,'-01') and CREATE_MONTH<=concat('${year}'-2,'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and a.BRAND_NAME=c.BRAND_NAME
--AND a.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and a.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
	a.CREATE_MONTH,
	SUM(a.REAL_AMOUNT) REAL_AMOUNT
FROM
	 FACT_S_SALE_REGULAR_REGION_M a
	
WHERE
  a.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and a.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND a.ATTRI_MANAGE_REGION in ('"+MANAGE_REGION_NAME+"')")}
${if(len(REGULAR_CODE)==0,"","AND a.REGULAR_CODE in( '"+REGULAR_CODE+"')")}
and CREATE_MONTH>=('${year}'-3||'-01') and CREATE_MONTH<=('${year}'-3||'-12')
AND (CURRENCY = '${currency}'
 ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
--and a.BRAND_NAME=c.BRAND_NAME
--AND a.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
--and a.ATTRI_MANAGE_REGION=c.ATTRI_MANAGE_REGION
GROUP BY CREATE_MONTH

SELECT
	--A.CREATE_DATE,
	COUNT( DISTINCT A.ORG_CODE ) NUM,
	substr ( A.CREATE_DATE, 1,7 ) M,
	substr ( A.CREATE_DATE, 6,2 ) D 
FROM
	DIM_SHOP_DAY_ALL A,
	DIM_SHOP B,
	VBI_ORG_INFO C,
	VBI_CURRENCY_INFO D,
	(
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) E
WHERE A.ORG_CODE = B.ORG_CODE and B.ORG_ID=C.ORG_ID
and C.CURRENCY_ID=D.CURRENCY_ID
AND B.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
and substr(A.CREATE_DATE,9,2) = '01'
and A.CREATE_DATE>=('${year}'||'-01'||'-01') and A.CREATE_DATE<=('${year}'||'-12'||'-01') and D.CURRENCY_NAME='${currency}'
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
and B.BRAND_NAME=E.BRAND_NAME
AND B.SUB_COMPANY_NAME=E.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=E.ATTRI_MANAGE_REGION

GROUP BY 	substr ( A.CREATE_DATE, 1,7 ),substr ( A.CREATE_DATE, 6,2 )

SELECT
--	A.CREATE_DATE,
	COUNT( DISTINCT A.ORG_CODE ) NUM,
	substr ( A.CREATE_DATE, 1,7 ) M,
	substr ( A.CREATE_DATE, 6,2 ) D 
FROM
	DIM_SHOP_DAY_ALL A,
	DIM_SHOP B,
	VBI_ORG_INFO C,
	VBI_CURRENCY_INFO D,
		(
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) E
WHERE A.ORG_CODE = B.ORG_CODE 
and B.ORG_ID=C.ORG_ID
and C.CURRENCY_ID=D.CURRENCY_ID
and D.CURRENCY_NAME='${currency}'
AND B.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION = '"+MANAGE_REGION_NAME+"'")}
and substr(A.CREATE_DATE,9,2) = '01'
and A.CREATE_DATE>=('${year}'-1||'-01'||'-01') and A.CREATE_DATE<=('${year}'-1||'-12'||'-01')
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
and B.BRAND_NAME=E.BRAND_NAME
AND B.SUB_COMPANY_NAME=E.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=E.ATTRI_MANAGE_REGION
GROUP BY 	substr ( A.CREATE_DATE, 1,7 ) ,
	substr ( A.CREATE_DATE, 6,2 )

SELECT
 -- A.CREATE_DATE,
  COUNT( DISTINCT A.ORG_CODE ) NUM,
  substr ( A.CREATE_DATE, 1,7 ) M,
  substr ( A.CREATE_DATE, 6,2 ) D 
FROM
  DIM_SHOP_DAY_ALL A,
  DIM_SHOP B,
  VBI_ORG_INFO C,
  VBI_CURRENCY_INFO D,
    (
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) E
WHERE A.ORG_CODE = B.ORG_CODE
and B.ORG_ID=C.ORG_ID
and C.CURRENCY_ID=D.CURRENCY_ID
and D.CURRENCY_NAME='${currency}'
AND B.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
and substr(A.CREATE_DATE,9,2) = '01' 
and A.CREATE_DATE>=('${year}'-2||'-01'||'-01') and A.CREATE_DATE<=('${year}'-2||'-12'||'-01')
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
and B.BRAND_NAME=E.BRAND_NAME
AND B.SUB_COMPANY_NAME=E.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=E.ATTRI_MANAGE_REGION
GROUP BY   substr ( A.CREATE_DATE, 1,7 ) ,
  substr ( A.CREATE_DATE, 6,2 ) 

SELECT
	--A.CREATE_DATE,
	COUNT( DISTINCT A.ORG_CODE ) NUM,
	substr ( A.CREATE_DATE,1, 7 ) M,
	substr ( A.CREATE_DATE, 6,2 ) D 
FROM
	DIM_SHOP_DAY_ALL A,
	DIM_SHOP B,
	VBI_ORG_INFO C,
	VBI_CURRENCY_INFO D,
		(
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) E
WHERE A.ORG_CODE = B.ORG_CODE
and B.ORG_ID=C.ORG_ID
and C.CURRENCY_ID=D.CURRENCY_ID
and D.CURRENCY_NAME='${currency}'
AND B.BRAND_NAME =  '${BRAND_NAME}'
${if(len(SUB_COMPANY_NAME)==0,"","and B.SUB_COMPANY_NAME in ('"+SUB_COMPANY_NAME+"')")}
${if(len(MANAGE_REGION_NAME)==0,"","AND B.ATTRI_MANAGE_REGION in('"+MANAGE_REGION_NAME+"')")}
and substr(A.CREATE_DATE,7,2) = '01'
and A.CREATE_DATE>=('${year}'-3||'-01'||'-01') and A.CREATE_DATE<=('${year}'-3||'-12'||'-01')
${if(len(ORG_NAME)==0,"","AND B.ORG_NAME in('"+ORG_NAME+"')")}
and B.BRAND_NAME=E.BRAND_NAME
AND B.SUB_COMPANY_NAME=E.SUB_COMPANY_NAME
and B.ATTRI_MANAGE_REGION=E.ATTRI_MANAGE_REGION
GROUP BY 	substr ( A.CREATE_DATE,1, 7 ) ,
	substr ( A.CREATE_DATE, 6,2 ) 

SELECT * FROM `VBI_CURRENCY`

SELECT * FROM `FACT_SALE_REGULAR_MONTH` where REGULAR_CODE="89" AND CREATE_MONTH="2019-02"

(
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct BRAND_NAME,SUB_COMPANY_NAME,ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST a,
FR_T_USER b,DIM_S_SHOP c
where to_char(b.id)=a.USER_ID and b.username='${fr_username}'

and to_char(b.id)=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')
) c

