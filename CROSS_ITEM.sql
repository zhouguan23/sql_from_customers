select distinct 
  b.BRAND_NAME as BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 
-- 品牌维度

select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
-- 分公司维度

SELECT DISTINCT ATTRI_MANAGE_REGION,MANAGE_REGION_NAME FROM DIM_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
${if(len(sub_company_name)==0,""," AND SUB_COMPANY_NAME ='"+sub_company_name+"'")}
--  区域维度

select * from (
select distinct 
         c.REGULAR_CODE,
         c.REGULAR_CODE||c.REGULAR_NAME as REGULAR_NAME 
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_ITEM  c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      union 
      select distinct 
        d.REGULAR_CODE,
        concat(d.REGULAR_CODE,d.REGULAR_NAME) as REGULAR_NAME   
      from 
        FILL_USER_POST  a,
        FR_T_USER  b,
        DIM_SMALL_BUYER  c,
        DIM_ITEM  d
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
        d.REGULAR_CODE||d.REGULAR_NAME  REGULAR_NAME  
      from 
        FILL_USER_POST  a,
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
)  a where REGULAR_CODE in 
(
select distinct 
  REGULAR_CODE
from 
DIM_ITEM_INFO_ALL 
where BRAND_NAME='${brand}'
)
order by REGULAR_CODE

-- 规整类维度

select t.*,b.small_pic from (SELECT ITEM_ID,
  ITEM_CODE 货号,
  ITEM_NAME 名称,
  SALE_PRICE 零售价,
  FIRST_IN_DATE 首次到仓,
  LAST_IN_DATE 最近到仓,
  SUM(SHOP_NUM) 销售店铺数,
  SUM(ORGI_WEEK) 原价金额,
  SUM(TRANS_WEEK) 配送金额,
  SUM(SALE_WEEK) 本期销售金额,
  SUM(SALE_PER) SALE_PER,
  SUM(月库存金额) 月库存金额,
  SUM(店铺库存数) 店铺库存数,
  SUM(STOCK_PER) STOCK_PER
  FROM 
(
SELECT T1.ITEM_ID,T1.ITEM_CODE,T1.ITEM_NAME,T1.SALE_PRICE,T1.FIRST_IN_DATE,T1.LAST_IN_DATE,T2.SHOP_NUM, T1.ORGI_WEEK,T1.TRANS_WEEK,T1.SALE_WEEK,T1.SALE_PER,T1.月库存金额,T1.店铺库存数, T1.STOCK_PER
FROM 
(SELECT 
    A.ITEM_ID,
    B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ,
    SUM(A.REAL_AMOUNT)  SALE_WEEK,
    SUM(A.ORGI_AMOUNT)  ORGI_WEEK,
    SUM(A.TRANS_AMOUNT)  TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/
    (SELECT 
    SUM(A.REAL_AMOUNT)  SALE_WEEK   
  FROM FACT_CROSS_SALE_ITEM_REGION  A
  ,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  SALE_PER,
   0 月库存金额,
   0 店铺库存数,
   0 STOCK_PER
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  GROUP BY A.ITEM_ID,B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ) T1 LEFT JOIN
     (SELECT ITEM_ID,SUM(SHOP_NUM)  SHOP_NUM
    FROM DIM_CROSS_SHOP_NUMBER  a,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  b
    WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate})*7,'yyyy-mm-dd hh24:mi:ss')
    AND BRAND_NAME = '${brand}'
     AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    GROUP BY ITEM_ID) T2 ON  T1.ITEM_ID=T2.ITEM_ID
  union all
 SELECT 
     A.ITEM_ID,
  a.ITEM_CODE 货号,
  a.ITEM_NAME 名称,
  a.SALE_PRICE 零售价,
  a.FIRST_IN_DATE 首次到仓,
  a.LAST_IN_DATE 最近到仓,
  0 SHOP_NUM ,
  0 原价金额,
  0 配送金额,
  0 本期销售金额,
  0 SALE_PER,
    A.STOCK_MONTH,
    B.SHOP_NUMBER  店铺库存数 ,
    A.STOCK_PER
  FROM
    (select 
      A.ITEM_ID,
      B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE ,
      SUM(A.STOCK_AMOUNT)  STOCK_MONTH,
      SUM(A.STOCK_AMOUNT)/
      (select 
      SUM(A.STOCK_AMOUNT) AS STOCK_MONTH
    FROM FACT_STOCK_ITEM_REGION_WEEK  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
   )  c
    
    WHERE A.CREATE_DATE =to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  STOCK_PER
    FROM FACT_STOCK_ITEM_REGION_WEEK  A,DIM_ITEM_INFO_ALL  B
    WHERE A.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    GROUP BY A.ITEM_ID, B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE) A,
    -- 店铺数
    (SELECT 
      A.ITEM_ID,
      sum(A.SHOP_NUMBER)  SHOP_NUMBER
    FROM DIM_CROSS_STOCK_SHOP_NUMBER  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
    WHERE A.CREATE_MONTH = TO_CHAR(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'YYYY-MM')
    AND A.BRAND_NAME = '${brand}'
     AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    AND A.ITEM_ID=B.ITEM_ID
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    group by A.ITEM_ID  ) B
  WHERE
    A.ITEM_ID = B.ITEM_ID)
    GROUP BY ITEM_ID,
  ITEM_CODE ,
  ITEM_NAME ,
  SALE_PRICE ,
  FIRST_IN_DATE ,
  LAST_IN_DATE ) t,VBI_ITEM_INFO_PIC b where t.货号=b.item_code

SELECT WEEK_ALL,MIN(DAY_ID) AS DAY_ID
FROM DIM_DAY
group by WEEK_ALL
order by WEEK_ALL

-- 日期维度

select  min(DAY_ID) AS DAY_ID from DIM_DAY where WEEK_ALL=(
select WEEK_ALL from DIM_DAY where DAY_SHORT_DESC =trunc(sysdate)-7)

-- 由于日期维度做默认值

select t.*,b.small_pic from (SELECT ITEM_ID,
  ITEM_CODE 货号,
  ITEM_NAME 名称,
  SALE_PRICE 零售价,
  FIRST_IN_DATE 首次到仓,
  LAST_IN_DATE 最近到仓,
  SUM(SHOP_NUM) 销售店铺数,
  SUM(ORGI_WEEK) 原价金额,
  SUM(TRANS_WEEK) 配送金额,
  SUM(SALE_WEEK) 本期销售金额,
  SUM(SALE_PER) SALE_PER,
  SUM(月库存金额) 月库存金额,
  SUM(店铺库存数) 店铺库存数,
  SUM(STOCK_PER) STOCK_PER
  FROM 
(
SELECT T1.ITEM_ID,T1.ITEM_CODE,T1.ITEM_NAME,T1.SALE_PRICE,T1.FIRST_IN_DATE,T1.LAST_IN_DATE,T2.SHOP_NUM, T1.ORGI_WEEK,T1.TRANS_WEEK,T1.SALE_WEEK,T1.SALE_PER,T1.月库存金额,T1.店铺库存数, T1.STOCK_PER
FROM 
(SELECT 
    A.ITEM_ID,
    B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ,
    SUM(A.REAL_AMOUNT)  SALE_WEEK,
    SUM(A.ORGI_AMOUNT)  ORGI_WEEK,
    SUM(A.TRANS_AMOUNT)  TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/
    (SELECT 
    SUM(A.REAL_AMOUNT)  SALE_WEEK   
  FROM FACT_CROSS_SALE_ITEM_REGION  A
  ,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  SALE_PER,
   0 月库存金额,
   0 店铺库存数,
   0 STOCK_PER
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  GROUP BY A.ITEM_ID,B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ) T1 LEFT JOIN
     (SELECT ITEM_ID,SUM(SHOP_NUM)  SHOP_NUM
    FROM DIM_CROSS_SHOP_NUMBER  a,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  b
    WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate})*7,'yyyy-mm-dd hh24:mi:ss')
    AND BRAND_NAME = '${brand}'
     AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    GROUP BY ITEM_ID) T2 ON  T1.ITEM_ID=T2.ITEM_ID
  union all
 SELECT 
     A.ITEM_ID,
  a.ITEM_CODE 货号,
  a.ITEM_NAME 名称,
  a.SALE_PRICE 零售价,
  a.FIRST_IN_DATE 首次到仓,
  a.LAST_IN_DATE 最近到仓,
  0 SHOP_NUM ,
  0 原价金额,
  0 配送金额,
  0 本期销售金额,
  0 SALE_PER,
    A.STOCK_MONTH,
    B.SHOP_NUMBER  店铺库存数 ,
    A.STOCK_PER
  FROM
    (select 
      A.ITEM_ID,
      B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE ,
      SUM(A.STOCK_AMOUNT)  STOCK_MONTH,
      SUM(A.STOCK_AMOUNT)/
      (select 
      SUM(A.STOCK_AMOUNT) AS STOCK_MONTH
    FROM FACT_STOCK_ITEM_REGION_WEEK  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
   )  c
    
    WHERE A.CREATE_DATE =to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  STOCK_PER
    FROM FACT_STOCK_ITEM_REGION_WEEK  A,DIM_ITEM_INFO_ALL  B
    WHERE A.CREATE_DATE = to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    GROUP BY A.ITEM_ID, B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE) A,
    -- 店铺数
    (SELECT 
      A.ITEM_ID,
      sum(A.SHOP_NUMBER)  SHOP_NUMBER
    FROM DIM_CROSS_STOCK_SHOP_NUMBER  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
    WHERE A.CREATE_MONTH = TO_CHAR(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'YYYY-MM')
    AND A.BRAND_NAME = '${brand}'
     AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    AND A.ITEM_ID=B.ITEM_ID
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    group by A.ITEM_ID  ) B
  WHERE
    A.ITEM_ID = B.ITEM_ID)
    GROUP BY ITEM_ID,
  ITEM_CODE ,
  ITEM_NAME ,
  SALE_PRICE ,
  FIRST_IN_DATE ,
  LAST_IN_DATE ) t,VBI_ITEM_INFO_PIC b where t.货号=b.item_code

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY
-- 币种维度

WITH QX_C AS 
(select distinct A.SUB_COMPANY_NAME
            from FILL_USER_BRAND a, FR_T_USER b,DIM_S_SHOP c
                                           where a.USER_ID = to_char(b.id) and a.sub_company_name=c.sub_company_name 
                                             and b.username = '1104'  
                                           -- ${if(len(brand) == 0,  "", " AND c.BRAND_NAME ='" + brand + "'")
                                             )
SELECT
  C.ITEM_ID,
  C.ITEM_CODE 货号,
  C.ITEM_NAME 名称,
  C.SALE_PRICE 零售价,
  C.FIRST_IN_DATE 首次到仓,
  C.LAST_IN_DATE 最近到仓,
  C.SHOP_NUM 销售店铺数,
  D.ORGI_WEEK 原价金额,
  D.TRANS_WEEK 配送金额,
  D.SALE_WEEK 本期销售金额,
  D.SALE_PER,
  E.STOCK_MONTH 月库存金额,
     E.SHOP_NUMBER 店铺库存数,
     E.STOCK_PER
FROM
  -- 商品基本属性
  (SELECT 
    A.ITEM_ID,A.ITEM_CODE,A.ITEM_NAME,A.SALE_PRICE,A.FIRST_IN_DATE,A.LAST_IN_DATE,
    B.SHOP_NUM
  FROM (SELECT A.ITEM_ID,A.ITEM_CODE,A.ITEM_NAME,A.SALE_PRICE,A.FIRST_IN_DATE,A.LAST_IN_DATE
    from DIM_ITEM_INFO_ALL A,
    -- 库存店铺数
   
    (SELECT A.ITEM_ID
      FROM DIM_CROSS_STOCK_SHOP_NUMBER  a,  QX_C  b
      WHERE (CREATE_MONTH <= to_char(to_date('2010-12-26','yyyy-mm-dd')+340*7,'yyyy-mm')
     AND 
    CREATE_MONTH >= to_char(to_date('2010-12-26','yyyy-mm-dd')+(340-3)*7,'yyyy-mm') )
     AND BRAND_NAME = '${brand}'     
/*     AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,"","AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
      ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}*/
      and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
      
    -- 销售店铺数
     UNION 
     SELECT A.ITEM_ID
      FROM DIM_CROSS_SHOP_NUMBER  a, QX_C  b
      WHERE  (CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+340*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(340-1)*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE =to_char(to_date('2010-12-26','yyyy-mm-dd')+(340-2)*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(340-3)*7,'yyyy-mm-dd hh24:mi:ss')
    )
      AND BRAND_NAME = '${brand}'
/*       AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
      and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
      ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}*/
      ) B
    
     where 
     --(CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")}) 
     1=1 AND A.ITEM_ID=B.ITEM_ID
  --  ${if(len(regular_code)==0,""," AND REGULAR_CODE in ('"+regular_code+"')")}
    
   )A left join
    (SELECT ITEM_ID,SUM(SHOP_NUM)  SHOP_NUM
    FROM DIM_CROSS_SHOP_NUMBER  a,QX_C  b
    WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(340)*7,'yyyy-mm-dd hh24:mi:ss')
  --  AND BRAND_NAME = '${brand}'
  --   AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
 --   ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
--    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    GROUP BY ITEM_ID) B
  on  A.ITEM_ID = B.ITEM_ID
  ) C left join
  -- 商品本期总原价、配送、销售金额
  (SELECT 
    A.ITEM_ID,
    SUM(A.REAL_AMOUNT)  SALE_WEEK,
    SUM(A.ORGI_AMOUNT)  ORGI_WEEK,
    SUM(A.TRANS_AMOUNT)  TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/
    (SELECT 
    SUM(A.REAL_AMOUNT)  SALE_WEEK   
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B,
QX_C  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  /*AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})*/
 /* ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}*/
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
 -- ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  )  SALE_PER
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= 340-3
  and A.WEEK_ALL <=340
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=TO_CHAR(B.ITEM_ID)
/*  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}*/
  GROUP BY A.ITEM_ID) D on C.ITEM_ID = D.ITEM_ID
  left join
  (SELECT 
    A.ITEM_ID,
    A.STOCK_MONTH,
    A.STOCK_PER,
    B.SHOP_NUMBER
  FROM
    (select 
      A.ITEM_ID,
      SUM(A.STOCK_AMOUNT)  STOCK_MONTH,
      SUM(A.STOCK_AMOUNT)/
      (select 
      SUM(A.STOCK_AMOUNT) AS STOCK_MONTH
    FROM FACT_STOCK_ITEM_REGION_MONTH  A,DIM_ITEM_INFO_ALL  B,
QX_C  c
    
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+340*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
   /* AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}*/
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
   /* ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}*/)  STOCK_PER
    FROM FACT_STOCK_ITEM_REGION_MONTH  A,DIM_ITEM_INFO_ALL  B
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+340*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
   /* AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}*/
    GROUP BY A.ITEM_ID) A,
    -- 店铺数
    (SELECT 
      A.ITEM_ID,
      sum(A.SHOP_NUMBER)  SHOP_NUMBER
    FROM DIM_CROSS_STOCK_SHOP_NUMBER  A,DIM_ITEM_INFO_ALL  B,
QX_C  c
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+340*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
   /*  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}*/
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    AND A.ITEM_ID=B.ITEM_ID
 --   ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    group by A.ITEM_ID) B
  WHERE
    A.ITEM_ID = B.ITEM_ID
  )  E on C.ITEM_ID=E.ITEM_ID
  order by E.STOCK_MONTH  desc

select distinct c.ATTRI_MANAGE_REGION,c.MANAGE_REGION_NAME from FILL_USER_POST as a,
finedb.FR_T_USER as b,DIM_S_SHOP as c
where b.ID=a.USER_ID and b.username='${fr_username}'
${if(len(sub_company_name)=0,"","AND c.SUB_COMPANY_NAME IN ('"+sub_company_name+"')")}
AND c.BRAND_NAME = '${brand}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct c.ATTRI_MANAGE_REGION,c.MANAGE_REGION_NAME from FILL_USER_POST as a,
finedb.FR_T_USER as b,DIM_S_SHOP as c
where b.ID=a.USER_ID and b.username='${fr_username}' 
${if(len(sub_company_name)=0,"","AND c.SUB_COMPANY_NAME IN ('"+sub_company_name+"')")}
and b.ID=c.DOMAIN
AND c.BRAND_NAME = '${brand}' and a.POST in('督导')
union 
select distinct c.ATTRI_MANAGE_REGION,c.MANAGE_REGION_NAME from FILL_USER_POST as a,
finedb.FR_T_USER as b,DIM_S_SHOP as c
where b.ID=a.USER_ID and b.username='${fr_username}' 
${if(len(sub_company_name)=0,"","AND c.SUB_COMPANY_NAME IN ('"+sub_company_name+"')")}
and b.ID=c.AD
AND c.BRAND_NAME = '${brand}' and a.POST in('城市经理')

--  区域维度

SELECT
	SMALL_PIC 
FROM
	VBI_ITEM_INFO_PIC 
WHERE
	ITEM_CODE = '${ITEM_CODE}'

SELECT 
    A.ITEM_ID,
    B.ITEM_CODE 货号,
    B.ITEM_NAME 名称,
    B.SALE_PRICE 零售价,
    B.FIRST_IN_DATE 首次到仓,
    B.LAST_IN_DATE 最近到仓,
    SUM(A.REAL_AMOUNT)  SALE_WEEK,
    SUM(A.ORGI_AMOUNT)  ORGI_WEEK,
    SUM(A.TRANS_AMOUNT)  TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/
    (SELECT 
    SUM(A.REAL_AMOUNT)  SALE_WEEK   
  FROM FACT_CROSS_SALE_ITEM_REGION  A
  ,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  SALE_PER
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  GROUP BY A.ITEM_ID,B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE 

SELECT ITEM_ID,
  ITEM_CODE 货号,
  ITEM_NAME 名称,
  SALE_PRICE 零售价,
  FIRST_IN_DATE 首次到仓,
  LAST_IN_DATE 最近到仓,
  SUM(SHOP_NUM) 销售店铺数,
  SUM(ORGI_WEEK) 原价金额,
  SUM(TRANS_WEEK) 配送金额,
  SUM(SALE_WEEK) 本期销售金额,
  SUM(SALE_PER) SALE_PER,
  SUM(月库存金额) 月库存金额,
  SUM(店铺库存数) 店铺库存数,
  SUM(STOCK_PER) STOCK_PER
  FROM 
(
SELECT T1.ITEM_ID,ITEM_CODE,ITEM_NAME,SALE_PRICE,FIRST_IN_DATE,LAST_IN_DATE,T2.SHOP_NUM, SALE_WEEK,ORGI_WEEK,TRANS_WEEK,SALE_PER,月库存金额,店铺库存数, STOCK_PER
FROM 
(SELECT 
    A.ITEM_ID,
    B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ,
    SUM(A.REAL_AMOUNT)  SALE_WEEK,
    SUM(A.ORGI_AMOUNT)  ORGI_WEEK,
    SUM(A.TRANS_AMOUNT)  TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/
    (SELECT 
    SUM(A.REAL_AMOUNT)  SALE_WEEK   
  FROM FACT_CROSS_SALE_ITEM_REGION  A
  ,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  SALE_PER,
   0 月库存金额,
   0 店铺库存数,
   0 STOCK_PER
  FROM FACT_CROSS_SALE_ITEM_REGION  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
      ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  GROUP BY A.ITEM_ID,B.ITEM_CODE ,
    B.ITEM_NAME ,
    B.SALE_PRICE ,
    B.FIRST_IN_DATE ,
    B.LAST_IN_DATE ) T1 LEFT JOIN
     (SELECT ITEM_ID,SUM(SHOP_NUM)  SHOP_NUM
    FROM DIM_CROSS_SHOP_NUMBER  a,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  b
    WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate})*7,'yyyy-mm-dd hh24:mi:ss')
    AND BRAND_NAME = '${brand}'
     AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    GROUP BY ITEM_ID) T2 ON  T1.ITEM_ID=T2.ITEM_ID
  union all
 SELECT 
     A.ITEM_ID,
  a.ITEM_CODE 货号,
  a.ITEM_NAME 名称,
  a.SALE_PRICE 零售价,
  a.FIRST_IN_DATE 首次到仓,
  a.LAST_IN_DATE 最近到仓,
  0 SHOP_NUM ,
  0 原价金额,
  0 配送金额,
  0 本期销售金额,
  0 SALE_PER,
    A.STOCK_MONTH,
    A.STOCK_PER,
    B.SHOP_NUMBER
  FROM
    (select 
      A.ITEM_ID,
      B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE ,
      SUM(A.STOCK_AMOUNT)  STOCK_MONTH,
      SUM(A.STOCK_AMOUNT)/
      (select 
      SUM(A.STOCK_AMOUNT) AS STOCK_MONTH
    FROM FACT_STOCK_ITEM_REGION_MONTH  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
   )  c
    
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")})  STOCK_PER
    FROM FACT_STOCK_ITEM_REGION_MONTH  A,DIM_ITEM_INFO_ALL  B
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
    AND A.ITEM_ID=B.ITEM_ID
    AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    GROUP BY A.ITEM_ID, B.ITEM_CODE ,
  B.ITEM_NAME ,
  B.SALE_PRICE ,
  B.FIRST_IN_DATE ,
  B.LAST_IN_DATE) A,
    -- 店铺数
    (SELECT 
      A.ITEM_ID,
      sum(A.SHOP_NUMBER)  SHOP_NUMBER
    FROM DIM_CROSS_STOCK_SHOP_NUMBER  A,DIM_ITEM_INFO_ALL  B,
        (
  select DISTINCT 
  c.SUB_COMPANY_NAME 
from DIM_S_SHOP c,FILL_USER_BRAND  a,FR_T_USER  b
WHERE 1=1
${if(len(brand)==0,""," AND c.BRAND_NAME ='"+brand+"'")}
and a.USER_ID=to_char(b.id) and b.username='${fr_username}'
and c.SUB_COMPANY_NAME = a.SUB_COMPANY_NAME 
  )  c
    WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
    AND A.BRAND_NAME = '${brand}'
     AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
    AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
    and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
    AND A.ITEM_ID=B.ITEM_ID
    ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
    group by A.ITEM_ID  ) B
  WHERE
    A.ITEM_ID = B.ITEM_ID)
    GROUP BY ITEM_ID,
  ITEM_CODE ,
  ITEM_NAME ,
  SALE_PRICE ,
  FIRST_IN_DATE ,
  LAST_IN_DATE 

SELECT
  C.ITEM_ID,
  C.ITEM_CODE 货号,
  C.ITEM_NAME 名称,
  C.SALE_PRICE 零售价,
  C.FIRST_IN_DATE 首次到仓,
  C.LAST_IN_DATE 最近到仓,
  C.SHOP_NUM 销售店铺数,
  D.ORGI_WEEK 原价金额,
  D.TRANS_WEEK 配送金额,
  D.SALE_WEEK 本期销售金额,
  D.SALE_PER,
   E.STOCK_MONTH 月库存金额,
      E.SHOP_NUMBER 店铺库存数,
      E.STOCK_PER
FROM
  -- 商品基本属性，销售店铺数
  (SELECT 
    A.ITEM_ID,A.ITEM_CODE,A.ITEM_NAME,A.SALE_PRICE,A.FIRST_IN_DATE,A.LAST_IN_DATE,
    B.SHOP_NUM
  FROM (select * from DIM_ITEM_INFO_ALL 
  WHERE (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
  AND (ITEM_ID in(SELECT ITEM_ID
    FROM DIM_CROSS_STOCK_SHOP_NUMBER  a,
        (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  b
    WHERE (CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
    or 
    CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-1)*7,'yyyy-mm')
    or 
    CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-2)*7,'yyyy-mm')
    or 
    CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-3)*7,'yyyy-mm')
    )
    AND BRAND_NAME = '${brand}'
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    ${IF(LEN(sub_company_name)=0,"","AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")})
  or ITEM_ID in(SELECT ITEM_ID
    FROM DIM_CROSS_SHOP_NUMBER  a,
        (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  b
    WHERE 
    (CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-1)*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-2)*7,'yyyy-mm-dd hh24:mi:ss')
    or 
    CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+(${ddate}-3)*7,'yyyy-mm-dd hh24:mi:ss')
    )
    AND BRAND_NAME = '${brand}'
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")})
  
  )

  ${if(len(regular_code)==0,""," AND REGULAR_CODE in ('"+regular_code+"')")}) A left join
    (SELECT ITEM_ID,SUM(SHOP_NUM)  SHOP_NUM
    FROM DIM_CROSS_SHOP_NUMBER  a,
        (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  b
    WHERE CREATE_DATE = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm-dd hh24:mi:ss')
    AND BRAND_NAME = '${brand}'
    AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
    ${IF(LEN(sub_company_name)=0,""," AND a.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
    ${IF(LEN(area)=0,""," AND ATTRI_MANAGE_REGION = '"+area+"'")}
    and a.SUB_COMPANY_NAME=b.SUB_COMPANY_NAME
    GROUP BY ITEM_ID) B
  on  A.ITEM_ID = B.ITEM_ID
  ) C
  -- 商品本期总原价、配送、销售金额
  left join
  (SELECT 
    A.ITEM_ID,
    SUM(A.REAL_AMOUNT) AS SALE_WEEK,
    SUM(A.ORGI_AMOUNT) AS ORGI_WEEK,
    SUM(A.TRANS_AMOUNT) AS TRANS_WEEK,
    SUM(A.REAL_AMOUNT)/(SELECT 
    SUM(A.REAL_AMOUNT) AS SALE_WEEK
  FROM FACT_CROSS_SALE_ITEM_SUB  A,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  c
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL<='${ddate}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  AND A.BRAND_NAME = '${brand}'
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")})
   SALE_PER
  FROM FACT_CROSS_SALE_ITEM_SUB  A,DIM_ITEM_INFO_ALL  B
  WHERE A.WEEK_ALL >= '${ddate}'-3
  and A.WEEK_ALL <= '${ddate}'
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,""," AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  GROUP BY A.ITEM_ID) D
on C.ITEM_ID = D.ITEM_ID
left join
(
SELECT 
  A.ITEM_ID,
  A.STOCK_MONTH,
  A.STOCK_PER,
  B.SHOP_NUMBER
FROM
  (select 
    A.ITEM_ID,
    SUM(A.STOCK_AMOUNT)  STOCK_MONTH,
    SUM(A.STOCK_AMOUNT)/(select 
    SUM(A.STOCK_AMOUNT)  STOCK_MONTH
  FROM FACT_STOCK_ITEM_SUB_MONTH  A,DIM_ITEM_INFO_ALL B,
      (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  c
  WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  AND A.BRAND_NAME = '${brand}'
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")})
   STOCK_PER
  FROM FACT_STOCK_ITEM_SUB_MONTH  A,DIM_ITEM_INFO_ALL  B
  WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
  AND A.BRAND_NAME = '${brand}'
  AND A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  GROUP BY A.ITEM_ID) A,
  (SELECT 
    A.ITEM_ID,
    sum(A.SHOP_NUMBER)  SHOP_NUMBER
  FROM DIM_CROSS_STOCK_SHOP_NUMBER  A,DIM_ITEM_INFO_ALL  B,
      (
  select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
  )  c
  WHERE A.CREATE_MONTH = to_char(to_date('2010-12-26','yyyy-mm-dd')+${ddate}*7,'yyyy-mm')
  AND A.BRAND_NAME = '${brand}'
  and A.ITEM_ID=B.ITEM_ID
  AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
  AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
  ${if(len(regular_code)==0,""," AND B.REGULAR_CODE in ('"+regular_code+"')")}
  ${IF(LEN(sub_company_name)=0,"","AND A.SUB_COMPANY_NAME = '"+sub_company_name+"'")}
  and A.SUB_COMPANY_NAME=c.SUB_COMPANY_NAME
  ${IF(LEN(area)=0,""," AND A.ATTRI_MANAGE_REGION = '"+area+"'")}
  group by A.ITEM_ID) B
WHERE
  A.ITEM_ID = B.ITEM_ID
)  E
on C.ITEM_ID=E.ITEM_ID
  order by E.STOCK_MONTH desc

