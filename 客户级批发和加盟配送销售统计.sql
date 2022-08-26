with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         c.union_area_name,
         b.attribute,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b, dim_region c
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
     and a.area_code = c.area_code
          ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
          ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
          ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
          ${if(len(cus)=0,""," and cus_name in ('"+cus+"')")}
          ${if(len(UNION_AREA)=0,"","and c.UNION_AREA_NAME in('"+UNION_AREA+"')")}
         and a.sale_date >= date '${start_date}'
         and a.sale_date <= date '${end_date}')
select area_code,
       union_area_name,
       cus_code,
       cus_name,
       attribute,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               ddt.union_area_name,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.attribute,
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
          from ddt
         group by ddt.area_code，ddt.cus_code,
                  ddt.cus_name,
                  ddt.attribute,
                  ddt.union_area_name)
 group by area_code, cus_code, cus_name, attribute, union_area_name
 order by 1, 2

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
        ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
        ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
        ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12)
        )
select area_code,
       cus_code,
       cus_name,
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
          from ddt
         group by ddt.area_code，ddt.cus_code, ddt.cus_name
         order by 1)
 group by area_code, cus_code, cus_name

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
        ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
        ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
        ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
        and a.sale_date >= date '${start_date2}'
        and a.sale_date <= date '${end_date2}')
select area_code,
       cus_code,
       cus_name,
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
          from ddt
         group by ddt.area_code，ddt.cus_code, ddt.cus_name
         order by 1)
 group by area_code, cus_code, cus_name

select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
${if(len(area)=0, "", " and area_code in ('"+area+"')")}
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
        ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
        ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
        ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12))
select area_code,
       cus_code,
       cus_name,
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
          from ddt
         group by ddt.area_code，ddt.cus_code, ddt.cus_name
         order by 1)
 group by area_code, cus_code, cus_name

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         c.union_area_name,
         b.attribute,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b, dim_region c
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
     and a.area_code = c.area_code
          ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
          ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
          ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
          ${if(len(cus)=0,""," and cus_name in ('"+cus+"')")}
          ${if(len(UNION_AREA)=0,"","and c.UNION_AREA_NAME in('"+UNION_AREA+"')")}
         and a.sale_date >= date '${start_date}'
         and a.sale_date <= date '${end_date}')
select area_code,
       union_area_name,
       cus_code,
       cus_name,
       attribute,
       sum(销售额) 销售额,
       sum(毛利额) 毛利额,
       sum(销售数量) 销售数量
  from (select ddt.area_code,
               ddt.union_area_name,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) =
                          substr(ddt.cus_code, 1, 6)),
                   cus_code) cus_code,
               ddt.cus_name,
               ddt.attribute,
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
          from ddt
         group by ddt.area_code，ddt.cus_code,
                  ddt.cus_name,
                  ddt.attribute,
                  ddt.union_area_name)
 group by area_code, cus_code, cus_name, attribute, union_area_name
 order by 1, 2

with ddt as
 (select a.area_code,
         a.cus_code,
         b.cus_name,
         a.sale_date,
         a.gather,
         a.dtp,
         a.no_tax_amount,
         a.no_tax_cost,
         a.delivery_qty sale_qty,
         a.tax_amount,
         a.tax_cost,
         a.delivery_type attribute,
         nvl(b.related_party_trnsaction, '否') related_party_trnsaction
    from dm_delivery_tmp a, dim_cus b
   where a.area_code = b.area_code
     and a.cus_code = b.cus_code
     and a.delivery_type in ('加盟', '批发')
     and b.attribute in ('加盟', '批发')
        ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
        ${if(len(attribute)=0,"","and a.delivery_type in ('"+attribute+"')")}
        ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
        and a.sale_date >= date '${start_date2}'
        and a.sale_date <= date '${end_date2}')
select area_code,
       cus_code,
       cus_name,
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
          from ddt
         group by ddt.area_code，ddt.cus_code, ddt.cus_name
         order by 1)
 group by area_code, cus_code, cus_name

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

