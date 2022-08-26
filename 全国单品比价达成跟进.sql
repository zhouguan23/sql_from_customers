with sale as
 (select decode(purchase, '上海零售', '上海地区', purchase) as area_name,
         region,
         sales_scale,
         province,
         sum(tax_amount) as tax_amount,
         sum(tax_amount) - sum(tax_cost) as ml,
         sum(qty) qty,
         a.goods_code,
         a.goods_name,
         b.specification,
         a.manufacturer,
         dtp
  --         gather,
  --         composition,
  --         dosage_form
    from dm_purchase_sale_region a, dim_goods b
   where a.sale_date   between date'${start_date}' and date'${end_date}'
     and a.attribute = '直营'
     and a.goods_code <> '0'
     and a.goods_code not like '6%'
     and a.goods_code = b.goods_code
       ${if(len(cate)=0,"","and  b.sub_CATEGORY in ('"+cate+"')")}
       ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
       ${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
       ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
       ${if(len(composition)=0,""," and a.composition in ('"+composition+"')")}
       ${if(len(dosage_form)=0,""," and a.dosage_form in ('"+dosage_form+"')")}
   group by decode(purchase, '上海零售', '上海地区', purchase),
            region,
            sales_scale,
            province,
            a.goods_code,
            a.goods_name,
            b.specification,
            a.manufacturer,
            dtp
  --            gather,
  --            composition,
  --            dosage_form
  ),
rn as
 (select goods_code,
         row_number() over(order by sum(tax_amount) desc nulls last) rank
    from sale
   group by goods_code),
fp as
 (select a.area_code,
         a.goods_code,
         a.tax_price,
         a.supplier_name,
         a.supplier_code,
         a.order_date,
         a.order_qty,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and order_date  between date'${start_date2}' and date'${end_date2}'
     and a.area_code = b.area_code
     and order_qty > = 0
     and tax_price > 0.01),
fp1 as
 (select a.area_code,
         a.goods_code,
         a.tax_price,
         a.supplier_name,
         a.supplier_code,
         a.order_date,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and a.area_code = b.area_code
     and order_date >=  date'${start_date2}' 
     and order_qty > = 0
     and tax_price > 0.01),
--区域(基准)
f1 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
f2 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
--   区域采购价（当前）
f3 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp1 a
           where a.goods_code <> '0') a
   where rn = 1),
f4 as
 (select a.goods_code,
         a.purchase,
         round(sum(a.order_qty * (d.price - a.tax_price))/10000,2) as mlts--换算成万元，保留小数点后两位
    from fp a, f1 c, f2 d
   where a.goods_code = c.goods_code
     and a.purchase = c.purchase
     and a.goods_code = d.goods_code
     and a.purchase = d.purchase
     and a.order_date between trunc(c.order_date, 'MM') and
         add_months(trunc(c.order_date, 'MM'), 1) - 1
   group by a.goods_code, a.purchase)
select sale.area_name,
       sale.goods_code,
       sale.region,
       sale.sales_scale,
       sale.province,
       sale.goods_name,
       sale.specification,
       sale.manufacturer,
       sale.tax_amount,
       sale.ml,
       sale.qty,
       f1.price           as f1,--区域采购价（基准）
       f1.supplier_name   as s1,
       f1.supplier_code   as sc1,
       f1.order_date      as o1,
       f1.purchase        as p1,
       f3.price           as f3,--区域采购价（当前）
       f3.supplier_name   as s3,
       f3.supplier_code   as sc3,
       f3.order_date      as o3,
       f3.purchase        as p3,
       round(f3.price/f1.price-1,1) as cgjtb,  --当前日期最后一次采购价/基准日期最后一次采购价-1
       f4.mlts
  from sale, rn, f1, f2, f3, f4
 where sale.goods_code = rn.goods_code
   and sale.area_name = f1.purchase(+)
   and sale.goods_code = f1.goods_code(+)
   and sale.area_name = f2.purchase(+)
   and sale.goods_code = f2.goods_code(+)
   and sale.area_name = f3.purchase(+)
   and sale.goods_code = f3.goods_code(+)
   and sale.area_name = f4.purchase(+)
   and sale.goods_code = f4.goods_code(+)
   ${if(len(purchase)=0,""," and sale.area_name in ('"+purchase+"')")}
    and rank <= '${rank}'
 order by 1, 2

--区域top
with rn as
 (select decode(purchase, '上海零售', '上海地区', purchase) as area_name,
         a.goods_code,
         region,
         sales_scale,
         province,
         a.goods_name,
         b.specification,
         a.manufacturer,
         dtp,
         --         gather,
         --         composition,
         --         dosage_form,
         sum(tax_amount) as tax_amount,
         sum(tax_amount) - sum(tax_cost) ml,
         sum(qty) qty,
         row_number() over(partition by decode(purchase, '上海零售', '上海地区', purchase) order by sum(tax_amount) desc) rank
    from dm_purchase_sale_region a, dim_goods b
   where a.sale_date  between date '${start_date}' and date   '${end_date}'
     and a.goods_code = b.goods_code
           ${if(len(cate)=0,"","and  b.sub_CATEGORY in ('"+cate+"')")}
           ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
           ${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
           ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
           ${if(len(composition)=0,""," and a.composition in ('"+composition+"')")}
           ${if(len(dosage_form)=0,""," and a.dosage_form in ('"+dosage_form+"')")}
           ${if(len(purchase)=0,""," and a.purchase in ('"+purchase+"')")}
     and attribute = '直营'
     and a.goods_code <> '0'
     and a.goods_code not like '6%'
   group by a.goods_code,
            decode(purchase, '上海零售', '上海地区', purchase),
            a.goods_code,
            region,
            sales_scale,
            province,
            a.goods_name,
            b.specification,
            a.manufacturer,
            dtp
  --            gather,
  --            composition,
  --            dosage_form
  ),
fp as
 (select a.area_code,
         a.goods_code,
         a.tax_price,
         a.supplier_name,
         a.supplier_code,
         a.order_date,
         a.order_qty,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and order_date between date'${start_date2}' and date'${end_date2}'
     and a.area_code = b.area_code
     and order_qty > = 0
     and tax_price > 0.01),
fp1 as
 (select a.area_code,
         a.goods_code,
         a.tax_price,
         a.supplier_name,
         a.supplier_code,
         a.order_date,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and a.area_code = b.area_code
     and order_date >= date'${start_date2}' 
     and order_qty > = 0
     and tax_price > 0.01),
--区域(基准)
f1 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
f2 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
--   区域采购价（当前）
f3 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_code,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_code,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp1 a
           where a.goods_code <> '0') a
   where rn = 1),
f4 as
 (select a.goods_code,
         a.purchase,
         round(sum(a.order_qty * (d.price - a.tax_price)) / 10000, 2) as mlts --换算成万元，保留小数点后两位
    from fp a, f1 c, f2 d
   where a.goods_code = c.goods_code
     and a.purchase = c.purchase
     and a.goods_code = d.goods_code
     and a.purchase = d.purchase
     and a.order_date between trunc(c.order_date, 'MM') and
         add_months(trunc(c.order_date, 'MM'), 1) - 1
   group by a.goods_code, a.purchase)
select rn.area_name,
       rn.goods_code,
       rn.region,
       rn.sales_scale,
       rn.province,
       rn.goods_name,
       rn.specification,
       rn.manufacturer,
       rn.tax_amount,
       rn.ml,
       rn.qty,
       f1.price as f1, --区域采购价（基准）
       f1.supplier_name as s1,
       f1.supplier_code as sc1,
       f1.order_date as o1,
       f1.purchase as p1,
       f3.price as f3, --区域采购价（当前）
       f3.supplier_name as s3,
       f3.supplier_code as sc3,
       f3.order_date as o3,
       f3.purchase as p3,
       round(f3.price / f1.price - 1, 1) as cgjtb, --当前日期最后一次采购价/基准日期最后一次采购价-1
       f4.mlts
  from rn, f1, f2, f3, f4
 where rn.area_name = f1.purchase(+)
   and rn.goods_code = f1.goods_code(+)
   and rn.area_name = f2.purchase(+)
   and rn.goods_code = f2.goods_code(+)
   and rn.area_name = f3.purchase(+)
   and rn.goods_code = f3.goods_code(+)
   and rn.area_name = f4.purchase(+)
   and rn.goods_code = f4.goods_code(+)
   ${if(len(purchase)=0,""," and rn.area_name in ('"+purchase+"')")}
   and rank <= '${rank}'

select  distinct gather from dm_purchase_group_by_area

select distinct composition from dim_goods

select distinct dosage_form from dim_goods

select distinct purchase from dim_region

select distinct sub_category from dim_goods where sub_category is not null

