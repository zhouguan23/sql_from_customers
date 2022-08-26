select b.union_area_name area_name, sum(
case when RELATED_PARTY_TRNSACTION = '否' then no_tax_amount else 0 end ) no_tax_amount,
sum(no_tax_amount-no_tax_cost) 毛利
  from dm_monthly_company a, dim_region b
 where 1=1
 AND   a.area_code = b.area_code 
   AND SALE_DATE >= date '${AFTER1}'
   AND SALE_DATE <= date '${AFTER2}'
   ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
  ${if(len(rate)=0,"","and decode(tax_rate,0.03,0.03,0)='"+rate+"'")} 
  ${if(len(rpt)=0,"","and a.RELATED_PARTY_TRNSACTION='"+rpt+"'")}
  -- AND RELATED_PARTY_TRNSACTION = '否'
 group by b.union_area_name
 order by 1

select b.union_area_name area_name, sum(
case when RELATED_PARTY_TRNSACTION = '否' then no_tax_amount else 0 end ) no_tax_amount,
sum(no_tax_amount-no_tax_cost) 毛利
  from dm_monthly_company a, dim_region b
 where 1=1
   and a.area_code = b.area_code
   AND SALE_DATE >= add_months(date '${AFTER1}',-12)
   AND SALE_DATE <= add_months(date '${AFTER2}',-12)
    ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
    ${if(len(rate)=0,"","and decode(tax_rate,0.03,0.03,0)='"+rate+"'")} 
    ${if(len(rpt)=0,"","and a.RELATED_PARTY_TRNSACTION='"+rpt+"'")}
  -- AND RELATED_PARTY_TRNSACTION = '否'
 group by b.union_area_name

SELECT  
DISTINCT 
UNION_AREA_NAME
FROM 
DIM_REGION
where union_area_name is not null 
 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1

select b.union_area_name as 区域名称, a.create_month as 月份, sum(a.value) as 指标值
  from fact_sale_index a
 left join dim_region b
    on a.area_code = b.area_code
   where a.create_month = to_char(date'${AFTER1}','yyyy')
    ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
    group by b.union_area_name,a.create_month

select b.union_area_name area_name, sum(
case when RELATED_PARTY_TRNSACTION = '否' then no_tax_amount else 0 end ) no_tax_amount,
sum(no_tax_amount-no_tax_cost) 毛利
  from dm_monthly_company a, dim_region b
 where 1=1
   and a.area_code = b.area_code
   AND SALE_DATE >= date '${AFTER1}'
   AND SALE_DATE <= date '${AFTER2}'
   and dtp='否'
  -- AND RELATED_PARTY_TRNSACTION = '否'
    ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
    ${if(len(rate)=0,"","and decode(tax_rate,0.03,0.03,0)='"+rate+"'")} 
    ${if(len(rpt)=0,"","and a.RELATED_PARTY_TRNSACTION='"+rpt+"'")}
 group by b.union_area_name

select b.union_area_name area_name, sum(
case when RELATED_PARTY_TRNSACTION = '否' then no_tax_amount else 0 end ) no_tax_amount,
sum(no_tax_amount-no_tax_cost) 毛利
  from dm_monthly_company a, dim_region b
 where 1=1
   and a.area_code = b.area_code
   AND SALE_DATE >= add_months(date '${AFTER1}',-12)
   AND SALE_DATE <= add_months(date '${AFTER2}',-12)
   and dtp='否'
    ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
    ${if(len(rate)=0,"","and decode(tax_rate,0.03,0.03,0)='"+rate+"'")} 
    ${if(len(rpt)=0,"","and a.RELATED_PARTY_TRNSACTION='"+rpt+"'")}
  -- AND RELATED_PARTY_TRNSACTION = '否'
 group by b.union_area_name

select b.union_area_name area_name, sum(
case when RELATED_PARTY_TRNSACTION = '否' then no_tax_amount else 0 end ) no_tax_amount,
sum(no_tax_amount-no_tax_cost) 毛利
  from dm_monthly_company a, dim_region b
 where 1=1
 and a.area_code = b.area_code 
   AND SALE_DATE >=trunc( date '${AFTER1}','yyyy')
   AND SALE_DATE <= date '${AFTER2}'
   ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")} 
   ${if(len(rate)=0,"","and decode(tax_rate,0.03,0.03,0)='"+rate+"'")} 
   ${if(len(rpt)=0,"","and a.RELATED_PARTY_TRNSACTION='"+rpt+"'")}
  -- AND RELATED_PARTY_TRNSACTION = '否'
 group by b.union_area_name
 order by 1

