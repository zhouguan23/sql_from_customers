${if(HOUR(now()) < 4 ,"select TIME(NOW())t,0 c","select TIME(NOW())t,count(*)c from
(
select * from hr_workdays where (left(DATE_ADD(date,INTERVAL 3 DAY),7)
=LEFT(DATE_ADD(   CURDATE()   ,INTERVAL 3 DAY),7) or  left(DATE_ADD(date,INTERVAL 3 DAY),7)
=LEFT(DATE_ADD(  DATE_ADD(   CURDATE()   ,INTERVAL 3 DAY)  ,INTERVAL -1 month),7) )and state=0
)days /*本月周期工作日*/
cross join (select 0 type union select 1) daytype /*上下午*/
left join (
SELECT check_user,check_day,check_day_type,CASE WHEN (check_day_type = 0) THEN min(check_time) ELSE max(check_time) END check_time
FROM(select check_user,check_day,check_day_type,check_time,check_latitude,check_longitude from hr_check_in where check_user='"+fr_username+"'and check_day>=DATE_ADD(CURDATE(),INTERVAL -61 day)
)hc
JOIN hr_check_in_range 
ON check_latitude BETWEEN range_latitude_min AND range_latitude_max
AND check_longitude BETWEEN range_longitude_min AND range_longitude_max
GROUP BY check_user,check_day,check_day_type /*用视图过滤慢*/
)hr_check_in on check_day =date and  check_day_type= type 
left join (select * from hr_time where user='"+fr_username+"'and day>=DATE_ADD(CURDATE(),INTERVAL -61 day) 
and out_type>=1 and out_type<>9
)hr_time on day =date and day_type= type /*请假出差补签*/
where
(date>=(select user_entrydate from hr_user where user_username='"+fr_username+"')
	and date<DATE_ADD(CURDATE(),INTERVAL -1 day) or (date=DATE_ADD(CURDATE(),INTERVAL -1 day) and type=0)
)and ifnull(check_user,user) is null"
)}

select date dt,CASE dayofweek(date)
WHEN 1 THEN	'周日'WHEN 2 THEN	'周一'WHEN 3 THEN	'周二'WHEN 4 THEN	'周三'
WHEN 5 THEN	'周四'WHEN 6 THEN	'周五'WHEN 7 THEN	'周六'
END  w 
,state,type,ifnull(check_user,user)check_user,check_time,out_type
,case when out_type >= 1 and out_type <>9 then o.name else check_time end result from
(select * from hr_workdays where date between DATE_ADD(CURDATE(),INTERVAL -7 DAY) and  DATE_ADD(CURDATE(),INTERVAL -0 DAY) 
)days  cross join (select 0 type union select 1)daytype left join 
(select * from v_hr_check_in where check_user='${fr_username}')hr_check_in on check_day =date and  check_day_type= type left join 
(select * from hr_time where user='${fr_username}')hr_time on day =date and day_type= type
left join hr_time_out_type o on hr_time.out_type=o.id
where date >=(select ifnull(DATE(user_entrydate),'2001-01-01') from hr_user where  user_username='${fr_username}') ORDER BY dt ,type 

