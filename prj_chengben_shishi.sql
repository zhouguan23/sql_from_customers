select 
a.key_id
,a.prj_number
,b.com_name
,a.opportunity_name
,DATE_FORMAT(c.REQ_INPUT_DATE,'%Y-%m-%d') REQ_INPUT_DATE
,str_to_date(a.prj_appovedate,'%Y-%m-%d')prj_appovedate
,ifnull(a.prj_apply_status,a.prj_status) prj_status
,history_time
,a.projectmanager
,d.team_name zerenteam
,a.prj_salesman
,d.team_region
,e.dengji
,f.waibaotype
,r.project_scale
,a.prj_rentian
,ifnull(g.chuchaidays,0)chuchaidays
,ifnull(h.zaitudays,0)zaitudays
,i.ctrlink_contract
,j.ctr_id
,j.ctr_project
,j.ctr_signdate
,round(ifnull(ctr_amount,0)*ifnull(f_amount,1) -ifnull(sumpay_bill,0) ,2) ctramount
,round(ifnull(pay_paid,0)*(ifnull(prj_amount,0)-ifnull(sumpay_bill,0)*ifnull(f_amount,1)*ifnull(prj_amount,0)/ifnull(ctr_amount,0)-ifnull(outs_amount,0))/(ifnull(ctr_amount,0)*ifnull(f_amount,1) -ifnull(sumpay_bill,0)),0) paid
,round(ifnull(prj_adjust1,0) ,2) prj_adjust1
,prj_finanprice as chenbensj
,round(ifnull(ifnull(purch_amount,pur_amount),0),2) pur_amount
,/*ifnull(jsamount,0) jsamount,*/round(ifnull(outs_paid,0),2)outs_paid
,round(ifnull(outs_amount,0),2)outs_amount
,ifnull(fh_amount,0)fh_amount
,ifnull(sln_amount,0)sln_amount
,ifnull(prjx_amount_jx,0)prjx_amount_jx
,round(ifnull(canbu,0),2)canbu
,round(ifnull(dache,0),2) dache
,round(ifnull(fangzu,0),2)fangzu
,round(ifnull(recoup_amount,0),2) recoup_amount
,round(ifnull(amount_recoup_zong,0),2)-round(ifnull(canbu,0),2)-round(ifnull(dache,0),2)-round(ifnull(fangzu,0),2)-round(ifnull(recoup_amount,0),2)-round(ifnull(fh_amount,0),2) qitaamount
,ifnull(prj_adjust,0) prj_adjust
,ifnull(prj,0)prj
,round(ifnull(amount_recoup_zong,0),2)+round(ifnull(prjx_amount_jx,0),2) zongamount
,round(ifnull(outs_amount,0),2)outsamount
,concat('<html>',projectmanager,'<br/>',substring_index(substring_index(a.projectmanager_name,'(',1),')',1)) manager
,concat('<html>',prj_salesman,'<br/>',substring_index(substring_index(a.prj_salesman_name,'(',1),')',1)) salesman
,zongchengben
from(select * from project_opportunity1
where 1=1
/*prj_status in ('实施阶段','运维阶段','项目关闭')*/
${if(len(num)=0,"","and prj_number in( '"+num+"')")}
${if(len(oppname)=0,"","and opportunity_name in( '"+oppname+"') ")}
${if(len(team)=0,"","and prj_team in  ('"+team+"')")}
${if(len(salesman)=0,"","and prj_salesman in ('"+salesman+"')")}
${if(len(xmstartdate)=0,"","and prj_appovedate >= '"+xmstartdate+"'")}
${if(len(xmenddate)=0,"","and prj_appovedate <= '"+xmenddate+"'")}
${if(len(status)=0,"","and ifnull(prj_apply_status,prj_status) in  ('"+status+"')")}
${if(len(manager)=0,"","and projectmanager in ('"+treelayer(manager,true,"\',\'")+"')")}
) a
left join cust_company b on a.customer_id = b.com_id 
left join project_f_requirement_info c on a.prj_number = c.REQ_ID 
left join (select DATE_FORMAT(max(history_time),'%Y-%m-%d') history_time,history_project from prj_project_history where history_status_change in ('运维阶段','项目关闭') group by history_project)history on history_project=a.key_id
left join hr_department_team d on a.prj_team = d.team_id 
left join (select tags_names dengjiid,tag_name dengji,B.tags_project from (select  tags_names ,tags_project from prj_project_tags where tags_type=32 and tags_project is not null)B
left join (select tag_id,tag_name from prj_tag  where tag_type='32') C on B.tags_names= C.tag_id group by  B.tags_project )e on e.tags_project=a.key_id /*项目等级*/
left join (select tags_names waibao,tag_name waibaotype,B.tags_project from (select  tags_names ,tags_project from prj_project_tags where tags_type=37 and tags_project is not null)B
left join (select tag_id,tag_name from prj_tag  where tag_type='37') C on B.tags_names= C.tag_id)f on f.tags_project=a.key_id /*外包类型*/
left join (select project,count(day)*0.5 chuchaidays from prj_qiandao_time where project_type ='项目实施'
and ((year(day)='${year}' and QUARTER(day) <='${jidu}') or year(day)<'${year}') 
 group by project) g on g.project = a.key_id  
left join (select b.project,count(day)*0.5 zaitudays from (
select * from hr_time where out_type ='13' 
and ((year(day)='${year}' and QUARTER(day) <='${jidu}') or year(day)<'${year}') 
) a
join (select * from hr_time_reason where project is not null) b on a.reason_id = b.reason_id 
group by b.project ) h on h.project = a.key_id  
left join project_contract_link i on i.ctrlink_key = a.key_id 
left join sale_contract_info j on j.ctr_id = i.ctrlink_contract and ctr_status <>'已作废'
left join (select sum(ifnull(prj_amount,0)) prj_amount,prj_contract from sale_contract_of_project group by prj_contract )kk on kk.prj_contract =j.ctr_id 
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
where (year(pay_enddate) ='${year}' and QUARTER(pay_enddate) <='${jidu}' ) or year(pay_enddate) <'${year}'
group by pay_contract) m ON m.pay_contract=j.ctr_id 
left join (select prj_id,prj_contract,sum(ifnull(prj_adjust,0))prj_adjust,max(ifnull(prj_finanprice,0)*ifnull(prj_finandays,1))prj_finanprice  from project_cost
where ((prj_year='${year}' and prj_season<'${jidu}') or prj_year< '${year}')
group by prj_id,prj_contract ) o on o.prj_id =a.key_id and o.prj_contract=j.ctr_id
left join (select prj_id,prj_contract,sum(ifnull(prj_adjust,0))prj_adjust1 ,sum(if(prj_year='${year}' and prj_season='${jidu}',ifnull(prj_adjust,0),0)) prj from project_cost
where 1=1
group by prj_id,prj_contract ) ss on ss.prj_id =a.key_id and ss.prj_contract=j.ctr_id
left join (
select round(sum((ifnull(ctr_amount,0)*ifnull(f_amount,1) -ifnull(sumpay_bill,0))/10000),2) ammount,a.ctrlink_key from project_contract_link a 
left join sale_contract_info b on a.ctrlink_contract = b.ctr_id and ctr_status <>'已作废'
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
left join (select pay_contract,sum(IFNULL(pay_bill,0))sumpay_bill from sale_payment
 where pay_status in('记坏账','已作废')group by pay_contract)c on c.pay_contract=b.ctr_id
group by a.ctrlink_key
) rr on rr.ctrlink_key = a.key_id 
left join project_scale r on rr.ammount > r.ctr_lower and rr.ammount <= ifnull(r.ctr_upper,1000000)
/*代采购-商务*/
left join (select sum(ifnull(pur_amount,0))pur_amount ,pur_contract from sale_contract_of_purchasing group by pur_contract) dai on dai.pur_contract = j.ctr_id
/*产品代采购合同，这个优先*/
left join(SELECT outs_contract as sale_purch_ctr,outs_amount-ifnull(bill,0) as purch_amount
FROM `sale_outsource`
left join (select sum(ifnull(outspay_amount,0))bill,outspay_outsource b_outsource from sale_outsource_payment where outspay_status="已作废" group by outspay_outsource)outs_bill on b_outsource=outs_id
where outs_type regexp '产品代采购'
group by outs_contract)sale_purch on sale_purch.sale_purch_ctr=j.ctr_id
-- left join (
-- select js_project,sum(ifnull(js_amount,0)-ifnull(js_fd,0)-ifnull(js_salary,0)) jsamount  from 
-- (select * from project_kpi_cost order by js_year desc,js_month desc)a
-- left join dict_date on js_month = date_month 
-- where (js_year ='${year}' and date_quarter<='${jidu}') or js_year<'${year}'  
--  group by js_project  
-- )cost on a.key_id=js_project  
left join (/*二次开发金额*/
SELECT sum(ifnull(pro_day_outspay,0))sln_amount,pro_project FROM `project_sln_info`
where (year(pro_recdate)='${year}' and QUARTER(pro_recdate) <='${jidu}' or year(pro_recdate)<'${year}')
group by pro_project
)sln on a.key_id=pro_project
left join (/*餐补+绩效*/
select sum(ifnull(prjx_amount_jx,0)) prjx_amount_jx,prjx_project from project_member_jx
left join dict_date on prjx_month = date_month 
where (prjx_year ='${year}' and date_quarter<='${jidu}') or prjx_year<'${year}'  
group by prjx_project
)jx on a.key_id=prjx_project  
LEFT JOIN (/*出差费用*/
select project_id,sum(if(finan.subject=347,amount_recoup,0)) fh_amount,sum(if(finan.subject=128,amount_recoup,0)) dache,sum(if(finan.subject=226,amount_recoup,0)) canbu,sum(if(b.parent =302,amount_recoup,0))fangzu, sum(if(b.parent =302 ||finan.subject=128 ||finan.subject=226 ||finan.subject=347 ,0,amount_recoup))recoup_amount from finan_recoup finan 
join finan_dict_subject b on finan.subject =b.id
join finan_dict_subject c on b.parent = c.id
where project_id is not null  and (c.parent ='2' || b.parent ='2') and finan.subject <>'141'
and ((year(happenday)='${year}' and QUARTER(happenday) <='${jidu}') or year(happenday)<'${year}')
GROUP BY project_id
)recoup on recoup.project_id=a.key_id
left join (select project_id,sum(amount_recoup) amount_recoup_zong from  finan_recoup
where ((year(happenday)='${year}' and QUARTER(happenday) <='${jidu}') or year(happenday)<'${year}') 
and subject <>'141'
group by project_id
 ) re on re.project_id = a.key_id
 
 
left join (select project as key_id,round(sum(amount),0) as zongchengben
from(
select project,year(day) as year,QUARTER(day) as jd,(SUM(ifnull(c.c_value,1))/2 ) as days
,ifnull(n.price_amount,m.price_amount) as price,(SUM(ifnull(c.c_value,1))/2 )*ifnull(n.price_amount,m.price_amount) as amount
from project_opportunity1 
join prj_qiandao_time a on project=key_id and project_type='项目实施' and user_type=1 and project_mode=0 and day<=if('${jddate}'>curdate(),curdate(),'${jddate}')
left join project_out_coefficient c on a.user=c_username and a.day BETWEEN c_startdate and c_enddate
left join project_region_unitprice m on m.price_year =2018 and m.price_jidu=3 and(year(day)<2018 or(year(day)=2018 and QUARTER(day)<4)) and m.price_province=prj_province
left join(select * from(select * from project_region_unitprice order by price_year desc,price_jidu desc )list group by price_year,price_jidu,price_province)n on n.price_year=2019  and n.price_jidu=1 and (year(day)>2018 or(year(day)=2018 and QUARTER(day)=4)) and n.price_province=prj_province
/*where prj_status in ('实施阶段','运维阶段','项目关闭')*/
group by project,year(day),QUARTER(day)
)list
group by project
)zongcb on zongcb.key_id=a.key_id

where 1=1
${if(len(company)=0,"","and b.com_id in('"+company+"') ")}
${if(len(area)=0,"","and d.team_region in  ('"+area+"')")}
${if(len(waibao)=0,"","and f.waibao in  ('"+waibao+"')")}
${if(len(xqstartdate)=0,"","and c.REQ_INPUT_DATE >= '"+xqstartdate+"'")}
${if(len(xqenddate)=0,"","and c.REQ_INPUT_DATE <= '"+xqenddate+"'")}
${if(len(jxstartdate)=0,"","and history_time >= '"+jxstartdate+"'")}
${if(len(jxenddate)=0,"","and history_time <= '"+jxenddate+"'")}
${if(len(dengji)=0,"","and e.dengjiid in  ('"+dengji+"')")}
${if(find("销售",fine_userposition)<>0 && find("大区",fine_userposition)<>0," and com_sales_region in (select sales_region from hr_salesman where sales_parent= '"+fine_username+"' ) ",if(find("销售",fine_userposition)<>0 && find("大区",fine_userposition)=0," and a.prj_salesman = '"+fine_username+"' ","") )}
#having ifnull(prj,0)<>0
order  by  d.team_region,d.team_kind,d.team_paixu,prj_number

select * from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by if(team_name regexp '项目',0,1),team_kind,team_paixu

select prj_user,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu,team_right,if(team_name regexp '项目' and team_name regexp '组',0,1) xuhao from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_project=1 and team_verified="valid" and prj_verified="valid"
union select team_name as prj_user,null as team_name,team_name as name,team_paixu,team_right,if(team_name regexp '项目' and team_name regexp '组',0,1) xuhao from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by xuhao,team_right ,team_paixu,prj_user

SELECT distinct team_region FROM hr_department_team where team_region is not null

select tag_id,tag_name from prj_tag  where tag_type='37'

SELECT sales_name,b.user_name FROM `hr_salesman` a
left join hr_user b on a.sales_name = b.user_username 
join hr_area on area_region = sales_region
where 1=1
${if(len(area)>0,"and replace(replace(area_area,'区','组'),'京津','北京') in ('"+area+"')","")}

select tag_id,tag_name from prj_tag  where tag_type='32'

 SELECT * FROM `prj_title_show` where title_use ='成本' order by title_order

select year(curdate())-1 y union 
select year(curdate()) y union 
select year(curdate())+1 y   

select key_id,opportunity_name,com_id,com_name from project_opportunity1 left join cust_company on customer_id=com_id
where 1=1
${if(len(company)=0,"","and com_id in('"+company+"')")}

select prj_number from project_opportunity1 left join cust_company on customer_id=com_id
where 1=1
${if(len(company)=0,"","and com_id in('"+company+"')")}
${if(len(oppname)=0,"","and opportunity_name in('"+oppname+"')")}

select com_id,com_name from project_opportunity1 left join cust_company on customer_id=com_id


select project as key_id,sum(days)as days
,price,round(sum(amount),0) as zongchengben
from(
select project,year(day) as year,QUARTER(day) as jd,(SUM(ifnull(c.c_value,1))/2 ) as days
,ifnull(n.price_amount,m.price_amount) as price,(SUM(ifnull(c.c_value,1))/2 )*ifnull(n.price_amount,m.price_amount) as amount
from project_opportunity1 
join prj_qiandao_time a on project=key_id and project_type='项目实施' and user_type=1 and project_mode=0 and day<=if('${jddate}'>curdate(),curdate(),'${jddate}')
left join project_out_coefficient c on a.user=c_username and a.day BETWEEN c_startdate and c_enddate
left join project_region_unitprice m on m.price_year =2018 and m.price_jidu=3 and(year(day)<2018 or(year(day)=2018 and QUARTER(day)<4)) and m.price_province=prj_province
left join(select * from(select * from project_region_unitprice order by price_year desc,price_jidu desc )list group by price_year,price_jidu,price_province)n on n.price_year=2019  and n.price_jidu=1 and (year(day)>2018 or(year(day)=2018 and QUARTER(day)=4)) and n.price_province=prj_province
where 1=1
/*prj_status in ('实施阶段','运维阶段','项目关闭')*/
and key_id in('${keyid}')
group by project,year(day),QUARTER(day)
)list
group by project


