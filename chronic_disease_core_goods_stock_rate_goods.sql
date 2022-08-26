select b.union_area_name 合并区域,a.area_code 区域编码,b.area_name 区域名称,a.ill_type 病种,
a.goods_code 商品编码,f.goods_name 商品名称,f.specification 规格,f.manufacturer 生产厂家,g.func 功能主治,
count(distinct a.cus_code)备货门店数,count(distinct c.cus_code)动销门店数,count(distinct d.cus_code)有库存门店数
from dim_region b,dim_cus e ,dim_illness_core_catalogue a
left join fact_sale c
on a.area_code=c.area_code
--and a.cus_code=c.cus_code
and a.goods_code=c.goods_code
and c.sale_date>=to_date('${start_date}','yyyy-mm-dd')
and c.sale_date<=to_date('${end_date}','yyyy-mm-dd')
left join dm_stock_shop_day d
on a.area_code=d.area_code
--and a.cus_code=d.cus_code
and a.goods_code=d.goods_code
and d.stock_qty>0
left join dim_goods f
on a.goods_code=f.goods_code
left join dim_illness_catalogue g
on a.goods_code=g.goods_code
and a.ill_type=g.ill_type
where a.area_code=b.area_code
and a.area_code=e.area_code
and a.cus_code=e.cus_code
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and b.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
group by b.union_area_name,a.area_code,b.area_name,a.ill_type,a.goods_code,f.goods_name,f.specification,f.manufacturer,g.func
order by a.area_code,a.goods_code

select a.area_code,a.area_name from dim_region a 
where 
 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1

select distinct a.UNION_AREA_NAME,a.area_code from dim_region a 
order by area_code

select distinct ill_type from dim_illness_core_catalogue

select distinct a.goods_code,a.goods_code||'|'||b.goods_name as goods_name from dim_illness_core_catalogue a,dim_goods b
where  a.goods_code=b.goods_code

select b.union_area_name 合并区域,a.area_code 区域编码,b.area_name 区域名称,a.ill_type 病种,
a.goods_code 商品编码,f.goods_name 商品名称,f.specification 规格,f.manufacturer 生产厂家,g.func 功能主治,
count(distinct a.cus_code)备货门店数,count(distinct c.cus_code)动销门店数,count(distinct d.cus_code)有库存门店数
from dim_region b,dim_cus e ,dim_illness_catalogue g,dim_goods f,dim_illness_core_catalogue a
left join fact_sale c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
and a.goods_code=c.goods_code
and c.sale_date>=to_date('${start_date}','yyyy-mm-dd')
and c.sale_date<=to_date('${end_date}','yyyy-mm-dd')
left join dm_stock_shop_day d
on a.area_code=d.area_code
and a.cus_code=d.cus_code
and a.goods_code=d.goods_code
and d.stock_qty>0


where a.area_code=b.area_code
and a.area_code=e.area_code
and a.cus_code=e.cus_code
and a.goods_code=g.goods_code
and a.ill_type=g.ill_type
and a.goods_code=f.goods_code
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and b.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
group by b.union_area_name,a.area_code,b.area_name,a.ill_type,a.goods_code,f.goods_name,f.specification,f.manufacturer,g.func
order by a.area_code,a.goods_code

select area_code,goods_code,count(distinct cus_code)有库存门店数 from dm_stock_shop_day
where stock_qty>0
group by  area_code,goods_code

select area_code,goods_code,sum(stock_qty)大仓库存数量 from  dm_stock_general_day
group by  area_code,goods_code

select area_code,goods_code,count(distinct cus_code)动销门店数 from fact_sale
where sale_date>=to_date('${start_date}','yyyy-mm-dd')
and sale_date<=to_date('${end_date}','yyyy-mm-dd')
group by  area_code,goods_code

