select * from (select key_id,prj_number,ctr_id,ctr_project,opportunity_name,com_name,(ctr_amount-ifnull(sum_bill,0))*ifnull(f_amount,1) ctr_amount,(prj_amount-ifnull(sum_bill,0)/ctr_amount*prj_amount)*ifnull(f_amount,1) prj_amount,com_id,com_salesman,ctr_signdate,projectmanager,team_name,if(com_salesman='aaron'&&com_country='中国','上海',tags_name)region from 
project_opportunity1
left join hr_department_team on team_id=prj_team
left join cust_company on com_id=customer_id
join project_contract_link on ctrlink_key=key_id
join sale_contract_info on ctrlink_contract=ctr_id
left join finan_other_statistics on f_type=ifnull(ctr_currency,"CNY") and f_remark="CNY"
left join hr_user_tags on tag_username=com_salesman
left join hr_tags on tags_id=tag_region_id
left join (select sum(pay_bill)sum_bill,pay_contract from sale_payment where pay_status in ('已作废','记坏账') group by pay_contract)sum on pay_contract=ctr_id
left join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where 1=1
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and team_id in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(ctrname)=0,"","and ctr_id in ('"+ctrname+"')")}
${if(len(region)=0,"","and if(com_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and com_salesman in ('"+salesman+"')")}
${if(len(oppname)=0,"","and key_id in ('"+oppname+"')")}
${if(len(prjnum)=0,"","and prj_number in ('"+prjnum+"')")}
${if(zb="true","and projectmanager in (select user_username from hr_user where user_username not in (
SELECT prj_user FROM project_members
left join hr_department_team on team_id=prj_team
where prj_verified='valid' and team_region not in ('总部')) and user_type='正式')","")}
)main
/********所有回款*******/
${if(len(pre_startdate)=0&&len(pre_enddate)=0&&len(pay_startdate)=0&&len(pay_enddate)=0,"left join","join")}
(select pay_contract,sum(pay_bill)pay_bill,sum(prj_bill)prj_bill,sum(ifnull(prj_paid,0))prj_paid,predate_ym,tag,enddate_ym,pay_id,group_concat(distinct al_apply)al_apply,group_concat(distinct a_status)a_status,group_concat(distinct ahis_recorder)ahis_recorder from (
select pay_id,pay_contract,pay_bill*ifnull(b.f_amount,1) pay_bill,pay_bill/ctr_amount*prj_amount*ifnull(b.f_amount,1) prj_bill,pay_paid/ctr_amount*prj_amount*ifnull(a.f_amount,1) prj_paid,left(pay_enddate,7) enddate_ym,left(pay_predate,7) predate_ym,al_apply,a_status,ahis_recorder,
case when ifnull(pay_paid,0)=0 and pay_predate>=curdate() then "未到时间点未回款"
when ifnull(pay_paid,0)=0 and pay_predate<curdate() then "逾期未回款"
when pay_predate<pay_enddate then "逾期已回款"
when pay_predate>pay_enddate then "提前回款"
else "正常回款" end tag
from sale_payment
left join payment_apply_link on al_payid=pay_id
left join payment_apply_info on a_id=al_apply
left join payment_apply_history on ahis_applyid=a_id and ahis_type="申请作废"
left join finan_other_statistics a on a.f_type=ifnull(pay_currency,"CNY") and a.f_remark="CNY"
left join sale_contract_info  on ctr_id=pay_contract
left join finan_other_statistics b on b.f_type=ifnull(ctr_currency,"CNY") and b.f_remark="CNY"
left join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where pay_status not in ("已作废","记坏账") and pay_verified="valid"
${if(len(pre_startdate)=0,"","and pay_predate>='"+pre_startdate+"'")}
${if(len(pre_enddate)=0,"","and pay_predate<='"+pre_enddate+"'")}
${if(len(pay_startdate)=0,"","and pay_enddate>='"+pay_startdate+"'")}
${if(len(pay_enddate)=0,"","and pay_enddate<='"+pay_enddate+"'")}
)list
group by enddate_ym,predate_ym,pay_contract,tag)a on pay_contract=ctr_id
/*********实际回款年月***********/
/*${if(len(pay_startdate)=0&&len(pay_enddate)=0,"left join","join")}
(select left(pay_enddate,7) enddate_ym,ctrlink_key
from sale_payment
join sale_contract_info  on ctr_id=pay_contract
join project_contract_link on ctrlink_contract=ctr_id
where pay_status not in ("已作废","记坏账") and pay_verified="valid" and pay_enddate is not null
${if(len(pay_startdate)=0,"","and pay_enddate>='"+pay_startdate+"'")}
${if(len(pay_enddate)=0,"","and pay_enddate<='"+pay_enddate+"'")}
group by ctrlink_key)b on ctrlink_key=key_id*/
where 1=1
${if(len(tag)=0,"","and tag in ('"+tag+"')")}
${if(check="true","and enddate_ym is null","")}
order by ifnull(enddate_ym,9999-99),predate_ym


SELECT user_username,concat(user_username,"-",user_name)name FROM project_opportunity1
left join hr_user on user_username=projectmanager
left join hr_department_team on team_id=prj_team
where 1=1
${if(len(region)=0,"","and team_base in ('"+region+"')")}

select * from hr_tags where tags_type="区域" and tags_name not in ("待分配","无","总部")

select user_username,concat(user_username,"-",user_name)name from hr_salesman
left join hr_user on user_username=sales_name
where 1=1
${if(len(region)=0,"","and sales_region in ('"+region+"')")}

select * from hr_department_team
where team_department=18 and team_verified="valid" and team_region not in ("总部")
order by team_paixu

select "正常回款" as type
union
select "逾期已回款"
union
select "提前回款"
union
select "未到时间点未回款"
union
select "逾期未回款"

select * from (select key_id,prj_number,ctr_id,ctr_project,opportunity_name,com_name,(ctr_amount-ifnull(sum_bill,0))*ifnull(f_amount,1) ctr_amount,(prj_amount-ifnull(sum_bill,0)/ctr_amount*prj_amount)*ifnull(f_amount,1) prj_amount,com_id,com_salesman,ctr_signdate,projectmanager,team_name,if(com_salesman='aaron'&&com_country='中国','上海',tags_name)region from 
project_opportunity1
left join hr_department_team on team_id=prj_team
left join cust_company on com_id=customer_id
join project_contract_link on ctrlink_key=key_id
join sale_contract_info on ctrlink_contract=ctr_id
left join finan_other_statistics on f_type=ifnull(ctr_currency,"CNY") and f_remark="CNY"
left join hr_user_tags on tag_username=com_salesman
left join hr_tags on tags_id=tag_region_id
left join (select sum(pay_bill)sum_bill,pay_contract from sale_payment where pay_status in ('已作废','记坏账') group by pay_contract)sum on pay_contract=ctr_id
left join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where 1=1
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and team_id in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(ctrname)=0,"","and ctr_id in ('"+ctrname+"')'")}
${if(len(region)=0,"","and if(com_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and com_salesman in ('"+salesman+"')")}
${if(len(oppname)=0,"","and key_id in ('"+key_id+"')")}
${if(len(prjnum)=0,"","and prj_number in ('"+prjnum+"')")})main
/********所有回款*******/
${if(len(pre_startdate)=0&&len(pre_enddate)=0&&len(pay_startdate)=0&&len(pay_enddate)=0,"left join","join")}
(select pay_contract,sum(pay_bill)pay_bill,sum(prj_bill)prj_bill,sum(ifnull(prj_paid,0))prj_paid,predate_ym,tag,enddate_ym from (
select pay_id,pay_contract,pay_bill,pay_bill/ctr_amount*prj_amount*ifnull(f_amount,1) prj_bill,pay_paid/ctr_amount*prj_amount*ifnull(f_amount,1) prj_paid,left(pay_enddate,7) enddate_ym,left(pay_predate,7) predate_ym,
case when ifnull(pay_paid,0)=0 and pay_predate>=curdate() then "未到时间点未回款"
when ifnull(pay_paid,0)=0 and pay_predate<curdate() then "逾期未回款"
when pay_predate<pay_enddate then "逾期已回款"
when pay_predate>pay_enddate then "提前回款"
else "正常回款" end tag
from sale_payment
left join finan_other_statistics on f_type=ifnull(pay_currency,"CNY") and f_remark="CNY"
left join sale_contract_info  on ctr_id=pay_contract
left join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where pay_status not in ("已作废","记坏账") and pay_verified="valid"
${if(len(pre_startdate)=0,"","and pay_predate>='"+pre_startdate+"'")}
${if(len(pre_enddate)=0,"","and pay_predate<='"+pre_enddate+"'")}
${if(len(pay_startdate)=0,"","and pay_enddate>='"+pay_startdate+"'")}
${if(len(pay_enddate)=0,"","and pay_enddate<='"+pay_enddate+"'")}
)list
group by enddate_ym,predate_ym,pay_contract,tag)a on pay_contract=ctr_id
/*********实际回款年月***********/
/*${if(len(pay_startdate)=0&&len(pay_enddate)=0,"left join","join")}
(select left(pay_enddate,7) enddate_ym,ctrlink_key
from sale_payment
join sale_contract_info  on ctr_id=pay_contract
join project_contract_link on ctrlink_contract=ctr_id
where pay_status not in ("已作废","记坏账") and pay_verified="valid" and pay_enddate is not null
${if(len(pay_startdate)=0,"","and pay_enddate>='"+pay_startdate+"'")}
${if(len(pay_enddate)=0,"","and pay_enddate<='"+pay_enddate+"'")}
group by ctrlink_key)b on ctrlink_key=key_id*/
where 1=1
${if(len(tag)=0,"","and tag in ('"+tag+"')")}
${if(check="true","and enddate_ym is null","")}
group by ${js}

select ctr_id,ctr_project,key_id,opportunity_name,prj_number from project_opportunity1
left join project_contract_link on ctrlink_key=key_id
left join sale_contract_info on ctrlink_contract=ctr_id
left join cust_company on com_id=customer_id
where 1=1
${if(len(com)=0,"","and com_name like '%"+com+"%'")}

