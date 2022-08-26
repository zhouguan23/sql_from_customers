select distinct ill_type from dim_illness_core_catalogue

select distinct a.goods_code,substr(a.goods_code||'|'||b.goods_name|| '|' ||item_desc_secondary|| '|' ||
                b.specification || '|' || b.manufacturer,1,40) as goods_name from dim_illness_core_catalogue a,dim_goods b
where  a.goods_code=b.goods_code
order by 1

select b.union_area_name as 合并区域,
       b.area_name as 区域名称,
       a.area_code,
       a.cus_code as 门店编码,
       c.cus_name as 门店名称,
       a.ill_type as 病种,
       a.goods_code 应备商品编码,
       dg.goods_name 应备商品名称,
       dg.specification 规格,
       dg.manufacturer 生产厂家,
       ds.stock_qty 实际库存数量,
       sum(fs.sale_qty) 销售数量,
       sum(fs.tax_amount) 销售含税金额,
       sum(nvl(fs.tax_amount,0)-nvl(fs.tax_cost,0))销售含税毛利额
       
from dim_region b,dim_cus c ,dim_goods dg,(select * from USER_AUTHORITY)  ua,dim_illness_core_catalogue a

left join dim_illness_catalogue di
on a.goods_code=di.goods_code
and a.ill_type=di.ill_type

left join fact_sale fs
on fs.area_code=a.area_code
and fs.cus_code=a.cus_code
and fs.goods_code=a.goods_code
and fs.sale_date>=to_date('${start_date}','yyyy-mm-dd')
and fs.sale_date<=to_date('${end_date}','yyyy-mm-dd')

left join (select area_code,cus_code,goods_code,sum(stock_qty)as stock_qty  
from dm_stock_shop_day 
group by area_code,cus_code,goods_code)ds
on  ds.area_code=a.area_code
and ds.cus_code=a.cus_code
and ds.goods_code=a.goods_code

where a.area_code=b.area_code
and a.area_code=c.area_code
and a.cus_code=c.cus_code
and a.goods_code=dg.goods_code
and (b.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}


and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and b.union_area_name in ('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
and 1=1 ${if(len(func)=0,""," and di.func in ('"+func+"')")}

group by b.union_area_name,b.area_name,a.area_code,a.cus_code,c.cus_name,a.ill_type,ds.stock_qty,a.goods_code,dg.goods_name,dg.specification,dg.manufacturer
order by min(b.sorted),a.cus_code,a.goods_code

select distinct a.cus_code,a.cus_code||'|'||b.cus_name as cus_name from dim_illness_core_catalogue a,dim_cus b,dim_region c
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.area_code=c.area_code
and 1=1 ${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
and  1=1 ${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
order by a.cus_code

select distinct func from dim_illness_catalogue a,dim_illness_core_catalogue b
where a.goods_code=b.goods_code
and a.ill_type=b.ill_type
and 1=1 ${if(len(ill_type)=0,""," and a.ill_type in ('"+ill_type+"')")}

