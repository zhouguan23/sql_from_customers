--当期销售
select b.union_area_name,m.large_cate,m.small_cate,
c.cus_code,c.cus_name,c.attribute,case when i.cus_code is not null then '是' else '否' end is_import,
MIN(b.sorted) sorted,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
COUNT(DISTINCT A.TRAN_NO) 销售单数

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join dim_o2o_import_cus i
on a.area_code=i.area_code
and a.cus_code=i.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on a.area_code=m.area_code
and a.marketing_code=m.marketing_code
, (select * from USER_AUTHORITY) u
where  
--a.is_b2c='Y' 
m.large_cate like '%O2O%'

and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 

and 1=1 ${if(len(cus)=0,"","and c.cus+code in('"+cus+"')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(attribute)=0, "", " and c.attribute in ('" + attribute + "')")}
and 1=1 ${if(len(large)=0, "", " and m.large_cate in ('" + large + "')")}
and 1=1 ${if(len(small)=0, "", " and m.small_cate in ('" + small + "')")}
group by b.union_area_name,m.large_cate,m.small_cate,c.cus_code,c.cus_name,c.attribute,case when i.cus_code is not null then '是' else '否' end 
order by sorted,c.cus_code,m.large_cate,m.small_cate

select r.union_area_name,a.cus_code,(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end) 直营非DTP销售
from dm_sale_tmp a,dim_region r
where a.area_code=r.area_code
and  a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and a.dtp='否'
group by r.union_area_name,a.cus_code

select r.union_area_name,a.cus_code,(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end) 直营非DTP销售
from dm_sale_tmp a,dim_region r
where a.area_code=r.area_code
and   a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and a.dtp='否'
group by r.union_area_name,a.cus_code

select r.union_area_name,a.cus_code,(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end) 直营非DTP销售
from dm_sale_tmp a,dim_region r
where a.area_code=r.area_code
and   a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and a.dtp='否'
group by r.union_area_name,a.cus_code

--当期销售
select b.union_area_name,m.large_cate,m.small_cate,
c.cus_code,c.cus_name,c.attribute,
min(b.sorted) sorted,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
COUNT(DISTINCT A.TRAN_NO) 销售单数

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on a.area_code=m.area_code
and a.marketing_code=m.marketing_code
, (select * from USER_AUTHORITY) u
where  
--a.is_b2c='Y' 
m.large_cate like '%O2O%'

and (b.UNION_AREA_NAME=u.UNION_AREA_NAME or u.UNION_AREA_NAME='ALL') 
and ${"u.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and   a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and 1=1 ${if(len(attribute)=0, "", " and c.attribute in ('" + attribute + "')")}
and 1=1 ${if(len(large)=0, "", " and m.large_cate in ('" + large + "')")}
group by b.union_area_name,m.large_cate,m.small_cate,c.cus_code,c.cus_name,c.attribute
order by sorted,c.cus_code,m.large_cate

--当期销售
select b.union_area_name,m.large_cate,m.small_cate,
c.cus_code,c.cus_name,c.attribute,
min(b.sorted) sorted,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量,
COUNT(DISTINCT A.TRAN_NO) 销售单数

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on a.area_code=m.area_code
and a.marketing_code=m.marketing_code

where  
--a.is_b2c='Y' 
m.large_cate like '%O2O%'


and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and 1=1 ${if(len(attribute)=0, "", " and c.attribute in ('" + attribute + "')")}
and 1=1 ${if(len(large)=0, "", " and m.large_cate in ('" + large + "')")}
group by b.union_area_name,m.large_cate,m.small_cate,c.cus_code,c.cus_name,c.attribute
order by sorted,c.cus_code,m.large_cate

select a.area_code,a.area_name,a.UNION_AREA_NAME,a.sorted from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
 
order by sorted

select distinct large_cate,small_cate from dim_marketing_all
where large_cate like '%O2O%'

