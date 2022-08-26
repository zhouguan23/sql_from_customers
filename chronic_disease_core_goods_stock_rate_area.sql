select b.union_area_name 合并区域,b.sorted,a.area_code 区域编码,b.area_name 区域名称,a.ill_type 病种,
sum(a.备货品种数)备货品种数,count(distinct a.cus_code)备货门店数,sum(a.动销品种数)动销品种数,sum(a.有库存品种数)有库存品种数
from (
select a.area_code,a.cus_code,a.ill_type,b.func,count(distinct a.goods_code)备货品种数,count(distinct c.goods_code)动销品种数,count(distinct d.goods_code)有库存品种数
from dim_cus e,dim_illness_core_catalogue a
left join dim_illness_catalogue b
on a.goods_code=b.goods_code
and a.ill_type=b.ill_type
left join fact_sale c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
and a.goods_code=c.goods_code
and c.sale_date>=to_date('${start_date}','yyyy-mm-dd')
and c.sale_date<=to_date('${end_date}','yyyy-mm-dd')

left join --dm_stock_shop_day d

(select a.cus_code,a.area_code,a.goods_code from dm_stock_shop_day a
where  a.stock_qty>0)d

on a.area_code=d.area_code
and a.cus_code=d.cus_code
and a.goods_code=d.goods_code
--and d.stock_qty>0
where a.area_code=e.area_code
and a.cus_code=e.cus_code
group by a.area_code,a.cus_code,a.ill_type,b.func
)a,dim_region b,(select * from USER_AUTHORITY)  ua
where a.area_code=b.area_code
and (b.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}
and 1=1 ${if(len(func)=0,""," and a.func in ('"+func+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and b.union_area_name in ('"+UNION_AREA+"')")}
and a.area_code!='16'
group by  b.union_area_name,b.sorted,a.area_code,b.area_name,a.ill_type
--order by decode(a.area_code,'00','AA',b.union_area_name),a.area_code
order by b.sorted

select a.area_code,a.area_name from dim_region a 
where 
 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
--order by decode(area_code,'00','AA',union_area_name),area_code
order by a.sorted

select  a.UNION_AREA_NAME,a.area_code from dim_region a 
--order by decode(area_code,'00','AA',union_area_name),area_code
order by a.sorted

select distinct ill_type from dim_illness_core_catalogue

select distinct func from dim_illness_catalogue a,dim_illness_core_catalogue b
where a.goods_code=b.goods_code
and a.ill_type=b.ill_type
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}

