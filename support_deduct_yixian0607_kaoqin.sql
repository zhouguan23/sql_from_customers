select *,case when rate < 0.1 then 1   
     when rate >= 0.1 and rate < 0.15 then 0.8
     when rate >= 0.15 and rate < 0.20 then 0.6  
     when rate >= 0.20 and rate < 0.25 then 0.4 
     when rate >= 0.25 and rate < 0.30 then 0.2  
     when rate >= 0.3  then 0  end yinshu from(
select lower(sup_name)sup_name,sup_num,ifnull(ifnull(c,0)/(ifnull(s,0)+ifnull(c,0)+ifnull(cc,0)+ifnull(gc,0)),0) rate,(ifnull(s,0)+ifnull(c,0)+ifnull(cc,0)+ifnull(gc,0))p from hr_support_yixian
LEFT JOIN
(SELECT count(f.bug_id)c,CREATOR from fr_t_system1 f
LEFT JOIN cust_bug c on f.bug_id=c.bug_id
where BUGKIND in("客户bug","BI客户bug")
and jira_keys regexp'CUSTBUG-' and bug_state=0
and createdate between '${startmontth}' and  '${endmonth}' and lower(creator)<>lower(support) GROUP BY CREATOR)a
on sup_name=creator
LEFT JOIN
(select sup,sum(s)s from(
SELECT ifnull(replace_user,sup_name)sup,count(r.id)s,'o' from service_satisfaction_evaluation r
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id
LEFT JOIN support_servicenum_ship s on r.service_number=s.service_number and r.push_time BETWEEN startdate and ifnull(enddate,NOW()) 
left join support_num_replace on r.service_number = replace_num and (r.push_time BETWEEN replace_startdate and replace_enddate)
where date(r.push_time) <='2018-02-07'
and date(r.push_time) between '${startmontth}' and  '${endmonth}'
and substring_index(ifnull(r2.tags,r.tags),'-->',1) in ('产品','方案','BI其它')
GROUP BY sup
UNION
SELECT r.service_number,count(r.id)s,'n' from service_satisfaction_evaluation r
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id
where date(r.push_time) >'2018-02-07'
and date(r.push_time) between '${startmontth}' and  '${endmonth}'
and substring_index(ifnull(r2.tags,r.tags),'-->',1) in ('产品','方案','BI其它')
GROUP BY r.service_number
)tt GROUP BY sup)b
on sup_name=sup
LEFT JOIN
(SELECT count(gp_id)gc,gp_recorder from group_support_problem
where gp_tags in ('产品','方案','BI其它')
and gp_date between '${startmontth}' and  '${endmonth}'  GROUP BY gp_recorder)gp
on sup_name=gp_recorder
LEFT JOIN
(SELECT count(ff.bug_id)cc,CREATOR from fr_t_system1 ff
where BUGKIND='客户需求' and history not like "%退回补充信息%"
and createdate between '${startmontth}' and  '${endmonth}'  GROUP BY CREATOR)aa
on sup_name=aa.creator
)w

select lower(sup_name)sname,sup_name,sup_junior,left(DATE_ADD(sup_stime,INTERVAL -1 month), 7)sup_stime,ifnull(user.checkin, 0)checkin, ifnull(user.buqian, 0) buqian, ifnull(summary, 0) summary ,support_group
from hr_support_yixian
left join support_master_ship on lower(sup_master) = lower(sup_name)
left join (select sum(supkoujian) summary,supname from support_checkin_koujian_yixian where supmonth = left(DATE_add('${endmonth}', INTERVAL -1 month), 7) group by supname) ss on lower(supname) = lower(sup_name)
left join (select check_user, count(*) as checkin,  buqian  from (SELECT check_user,check_day,check_day_type,
	(
		CASE WHEN (check_day_type = 0) THEN
			min(check_time)
		ELSE
			max(check_time)
		END
	) AS check_time
FROM
		hr_check_in
where check_day  >= '2019-08-01' AND check_day <= '2019-08-31'
GROUP By check_user,check_day,check_day_type)hr_check_in
left join (select user, ifnull(count(*),0) as buqian from hr_time where day_type = 0 and out_type = 5 and 
day >= '${startmontth}' AND day <= '${endmonth}' group by user) time on time.user = check_user
left join (select * from support_user_history where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' group by support_name order by support_starttime)support_user_history on check_user = support_user_history.support_name
join hr_workdays on date(check_day) = date(date) and state = 0
where check_day_type = 0 and check_time > "09:00:00" and support_name is not null and length(check_time)=8
and check_day >= '${startmontth}' and check_day <= '${endmonth}'
group by check_user) user on lower(check_user) = lower(sup_name)
left join (select * from support_user_history where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' group by support_name order by support_starttime)support_user_history1 on lower(sup_name) = lower(support_user_history1.support_name)
order by support_group

select concat(support_name,"@fanruan.com")mail,support_group from support_user 
where support_status="1" and support_duty=1
order by support_group


select *, lower(support_yixian_name)support from support_yixian_jixiao where start_time='${startmontth}' and end_time='${endmonth}'

select *, lower(sup_name) ssname from hr_support_yixian

SELECT lower(ques_recorder) supporter,ques_recordval zhishivalue,ques_recordtime writetime from ques_kms_record where ques_recordtime=left("${startmontth}",7)

/*select id,supporter,zhishivalue,koujian,writetime from support_jixiao_zhishi where writetime=left("${startmontth}",7) order by supporter,writetime
*/


select SUM(0-deduct_score)v,lower(sup_name)sup_name from sup_deduct_list 
where date(editdate) between '${startmontth}' and  '${endmonth}'
GROUP BY sup_name

select lower(supporter)supporter,(0-count(uid)*100)v from support_response_tousu  
where tbdate between '${startmontth}' and  '${endmonth}'
and supporter in (select sup_name from hr_support_yixian)
GROUP BY supporter

/*一线技术支持绩效*/
SELECT lower(service_number)service_number, rrr, IF(LENGTH(ifnull(aa,''))=0,'无',aa)a,IF(LENGTH(ifnull(bb,''))=0,'无',bb)b,com_status FROM(
  SELECT r.*, ifnull(r2.result,r.result) rrr, sup_main,ifnull(r2.tags,r.tags)tagg, substring_index(ifnull(r2.tags,r.tags),'-->',1)aa, 
  CASE WHEN ifnull(r2.tags,r.tags) REGEXP '-->' then substring_index(ifnull(r2.tags,r.tags),'-->',-1) else '' end AS bb,
  IFNULL(r2.result,r.result) end_result, ifnull(ifnull(r2.solution2,r2.solution), ifnull(r.solution2,r.solution)) AS end_solution, 
  CASE WHEN r.solution_dialogue is not null then '被关联'
   WHEN r.result not in ('未解决','未评价') then ''    
   WHEN r.solution_dialogue is null then '点击关联'
   WHEN r.solution_dialogue='' then '点击关联' else r2.dialogue_ID end sd, 
   com_id,com_name,com_status,com_salesman,com_province FROM ( 
    
	SELECT sse.* FROM(
	  SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
      push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
	  CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    cont_id,cont_name,cont_mobile,cont_company
	  FROM service_satisfaction_evaluation
	  LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
	  JOIN cust_contact ON im=cont_qq
	  WHERE push_time >= '${startmontth}'  AND push_time <= '${endmonth}' and cont_verified='valid'
	) AS sse



	UNION
	SELECT list.* FROM(
	  SELECT sse.* FROM(
		SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
		push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
		CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    way_contact,cont_name,cont_mobile,cont_company
		FROM service_satisfaction_evaluation
		LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact_way ON im = way_entity
    JOIN cust_contact ON cont_id = way_contact
		WHERE push_time >= '${startmontth}'  AND push_time <= '${endmonth}' and tags in ('方案','产品') and way_type = 'qq'
    and cont_way_mark = 1 AND cont_verified='valid'
	  ) AS sse

	) AS list

	UNION
	SELECT sse.* FROM (
	  SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
	  push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
	  CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    cont_id,cont_name,cont_mobile,cont_company
	  FROM service_satisfaction_evaluation
	  LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact ON im=cont_mobile
	  WHERE push_time >= '${startmontth}'  AND push_time <= '${endmonth}' and cont_verified='valid'
    ) AS sse
	
    
			
	UNION
	SELECT list.* FROM(
	  SELECT sse.* FROM(
	    SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
		push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
		CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    way_contact,cont_name,cont_mobile,cont_company
		FROM service_satisfaction_evaluation
		LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact_way ON im = way_entity
    JOIN cust_contact ON cont_id = way_contact
		WHERE push_time >= '${startmontth}'  AND push_time <= '${endmonth}' and tags in ('方案','产品')
    and way_type = 'mobile' and cont_way_mark = 1 AND cont_verified='valid'
	  ) AS sse 
	) AS list
	
)r LEFT JOIN cust_company on cont_company=com_id and com_verified='valid' 
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id LEFT JOIN support_company_bind ON sup_company = com_id  where 1=1)t 
group by id HAVING 1=1 and a in ('方案','产品') and com_status in ("合作","跟进")  

/*一线技术支持绩效*/
SELECT lower(service_number)service_number, rrr, IF(LENGTH(ifnull(aa,''))=0,'无',aa)a,IF(LENGTH(ifnull(bb,''))=0,'无',bb)b FROM(
  SELECT r.*, ifnull(r2.result,r.result) rrr, sup_main,ifnull(r2.tags,r.tags)tagg, substring_index(ifnull(r2.tags,r.tags),'-->',1)aa, 
  CASE WHEN IFNULL(r2.tags,r.tags) REGEXP '-->' then substring_index(ifnull(r2.tags,r.tags),'-->',-1) else '' end bb, 
  IFNULL(r2.result,r.result) end_result,ifnull(ifnull(r2.solution2,r2.solution),ifnull(r.solution2,r.solution)) end_solution, 
  CASE WHEN r.solution_dialogue is not null then '被关联' 
   WHEN r.result not in ('未解决','未评价') then ''    
   WHEN r.solution_dialogue is null then '点击关联'
   WHEN r.solution_dialogue='' THEN '点击关联' ELSE r2.dialogue_ID END sd, 
  com_id,com_name,com_status,com_salesman,com_province FROM( 
	
	SELECT sse.* FROM(
	  SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
      push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
	  CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    cont_id,cont_name,cont_mobile,cont_company
	  FROM service_satisfaction_evaluation
	  LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact ON im=cont_qq
	  WHERE push_time >= '${startmontth}'  
	  AND push_time <DATE_add('${endmonth}',INTERVAL 1 day) 
	  and tags in ('方案','产品') and cont_verified='valid'
	) AS sse


	UNION
	SELECT list.*  FROM(
	  SELECT sse.* FROM(
		SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
		push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
		CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    way_contact,cont_name,cont_mobile,cont_company
		FROM service_satisfaction_evaluation
		LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact_way ON im = way_entity
    JOIN cust_contact ON cont_id = way_contact
		WHERE push_time >= '${startmontth}'  AND push_time <DATE_add('${endmonth}',INTERVAL 1 day)  and tags in ('方案','产品') and way_type = 'qq'
    and cont_way_mark = 1 AND cont_verified='valid'
	  ) AS sse
	) AS list

	UNION
	SELECT sse.* FROM (
	  SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
	  push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
	  CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    cont_id,cont_name,cont_mobile,cont_company
	  FROM service_satisfaction_evaluation
	  LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
	  JOIN cust_contact ON im=cont_mobile
	  WHERE push_time >= '${startmontth}'  AND push_time <DATE_add('${endmonth}',INTERVAL 1 day)  and tags in ('方案','产品')
    and cont_verified='valid'
    ) AS sse

    
			
	UNION
	SELECT list.* FROM(
	  SELECT sse.* FROM(
	    SELECT id, dialogue_ID, ques_overdue_email AS email, ques_jdk AS jdk, service_number, IM, details, solution, tags,
		push_time, evaluate_time, solution_dialogue, solution2, verifier, vertime, fb_result, cust_ip, ques_oppid, ques_ctrid,
		CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS result,
    CASE WHEN tempid IS NOT NULL AND tempid <> '' AND push_time <= tempPushtime THEN '已解决' ELSE result END AS t_result,
    way_contact,cont_name,cont_mobile,cont_company
		FROM service_satisfaction_evaluation
		LEFT JOIN service_satisfaction_canliu ON  IM = tempIM
    JOIN cust_contact_way ON im = way_entity
    JOIN cust_contact ON cont_id = way_contact
		WHERE push_time >= '${startmontth}'  AND push_time <DATE_add('${endmonth}',INTERVAL 1 day)  and tags in ('方案','产品')
    and way_type = 'mobile' and cont_way_mark = 1 AND cont_verified='valid'
	  ) AS sse   
	) AS list

	
)r 
LEFT JOIN cust_company on cont_company=com_id and com_verified='valid' 
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id 
LEFT JOIN support_company_bind ON sup_company = com_id  where 1=1
)t 
group by service_number, IM, date(push_time)   

select support,sum(v)s_v from(SELECT f.bug_id,lower(support)support,ifnull(v,15)v from fr_t_system1 f
left JOIN(SELECT round(avg(sumvalue),2)v,bugid from custbug_charger GROUP BY bugid)val on bug_id=val.bugid
left join cust_bug cb on f.bug_id=cb.bug_id
where bugstatus in("关闭","BUG已解决")
and BUGKIND in("客户bug","BI客户bug")
and jira_keys regexp"CUSTBUG"
and (bug_state<>1 or bug_state is null)
and endtime>='${startmontth}' AND endtime <= '${endmonth}'
order by f.bug_id)a 
group by support

select *,sum(ques_recordval)zhishivalue from
(SELECT ques_recorder,ques_recordval  from ques_kms_record 
where ques_recordtime=left('${startmontth}',7)
UNION
select zhishi_support,zhishi_value from zhishiku_value
where zhishi_month=left('${startmontth}',7)
UNION
select kms_j_support,kms_j_value from kms_jifen_value
where kms_j_month=left('${startmontth}',7)
)A
group by ques_recorder

select * from support_jixiao_pzhi

-- kaoqin_jixiao
select *,round(all_summary/number,2) as kaoqin_jixiao from(select support_group,(sum(-koujian) + if(sum(summary) < -5, -sum(summary), 0)) all_summary,sum(member) number
from(select *,if(checkin < 1 and buqian <= 2, 0, 0 - (10 + (if(checkin <= 1, 0, checkin - 1) + if(buqian <= 2, 0, buqian - 2)) * 50))koujian,if(checkin < 1 and buqian <= 2,1,0)  member
 from(select * from(select lower(sup_name)sname,sup_name,ifnull(user.checkin, 0)checkin, 
ifnull(user.buqian, 0) buqian, ifnull(summary, 0) summary ,support_group
from hr_support_yixian
left join (select sum(supkoujian) summary,supname from support_checkin_koujian_yixian where supmonth = left(DATE_add('${endmonth}', INTERVAL -1 month), 7) group by supname) ss on lower(supname) = lower(sup_name)
left join (select check_user, count(*) as checkin,  buqian  from hr_check_in
left join (select user, ifnull(count(*),0) as buqian from hr_time where day_type = 0 and out_type = 5 and 
day >= '${startmontth}' AND day <= '${endmonth}' group by user ) time on time.user = check_user
left join (select * from support_user_history  where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' group by support_name order by support_starttime)support_user_history 
on check_user = support_user_history.support_name
join hr_workdays on date(check_day) = date(date) and state = 0
where check_day_type = 0 and check_time > "09:00:00" and support_name is not null and length(check_time)=8
and check_day >= '${startmontth}' and check_day <= '${endmonth}'
group by check_user) user on lower(check_user) = lower(sup_name)
left join (select * from support_user_history  where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' group by support_name order by support_starttime)support_user_history1 on 
lower(sup_name) = lower(support_user_history1.support_name)
order by support_group)yixian
UNION
select * from(select  lower(support_name)support_name,support_name bigname,ifnull(user.checkin, 0)checkin, ifnull(user.buqian, 0) buqian,
ifnull(summary, 0) summary,support_group from support_user_history 

left join (select sum(supkoujian) summary,supname from support_checkin_koujian where supmonth = left(DATE_add('${endmonth}', INTERVAL -1 month), 7) group by supname) ss on lower(supname) = lower(support_name)

left join (select check_user, count(*) as checkin,  buqian  from (select *, min(check_time) time 
from hr_check_in where check_day_type = 0 and check_day >= '${startmontth}' and check_day <= '${endmonth}'
 and check_time <= "12:00:00" group by check_user, check_day, check_day_type)hr_check_in
left join (select user, ifnull(count(*),0) as buqian from hr_time where day_type = 0 and out_type = 5 and 
day >= '${startmontth}' AND day <= '${endmonth}' group by user) time on time.user = check_user
join (select * from support_user_history  where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' group by support_name)support_user_history on check_user = support_name
join hr_workdays on date(check_day) = date(date) and state = 0
where time > "09:00:00"
group by check_user) user on lower(check_user) = lower(support_name)

where support_starttime <= '${endmonth}' and support_endtime >= '${endmonth}' 
-- '${startmontth}' between concat(left(support_starttime,7), "-01") and concat(left(support_endtime,7), "-01")
and ((support_label<>6  && support_label <> 7 && support_label <> 2 && support_label <> 3)  or support_label is null)
and (support_duty=2 or support_name = 'grey')
and support_name not in(select sup_name from hr_support_yixian)
order by support_name)er_xian)kaoqin
order by support_group)kaoqin_jixiao
group by support_group)avg_kaoqin

select support_name,valuess+IFNULL(minus_score,0) as valuess
FROM
(
SELECT count(*)*100 valuess,lower(support_name)support_name from support_user LEFT JOIN hr_time on support_name=user
where day>=concat('${startmontth}'," 00:00:00")
and day<=concat('${endmonth}'," 23:59:59")
and (out_type = 4 or out_type=13)
and support_status=1
and support_group not in (4)
GROUP BY support_name
) v
left join 
(
-- 9.10起扣除未录入出差日报发送记录的分值
select out_user,sum(case when out_date>='2019-10-08' and out_date<CURRENT_DATE() then per_score*a_cnt else 0 end ) as minus_score 
from(
select task_actor as out_user,task_predate as out_date,count(*) as total_cnt,-50/count(*) as per_score,sum(case when out_state is null then 1 else 0 end) as a_cnt
from cust_task ct left join support_chuchai_daily_record sp
on ct.task_predate = sp.out_date
and ct.task_actor = sp.out_user
and ct.task_company = sp.out_com_id
where 
task_predate>=concat('${startmontth}'," 00:00:00")
and task_predate<=concat('${endmonth}'," 23:59:59")
and task_status <> '取消'
group by task_actor,task_predate
) a
group by out_user
) m
on v.support_name = m.out_user

select * from support_user

