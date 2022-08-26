--全国top
with sale as
 (select purchase as area_name,
         region,
         sales_scale,
         province,
         sum(tax_amount) as tax_amount,
         sum(tax_amount) - sum(tax_cost) as ml,
         sum(qty) qty,
         a.goods_code,
         a.goods_name,
         a.specification,
         a.manufacturer,
         dtp
--         gather,
--         composition,
--         dosage_form
    from dm_purchase_sale_region a,dim_goods b
   where a.sale_date between date'${start_date}' and date'${end_date}'
     and a.attribute = '直营'
     and a.goods_code <> '0'
     and a.goods_code not like '6%'
     and a.goods_code=b.goods_code
      ${if(len(cate)=0,"","and  b.sub_CATEGORY in ('"+cate+"')")}
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(gather)=0,""," and a.gather in ('"+gather+"')")}
      ${if(len(goods)=0,""," and a.goods_code in ('"+goods+"')")}
      ${if(len(composition)=0,""," and a.composition in ('"+composition+"')")}
      ${if(len(dosage_form)=0,""," and a.dosage_form in ('"+dosage_form+"')")}
   group by purchase,
            region,
            sales_scale,
            province,
            a.goods_code,
            a.goods_name,
            a.specification,
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
         a.order_date,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and order_date between date'${start_date}' and date'${end_date}'
     and a.area_code = b.area_code
     and order_qty > = 0
     and tax_price > 0.01),
--区域
f1 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
--全国
f2 as
 (select a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--地区
f3 as
 (select a.region,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, region order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--省
f4 as
 (select a.province,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.province,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, province order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--采购规模
f5 as
 (select a.sales_scale,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.sales_scale,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, sales_scale order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1)
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
       f1.price           as f1,
       f1.supplier_name   as s1,
       f1.order_date      as o1,
       f1.purchase        as p1,
       f2.price           as f2,
       f2.supplier_name   as s2,
       f2.order_date      as o2,
       f2.purchase        as p2,
       f3.price           as f3,
       f3.supplier_name   as s3,
       f3.order_date      as o3,
       f3.purchase        as p3,
       f4.price           as f4,
       f4.supplier_name   as s4,
       f4.order_date      as o4,
       f4.purchase        as p4,
       f5.price           as f5,
       f5.supplier_name   as s5,
       f5.order_date      as o5,
       f5.purchase        as p5
  from sale, rn, f1, f2, f3, f4, f5
 where sale.goods_code = rn.goods_code
   and sale.area_name = f1.purchase(+)
   and sale.goods_code = f1.goods_code(+)
   and sale.goods_code = f2.goods_code(+)
   and sale.region = f3.region(+)
   and sale.goods_code = f3.goods_code(+)
   and sale.province = f4.province(+)
   and sale.goods_code = f4.goods_code(+)
   and sale.sales_scale = f5.sales_scale(+)
   and sale.goods_code = f5.goods_code(+)
   ${if(len(purchase)=0,""," and sale.area_name in ('"+purchase+"')")}
   and rank <= '${rank}'
 order by 1, 2

with rn as
 (select purchase as area_name,
         a.goods_code,
         region,
         sales_scale,
         province,
         a.goods_name,
         a.specification,
         a.manufacturer,
         dtp,
--         gather,
--         composition,
--         dosage_form,
         sum(tax_amount) as tax_amount,
         sum(tax_amount) - sum(tax_cost) ml,
         sum(qty) qty,
         row_number() over(partition by purchase order by sum(tax_amount) desc) rank
    from dm_purchase_sale_region a,dim_goods b
   where a.sale_date between date '${start_date}' and date
   '${end_date}'
   and a.goods_code=b.goods_code
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
            purchase,
            a.goods_code,
            region,
            sales_scale,
            province,
            a.goods_name,
            a.specification,
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
         a.order_date,
         b.region,
         b.purchase,
         b.province,
         b.sales_scale
    from fact_purchase a, dim_region b
   where procurement_type = '采进'
     and order_date between date '${start_date2}' and date
   '${end_date2}'
     and a.area_code = b.area_code
     and order_qty > = 0
     and tax_price > 0.01),
--区域
f1 as
 (select a.purchase,
         a.region,
         a.province,
         a.sales_scale,
         a.goods_code,
         a.tax_price as price,
         a.order_date,
         a.supplier_name
    from (select a.goods_code,
                 a.tax_price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.province,
                 a.sales_scale,
                 a.supplier_name,
                 row_number() over(partition by purchase, goods_code order by order_date desc nulls last) rn
            from fp a
           where a.goods_code <> '0') a
   where rn = 1),
--全国
f2 as
 (select a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--地区
f3 as
 (select a.region,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.region,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, region order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--省
f4 as
 (select a.province,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.province,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, province order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1),
--采购规模
f5 as
 (select a.sales_scale,
         a.goods_code,
         a.price,
         a.order_date,
         a.purchase,
         a.supplier_name
    from (select a.goods_code,
                 a.price,
                 a.order_date,
                 a.sales_scale,
                 a.purchase,
                 a.supplier_name,
                 row_number() over(partition by goods_code, sales_scale order by price nulls last) rn
            from f1 a
           where a.goods_code <> '0') a
   where rn = 1)
select rn.*,
       f1.price         as f1,
       f1.supplier_name as s1,
       f1.order_date    as o1,
       f1.purchase      as p1,
       f2.price         as f2,
       f2.supplier_name as s2,
       f2.order_date    as o2,
       f2.purchase      as p2,
       f3.price         as f3,
       f3.supplier_name as s3,
       f3.order_date    as o3,
       f3.purchase      as p3,
       f4.price         as f4,
       f4.supplier_name as s4,
       f4.order_date    as o4,
       f4.purchase      as p4,
       f5.price         as f5,
       f5.supplier_name as s5,
       f5.order_date    as o5,
       f5.purchase      as p5
  from rn, f1, f2, f3, f4, f5
 where rn.area_name = f1.purchase(+)
   and rn.goods_code = f1.goods_code(+)
   and rn.goods_code = f2.goods_code(+)
   and rn.region = f3.region(+)
   and rn.goods_code = f3.goods_code(+)
   and rn.province = f4.province(+)
   and rn.goods_code = f4.goods_code(+)
   and rn.sales_scale = f5.sales_scale(+)
   and rn.goods_code = f5.goods_code(+)
   and rank <= '${rank}'
 order by 1, 2

select  distinct gather from dm_purchase_group_by_area

select distinct composition from dim_goods

select distinct dosage_form from dim_goods

select distinct purchase from dim_region

select distinct sub_category from dim_goods where sub_category is not null

