SELECT user_name,user_username,user_mobile,user_duty,user_workplace,user_state,
user_department,dept_name,tag_industry_id,tag_product_id,tag_region_id,if(user_team=0,null,user_team)user_team,g.group_id,group_manager,group_name,user_type
,case when user_type ='实习生' or user_transform_date is not null then user_entrydate else null end as sxs_entrydate
,case when user_type ='实习生' or user_transform_date is not null then user_firstConventionDate else user_entrydate end as user_entrydate,
user_group_weituo,user_group_shoutuo,
sales_parent_I dist_manager
FROM hr_user 
left JOIN v_hr_contract on user_username = hr_ctr_user
LEFT JOIN hr_department ON dept_id = user_department
LEFT JOIN hr_user_tags ON user_username = tag_username
left join
(select department_id,industry_id,product_id,region_id,group_id from hr_tags_group where tags_group_year=YEAR(CURDATE())
)g on user_department = department_id
and (tag_industry_id regexp industry_id or ifnull(industry_id,'')='')
and (tag_product_id regexp product_id or ifnull(product_id,'')='')
and (tag_region_id regexp region_id or ifnull(region_id,'')='')
left join hr_group on hr_group.group_id=g.group_id
left join hr_sales on user_username=sales_name
WHERE user_type in('正式','外聘','实习生','兼职','外包-软通') and 
(user_state='在职'/*or (user_state='离职' 
and user_leaveDate >=(select cycle_startdate from hr_attendance_month_cycle WHERE cycle_ym =left(CURDATE(),7)))*/)
${if(len(producttag)=0,"", " and tag_product_id in ("+producttag+") ")}
${if(len(dept)=0,"", " and user_department in ("+dept+") ")}
${if(len(team)=0,"", " and user_team in ("+team+") ")}
${if(user_group=0," and g.group_id is null",if(len(user_group)=0,""," and g.group_id is not null and g.group_id in ("+user_group+")"))}
ORDER BY user_department,user_team,user_username 

SELECT dept_id, dept_name FROM `hr_department`

SELECT team_id, team_name FROM `hr_department_team`

SELECT group_id,group_name,group_manager FROM hr_group
WHERE group_verified= 'valid'
UNION 
SELECT
"0" , '未检测到团队', null 

select a.user_name, a.check_user,sum((time_to_sec(str_to_date(b.resultyesr, "%H:%i:%s")) - time_to_sec(str_to_date(a.resultyesr, "%H:%i:%s")) - 5400)/3600) as workhours
from 
(select date dt,state,type,user_department,user_team,user_name,user_username check_user
,case when out_type >= 1 and out_type<>9 then o.name else ifnull(CONVERT(check_time USING utf8),state_ch) end result,hr_time.reason_id,
case when out_type=5 then "17:30:00"
when out_type >= 1 and out_type <> 9 and out_type <>5 then "13:30:00"
else ifnull(CONVERT(check_time USING utf8),"13:30:00") end resultyesr
from(select *,if(state=1,'公休',null)state_ch from hr_workdays 
where hr_workdays.date between '${start}' and '${end}'
)days  
cross join (select 0 type union select 1)daytype 
cross join (SELECT * FROM `hr_user` where (user_state='在职'))u
left join(
SELECT `check_user`,`check_day`,`check_day_type`,
CASE WHEN (`hc`.`check_day_type` = 0) THEN min(`hc`.`check_time`) ELSE max(`hc`.`check_time`) END `check_time`,
`check_remark`,`check_latitude`,`check_longitude`
FROM`hr_check_in` `hc`JOIN `hr_check_in_range` 
ON `check_latitude` BETWEEN `range_latitude_min` AND `range_latitude_max` AND `check_longitude` BETWEEN `range_longitude_min` AND `range_longitude_max`
where check_day between '${start}' and '${end}'

GROUP BY`check_user`,`check_day`,`check_day_type`
)hr_check_in on check_user =user_username and check_day =date and  check_day_type= type 

left join (select * from hr_time where day between '${start}' and '${end}')
hr_time on user =user_username and day =date and day_type= type
left join hr_time_out_type o on hr_time.out_type=o.id
where type = 1 and state = 0
ORDER BY user_department,dt,type,user_username) b,
(select date dt,state,type,user_department,user_team,user_name,user_username check_user
,case when out_type >= 1 and out_type<>9 then o.name else ifnull(CONVERT(check_time USING utf8),state_ch) end result,hr_time.reason_id,
case when out_type=5 then "09:00:00"
when out_type >= 1 and out_type <> 9 and out_type <>5 then "12:00:00"
else if(check_time is null,'12:00:00',if(check_time < '09:00:00','09:00:00',check_time)) end resultyesr
from(select *,if(state=1,'公休',null)state_ch from hr_workdays 

where hr_workdays.date between '${start}' and '${end}'
)days  
cross join (select 0 type union select 1)daytype 
cross join (SELECT * FROM `hr_user` where (user_state='在职') )u
left join (SELECT `check_user`,`check_day`,`check_day_type`,
CASE WHEN (`hc`.`check_day_type` = 0) THEN min(`hc`.`check_time`) ELSE max(`hc`.`check_time`) END `check_time`,
`check_remark`,`check_latitude`,`check_longitude`
FROM`hr_check_in` `hc`JOIN `hr_check_in_range` 
ON `check_latitude` BETWEEN `range_latitude_min` AND `range_latitude_max` AND `check_longitude` BETWEEN `range_longitude_min` AND `range_longitude_max`
where check_day between '${start}' and '${end}'

GROUP BY`check_user`,`check_day`,`check_day_type`)hr_check_in_result on check_user =user_username and check_day =date and  check_day_type= type 

left join (select * from hr_time where day between '${start}' and '${end}')
hr_time on user =user_username and day =date and day_type= type
left join hr_time_out_type o on hr_time.out_type=o.id
where type = 0 and state = 0
ORDER BY user_department,dt,type,user_username) a
where a.check_user=b.check_user and a.dt=b.dt
group by check_user

SELECT * FROM `hr_department_team` 
${if(len(dept)=0,"where 1=2", " where team_department in ("+dept+") ")} 

select hr_user.user_username, (count(case when out_type=5 then user_username end)) "补签", count(case when out_type in (4,13,14) then user_username end) "出差", count(case when out_type=12 then user_username end) "调休", count(case when out_type not in (0,4,5,9,12,13,14) then user_username end) "请假"
from hr_time,hr_user
where hr_time.user=hr_user.user_username  
and (user_state='在职'  or user_leaveDate between '${start}' and '${end}')
and day >='${start}'and  day <='${end}'
group by user_username

select check_day,check_user,check_time,state,count(case when check_time between "09:00:01" and "09:30:00" then check_user end) times1, count(case when check_time > "09:30:00" and check_day_type=0 then check_user end) times2, count(case when check_time>='20:00:00' then check_user end)times3,count(case when check_day_type = 1 and check_time between "13:30:00" and "17:29:59" then check_user end)times4
from (select * from hr_workdays where `date` between '${start}' and '${end}' and state = 0 )hr_workdays, (select check_user, check_time, check_day, check_day_type from (select `hc`.`check_user` AS `check_user`,`hc`.`check_day` AS `check_day`,`hc`.`check_day_type` AS `check_day_type`,(case when (`hc`.`check_day_type` = 0) then min(`hc`.`check_time`) else max(`hc`.`check_time`) end) AS `check_time`,`hc`.`check_remark` AS `check_remark`,`hc`.`check_latitude` AS `check_latitude`,`hc`.`check_longitude` AS `check_longitude` from (`hr_check_in` `hc` join `hr_check_in_range` on(((`hc`.`check_latitude` between `hr_check_in_range`.`range_latitude_min` and `hr_check_in_range`.`range_latitude_max`) and (`hc`.`check_longitude` between `hr_check_in_range`.`range_longitude_min` and `hr_check_in_range`.`range_longitude_max`))))where  check_day BETWEEN '${start}' and '${end}'/*0722新加where*/ group by `hc`.`check_user`,`hc`.`check_day`,`hc`.`check_day_type`)a where check_day BETWEEN '${start}' and '${end}')hr_check_in
where  date(check_day) between '${start}'and '${end}' and check_user <> ''
and check_day = `date`
GROUP BY check_user

select * from hr_tags where tags_type='产品线'

select * from hr_workdays 
where  
 date BETWEEN '${start}' and '${end}'
/*date <= DATE_ADD(CURDATE(),INTERVAL 3 day) order by date*/

${if(check<>"true"," select 1","select date dt,state,type,user_department,user_team,user_name,user_username check_user,case when out_type >= 1 and out_type<>9 then o.name else ifnull(CONVERT(check_time USING utf8),state_ch) end result,hr_time.reason_id from(select *,if(state=1,'公休',null)state_ch from hr_workdays where   date  BETWEEN '"+start+"' and '"+end+"')days cross join (select 0 type union select 1)daytype cross join (SELECT * FROM `hr_user` where (user_state='在职' or user_leaveDate >= '"+start+"'))u
left join(
SELECT `check_user`,`check_day`,`check_day_type`,
CASE WHEN (`hc`.`check_day_type` = 0) THEN min(`hc`.`check_time`) ELSE	max(`hc`.`check_time`) END `check_time`,
`check_remark`,`check_latitude`,`check_longitude`
FROM`hr_check_in` `hc`JOIN `hr_check_in_range` 
ON `check_latitude` BETWEEN `range_latitude_min` AND `range_latitude_max` AND `check_longitude` BETWEEN `range_longitude_min` AND `range_longitude_max`
where check_day BETWEEN '"+start+"' and '"+end+"'
GROUP BY`check_user`,`check_day`,`check_day_type`
)hr_check_in on check_user =user_username and check_day =date and  check_day_type= type 
left join (select * from hr_time where  day  BETWEEN '"+start+"' and '"+end+"')
hr_time on user =user_username and day =date and day_type= type
left join hr_time_out_type o on hr_time.out_type=o.id
ORDER BY user_department,dt,type,user_username")}

select a.user_name, a.check_user,
sum(((time_to_sec(str_to_date(b.resultyesr, "%H:%i:%s")) - time_to_sec(str_to_date(a.resultyesr, "%H:%i:%s")) - 5400)/3600)) as jiabanhours
from(select days.date dt,state,type,user_department,user_team,user_name,user_username check_user,check_time,wb_username,find_in_set(check_user,wb_username),
case when (find_in_set(check_user,wb_username) is null) then '13:30:00'
when (find_in_set(check_user,wb_username)<>0 and check_time is null) then '13:30:00'
else check_time
end resultyesr
from (select * from hr_workdays where hr_workdays.date between '${start}' and '${end}')days  
inner join (select * from hr_jiaban_ceshiandyanfa j where j.group = '测试外包组')wb on wb.date = days.date
cross join (select 0 type union select 1)daytype
cross join (
select * from hr_user right join hr_department on dept_id = user_department where user_state='在职' and dept_id = 36)u
left join (
select check_user,check_day,check_day_type,case when (check_day_type = 0) then min(check_time) else max(check_time) end check_time,
check_remark,check_latitude,check_longitude from hr_check_in
join hr_check_in_range 
on check_latitude between range_latitude_min and range_latitude_max and check_longitude between range_longitude_min and range_longitude_max
where check_day between '${start}' and '${end}'
group by check_user,check_day,check_day_type)hr_check_in_result on check_user =user_username and check_day = days.date and check_day_type = type
where type = 1
order by dt,type,user_username)b,
(select days.date dt,state,type,user_department,user_team,user_name,user_username check_user,check_time,wb_username,find_in_set(check_user,wb_username),
case when (find_in_set(check_user,wb_username)=0) then '12:00:00'
when (find_in_set(check_user,wb_username)<>0 and check_time is null) then '12:00:00'
else if(check_time<'09:00:00','09:00:00',check_time)
end resultyesr
from (select * from hr_workdays where hr_workdays.date between '${start}' and '${end}')days  
inner join (select * from hr_jiaban_ceshiandyanfa j where j.group = '测试外包组')wb on wb.date = days.date
cross join (select 0 type union select 1)daytype
cross join (
select * from hr_user right join hr_department on dept_id = user_department where user_state='在职' and dept_id = 36)u
left join (
select check_user,check_day,check_day_type,case when (check_day_type = 0) then min(check_time) else max(check_time) end check_time,
check_remark,check_latitude,check_longitude from hr_check_in
join hr_check_in_range 
on check_latitude between range_latitude_min and range_latitude_max and check_longitude between range_longitude_min and range_longitude_max
where check_day between '${start}' and '${end}'
group by check_user,check_day,check_day_type)hr_check_in_result on check_user =user_username and check_day = days.date and check_day_type = type
where type = 0
order by dt,type,user_username)a
where a.check_user = b.check_user and a.dt = b.dt
group by check_user

