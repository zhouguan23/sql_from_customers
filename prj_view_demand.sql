select * from prj_dict_status

select A.*,B.*,C.opp_name,F.input_date,COALESCE(bm_guwen,com_presales)guwen,bm_guwen,
if(com_status='合作',if(bm_mark='-1','0',ifnull(bm_mark,'0')),'-1')bm_mark,H.CONTRACT_ID from PROJECT_F_REQUIREMENT_INFO A
LEFT JOIN cust_company B ON A.CUST_ID=B.com_id
LEFT JOIN sale_opportunity C ON A.CUST_OPPO_ID=C.opp_id
LEFT JOIN PROJECT_F_REQUIREMENT_MARK F ON A.req_id=f.req_id and F.MARK_TYPEID in("JDZ","JDBZ") and is_deal=F.MARK_TYPEID
left join cust_benchmark on bm_company=com_id
left join project_f_contract_info H on H.req_id=A.req_id
where A.req_id="${uid}"

select *,concat(prj_user,"(",prj_name,")") name from project_members

select *,concat(prj_user,"(",prj_name,")") name from project_members

select *,concat(prj_user,"(",prj_name,")") name from project_members

select *,concat(prj_user,"(",prj_name,")") name from project_members

select *,concat(prj_user,"(",prj_name,")") name from project_members

select user_username,concat(user_username,"(",user_name,")") name from hr_user where user_department=3 and user_state<>"离职"

select distinct user_username,concat(user_username,"(",user_name,")") name from hr_presales
left join hr_user on pres_name=user_username

select distinct user_username,concat(user_username,"(",user_name,")") name from hr_salesman
left join hr_user on sales_name=user_username

select * from prj_project_tags
left join prj_tag_type on tags_type=tag_type_id
where tags_project="${keyid}"order by tag_type_order

select *,ifnull(tag_type_multi,1) is_multi from prj_tag_type where tag_type_verified=1 and tag_type_project=1 and tag_type_mark=1
order by tag_type_order

select * from prj_project_performance
left join prj_performance_goal on performance_goal=goal_id
where performance_project="${keyid}"
order by goal_order,goal_id

select * from prj_performance_goal

select max(key_id) from project_opportunity1

select A.*,B.*,if(com_status='合作',if(bm_mark='-1','0',ifnull(bm_mark,'0')),'-1')bm_mark from project_opportunity1 A
LEFT JOIN cust_company B ON customer_id=com_id
left join cust_benchmark on bm_company=com_id
where key_id="${keyid}"

SELECT ctr_salesman,sum(outspay_paid) paid,month(outspay_paydate) month,year(outspay_paydate) year,outs_contract FROM `sale_outsource` a
left join v_sale_contract_info_valid b on outs_contract=ctr_id
left join sale_outsource_payment e on outs_id=outspay_outsource
where outs_status!="已作废" and outs_contract in (select contract_id from project_opportunity1 where key_id="${keyid}")
group by ctr_id
order by month(outspay_paydate)

select * from finan_recoup where project_id="${keyid}" and status="已报销"

select * from prj_project_role
where role_project="${keyid}"


select * from prj_project_milestone
left join prj_milestone_node on node_name=milestone_node
where milestone_project="${keyid}"
order by milestone_order,milestone_date_plan

select * from prj_project_stakeholder
where stake_project="${keyid}"

select * from (select record_point,record_remark,record_creator,record_time from prj_project_record
where record_project="${keyid}" 
union
SELECT 
	HISTORY_TYPE  record_point,
	HISTORY_CONTENT record_remark,
	INPUT_PERSON record_creator,
	INPUT_DATE record_time
FROM PROJECT_F_HISTORY 
WHERE REQ_ID='${uid}'
order by record_time desc)main limit 10

select * from prj_project_document
where doc_project="${keyid}"

select concat(prj_user,"(",prj_name,")") coop_name,prj_user name_id,"项目组人员" type_name from project_members
union
select distinct coop_name,coop_id name_id,"合作伙伴/外包" type_name from project_opportunity1
left join sale_outsource on outs_contract=contract_id
left join sale_supplier_cooperation on outs_supplier=coop_supplier
where key_id="${keyid}"
union
select stake_name coop_name,concat("${keyid}",stake_id) name_id,"合作伙伴/外包" type_name from prj_project_stakeholder
where stake_project="${keyid}"

select * from prodemandeva_attachments where fileid = "${F1}"

select project,sum(days)days,sum(end_days)end_days,user from (
/*每个人在每个项目的人天数*/
select user,project,count(*)*0.5 days,sum(ifnull(c.c_value,1)*0.5)end_days from (
select * from hr_time where out_type=4
)a join (
select * from hr_time_reason where project is not null 
)b on a.reason_id=b.reason_id
left join project_out_coefficient c on user=c_username and day BETWEEN c_startdate and c_enddate
/*在人天系数范围内的取设定的人天系数，不在的取人天系数为 1 */
where user not in('tiny','galaxy')/*tiny , galaxy不统计人天*/
GROUP BY user,project
)v 
where project="${keyid}"
GROUP BY project,user

SELECT prj_days FROM project_opportunity1
left join sale_contract_of_project on prj_contract=contract_id
where key_id="${keyid}"

select coop_name,name_id,type_name from prj_project_role
left join
(select prj_user coop_name,prj_id name_id,"项目组人员" type_name from project_members
union
select distinct coop_name,coop_id name_id,"合作伙伴/外包" type_name from project_opportunity1
left join sale_outsource on outs_contract=contract_id
left join sale_supplier_cooperation on outs_supplier=coop_supplier
where key_id="${keyid}")s on name_id=role_user
union
select stake_name coop_name,concat("${keyid}",stake_id) name_id,"关键干系人" type_name from prj_project_stakeholder
where stake_project="${keyid}"

select sum(cost_amount) amount from prj_project_cost where cost_project="${keyid}"

select * from hr_department_team
where team_id in (1,2,3,4,5,6,7,15,19)

SELECT fr_system_id,bug_id,BUGKIND,jira_keys,BUGTITLE,BUGSTATUS,CHARGER,CREATEDATE,ENDTIME,projectname from fr_t_system1 where projectname is not null
and projectname="${keyid}" and BUGSTATUS not in ("已解决","终止开发")
order by CREATEDATE desc

SELECT a.audit_id,a.audit_project,a.audit_type,a.audit_finish_date,a.audit_remark,a.audit_check,a.audit_check_remark,
if(a.audit_type='运维交接',if(isnull(b.PROJECTID)=1,'false','true'),a.audit_is_done) audit_is_done
 FROM `prj_project_audit`  a
left join (SELECT PROJECTID
FROM OPR_F_TAKEOVER 
WHERE TAKEOVERSTATUS IN ('技术支持通过' ,'运维通过')
) b on a.audit_project = b.PROJECTID
where audit_project="${keyid}"

select * from prj_project_warning
where warn_project="${keyid}"

