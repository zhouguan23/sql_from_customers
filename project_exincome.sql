 select date_month,round(sum(ifnull(pay_paid,0))/10000,2) pay_paid,
round(sum(ifnull(outs_paid,0))/10000,2) outs_paid,0 snum,
round(sum(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull( f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull( f_amount,1)-ifnull(sumpay_bill,0)))/10000,2) paid,
round(sum((ifnull(pay_paid,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_paid,0)))/10000,2) caiwupaid 
from (select date_month  from dict_date where 1=1 
 ${if(len(month)=0,""," and date_month in ('"+month+"')")}  ) a
left join (select key_id,prj_number,opportunity_name,project_area,prj_status,prj_team,customer_id,prj_salesman,projectmanager,prj_salesman_name,projectmanager_name  from project_opportunity1 
where if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('实施阶段','运维阶段','项目暂停','项目关闭','申请立项','申请暂停','申请重启','申请结项')   )opp on 1=1
left join project_contract_link on ctrlink_key=key_id
left join sale_contract_info on ctr_id=ctrlink_contract
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
left join (select pay_contract sum_contract,sum(IFNULL(pay_bill,0)*ifnull(f_amount,1))sumpay_bill from sale_payment
left join sale_contract_info on pay_contract = ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
 where pay_status in('记坏账','已作废')group by pay_contract)sumpay on sum_contract=ctr_id
left join (select sum(IFNULL(det_amount,0)) prj_amount,det_contract from v_contract_detail where det_type="实施" group by det_contract)prj on prj.det_contract=ctr_id
left join (
select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract,month(pay_enddate) monpay from sale_payment
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
WHERE 1=1
${if(len(year)=0,""," and year(pay_enddate)='"+year+"'")}
group by pay_contract,monpay)paid on pay_contract=ctr_id and monpay=date_month
/**************外包*****************/
#实施外包
left join 
(select ctr_id outs_contract,sum(d_outstype_amount) outs_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join sale_contract_info on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id)outs on outs_contract=ctr_id
/************外包付款*****************/
left join (
select sum(outs_paid) outs_paid,outs_contract outspay_contract, monouts  from 
(select sum(IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount) outs_paid,outs_contract,month(outspay_paydate) monouts  
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
where outs_status!="已作废" and d_outs_type="实施"
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
where 1=1
${if(len(year)=0,""," and year(outspay_paydate)='"+year+"'")}
group by outs_contract,monouts)main group by outs_contract,monouts)outs_paid
on outspay_contract=ctr_id and monouts= date_month
/******************************************/
${if(len(leixing)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=24 and tags_project is not null) m on opp.key_id = m.tags_project ")}
${if(len(waibao)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=37 and tags_project is not null) n on opp.key_id = n.tags_project ")}
${if(len(dengji)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=32 and tags_project is not null) o on opp.key_id = o.tags_project ")}
where 1=1
${if(len(team)=0,""," and prj_team in('"+team+"') ")} 
${if(len(region)=0,""," and opp.project_area in ('"+region+"') ")}
${if(len(leixing)=0,""," and m.tags_names in ('"+leixing+"') ")}
${if(len(waibao)=0,""," and n.tags_names in ('"+waibao+"') ")}
${if(len(dengji)=0,""," and o.tags_names in ('"+dengji+"') ")}
group by  date_month
union ALL
select month date_month,0 pay_paid,0 outs_paid,round(sum(ifnull(amount,0))/10000,2) snum,0 paid,0 caiwupaid from prj_payment_allocated a
left join project_opportunity1 opp on a.keyid =opp.key_id
${if(len(leixing)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=24 and tags_project is not null) m on opp.key_id = m.tags_project ")}
${if(len(waibao)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=37 and tags_project is not null) n on opp.key_id = n.tags_project ")}
${if(len(dengji)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=32 and tags_project is not null) o on opp.key_id = o.tags_project ")}
where 1=1
${if(len(year)=0,""," and year='"+year+"'")} 
${if(len(month)=0,""," and month in ('"+month+"')")}
${if(len(team)=0,""," and teamid in('"+team+"') ")}
${if(len(region)=0,""," and opp.project_area in ('"+region+"') ")}
${if(len(leixing)=0,""," and m.tags_names in ('"+leixing+"') ")}
${if(len(waibao)=0,""," and n.tags_names in ('"+waibao+"') ")}
${if(len(dengji)=0,""," and o.tags_names in ('"+dengji+"') ")}
group by  date_month 


select * from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by team_paixu

select * from prj_tag
where tag_type=24 and tag_verified=1
order by tag_order

select * from prj_tag
where tag_type=37 and tag_verified=1
order by tag_order

select * from prj_tag
where tag_type=32 and tag_verified=1
order by tag_order

select date_year from dict_date where date_year >='2017' order by date_year desc 

#sumteam
 select if(team_kind='2' and team_id not in ('2','30'),"成本中心",team_name) team_name,round(sum(ifnull(pay_paid,0))/10000,2) pay_paid,
 round(sum(ifnull(outs_paid,0))/10000,2)outs_paid,0 snum,
round(sum(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull( f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull( f_amount,1)-ifnull(sumpay_bill,0)))/10000,2) paid,
round(sum((ifnull(pay_paid,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_paid,0)))/10000,2) caiwupaid,if(team_kind='2' and team_id not in ('2','30'),0,team_paixu) team_paixu 
from (select key_id,prj_number,opportunity_name,project_area,prj_status,prj_team,customer_id,prj_salesman,projectmanager,prj_salesman_name,projectmanager_name  from project_opportunity1 where 
if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('实施阶段','运维阶段','项目暂停','项目关闭','申请立项','申请暂停','申请重启','申请结项') )opp  
left join (select team_id,team_name,team_kind,team_paixu from hr_department_team where team_department='18' union all select 0,'成本中心','2','0' ) te on opp.prj_team = te.team_id 
left join project_contract_link on ctrlink_key=key_id
left join sale_contract_info on ctr_id=ctrlink_contract
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
left join (select pay_contract sum_contract,sum(IFNULL(pay_bill,0)*ifnull(f_amount,1))sumpay_bill from sale_payment
left join sale_contract_info on pay_contract = ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
 where pay_status in('记坏账','已作废')group by pay_contract)sumpay on sum_contract=ctr_id
left join (select sum(IFNULL(det_amount,0)) prj_amount,det_contract from v_contract_detail where det_type="实施" group by det_contract)prj on prj.det_contract=ctr_id
left join (
select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract  from sale_payment
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
WHERE 1=1
${if(len(year)=0,""," and year(pay_enddate)='"+year+"'")}
${if(len(month)=0,""," and month(pay_enddate) in ('"+month+"') ")}
group by pay_contract )paid on pay_contract=ctr_id  
/**************外包*****************/
#实施外包
left join 
(select ctr_id outs_contract,sum(d_outstype_amount) outs_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join sale_contract_info on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id)outs on outs_contract=ctr_id
/************外包付款*****************/
left join (
select sum(outs_paid) outs_paid,outs_contract outspay_contract   from 
(select sum(IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount) outs_paid,outs_contract 
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
where outs_status!="已作废" and d_outs_type="实施"
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
where 1=1
${if(len(year)=0,""," and year(outspay_paydate)='"+year+"'")}
${if(len(month)=0,""," and month(outspay_paydate) in('"+month+"') ")}
group by outs_contract )main group by outs_contract )outs_paid
on outspay_contract=ctr_id  
/******************************************/
${if(len(leixing)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=24 and tags_project is not null) m on opp.key_id = m.tags_project ")}
${if(len(waibao)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=37 and tags_project is not null) n on opp.key_id = n.tags_project ")}
${if(len(dengji)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=32 and tags_project is not null) o on opp.key_id = o.tags_project ")}
where 1=1
${if(len(team)=0,""," and prj_team in('"+team+"') ")} 
${if(len(region)=0,""," and opp.project_area in ('"+region+"') ")}
${if(len(leixing)=0,""," and m.tags_names in ('"+leixing+"') ")}
${if(len(waibao)=0,""," and n.tags_names in ('"+waibao+"') ")}
${if(len(dengji)=0,""," and o.tags_names in ('"+dengji+"') ")}
group by  team_name,team_paixu 
union all
 select if(team_kind='2' and team_id not in ('2','30'),"成本中心",team_name) team_name,0 pay_paid,0 outs_paid,round(sum(ifnull(amount,0))/10000,2) snum,
0 paid,0 caiwupaid,if(team_kind='2' and team_id not in ('2','30'),0,team_paixu) team_paixu   from prj_payment_allocated a
left join project_opportunity1 opp on a.keyid =opp.key_id
left join (select team_id,team_name,team_kind,team_paixu from hr_department_team where team_department='18' union all select 0,'成本中心','2','0' ) te  on a.teamid = te.team_id 
${if(len(leixing)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=24 and tags_project is not null) m on opp.key_id = m.tags_project ")}
${if(len(waibao)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=37 and tags_project is not null) n on opp.key_id = n.tags_project ")}
${if(len(dengji)=0,""," left join (select tags_names,tags_project from prj_project_tags where tags_type=32 and tags_project is not null) o on opp.key_id = o.tags_project ")}
where 1=1
${if(len(year)=0,""," and year='"+year+"'")} 
${if(len(month)=0,""," and month in ('"+month+"')")}
${if(len(team)=0,""," and teamid in('"+team+"') ")}
${if(len(region)=0,""," and opp.project_area in ('"+region+"') ")}
${if(len(leixing)=0,""," and m.tags_names in ('"+leixing+"') ")}
${if(len(waibao)=0,""," and n.tags_names in ('"+waibao+"') ")}
${if(len(dengji)=0,""," and o.tags_names in ('"+dengji+"') ")}
group by  team_name,team_paixu 
order by team_paixu
 


select a.cyear,sum(ifnull(a.cxishu,0)) cxishu,
b.team_name,team_kind
 from (select * from prj_chaorentian where cyear='${year}' ) a
left join (
select team_id,team_name,team_paixu,team_kind from hr_department_team where team_department ='18'
union 
select 0,'成本中心',99,2
) b on a.cteam =b.team_id
left join hr_user c on a.cuser = c.user_username 
/*left join (select h_username,h_job_level from hr_user_department_history where h_year="${year}" and h_job_level is not null group by h_username) his on c.user_username = his.h_username*/
left join (select sum(chaorentian) chaoren,cuser from prj_chaorentian where cyear='${year}' group by cuser) d on a.cuser = d.cuser
where 1=1
${if(len(team)=0,"","and cteam in ('"+team+"')")}
group by cteam,cyear
ORDER BY
team_kind,
	team_paixu,
	cteam,
	bilipaiming1

