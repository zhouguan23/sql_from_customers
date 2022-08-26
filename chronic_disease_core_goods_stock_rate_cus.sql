select b.union_area_name 合并区域,a.area_code 区域编码,b.sorted,b.area_name 区域名称,a.ill_type 病种,a.cus_code 门店编码,e.cus_name 门店名称,count(distinct a.goods_code)备货品种数,count(distinct c.goods_code)动销品种数,count(distinct d.goods_code)有库存品种数
from dim_region b,(select * from USER_AUTHORITY)  ua,dim_cus e ,dim_illness_core_catalogue a
left join fact_sale c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
and a.goods_code=c.goods_code
and c.sale_date>=to_date('${start_date}','yyyy-mm-dd')
and c.sale_date<=to_date('${end_date}','yyyy-mm-dd')
left join --dm_stock_shop_day d

(select a.cus_code,a.area_code,a.goods_code from dm_stock_shop_day a
where   a.stock_qty>0)d

on a.area_code=d.area_code
and a.cus_code=d.cus_code
and a.goods_code=d.goods_code
--and d.stock_qty>0
 
where a.area_code=b.area_code
and a.area_code=e.area_code
and a.cus_code=e.cus_code
and (b.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and b.union_area_name in ('"+UNION_AREA+"')")}
and a.area_code!='16'
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
group by b.union_area_name,a.area_code,b.sorted,b.area_name,a.cus_code,a.ill_type,e.cus_name
--order by decode(a.area_code,'00','AA',b.union_area_name),a.area_code,a.cus_code
order by b.sorted,a.cus_code

select distinct ill_type from dim_illness_core_catalogue


select distinct a.cus_code,a.cus_code||'|'||b.cus_name as cus_name from dim_illness_core_catalogue a,dim_cus b,dim_region c
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.area_code=c.area_code
and 1=1 ${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
order by a.cus_code

