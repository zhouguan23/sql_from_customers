select a.key_id,a.prj_number,a.customer_id,b.com_name,a.opportunity_name,c.tags_names,d.waibaotype,e.dengji,a.prj_rentian,ifnull(f.cnt1,0)cnt1,ifnull(f.cnt2,0)cnt2,a.prj_status,a.prj_apply_status,ifnull(A.prj_apply_status,A.prj_status) status,
b.com_sales_region,a.prj_salesman_name,a.prj_presales_name,g.team_name,a.projectmanager_name,a.project_manager_zxname,concat(ifnull(h.num1,0),"(",ifnull(h.num2,0),"+",ifnull(h.num3,0),")") num,
concat(ifnull(i.rt1,0),"(",ifnull(i.rt2,0),"+",ifnull(i.rt3,0),")") rt,j.paid,k.waibaoamount,DATE_FORMAT(a.prj_createdate,'%Y-%m-%d') prj_createdate,DATE_FORMAT(a.prj_appovedate,'%Y-%m-%d') prj_appovedate,
a.prj_startdate,a.prj_enddate,l.minday,l.maxday,history.history_time,n.audit_status,n.type,n.dengji2,n.rentian,
if(DATEDIFF(CURDATE(),a.prj_enddate)>0, 1, 0) chaoshijian,ifnull(i.rt1,0)rt1,
if(a.contract_id is null or length(a.contract_id)=0,1,0) hetong,j.pay_unpaid,
if(prj_status="立项阶段",1,if(prj_status="实施阶段"&&prj_apply_status is null,2,if(prj_status="项目暂停"&&prj_apply_status is null,3,if(prj_apply_status="申请暂停",4,if(prj_apply_status="申请重启",5,if(prj_apply_status="申请结项",6,if(prj_status="运维阶段",7,8))))))) paixu
,tag_name,hy_prj_character,hy_prj_detail
from project_opportunity1 a 
join (select * from prj_project_tags where tags_type='3')s on s.tags_project=a.key_id and s.tags_names = '19'
join prj_tag on tag_type=3 and tag_id=s.tags_names
left join prj_hyh_character on hy_prj_keyid=a.key_id and hy_prj_tag=tag_id
left join cust_company b on a.customer_id = b.com_id
left join (select 	C.tag_id ,tag_name tags_names,hh.tags_project from (select tags_names,tags_project from prj_project_tags where tags_type=24 and tags_project is not null)hh
left join (select tag_id,tag_name from prj_tag  where tag_type='24') C  on hh.tags_names =C.tag_id )c on c.tags_project=a.key_id/*项目模式*/
left join (select tag_name waibaotype,B.tags_project from (select  tags_names ,tags_project from prj_project_tags where tags_type=37 and tags_project is not null)B
left join (select tag_id,tag_name from prj_tag  where tag_type='37') C on B.tags_names= C.tag_id)d on d.tags_project=a.key_id /*外包类型*/
left join (select group_concat(tag_name) dengji,B.tags_project from (select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)B
left join (select tag_id,tag_name from prj_tag  where tag_type='32') C on B.tags_names= C.tag_id group by  B.tags_project )e on e.tags_project=a.key_id /*项目等级*/
left join (select count(uuid) cnt1,key_id,sum(if(audit_status <>"通过",1,0)) cnt2,sum(if(audit_status ="未审核",1,0)) cnt3,sum(if(audit_status ="未通过",1,0)) cnt4,sum(if(audit_status ="通过",1,0)) cnt5 from prj_jizhun_modify group by key_id) f on f.key_id = a.key_id
left join hr_department_team g on a.prj_team = g.team_id
left join (select role_project,count(role_id) num1,sum(if(role_type='1',1,0)) num2,sum(if(role_type='0',1,0)) num3  from prj_project_role group by role_project ) h on h.role_project=a.key_id /*1-帆软人员，0-外包人员*/
left join (select project,cast(sum(rt1) as decimal(8,2)) rt1,cast(sum(rt2) as decimal(8,2)) rt2,cast(sum(rt3)as decimal(8,2)) rt3 from (
select project,sum(ifnull(b.c_value,1)*0.5) rt1,sum(if(user_type='1',ifnull(b.c_value,1)*0.5,0))  rt2,sum(if(user_type='0',ifnull(b.c_value,1)*0.5,0))  rt3
from prj_qiandao_time a 
left join project_out_coefficient b on a.user = b.c_username and a.day BETWEEN b.c_startdate and b.c_enddate
where project_type ='项目实施'
group by project
union ALL
select c.key_id project,cast(sum(ifnull(b.c_value,1)*0.5) as decimal(8,1)) rt1,sum(if(user_type='1',ifnull(b.c_value,1)*0.5,0)) rt2,sum(if(user_type='0',ifnull(b.c_value,1)*0.5,0)) rt3
from prj_qiandao_time a
left join project_out_coefficient b on a.user = b.c_username and a.day BETWEEN b.c_startdate and b.c_enddate
left join project_opportunity1 c on a.project = c.prj_number
where project_type ='需求评估'
group by project
union 
select c.key_id,sum(if(TO_DAYS(CREATEDATE) - TO_DAYS('2018-10-01')<0 && bugkind ='二次开发',ifnull(timeoriginalestimate,0),ifnull(timespent,0))) rt1,sum(if(TO_DAYS(CREATEDATE) - TO_DAYS('2018-10-01')<0 && bugkind ='二次开发',ifnull(timeoriginalestimate,0),ifnull(timespent,0))) rt2,0 rt3 from project_opportunity1 a 
left join (select * from fr_t_system1 where  projectname is not null and bugkind in ('二次开发','视觉需求')) b on a.key_id =  b.projectname or a.prj_number = b.projectname or a.opportunity_name = b.projectname
left join (select * from project_opportunity1 where prj_status <>'无效') c on a.prj_number = c.prj_number
group by  c.key_id ) a group by project) i on i.project= a.key_id
left join (select a.ctrlink_key,concat(cast(sum(ifnull(pay_paid,0)) as decimal(9,2)),'/',cast(sum(ifnull((ifnull(b.ctr_amount,0)-ifnull(sumpay_bill,0)),0)*ifnull(e.f_amount,1)) as decimal(9,2))) paid,sum(ifnull(pay_unpaid,0)*ifnull(e.f_amount,1)) pay_unpaid from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract= b.ctr_id and b.ctr_status <>'已作废'
left join (select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract bill_contract from sale_payment 
left join finan_other_statistics  on f_remark='CNY' and f_type=pay_currency
where pay_verified="valid" group by pay_contract)c on c.bill_contract=b.ctr_id  and b.ctr_status <>"已作废"/*已回款*/
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) sumpay_bill FROM sale_payment WHERE pay_status IN ('记坏账', '已作废') GROUP BY pay_contract) d ON d.pay_contract = b.ctr_id and b.ctr_status <>"已作废" /*作废回款*/
left join finan_other_statistics e on e.f_remark='CNY' and e.f_type=b.ctr_currency
LEFT JOIN (SELECT pay_contract,sum(IFNULL(pay_bill, 0)) pay_unpaid FROM sale_payment WHERE pay_status in ("未开票","已到期","待收款") and ifnull(pay_paid,0)=0 and pay_predate<curdate() and pay_verified="valid" GROUP BY pay_contract) f ON f.pay_contract = b.ctr_id and b.ctr_status <>"已作废"
group by a.ctrlink_key) j on j.ctrlink_key = a.key_id
left join (select a.app_project,concat(sum(ifnull(payamount,0)),"/",sum(ifnull(waibaoamount,0))) waibaoamount from sale_outsource_apply a
left join (select sum(outspay_amount) waibaoamount,outspay_appid from sale_outsource_payment group by outspay_appid)aa on a.app_id =aa.outspay_appid
left join (select sum(outspay_paid) payamount,outspay_appid from sale_outsource_payment where outspay_status ='已付款' group by outspay_appid)bb on a.app_id =bb.outspay_appid
where a.app_audit = '执行中' and a.app_project is not null
group by app_project) k on k.app_project = a.key_id
left join (select min(minday) minday,max(maxday) maxday,if(project_type ='需求评估',b.key_id,a.project) project from (
select  min(day) minday,max(day) maxday,project_type,project,user from prj_qiandao_time  where project_type in ('需求评估','项目实施')  group by project,project_type) a
left join project_opportunity1 b on a.project = b.prj_number and a.project_type ='需求评估'
 group by if(project_type ='需求评估',b.key_id,a.project) ) l on l.project=a.key_id
left join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=a.key_id
left join project_members m on m.prj_team=a.prj_team and m.prj_is_leader=1
left join (select * from (select audit_status,key_id,if(type_before<>type_after,1,0) type,if(dengji_before<>dengji_after,1,0) dengji2,if(rentian_before<>rentian_after,1,0) rentian from prj_jizhun_modify order by record_time desc) kk group by key_id) n on n.key_id = a.key_id
${if(len(paystatus)=0,"","left join (select sum(ifnull(pay_bill,0)) prjpay_bill,ctrlink_key paid_key from sale_payment left join project_contract_link on ctrlink_contract=pay_contract where pay_status in ('未开票','已到期','待收款') and ifnull(pay_paid,0)=0  and pay_verified='valid' group by ctrlink_key)prjkey_paid on paid_key=a.key_id")}
${if(len(leixing)=0,"","left join prj_supervise_manage su on su.sup_keyid = a.key_id")}
where prj_status <>'无效'
${if(len(num)=0,"","and a.prj_number regexp '"+num+"'")}
${if(len(company)=0,"","and b.com_name  like '%"+company+"%' ")}
${if(len(oppname)=0,"","and a.opportunity_name like '%"+oppname+"%' ")}
${if(len(paystatus)=0,"","and if(j.ctrlink_key is null,2,if(ifnull(prjpay_bill,0)=0,1,0)) in ('"+paystatus+"')")}
${if(len(status)=0,"","and if(a.prj_apply_status=''||a.prj_apply_status is null,a.prj_status,a.prj_apply_status) in ('"+status+"')")}
${if(len(salesman)=0,"","and a.prj_salesman in ('"+treelayer(salesman,true,"\',\'")+"')")}
${if(len(manager)=0,"","and a.projectmanager in ('"+treelayer(manager,true,"\',\'")+"')")}
${if(len(team)=0,"","and a.prj_team in  ('"+team+"')")}
${if(len(prj_startdate)=0,"","and a.prj_startdate>='"+prj_startdate+"'")}
${if(len(prj_enddate)=0,"","and a.prj_enddate<='"+prj_enddate+"'")}
${if(len(prj_tag)=0,"","and c.tag_id in ('"+prj_tag+"')")}
${if(len(presales)=0,"","and a.prj_presales in ('"+treelayer(presales,true,"\',\'")+"')")}
${if(len(leixing)=0 ,""," and ( CONCAT_WS(',',if(a.contract_id is null or length(a.contract_id)=0 ,'无合同',''),if(ifnull(i.rt1,0)>prj_rentian,'超人天',''),if(DATEDIFF(CURDATE(),a.prj_enddate)>0,'超时间',''),if(su.sup_type='不监管','不监管','')) "+Label1 +") ")}
${if(len(warn)=0 ,""," and ( "+Label2 +") ")}
${if(len(hy_char)=0 ,""," and  concat(',',hy_prj_character,',') regexp ',"+hy_char+",'")}
${if(len(hy_detail)=0 ,""," and  hy_prj_detail like '%"+hy_detail+"%'")}
order by paixu,customer_id,prj_number,opportunity_name

select * from prj_project_tags


select * from prj_tag_type where tag_type_verified=1 and tag_type_project=1
order by tag_type_order

select dict_prj_status from prj_dict_status
union
select dict_prj_applt_type from prj_dict_status

select * from prj_tag
where tag_type=3

select user_username,concat(user_username,"(",user_name,")") name,sales_region from hr_salesman
left join hr_user on user_username=sales_name
where sales_region is not null
order by sales_region,user_name


select *,concat(prj_user,"(",prj_name,")") name from project_members

SELECT dict_prj_applt_type FROM `prj_dict_status`

select * from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by team_paixu

select prj_user,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_project=1 and team_verified="valid" and prj_verified="valid"
union select team_name as prj_user,null as team_name,team_name as name,team_paixu from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by team_paixu,prj_user

select user_username,concat(user_username,"(",user_name,")") name,pres_region from hr_presales
left join hr_user on user_username=pres_name
where pres_region is not null
order by pres_region,user_name

select * from prj_tag
where tag_type=24 and tag_verified=1
order by tag_order

select * from dict_prj_hyh_char

