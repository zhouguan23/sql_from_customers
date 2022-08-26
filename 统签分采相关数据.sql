 select 
  d.ORDER_NUMBER,
 d.order_date,
 d.area_code,
 	a.area_name 区域,
       a.union_area_name 合并区域,
       c.goods_code 商品代码,
       b.goods_name 品名,
       b.specification 规格,
       b.manufacturer 厂家,
       d.order_qty 区域外采数量,
       c.no_tax_amount 区域外采金额,
       d.no_tax_amount/d.order_qty 区域外采价格,
       d.supplier_name 区域外采供应商
from 
(select a.area_code,a.goods_code,a.supplier_code,sum(a.no_tax_amount) as no_tax_amount
from fact_purchase a,dim_net_catalogue_general3 b 
 where a.area_code=b.area_code
and a.goods_code=b.goods_code
and b.cp_type in ('统签分采','统采直送')
and to_char(a.order_date,'yyyy-mm')=b.create_month
and 1=1
${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1
${if(len(gcode)=0, "", " and a.goods_code in ('" + gcode + "')")}
and to_char(a.order_date,'yyyy-mm-dd') between'${start_date}' and '${end_date}'
group by a.area_code,a.goods_code,a.supplier_code 
) c,
dim_region a,dim_goods b,fact_purchase d,dim_net_catalogue_general3 e
where a.area_code=c.area_code
and b.goods_code=c.goods_code
and a.area_code=d.area_code
and b.goods_code=d.goods_code
and c.area_code=d.area_code
and c.goods_code=d.goods_code
and c.supplier_code=d.supplier_code
and e.area_code=d.area_code
and e.goods_code=d.goods_code
and e.cp_type in ('统签分采','统采直送')
and to_char(d.order_date,'yyyy-mm')=e.create_month
and 1=1
${if(len(area)=0, "", " and d.area_code in ('" + area + "')")}
and 1=1
${if(len(gcode)=0, "", " and b.goods_code in ('" + gcode + "')")}
and 1=1
${if(len(attribute)=0, "", " and b.commodity_attribute in ('" + attribute + "')")}
and to_char(d.order_date,'yyyy-mm-dd') between'${start_date}' and '${end_date}'
order by 1,4

select * from 
(select area_code,
        goods_code,
        supplier_code,
        order_date,
        no_tax_price,
        row_number()over(partition by goods_code,area_code order by order_date desc )rn
        from fact_purchase where area_code='00' and  no_tax_price>=0)t
        where t.rn=1
and 1=1
${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1
${if(len(gcode)=0, "", " and goods_code in ('" + gcode + "')")}
and to_char(order_date,'yyyy-mm-dd') between'${start_date}' and '${end_date}'

select area_code,area_name from dim_region

select 
goods_code,
goods_code||'|'||goods_name
from dim_goods
order by goods_code




select distinct commodity_attribute from dim_goods

