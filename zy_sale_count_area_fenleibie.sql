/*select distinct union_area_name,area_name,area_code,trans_party_relation from dim_region
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and UNION_AREA_NAME in('"+UNION_AREA+"')")}
order by area_code*/
select distinct a.union_area_name,a.area_name,a.area_code,a.trans_party_relation,a.sorted from dim_region a,(select * from USER_AUTHORITY) b,
(select distinct area_code from dm_monthly_company 
where sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd') and attribute='直营') c
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")}

and a.area_code=c.area_code
order by sorted
--order by decode(a.area_code,'00','AA',a.union_area_name),a.area_code

/*select a.area_code,a.area_name,a.UNION_AREA_NAME from dim_region a , (select * from USER_AUTHORITY) b
where (a.UNION_AREA_NAME=b.UNION_AREA_NAME or b.UNION_AREA_NAME='ALL') 
and ${"b.user_id='"+$fr_username+"'"}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")} 
 ${if(len(UNION_AREA)=0,"","and a.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
order by 1,2*/

select union_area_name,to_char(wm_concat(area_code)) from dim_region
--where  trans_party_relation='Y'
group by union_area_name


select a.area_code,b.area_name,
/*(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 销售毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'否')='否' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'否')='否' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'否')='否' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'否')='否' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 销售毛利,
sum(sale_qty)销售数量

from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code

and a.attribute='直营'
--and nvl(a.is_b2c,'否')!='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name
order by a.area_code


select a.area_code,b.area_name,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 销售毛利
from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code

and a.attribute='直营'
--and nvl(a.is_b2c,'否')!='是'
and a.dtp='否'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name
order by a.area_code


select a.area_code,b.area_name,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 销售毛利
from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code

and a.attribute='直营'
--and nvl(a.is_b2c,'否')!='是'
and a.dtp='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name
order by a.area_code


select a.area_code,b.area_name,
(case when '${Tax}'='无税' then sum(a.no_tax_amount) else sum(a.tax_amount) end) as 销售额,
(case when '${Tax}'='无税' then nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0)  else nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end) as 销售毛利
from DM_MONTHLY_COMPANY a,dim_region b
where a.area_code=b.area_code

and a.attribute='直营'
--and nvl(a.is_b2c,'否')!='是'
and oto='是'
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and b.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and a.sale_date>=(case when '${combination_time}'='是' then nvl(combination_time,to_date('0001-01-01','yyyy-mm-dd'))
else to_date('${start_date}', 'yyyy-mm-dd') end)
and a.sale_date>=to_date('${start_date}', 'yyyy-mm-dd')
and a.sale_date<=to_date('${end_date}', 'yyyy-mm-dd')

group by a.area_code,b.area_name
order by a.area_code

