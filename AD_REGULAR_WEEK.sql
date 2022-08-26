select distinct b.BRAND_NAME as BRAND_NAME from (
select BRAND_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=TO_CHAR(b.id) 
${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND b
where a.BRAND_NAME=b.BRAND_NAME 

select 
  a.REGULAR_CODE,
  a.REGULAR_NAME,
  a.BRAND_NAME,
  a.MANAGE_REGION_NAME,
  a.SUB_COMPANY_NAME,
  a.ORG_DOMAIN_NAME,
  a.ORG_CODE,
  a.ORG_NAME,
  a.REGULAR_CODE || a.ORG_CODE AS PK,
  NVL(b.REAL_AMOUNT,0) AS REAL_AMOUNT,
  --b.REAL_AMOUNT,
  b.ORGI_AMOUNT,
  f.TRANS_QTY,
  f.TRANS_AMOUNT,
  b.REAL_PRICE,
  b.REAL_QTY,
  b.SHOP_REAL_AMOUNT,
  c.STOCK_QTY,
  c.STOCK_AMOUNT,
  c.STOCK_PRICE,
 decode(b.ORGI_AMOUNT,0,'', c.STOCK_AMOUNT/b.ORGI_AMOUNT) as CYCLE,
  d.REAL_QTY as ON_QTY,
  d.VALID_AMOUNT,
  e.REAL_AMOUNT as LAST_WEEK_REAL_AMOUNT,
  e.REAL_QTY as LAST_WEEK_REAL_QTY,
  e.SHOP_REAL_AMOUNT as LAST_WEEK_SHOP_REAL_AMOUNT
from 
  (
  select 
    c.REGULAR_CODE,
    c.REGULAR_NAME,
    b.BRAND_NAME,
    b.MANAGE_REGION_NAME,
    b.SUB_COMPANY_NAME,
    b.ORG_DOMAIN_NAME,
    b.ORG_CODE,
    b.ORG_NAME
  from 
    FACT_SALE_REGULAR_WEEK  a,
    DIM_SHOP  b,
    FACT_S_SALE_SHOP_WEEK  e,
    VBI_REGULAR_CATE  c,
    (
    select 
      distinct c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in(select POST FROM FILL_POST)
    union 
    select 
      distinct c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.DOMAIN
      and  a.POST in('督导')
    union 
    select 
      distinct c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.AD
      and  a.POST in('城市经理')
    ) f
  where
    a.WEEK_ALL='${WEEK_ALL}' 
    and e.WEEK_ALL=a.WEEK_ALL
    AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
    AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
    ${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
    ${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
    ${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
    ${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
    ${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
    and a.REGULAR_CODE=c.REGULAR_CODE 
    and a.ORG_CODE=b.ORG_CODE
    and a.ORG_CODE=e.ORG_CODE
    and a.ORG_CODE=f.ORG_CODE
  union 
  select 
    c.REGULAR_CODE,
    c.REGULAR_NAME,
    b.BRAND_NAME,
    b.MANAGE_REGION_NAME,
    b.SUB_COMPANY_NAME,
    b.ORG_DOMAIN_NAME,
    b.ORG_CODE,
    b.ORG_NAME
  from 
    FACT_STOCK_REGULAR  a,
    DIM_SHOP  b,
    VBI_REGULAR_CATE  c,
    (
    select 
      distinct c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in(select POST FROM FILL_POST)
    union 
    select 
      distinct c.ORG_CODE 
    from 
      FILL_USER_POST  a,
      FR_T_USER  b,
      DIM_S_SHOP  c
    where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and b.ID=c.DOMAIN
      and  a.POST in('督导')
    union 
    select 
      distinct c.ORG_CODE 
    from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.AD
           and  a.POST in('城市经理')
    ) f

 where a.CREATE_DATE=to_date('2010-12-26','yyyy-mm-dd') + ${WEEK_ALL}*7
 and a.ORG_CODE=b.ORG_CODE
 and a.ORG_CODE=f.ORG_CODE
and a.REGULAR_CODE=c.REGULAR_CODE
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
union 
select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_ON_PASSAGE_ITEM  a,DIM_SHOP  b,DIM_ITEM_INFO_ALL  c,
 (
    select distinct c.ORG_CODE from FILL_USER_POST  a,
           FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and a.POST in(select POST FROM FILL_POST)
          union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.DOMAIN
           and  a.POST in('督导')
           union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.AD
           and  a.POST in('城市经理')
    ) f

where a.CREATE_DATE=to_char(to_date('2010-12-26','yyyy-mm-dd') + ${WEEK_ALL}*7,'yyyy-mm-dd')
and a.ITEM_ID=c.ITEM_ID and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=f.ORG_CODE
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
union 
select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c,
(
    select distinct c.ORG_CODE from FILL_USER_POST  a,
           FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and a.POST in(select POST FROM FILL_POST)
          union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.DOMAIN
           and  a.POST in('督导')
           union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.AD
           and  a.POST in('城市经理')
    ) f
 where a.WEEK_ALL='${WEEK_ALL}'-52 
 and e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE
and a.ORG_CODE=f.ORG_CODE
union
select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c,
(
    select distinct c.ORG_CODE from FILL_USER_POST  a,
           FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and a.POST in(select POST FROM FILL_POST)
          union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.DOMAIN
           and  a.POST in('督导')
           union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.AD
           and  a.POST in('城市经理')
    ) f
 where a.WEEK_ALL='${WEEK_ALL}' -1
 and e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE
and a.ORG_CODE=f.ORG_CODE 
union
select a.REGULAR_CODE,a.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_ON_REGULAR_WEEK  a,DIM_SHOP  b,(
    select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and a.POST in(select POST FROM FILL_POST)
          union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.DOMAIN
           and  a.POST in('督导')
           union 
          select distinct c.ORG_CODE from FILL_USER_POST  a,
          FR_T_USER  b,DIM_S_SHOP  c
          where b.ID=a.USER_ID and b.username='${fr_username}'
          and b.ID=c.AD
           and  a.POST in('城市经理')
    ) f

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
 and a.ORG_CODE=f.ORG_CODE
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}

)  a
left join 
(
select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
decode(a.REAL_QTY,0,'', (a.REAL_AMOUNT/a.REAL_QTY)) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}' 
 and e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE)  b
on a.REGULAR_CODE=b.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
left join
(
select a.ORG_CODE,a.REGULAR_CODE,a.STOCK_QTY,a.STOCK_AMOUNT,case when a.STOCK_QTY=0 then 0 else a.STOCK_AMOUNT/a.STOCK_QTY end  STOCK_PRICE
 from FACT_STOCK_REGULAR  a,DIM_SHOP  b,VBI_REGULAR_CATE  c
 where a.CREATE_DATE=to_date('2010-12-26','yyyy-mm-dd') + ${WEEK_ALL}*7
 and a.ORG_CODE=b.ORG_CODE
and a.REGULAR_CODE=c.REGULAR_CODE
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
)  c
on a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=c.ORG_CODE
left join 
(
select c.REGULAR_CODE,a.ORG_CODE,sum(REAL_QTY) as REAL_QTY,
sum(VALID_AMOUNT) as VALID_AMOUNT
 from FACT_ON_PASSAGE_ITEM  a,DIM_SHOP  b,DIM_ITEM_INFO_ALL  c

where a.CREATE_DATE=to_char(to_date('2010-12-26','yyyy-mm-dd') + ${WEEK_ALL}*7,'yyyy-mm-dd')
and a.ITEM_ID=c.ITEM_ID and a.ORG_CODE=b.ORG_CODE
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
group by c.REGULAR_CODE,a.ORG_CODE

)  d
on
a.REGULAR_CODE=d.REGULAR_CODE and a.ORG_CODE=d.ORG_CODE
left join 
(select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
decode(a.REAL_QTY,0,'', (a.REAL_AMOUNT/a.REAL_QTY)) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}'-1  
 and  e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE
)  e 
on a.REGULAR_CODE=e.REGULAR_CODE and a.ORG_CODE=e.ORG_CODE
left join
(
select a.ORG_CODE,a.REGULAR_CODE,a.REAL_QTY as TRANS_QTY,a.REAL_AMOUNT as TRANS_AMOUNT
 from FACT_ON_REGULAR_WEEK  a,DIM_SHOP  b

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
${if(len(ORG_CODE)=0,""," AND b.ORG_CODE in('"+ORG_CODE+"')")}
)  f
on a.REGULAR_CODE=f.REGULAR_CODE and a.ORG_CODE=f.ORG_CODE
order by a.REGULAR_CODE,NVL(b.REAL_AMOUNT,0) desc 

select DISTINCT SUB_COMPANY_NAME from DIM_S_SHOP 
WHERE 1=1
${if(len(BRAND_NAME)==0,""," AND BRAND_NAME ='"+BRAND_NAME+"'")}
and SUB_COMPANY_NAME in (select SUB_COMPANY_NAME from FILL_USER_BRAND  a,FR_T_USER  b
where a.USER_ID=to_char(b.id) and b.username='${fr_username}')

select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and b.ID=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union 
select distinct ATTRI_MANAGE_REGION,MANAGE_REGION_NAME from FILL_USER_POST  a,
FR_T_USER b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
and 
c.SUB_COMPANY_NAME = '${SUB_COMPANY_NAME}'
and b.ID=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')


select * from (
select distinct 
         c.REGULAR_CODE,
         concat(c.REGULAR_CODE,c.REGULAR_NAME)  REGULAR_NAME 
      from 
        DIM_ITEM  c
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
      b.ID=to_char(a.USER_ID) 
      ${if(len(fr_username)==0 || fr_username='admin',"","AND b.username IN ('"+fr_username+"')")} 
    --  and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
  
      union 
      select distinct 
        d.REGULAR_CODE,
        concat(d.REGULAR_CODE,d.REGULAR_NAME)  REGULAR_NAME  
      from 
        FILL_USER_POST  a,
       FR_T_USER b,
        DIM_SMALL_BUYER  c,
        DIM_ITEM  d
      where 
      b.ID=to_char(a.USER_ID) 
      ${if(len(fr_username)==0 || fr_username='admin',"","AND b.username IN ('"+fr_username+"')")} 
   --   and b.username='${fr_username}'
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
where BRAND_NAME='${BRAND_NAME}'
)




-- 规整类维度

select REGULAR_CODE,sum(STOCK_QTY) as STOCK_QTY ,sum(STOCK_AMOUNT) as STOCK_AMOUNT
from FACT_STOCK_GENERAL  a,DIM_ITEM_INFO_ALL  b

 where a.CREATE_DATE=to_date('2010-12-26','yyyy-mm-dd')+${WEEK_ALL}*7
 and a.ITEM_ID=b.ITEM_ID
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
 AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
  ${if(len(REGULAR_CODE)=0,""," AND b.REGULAR_CODE in('"+REGULAR_CODE+"')")}
 group by REGULAR_CODE

select a.REGULAR_CODE,a.ORG_CODE,a.SKU from FACT_S_SALE_REGULAR_SKU_WEEK  a,DIM_SHOP  b,VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}' and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
 -- AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select a.REGULAR_CODE,a.ORG_CODE,a.SKU from FACT_S_STOCK_REGULAR_SKU  a,DIM_SHOP  b,VBI_REGULAR_CATE  c

 where a.CREATE_DATE=to_char(to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7, 'yyyy-mm-dd hh24:mi:ss')
 and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.REGULAR_CODE,count(1) as shop_num
 from FACT_SALE_REGULAR_WEEK a,DIM_SHOP  b,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}'
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE 
group by c.REGULAR_CODE

select c.REGULAR_CODE,count(1) as shop_num
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}'-1
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE group by c.REGULAR_CODE

select c.REGULAR_CODE,count(1) as shop_num
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL=(select LAST_WEEK_ALL from DIM_DAY_START_END where WEEK_ALL='${WEEK_ALL}')
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE group by c.REGULAR_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_DAYS_WEEK  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.WEEK_ALL='${WEEK_ALL}'-1
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
decode(a.REAL_QTY,0,'',a.REAL_AMOUNT/a.REAL_QTY) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_REGULAR_WEEK a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}'-1  
 and  e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_SALE_DAYS  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.CREATE_MONTH= to_char(to_date('2009-12-20','yyyy-mm-dd')+'${WEEK_ALL}'*7, 'yyyy-mm')
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select c.REGULAR_CODE,c.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME,a.REAL_AMOUNT,a.ORGI_AMOUNT,a.TRANS_AMOUNT,
decode(a.REAL_QTY,0,'',a.REAL_AMOUNT/a.REAL_QTY) as REAL_PRICE,a.REAL_QTY,e.REAL_AMOUNT as SHOP_REAL_AMOUNT
 from FACT_SALE_REGULAR_WEEK  a,DIM_SHOP  b,FACT_S_SALE_SHOP_WEEK  e,
VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}'-52  and 
 e.WEEK_ALL=a.WEEK_ALL
AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
AND (e.CURRENCY = '${currency}' ${IF(currency='人民币',"OR e.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
and a.ORG_CODE=e.ORG_CODE

select a.ORG_CODE,a.SALE_DAYS from DIM_SHOP_DAYS_WEEK  a,DIM_SHOP  b
where a.ORG_CODE=b.ORG_CODE and a.WEEK_ALL='${WEEK_ALL}'
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select a.ORG_CODE,a.REGULAR_CODE,a.REAL_QTY as TRANS_QTY,a.REAL_AMOUNT as TRANS_AMOUNT
 from FACT_ON_REGULAR_WEEK as a,DIM_SHOP as b

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

SELECT WEEK_ALL,MIN(DAY_ID) AS DAY_ID
FROM DIM_DAY
group by WEEK_ALL
ORDER BY WEEK_ALL

select  min(DAY_ID) AS DAY_ID from DIM_DAY where WEEK_ALL=(
select WEEK_ALL from DIM_DAY where DAY_SHORT_DESC =TRUNC(SYSDATE-7))

select a.REGULAR_CODE,a.ORG_CODE,a.SKU from FACT_S_SALE_80_REGULAR_SKU  a,DIM_SHOP  b,VBI_REGULAR_CATE  c

 where a.WEEK_ALL='${WEEK_ALL}' and a.REGULAR_CODE=c.REGULAR_CODE and a.ORG_CODE=b.ORG_CODE
 -- AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
${if(len(REGULAR_CODE)=0,""," AND c.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select a.REGULAR_CODE,a.REGULAR_NAME,b.BRAND_NAME,
b.MANAGE_REGION_NAME,b.SUB_COMPANY_NAME,b.ORG_DOMAIN_NAME,b.ORG_CODE,b.ORG_NAME
 from FACT_ON_REGULAR_WEEK as a,DIM_SHOP as b

 where a.WEEK_ALL='${WEEK_ALL}'
 and a.ORG_CODE=b.ORG_CODE
${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}

select a.REGULAR_CODE,b.ORG_CODE,sum(a.REAL_AMOUNT) as REAL_AMOUNT
 from FACT_CROSS_SALE_REGULAR  a,DIM_SHOP  b

 where a.CREATE_DATE<=to_char(to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7, 'yyyy-mm-dd')
and a.CREATE_DATE>= to_char(TRUNC(to_date('2010-12-26','yyyy-mm-dd')+'${WEEK_ALL}'*7,'MM'), 'yyyy-mm-dd')
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})

${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 

${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} and a.ORG_CODE=b.ORG_CODE
group by B.ORG_CODE,a.REGULAR_CODE

select 
  a.REGULAR_CODE,
  b.ORG_CODE,
  sum(a.REAL_AMOUNT) as REAL_AMOUNT
from 
  FACT_CROSS_SALE_REGULAR  a,
  DIM_SHOP  b
where    
  a.CREATE_DATE<=to_char(add_months(to_date('2010-12-26','yyyy-mm-dd')+(${WEEK_ALL})*7,-12),'yyyy-mm-dd hh24:mi:ss')  
  and a.CREATE_DATE>= to_char(TRUNC(add_months(TO_DATE('2010-12-26 ','yyyy-mm-dd')+ (${WEEK_ALL})*7,-12),'MM'),'yyyy-mm-dd hh24:mi:ss')  
  AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
  ${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 
  ${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
  ${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
  ${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} 
  and a.ORG_CODE=b.ORG_CODE
group by b.ORG_CODE,a.REGULAR_CODE

SELECT 
  B.realname as AD,
  ORG_CODE 
FROM 
  DIM_S_SHOP  A,
  FR_T_USER   B
WHERE 
  1=1
  ${if(len(BRAND_NAME)=0,""," AND A.BRAND_NAME ='"+BRAND_NAME+"'")}
  ${if(len(SUB_COMPANY_NAME)=0,""," AND A.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
  ${if(len(ATTRI_MANAGE_REGION)=0,""," AND A.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")}
  and A.AD=B.id

select id,concat(username,realname) as name from FR_T_USER 

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY


select a.REGULAR_CODE,b.ORG_CODE,sum(a.REAL_AMOUNT) as REAL_AMOUNT
 from FACT_CROSS_SALE_REGULAR as a,DIM_SHOP as b

 where a.CREATE_DATE<=DATE_FORMAT(DATE_ADD('2010-12-26 00:00:00',INTERVAL ${WEEK_ALL} WEEK),'%Y-%m-%d')  
and a.CREATE_DATE>= DATE_ADD(DATE_ADD('2010-12-26 00:00:00',INTERVAL '${WEEK_ALL}' WEEK),interval -day(DATE_ADD('2010-12-26 00:00:00',INTERVAL '${WEEK_ALL}' WEEK))+1 day)
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})

${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 

${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} and a.ORG_CODE=b.ORG_CODE
group by a.ORG_CODE,a.REGULAR_CODE

select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in(select POST FROM FILL_POST)
union 
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and b.ID=c.DOMAIN
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('督导')
union  
select distinct c.ORG_NAME,c.ORG_CODE from FILL_USER_POST  a,
FR_T_USER  b,DIM_S_SHOP  c
where b.ID=a.USER_ID and b.username='${fr_username}'
${IF(LEN(ATTRI_MANAGE_REGION)=0,"","and c.ATTRI_MANAGE_REGION IN ('"+ATTRI_MANAGE_REGION+"')")}
${IF(LEN(SUB_COMPANY_NAME)=0,"","and c.SUB_COMPANY_NAME IN ('"+SUB_COMPANY_NAME+"')")}
and b.ID=c.AD
AND c.BRAND_NAME = '${BRAND_NAME}' and a.POST in('城市经理')


select a.REGULAR_CODE,b.ORG_CODE,sum(a.REAL_AMOUNT) as REAL_AMOUNT
 from FACT_CROSS_SALE_REGULAR as a,DIM_SHOP as b

 where a.CREATE_DATE<=DATE_FORMAT(DATE_ADD('2010-12-26 00:00:00',INTERVAL '${WEEK_ALL}' WEEK),'%Y-%m-%d')  
and a.CREATE_DATE>= DATE_ADD(DATE_ADD('2010-12-26 00:00:00',INTERVAL '${WEEK_ALL}' WEEK),interval -day(DATE_ADD('2010-12-26 00:00:00',INTERVAL '${WEEK_ALL}' WEEK))+1 day)
 AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})

${if(len(REGULAR_CODE)=0,""," AND a.REGULAR_CODE in('"+REGULAR_CODE+"')")} 

${if(len(BRAND_NAME)=0,""," AND b.BRAND_NAME ='"+BRAND_NAME+"'")}
${if(len(SUB_COMPANY_NAME)=0,""," AND b.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
${if(len(ATTRI_MANAGE_REGION)=0,""," AND b.ATTRI_MANAGE_REGION in('"+ATTRI_MANAGE_REGION+"')")} and a.ORG_CODE=b.ORG_CODE and a.ORG_CODE='005009'
group by a.ORG_CODE,a.REGULAR_CODE

