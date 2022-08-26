with t1 as(
SELECT
'${edate}'  CREDATE,
t2.area_name area,
t1.projectname projectName,
t1.city ,
t1.hfProjectId projectId,
t1.sale_org_id saleOrgId,
'${edate}' as insertime,
'hb_ip_log' as datafrom,
'访问量' dataTarget,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND date(date) between  '${sdate}' and '${edate}') tomorrowCount,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND date(date)<= '${edate}' ) totalCount
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid WHERE t2.app_id IS NOT NULL
AND t2.area_name IS NOT NULL 
UNION
SELECT
'${edate}'  CREDATE,
t2.area_name area,
t1.projectname projectName,
t1.city ,
t1.hfProjectId projectId,
t1.sale_org_id saleOrgId,
now() as insertime,
'mini_mobile_info' as datafrom,
'获电量' dataTarget ,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime) between  '${sdate}' and '${edate}') tomorrowCount,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime) <= '${edate}' ) totalCount
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid WHERE t2.app_id IS NOT NULL
AND  t2.area_name IS NOT NULL 
),t2 as(
select credate,dataTarget,area,
case when projectname like '%城市首页%' then left(projectname,2)
else city end city,
projectname,sum(tomorrowcount)tomorrowcount,sum(totalCount)totalCount
from t1
where projectname <>'压测项目-测试'
group by dataTarget,credate,area,city,projectname
)
select * from t2
where 1=1
${if(len(area)=0,"","and area in ('"+area+"')")}
${if(len(city)=0,"","and city in ('"+city+"')")}
${if(len(proj)=0,"","and projectname in ('"+proj+"')")}
order by  
 find_in_set(area,"珠海区域,华南区域,华东区域,华中区域,山东区域,北方区域,北京区域")
,city,projectname



select distinct area_name from sys_area_app
where area_name is not null

select distinct area_name,city
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid 
WHERE t2.app_id IS NOT NULL
and city is not null and city <>''
${if(len(area)=0,"","and area_name in ('"+area+"')")}
order by  area_name,city

select distinct area_name,city,projectname
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid 
WHERE t2.app_id IS NOT NULL
and city is not null and city <>''
${if(len(area)=0,"","and area_name in ('"+area+"')")}
${if(len(city)=0,"","and city in ('"+city+"')")}
order by  area_name,city,projectname

with t1 as(
SELECT
'${edate}'  CREDATE,
t2.area_name area,
t1.projectname projectName,
t1.city ,
t1.hfProjectId projectId,
t1.sale_org_id saleOrgId,
'${edate}' as insertime,
'hb_ip_log' as datafrom,
'访问量' dataTarget,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND date(date)='${edate}') tomorrowCount,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE  projectid = t1.Id AND appid = t1.appid AND date(date) >= date_sub('${edate}',INTERVAL WEEKDAY('${edate}') DAY) AND date(date) <= '${edate}') weekCount,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND date(date) >=concat(date_format(LAST_DAY('${edate}'),"%Y-%m-"),"01") AND date(date)<='${edate}') monthCount,
(SELECT ifnull(sum(browse),0) FROM house_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND date(date)<= '${edate}' ) totalCount
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid WHERE t2.app_id IS NOT NULL
AND t2.area_name IS NOT NULL 
UNION
SELECT
'${edate}'  CREDATE,
t2.area_name area,
t1.projectname projectName,
t1.city ,
t1.hfProjectId projectId,
t1.sale_org_id saleOrgId,
'${edate}' as insertime,
'mini_mobile_info' as datafrom,
'获电量' dataTarget ,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime)='${edate}') tomorrowCount,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime) >= date_sub('${edate}',INTERVAL WEEKDAY('${edate}') DAY) AND date(mobiletime) <= '${edate}') weekCount,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime) >= concat(date_format(LAST_DAY('${edate}'),"%Y-%m-"),"01") AND date(mobiletime)<= '${edate}') monthCount,
(SELECT count(distinct mobile,projectid) FROM mobile_report_summary WHERE projectid = t1.Id AND appid = t1.appid AND source !=8 and  date(mobiletime) <= '${edate}') totalCount
FROM dh_project t1 
left join sys_area_app t2 on t2.app_id = t1.appid WHERE t2.app_id IS NOT NULL
AND  t2.area_name IS NOT NULL 
)

select credate,dataTarget,area,
case when length(city)=0 then area 
when projectname like '%城市首页%' then projectname
else city end city,
projectname,sum(tomorrowcount)tomorrowcount,
sum(weekCount)weekCount,sum(monthcount)monthcount,sum(totalcount)totalcount
from t1
where projectname <>'压测项目-测试'
${if(len(area)<>0,"and area_name in ('"+area+"')")}
${if(len(city)<>0,"and city in ('"+city+"')")}
${if(len(proj)<>0,"and projectname in ('"+proj+"')")}
group by dataTarget,credate,area,city,projectname
order by  
 find_in_set(area,"珠海区域,华南区域,华东区域,华中区域,山东区域,北方区域,北京区域")
,city,projectname


