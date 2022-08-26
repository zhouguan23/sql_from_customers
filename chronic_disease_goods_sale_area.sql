select a.*,b.销售额,b.毛利额 from (
(select c.union_area_name,a.area_code,c.area_name,b.ill_type,sum(tax_amount),sum(nvl(tax_amount,0)-nvl(tax_cost,0)) 
from dim_illness_catalogue b,dim_region c,fact_sale a
left join dim_cus dc
on a.area_code=dc.area_code
and a.cus_code=dc.cus_code
where a.goods_code=b.goods_code
and a.area_code=c.area_code
and sale_date>=to_date('${start_date}','yyyy-mm-dd')
and sale_date<=to_date('${end_date}','yyyy-mm-dd')
and 1=1 ${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and b.ill_type in ('"+ill_type+"')")}
and 1=1 ${if(len(func)=0,""," and b.func in ('"+func+"')")}
and 1=1 ${if(len(attribute)=0,""," and dc.attribute in ('"+attribute+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
group by c.union_area_name,a.area_code,c.area_name,b.ill_type
order by a.area_code)a
left join (
select a.area_code,b.ill_type,sum(tax_amount)销售额,sum(nvl(tax_amount,0)-nvl(tax_cost,0))毛利额
from dim_illness_catalogue b,dim_region c,fact_sale a
left join dim_cus dc
on a.area_code=dc.area_code
and a.cus_code=dc.cus_code
where a.goods_code=b.goods_code
and a.area_code=c.area_code
and sale_date>=to_date('${start_date1}','yyyy-mm-dd')
and sale_date<=to_date('${end_date1}','yyyy-mm-dd')
and 1=1 ${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and b.ill_type in ('"+ill_type+"')")}
and 1=1 ${if(len(func)=0,""," and b.func in ('"+func+"')")}
and 1=1 ${if(len(attribute)=0,""," and dc.attribute in ('"+attribute+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
group by a.area_code,b.ill_type
order by a.area_code)b 
on a.area_code=b.area_code
and a.ill_type=b.ill_type
--and a.func=b.func
--and a.is_core=b.is_core

)




select a.area_code,a.area_name from dim_region a 
where 
 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1

select distinct a.UNION_AREA_NAME,a.area_code from dim_region a 
order by area_code

select distinct ill_type from dim_illness_catalogue

select distinct a.goods_code,a.goods_code||'|'||b.goods_name as goods_name from dim_illness_catalogue a,dim_goods b
where a.goods_code=b.goods_code
order by a.goods_code

select distinct func from dim_illness_catalogue
where 1=1 ${if(len(ill_type)=0,""," and ill_type in ('"+ill_type+"')")}

