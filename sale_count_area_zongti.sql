/*select distinct union_area_name,area_name,area_code,trans_party_relation from dim_region
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code*/
select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation,a.sorted from dim_region a,(select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}

and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}
--order by decode(a.area_code,'00','AA',a.union_area_name),a.area_code
order by sorted 
/*select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1,2*/

select union_area_name,to_char(wm_concat(area_code)) from dim_region
--where  trans_party_relation='Y'
group by union_area_name



--区域累计完成率剔除关联交易

select area_code,sum(累计销售)累计销售,sum(销售指标)销售指标,(case when sum(销售指标)=0 then null ELSE sum(累计销售)/sum(销售指标) end) as 累计完成率 from 
(select area_code,(case when '${Tax}'='无税' then SUM(NO_TAX_AMOUNT) ELSE SUM(TAX_AMOUNT) end) as 累计销售,0 销售指标 from dm_monthly_company
where to_char(sale_date,'YYYY')=to_char(sysdate,'YYYY')
and  RELATED_PARTY_TRNSACTION ='否'
group by area_code
union all
select area_code,0 累计销售, (case when '${Tax}'='无税' then sum(value) else null end )as 销售指标 from FACT_SALE_INDEX
where create_month=to_char(sysdate,'YYYY')
group by area_code)
group by area_code

--当期销售
select a.area_code,b.area_name,


(case when '${Tax}'='无税' then 
(case  
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then no_tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(tax_amount)end) 
end)  as 总销售金额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 总销售毛利

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
group by a.area_code,b.area_name
order by a.area_code

--同期销售
select a.area_code,b.area_name,


(case when '${Tax}'='无税' then 
(case  
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then no_tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(tax_amount)end) 
end)  as 销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then  sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then  sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 毛利额

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
group by a.area_code,b.area_name
order by a.area_code

--对比期销售
select a.area_code,b.area_name,
(case when '${Tax}'='无税' then 
(case  
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then no_tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(tax_amount)end) 
end)  as 销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 毛利额

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
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


--当期销售
select /*a.area_code,b.area_name,*/
--(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 总销售金额,
--(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 总销售毛利


/*(case when '${Tax}'='无税' then (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then no_tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then no_tax_amount end )else sum(no_tax_amount)end) else (case when '${RELATED}' = '是' then sum(case when related_party_trnsaction='是' then tax_amount end) when '${RELATED}' = '否' then sum(case when related_party_trnsaction='否' then tax_amount end )else sum(tax_amount)end)end)  as 总销售金额,
(case when '${Tax}'='无税'  then (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) else null end) else sum(no_tax_amount) - sum(no_tax_cost) end)  ELSE (case when '${RELATED}' = '是' then sum(case when RELATED_PARTY_TRNSACTION = '是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) else null end) else sum(tax_amount) - sum(tax_cost) end) end) as 总销售毛利*/

(case when '${Tax}'='无税' then 
(case when '${RELATED}' = '仅含国大合并区域内的关联交易' then sum(case when related_party_trnsaction_in='是' then no_tax_amount end) 
when '${RELATED}' = '仅含国大合并区域外的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then no_tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 
else (case when '${RELATED}' = '仅含国大合并区域内的关联交易' then sum(case when related_party_trnsaction_in='是' then tax_amount end) 
when '${RELATED}' = '仅含国大合并区域外的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then tax_amount end )
when '${RELATED}' = '含所有关联交易额' then sum(tax_amount)end) 
end)  as 总销售金额,
(case when '${Tax}'='无税'  then 
(case when '${RELATED}' = '仅含国大合并区域内的关联交易' then sum(case when related_party_trnsaction_in='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '仅含国大合并区域外的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case when '${RELATED}' = '仅含国大合并区域内的关联交易' then sum(case when related_party_trnsaction_in='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '仅含国大合并区域外的关联交易' then sum(case when related_party_trnsaction='是' and related_party_trnsaction_in='否' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 总销售毛利



from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
--group by a.area_code,b.area_name
order by a.area_code

--当期销售
select 


(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end ) 
else  sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )end)  as 总销售金额,

(case when '${Tax}'='无税'  then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
else  sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)   as 总销售毛利

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}



--同期销售
select  


(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end ) 
else  sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )end)  as 销售额,

(case when '${Tax}'='无税'  then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
else  sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)   as 毛利额

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code

/*and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and a.sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and a.sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}


--对比期销售
select  


(case when '${Tax}'='无税' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end ) 
else  sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then tax_amount end )end)  as 销售额,

(case when '${Tax}'='无税'  then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
else  sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)   as 毛利额


from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code
 
/*and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')*/

and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date1}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date1}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date1}', 'yyyy-mm-dd')

and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
 

