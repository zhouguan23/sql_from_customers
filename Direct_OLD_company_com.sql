select a.AREA_CODE,a.CUS_CODE,a.TRAN_NUM,b.TRAN_NUM as TQTRAN_NUM
from (select b.AREA_CODE,b.CUS_CODE,sum(TRAN_NUM) TRAN_NUM from DM_TRANSACTION a 
left join 
DIM_CUS b 
on a.AREA_CODE=b.AREA_CODE and to_char(a.CUS_CODE)=b.CUS_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and to_char(a.CUS_CODE)=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code

where 
SALE_DATE between date'${start_date}' and date'${end_date}'
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
${if(len(is_small_scale)=0,"","and nvl(b.small_scale,'否') ='"+is_small_scale+"'")}
and b.attribute='直营'
group by b.AREA_CODE,b.CUS_CODE
)a
left join (
select b.AREA_CODE,b.CUS_CODE,sum(TRAN_NUM) TRAN_NUM from DM_TRANSACTION a 
left join 
DIM_CUS b 
on a.AREA_CODE=b.AREA_CODE and to_char(a.CUS_CODE)=b.CUS_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and to_char(a.CUS_CODE)=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code

where 
SALE_DATE between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
${if(len(is_small_scale)=0,"","and nvl(b.small_scale,'否') ='"+is_small_scale+"'")}
and b.attribute='直营'
group by b.AREA_CODE,b.CUS_CODE
)b
on a.AREA_CODE=b.AREA_CODE
and a.CUS_CODE=b.CUS_CODE
 

select a.area_code,
a.sorted,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
a.OPEN_DATE,
a.SHOP_AREA,
a.EMPLOYEE_NUMBER, 
a.销售额,
a.毛利额,
a.sku,
a.xdb,
b.销售额 as 同期销售额,
b.毛利额 as 同期毛利额,
b.sku as tqsku,
b.xdb as tqxdb

from (select 
area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT) else sum(TAX_AMOUNT) end as 销售额,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT-NO_TAX_COST) else sum(TAX_AMOUNT-TAX_COST) end as 毛利额,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
sorted,
b.area_code,
b.area_name,
f.union_area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto, -- oto
nvl(b.small_scale,'否') as small_scale --is_small_scale
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
LEFT JOIN
DIM_DTP C
ON
A.AREA_CODE = C.AREA_CODE 
AND 
A.GOODS_CODE = C.GOODS_CODE 
AND 
TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
DIM_MARKETING D
ON 
A.MARKETING_CODE = D.MARKETING_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code
left join (select * from USER_AUTHORITY) g on (f.UNION_AREA_NAME=g.UNION_AREA_NAME or g.UNION_AREA_NAME='ALL')
where a.SALE_DATE between date'${start_date}' and date'${end_date}'
and b.attribute='直营' and ${"g.user_id='"+$fr_username+"'"}
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
order by sorted
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(area)=0,""," and area_name in ('"+area+"') ")}
and 1=1 ${if(len(cus)=0,""," and cus_name in ('"+cus+"') ")}
and 1=1 ${if(len(is_small_scale)=0,"","and small_scale ='"+is_small_scale+"'")}
group by area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER
order by sorted,cus_code
)a

left join (
select 
area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT) else sum(TAX_AMOUNT) end as 销售额,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT-NO_TAX_COST) else sum(TAX_AMOUNT-TAX_COST) end as 毛利额,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
sorted,
b.area_code,
b.area_name,
f.union_area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto, -- oto
nvl(b.small_scale,'否') as small_scale --is_small_scale
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
LEFT JOIN
DIM_DTP C
ON
A.AREA_CODE = C.AREA_CODE 
AND 
A.GOODS_CODE = C.GOODS_CODE 
AND 
TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
DIM_MARKETING D
ON 
A.MARKETING_CODE = D.MARKETING_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code
left join (select * from USER_AUTHORITY) g on (f.UNION_AREA_NAME=g.UNION_AREA_NAME or g.UNION_AREA_NAME='ALL')
where a.SALE_DATE between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and b.attribute='直营' and ${"g.user_id='"+$fr_username+"'"}
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
order by sorted
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(area)=0,""," and area_name in ('"+area+"') ")}
and 1=1 ${if(len(cus)=0,""," and cus_name in ('"+cus+"') ")}
and 1=1 ${if(len(is_small_scale)=0,"","and small_scale ='"+is_small_scale+"'")}
group by area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER
order by sorted,cus_code
)b
on a.area_code=b.area_code
and a.cus_code=b.cus_code
and a.OPEN_DATE=b.OPEN_DATE
and a.SHOP_AREA=b.SHOP_AREA
and a.EMPLOYEE_NUMBER=b.EMPLOYEE_NUMBER
order by a.sorted,a.cus_code

select 
b.CUS_Code,
b.area_code,
count(distinct a.goods_code)
from dm_stock_shop_detail A
left join dim_cus b on a.area_code=b.area_code and a.cus_code=b.cus_code
left join (select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) c 
on a.AREA_CODE=c.AREA_CODE and a.CUS_CODE=c.CUS_CODE
WHERE DDATE = (select max(DDATE) from dm_stock_shop_shop)
--and b.attribute='直营'
--and c.time not in ('新店','次新店') 
${if(len(time)=0,"","and c.age_store IN ('"+time+"')")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
${if(len(is_small_scale)=0,"","and nvl(b.small_scale,'否') ='"+is_small_scale+"'")}
group by b.CUS_Code,b.area_code
 

select distinct age_store as time from AGE_STORE

select 
area_code,
area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT) else sum(TAX_AMOUNT) end as 销售额,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT-NO_TAX_COST) else sum(TAX_AMOUNT-TAX_COST) end as 毛利额,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
b.area_code,
b.area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto, -- oto
nvl(b.small_scale,'否') as small_scale --is_small_scale
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
LEFT JOIN
DIM_DTP C
ON
A.AREA_CODE = C.AREA_CODE 
AND 
A.GOODS_CODE = C.GOODS_CODE 
AND 
TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
DIM_MARKETING D
ON 
A.MARKETING_CODE = D.MARKETING_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code
left join (select * from USER_AUTHORITY) g on (f.UNION_AREA_NAME=g.UNION_AREA_NAME or g.UNION_AREA_NAME='ALL')
where a.SALE_DATE between date'${b_date1}' and date'${b_date2}'
and b.attribute='直营' and ${"g.user_id='"+$fr_username+"'"}
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(is_small_scale)=0,"","and small_scale ='"+is_small_scale+"'")}
group by area_code,
area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER
order by area_code

select b.AREA_CODE,b.CUS_CODE,sum(TRAN_NUM) TRAN_NUM from DM_TRANSACTION a 
left join 
DIM_CUS b 
on a.AREA_CODE=b.AREA_CODE and to_char(a.CUS_CODE)=b.CUS_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and to_char(a.CUS_CODE)=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code

where 
SALE_DATE between date'${b_date1}' and date'${b_date2}'
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
${if(len(is_small_scale)=0,"","and nvl(b.small_scale,'否') ='"+is_small_scale+"'")}
and b.attribute='直营'
group by b.AREA_CODE,b.CUS_CODE
 

select 
distinct
area_name,area_code
from
DIM_REGION
where 1=1 
${if(len(union_area)=0,"","and union_area_name IN ('"+union_area+"')")}
order by area_name

select 
distinct
cus_name,cus_code
from 
dim_cus
where 
1=1 ${if(len(area)=0,""," and area_code in ('"+area+"') ")}


select distinct 
union_area_name
from dim_region

select a.area_code,
a.sorted,
a.area_name,
a.union_area_name,
a.cus_code,
a.cus_name,
a.OPEN_DATE,
a.SHOP_AREA,
a.EMPLOYEE_NUMBER, 
a.销售额,
a.毛利额,
a.sku,
a.xdb,
b.销售额 as 同期销售额,
b.毛利额 as 同期毛利额,
b.sku as tqsku,
b.xdb as tqxdb

from (select 
area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT) else sum(TAX_AMOUNT) end as 销售额,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT-NO_TAX_COST) else sum(TAX_AMOUNT-TAX_COST) end as 毛利额,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
sorted,
b.area_code,
b.area_name,
f.union_area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto, -- oto
nvl(b.small_scale,'否') as small_scale --is_small_scale
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
LEFT JOIN
DIM_DTP C
ON
A.AREA_CODE = C.AREA_CODE 
AND 
A.GOODS_CODE = C.GOODS_CODE 
AND 
TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
DIM_MARKETING D
ON 
A.MARKETING_CODE = D.MARKETING_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code
/*left join (select * from USER_AUTHORITY) g on (f.UNION_AREA_NAME=g.UNION_AREA_NAME or g.UNION_AREA_NAME='ALL')*/
where a.SALE_DATE between date'${start_date}' and date'${end_date}'
and b.attribute='直营' --and ${"g.user_id='"+$fr_username+"'"}
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
order by sorted
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(area)=0,""," and area_name in ('"+area+"') ")}
and 1=1 ${if(len(cus)=0,""," and cus_name in ('"+cus+"') ")}
and 1=1 ${if(len(is_small_scale)=0,"","and small_scale ='"+is_small_scale+"'")}
group by area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER
order by sorted,cus_code
)a

left join (
select 
area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT) else sum(TAX_AMOUNT) end as 销售额,
case when '${Tax}'='无税' then sum(NO_TAX_AMOUNT-NO_TAX_COST) else sum(TAX_AMOUNT-TAX_COST) end as 毛利额,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
sorted,
b.area_code,
b.area_name,
f.union_area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto, -- oto
nvl(b.small_scale,'否') as small_scale --is_small_scale
from
fact_sale a 
left join dim_cus b 
on a.AREA_CODE=b.AREA_CODE and a.CUS_CODE=b.CUS_CODE
LEFT JOIN
DIM_DTP C
ON
A.AREA_CODE = C.AREA_CODE 
AND 
A.GOODS_CODE = C.GOODS_CODE 
AND 
TO_CHAR(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM') =C.CREATE_MONTH
LEFT JOIN 
DIM_MARKETING D
ON 
A.MARKETING_CODE = D.MARKETING_CODE
left join 
(select *
from AGE_STORE 
where date1=(select max(date1) from AGE_STORE)
) e 
on a.AREA_CODE=e.AREA_CODE and a.CUS_CODE=e.CUS_CODE
left join DIM_REGION f on a.area_code=f.area_code
/*left join (select * from USER_AUTHORITY) g on (f.UNION_AREA_NAME=g.UNION_AREA_NAME or g.UNION_AREA_NAME='ALL')*/
where a.SALE_DATE between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and b.attribute='直营' --and ${"g.user_id='"+$fr_username+"'"}
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
order by sorted
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(area)=0,""," and area_name in ('"+area+"') ")}
and 1=1 ${if(len(cus)=0,""," and cus_name in ('"+cus+"') ")}
and 1=1 ${if(len(is_small_scale)=0,"","and small_scale ='"+is_small_scale+"'")}
group by area_code,
sorted,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE,
SHOP_AREA,
EMPLOYEE_NUMBER
order by sorted,cus_code
)b
on a.area_code=b.area_code
and a.cus_code=b.cus_code
and a.OPEN_DATE=b.OPEN_DATE
and a.SHOP_AREA=b.SHOP_AREA
and a.EMPLOYEE_NUMBER=b.EMPLOYEE_NUMBER
order by a.sorted,a.cus_code

