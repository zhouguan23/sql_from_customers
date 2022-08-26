select  union_area_name,
        销售额/10000 as 销售额,
       (case when 销售预算=0 then null else (销售额/销售预算) end ) as 销售达成率,
       (销售额-同期销售)/10000 as 同比销售增量,
       毛利额/10000 as 毛利额,
       销售额/同期销售-1  as 销售同比,
       毛利额/同期毛利-1 as 毛利同比,
       (case when 销售预算=0 then 0 else 销售预算-销售额 end )/10000 as 目标差额,
       同期销售/10000 as 同期销售,
       同期毛利/10000 as 同期毛利,
       销售预算/10000 as 销售预算
from (
select b.union_area_name,
       (case 
            when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then a.no_tax_amount end)
            when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then a.no_tax_amount end)
            when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then a.no_tax_amount end )
            when '${RELATED}' = '含所有关联交易额' then sum(a.no_tax_amount) end) as 销售额,
       (case 
            when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
            when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
            when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
            when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)毛利额,  
       c.销售额  as 同期销售,
       c.毛利额  as 同期毛利,
       d.销售预算 as 销售预算
from dm_monthly_company a,dim_region b

left join (
select b.union_area_name,
       (case  
       when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then no_tax_amount end )
       when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
       when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
       when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 销售额,
       (case 
       when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
       when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
       when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
       when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)毛利额  
from dm_monthly_company a,dim_region b
where a.area_code=b.area_code
and sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by b.union_area_name
)c on b.union_area_name=c.union_area_name
left join (
select b.union_area_name,sum(nvl(a.value,0))销售预算 from fact_sale_index a,dim_region b
where a.area_code=b.area_code
and a.create_month=to_char(sysdate,'YYYY')
group by b.union_area_name
)d on b.union_area_name=d.union_area_name

where a.area_code=b.area_code
and sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and sale_date>=to_date('${start_date}','yyyy-mm-dd')
and sale_date<=to_date('${end_date}','yyyy-mm-dd')
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and b.area_code !='00'
--and b.combination_time>=trunc(sysdate,'yyyy')
and (b.combination_time is null or b.combination_time<trunc(sysdate,'yyyy'))
group by b.union_area_name,c.销售额,c.毛利额,d.销售预算
order by min(b.sorted)
)

select  union_area_name,
        销售额/10000 as 销售额,
       (case when 销售预算=0 then null else (销售额/销售预算) end ) as 销售达成率,
       (销售额-同期销售)/10000 as 同比销售增量,
       毛利额/10000 as 毛利额,
       销售额/同期销售-1  as 销售同比,
       毛利额/同期毛利-1 as 毛利同比,
       (case when 销售预算=0 then 0 else 销售预算-销售额 end )/10000 as 目标差额,
       同期销售/10000 as 同期销售,
       同期毛利/10000 as 同期毛利,
       销售预算/10000 as 销售预算
from (
select b.union_area_name,
       (case 
            when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then a.no_tax_amount end)
            when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then a.no_tax_amount end)
            when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then a.no_tax_amount end )
            when '${RELATED}' = '含所有关联交易额' then sum(a.no_tax_amount) end) as 销售额,
       (case 
            when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
            when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
            when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
            when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)毛利额,  
       c.销售额  as 同期销售,
       c.毛利额  as 同期毛利,
       d.销售预算 as 销售预算
from dm_monthly_company a,dim_region b

left join (
select b.union_area_name,
       (case  
       when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum(case when (related_party_trnsaction='是' and related_party_trnsaction_in='否')or (related_party_trnsaction='否' and related_party_trnsaction_in='否') then no_tax_amount end )
       when '${RELATED}' = '剔除所有关联交易' then sum(case when related_party_trnsaction='否' and related_party_trnsaction_in='否' then no_tax_amount end )
       when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then no_tax_amount end )
       when '${RELATED}' = '含所有关联交易额' then sum(no_tax_amount)end) 销售额,
       (case 
       when '${RELATED}' = '剔除国 大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
       when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
       when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
       when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)毛利额 
from dm_monthly_company a,dim_region b
where a.area_code=b.area_code
and sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) end)
and sale_date>=add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12)
and sale_date<=add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
group by b.union_area_name
)c on b.union_area_name=c.union_area_name
left join (
select b.union_area_name,sum(nvl(a.value,0))销售预算 from fact_sale_index a,dim_region b
where a.area_code=b.area_code
and a.create_month=to_char(sysdate,'YYYY')
group by b.union_area_name
)d on b.union_area_name=d.union_area_name

where a.area_code=b.area_code
and sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and sale_date>=to_date('${start_date}','yyyy-mm-dd')
and sale_date<=to_date('${end_date}','yyyy-mm-dd')
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and b.combination_time>=trunc(sysdate,'yyyy')
group by b.union_area_name,c.销售额,c.毛利额,d.销售预算
order by min(b.sorted)
)

