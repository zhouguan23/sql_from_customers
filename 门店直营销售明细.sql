select
* from
(
--无税
select
'无税' flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
sum(nvl(NO_TAX_AMOUNT,0)) as NO_TAX_AMOUNT,
sum(nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0) end) NDTP_NO_TAX_AMOUNT,
sum(case when DTP='否' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) NDTP_NO_SALE_ML,
sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0) end) DTP_NO_TAX_AMOUNT,
sum(case when DTP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) DTP_NO_SALE_ML,
sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0) end) OTO_NO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) OTO_NO_SALE_ML,
sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0) end) VIP_NO_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0) end) VIP_NO_SALE_ML
from dim_cus b,dim_region c ,(select * from USER_AUTHORITY) d,DM_SALE_TMP a 
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
and (c.UNION_AREA_NAME=d.UNION_AREA_NAME or d.UNION_AREA_NAME='ALL') 
and ${"d.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(age_store)=0,"","and e.age_store IN ('"+age_store+"')")}
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME

union all
--含税
select
'含税' flag,
b.cus_code,
b.cus_name,
c.area_code,
c.area_name,
c.UNION_AREA_NAME,
sum(nvl(TAX_AMOUNT,0)) as TAX_AMOUNT,
sum(nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)) as SALE_ML,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0) end) NDTP_TAX_AMOUNT,
sum(case when DTP='否' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) NDTP_NO_SALE_ML,
sum(case when DTP='是' then nvl(TAX_AMOUNT,0) end) DTP_TAX_AMOUNT,
sum(case when DTP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) DTP_NO_SALE_ML,
sum(case when OTO='是' then nvl(TAX_AMOUNT,0) end) OTO_TAX_AMOUNT,
sum(case when OTO='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) OTO_NO_SALE_ML,
sum(case when a.VIP='是' then nvl(ORIGIN_AMOUNT,0) end) ORIGIN_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0) end) VIP_TAX_AMOUNT,
sum(case when a.VIP='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) VIP_NO_SALE_ML
from dim_cus b,dim_region c ,(select * from USER_AUTHORITY) d,DM_SALE_TMP a  
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营' 
and (c.UNION_AREA_NAME=d.UNION_AREA_NAME or d.UNION_AREA_NAME='ALL') 
and ${"d.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(age_store)=0,"","and e.age_store IN ('"+age_store+"')")}
group by b.cus_code,b.cus_name,c.area_code,c.area_name,c.UNION_AREA_NAME
)
where 1=1
${if(len(flag)=0,"","and flag ='"+flag+"'")}
${if(len(UNIONAREA)=0,""," and UNION_AREA_NAME in ('"+UNIONAREA+"')")}
${if(len(AREA)=0,""," and AREA_CODE in ('"+AREA+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
order by area_code,cus_code

select 
area_code,
cus_code,
sum(TRAN_NUM) TRAN_NUM,
sum(case when IS_VIP='Y' then TRAN_NUM end ) vip_TRAN_NUM
from DM_TRANSACTION
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
group by area_code,
cus_code

select distinct
a.UNION_AREA_NAME,
a.area_code,
a.area_name
from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and 
1=1
${if(len(UNIONAREA)=0,""," and a.UNION_AREA_NAME in ('"+UNIONAREA+"')")}
and ${"b.user_id='"+$fr_username+"'"}
order by a.area_code

select a.area_code, a.cus_code, a.cus_code || '|' || a.cus_name as  cus_name
  from dim_cus a,dim_region b 
where 
 a.area_code=b.area_code
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1  ${if(len(UNIONAREA)=0,""," and b.UNION_AREA_NAME in ('"+UNIONAREA+"')")} 
order by 1,2

select 
distinct 
area_code,
cus_code,
OPEN_DATE,
HEALTH_CARE,
SHOP_AREA,
EMPLOYEE_NUMBER,
attribute
from 
dim_cus

select 
a.area_code,
a.cus_code,
count(distinct goods_code) sku
from fact_sale a ,dim_cus b
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
and a.area_code=b.area_code and a.cus_code=b.cus_code
and b.attribute='直营' 
group by a.area_code,
a.cus_code

select 
a.area_code,
a.cus_code,
count(distinct goods_code) sku
from dm_stock_shop_day a ,dim_cus b
where a.area_code=b.area_code 
and a.cus_code=b.cus_code
and b.attribute='直营' 
group by a.area_code,
a.cus_code

select distinct age_store from AGE_STORE

