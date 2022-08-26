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
HAVING get_com_leader_change(com_id) in ('${region}')
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
HAVING get_com_leader_change(com_id) in ('${region}')
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
HAVING get_com_leader_change(com_id) in ('${region}')
ORDER BY sales_region,com_salesman,com_id

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
HAVING get_com_leader_change(com_id) in ('${region}')
ORDER BY sales_region

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
LEFT JOIN `service_satisfaction_canliu` ON r.im = tempIM
where 1=1
and cont_verified='valid'
and length(details) <> 0
and (r.tags REGEXP 'BI' or r.service_number in (SELECT support_name from support_user_bi where support_status=1))
and r.push_time>='2017-12-29'
having get_com_leader_change(cont_company) in ('${region}')
UNION
SELECT r.id,r.dialogue_ID,r.solution_dialogue,r.solution,r.service_number,r.tags,r.push_time,cont_name,cont_mobile,cont_company,cont_qq,details,
CASE when tempid IS NOT NULL and tempid <> '' and push_time <= tempPushtime then '已解决' ELSE result END AS result from service_satisfaction_evaluation r
join (SELECT * from cust_contact where cont_qq like'%,%' and cont_verified='valid')cust_contact on FIND_IN_SET(im,cont_qq)
LEFT JOIN `service_satisfaction_canliu` ON r.im = tempIM
where 1=1
and cont_verified='valid'
and length(details) <> 0
and (r.tags REGEXP 'BI' or r.service_number in (SELECT support_name from support_user_bi where support_status=1))
and r.push_time>='2017-12-29'
having get_com_leader_change(cont_company) in ('${region}')
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
and gpa.gp_date>='2017-12-29'
having get_com_leader_change(com_id) in ('${region}')
ORDER BY inputtime desc

select A.*,support_name,support_group from
(select _id as id,
_widget_1584336630853 as contact,
_widget_1584335876535 as all_detail,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator 
from `xyxwtlr(wqy)`
where _id not in (
select _id from `xyxwtlr(wqy)`
left join cust_contact on cont_qq=_widget_1584336630853
where cont_verified="valid"
UNION
select _id from `xyxwtlr(wqy)`
left join cust_contact_way on (way_entity=_widget_1584336630853 and way_type in ("qq","mobile") and way_verified="valid")
left join cust_contact on way_contact=cont_id 
where  cont_verified="valid"
UNION
select _id from `xyxwtlr(wqy)`
left join cust_contact on cont_mobile=_widget_1584336630853
where cont_verified="valid"
)
and createtime>=concat('${day}'," 00:00:00") and createtime<=concat('${day}'," 23:59:59")
)A
left join support_user on support_name=creator
where support_group in (SELECT support_group from support_user where 
support_name in ('${region}') and support_status=1)

select C.*,support_name,support_group from
(select * from
(select * from
(select _id as id,
_widget_1584336630853 as contact,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_company,com_name,com_status,createtime  
from `xyxwtlr(wqy)`
left join cust_contact on cont_qq=_widget_1584336630853
left join cust_company on com_id=cont_company
where cont_verified="valid" and com_verified="valid" and com_status in ('合作','跟进')
UNION
select _id as id,
_widget_1584336630853 as contact,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_company,com_name,com_status,createtime 
from `xyxwtlr(wqy)`
left join cust_contact_way on (way_entity=_widget_1584336630853 and way_type in ("qq","mobile") and way_verified="valid")
left join cust_contact on way_contact=cont_id 
left join cust_company on com_id=cont_company
where  cont_verified="valid" and com_verified="valid" and com_status in ('合作','跟进')
UNION
select _id as id,
_widget_1584336630853 as contact,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_company,com_name,com_status,createtime 
from `xyxwtlr(wqy)`
left join cust_contact on cont_mobile=_widget_1584336630853
left join cust_company on com_id=cont_company
where cont_verified="valid" and com_verified="valid" and com_status in ('合作','跟进')
)A
order by createtime desc
)B
group by cont_company
order by createtime desc
)C
left join support_user on support_name=creator
where DATE_ADD(createtime,INTERVAL 1 month)<'${day}'
and support_group in (SELECT support_group from support_user where 
support_name in ('${region}') and support_status=1)

select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,stringvalue,D.customvalue
from jiraissue A
left join issuestatus on issuestatus.id=A.issuestatus
left join (select * from customfieldvalue where CUSTOMFIELD="14301") C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
where A.PROJECT=10600 and stringvalue is not null

/*技术支持日报*/
select id,contact,creator,createtime,_widget_1584335876535 as all_detail, 
com_id,com_name,com_salesman,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_regions,
com_presales,com_status,cont_name,sales_region,mt from(
SELECT _id as id,
_widget_1584336630853 as contact,
_widget_1584335876535,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_name,cont_company,createtime 
from `xyxwtlr(wqy)`
join cust_contact on _widget_1584336630853=cont_qq 
where cont_verified='valid'
and createtime>=concat('${day}'," 00:00:00") and createtime<=concat('${day}'," 23:59:59")
UNION
select _id as id,
_widget_1584336630853 as contact,
_widget_1584335876535,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_name,cont_company,createtime  
from `xyxwtlr(wqy)`
left join cust_contact_way on (way_entity=_widget_1584336630853 and way_type in ("qq","mobile") and way_verified="valid")
left join cust_contact on way_contact=cont_id 
where  cont_verified="valid"
and createtime>=concat('${day}'," 00:00:00") and createtime<=concat('${day}'," 23:59:59")
union
SELECT _id as id,
_widget_1584336630853 as contact,
_widget_1584335876535,
SUBSTRING_INDEX(SUBSTRING_INDEX(creator,'-',1),',"name":"',-1) as creator,
cont_name,cont_company,createtime  
from `xyxwtlr(wqy)`
join cust_contact on _widget_1584336630853=cont_mobile
where cont_verified='valid'
and createtime>=concat('${day}'," 00:00:00") and createtime<=concat('${day}'," 23:59:59")
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
HAVING get_com_leader_change(com_id) in ('${region}')
ORDER BY sales_region,com_salesman

select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,C.stringvalue as comid,I.stringvalue as salesman,
J.stringvalue as comstatus,D.stringvalue as cont_id,
A.SUMMARY as title,if(F.stringvalue="16109" or G.pname="BUG已解决","已解决","未解决") as bug_status,H.pname as bug_type,creator
from jiraissue A
left join issuestatus on issuestatus.id=A.issuestatus
/*公司ID*/
left join (select * from customfieldvalue where CUSTOMFIELD="10504") C on C.issue=A.ID
/*联系人ID*/
left join (select * from customfieldvalue where CUSTOMFIELD="10503") D on D.issue=A.ID
/*当前问题关键点标记为【客户确认解决】*/
left join (select * from customfieldvalue where CUSTOMFIELD="14304") F on F.issue=A.ID and F.stringvalue="16109"
left join issuestatus G on G.ID=A.issuestatus
left join issuetype H on H.ID=A.issuetype
/*责任销售*/
left join (select * from customfieldvalue where CUSTOMFIELD="10549") I on I.issue=A.ID
/*公司状态*/
left join (select * from customfieldvalue where CUSTOMFIELD="10505") J on J.issue=A.ID
where A.PROJECT=10600 and (H.pname<>"否定答复" or length(H.pname)=0)
and date(created)='${day}'
order by I.stringvalue,created desc

select *,(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_regions from hr_salesman
where sales_region <> "" or sales_region is not null

select A.*,cont_name,com_salesman,com_presales,com_status,
(case when(sales_region = "南京") then "苏皖" when(sales_region = "成都") then "西南" else "" end) sales_regions,
sales_region from
(select bug_id,company,contact,
creator,CREATEDATE,BUGTITLE,concat("未解决",bug_id) as bug_status,"产品需求" as kind from fr_t_system1
join support_user on creator=support_name
where bugscene not like "%[ jira编号：%" and bugkind="客户需求"
and createdate='${day}'
UNION
select bug_id,company,contact,
creator,CREATEDATE,BUGTITLE,concat("未解决",jira_keys) as bug_status,"否定答复" as kind from fr_t_system1
join support_user on creator=support_name
where BUGKIND="否定答复申请"
and createdate='${day}'
)A
left join cust_company on com_id=company
left join hr_salesman on com_salesman = sales_name
left join cust_contact on cont_id=contact
having get_com_leader_change(company) in ('${region}')

/*技术支持日报*/
select dt.com_id com,max(due_date)mt from(
select due_company com_id,due_date from v_support_service_due 
union
select opp_company,opp_predate from sale_opportunity where opp_verified='valid' and opp_status<>'跟进失败'
union
select agr_company,agr_enddate FROM sale_agreement_info a where agr_status not in('待审核','不合格')
)dt 
left join cust_company C on C.com_id=dt.com_id
where com_verified='valid'
group by C.com_id
ORDER BY com_salesman

