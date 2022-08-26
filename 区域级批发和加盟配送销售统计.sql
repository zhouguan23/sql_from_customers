select a.area_code,
       --a.attribute,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', no_tax_amount, 0)) 
         else
          sum(no_tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
         else
          sum(no_tax_amount) - sum(no_tax_cost)
       end as 毛利额
  from dm_monthly_company a,dim_region b 
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >= date '${start_date}'
   and a.sale_date <= date '${end_date}'
   and a.attribute in ('加盟', '批发')
   and a.area_code=b.area_code
   ${if(len(area)=0, "", " and b.area_code in ('" + area + "')")}
   ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")}
 group by a.area_code
--a.attribute
 order by a.area_code

select a.area_code,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', no_tax_amount, 0)) 
         else
          sum(no_tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
         else
          sum(no_tax_amount) - sum(no_tax_cost)
       end as 毛利额
  from dm_monthly_company a
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12)
   and a.attribute in ('加盟', '批发')
 group by a.area_code
 order by a.area_code

select a.area_code,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', no_tax_amount, 0)) 
         else
          sum(no_tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', no_tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', no_tax_cost, 0))
         else
          sum(no_tax_amount) - sum(no_tax_cost)
       end as 毛利额
  from dm_monthly_company a
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >= date '${start_date2}'
   and a.sale_date <= date '${end_date2}'
   and a.attribute in ('加盟', '批发')
 group by a.area_code
 order by a.area_code

select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
   ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
   ${if(len(UNION_AREA)=0,"","and  UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code

select a.area_code,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', tax_amount, 0)) 
         else
          sum(tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', tax_cost, 0))
         else
          sum(tax_amount) - sum(tax_cost)
       end as 毛利额
  from dm_monthly_company a
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >=add_months(date '${start_date}',-12)
   and a.sale_date <=add_months(date '${end_date}',-12)
   and a.attribute in ('加盟', '批发')
 group by a.area_code
 order by a.area_code

select a.area_code,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', tax_amount, 0)) 
         else
          sum(tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', tax_cost, 0))
         else
          sum(tax_amount) - sum(tax_cost)
       end as 毛利额
  from dm_monthly_company a
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >= date '${start_date}'
   and a.sale_date <= date '${end_date}'
   and a.attribute in ('加盟', '批发')
 group by a.area_code
 order by a.area_code

select a.area_code,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) 
          when '${rpt}' = '否' then
          sum(decode(related_party_trnsaction, '否', tax_amount, 0)) 
         else
          sum(tax_amount) 
       end as  销售额,
       case
         when '${rpt}' = '是' then
          sum(decode(related_party_trnsaction, '是', tax_amount, 0)) -
          sum(decode(related_party_trnsaction, '是', tax_cost, 0))
         else
          sum(tax_amount) - sum(tax_cost)
       end as 毛利额
  from dm_monthly_company a
 where 1 = 1
      ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
      ${if(len(attribute)=0,"","and a.ATTRIBUTE IN ('"+attribute+"')")}
      ${if(len(area)=0,""," and a.area_Code in ('"+area+"')")}
   and a.sale_date >= date '${start_date2}'
   and a.sale_date <= date '${end_date2}'
   and a.attribute in ('加盟', '批发')
 group by a.area_code
 order by a.area_code

with fsi as
 (select sum(target) 指标值, area_code
    from (select create_month, area_code, mem as target, '加盟' attribute
            from fact_sale_index
          union all
          select create_month, area_code, batch as target, '批发' attribute
            from fact_sale_index)
   where create_month = to_char(sysdate, 'yyyy')
     ${if(len(attribute)=0,"","and ATTRIBUTE IN ('"+attribute+"')")}
     ${if(len(area)=0,""," and area_Code in ('"+area+"')")}
   group by area_code),
sale as
 (select sum(decode(related_party_trnsaction, '是', 0, no_tax_amount)) 累计金额, dmc.area_code
    from dm_monthly_company dmc
   where dmc.sale_date between trunc(sysdate, 'yyyy') and trunc(sysdate) - 1
     and dmc.attribute in ('加盟', '批发')
     ${if(len(attribute)=0,"","and dmc.ATTRIBUTE IN ('"+attribute+"')")}
     ${if(len(area)=0,""," and dmc.area_Code in ('"+area+"')")}
   group by dmc.area_code)
select 累计金额,
       指标值,
       case
         when 指标值 = 0 then
          0
         else
          累计金额 / 指标值
       end 达成率,
       sale.area_code
  from sale, fsi
 where sale.area_code = fsi.area_code

with fsi as
 (select create_month, area_code, mem as target, '加盟' attribute
    from fact_sale_index
  union all
  select create_month, area_code, batch as target, '批发' attribute
    from fact_sale_index)
select sum(decode(related_party_trnsaction, 'Y', 0, no_tax_amount)) 累计金额,
       0 指标值,
       0 达成率,
       dmc.area_code
  from dm_monthly_company dmc, fsi
 where dmc.sale_date between trunc(sysdate, 'yyyy') and trunc(sysdate) - 1
   and dmc.area_code = fsi.area_code
   and fsi.create_month = to_char(sysdate, 'yyyy')
   and fsi.attribute = dmc.attribute
   and dmc.attribute in ('加盟', '批发')
  ${if(len(dtp)=0,"","and dmc.dtp ='"+dtp+"'")}
   ${if(len(attribute)=0,"","and dmc.ATTRIBUTE IN ('"+attribute+"')")}
  ${if(len(area)=0,""," and dmc.area_Code in ('"+area+"')")}
 group by dmc.area_code

select distinct union_area_name,area_name,area_code,trans_party_relation 
from dim_region
where 1=1 
order by area_code

