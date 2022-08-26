select opp.*,com_name,ctr_id,ctr_project,ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0) ctr_amount,ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0) prj_amount,pay_paid,outs_amount,expense,snum,T.prj_user team_manager,m.tag_name,maxdate,ifnull(outs_paid,0) outs_paid,if(prj_status="项目关闭",3,if(prj_status="运维阶段",2,1))paixu,num,wnum,
(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0)) ss,
if(tags_names =120 or tags_names =121,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)))) shishipaid,

sum2,ifnull(p.dayamount,0) chengben,
pay_paid*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)) sspayback ,/*实施回款*/
ifnull(
pay_paid*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)) - ifnull(outs_paid,0) - ifnull(p.dayamount,0)-ifnull(pro_day_outspay,0),0)  jinkamount,
/*-k*实施回款-内部成本-二开-实施外包*/

if(tags_names <>120 and tags_names <>121 ,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)))) jianguanpaid,
(ifnull(ifnull(pay_paid,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0),0)-ifnull(outs_paid,0)) caiwupaid 
 from (select key_id,prj_number,opportunity_name,prj_status,prj_team,customer_id,prj_salesman,projectmanager,prj_salesman_name,projectmanager_name  from project_opportunity1 where 
if(prj_apply_status=''||prj_apply_status is null,prj_status,prj_apply_status) in ('实施阶段','运维阶段','项目暂停','项目关闭','申请立项','申请暂停','申请重启','申请结项') )opp

/*内部成本*/
left join (select a.project,sum(ifnull(a.days,0)*ifnull(m.price_amount,mm.price_amount)) dayamount
from 
(select sum(if(`day` between c_startdate and c_enddate,0.5*c_value,0.5)) days,a.key_id as project,a.prj_province,year(day) yy,QUARTER(day) qq ,(QUARTER(c.day)-1) dd
from project_opportunity1 a 
join prj_qiandao_time c on (a.key_id = c.project or a.prj_number=c.project) and user_type='1' and status ='0' and (out_type = 0 or out_type = 16 ) 
${if(tag=0,"","and year(day)=year(curdate())")} 
left join project_out_coefficient on c_username=c.`user`
group by a.key_id,year(day),QUARTER(day)
 )a
left join project_region_unitprice m on m.price_year =a.yy 
and m.price_jidu =a.qq and m.price_province=a.prj_province
left join project_region_unitprice mm on mm.price_year =a.yy 
and mm.price_jidu =a.dd and mm.price_province=a.prj_province
group by project)p on p.project=opp.key_id



left join project_contract_link on ctrlink_key=key_id
left join project_members T on T.prj_team=opp.prj_team and prj_is_leader=1
left join (select * from prj_project_tags where tags_type=37)t on t.tags_project=key_id
left join (select tag_id,tag_name from prj_tag  where tag_type=37) m on t.tags_names= m.tag_id
left join cust_company on com_id=customer_id
left join v_sale_contract_info_valid on ctr_id=ctrlink_contract
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
left join (select pay_contract sum_contract,sum(IFNULL(pay_bill,0)*ifnull(f_amount,1))sumpay_bill from sale_payment
left join sale_contract_info on pay_contract = ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
 where pay_status in('记坏账','已作废')group by pay_contract)sumpay on sum_contract=ctr_id
left join (select sum(IFNULL(det_amount,0)) prj_amount,det_contract from v_contract_detail where det_type="实施" group by det_contract)prj on prj.det_contract=ctr_id
left join (
select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract from sale_payment
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
WHERE 1=1
${if(len(year)=0,""," and year(pay_enddate)='"+year+"'")}
${if(len(year_c)=0,""," and year(pay_enddate)='"+year_c+"'")}
group by pay_contract)paid on pay_contract=ctr_id
/**************外包*****************/
#实施外包
left join 
(select ctr_id outs_contract,sum(d_outstype_amount) outs_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id)outs on outs_contract=ctrlink_contract
/************外包付款*****************/
left join (
select sum(outs_paid) outs_paid,outs_contract outspay_contract  from 
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
${if(len(year_c)=0,""," and year(outspay_paydate)='"+year_c+"'")}
group by outs_contract)main group by outs_contract)outs_paid
on outspay_contract=ctrlink_contract
/******************************************/

/*********二开*********/
left join (select pro_project,sum(ifnull(pro_day_outspay,0)) pro_day_outspay  from project_sln_info  left join fr_t_system1 on pro_key=jira_keys  where pro_project<>'' 
/*${if(tag=0,"","and year(accept_time)=year(curdate())")}*/
${if(len(year)=0,""," and year(accept_time)='"+year+"'")}
${if(len(year_c)=0,""," and year(accept_time)='"+year_c+"'")}
group by pro_project
) sln  on pro_project=opp.key_id 
/*二开成本取值*/


LEFT JOIN (SELECT SUM(IFNULL(AMOUNT_RECOUP,0))EXPENSE,PROJECT_ID FROM FINAN_RECOUP GROUP BY PROJECT_ID)EXPENSE ON PROJECT_ID=KEY_ID


left join (select SUM(F_NUMBER) snum,CTR_ID sctr ,
sum(if(c_name='crm',f_number,0)) sum2

from project_payment
LEFT JOIN SALE_PAYMENT ON PAY_ID=PAYID
LEFT JOIN SALE_CONTRACT_INFO ON CTR_ID=PAY_CONTRACT
where xishu is not null
${if(len(year)=0,""," and year(pay_enddate)='"+year+"'")}
${if(len(year_c)=0,""," and year(pay_enddate)='"+year_c+"'")}
GROUP by ctr_id)split on ctrlink_contract=sctr



left join (select SUM(ifnull(pay_paid,0)*ifnull(f_amount,1)) wnum,CTR_ID wctr from SALE_PAYMENT
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
LEFT JOIN SALE_CONTRACT_INFO ON CTR_ID=PAY_CONTRACT
where pay_id not in (select payid from project_payment)
${if(len(year)=0,""," and year(pay_enddate)='"+year+"'")}
${if(len(year_c)=0,""," and year(pay_enddate)='"+year_c+"'")}
GROUP by ctr_id)split2 on ctr_id=wctr
left join (select max(ifnull(pay_enddate,"2016-01-01"))maxdate,pay_contract payctr from sale_payment group by pay_contract)paydate on payctr=ctr_id
LEFT JOIN (SELECT COUNT(*) NUM,CTRLINK_CONTRACT NUM_CONTRACT FROM project_contract_link 
left join project_opportunity1 on CTRLINK_key=key_id 
where prj_status<>"无效"
GROUP BY CTRLINK_CONTRACT)CTRLINK ON NUM_CONTRACT=ctrlink_contract
where 1=1
${if(tag="true"," and ifnull(num,0)>=2","")}
${if(len(number)=0,""," and opp.prj_number regexp '"+number+"'")}
${if(len(opp)=0,""," and com_name regexp '"+opp+"'")}
${if(len(salesman)=0,""," and prj_salesman in  ('"+treelayer(salesman,true,"\',\'")+"')")}
${if(len(team)=0,""," and opp.prj_team in ('"+team+"')")}
${if(len(manager)=0,""," and projectmanager in ('"+treelayer(manager,true,"\',\'")+"')")}
${if(flag="true","  and (((abs(if(tags_names =120 or tags_names =121,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0))))-ifnull(snum,0))>5 
) and if(tags_names =120 or tags_names =121,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)))) <>0) or ((abs(if(tags_names <>120 and tags_names <>121,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0))))-ifnull(snum,0))>5 
) and if(tags_names <>120 and tags_names <>121,0,(ifnull(pay_paid,0)*(ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)))) <>0))  ","")}
${if(find("Maggie",fr_username)>0||find("tiny",fr_username)>0||find("jeremy",fr_username)>0||find("victor",fr_username)>0||find("Lance",fr_username)>0||find("marks",fr_username)>0||find("Coral",fr_username)>0||find("crm",fr_username)>0||find("May.Ren",fr_username)>0,""," and (T.prj_user regexp '"+fr_username+"' or projectmanager='"+fr_username+"')")}
order by maxdate desc,paixu

select user_username,concat(user_username,"(",user_name,")") name,sales_region from hr_salesman
left join hr_user on user_username=sales_name
where sales_region is not null
order by sales_region,user_name


select * from hr_department_team
where team_department=18 /*and team_project=1*/ and team_verified="valid"
order by team_paixu

select * from dict_date where date_year>=2017 and  date_year <=2020 order by date_year desc

select prj_user,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_project=1 and team_verified="valid" and prj_verified="valid"
union select team_name as prj_user,null as team_name,team_name as name,team_paixu from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by team_paixu,prj_user

select team_name AS name_id,team_name as coop_name,"项目组人员" as type_name,team_paixu from hr_department_team where team_department=18 and team_project=1 and team_verified="valid"

select  prj_user name_id,concat(prj_user,"(",prj_name,")") coop_name,team_name type_name,0 as team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_project=1 and team_verified="valid" and prj_verified="valid"

