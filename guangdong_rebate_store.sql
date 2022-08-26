with a as
 (select goods_code,
         goods_name,
         cus_code， cus_name,
         area_code,
         sum(no_tax_amount) no_tax_amount,
         sum(sale_qty) sale_qty,
         sum(no_tax_cost) no_tax_cost,
         sum(no_tax_price) no_tax_price ， new_attribute
    from (select c.goods_code,
                 c.goods_name,
                 a.area_code,
                 d.cus_code,
                 d.cus_name,
                 sum(a.no_tax_amount) no_tax_amount,
                 sum(a.sale_qty) sale_qty,
                 sum(a.no_tax_cost) no_tax_cost， avg(a.no_tax_cost / a.sale_qty) no_tax_price,
                 nvl2(e.goods_code, '是', '否') dtp,
                 g.oto,
                 nvl(f.new_attribute, '地采') new_attribute
            from fact_sale                     a,
                 store                         b,
                 dim_goods                     c,
                 dim_cus                       d,
                 dim_dtp                       e,
                 dim_net_catalogue_general_all f,
                 gygd_bi.dim_marketing         g
           where SALE_DATE >= date '${AFTER1}'
             AND SALE_DATE <= date '${AFTER2}'
             and a.sale_qty > 0
             and a.cus_code = to_char(b.store)
             and a.goods_code = c.goods_code
             and a.area_code = d.area_code
             and a.cus_code = d.cus_code
             and a.goods_code = e.goods_code(+)
             and a.area_code = e.area_code(+)
             and a.goods_code = f.goods_code(+)
             and a.area_code = f.area_code(+)
             and a.marketing_code = g.marketing_code
             and to_char(add_months(a.sale_date, -1), 'yyyy-mm') =
                 e.create_month(+)
             and to_char(a.sale_date, 'yyyy-mm') = f.create_month(+)
             and d.attribute = '直营'
             and b.region in ('106', '107')
           group by c.goods_code,
                    c.goods_name,
                    a.area_code,
                    nvl2(e.goods_code, '是', '否'),
                    g.oto,
                    nvl(f.new_attribute, '地采'),
                    d.cus_code,
                    d.cus_name)
   where 1 = 1
  ${if(len(dtp) = 0, "", "and dtp ='" + dtp + "'") }
  ${if(len(oto) = 0, "", "and oto ='" + oto + "'") }
  ${if(len(new_attribute) = 0, "", "and new_attribute in ('" + new_attribute + "')")}
   group by goods_code,
            goods_name，new_attribute,
            cus_code,
            cus_name,
            area_code),
b as
 (
  --批发配送
  select c.goods_code,
          c.goods_name,
          sum(a.no_tax_amount) no_tax_amount_b,
          sum(a.delivery_qty) delivery_qty_b,
          sum(a.no_tax_cost) no_tax_cost_b， avg(a.no_tax_cost / a.delivery_qty) no_tax_price_b
    from fact_delivery a, dim_goods c
   where SALE_DATE >= add_months(date '${AFTER1}',-2)
     AND SALE_DATE <= date '${AFTER2}'
     and a.delivery_qty > 0
     and a.goods_code = c.goods_code
     and a.delivery_type = '批发'
     and a.cus_code in ('200249', '200250')
   group by c.goods_code, c.goods_name)
select cus_code,
       cus_name,
       age_store,
       area_code,
       area_name,
       sum(no_tax_amount),
       sum(sale_qty),
       sum(no_tax_cost),
       sum(no_tax_price),
       sum(case
             when no_tax_amount_b = 0 then
              no_tax_amount - no_tax_cost
             else
              no_tax_amount - sale_qty * no_tax_price_b
           end) qtfl
  from (select a.goods_code,
               a.goods_name,
               a.cus_code,
               a.cus_name,
               d.age_store,
               a.area_code,
               c.area_name,
               nvl(a.no_tax_amount, 0) no_tax_amount,
               nvl(a.sale_qty, 0) sale_qty,
               nvl(a.no_tax_cost, 0) no_tax_cost,
               nvl(a.no_tax_price, 0) no_tax_price,
               a.new_attribute， nvl(b.no_tax_amount_b, 0) no_tax_amount_b,
               nvl(delivery_qty_b, 0) delivery_qty_b,
               nvl(no_tax_cost_b, 0) no_tax_cost_b,
               nvl(no_tax_price_b, 0) no_tax_price_b
          from a, b, dim_region c，age_store d
         where a.goods_code = b.goods_code(+)
           and a.area_code = c.area_code
           and a.area_code = d.area_code
           and a.cus_code = d.cus_code
           and date1 = '${date1}')
 group by cus_code, cus_name, area_code, area_name, age_store

select distinct new_attribute from dim_net_catalogue_general_all
union
select '地采' as new_attribute from dual

