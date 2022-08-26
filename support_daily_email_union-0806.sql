/*技术支持日报*/
SELECT a.fr_system_id,a.productline,b.com_salesman,a.bug_id,a.bugtitle,bugkind,a.createdate,a.support,b.com_presales,b.com_name,b.com_type,a.jira_keys,a.contact
,case when instr(substring_index(reverse(substring_index(substr(reverse(history),instr(reverse(history),reverse(concat('time":"','${day}')))-length(' hh:mm:ss"'),length(history)),'{',1)),'","time"',1),'"当天问题进展:')=0 
			then null 
 else substring_index(substring_index(reverse(substring_index(substr(reverse(history),instr(reverse(history),reverse(concat('time":"','${day}')))-length(' hh:mm:ss"'),length(history)),'{',1)),'","time"',1),'"当天问题进展:',-1) 
 end bugmark
,a.lastdayinfo,b.com_id,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_region,cont_name,mt
FROM fr_t_system1 a
LEFT JOIN cust_company b ON a.company = b.com_id
LEFT JOIN cust_contact _b ON _b.cont_id = a.contact
LEFT JOIN hr_salesman ON com_salesman = sales_name
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on a.company=limitdate.com

WHERE (bugkind =('客户BUG') or (BUGKIND='BI客户BUG' and SUPPORT in (select support_name from support_user)))
AND jira_keys LIKE 'CUSTBUG%' 
and productline="FR"
AND bugstatus IN ("组员处理","组长审核","指定组员","技术支持小组长") 
AND createdate>"2016-01-01"
HAVING find_in_set(get_com_leader(com_id),'${region}')
ORDER BY sales_region,com_salesman,com_id

/*技术支持日报*/
SELECT a.fr_system_id,a.productline,b.com_salesman,a.bug_id,a.bugtitle,a.endtime,a.RDtime,bugkind,a.support,b.com_presales,b.com_name,b.com_type,a.jira_keys,a.contact,a.solution,b.com_id,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_region,ceil(ifnull(bugtime_s,c.bug_menber_time))menbertime,_b.cont_name,mt
FROM fr_t_system1 a 
LEFT JOIN cust_company b ON a.company = b.com_id
LEFT JOIN cust_contact _b ON a.contact = _b.cont_id
LEFT JOIN cust_bug c ON a.bug_id = c.bug_id
LEFT JOIN custbug_timedely_apply ON a.bug_id=bugid
LEFT JOIN hr_salesman ON com_salesman = sales_name
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on a.company=limitdate.com

WHERE (bugkind =('客户BUG') or (BUGKIND='BI客户BUG' and SUPPORT in (select support_name from support_user))) AND bugstatus = "BUG已解决" 
and productline="FR"
AND createdate>"2016-01-01" AND jira_keys LIKE 'CUSTBUG%'
AND com_verified = 'valid' AND cont_verified = 'valid'
${if(len(day)=0,""," and endtime = '"+day+"'")}
HAVING find_in_set(get_com_leader(com_id),'${region}')
ORDER BY sales_region,com_salesman,com_id

/*技术支持日报*/
SELECT a.BUG_ID,a.productline,a.fr_system_id,b.com_salesman,a.bug_id,a.bugtitle,a.SUPPORTTIME,a.createdate,bugkind,a.support,b.com_presales,b.com_name,b.com_status,a.jira_keys,b.com_id,a.jiraid,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_region,mt FROM fr_t_system1 a
LEFT JOIN cust_company b ON a.company = b.com_id
LEFT JOIN hr_salesman ON sales_name = com_salesman
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on a.company=limitdate.com

WHERE (bugkind =('客户BUG') or (BUGKIND='BI客户BUG' and SUPPORT in (select support_name from support_user)))
AND support IN(SELECT support_name FROM support_user) 
and productline="FR"
AND jira_keys LIKE 'CUSTBUG%' AND bugstatus IN ("研发模块设置","研发处理中") AND createdate>"2016-01-01"
group by a.FR_SYSTEM_ID
HAVING find_in_set(get_com_leader(com_id),'${region}')
ORDER BY sales_region,com_salesman,com_id

/*技术支持日报*/
select uid,a.qanda_question,a.qanda_answer,a.qanda_solved,a.qanda_remarks,a.qanda_recorder,a.qanda_recdate,b.com_id,b.com_name,b.com_salesman,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_regions,b.com_presales,b.com_status,c.cont_name,2000 evaluate_time,sales_region,''mt 
from qq_qanda a 
join cust_company b on a.qanda_company=b.com_id
left join hr_salesman on com_salesman = sales_name
join cust_contact c on a.qanda_contact=c.cont_id
where to_days(qanda_recdate)=to_days('${day}')
HAVING find_in_set(get_com_leader(com_id),'${region}')
UNION 
select id,details,solution,result,tags,service_number,push_time,
com_id,com_name,com_salesman,(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_regions,com_presales,com_status,cont_name,evaluate_time,sales_region,mt from(
SELECT id,details,solution,result,tags,service_number,push_time,evaluate_time,im,cont_name,cont_company from v_service_satisfaction_evaluation join 
cust_contact on im=cont_qq where 1=1
and cont_verified='valid'
and date(push_time)=date('${day}')
UNION
SELECT id,details,solution,result,tags,service_number,push_time,evaluate_time,im,cont_name,cont_company from v_service_satisfaction_evaluation join 
(SELECT * from cust_contact where cont_qq like'%,%' and cont_verified='valid')cust_contact on FIND_IN_SET(im,cont_qq)
where 1=1
and date(push_time)=date('${day}')
)v_sevice 
LEFT JOIN cust_company on cont_company=com_id
left join hr_salesman on com_salesman = sales_name
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on cont_company=limitdate.com

where com_verified='valid'
HAVING find_in_set(get_com_leader(com_id),'${region}')
ORDER BY sales_region,com_salesman

/*技术支持日报*/
SELECT group_support_problem.*,com_status,com_salesman,(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_region,com_id,com_name,cont_name,mt
FROM group_support_problem 
LEFT JOIN cust_company ON gp_com = com_id 
LEFT JOIN cust_contact ON cont_id = gp_concat
LEFT JOIN hr_salesman ON sales_name = com_salesman
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on gp_com=limitdate.com
WHERE 1=1
${if(len(day)=0,""," and date(gp_date) = '"+day+"'")}
HAVING find_in_set(get_com_leader(com_id),'${region}')
ORDER BY sales_region

/*技术支持日报*/
SELECT id,im,details,result,solution,service_number FROM service_satisfaction_evaluation
LEFT JOIN support_user on service_number=support_name
WHERE date(push_time)=date('${day}')
and id NOT IN 
(
SELECT id from service_satisfaction_evaluation join 
cust_contact on im=cont_qq where 1=1
and date(push_time)=date('${day}')
and cont_verified='valid'
union
SELECT id from service_satisfaction_evaluation join 
(select cont_qq from cust_contact where cont_qq REGEXP',' and cont_verified='valid')cust_contact on FIND_IN_SET(im,cont_qq) where 1=1
and date(push_time)=date('${day}')
UNION
SELECT id from service_satisfaction_evaluation join 
cust_contact on im=cont_mobile where 1=1
and date(push_time)=date('${day}')
and cont_verified='valid'
union
SELECT id from service_satisfaction_evaluation join 
(select cont_mobile from cust_contact where cont_mobile REGEXP',' and cont_verified='valid')cust_contact on FIND_IN_SET(im,cont_mobile) where 1=1
and date(push_time)=date('${day}')

) 
and support_group in (SELECT support_group from support_user where 
find_in_set(support_name,'${region}') and support_status=1)
order by push_time

/*技术支持日报*/
select concat(b.pkey,"-",issuenum)jirakeys, c.pname,ASSIGNEE,worklogbody,STARTDATE,a.id,destination from jira.jiraissue a
LEFT JOIN jira.project b on a.PROJECT=b.id
LEFT JOIN jira.worklog on a.id=issueid
AND STARTDATE REGEXP"${day}"
LEFT JOIN jira.issuestatus c on a.issuestatus=c.id
JOIN jira.issuelink ON a.id = source
AND destination in (${dest}) AND linktype=10300


/*技术支持日报*/
SELECT a.id,concat("BI-",a.issuenum)jirakeys,SUMMARY,TIMESTAMPDIFF(day,CREATED,now())cdays,TIMESTAMPDIFF(day,CREATED,date(fa.DATEVALUE))sdays,date(fa.DATEVALUE)endtime,fb.STRINGVALUE comid,fc.STRINGVALUE contid,"BI客户BUG" from jira.jiraissue a
LEFT JOIN jira.customfieldvalue fa on a.id=fa.ISSUE and fa.CUSTOMFIELD=10748
LEFT JOIN jira.customfieldvalue fb on a.id=fb.ISSUE and fb.CUSTOMFIELD=10504
LEFT JOIN jira.customfieldvalue fc on a.id=fc.ISSUE and fc.CUSTOMFIELD=10503
where a.issuestatus in(10118,10564)
and date(fa.DATEVALUE)='${day}'
and PROJECT=10311
and issuetype=10409
and fb.STRINGVALUE is not null
GROUP BY a.id
order by comid,a.id

/*技术支持日报*/
SELECT a.id,concat("BI-",a.issuenum)jirakeys,b.pname,ASSIGNEE,SUMMARY,TIMESTAMPDIFF(day,CREATED,now())cdays,fb.STRINGVALUE comid,fc.STRINGVALUE contid,"BI客户BUG"
from jira.jiraissue a
LEFT JOIN jira.customfieldvalue fb on a.id=fb.ISSUE and fb.CUSTOMFIELD=10504
LEFT JOIN jira.customfieldvalue fc on a.id=fc.ISSUE and fc.CUSTOMFIELD=10503
LEFT JOIN jira.issuestatus b on a.issuestatus=b.id
where 
PROJECT=10311
and issuetype=10409
and fb.STRINGVALUE is not null
and issuestatus not in (SELECT id from jira.issuestatus where pname 
in ("创建者验收", "已解决", "创建者确认", "被否决"))
GROUP BY a.id
order by comid,a.id

SELECT com_id,com_name,com_salesman,com_type,bi_comsupport,cont_id,cont_name,mt
FROM cust_company
JOIN cust_contact ON cont_company=com_id
LEFT JOIN cust_company_bi ON bi_comid=com_id
left join(select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt GROUP BY 1)limitdate on com_id=com
WHERE 
${"com_id in ('"+comid+"') AND cont_id in ('"+contid+"')"} 
GROUP BY com_id

SELECT com_id,com_name,com_salesman,com_type,bi_comsupport,cont_id,cont_name,mt
FROM cust_company
JOIN cust_contact ON cont_company=com_id
LEFT JOIN cust_company_bi ON bi_comid=com_id
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity 
where opp_verified='valid' and opp_status<>'跟进失败'
)dt GROUP BY 1)limitdate on com_id=limitdate.com

WHERE 
${"com_id in ('"+comid+"') AND cont_id in ('"+contid+"')"} 
GROUP BY com_id

SELECT rr.details,rr.solution,ifnull(r2.result,rr.result)result,rr.service_number,rr.push_time,substring_index(ifnull(r2.tags,rr.tags),'-->',1)aa,date(rr.push_time)inputtime,TIMESTAMPDIFF(day,rr.push_time,now())delay,
com_id,com_name,com_salesman,com_presales,com_status,cont_name,ifnull(x.dist_region,y.dist_region)regions,"IMCC问题"k,rr.dialogue_ID qid, mt FROM (
SELECT r.id,r.dialogue_ID,r.solution_dialogue,r.solution,r.service_number,r.tags,r.push_time,cont_name,cont_mobile,cont_company,cont_qq,details,
CASE when tempid IS NOT NULL and tempid <> '' and push_time <= tempPushtime then '已解决' ELSE result END AS result 
from service_satisfaction_evaluation r
join cust_contact on im=cont_qq 
LEFT JOIN `service_satisfaction_canliu` ON find_in_set(r.IM,tempIM)
where 1=1
and cont_verified='valid'
and length(details) <> 0
and (r.tags REGEXP 'BI' or r.service_number in (SELECT support_name from support_user_bi where support_status=1))

and date(r.push_time)>='2017-12-29'
UNION
SELECT r.id,r.dialogue_ID,r.solution_dialogue,r.solution,r.service_number,r.tags,r.push_time,cont_name,cont_mobile,cont_company,cont_qq,details,
CASE when tempid IS NOT NULL and tempid <> '' and push_time <= tempPushtime then '已解决' ELSE result END AS result from service_satisfaction_evaluation r
join (SELECT * from cust_contact where cont_qq like'%,%' and cont_verified='valid')cust_contact on FIND_IN_SET(im,cont_qq)
LEFT JOIN `service_satisfaction_canliu` ON find_in_set(r.IM,tempIM)
where 1=1
and cont_verified='valid'
and length(details) <> 0
and (r.tags REGEXP 'BI' or r.service_number in (SELECT support_name from support_user_bi where support_status=1))
and date(r.push_time)>='2017-12-29'
)rr
LEFT JOIN cust_company on cont_company=com_id 
left join (select dist_region,dist_salesman from dict_district GROUP BY dist_salesman)x on com_salesman=dist_salesman
LEFT JOIN (select dist_region,dist_province from dict_district GROUP BY dist_province)y on com_province=y.dist_province
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity 
where opp_verified='valid' and opp_status<>'跟进失败'
)dt GROUP BY 1)limitdate on com_id=limitdate.com
LEFT JOIN v_service_satisfaction_evaluation r2 on rr.solution_dialogue=r2.id
where com_status in ('合作','跟进','潜在','无效','尚未联络')
and ifnull(r2.result,rr.result)='未解决'
and com_verified='valid'
group by rr.id 

UNION

select gpa.gp_des,gpa.gp_solution,ifnull(gpb.gp_status,gpa.gp_status),gpa.gp_recorder,gpa.gp_date,gpa.gp_tags,date(gpa.gp_date),TIMESTAMPDIFF(day,gpa.gp_date,now()),
com_id,com_name,com_salesman,com_presales,com_status,cont_name,ifnull(x.dist_region,y.dist_region)regions,"其他类型问题",gpa.gp_id,mt from group_support_problem gpa
left join cust_company on gpa.gp_com = com_id 
LEFT JOIN cust_contact on gpa.gp_concat=cont_id
left join sale_opportunity on gpa.gp_oppid=opp_id
LEFT JOIN group_support_problem gpb on gpb.gp_id=gpa.gp_parent
left join (select dist_region,dist_salesman from dict_district GROUP BY dist_salesman)x on com_salesman=x.dist_salesman
LEFT JOIN (select dist_region,dist_province from dict_district GROUP BY dist_province)y on com_province=y.dist_province
LEFT JOIN (select com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity 
where opp_verified='valid' and opp_status<>'跟进失败'
)dt GROUP BY 1)limitdate on com_id=limitdate.com

where (gpa.gp_tags regexp "BI" or gpa.gp_recorder in(select support_name from support_user_bi))
and ifnull(gpb.gp_status,gpa.gp_status)='未解决'
and date(gpa.gp_date)>='2017-12-29'
ORDER BY inputtime desc

