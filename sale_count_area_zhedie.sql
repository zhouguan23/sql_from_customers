/*select distinct union_area_name,area_name，area_code,trans_party_relation from dim_region
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code*/
select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation,sorted from dim_region a, (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
and 1=1  ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by sorted 

select a.area_code,
       b.area_name,
     
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
end)  as 直营销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 直营销售毛利

from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='直营'
and nvl(a.is_b2c,'否')!='是'

and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

select a.area_code,
       b.area_name,
 
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
end)  as 加盟配送销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 加盟配送毛利

from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='加盟'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')
group by a.area_code,b.area_name

select a.area_code,
       b.area_name,
 
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
end)  as 批发销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as 批发销售毛利

from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='批发'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

select union_area_name,to_char(wm_concat(area_code)) from dim_region
--where  trans_party_relation='Y'
group by union_area_name

select a.area_code,
       b.area_name,
     
 
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
end)  as 销售额
       
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='直营'
and nvl(a.is_b2c,'否')!='是'
and a.dtp='否'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

select a.area_code,
       b.area_name,
     

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
end)  as 销售额 

       
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='直营'
and nvl(a.is_b2c,'否')!='是'
and a.dtp='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

select a.area_code,
       b.area_name,
     

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
end)  as  销售额

       
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='直营'
and nvl(a.is_b2c,'否')!='是'
and a.oto='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

select a.area_code,
       b.area_name,
     

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
end)  as B2C销售额,
(case when '${Tax}'='无税'  then 
(case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(no_tax_amount, 0) - nvl(no_tax_cost, 0)  ) end)  
else (case 
when '${RELATED}' = '剔除国大合并区域内的关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '剔除所有关联交易' then sum( nvl(tax_amount, 0) - nvl(tax_cost, 0) ) 
when '${RELATED}' = '关联交易额' then sum(case when related_party_trnsaction='是' then nvl(tax_amount, 0) - nvl(tax_cost, 0) end)
when '${RELATED}' = '含所有关联交易额' then sum(  nvl(tax_amount, 0) - nvl(tax_cost, 0)  ) end)  
end) as B2C毛利

       
from dm_monthly_company a ,dim_region b
where a.area_code=b.area_code
and a.attribute='直营'
and a.is_b2c='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
/*and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')*/
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name

