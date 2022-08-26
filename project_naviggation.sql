select ifnull(sum(num),0) num,ifnull(sum(ifnull(cnt1,0)),0) cnt1,ifnull(sum(ifnull(cnt2,0)),0) cnt2,ifnull(sum(ifnull(cnt3,0)),0) cnt3,ifnull(sum(ifnull(cnt4,0)),0) cnt4,ifnull(sum(ifnull(cnt5,0)),0) cnt5,
ifnull(sum(ifnull(evaluatehour,0)),0) evaluatehour,ifnull(sum(ifnull(tingzhi,0)),0) tingzhi from (
select 1 num,case when EVA_STATUS = "待评估" then 1 else 0 end as cnt1,case when EVA_STATUS = "评估中" then 1 else 0 end as cnt2,
case when EVA_STATUS = "搁置中" then 1 else  0 end as cnt3,case when EVA_STATUS = "转项目关闭" then 1 else 0 end as cnt4,
case when EVA_STATUS ="转无产出关闭" then 1 else 0 end as cnt5,	if(CASE WHEN  EVA_STATUS="待评估" THEN TIMESTAMPDIFF(HOUR, REQ_INPUT_DATE,NOW())
		   ELSE 0 END >24,1,0)
	evaluatehour ,	if(CASE WHEN  EVA_STATUS="评估中" THEN TIMESTAMPDIFF(HOUR,H.lasttime,NOW()) ELSE 0
	END >168,1,0)	tingzhi
from PROJECT_F_REQUIREMENT_INFO A
LEFT JOIN (select REQ_ID,max(INPUT_DATE) lasttime from project_f_history GROUP BY REQ_ID) H ON A.REQ_ID=H.REQ_ID #最近更新时间
where A.req_id not in ('20161700149','20161700131','20161700050','20161700044','20161700034')) a

select ifnull(sum(num),0) num,ifnull(sum(ifnull(cnt1,0)),0) cnt1,ifnull(sum(ifnull(cnt2,0)),0) cnt2,ifnull(sum(ifnull(cnt3,0)),0) cnt3,ifnull(sum(ifnull(cnt4,0)),0) cnt4,ifnull(sum(ifnull(cnt5,0)),0) cnt5,
ifnull(sum(ifnull(evaluatehour,0)),0) evaluatehour,ifnull(sum(ifnull(tingzhi,0)),0) tingzhi from (
select 1 num,case when EVA_STATUS = "待评估" then 1 else 0 end as cnt1,case when EVA_STATUS = "评估中" then 1 else 0 end as cnt2,
case when EVA_STATUS = "搁置中" then 1 else  0 end as cnt3,case when EVA_STATUS = "转项目关闭" then 1 else 0 end as cnt4,
case when EVA_STATUS ="转无产出关闭" then 1 else 0 end as cnt5,	
if(CASE WHEN  EVA_STATUS="待评估" THEN TIMESTAMPDIFF(HOUR, REQ_INPUT_DATE,NOW())
		   ELSE 0 END >24,1,0)evaluatehour ,	
if(CASE WHEN  EVA_STATUS="评估中" THEN TIMESTAMPDIFF(HOUR,H.lasttime,NOW()) ELSE 0
	END >168,1,0)	tingzhi
from PROJECT_F_REQUIREMENT_INFO A
LEFT JOIN (select REQ_ID,max(INPUT_DATE) lasttime from project_f_history GROUP BY REQ_ID) H ON A.REQ_ID=H.REQ_ID #最近更新时间
where A.req_id not in ('20161700149','20161700131','20161700050','20161700044','20161700034') 
${if(find('销售',fr_userposition)<>0," and A.PERSON_SALES = '"+fr_username+"'",if(find('售前',fr_userposition)<>0," and A.PERSON_PRESALE= '"+fr_username+"'","and A.EVA_PERSON='"+fr_username+"'"))}
) a

select ifnull(sum(num),0) num,ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2 from (
select case when a.prj_status = '已审核' then 1 else 0 end as num,
case when a.prj_status = '已审核' && (length(li.prj_number) = 0 OR li.prj_number IS NULL) && e.ctr_status IN ('待录入','待处理','待收回','已收回','已存档','订单已处理') then 1 else 0 end as cnt1,
case when b.req_id <> li.prj_number && i.REQ_ID <> li.prj_number && length(li.prj_number) <> 0 && e.ctr_status IN ('待录入','待处理','待收回','已收回','已存档','订单已处理')then 1 else 0 end as cnt2
from sale_contract_audit_project a
LEFT JOIN PROJECT_F_REQUIREMENT_INFO b on a.prj_num=b.req_id
left join project_contract_link pc on a.prj_contract = pc.ctrlink_contract
LEFT JOIN project_opportunity1 li on pc.ctrlink_key=li.key_id
LEFT JOIN cust_company c ON b.CUST_ID=c.com_id
LEFT JOIN sale_contract_info e ON a.prj_contract=e.ctr_id
left join project_f_contract_info i on a.prj_contract = i.CONTRACT_ID
where 1=1) a

select ifnull(sum(num),0) num,ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2 from (
select case when a.prj_status = '已审核' then 1 else 0 end as num,
case when a.prj_status = '已审核' && (length(li.prj_number) = 0 OR li.prj_number IS NULL) && e.ctr_status IN ('待录入','待处理','待收回','已收回','已存档','订单已处理') then 1 else 0 end as cnt1,
case when b.req_id <> li.prj_number && i.REQ_ID <> li.prj_number && length(li.prj_number) <> 0 && e.ctr_status IN ('待录入','待处理','待收回','已收回','已存档','订单已处理')then 1 else 0 end as cnt2
from sale_contract_audit_project a
LEFT JOIN PROJECT_F_REQUIREMENT_INFO b on a.prj_num=b.req_id
left join project_contract_link pc on a.prj_contract = pc.ctrlink_contract
LEFT JOIN project_opportunity1 li on pc.ctrlink_key=li.key_id
LEFT JOIN cust_company c ON b.CUST_ID=c.com_id
LEFT JOIN sale_contract_info e ON a.prj_contract=e.ctr_id
left join project_f_contract_info i on a.prj_contract = i.CONTRACT_ID
left join  (select team_id,team_manager  from hr_department_team where team_department='18') h on li.prj_team=h.team_id
where 1=1
${if(find('销售',fr_userposition)<>0," and e.ctr_salesman = '"+fr_username+"'",if(find('售前',fr_userposition)<>0," and e.ctr_presales= '"+fr_username+"'","and (li.projectmanager='"+fr_username+"' or h.team_manager ='"+fr_username+"') "))}
) a
where 1=1

select ifnull(count(key_id),0) cnt from (select * from project_opportunity1 where prj_status<>'无效' and (contract_id is null or LENGTH(contract_id) =0 ) )a
left join (select team_id,team_manager  from hr_department_team where team_department='18') h on a.prj_team=h.team_id
where 1=1
${if(find('销售',fr_userposition)<>0," and prj_salesman = '"+fr_username+"'",if(find('售前',fr_userposition)<>0," and  prj_presales= '"+fr_username+"'","and ( projectmanager='"+fr_username+"' or  team_manager ='"+fr_username+"') "))}

select ifnull(sum(num),0) num,ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2,ifnull(sum(cnt3),0) cnt3,
ifnull(sum(cnt4),0) cnt4,ifnull(sum(cnt5),0) cnt5,ifnull(sum(cnt6),0) cnt6,ifnull(sum(cnt7),0) cnt7 from (
select 1 num,case when prj_status ='立项阶段' and prj_apply_status is null then 1 else 0 end as cnt1,
case when prj_apply_status ='申请立项' then 1 else 0 end as cnt2,
case when prj_status ='实施阶段' and prj_apply_status is null then 1 else 0 end as cnt3,
case when prj_status ='项目暂停' then 1 else 0 end as cnt4,
case when prj_apply_status ='申请结项' then 1 else 0 end as cnt5,
case when prj_status ='运维阶段' then 1 else 0 end as cnt6,
case when prj_status ='项目关闭' then 1 else 0 end as cnt7
from project_opportunity1 
where prj_status <>'无效')a

select ifnull(sum(num),0) num,ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2,ifnull(sum(cnt3),0) cnt3,
ifnull(sum(cnt4),0) cnt4,ifnull(sum(cnt5),0) cnt5,ifnull(sum(cnt6),0) cnt6,ifnull(sum(cnt7),0) cnt7 from (
select 1 num,case when prj_status ='立项阶段' and prj_apply_status is null then 1 else 0 end as cnt1,
case when prj_apply_status ='申请立项' then 1 else 0 end as cnt2,
case when prj_status ='实施阶段' and prj_apply_status is null then 1 else 0 end as cnt3,
case when prj_status ='项目暂停' then 1 else 0 end as cnt4,
case when prj_apply_status ='申请结项' then 1 else 0 end as cnt5,
case when prj_status ='运维阶段' then 1 else 0 end as cnt6,
case when prj_status ='项目关闭' then 1 else 0 end as cnt7
from project_opportunity1 a
left join hr_department_team b on a.prj_team = b.team_id 
where prj_status <>'无效' 
${if(find('销售',fr_userposition)<>0," and prj_salesman = '"+fr_username+"'",if(find('售前',fr_userposition)<>0," and  prj_presales= '"+fr_username+"'","and ( projectmanager='"+fr_username+"' or  team_manager ='"+fr_username+"') "))}
)a

select ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2,ifnull(sum(cnt3),0) cnt3,ifnull(sum(cnt4),0) cnt4,ifnull(sum(cnt5),0) cnt5
from project_opportunity1 opp left join 
(
select case when d.fr_system_id is not null then 1 else 0 end as cnt1,
case when d.BUGKIND = '项目组BUG' then 1 else 0 end as cnt2,
case when d.BUGKIND ='客户需求' then 1 else 0 end as cnt3,
case when d.BUGKIND  in ('二次开发','二次开发BUG') then 1 else 0 end as cnt4,
case when d.BUGKIND = '视觉需求' then 1 else 0 end as cnt5,prj_number
from project_opportunity1 a 
left join (select fr_system_id,bug_id,BUGKIND,jira_keys,BUGTITLE,BUGSTATUS,CHARGER,CREATEDATE,ENDTIME,projectname from fr_t_system1 where  projectname is not null ) d on  d.projectname = a.key_id or d.projectname = a.prj_number or d.projectname = a.opportunity_name 
where 1=1) a on opp.prj_number = a.prj_number
where opp.prj_status <> '无效'

select ifnull(sum(cnt1),0) cnt1,ifnull(sum(cnt2),0) cnt2,ifnull(sum(cnt3),0) cnt3,ifnull(sum(cnt4),0) cnt4,ifnull(sum(cnt5),0) cnt5
from project_opportunity1 opp left join 
(
select case when d.fr_system_id is not null then 1 else 0 end as cnt1,
case when d.BUGKIND = '项目组BUG' then 1 else 0 end as cnt2,
case when d.BUGKIND ='客户需求' then 1 else 0 end as cnt3,
case when d.BUGKIND in ('二次开发','二次开发BUG') then 1 else 0 end as cnt4,
case when d.BUGKIND = '视觉需求' then 1 else 0 end as cnt5,prj_number
from project_opportunity1 a 
left join (select fr_system_id,bug_id,BUGKIND,jira_keys,BUGTITLE,BUGSTATUS,CHARGER,CREATEDATE,ENDTIME,projectname from fr_t_system1 where  projectname is not null and BUGSTATUS not in ('已解决','终止开发','被否决','验收完成','已删除') ) d on  d.projectname = a.key_id or d.projectname = a.prj_number or d.projectname = a.opportunity_name 
where 1=1) a on opp.prj_number = a.prj_number
where opp.prj_status <> '无效'

select ifnull(sum(htcnt1),0)htcnt1,ifnull(sum(htcnt2),0)htcnt2,ifnull(sum(htcnt3),0)htcnt3,ifnull(sum(rtcnt1),0)rtcnt1, ifnull(sum(rtcnt2),0)rtcnt2,ifnull(sum(rtcnt3),0)rtcnt3,ifnull(sum(rtcnt4),0)rtcnt4,
ifnull(sum(sjcnt1),0)sjcnt1,ifnull(sum(sjcnt2),0)sjcnt2,ifnull(sum(jgcnt),0)jgcnt from (
select case when a.contract_id is null or LENGTH(contract_id) =0 then 1 else 0 end as htcnt1,case when a.contract_id is null or LENGTH(contract_id) =0  then a.prj_rentian else 0 end as htcnt2,case when a.contract_id is null or LENGTH(contract_id) =0  then h.days else 0 end as htcnt3
,case when days >prj_rentian then 1 else 0 end as rtcnt1,case when days >prj_rentian then a.prj_rentian else 0 end as rtcnt2,case when days >prj_rentian then days else 0 end as rtcnt3,case when days >prj_rentian then days-prj_rentian else 0 end as rtcnt4
,case when  DATEDIFF(CURDATE(),a.prj_enddate)>0 then 1 else 0 end as sjcnt1,case when if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('立项阶段','实施阶段','项目暂停','申请立项','申请结项') and DATEDIFF(CURDATE(),a.prj_enddate)>0 then DATEDIFF(CURDATE(),a.prj_enddate) else 0 end as sjcnt2
,case when o.sup_type='不监管' then 1 else 0 end as jgcnt
from (select * from project_opportunity1  where if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('立项阶段','实施阶段','项目暂停','申请立项','申请结项') )a
/*已用人天数*/
left join(select sum(days) days,project from v_rentian_forview group by project)h on h.project=a.key_id
left join prj_supervise_manage o on o.sup_keyid = a.key_id )a

select ifnull(sum(htcnt1),0)htcnt1,ifnull(sum(htcnt2),0)htcnt2,ifnull(sum(htcnt3),0)htcnt3,ifnull(sum(rtcnt1),0)rtcnt1, ifnull(sum(rtcnt2),0)rtcnt2,ifnull(sum(rtcnt3),0)rtcnt3,ifnull(sum(rtcnt4),0)rtcnt4,
ifnull(sum(sjcnt1),0)sjcnt1,ifnull(sum(sjcnt2),0)sjcnt2,ifnull(sum(jgcnt),0)jgcnt from (
select case when a.contract_id is null or LENGTH(contract_id) =0  then 1 else 0 end as htcnt1,case when a.contract_id is null or LENGTH(contract_id) =0  then a.prj_rentian else 0 end as htcnt2,case when a.contract_id is null or LENGTH(contract_id) =0  then h.days else 0 end as htcnt3
,case when days >prj_rentian then 1 else 0 end as rtcnt1,case when days >prj_rentian then a.prj_rentian else 0 end as rtcnt2,case when days >prj_rentian then days else 0 end as rtcnt3,case when days >prj_rentian then days-prj_rentian else 0 end as rtcnt4
,case when  DATEDIFF(CURDATE(),a.prj_enddate)>0 then 1 else 0 end as sjcnt1,case when if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('立项阶段','实施阶段','项目暂停','申请立项','申请结项') and  DATEDIFF(CURDATE(),a.prj_enddate)>0 then DATEDIFF(CURDATE(),a.prj_enddate) else 0 end as sjcnt2
,case when o.sup_type='不监管' then 1 else 0 end as jgcnt
from (select * from project_opportunity1  where if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('立项阶段','实施阶段','项目暂停','申请立项','申请结项') )a
/*已用人天数*/
left join(select sum(days) days,project from v_rentian_forview group by project)h on h.project=a.key_id
left join prj_supervise_manage o on o.sup_keyid = a.key_id
left join hr_department_team g on g.team_id=a.prj_team
where 1=1
${if(find('销售',fr_userposition)<>0," and prj_salesman = '"+fr_username+"'",if(find('售前',fr_userposition)<>0," and  prj_presales= '"+fr_username+"'","and ( projectmanager='"+fr_username+"' or  team_manager ='"+fr_username+"') "))}
 )a

SELECT * FROM prj_navigation where prj_kind ='团队运营' order by prj_order

