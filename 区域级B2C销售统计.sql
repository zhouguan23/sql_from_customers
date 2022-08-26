/*select distinct union_area_name,area_name,area_code,trans_party_relation from dim_region
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code*/
select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation from dim_region a,(select * from USER_AUTHORITY) b,(select distinct area_code from dm_monthly_company 
where sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd') and is_b2c='是') c
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and a.area_code=c.area_code
order by a.area_code

/*select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1,2*/

select union_area_name,to_char(wm_concat(area_code)) from dim_region
--where  trans_party_relation='Y'
group by union_area_name

--累计完成率
select a.area_code,c.area_name,
(case when '${Tax}'='无税' then SUM(a.NO_TAX_AMOUNT) ELSE SUM(a.TAX_AMOUNT) end) as 累计销售,
(case when '${Tax}'='无税' then  b.oto else null end )as 销售指标,
(case when b.oto=0 then null when '${Tax}'='无税' then SUM(a.NO_TAX_AMOUNT)/b.oto ELSE SUM(a.TAX_AMOUNT)/b.oto end) as 累计完成率
from DM_MONTHLY_COMPANY a,FACT_SALE_INDEX b,dim_region c
where a.area_code=b.area_code
and to_char(a.sale_date,'YYYY')=b.create_month
and a.area_code=c.area_code
and TO_CHAR(SALE_DATE,'YYYY') =TO_CHAR(sysdate,'YYYY')
and a.RELATED_PARTY_TRNSACTION != '是'
group by a.area_code,b.oto,c.area_name
order by 1

--当期销售
select a.area_code,b.area_name,
--(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 总销售金额,
--(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 总销售毛利

(case when '${Tax}'='无税' then (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end )else sum(tax_amount)end)end)  as 总销售金额,
(case when '${Tax}'='无税'  then (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) else sum(no_tax_amount) - sum(no_tax_cost) end)  ELSE (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) else sum(tax_amount) - sum(tax_cost) end) end) as 总销售毛利

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and a.is_b2c='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}

group by a.area_code,b.area_name
order by a.area_code

--同期销售
select a.area_code,b.area_name,
--(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
--(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 毛利额

(case when '${Tax}'='无税' then (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end )else sum(tax_amount)end)end)  as 销售额,
(case when '${Tax}'='无税'  then (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) else sum(no_tax_amount) - sum(no_tax_cost) end)  ELSE (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) else sum(tax_amount) - sum(tax_cost) end) end) as 毛利额

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and a.is_b2c='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}

group by a.area_code,b.area_name
order by a.area_code

--对比期销售
select a.area_code,b.area_name,
--(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
--(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 毛利额

(case when '${Tax}'='无税' then (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end )else sum(tax_amount)end)end)  as 销售额,
(case when '${Tax}'='无税'  then (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) else sum(no_tax_amount) - sum(no_tax_cost) end)  ELSE (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) else sum(tax_amount) - sum(tax_cost) end) end) as 毛利额

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and a.is_b2c='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}

group by a.area_code,b.area_name
order by a.area_code

select area_code,
(case when '${Tax}'='无税' then (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end )else sum(tax_amount)end)end)  as 销售额,
(case when '${Tax}'='无税'  then (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) else sum(no_tax_amount) - sum(no_tax_cost) end)  ELSE (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) else sum(tax_amount) - sum(tax_cost) end) end) as 毛利额

--when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end ) else sum(no_tax_amount)end)as 销售额

from dm_monthly_company
where sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
--and 1=1 ${if(len(RELATED)=0,"","and related_party_trnsaction  ='"+RELATED+"'")}
group by area_code
order by 1

--累计完成率
select c.UNION_AREA_NAME,
 SUM(a.NO_TAX_AMOUNT) as  累计销售,
 sum(b.value) as 销售指标,
(case when sum(b.value)=0 then null  ELSE SUM(a.NO_TAX_AMOUNT)/sum(b.value) end) as 累计完成率
from 
(select a.AREA_CODE,sum(a.NO_TAX_AMOUNT) as NO_TAX_AMOUNT
from DM_MONTHLY_COMPANY a
where to_char(a.sale_date,'YYYY')=TO_CHAR(sysdate,'YYYY')
and  a.RELATED_PARTY_TRNSACTION != '是'
group by a.AREA_CODE
) a
,FACT_SALE_INDEX b,dim_region c
where a.area_code=b.area_code
and to_char(sysdate,'YYYY')=b.create_month
and a.area_code=c.area_code

group by c.UNION_AREA_NAME


