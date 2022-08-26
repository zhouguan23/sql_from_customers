select  a.UNION_AREA_NAME
from dim_region a 
order by a.sorted

select distinct age_store from AGE_STORE

select c.union_area_name,b.age_store,count(a.cus_code)as 院边店数,count(d.cus_code)as 院边店关店数量,sum(dst.no_tax_amount)as 销售额,(sum(dst.no_tax_amount)-sum(dst.no_tax_cost)) as 毛利额,sum(fst.subtotal_of_expenses)as 费用额,
(sum(dst.no_tax_amount)-sum(dst.no_tax_cost))/sum(dst.no_tax_amount) as 毛利率,
sum(fst.subtotal_of_expenses)/sum(dst.no_tax_amount) as 费用率,
sum(fst.operating_profit)as 利润额,
sum(dst.sale_date)/count(a.cus_code) as 单店有效经营天数,
sum(dst.no_tax_amount)/sum(dst.sale_date) as 单店日均销售
from age_store b,dim_region c,dim_cus_ybd a
left join 
(select a.area_code,a.cus_code  from dim_cus_ybd a,dim_cus dc
where a.area_code=dc.area_code
and a.cus_code=dc.cus_code
and dc.attribute='直营'
and dc.close_date is not null
and to_char(dc.close_date,'yyyy-mm')>='${start_date}'
and to_char(dc.close_date,'yyyy-mm')<='${end_date}'
)d
on a.area_code=d.area_code
and a.cus_code=d.cus_code
left join (
select area_code,cus_code,sum(no_tax_amount)no_tax_amount,
sum(no_tax_cost)no_tax_cost,count(distinct sale_date)sale_date 
from dm_sale_tmp
where to_char(sale_date,'yyyy-mm')>='${start_date}'
and to_char(sale_date,'yyyy-mm')<='${end_date}'
group by area_code,cus_code
) dst
on  a.area_code=dst.area_code
and a.cus_code=dst.cus_code
left join (
select area_code,cus_code,sum(subtotal_of_expenses)subtotal_of_expenses,
sum(operating_profit)operating_profit 
from fact_store_import
where year||'-'||lpad(month,2,'0')>='${start_date}'
and year||'-'||lpad(month,2,'0')<='${end_date}'
group by area_code,cus_code
)fst
on a.area_code=fst.area_code
and a.cus_code=fst.cus_code

where a.area_code=b.area_code
and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.age_store like '%直营%'
and b.date1='${end_date}'
and 1=1 ${if(len(UNION_AREA)=0,"","and c.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(age_store)=0,"","and b.age_store in('"+age_store+"')")} 
group by c.union_area_name,b.age_store
order by min(c.sorted)


select  c.union_area_name,b.age_store, 
sum(dst.sale_date)/count( a.cus_code) as 单店有效经营天数,
sum(dst.no_tax_amount)/sum(dst.sale_date) as 单店日均销售
from age_store b,dim_region c,dim_cus a
left join (
select area_code,cus_code,sum(no_tax_amount)no_tax_amount,
sum(no_tax_cost)no_tax_cost,count(distinct sale_date)sale_date 
from dm_sale_tmp
where to_char(sale_date,'yyyy-mm')>='${start_date}'
and to_char(sale_date,'yyyy-mm')<='${end_date}'
group by area_code,cus_code
) dst
on a.area_code=dst.area_code
and a.cus_code=dst.cus_code
where a.area_code=b.area_code
and a.cus_code=b.cus_code 
and a.area_code=c.area_code
and not exists(select area_code,cus_code from dim_cus_ybd b where a.area_code=b.area_code and a.cus_code=b.cus_code)
and a.attribute='直营'
and (a.close_date is null or to_char(a.close_date,'yyyy-mm')>='${start_date}')
and b.date1='${end_date}'
and b.age_store like '%直营%'
and 1=1 ${if(len(UNION_AREA)=0,"","and c.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(age_store)=0,"","and b.age_store in('"+age_store+"')")} 
group by c.union_area_name,b.age_store

