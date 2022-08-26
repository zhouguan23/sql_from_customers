select goods_code,
       goods_name,
       sum(no_tax_amount),
       sum(sale_qty),
       sum(no_tax_cost),
       sum(no_tax_price)，
       new_attribute
  from (select c.goods_code,
               c.goods_name,
               sum(a.no_tax_amount) no_tax_amount,
               sum(a.sale_qty) sale_qty,
               sum(a.no_tax_cost) no_tax_cost, sum(a.no_tax_cost) / decode(sum(a.sale_qty), 0, 1, sum(a.sale_qty)) no_tax_price, nvl2(e.goods_code, '是', '否') dtp,
               nvl(f.new_attribute, '地采') new_attribute
          from fact_sale                     a,
               store                         b,
               dim_goods                     c,
               dim_cus                       d,
               dim_dtp                       e,
               dim_net_catalogue_general_all f
         where SALE_DATE >= date '${AFTER1}'
           AND SALE_DATE <= date '${AFTER2}'
           and a.cus_code = to_char(b.store)
           and a.goods_code = c.goods_code
           and a.area_code = d.area_code
           and a.cus_code = d.cus_code
           and a.goods_code = e.goods_code(+)
           and a.area_code = e.area_code(+)
           and a.goods_code = f.goods_code(+)
           and a.area_code = f.area_code(+)
           and a.sale_qty>0
           and to_char(add_months(a.sale_date, -1), 'yyyy-mm') =
               e.create_month(+)
            and to_char(a.sale_date, 'yyyy-mm') = f.create_month(+)
           and d.attribute = '直营'
           and b.region in ('106', '107')
         group by c.goods_code,
                  c.goods_name,nvl2(e.goods_code, '是', '否') , nvl(f.new_attribute, '地采'))
 where 1 = 1
   ${if(len(dtp) = 0, "", "and dtp ='" + dtp + "'") }
   ${if(len(new_attribute) = 0, "", "and new_attribute in ('" + new_attribute + "')")}
 group by goods_code, goods_name，new_attribute

--批发配送
select c.goods_code,
       c.goods_name,
       sum(a.no_tax_amount),
       sum(a.delivery_qty),
       sum(a.no_tax_cost)，
       sum(a.no_tax_cost) / decode(sum(a.delivery_qty), 0, 1, sum(a.delivery_qty)) no_tax_price from fact_delivery a, dim_goods c
 where SALE_DATE >= date '${AFTER1}'
   AND SALE_DATE <= date '${AFTER2}'
   and a.goods_code = c.goods_code
   and a.delivery_qty > 0
   and a.delivery_type='批发'
   and a.cus_code in ('200249','200250')
   group by  c.goods_code,c.goods_name

--加盟配送
select c.goods_code,
       c.goods_name,
       sum(a.no_tax_amount),
       sum(a.delivery_qty),
       sum(a.no_tax_cost) ， sum(a.no_tax_cost) / decode(sum(a.delivery_qty), 0, 1, sum(a.delivery_qty)) no_tax_price
  from fact_delivery a, store b, dim_goods c
 where SALE_DATE >= date '${AFTER1}'
   AND SALE_DATE <= date '${AFTER2}'
   and a.cus_code = to_char(b.store)
   and a.goods_code = c.goods_code
   and a.delivery_type = '加盟'
   and a.delivery_qty > 0
   and b.region in  ('106','107')
 group by c.goods_code, c.goods_name

select max(TRAN_DATE) order_date,
       a.item goods_code， d.region area_code,
       decode(sum(UNITS), 0, 0, (sum(TOTAL_COST) / sum(UNITS))) NO_TAX_PRICE
  from CMX_ARIF_HISTORY a,
       (select distinct ORDER_NO, SUPPLIER, written_date from CMX_ORDER) b,
       dim_storage c,
       ZUX_REGION_OU d
 where a.TRAN_CODE = '20'
   and a.TRAN_DATE >= add_months(date '${AFTER2}',-6)
   and a.TRAN_DATE <= date '${AFTER2}'
   and a.REF_NO_1 = b.ORDER_NO
   and d.ORG_UNIT_ID = C.ORG_UNIT_ID
   and to_char(a.location) = c.storage_code
   and d.brancode != '19'
   and d.region in ('105', '106')
 group by a.item， d.region


select distinct new_attribute from dim_net_catalogue_general_all
union
select '地采' as new_attribute from dual

