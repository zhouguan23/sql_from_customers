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
left join dim_region f on a.area_code=f.area_code
where 
SALE_DATE between date'${date1}' and date'${date2}'
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
and b.attribute='直营'
group by b.AREA_CODE,b.CUS_CODE
 


select 
area_code,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE_BAK,
SHOP_AREA,
EMPLOYEE_NUMBER,
sum(TAX_AMOUNT) as JE ,
sum(TAX_AMOUNT-TAX_COST) as ML,
sum(NO_TAX_AMOUNT) as no_JE,
sum(NO_TAX_AMOUNT-NO_TAX_COST) as no_ML,
count(distinct goods_code) sku,
count(goods_code) xdb
from
(
select
b.area_code,
b.area_name,
f.union_area_name,
b.cus_code,
b.cus_name,
b.OPEN_DATE_BAK,
b.SHOP_AREA,
b.EMPLOYEE_NUMBER,
TAX_AMOUNT,
TAX_COST,
NO_TAX_AMOUNT,
NO_TAX_COST,
a.goods_code,
DECODE(C.GOODS_CODE,NULL,'否','是') as dtp, -- dtp
DECODE(D.OTO,'否','否','是') as oto -- oto
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
where a.SALE_DATE between date'${date1}' and date'${date2}'
and b.attribute='直营'
${if(len(time)=0,"","and e.age_store IN ('"+time+"')")}
${if(len(union_area)=0,"","and f.union_area_name IN ('"+union_area+"')")}
--and e.time not in ('新店','次新店') 
order by b.area_code,b.cus_code
)
where 
1=1 ${if(len(OTO)=0,""," and oto ='"+OTO+"' ")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
and 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"') ")}
and 1=1 ${if(len(cus)=0,""," and cus_code in ('"+cus+"') ")}
group by area_code,
area_name,
union_area_name,
cus_code,
cus_name,
OPEN_DATE_BAK,
SHOP_AREA,
EMPLOYEE_NUMBER
order by union_area_name

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
and b.attribute='直营'
--and c.time not in ('新店','次新店') 
${if(len(time)=0,"","and c.age_store IN ('"+time+"')")}
and 1=1 ${if(len(DTP)=0,""," and dtp ='"+DTP+"' ")}
group by b.CUS_Code,b.area_code

select distinct age_store as time from AGE_STORE

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

