select date dt,CASE dayofweek(date)
WHEN 1 THEN	'周日'WHEN 2 THEN	'周一'WHEN 3 THEN	'周二'WHEN 4 THEN	'周三'
WHEN 5 THEN	'周四'WHEN 6 THEN	'周五'WHEN 7 THEN	'周六'
END  w 
,state,type,ifnull(check_user,user)check_user,check_time,out_type
,case when out_type >= 1 and out_type <>9 then o.name else check_time end result from
(select * from hr_workdays where left(DATE_ADD(date,INTERVAL 3 DAY),7)=LEFT(DATE_ADD(CURDATE(),INTERVAL 3 DAY),7))days  cross join (select 0 type union select 1)daytype left join 
(select * from v_hr_check_in where check_user='${fr_username}')hr_check_in on check_day =date and  check_day_type= type left join 
(select * from hr_time where user='${fr_username}')hr_time on day =date and day_type= type
left join hr_time_out_type o on hr_time.out_type=o.id
where date >=(select ifnull(DATE(user_entrydate),'2001-01-01') from hr_user where  user_username='${fr_username}') ORDER BY dt ,type

