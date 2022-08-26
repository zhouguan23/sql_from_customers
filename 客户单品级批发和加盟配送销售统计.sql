with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
           ${if(len(cus)=0,""," and b.cus_name in ('"+cus+"')")}
           and a.sale_date >= date '${start_date}'
           and a.sale_date <= date '${end_date}'
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
                 else
                  sum(no_tax_amount) - sum(no_tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
)
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer
                   order by 1,2,4


with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12)
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
                 else
                  sum(no_tax_amount) - sum(no_tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
         order by 1)
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
           and a.sale_date >= date '${start_date2}'
           and a.sale_date <= date '${end_date2}'
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', no_tax_amount, 0))
                 else
                  sum(no_tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
                 else
                  sum(no_tax_amount) - sum(no_tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
         order by 1)
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer


select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
${if(len(area)=0, "", " and area_code in ('"+area+"')")}
--${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12)
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', tax_amount, 0))
                 else
                  sum(tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', tax_cost, 0))
                 else
                  sum(tax_amount) - sum(tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
         order by 1)
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
           ${if(len(cus)=0,""," and b.cus_name in ('"+cus+"')")}
           and a.sale_date >= date '${start_date}'
           and a.sale_date <= date '${end_date}'
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', tax_amount, 0))
                 else
                  sum(tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', tax_cost, 0))
                 else
                  sum(tax_amount) - sum(tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
         )
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer
                   order by 1,2,4

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.goods_code,
         nvl(d.new_attribute, '地采') as gather,
         nvl2(c.goods_code, '是', '否') dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from fact_delivery                 a,
         dim_cus                       b,
         dim_dtp                       c,
         dim_net_catalogue_general_all d
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and b.attribute in ('加盟', '批发')
     and a.goods_code = c.goods_code(+)
     and a.area_code = c.area_code(+)
     and to_char(add_months(sale_date, -1), 'yyyy-mm') = c.create_month(+)
     and a.goods_code = d.goods_code(+)
     and a.area_code = d.area_code(+)
     and to_char(a.sale_date, 'yyyy-mm') = d.create_month(+)
           ${if(len(GOODS) = 0, "", " and a.GOODS_CODE IN ('" + GOODS + "') ") }
           ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
           ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
           and a.sale_date >= date '${start_date2}'
           and a.sale_date <= date '${end_date2}'
     )
select area_code,
       cus_code,
       cus_name,
       goods_code,
       goods_name,
       specification,
       manufacturer,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.goods_code,
               dg.goods_name,
               dg.specification,
               dg.manufacturer,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0))
                 when '${rpt}' = '否' then
                  sum(decode(related_party_trnsaction, '否', tax_amount, 0))
                 else
                  sum(tax_amount)
               end as 销售额,
               case
                 when '${rpt}' = '是' then
                  sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
                  sum(decode(related_party_trnsaction, '是', tax_cost, 0))
                 else
                  sum(tax_amount) - sum(tax_cost)
               end as 毛利额,
               sum(sale_qty) 销售数量
          from ddt, dim_goods dg
         where ddt.goods_code = dg.goods_code
           ${if(len(gather)=0,"","and ddt.gather in ('"+gather+"')")}
           ${if(len(dtp)=0,"","and ddt.dtp ='"+dtp+"'")}
         group by ddt.area_code,
                  ddt.cus_code,
                  ddt.cus_name,
                  ddt.goods_code,
                  dg.goods_name,
                  dg.specification,
                  dg.manufacturer
         order by 1)
 group by area_code,
          cus_code,
          cus_name,
          goods_code,
          goods_name,
          specification,
          manufacturer


/*select distinct substr(cus_code, 1, 6) cus_code, cus_name, area_code, attribute,substr(cus_code, 1, 6) || '|' || cus_name as sname
  from (select distinct cus_code, cus_name, area_code, attribute
          from dim_cus
          where attribute in ('批发','加盟')
        union all
        select distinct substr(a.cus_code, 1, 6) cus_code,
                        b.wf_customer_name,
                        a.area_code,
                        a.attribute
          from dim_cus a, wf_customer b
         where substr(a.cus_code, 1, 6) = to_char(b.wf_customer_id)
           and not exists (select *
                  from dim_cus c
                 where substr(a.cus_code, 1, 6) = c.cus_code
                   and a.area_code = c.area_code))
 where 1 = 1
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
${if(len(ATTRIBUTE)=0,"","and ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
order by 3,1
*/
select area_code,cus_name,substr(cus_code, 1, 6) || '|' || cus_name as sname
  from dim_cus
 where attribute in ('批发', '加盟')
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(cus)=0,""," and cus_name in ('"+cus+"')")}
${if(len(ATTRIBUTE)=0,"","and ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
order by 1

