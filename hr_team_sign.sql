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
${if(len(name)=0,"", " and user_username in ('"+name+"')")}
ORDER BY user_department,user_team,user_username 

SELECT dept_id, dept_name FROM `hr_department`

SELECT team_id, team_name FROM `hr_department_team`

SELECT group_id,group_name,group_manager FROM hr_group
WHERE group_verified= 'valid'
UNION 
SELECT
"0" , '未检测到团队', null 

select a.user_name, a.check_user,
sum((FLOOR(((time_to_sec(str_to_date(b.resultyesr, "%H:%i:%s")) - time_to_sec(str_to_date(a.resultyesr, "%H:%i:%s")) - 5400)/360))/10)) as workhours
from (select date dt,state,type,user_department,user_team,user_name,user_username check_user
,case when out_type >= 1 and out_type<>9 then o.name else ifnull(CONVERT(check_time USING utf8),state_ch) end result,hr_time.reason_id,
case when state <> 1 and out_type=5 then "18:00:00"
when state = 1 then "13:30:00"
when out_type <> 5 and state <> 1 then "13:30:00"
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
where type = 1
ORDER BY user_department,dt,type,user_username) b,
(select date dt,state,type,user_department,user_team,user_name,user_username check_user
,case when out_type >= 1 and out_type<>9 then o.name else ifnull(CONVERT(check_time USING utf8),state_ch) end result,hr_time.reason_id,
case when out_type >= 1 and out_type=5 then "09:00:00"
when state = 1 then "12:00:00"
when out_type <> 5 then "12:00:00"
else ifnull(CONVERT(check_time USING utf8),"12:00:00") end resultyesr
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
where type = 0
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

select check_day,check_user,check_time,state,count(case when check_time between "09:00:01" and "09:30:00" then check_user end) times1, count(case when check_time > "09:30:00" and check_day_type=0 then check_user end) times2, count(case when check_time>='20:00:00' and check_time<'21:00:00' then check_user end)times3,count(CASE WHEN check_time >= '21:00:00' THEN check_user END) times5,count(case when check_day_type = 1 and check_time between "13:30:00" and "17:29:59" then check_user end)times4
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

SELECT concat(user_name,"-",user_username) AS user_name,user_department,user_username,
CASE WHEN out_type = 4 THEN 1 ELSE 0 END AS chuchaicishu
FROM hr_user LEFT JOIN(
	SELECT check_day,check_user,state,check_time,
	SUM(morning) AS morning,
	SUM(afternoon) AS afternoon,
	SUM(night) AS night,
	SUM(chidao) AS chidao,
	SUM(zaotui) AS zaotui,
	SUM(chidaoshijia) AS chidaoshijia,
	SUM(zaotuishijia) AS zaotuishijia,
	SUM(times) AS times
	FROM(	
		SELECT check_day,check_user,state,check_time,
		SUM(morning) AS morning,
		SUM(afternoon) AS afternoon,
		SUM(night) AS night,
		SUM(chidao) AS chidao,
		SUM(zaotui) AS zaotui,
		SUM(chidaoshijia) AS chidaoshijia,
		SUM(zaotuishijia) AS zaotuishijia,
		CASE WHEN jiaban_id IS NOT NULL AND min(check_time) <= '10:00:00' AND max(check_time) >= '17:00:00' AND state = 1 THEN 10 WHEN max(flag) = min(flag) AND state = 1 THEN 1 WHEN state = 1 THEN max(flag) - min(flag) ELSE 0 END times
		FROM (
			SELECT DISTINCT check_day,check_user,state,
			CASE WHEN check_day_type = 0 THEN min(flag) ELSE max(flag) END AS flag,
			CASE WHEN check_day_type = 0 THEN min(check_time) ELSE max(check_time) END AS check_time,
			CASE WHEN check_day_type = 0 AND state = 0 THEN 1 ELSE 0 END AS morning,
			CASE WHEN check_day_type = 1 AND state = 0 THEN 1 ELSE 0 END AS afternoon,
			CASE WHEN max(check_time) >= '20:00:00' AND state = 0 THEN 1 ELSE 0 END night,
			CASE WHEN check_day_type = 0 AND min(check_time) > '09:00:00' AND min(check_time) <= '12:00:00' AND check_day <> '2016-12-28' AND check_day >= '2016-12-12' AND state = 0 THEN 1 ELSE 0 END AS chidao,
			CASE WHEN check_day_type = 1 AND max(check_time) >= '16:00:00' AND max(check_time) < '17:30:00' AND check_day >= '2016-12-12' AND state = 0 THEN 1 ELSE 0 END AS zaotui,
			CASE WHEN check_day_type = 0 AND min(check_time) > '10:30:00' AND check_day >= '2016-12-12' AND check_day <> '2016-12-28' AND state = 0 THEN 1 ELSE 0 END AS chidaoshijia,
			CASE WHEN check_day_type = 1 AND max(check_time) < '16:00:00' AND check_day >= '2016-12-12' AND state = 0 THEN 1 ELSE 0 END AS zaotuishijia
			FROM hr_user 
			JOIN (SELECT *,CASE WHEN check_time < '10:30:00' THEN 0 WHEN check_time BETWEEN '10:30:00' AND '16:30:00' THEN 1  ELSE 2 END flag FROM hr_check_in ) AS hr_check_in ON check_user = user_username
			JOIN hr_check_in_range ON (
				(check_latitude BETWEEN range_latitude_min AND range_latitude_max) AND 
				(check_longitude BETWEEN range_longitude_min AND range_longitude_max)
			)
			JOIN hr_workdays ON check_day = date
			WHERE (
			user_state='在职' OR user_leaveDate BETWEEN '${start}' AND '${end}' 
			OR (user_leaveDate >= '${start}' AND user_state='离职')
			)
			AND user_name NOT IN ( "产品组","技术支持","UI","BI1",'luren',"售前公共销售号","售前中转")

      AND date(check_day) BETWEEN '${start}' AND '${end}' AND check_user <> ''
			GROUP BY check_user,check_day,check_day_type
		) AS list1
		LEFT JOIN hr_weekday_jiaban ON check_user = jiaban_user AND check_day = jiaban_date
		GROUP BY check_user,check_day
	) AS list2
	GROUP BY check_user
) AS list3 ON check_user = user_username
LEFT JOIN hr_time ON user = user_username AND out_type NOT IN (0,9) AND day >='${start}'and  day <='${end}'
WHERE (
user_state='在职' OR user_leaveDate BETWEEN '${start}' AND '${end}' 
OR (user_leaveDate >= '${start}' AND user_state='离职')
)
AND user_name NOT IN ( "产品组","技术支持","UI","BI1",'luren',"售前公共销售号","售前中转")

ORDER BY user_department DESC,user_name DESC

SELECT user_username,user_name,concat(user_username,"-",user_name)name FROM hr_user where user_state='在职'

