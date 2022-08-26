SELECT 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," city_name, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," sale_org_name, " ) }
  case when channel in ('线上转全民营销成交','全民营销') then '全民营销' 
	when channel in ('线上转拓客成交','拓客') then '拓客' 
	when channel in ('线上转渠道成交','渠道') then '渠道' 
	when channel in ('线上转自然到访成交') then '线上' 
	else channel end channel,
sum(num) dealnum
FROM `temp2_transaction_day_detail`
where stype = '成交'
and credate BETWEEN '${SDATE}' AND '${EDATE}'
group by 
 ${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," city_name, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," sale_org_name, " ) }
  case when channel in ('线上转全民营销成交','全民营销') then '全民营销' 
	 when channel in ('线上转拓客成交','拓客') then '拓客' 
	when channel in ('线上转渠道成交','渠道') then '渠道' 
	when channel in ('线上转自然到访成交') then '线上' 
	else channel end
	
	order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",area_name)

with t1 as(
SELECT 
  case when cityname = '绍兴' then '1099001' else area_id end area_id,
  case when cityname = '绍兴' then '华东大区' else area_name end area_name,
cityname city_name,
	sum(mobilenum) mobilenum,
  sum(visitnum) viewnum,
	  sum(CASE WHEN date BETWEEN concat(date_format(LAST_DAY('${DATE}'),"%Y-%m-"),"01") AND '${DATE}' THEN mobilenum ELSE NULL END ) AS MON_mobile,
  sum(CASE WHEN date BETWEEN concat(LEFT('${DATE}',4),"-01-01") AND '${DATE}' THEN mobilenum ELSE NULL END ) AS YEAR_mobile,
	  sum(CASE WHEN date BETWEEN concat(date_format(LAST_DAY('${DATE}'),"%Y-%m-"),"01") AND '${DATE}' THEN visitnum ELSE NULL END ) AS MON_view,
  sum(CASE WHEN date BETWEEN concat(LEFT('${DATE}',4),"-01-01") AND '${DATE}' THEN visitnum ELSE NULL END ) AS YEAR_view
	
	FROM temp2_online_num t1
left join (select distinct area_name,area_id,city_name,city_id from dim_mkt_project) t2 on t1.cityid = t2.city_id
-- where area_name is not null
group by 
  area_id,
  area_name,
	city_name
order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",area_name)
),
t2 as (
SELECT 
area_name,city_name,sum(num) VISITNUM,
  sum(CASE WHEN credate BETWEEN concat(date_format(LAST_DAY('${DATE}'),"%Y-%m-"),"01") AND '${DATE}' THEN num ELSE NULL END ) AS MON_VISIT,
  sum(CASE WHEN credate BETWEEN concat(LEFT('${DATE}',4),"-01-01") AND '${DATE}' THEN num ELSE NULL END ) AS YEAR_VISIT
FROM `temp2_transaction_day_detail`
where stype = '到访'
and channel = '线上转到访' 
group by  area_name,city_name
order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",area_name)
),
t3 as (
SELECT 
area_name,city_name,
sum(num) dealnum,
  sum(CASE WHEN credate BETWEEN concat(date_format(LAST_DAY('${DATE}'),"%Y-%m-"),"01") AND '${DATE}' THEN num ELSE NULL END ) AS MON_DEAL,
  sum(CASE WHEN credate BETWEEN concat(LEFT('${DATE}',4),"-01-01") AND '${DATE}' THEN num ELSE NULL END ) AS YEAR_DEAL
FROM `temp2_transaction_day_detail`
where stype = '成交'
and channel = '线上转自然到访成交' 
group by  area_name,city_name
order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",area_name)
)

select 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t0.area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t0.city_name, " ) }
'' a,
sum(MON_view)MON_view,
sum(YEAR_view)YEAR_view,
sum(MON_mobile)MON_mobile,
sum(YEAR_mobile)YEAR_mobile,
sum(MON_VISIT)MON_VISIT,
sum(YEAR_VISIT)YEAR_VISIT,
sum(MON_DEAL)MON_DEAL,
sum(YEAR_DEAL)YEAR_DEAL
from 
(select distinct area_name,city_name from t1 
union 
select distinct area_name,city_name from t2 
union
select distinct area_name,city_name from t3 
) t0
left join t1 on t0.city_name = t1.city_name
left join t2 on t0.city_name = t2.city_name
left join t3 on t0.city_name = t3.city_name
group by 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t0.area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t0.city_name, " ) }
a



SELECT 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," city_name, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," sale_org_name, " ) }
  case when channel in ('线上转全民营销到访','全民营销') then '全民营销' 
	when channel in ('线上转拓客到访','拓客') then '拓客' 
	when channel in ('线上转渠道到访','渠道') then '渠道' 
	when channel in ('线上转到访') then '线上' 
	else channel end channel,
sum(num) dealnum
FROM `temp2_transaction_day_detail`
where stype = '到访'
and credate BETWEEN '${SDATE}' AND '${EDATE}'
group by 
 ${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," city_name, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," sale_org_name, " ) }
  case when channel in ('线上转全民营销到访','全民营销') then '全民营销' 
	when channel in ('线上转拓客到访','拓客') then '拓客' 
	when channel in ('线上转渠道到访','渠道') then '渠道' 
	when channel in ('线上转到访') then '线上' 
	else channel end
	order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",area_name)

