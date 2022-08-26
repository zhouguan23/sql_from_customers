select concat(support_name,"组")gpname,support_name,support_group from support_user where support_group <>4 and support_status="1" and support_duty=1
and support_group<>1
${if(len(groups)=0,"","and find_in_set(support_group ,'"+groups+"')")}

select sum(sc)bugnum,leader,'bugnum'kind from(
select get_com_leader(COMPANY)leader,f.bug_id,if(support_bug_level.bug_level=1,3.5,if(support_bug_level.bug_level=2,9,if(support_bug_level.bug_level=3,21,if(support_bug_level.bug_level=4,42,0))))sc
from fr_t_system1 f
LEFT JOIN cust_bug cb on f.bug_id=cb.bug_id
LEFT JOIN support_bug_level on bug_levels BETWEEN bug_grade_down and if(bug_grade_up='',1000000,bug_grade_up)
where f.bugkind in("客户bug","BI客户bug")
and jira_keys regexp "CUSTBUG"
and bug_state=0
and f.bugstatus in("关闭","BUG已解决")
and date(endtime) between "${startdate}" and "${enddate}"
and support not in('lidre','Ann')
and support in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
)bug GROUP BY leader

union

select count(*)n,get_com_leader(comid)leader,'qqnum' from(
select id,support,push_time,comid from service_satisfaction_deal 
LEFT JOIN cust_company ON comid = com_id
WHERE com_verified='valid'
and date(push_time) between "${startdate}" and "${enddate}"
and support in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
GROUP BY im,date(push_time)
)imcc
GROUP BY leader

UNION

select count(*)gpnum,gpleader,'gpnum' from(
select gp_id,get_com_leader(gp_com)gpleader from group_support_problem 
where date(gp_date) BETWEEN "${startdate}" and "${enddate}"
and gp_recorder not in("lidre","Ann")
and gp_recorder in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
GROUP BY gp_concat,date(gp_date)
)a GROUP BY gpleader

UNION

select count(*)*10 n,if(support_group=1,"lidre",if(support_group=2,"maple",if(support_group=3,"robert",if(support_group=5,"snake",if(support_group=6,"pello","james")))))chuleader,"chuchainum" from(
select day,support_group,user from(
SELECT user,day,day_type from hr_time 
LEFT JOIN hr_user on user=user_username
where 1=1  and day BETWEEN "${startdate}" and "${enddate}"
and out_type=4
)a
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from support_user_history where support_group not in(0,4)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and (support_label not regexp '2|6|7' or support_label is null)
)b on user=support_name and day BETWEEN support_starttime and support_endtime
where user not in("lidre","Ann")
)x 
GROUP BY support_group 

union

select count(*)*10 n,support_group,"chuchaiother" from(
select day,support_group,user from(
SELECT user,day,day_type from hr_time 
LEFT JOIN hr_user on user=user_username
where 1=1  and day BETWEEN "${startdate}" and "${enddate}"
and out_type=4
)a
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from 
support_user_history where support_group not in(0,4) and (support_label not regexp '2|6|7' or support_label is null)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and (support_label not regexp '2|6|7' or support_label is null)
)b on user=support_name and day BETWEEN support_starttime and support_endtime
where user not in("lidre","Ann")
)x 
GROUP BY support_group

select sum(if(days<=180,0,if(days<=270,0.4,0.5)))n,leader,support_group from(
SELECT support_name,support_group,TIMESTAMPDIFF(day,user_entrydate,day)days from support_user_history 
LEFT JOIN hr_user on support_name=user_username
LEFT JOIN hr_time on support_name=user and `day` BETWEEN support_starttime and support_endtime
where support_group not in(0,4) and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and out_type not in(4,5,9,13,14) and `day` between "${startdate}" and if("${enddate}">date(now()),date(now()),"${enddate}")
and support_name not in("lidre","Ann")
and (support_label not regexp '2|3|6|7' or support_label is null)
)chuqin
left join (select support_name leader,support_group groups from support_user where support_duty=1 and support_status=1)x on support_group=groups
GROUP BY leader

select e.bugid,support_group,support_label,lower(support)support,v,f.endtime,if((ceil(bug_menber_time)<=(ifnull(bug_hour,0) + ifnull(apply.applylen, 0)) or bug_menber_time is null), 0, 1) as flag from fr_t_system1  f left join cust_bug  c on f.bug_id = c.bug_id
left join cust_company on company=com_id
left join (select * from (SELECT round(avg(sumvalue),2)v,bugid from custbug_charger GROUP BY bugid) aa )e on f.bug_id = e.bugid
left join v_hr_contract v on hr_ctr_user = support 
LEFT JOIN support_bug_level_copy b on (v >= b.bug_grade_down and v < bug_grade_up)
left join custbug_timedely_apply apply on apply.bugid = e.bugid
left join (select support_name,support_group,support_status,support_label from (select support_name,support_group,support_status,support_label from
(SELECT support_name,support_group,support_status,support_label from support_user ORDER BY support_status desc)x 
GROUP BY support_name)y where support_group<>4) support on support.support_name = f.support
where f.bugkind in("客户bug","BI客户bug")
and jira_keys like'CUSTBUG%'
and com_country="中国"
and (c.bug_state<>1 or c.bug_state is null)
and f.bugstatus in("关闭","BUG已解决")
and length(v) != 0
and length(support_group) != 0
${if(len(groups)=0,"","and find_in_set(support_group ,'"+groups+"')")}
${if(len(startdate)=0,"","and f.endtime >= '"+startdate+"'")}
${if(len(enddate)=0,"","and f.endtime <= '"+enddate+"'")}
order by support_group asc

select uid, user.support_name leader, support_user_history.support_name,support_user_history.support_group,support_duty,v.user_firstConventionDate as month,
case when user_leaveDate is null then 1
when (user_leaveDate > '${enddate}' or user_leaveDate between '${enddate}' and '${startdate}') then 1
when (user_leaveDate <= '${enddate}' and user_leaveDate >= '${startdate}') then 1
else 0 end leaveflag,
case when date_add(v.user_firstConventionDate,interval 4 month) <= '${enddate}' then 1
else 0 end flag,
user.support_name leader,support_starttime,support_endtime,if(support_user_history.support_name = 'agan', '4,9', support_label)support_label,
case when support_starttime >= '${startdate}' then support_starttime
else '${startdate}' end stime,
case when support_endtime >= '${enddate}' then '${enddate}'
else support_endtime end etime,

case when (support_starttime >= '${startdate}' and find_in_set('3', support_label) = 0) or (support_starttime >= '${startdate}' and support_label is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${startdate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end estime,
case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end eetime,

case when date_add(v.user_firstConventionDate,interval 4 month) < (case when (support_starttime >= '${startdate}' and find_in_set('3', support_label) = 0) or (support_starttime >= '${startdate}' and support_label is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${startdate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end) then (case when (support_starttime >= '${startdate}' and find_in_set('3', support_label) = 0) or (support_starttime >= '${startdate}' and support_label is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${startdate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end)
when date_add(v.user_firstConventionDate,interval 4 month) <= (case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end) and date_add(v.user_firstConventionDate,interval 4 month) >= (case when (support_starttime >= '${startdate}' and find_in_set('3', support_label) = 0) or (support_starttime >= '${startdate}' and support_label is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${startdate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end) then date_add(v.user_firstConventionDate,interval 4 month)  
else date_add(v.user_firstConventionDate,interval 5 month) end eestime,



case when date_add(v.user_firstConventionDate,interval 4 month) > (case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end) then date_add(v.user_firstConventionDate,interval 4 month)
when date_add(v.user_firstConventionDate,interval 4 month) <= (case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end) and date_add(v.user_firstConventionDate,interval 4 month) >= (case when (support_starttime >= '${startdate}' and find_in_set('3', support_label) = 0) or (support_starttime >= '${startdate}' and support_label is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${startdate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end) then (case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end)

else (case 
 when (support_endtime >= '${enddate}' and find_in_set('3', support_label) = 0) or (support_endtime >= '${enddate}' and support_label is null) then '${enddate}'
when ('${enddate}' <= '2018-05-01' and find_in_set('3', support_label) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', support_label) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', support_label) > 0 and '${enddate}' > '2018-05-01') then "2018-05-01"
else support_endtime end) end eeetime

from support_user_history 
left join (select support_group,support_name from support_user where support_duty = 1 and support_group<>1) user on user.support_group = support_user_history.support_group
left join v_hr_contract v on support_user_history.support_name = hr_ctr_user
left join hr_user on v.hr_ctr_user = user_username

where support_user_history.support_group not in (0,4)and support_status="1"
and support_endtime >= '${startdate}' and support_starttime <= '${enddate}'
and (support_label not regexp '2|6|7' or support_label is null)
and (case when (support_starttime >= '${startdate}' and find_in_set('3', if(support_user_history.support_name = 'agan', '4,9', support_label)) = 0) or (support_starttime >= '${startdate}' and if(support_user_history.support_name = 'agan', '4,9', support_label) is null) then support_starttime
when ('${enddate}' <= '2018-05-01' and find_in_set('3', if(support_user_history.support_name = 'agan', '4,9', support_label)) > 0) then "${enddate}"
when ('${startdate}' >= '2018-05-01' and find_in_set('3', if(support_user_history.support_name = 'agan', '4,9', support_label)) > 0) then null
when ('${startdate}' < '2018-05-01' and find_in_set('3', if(support_user_history.support_name = 'agan', '4,9', support_label)) > 0 and '${enddate}' > '2018-05-01') then '${startdate}'
else '${startdate}' end) is not null
and support_user_history.support_name not in ("Ann", "lidre","Chenxing.Yu")
and if('${startdate}'>="2019-11-01",user.support_name<>"pello","1=1")
${if(len(groups)=0,"","and find_in_set(support_user_history.support_group ,'"+groups+"')")}
-- 技术支持的结束时间大于选定日期的开始时间;开始时间小于选定的结束时间，能够保证时间范围一定有交集
order by support_user_history.support_group asc

select sum(sc)bugnum,lower(support)support,'bugnum'kind from(
select f.bug_id,f.support,if(support_bug_level.bug_level=1,3.5,if(support_bug_level.bug_level=2,9,if(support_bug_level.bug_level=3,21,if(support_bug_level.bug_level=4,42,0))))sc
from fr_t_system1 f
LEFT JOIN cust_bug cb on f.bug_id=cb.bug_id
LEFT JOIN support_bug_level on bug_levels BETWEEN bug_grade_down and if(bug_grade_up='',1000000,bug_grade_up)
where f.bugkind in("客户bug","BI客户bug")
and jira_keys regexp "CUSTBUG"
and bug_state=0
and f.bugstatus in("关闭","BUG已解决")
and date(endtime) between "${startdate}" and "${enddate}"
and support not in('lidre','Ann')
and support in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
)bug GROUP BY support

union

select count(*)n,lower(support)support,'qqnum' from(
select id,support,push_time,comid from service_satisfaction_deal 
LEFT JOIN cust_company ON comid = com_id
WHERE com_verified='valid'
and date(push_time) between "${startdate}" and "${enddate}"
and support in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
GROUP BY im,date(push_time)
)imcc
GROUP BY support

union

select count(*)gpnum,gp_recorder,'gpnum' from(
select gp_id,gp_recorder from group_support_problem 
where date(gp_date) BETWEEN "${startdate}" and "${enddate}"
and gp_recorder not in("lidre","Ann")
and gp_recorder in(select support_name from support_user_history where support_endtime >="${startdate}" and support_starttime<="${enddate}" and (support_label not regexp '2|3|6|7' or support_label is null))
GROUP BY gp_concat,date(gp_date)
)a GROUP BY gp_recorder

union

select count(*)*10 n,user,"chuchainum" from(
select day,support_group,user from(
SELECT user,day,day_type from hr_time 
LEFT JOIN hr_user on user=user_username
where 1=1  and day BETWEEN "${startdate}" and "${enddate}"
and out_type=4
)a
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from support_user_history where support_group not in(0,4)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and (support_label not regexp '2|3|6|7' or support_label is null)
)b on user=support_name and day BETWEEN support_starttime and support_endtime
where user not in("lidre","Ann")
)x 
GROUP BY user

union

select count(*)*10 n,user,"chuchaiother" from(
select day,support_group,user from(
SELECT user,day,day_type from hr_time 
LEFT JOIN hr_user on user=user_username
where 1=1  and day BETWEEN "${startdate}" and "${enddate}"
and out_type=4
)a
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from support_user_history where support_group not in(0,4) and (support_label not regexp '2|3|6|7'  or support_label is null)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and (support_label not regexp '2|3|6|7' or support_label is null)
)b on user=support_name and day BETWEEN support_starttime and support_endtime
where user not in("lidre","Ann")
)x 
GROUP BY user 


select sum(if(days<=120,0,0.5))n,lower(support_name)support_name from(
SELECT support_name,support_group,TIMESTAMPDIFF(day,user_entrydate,day)days from support_user_history 
LEFT JOIN hr_user on support_name=user_username
LEFT JOIN hr_time on support_name=user and `day` BETWEEN support_starttime and support_endtime
left join hr_workdays on day=date
where support_group not in(0,4) and support_endtime >="${startdate}"  and support_starttime<="${enddate}"
and out_type not in(4,5,9,13,14) and `day` between "${startdate}" and if("${enddate}">date(now()),date(now()),"${enddate}")
and support_name not in("lidre","Ann") and state=0
and (support_label not regexp '2|3|6|7' or support_label is null)
)chuqin
GROUP BY support_name

select e.bugid,support_group,support_label,lower(support)support,round(if(TIMESTAMPDIFF(day,v.user_firstConventionDate,f.endtime) < 120, v, v)/4.4, 2)v,f.endtime,if((ceil(bug_menber_time)<=(ifnull(bug_hour,0) + ifnull(apply.applylen, 0)) or bug_menber_time is null), 0, 1) as flag from fr_t_system1  f left join cust_bug  c on f.bug_id = c.bug_id
left join cust_company on company=com_id
left join (select * from (SELECT round(avg(sumvalue),2)v,bugid from custbug_charger GROUP BY bugid) aa )e on f.bug_id = e.bugid
left join v_hr_contract v on hr_ctr_user = support 
LEFT JOIN support_bug_level_copy b on (v >= b.bug_grade_down and v < bug_grade_up)
left join custbug_timedely_apply apply on apply.bugid = e.bugid
left join (select support_name,support_group,support_status,support_label from (select support_name,support_group,support_status,support_label,support_starttime,support_endtime from
(SELECT support_name,support_group,support_status,support_label,support_starttime,support_endtime from support_user_history ORDER BY support_starttime desc)x 
)y where support_group<>4 and support_starttime <="${startdate}"  and support_endtime>="${enddate}") support on support.support_name = f.support
where f.bugkind in("客户bug","BI客户bug")
and jira_keys like'CUSTBUG%'
and com_country="中国"
and (c.bug_state<>1 or c.bug_state is null)
and f.bugstatus in("关闭","BUG已解决")
and length(v) != 0
and length(support_group) != 0
${if(len(groups)=0,"","and find_in_set(support_group ,'"+groups+"')")}
order by support_group asc

select count(bug_id)n,lower(support)support,bug_level,'bugnum'kind from (
select support,f.bug_id,support_bug_level.bug_level from fr_t_system1 f
LEFT JOIN cust_bug cb on f.bug_id=cb.bug_id
LEFT JOIN support_bug_level on bug_levels BETWEEN bug_grade_down and if(bug_grade_up='',1000000,bug_grade_up)
where f.bugkind in("客户bug","BI客户bug")
and jira_keys like'CUSTBUG%'
and bug_state=0
and f.bugstatus in("关闭","BUG已解决")
and date(endtime) between "${startdate}" and "${enddate}"
and support not in('lidre','ann')
)bug GROUP BY support,bug_level

union

select count(*)n,lower(sup)support,0,'qqnum' from(
select *, TIMESTAMPDIFF(day,vv.`hr_ctr_start`,date(push_time))days from(
select p.* from(

SELECT r.id, ss.sup_name sup, cont_company,im, push_time
from service_satisfaction_evaluation r
join  cust_contact on im=cont_qq 
left join (select *, if(left(enddate, 10) < "${startdate}", "${startdate}", if(left(enddate, 10) > "${enddate}", "${enddate}", left(enddate, 10))) aa, 
if(left(startdate, 10) > "${enddate}", "${enddate}", if(left(startdate, 10) > "${startdate}", left(startdate, 10), "${startdate}")) bb
 from support_servicenum_ship where left(enddate, 10) >= "2017-07-01") ss on r.service_number = ss.service_number
where 1=1
and cont_verified='valid'
and sup_name is not null
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and left(r.push_time, 10) >= bb
and left(r.push_time, 10) <= aa

union
SELECT r.id, ss.sup_name sup, cont_company,im, push_time
from service_satisfaction_evaluation r
join  cust_contact on im in (cont_qq) 
left join (select *, if(left(enddate, 10) < "${startdate}", "${startdate}", if(left(enddate, 10) > "${enddate}", "${enddate}", left(enddate, 10))) aa, 
if(left(startdate, 10) > "${enddate}", "${enddate}", if(left(startdate, 10) > "${startdate}", left(startdate, 10), "${startdate}")) bb
 from support_servicenum_ship where left(enddate, 10) >= "2017-07-01") ss on r.service_number = ss.service_number
where 1=1
and cont_verified='valid' and cont_way_mark=1
and sup_name is not null
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and left(r.push_time, 10) >= bb
and left(r.push_time, 10) <= aa


union
/*单个qq*/
SELECT r.id,r.service_number sup,cont_company,im,push_time
from service_satisfaction_evaluation r force index(index_pushtime)
join  cust_contact on im=cont_qq 
-- LEFT JOIN support_user_history his on r.service_number=his.support_name and r.push_time BETWEEN support_starttime and support_endtime
where 1=1
and cont_verified='valid'
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and date(r.push_time)between "${startdate}" and "${enddate}"

UNION
/*多个qq*/
SELECT r.id,r.service_number sup,cont_company,im,push_time
from service_satisfaction_evaluation r force index(index_pushtime)
join  cust_contact on im in (cont_qq)
-- LEFT JOIN support_user_history his on r.service_number=his.support_name and r.push_time BETWEEN support_starttime and support_endtime
where 1=1 and cont_way_mark = 1 and cont_verified='valid'
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and date(r.push_time)between "${startdate}" and "${enddate}"

UNION
/*单个mobile*/
SELECT r.id,r.service_number sup,cont_company,im,push_time
from service_satisfaction_evaluation r force index(index_pushtime)
join cust_contact on im=cont_mobile 
-- LEFT JOIN support_user_history his on r.service_number=his.support_name and r.push_time BETWEEN support_starttime and support_endtime
where 1=1
and cont_verified='valid'
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and date(r.push_time)between "${startdate}" and "${enddate}"

UNION
/*多个mobile*/
SELECT r.id,r.service_number sup,cont_company,im,push_time
from service_satisfaction_evaluation r force index(index_pushtime)
join  cust_contact on im in (cont_mobile)
-- LEFT JOIN support_user_history his on r.service_number=his.support_name and r.push_time BETWEEN support_starttime and support_endtime
where 1=1 and cont_way_mark = 1 and cont_verified='valid'
and SUBSTRING_INDEX(tags,"-->",1) <> "确认没有问题残留" 
and date(r.push_time)between "${startdate}" and "${enddate}"
)p 
LEFT JOIN support_user_history his on p.sup=his.support_name and p.push_time BETWEEN support_starttime and support_endtime
group by id
)qq
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) vv on sup = hr_ctr_user
where TIMESTAMPDIFF(day,vv.`hr_ctr_start`,date(push_time)) > 120
GROUP BY im,date(push_time)
)qqbug
GROUP BY support
/*-------------------------------------------------------------------------------*/
union

select count(*)gpnum,lower(gp_recorder)gp_recorder,0,'gpnum' from (
select gp_id,gp_recorder,gp_concat,gp_date from group_support_problem 
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) vv on gp_recorder = hr_ctr_user
where date(gp_date) between "${startdate}" and "${enddate}" and TIMESTAMPDIFF(day,vv.`hr_ctr_start`,date(gp_date)) >= 120
GROUP BY gp_concat,date(gp_date)
)ggp GROUP BY gp_recorder

UNION

select count(*)*10 n,lower(user)user,0,"chuchainum" from(
select day,user, TIMESTAMPDIFF(day,v.`hr_ctr_start`,day)days from(
SELECT user,day,day_type from hr_time 
where 1=1  and day  between "${startdate}" and "${enddate}"
and out_type in (4,13,14)
)a
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) v on user = hr_ctr_user
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from support_user_history where support_group not in(0,4)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}")b on user=support_name and day BETWEEN support_starttime and support_endtime
)x
where days >= 120 
GROUP BY user 

union

/*计算出勤 分两块，外聘和非外聘*/
select sum(n)n,lower(user)user,0,"chuqin" from(
/*非外聘，正常计算*/
select sum(if(days<=120,0,0.5))n,user from(
select user,support_group,TIMESTAMPDIFF(day,v.`hr_ctr_start`,day)days from(
SELECT user,day,day_type from hr_time where out_type=5 and `day` between "${startdate}" and "${enddate}"
UNION
select check_user,check_day,check_day_type from(
	SELECT check_user, check_day, check_day_type FROM hr_check_in
	JOIN hr_check_in_range ON
	(check_latitude BETWEEN range_latitude_min AND range_latitude_max) 
	AND (check_longitude BETWEEN range_longitude_min AND range_longitude_max) 
	where check_day between "${startdate}" and "${enddate}"
	and not EXISTS (select day from hr_time where day = check_day and check_day_type = day_type and check_user = user and out_type in (1,2,6,7,10))
	GROUP BY
	check_user,
	check_day,
	check_day_type
) AS subx
)x
left join (select * from hr_workdays where state = 0) hr_workdays on date = x.day LEFT JOIN hr_user on user=user_username
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) v on user_username = hr_ctr_user
JOIN 
(SELECT uid,support_name,support_group,support_starttime,support_endtime from support_user_history where support_group not in(0,4)
and support_endtime >="${startdate}"  and support_starttime<="${enddate}" and (support_label not REGEXP 4 or support_label is null))b on user=support_name and day BETWEEN support_starttime and support_endtime
where TIMESTAMPDIFF(day,user_entrydate,day)>21 and date is not null
)chuqin
GROUP BY user

UNION

select (total.n-ifnull(others.n,0))n,total.support_name from (
/*外聘，先统计全勤天数，再减去请假天数*/
select sum(if(days<=120,0,0.5))n,support_name from(
SELECT support_name,support_group,TIMESTAMPDIFF(day,v.`hr_ctr_start`,date)days from support_user_history 
LEFT JOIN hr_user on support_name=user_username
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) v on user_username = hr_ctr_user
LEFT JOIN(
SELECT date,0 type from hr_workdays where date between "${startdate}" and if("${enddate}">date(now()),date(now()),"${enddate}") and state=0
UNION
SELECT date,1 from hr_workdays where date between "${startdate}" and if("${enddate}">date(now()),date(now()),"${enddate}") and state=0
)x on date BETWEEN support_starttime and support_endtime
where support_group not in(0,4)and support_endtime >="${startdate}"  and support_starttime<="${enddate}" and support_label REGEXP 4
)chuqin
GROUP BY support_name
)total
LEFT JOIN 
(
/*外聘统计请假天数*/
select sum(if(days<=120,0,0.5))n,support_name from(
SELECT support_name,support_group,TIMESTAMPDIFF(day,vv.`hr_ctr_start`,day)days from support_user_history 
LEFT JOIN hr_user on support_name=user_username
left join (select hr_ctr_user, min(hr_ctr_start) hr_ctr_start from hr_contract group by hr_ctr_user) vv on user_username = hr_ctr_user
LEFT JOIN hr_time on support_name=user and `day` BETWEEN support_starttime and support_endtime
left join (select * from hr_workdays where state = 0) hr_workdays on date = day 
where support_group not in(0,4) and support_endtime >="${startdate}"  and support_starttime<="${enddate}" and support_label REGEXP 4
and out_type not in(4,5,9,14) and `day` between "${startdate}" and if("${enddate}">date(now()),date(now()),"${enddate}") and date is not null
)chuqin
GROUP BY support_name
)others
on total.support_name=others.support_name
)zcq group by user

select lower(check_user)check_user, sum(hour) as summary from (select aa.check_user, sum((FLOOR(((time_to_sec(bb.time2) - time_to_sec(aa.time1) - 5400)/360))/10)) as hour, 'daka'  type from (select *, min(check_time)time1 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 0
group by check_user,check_day) aa 
left join (select *, max(check_time)time2 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 1 group by check_user,check_day) bb on (aa.check_day = bb.check_day and aa.check_user = bb.check_user)
left join hr_workdays on date = aa.check_day
left join (select support_name from support_user_history group by support_name) his on his.support_name = aa.check_user
where state = 0 and support_name is not null
group by aa.check_user

union 

select user, count(*) * 4 total, 'buqian' type from (
select hr_time.* from hr_time left join hr_check_in hh on (check_user = user and check_day = day and check_day_type = day_type)
left join (select support_name from support_user_history group by support_name) his on his.support_name = user
left join hr_workdays on date = day
where out_type in (4, 5) and check_time is null and state = 0 and support_name is not null
and day between '${startdate}' and '${enddate}'
GROUP BY `user`, day, day_type order by day desc) aa
group by user

union

select aa.check_user, sum((FLOOR(((time_to_sec("13:30:30") - time_to_sec(aa.time1) - 5400)/360))/10)) as hour, 'xiawu'  type from 
(select *, min(check_time)time1 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 0 
group by check_user,check_day) aa 
left join (select *, max(check_time)time2 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 1 group by check_user,check_day) bb on (aa.check_day = bb.check_day and aa.check_user = bb.check_user)
left join hr_workdays on date = aa.check_day
left join (select support_name from support_user_history group by support_name) his on his.support_name = aa.check_user
where state = 0 and support_name is not null and bb.time2 is null 
group by aa.check_user

union

select bb.check_user, sum((FLOOR(((time_to_sec(bb.time2) - time_to_sec("12:00:00") - 5400)/360))/10)) as hour, 'shangwu'  type from 
(select *, max(check_time)time2 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 1 group by check_user,check_day) bb 
left join (select *, (min(check_time))time1 from hr_check_in where check_day between '${startdate}' and '${enddate}'
and check_day_type = 0 
group by check_user,check_day) aa  on (aa.check_day = bb.check_day and aa.check_user = bb.check_user)
left join hr_workdays on date = bb.check_day
left join (select support_name from support_user_history group by support_name) his on his.support_name = bb.check_user
where state = 0 and support_name is not null and aa.time1 is null
group by bb.check_user
)aaa
group by check_user

select aa.* from hr_workdays 
left join  (select *, min(if(check_time is null, "09:00:00", check_time))time1 from hr_check_in where check_day between '2018-05-01' and '2018-05-31'
and check_day_type = 0
group by check_user,check_day) aa on date = check_day
left join (select *, max(if(check_time is null, "18:00:00", check_time))time2 from hr_check_in where check_day between '2018-05-01' and '2018-05-31'
and check_day_type = 1 group by check_user,check_day) bb on (aa.check_day = bb.check_day and aa.check_user = bb.check_user)
where state = 0
and date between '2018-05-01' and '2018-05-31'

select user, count(*) * 4 total from (
select check_time, hr_time.* from hr_time left join hr_check_in hh on (check_user = user and check_day = day and check_day_type = day_type)
left join support_user_history on support_name = hh.check_user
left join hr_workdays on date = hh.check_day
where out_type in (4,5) and check_time is null and state = 0 and support_name is not null
and day between '${startdate}' and '${enddate}'
GROUP BY `user`, day, day_type order by day desc) aa
group by user

SELECT count(*) FROM `hr_workdays` where state = 0 and date <= '${enddate}'
and date >= '${startdate}'

