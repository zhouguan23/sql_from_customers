select a.area_code,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) = substr(a.cus_code, 1, 6)),
                   a.cus_code) cus_code,
               b.cus_name,
               b.attribute,
               sum(no_tax_amount) as no_tax_amount,
               sum(no_tax_cost) as no_tax_cost,
               sum(tax_amount) as tax_amount,
               sum(tax_cost) as tax_cost,
           --    nvl2(c.goods_code, 'Y', 'N') dtp,
              -- nvl2(b.related_party_trnsaction, 'Y', 'N') related_party_trnsaction,
               sum(a.no_tax_amount - a.no_tax_cost) wsml,
               sum(a.tax_amount - a.tax_cost) hsml
          from fact_delivery a, dim_dtp c, dim_cus b
         where b.attribute in ('加盟', '批发')
           and a.goods_code = c.goods_code(+)
           and a.area_code = c.area_code(+)
           and a.area_code = b.area_code
           and a.cus_code = b.cus_code
           and to_char(add_months(a.sale_date, -1), 'yyyy-mm') =
               c.create_month(+)
               ${if(len(vip)=0,""," and nvl(b.vip,'否') IN ('"+vip+"') ")}
               ${if(len(area_code)=0,""," and A.area_code in ('"+area_code+"')")} 
               ${if(len(cus_code)=0,""," and A.cus_code in ('"+cus_code+"')")} 
               ${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")} 
               ${if(len(dtp)=0,""," and nvl2(c.goods_code, 'Y', 'N') in ('"+dtp+"')")} 
               ${if(len(related_party_trnsaction)=0,""," and nvl2(b.related_party_trnsaction, 'Y', 'N') in ('"+related_party_trnsaction+"')")} 
           and a.sale_date between date '${start_date}' and date
         '${end_date}'
         group by a.area_code,
                  a.cus_code,
                  b.cus_name,
                  b.attribute
                  -- nvl2(c.goods_code, 'Y', 'N'),
                  --nvl2(b.related_party_trnsaction, 'Y', 'N')
order by 1,2,3

select distinct area_code,area_name from  dim_region 

select distinct cus_code, cus_name, area_code, attribute
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
${if(len(area_code)=0,""," and area_Code in ('"+area_code+"')")}
${if(len(cus_code)=0,""," and cus_code in ('"+cus_code+"')")}
order by 3,1
/*select distinct A.cus_code,B.cus_name from fact_delivery A left join dim_cus B
 on a.area_code=b.area_code and a.cus_code=b.cus_code
 where B.attribute IN ('加盟','批发') and 
${if(len(area_code)==0,"1=1","a.area_code in ('"+area_code+"')")}
and to_char(A.sale_date,'yyyy-mm')='${date}'
*/

