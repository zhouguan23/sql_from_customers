--当期销售
select a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
where  a.is_b2c='Y'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(CUS)=0, "", " and a.CUS_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
group by a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name
order by a.area_code,a.cus_code,a.marketing_code

--当期销售
select a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
where  a.is_b2c='Y'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and   a.sale_date >=add_months(date '${start_date}',-12)
 and a.sale_date <=add_months(date '${end_date}',-12)
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(CUS)=0, "", " and a.CUS_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
group by a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name
order by a.area_code,a.cus_code,a.marketing_code

--当期销售
select a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name,

(case when '${Tax}'='无税' then  sum(no_tax_amount) else  sum(tax_amount) end)  as 总销售金额,
(case when '${Tax}'='无税' then  sum(no_tax_amount) - sum(no_tax_cost) else sum(tax_amount) - sum(tax_cost) end) as 总销售毛利,
sum(sale_qty) 销售数量

from dm_goods_sale_payment a
left join dim_region b
on a.area_code=b.area_code
left join dim_cus c
on a.area_code=c.area_code
and a.cus_code=c.cus_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE and a.GOODS_CODE=d.GOODS_CODE
left join dim_marketing_all m
on decode(a.area_code,'16','15',a.area_code)=m.area_code
and a.marketing_code=m.marketing_code
where  a.is_b2c='Y'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date2}', 'yyyy-mm-dd') and
to_date('${end_date2}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and case when d.goods_code is not null then '是' else '否' end  ='"+dtp+"'")}
and 1=1 ${if(len(CUS)=0, "", " and a.CUS_code in ('" + area + "')")}
and 1=1 ${if(len(marketing)=0, "", " and a.marketing_code in ('" + marketing + "')")}
group by a.area_code,b.area_name,a.cus_code,c.cus_name,a.marketing_code,m.marketing_name
order by a.area_code,a.cus_code,a.marketing_code

select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
${if(len(area)=0, "", " and area_code in ('"+area+"')")}
${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code

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

select distinct marketing_code,marketing_name from dim_marketing_all
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}

