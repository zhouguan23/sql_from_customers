/*营销线new*/

select
opp.*,opp.key_id,com_name,ctr_id,ctr_project,
ifnull(ctr_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0) ctr_amount,/*合同金额*/
ifnull(prj_amount,0)*ifnull(f_amount,1)-ifnull(sumpay_bill,0)*ifnull(prj_amount,0)/ifnull(ctr_amount,0) prj_amount,/*实施金额*/
pay_paid,outs_amount,/*外包实施金额*/
prj_salesman_name salesman,projectmanager manager,tags_names,ifnull(opp.prj_finishdate,opp.prj_enddate) enddate,concat(opp.prj_startdate,"~",ifnull(opp.prj_finishdate,opp.prj_enddate) ) ctr_date
,ifnull(pst.tag_cost,0)tag_cost

,g.days,ifnull(sum1,0) sum1
from project_opportunity1 opp

left join (select project,sum(ifnull(days,0)) days from (${replace(SQL("CRM","SELECT statement FROM PRJ_SQL_COLLECT WHERE ID =2",1,1),'%keyid%',keyid)}) a
 group by project) g on opp.key_id = g.project  /*已用人天*/
 
left join prj_project_tags t on t.tags_project=opp.key_id and t.tags_type=37
left join project_contract_link on ctrlink_key=opp.key_id
left join (select tag_project,sum(tag_cost)tag_cost  from project_senior_tag  group by tag_project) pst on opp.key_id = pst.tag_project
left join cust_company on com_id=customer_id
left join sale_contract_info on ctr_id=ctrlink_contract
left join finan_other_statistics cur on f_remark='CNY' and f_type=ctr_currency
left join (select sum(IFNULL(prj_amount,0)) prj_amount,prj_contract from sale_contract_of_project group by prj_contract)prj on prj.prj_contract=ctr_id
left join (select sum(ifnull(pay_paid,0)*ifnull(f_amount,1)) pay_paid,pay_contract from sale_payment 
left join finan_other_statistics on f_remark='CNY' and f_type=pay_currency
group by pay_contract)paid on pay_contract=ctr_id
left join (select pay_contract sum_contract,sum(IFNULL(pay_bill,0)*ifnull(f_amount,1))sumpay_bill from sale_payment
LEFT JOIN sale_contract_info on pay_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
 where pay_status in('记坏账','已作废')group by pay_contract)sumpay on sum_contract=ctr_id
#实施外包
left join 
(select ctr_id outs_contract,sum(d_outstype_amount) outs_amount from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
join v_sale_contract_info_valid on ctr_id=outs_contract
where ctr_verified='valid' and outs_status!="已作废" and d_outs_type="实施"
group by ctr_id)outs on outs_contract=ctr_id

/*********总成本********/

left join(
select  (ifnull(project_expense,0) + ifnull(amount_ek,0))  sum1,key_id
from (
select ifnull(pro_day_outspay,0) amount_ek ,ifnull(project_expense,0) project_expense
,opp.key_id
from
project_opportunity1  opp
left join
(SELECT b.role_user,e.prj_name,c.project_type jieduan,user_type,project_type,
ifnull(m.price_amount,mm.price_amount) price_amount,count(day)*0.5 days,
sum(0.5*ifnull(m.price_amount,mm.price_amount)) project_expense ,key_id
FROM project_opportunity1 a 
join prj_project_role b on a.key_id = b.role_project and b.role_type ='1'
left join project_members e on b.role_user = e.prj_user
left join prj_qiandao_time c on c.user_type='1' and b.role_user = c.`user` and ( ( (a.key_id = c.project or a.prj_number=c.project ) and c.project_type = '项目实施' ) or ((a.key_id = c.project or a.prj_number=c.project ) and c.project_type ='需求评估')) 
left join project_region_unitprice m on m.price_year =year(c.day) and m.price_jidu =QUARTER(c.day) and m.price_province=a.prj_province
left join project_region_unitprice mm on mm.price_year =year(c.day) 
and mm.price_jidu =(QUARTER(c.day)-1) and mm.price_province=a.prj_province
where a.key_id ='${keyid}' and day >='2020-01-01' 
group by b.role_user,c.project_type) nb on nb.key_id = opp.key_id

left join 
(select  pro_day_price*pretime amount_ek,pro_key,pro_day_price,pro_project,pro_day_outspay, ek.* from project_sln_info /*二开成本表*/
left join 
 (
   select TIMEORIGINALESTIMATE pretime, accept_time,jira_keys,projectname,sec_contractid
    from  fr_t_system1
    where accept_time >='2020-01-01'
  ) ek on pro_key =  jira_keys


where pro_project ='${keyid}'
) er on er.pro_project = opp.key_id 

group by role_user,jieduan
)
dd)ee  on ee.key_id=opp.key_id


where opp.key_id=convert("${keyid}" using utf8) and ctr_id=convert("${ctrid}" using utf8)



select a.*,ifnull(pay_bill,0)*ifnull(bd.f_amount,1)paybill,ifnull(pay_payable,0)*ifnull(bd.f_amount,1) paypayable,
ifnull(pay_paid,0)*ifnull(ad.f_amount,1) paypaid ,outs_paid,outspay_paydate ,outspay_outsource 
 , 
 if ( d.ctd is null,0,ifnull(sum_wb,0)) sum_wb,
 if (d.ctd is null,0,ifnull(sum_ek,0)) sum_ek, 
 if ( d.ctd is null,0,ifnull(sum_nb,0)) sum_nb,d.ctd
 
 from sale_payment a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency

/*关联第一条合同*/
 left join 
 (SELECT ctr_id ,ifnull(ctrlink_contract,0 )ctd,ctrlink_key ,ctr_signdate FROM sale_contract_info 
left join 
(select ctrlink_contract ,ctrlink_key from project_contract_link) opp on ctrlink_contract = ctr_id 
where ctrlink_key = '${keyid}' 
order by ctr_signdate limit 1
)d
 on  d.ctd = a.pay_contract 



/*************外包*************/
left join
(select a.pay_contract p_ct,pay_id PD2,outs_paid,outspay_paydate ,outspay_outsource 
 ,sum(if (pay_enddate>outspay_paydate,outs_paid ,0 )) sum_wb

 from sale_payment a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency

 /***********实施外包付款***************/
left join (
select  outs_paid,outs_contract,outspay_id,outspay_paydate,outspay_outsource  ,outs_id
from 
(select IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount outs_paid,outs_contract ,
outspay_id,outspay_paydate,outspay_outsource,outs_id
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
where outs_status!="已作废" and d_outs_type="实施" 
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
where  outspay_paydate >='2020-01-01'
group by outs_id,outs_contract)main 
where outs_contract ='${ctrid}'
group by outs_id,outs_contract
) aa  on a.pay_contract =aa.outs_contract

where pay_contract=convert("${ctrid}" using utf8) and outspay_paydate >='2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc) wb on wb.p_ct = a.pay_contract and wb.PD2= a.pay_id

/*********二开金额*****************/
left join (
select a.pay_contract p_contract,pay_id PD1,sum(if (pay_enddate>accept_time,amount_ek ,0 )) sum_ek,accept_time

 from sale_payment a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency
/************链接项目机会表***********/
left join (select ctrlink_contract,key_id,prj_number,opportunity_name,prj_status from project_opportunity1
            left join project_contract_link ht on ht.ctrlink_key=key_id 
       where   ctrlink_contract ='${ctrid}'         
 ) opp  on opp.ctrlink_contract = a.pay_contract

left join 
(select  pro_day_price*pretime amount_ek,pro_key,pro_day_price,pro_project,pro_day_outspay, ek.* from project_sln_info /*二开成本表*/
left join 
 (
   select TIMEORIGINALESTIMATE pretime, accept_time,jira_keys,projectname,sec_contractid
    from  fr_t_system1
  ) ek on pro_key =  jira_keys
  where pro_project = '${keyid}'
) er on er.pro_project = opp.key_id 


where pay_contract=convert("${ctrid}" using utf8) and accept_time >= '2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc
) ek on ek.PD1= a.pay_id 




/************内部成本**************/
left join (
select a.pay_contract pt,pay_id PD,
nb.day,sum(if (pay_enddate>day,dayamount,0)) sum_nb
 from sale_payment a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency
/************链接项目机会表***********/
left join (select ctrlink_contract,key_id,prj_number,opportunity_name,prj_status from project_opportunity1
            left join project_contract_link ht on ht.ctrlink_key=key_id 
       where   ctrlink_contract ='${ctrid}'         
 ) opp  on opp.ctrlink_contract = a.pay_contract


left join 
(select a.project,sum(ifnull(a.days,0)*ifnull(m.price_amount,mm.price_amount)) dayamount,
a.prj_status,a.contract_id,day
from 
(select sum(if(`day` between c_startdate and c_enddate,0.5*c_value,0.5)) days,day,a.key_id as project,a.prj_province,year(day) yy,QUARTER(day) qq ,QUARTER(day)-1 dd,prj_status,contract_id
from project_opportunity1 a 
join prj_qiandao_time c 
on (a.key_id = c.project or a.prj_number=c.project) and user_type='1' and status ='0' and (out_type = 0 or out_type = 16 ) 

left join project_out_coefficient on c_username=c.`user`


group by a.key_id,day
 )a
left join project_region_unitprice m on m.price_year =a.yy and m.price_jidu =a.qq 
and m.price_province=a.prj_province

left join project_region_unitprice mm on mm.price_year =a.yy and mm.price_jidu =a.dd 
and mm.price_province=a.prj_province
where a.project ='${keyid}'
group by day ,a.project)nb on nb.project =opp.key_id


where pay_contract=convert("${ctrid}" using utf8)  and day >='2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc) nb on nb.PD = a.pay_id




where pay_contract=convert("${ctrid}" using utf8) 
and ((pay_enddate>='2020-01-01') or (pay_enddate is null)) 

group by pay_id  
order by ifnull(pay_enddate,'2099')  asc

/*select prj_user,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_project=1 and team_verified="valid" and prj_verified="valid"
union select team_name as prj_user,null as team_name,team_name as name, team_paixu from hr_department_team
where team_department=18 and team_project=1 and team_verified="valid"
order by team_paixu,prj_user*/

select distinct prj_user,prj,team_name,name,team_paixu
from (
select user prj_user,project prj,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from (
select * from hr_time where out_type=4 
)a join (
select * from hr_time_reason where project is not null 
)b on a.reason_id=b.reason_id
left join project_members on user=prj_user
left join hr_department_team on team_id=prj_team
where project="${keyid}"
GROUP BY user,project
union 
select prj_user,${keyid} prj,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
join project_opportunity1 on prj_user=projectmanager and key_id="${keyid}"
)main
union
select 'luren',null,null,'luren',null
union
select 'luren1',null,null,'luren1',null

select * from project_payment

select user p_user,project prj,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from (
select * from hr_time where out_type=4 
)a join (
select * from hr_time_reason where project is not null 
)b on a.reason_id=b.reason_id
left join project_members on user=prj_user
left join hr_department_team on team_id=prj_team
where project="${keyid}"
GROUP BY user,project
union 
select prj_user p_user,${keyid} prj,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_id=1

SELECT CONCAT("SLN-",issuenum)jirakey,summary,it.pname,pn.STRINGVALUE,date(ks.DATEVALUE) kstart,date(ke.DATEVALUE) kend,date(ys.DATEVALUE) ystart,date(ye.DATEVALUE) yend,date(tt.DATEVALUE)ttime,TIMEORIGINALESTIMATE/3600/8 pretime,date(created) created from jira.jiraissue j
LEFT JOIN jira.customfieldvalue ks on j.id=ks.ISSUE and ks.CUSTOMFIELD=10302
LEFT JOIN jira.customfieldvalue ke on j.id=ke.ISSUE and ke.CUSTOMFIELD=10303
LEFT JOIN jira.customfieldvalue ys on j.id=ys.ISSUE and ys.CUSTOMFIELD=11315
LEFT JOIN jira.customfieldvalue ye on j.id=ye.ISSUE and ye.CUSTOMFIELD=10904
LEFT JOIN jira.customfieldvalue pn on j.id=pn.ISSUE and pn.CUSTOMFIELD=10441
LEFT JOIN jira.customfieldvalue tt on j.id=tt.ISSUE and tt.CUSTOMFIELD=10819
LEFT JOIN jira.customfieldvalue ct on j.id=ct.ISSUE and ct.CUSTOMFIELD=10819
LEFT JOIN jira.nodeassociation on j.id=SOURCE_NODE_ID and sink_node_entity="Component"
LEFT JOIN jira.issuestatus it on issuestatus=it.ID
where PROJECT=10303 and SINK_NODE_ID=11122 and year(tt.DATEVALUE)>=2018 and it.pname="验收完成"
and (pn.STRINGVALUE="${keyid}" or pn.STRINGVALUE="${uid}" or pn.STRINGVALUE="${wuxiaokeyid}")
ORDER BY issuenum desc

select * from project_sln_info

select prj_user,team_name,concat(prj_user,"(",prj_name,")") name,team_paixu from project_members
left join hr_department_team on team_id=prj_team
where team_department=18 and team_verified="valid" and prj_verified="valid" and team_id=2
order by team_paixu,prj_user

select distinct prj_user,name,projectmanager_name,prj_demander
from (
select b.role_user prj_user,concat(b.role_user,"(",user_name,")") name,projectmanager_name,prj_demander from project_opportunity1 a
join prj_project_role b on a.key_id = b.role_project and b.role_type ='1'
join hr_user c on b.role_user = c.user_username
where a.key_id="${keyid}"
union 
select prj_user,concat(prj_user,"(",prj_name,")") name,'','' from project_members
join project_opportunity1 on prj_user=projectmanager and key_id="${keyid}"

)main

select tag_id,tag_name from prj_tag where tag_type ='73' and tag_verified =1 order by tag_order

select * from project_senior_tag  where tag_project ='${keyid}'

select cc.user,if(days<>0,days/sum(d),0) bli,user_type,project_mode,project_type FROM
(
select
count(day)*0.5 d,project,user_type,project_mode,project_type
FROM prj_qiandao_time 
where project ='${keyid}' and user_type='1' 
group by project) bb
left join 
(select count(day)*0.5 days ,project ,user
FROM prj_qiandao_time 
where project ='${keyid}' and user_type='1' 
group by project,user ) cc on bb.project  =cc.project

group BY user

select a.*,ifnull(pay_bill,0)*ifnull(bd.f_amount,1)paybill,ifnull(pay_payable,0)*ifnull(bd.f_amount,1) paypayable,
ifnull(pay_paid,0)*ifnull(ad.f_amount,1) paypaid 
 from sale_payment a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contact =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency
where pay_contract=convert("${ctrid}" using utf8) and pay_enddate <'2020-01-01'
order by pay_enddate desc

select distinct payID from project_payment where ctd ='${ctrid}'

select a.*,ifnull(pay_bill,0)*ifnull(bd.f_amount,1)paybill,ifnull(pay_payable,0)*ifnull(bd.f_amount,1) paypayable,
ifnull(pay_paid,0)*ifnull(ad.f_amount,1) paypaid ,outs_paid,outspay_paydate ,outspay_outsource 
 , 
 if ( d.ctd is null,0,ifnull(sum_wb,0)) sum_wb,
 if (d.ctd is null,0,ifnull(sum_ek,0)) sum_ek, 
 if ( d.ctd is null,0,ifnull(sum_nb,0)) sum_nb
 
 from 
 
 (select pay_id,pay_contract,pay_bill,pay_paid,pay_enddate,pay_unpaid,pay_status,pay_currency,pay_payable, 0 remark from sale_payment where pay_contract='${ctrid}'
union 
select '${A1}','${ctrid}',0,0,'2099-12-31',0,'已回款','CNY','2099-12-31',1 remark) a

left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency

/*关联第一条合同*/
 left join 
 (SELECT ctr_id ,ifnull(ctrlink_contract,0 )ctd,ctrlink_key ,ctr_signdate FROM sale_contract_info 
left join 
(select ctrlink_contract ,ctrlink_key from project_contract_link) opp on ctrlink_contract = ctr_id 
where ctrlink_key = '${keyid}' 
order by ctr_signdate limit 1
)d
 on  d.ctd = a.pay_contract 


/*************外包*************/
left join
(select a.pay_contract p_ct,pay_id PD2,outs_paid,outspay_paydate ,outspay_outsource 
 ,sum(if (pay_enddate>outspay_paydate,outs_paid ,0 )) sum_wb

 from (select pay_id,pay_contract,pay_bill,pay_paid,pay_enddate,pay_unpaid,pay_status,pay_currency,pay_payable, 0 remark from sale_payment where pay_contract='${ctrid}'
union 
select '${A1}','${ctrid}',0,0,'2099-12-31',0,'已回款','CNY','2099-12-31', 1 remark) a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency

 /***********实施外包付款***************/
left join (
select  outs_paid,outs_contract,outspay_id,outspay_paydate,outspay_outsource  ,outs_id
from 
(select IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount outs_paid,outs_contract ,
outspay_id,outspay_paydate,outspay_outsource,outs_id
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
where outs_status!="已作废" and d_outs_type="实施" 
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
where  outspay_paydate >='2020-01-01'
group by outs_id,outs_contract)main 
where outs_contract ='${ctrid}'
group by outs_id,outs_contract
) aa  on a.pay_contract =aa.outs_contract

where pay_contract=convert("${ctrid}" using utf8) and outspay_paydate >='2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc) wb on wb.p_ct = a.pay_contract and wb.PD2= a.pay_id

/*********二开金额*****************/
left join (
select a.pay_contract p_contract,pay_id PD1,sum(if (pay_enddate>accept_time,amount_ek ,0 )) sum_ek,accept_time

 from (select pay_id,pay_contract,pay_bill,pay_paid,pay_enddate,pay_unpaid,pay_status,pay_currency,pay_payable, 0 remark from sale_payment where pay_contract='${ctrid}'
union 
select '${A1}','${ctrid}',0,0,'2099-12-31',0,'已回款','CNY','2099-12-31', 1 remark)a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency
/************链接项目机会表***********/
left join (select ctrlink_contract,key_id,prj_number,opportunity_name,prj_status from project_opportunity1
            left join project_contract_link ht on ht.ctrlink_key=key_id 
       where   ctrlink_contract ='${ctrid}'         
 ) opp  on opp.ctrlink_contract = a.pay_contract

left join 
(select  pro_day_price*pretime amount_ek,pro_key,pro_day_price,pro_project,pro_day_outspay, ek.* from project_sln_info /*二开成本表*/
left join 
 (
   select TIMEORIGINALESTIMATE pretime, accept_time,jira_keys,projectname,sec_contractid
    from  fr_t_system1
  ) ek on pro_key =  jira_keys
  where pro_project = '${keyid}'
) er on er.pro_project = opp.key_id 


where pay_contract=convert("${ctrid}" using utf8) and accept_time >= '2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc
) ek on ek.PD1= a.pay_id


/************内部成本**************/
left join (
select a.pay_contract pt,pay_id PD,
nb.day,sum(if (pay_enddate>day,dayamount,0)) sum_nb
 from (select pay_id,pay_contract,pay_bill,pay_paid,pay_enddate,pay_unpaid,pay_status,pay_currency,pay_payable, 0 remark from sale_payment where pay_contract='${ctrid}'
union 
select '${A1}','${ctrid}',0,0,'2099-12-31',0,'已回款','CNY','2099-12-31', 1 remark) a
left join finan_other_statistics ad on ad.f_remark='CNY' and ad.f_type=pay_currency
left join sale_contract_info b on a.pay_contract =b.ctr_id 
left join finan_other_statistics bd on bd.f_remark='CNY' and bd.f_type=ctr_currency
/************链接项目机会表***********/
left join (select ctrlink_contract,key_id,prj_number,opportunity_name,prj_status from project_opportunity1
            left join project_contract_link ht on ht.ctrlink_key=key_id 
       where   ctrlink_contract ='${ctrid}'         
 ) opp  on opp.ctrlink_contract = a.pay_contract


left join 
(select a.project,sum(ifnull(a.days,0)*ifnull(m.price_amount,mm.price_amount)) dayamount,
a.prj_status,a.contract_id,day
from 
(select sum(if(`day` between c_startdate and c_enddate,0.5*c_value,0.5)) days,day,a.key_id as project,a.prj_province,year(day) yy,QUARTER(day) qq ,QUARTER(day)-1 dd,prj_status,contract_id
from project_opportunity1 a 
join prj_qiandao_time c 
on (a.key_id = c.project or a.prj_number=c.project) and user_type='1' and status ='0' and (out_type = 0 or out_type = 16 ) 

left join project_out_coefficient on c_username=c.`user`


group by a.key_id,day
 )a
left join project_region_unitprice m on m.price_year =a.yy and m.price_jidu =a.qq 
and m.price_province=a.prj_province
left join project_region_unitprice mm on mm.price_year =a.yy and mm.price_jidu =a.dd 
and mm.price_province=a.prj_province


where a.project ='${keyid}'

group by day ,a.project)nb on nb.project =opp.key_id


where pay_contract=convert("${ctrid}" using utf8)  and day >='2020-01-01'
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc) nb on nb.PD = a.pay_id

where pay_contract=convert("${ctrid}" using utf8) 
and ((pay_enddate>='2020-01-01') or (pay_enddate is null))
and a.remark=1
group by pay_id  
order by ifnull(pay_enddate,'2099')  asc


