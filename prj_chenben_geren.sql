select b.key_id,b.prj_number,b.opportunity_name,
ifnull(g.chuchaidays,0)chuchaidays,ifnull(h.zaitudays,0)zaitudays,i.ctrlink_contract,j.ctr_project,j.ctr_signdate,round(ifnull(ctr_amount,0)*ifnull(f_amount,1) -ifnull(sumpay_bill,0) ,2) ctramount,concat(prj_user,'(',prj_name,')') username,
round(ifnull(pay_paid,0)*(ifnull(prj_amount,0)-ifnull(sumpay_bill,0)*ifnull(f_amount,1)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1) -ifnull(sumpay_bill,0)),0) paid,round(ifnull(f_number,0),0) f_number,round(ifnull(prj_adjust,0) ,2) prj_adjust,prj_finanprice chenbensj,
round(ifnull(pur_amount,0),2) pur_amount,/*ifnull(jsamount,0) jsamount,*/round(ifnull(outs_paid,0),2)outs_paid,round(ifnull(outs_amount,0),2)outs_amount,ifnull(chailv,0)chailv,ifnull(sln_amount,0)sln_amount,ifnull(prjx_amount_jx,0)prjx_amount_jx,round(ifnull(canbu,0),2)canbu,round(ifnull(dache,0),2) dache,round(ifnull(fangzu,0),2)fangzu,round(ifnull(recoup_amount,0),2) recoup_amount,round(ifnull(amount_recoup_zong,0),2)-round(ifnull(canbu,0),2)-round(ifnull(dache,0),2)-round(ifnull(fangzu,0),2)-round(ifnull(recoup_amount,0),2) qitaamount,ifnull(prj_adjust1,0) prj_adjust1,ifnull(prj,0)prj,
round(ifnull(amount_recoup_zong,0),2)+round(ifnull(prjx_amount_jx,0),2) zongamount
 from (
select distinct user,project  from prj_qiandao_time where user_type='1' and project ='${keyid}'  
union select role_user,role_project from prj_project_role where role_type ='1' and role_project ='${keyid}') a
left join project_opportunity1 b on a.project =b.key_id
left join project_members bb on a.user = bb.prj_user 
left join (select project,user,count(day)*0.5 chuchaidays from prj_qiandao_time where project_type ='项目实施' and project ='${keyid}' 
and (year(day) = '${year}' and quarter(day)<='${jidu}') or year(day)<'${year}'
  group by project,user) g on g.project = a.project and g.user = a.user
left join (select a.user,b.project,count(day)*0.5 zaitudays from  
hr_time a join hr_time_reason b on a.reason_id = b.reason_id 
 where project ='${keyid}' and out_type ='13'
and ((year(day) = '${year}' and quarter(day)<='${jidu}') or year(day)<'${year}')
group by b.project,a.user) h on h.project = a.project and h.user = a.user
left join project_contract_link i on i.ctrlink_key = a.project 
left join sale_contract_info j on j.ctr_id = i.ctrlink_contract and ctr_status <>'已作废'
left join sale_contract_of_project kk on kk.prj_contract =j.ctr_id 
left join finan_other_statistics k on k.f_remark='CNY' and k.f_type=j.ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment
 where pay_status in('记坏账','已作废')group by pay_contract)l on l.pay_contract=j.ctr_id
/**************外包*****************/
left join 
(select ctr_id outs_contract,sum(d_outstype_amount) outs_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id)outs on outs_contract=ctr_id
#外包付款
left join (select sum(outs_paid) outs_paid,outs_contract outspay_contract  from 
(select sum(IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount) outs_paid,outs_contract 
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from (select * from  v_outsource_detail where d_outs_type = "实施") a
left join (select * from sale_outsource where outs_status!="已作废") b on d_outs_id=outs_id
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
where 1=1
and ((year(outspay_paydate) ='${year}' and QUARTER(outspay_paydate) <='${jidu}' ) or year(outspay_paydate) <'${year}')
group by outs_contract)main group by outs_contract) outs_paid on j.ctr_id = outs_paid.outspay_contract 
left join (
select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract from sale_payment
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
where (year(pay_enddate) ='${year}' and QUARTER(pay_enddate) ='${jidu}') or year(pay_enddate) <'${year}'
group by pay_contract) m ON m.pay_contract=j.ctr_id 
left join ( select sum(f_number)f_number,keyid,b.pay_contract,name_id from project_payment a left join sale_payment b on a.payID = b.pay_id group by keyid,b.pay_contract,name_id )n on a.project = n.keyid and a.user= n.name_id and j.ctr_id = n.pay_contract
left join (select prj_id,prj_contract,sum(ifnull(prj_adjust,0))prj_adjust,sum(ifnull(prj_orgprice,0)) prj_orgprice,sum(ifnull(prj_finanprice,0))prj_finanprice from project_cost
where ((prj_year='${year}' and prj_season<'${jidu}') or prj_year< '${year}')
group by prj_id,prj_contract ) o on o.prj_id =a.project and o.prj_contract=j.ctr_id
left join (select prj_id,prj_contract,sum(ifnull(prj_adjust,0))prj_adjust1,sum(if(prj_year='${year}' and prj_season='${jidu}',ifnull(prj_adjust,0),0)) prj  from project_cost
where 1=1
group by prj_id,prj_contract ) ss on ss.prj_id =a.project and ss.prj_contract=j.ctr_id
left join sale_contract_of_purchasing dai on dai.pur_contract = j.ctr_id
-- left join (
-- select js_project,js_user,sum(ifnull(js_amount,0)-ifnull(js_fd,0)-ifnull(js_salary,0)) jsamount  from 
-- (select * from project_kpi_cost order by js_year desc,js_month desc)a
-- left join dict_date on js_month = date_month 
-- where (js_year ='${year}' and date_quarter<='${jidu}') or js_year<'${year}'  
--  group by js_project,js_user
-- )cost on a.project=js_project and a.user = cost.js_user 
left join (/*二次开发金额*/
SELECT sum(ifnull(pro_day_outspay,0))sln_amount,pro_project FROM `project_sln_info`
where (year(pro_recdate)='${year}' and QUARTER(pro_recdate) <='${jidu}' or year(pro_recdate)<'${year}')
group by pro_project
)sln on a.project=pro_project
left join (/*绩效*/
select sum(ifnull(prjx_amount_jx,0)) prjx_amount_jx,prjx_project,prjx_username from project_member_jx
left join dict_date on prjx_month = date_month 
where (prjx_year ='${year}' and date_quarter<='${jidu}') or prjx_year<'${year}'
group by prjx_project,prjx_username
)jx on a.project=prjx_project  and a.user = jx.prjx_username
LEFT JOIN (/*出差费用*/
select project_id,recorder,sum(if(finan.subject=128,amount_recoup,0)) dache,sum(if(finan.subject=226,amount_recoup,0)) canbu,sum(if(b.parent =302,amount_recoup,0))fangzu,sum(if(b.parent =347,amount_recoup,0))chailv, sum(if(b.parent =302 ||finan.subject=128 ||finan.subject=226||finan.subject=347  ,0,amount_recoup))recoup_amount from finan_recoup finan 
join finan_dict_subject b on finan.subject =b.id
join finan_dict_subject c on b.parent = c.id
where project_id is not null and (c.parent ='2' || b.parent ='2')
and ((year(happenday)='${year}' and QUARTER(happenday) <='${jidu}') or year(happenday)<'${year}')
and subject <>'141'
GROUP BY project_id,recorder 
)recoup on recoup.project_id=a.project and recoup.recorder = a.user 
left join (select project_id,recorder,sum(amount_recoup) amount_recoup_zong from  finan_recoup
where ((year(happenday)='${year}' and QUARTER(happenday) <='${jidu}') or year(happenday)<'${year}') 
and subject <>'141'
group by project_id,recorder
 ) re on re.project_id = a.project and  re.recorder = a.user 
where 1=1

select count(distinct user) cnt from (
select distinct user,project  from prj_qiandao_time where user_type='1' and project ='${keyid}'  
union select role_user,role_project from prj_project_role where role_type ='1' and role_project ='${keyid}')a

select count(ctrlink_contract) cnt2 from project_contract_link where ctrlink_key ='${keyid}'

