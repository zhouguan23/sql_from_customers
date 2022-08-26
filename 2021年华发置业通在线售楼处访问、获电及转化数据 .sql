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
and left(credate,4) = LEFT('${DATE}',4)
and credate<='${DATE}'
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

WITH RECURSIVE user_org as
(
  select m.* from fr_org_mkt m inner join (select dept_id from fr_user_org_mkt where user_id='${fine_username}' )l on m.dept_id=l.dept_id
  UNION ALL
  select t.* from fr_org_mkt t inner join user_org tcte on t.parent_id = tcte.dept_id
),

t1 as(
SELECT 
  case when cityname = '绍兴' then '1099001' 
	     when cityname = '珠海' then '1099006' 
			 when cityname = '武汉' then  '1099001'
			 when cityname = '烟台' then  '1099003'
	     else area_id end area_id,
  case when cityname = '绍兴' then '华东大区' 
	     when cityname = '珠海' then '珠海大区' 
			 when cityname = '武汉' then  '华东大区' 
			 when cityname = '烟台' then  '北方大区'
			 else area_name end area_name,
  cityname city_name,
	sum(mobilenum)mobilenum,
  sum(visitnum) viewnum
	FROM temp2_online_num t1
left join (select distinct area_name,area_id,city_name,city_id from dim_mkt_project) t2 on t1.cityname = t2.city_name
where date between '${SDATE}' and '${EDATE}' 
group by 
  area_id,
  area_name,
	cityname
),
t2 as (
SELECT 
area_name,city_name,sum(num) VISITNUM
FROM `temp2_transaction_day_detail`
where stype = '到访'
and channel = '线上' 
AND credate between '${SDATE}' and '${EDATE}' 
group by  area_name,city_name
),
t3 as (
SELECT 
area_name,city_name,
sum(num) dealnum
FROM `temp2_transaction_day_detail`
where stype = '成交'
and channel = '线上' 
AND credate between '${SDATE}' and '${EDATE}' 
group by  area_name,city_name
),
t4 as(
SELECT 
area_name,city_name,
sum(num) mobilenum
FROM `temp2_transaction_day_detail`
where stype = '获客'
and channel = '线上' 
AND credate between '${SDATE}' and '${EDATE}' 
group by  area_name,city_name
)

select 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t0.area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t0.city_name, " ) }
'' a,
sum(viewnum)viewnum,
sum(t4.mobilenum)mobilenum,
sum(visitnum)visitnum,
sum(dealnum)dealnum
from 
(select distinct area_name,city_name from t1 
union 
select distinct area_name,city_name from t2 
union
select distinct area_name,city_name from t3 
union
select distinct area_name,city_name from t4 
) t0
-- inner join (select distinct dept_name from user_org where dept_level = 2 ) tt on t0.city_name = tt.dept_name
left join t1 on t0.city_name = t1.city_name
left join t2 on t0.city_name = t2.city_name
left join t3 on t0.city_name = t3.city_name
left join t4 on t0.city_name = t4.city_name
where t0.city_name is not null

group by 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t0.area_name," ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t0.city_name, " ) }
a
order by instr("珠海大区|华南大区|华东大区|北方大区|北京区域",t0.area_name),
t0.city_name




