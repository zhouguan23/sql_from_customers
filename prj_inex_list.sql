select * from 
(select ctr_id,ctr_project,opportunity_name,com_name,ctr_amount,prj_amount,ctr_salesman,ctr_signdate,projectmanager,team_name,if(com_salesman='aaron'&&com_country='中国','上海',tags_name)region,date_month from 
project_opportunity1
left join hr_department_team on team_id=prj_team
left join cust_company on com_id=customer_id
join project_contract_link on ctrlink_key=key_id
join sale_contract_info on ctrlink_contract=ctr_id
left join hr_user_tags on tag_username=com_salesman
left join hr_tags on tags_id=tag_region_id
left join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
left join dict_date on 1=1
where 1=1 
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and team_id in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(region)=0,"","and if(com_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and com_salesman in ('"+salesman+"')")})main
/*************实际回款**************/
left join 
(select sum(prj_paid)prj_paid,sum(pay_paid)pay_paid,pay_month,pay_contract,sum(if(tag="逾期回款",prj_paid,0))paid_yqhk,sum(if(tag="提前回款",prj_paid,0))paid_tqhk,sum(if(tag="正常回款",prj_paid,0))paid_zchk from (
select pay_id,pay_contract,pay_paid/ctr_amount*prj_amount*f_amount prj_paid,pay_paid,pay_enddate,month(pay_enddate) pay_month,
case when ifnull(pay_paid,0)>0 and pay_predate<pay_enddate then "逾期回款"
when ifnull(pay_paid,0)>0 and pay_predate>pay_enddate then "提前回款"
when ifnull(pay_paid,0)>0 and pay_predate=pay_enddate then "正常回款" 
else "w" end tag
from sale_payment
left join finan_other_statistics on f_type=ifnull(pay_currency,"CNY") and f_remark="CNY"
left join sale_contract_info  on ctr_id=pay_contract
join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where year(pay_enddate)="${year}")list
group by pay_month,pay_contract)paid_list on pay_contract=ctr_id and pay_month=date_month
/************预计回款***************/
left join 
(select sum(prj_bill)prj_bill,sum(pay_bill)pay_bill,pre_month,pay_contract prepay_contract from (
select pay_id,pay_contract,pay_bill/ctr_amount*prj_amount*f_amount prj_bill,pay_bill,pay_predate,month(pay_predate) pre_month
from sale_payment
left join sale_contract_info  on ctr_id=pay_contract
left join finan_other_statistics on f_type=ifnull(ctr_currency,"CNY") and f_remark="CNY"
join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type in ("实施","运维") group by det_contract)prj on det_contract=ctr_id
where year(pay_predate)="${year}" and pay_status not in ("已作废","记坏账") and pay_verified="valid")list
group by pre_month,prepay_contract)prepay_list on  pre_month=date_month and prepay_contract=ctr_id



select sum(prj_paid)prj_paid,sum(pay_paid)pay_paid,pay_month,pay_contract,tag from (
select pay_id,pay_contract,pay_paid/ctr_amount*prj_amount*f_amount prj_paid,pay_paid,pay_enddate,month(pay_enddate) pay_month,
case when pay_predate<pay_enddate then "逾期回款"
when pay_predate>pay_enddate then "提前回款"
else "正常回款" end tag
from sale_payment
left join finan_other_statistics on f_type=ifnull(pay_currency,"CNY") and f_remark="CNY"
left join sale_contract_info  on ctr_id=pay_contract
join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type="实施" group by det_contract)prj on det_contract=ctr_id
where year(pay_enddate)="${year}")list
group by pay_month,tag,pay_contract

select sum(prj_bill)prj_bill,sum(pay_bill)pay_bill,pre_month,pay_contract from (
select pay_id,pay_contract,pay_bill/ctr_amount*prj_amount*f_amount prj_bill,pay_bill,pay_predate,month(pay_predate) pre_month
from sale_payment
left join sale_contract_info  on ctr_id=pay_contract
left join finan_other_statistics on f_type=ifnull(ctr_currency,"CNY") and f_remark="CNY"
join (select sum(det_amount)prj_amount,det_contract from v_contract_detail where det_type="实施" group by det_contract)prj on det_contract=ctr_id
where year(pay_predate)="${year}")list
group by pre_month,pay_contract

select * from hr_tags where tags_type="区域" and tags_name not in ("待分配","无","总部")

select * from hr_department_team
where team_department=18 and team_verified="valid" and team_region not in ("总部")
order by team_paixu

select user_username,concat(user_username,"-",user_name)name from hr_salesman
left join hr_user on user_username=sales_name
where 1=1
${if(len(region)=0,"","and sales_region in ('"+region+"')")}

SELECT user_username,concat(user_username,"-",user_name)name FROM project_members
left join hr_user on user_username=prj_user
left join hr_department_team on team_id=prj_team
where prj_verified="valid" and team_region not in ("总部")
${if(len(region)=0,"","and team_base in ('"+region+"')")}


select outspay_id,outspay_outsource,outs_contract,sum(outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1))outspay_paid,sum(outspay_amount*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1)) outspay_amount,outspay_predate,outspay_paydate,app_contracttype,year(outspay_predate)year,month(outspay_predate)month from 
(select * from sale_outsource_payment where year(outspay_predate)="${year}")main 
left join sale_outsource_apply on outspay_appid=app_numid and ifnull(outspay_outsource,"")=""
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
left join project_opportunity1 on ctrlink_key=key_id
left join cust_company on com_id=customer_id 
left join hr_user_tags on tag_username=outspay_salesman
left join hr_tags on tags_id=tag_region_id
where (d_outs_type="实施" or ifnull(outspay_outsource,"")="" and app_type=0)
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and prj_team in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(salesman)=0,"","and outspay_salesman in ('"+salesman+"')")}
${if(len(region)=0,""," and if(outspay_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
group by outspay_id

select outspay_id,
case when ifnull(outspay_outsource,"")="" or ifnull(paid_leiji,0)<ifnull(outspay_paid_zq,0)+ifnull(outspay_paid_dt,0) then ifnull(outspay_paid,0)
when ifnull(outspay_outsource,"")<>"" and ifnull(app_contracttype,0)<>"项目整包合同" then ifnull(outspay_paid,0)*(1-if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)<0,0,if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)>outspay_paid_dt,outspay_paid_dt,ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)))/outspay_paid_dt)
else 0 end tqfk, 
case when ifnull(outspay_outsource,"")<>"" and ifnull(app_contracttype,0)<>"项目整包合同" and outspay_predate<=outspay_paydate and ifnull(paid_leiji,0)>=ifnull(outspay_paid_zq,0)+ifnull(outspay_paid_dt,0) then ifnull(outspay_paid,0)*if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)<0,0,if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)>outspay_paid_dt,outspay_paid_dt,ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)))/outspay_paid_dt
else 0 end zcfk,
case when  ifnull(outspay_outsource,"")<>"" and ifnull(app_contracttype,0)<>"项目整包合同" and outspay_predate>outspay_paydate and ifnull(paid_leiji,0)>=ifnull(outspay_paid_zq,0)+ifnull(outspay_paid_dt,0) then ifnull(outspay_paid,0)*if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)<0,0,if(ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)>outspay_paid_dt,outspay_paid_dt,ifnull(paid_leiji,0)-ifnull(outspay_paid_zq,0)))/outspay_paid_dt
else 0 end yqfk,
month(outspay_paydate) month
from (
select outspay_id,outspay_outsource,outs_contract,outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1)outspay_paid,outspay_amount*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1)outspay_amount,outspay_predate,outspay_paydate,app_contracttype,key_id,ifnull(sup_name,outs_2ndparty)supplier,
/******回款金额*******
(select sum(ifnull(pay_paid,0))paid_leiji from sale_payment left join sale_contract_info on ctr_id=pay_contract
join project_contract_link on ctrlink_contract=ctr_id 
where ctrlink_key=project_opportunity1.key_id and pay_enddate<main.outspay_paydate)*/ifnull(js_ctr_paid,0) paid_leiji,
/*****当天外包付款****
(select sum(outspay_paid) from (select outspay_id,outspay_outsource,outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1) outspay_paid,ifnull(outs_amount,app_amount)outs_amount,outspay_paydate,ctrlink_key 
from sale_outsource_payment
left join sale_outsource_apply on outspay_appid=app_numid
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
where (d_outs_type="实施" or ifnull(outs_contract,"")="" and app_type=0)
group by outspay_id)list
where ctrlink_key=project_opportunity1.key_id and outspay_paydate=main.outspay_paydate)*/ifnull(js_outspaid_dt,0) outspay_paid_dt,
/*****之前外包付款累计***
(select sum(outspay_paid) from (select outspay_id,outspay_outsource,outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1) outspay_paid,ifnull(outs_amount,app_amount)outs_amount,outspay_paydate,ctrlink_key 
from sale_outsource_payment
left join sale_outsource_apply on outspay_appid=app_numid
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
where (d_outs_type="实施" or ifnull(outs_contract,"")="" and app_type=0)
group by outspay_id)list
where ctrlink_key=project_opportunity1.key_id and outspay_paydate<main.outspay_paydate)*/ifnull(js_outspaid_zq,0) outspay_paid_zq
from 
(select * from sale_outsource_payment  where year(outspay_paydate)="${year}")main
left join project_outspay_js on js_oustpay=outspay_id
left join sale_outsource_apply on outspay_appid=app_numid
left join sale_outsource on outs_id=outspay_outsource
left join project_supplier on sup_id=ifnull(outs_supplier,app_supplier)
left join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
left join project_opportunity1 on ctrlink_key=key_id or key_id=outspay_project
left join hr_department_team on team_id=prj_team
left join cust_company on com_id=customer_id
left join hr_user_tags on tag_username=outspay_salesman
left join hr_tags on tags_id=tag_region_id
where (d_outs_type="实施" or ifnull(outs_contract,"")="" and ifnull(app_type,0)=0)
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and team_id in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(region)=0,"","and if(com_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and com_salesman in ('"+salesman+"')")}
group by outspay_id)list
where  ifnull(outs_contract,"")="" or ifnull(app_contracttype,0)<>"项目整包合同"


select *,outs_amount*ifnull(paid_rate,0) outspay_yingfu,month(outspay_paydate)month,
if(outspay_paid_leiji>outs_amount*ifnull(paid_rate,0),if(outspay_paid_leiji-outs_amount*ifnull(paid_rate,0)>outspay_paid,outspay_paid,outspay_paid_leiji-outs_amount*ifnull(paid_rate,0)),0)outspay_tqfk,
if(outspay_paid_leiji<=outs_amount*ifnull(paid_rate,0)&&outspay_predate>=outspay_paydate,outspay_paid,
if(outspay_paid_leiji>outs_amount*ifnull(paid_rate,0)&&outspay_predate>=outspay_paydate&&outspay_paid_leiji-outs_amount*ifnull(paid_rate,0)<outspay_paid,outspay_paid-outspay_paid_leiji+outs_amount*ifnull(paid_rate,0),0)) outspay_zcfk,
if(outspay_paid_leiji<=outs_amount*ifnull(paid_rate,0)&&outspay_predate<outspay_paydate,outspay_paid,
if(outspay_paid_leiji>outs_amount*ifnull(paid_rate,0)&&outspay_predate<outspay_paydate&&outspay_paid_leiji-outs_amount*ifnull(paid_rate,0)<outspay_paid,outspay_paid-outspay_paid_leiji+outs_amount*ifnull(paid_rate,0),0)) outspay_qyfk
from (
select sum(outspay_paid)outspay_paid,outspay_amount,outspay_paydate,outspay_predate,key_id,paid_rate,outspay_paid_leiji,outs_amount 
from 
(select outspay_id,outspay_outsource,outs_contract,outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1) outspay_paid,outspay_amount,outspay_paydate,outspay_predate,key_id,
/*****合同回款比例******
(select sum(ifnull(pay_paid,0))/sum(ifnull(ctr_amount,1)) from sale_payment left join sale_contract_info on ctr_id=pay_contract
join project_contract_link on ctrlink_contract=ctr_id 
where ctrlink_key=project_opportunity1.key_id and pay_enddate<main.outspay_paydate)*/ ifnull(js_ctr_paid_rate,0) paid_rate,
/*****截止当天累计外包付款***
(select sum(outspay_paid) from (select outspay_id,outspay_outsource,outspay_paid*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1) outspay_paid,ifnull(outs_amount,app_amount)outs_amount,outspay_paydate,ctrlink_key 
from sale_outsource_payment
left join sale_outsource_apply on outspay_appid=app_numid
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
where (d_outs_type="实施" or ifnull(outs_contract,"")="" and app_type=0)
group by outspay_id)list
where ctrlink_key=project_opportunity1.key_id and outspay_paydate<=main.outspay_paydate)*/ ifnull(js_outspaid_leiji,0) outspay_paid_leiji,
/*************外包金额**************
(select sum(outs_amount) from (select outspay_outsource,ifnull(outs_amount*ifnull(d_outstype_amount,1)/ifnull(d_outs_amount,1),app_amount)outs_amount,ctrlink_key 
from sale_outsource_payment
left join sale_outsource_apply on outspay_appid=app_numid
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id
where (d_outs_type="实施" or ifnull(outs_contract,"")="" and app_type=0)
group by outspay_outsource,app_numid)list
where ctrlink_key=project_opportunity1.key_id )*/ifnull(js_outs_amount,0) outs_amount
from (select * from sale_outsource_payment where year(outspay_paydate)="${year}")main
left join project_outspay_js on js_oustpay=outspay_id
join sale_outsource_apply on outspay_appid=app_numid and app_contracttype="项目整包合同"
left join sale_outsource on outs_id=outspay_outsource
join project_contract_link on outs_contract=ctrlink_contract or app_project=ctrlink_key
left join v_outsource_detail on d_outs_id=outs_id 
left join project_opportunity1 on ctrlink_key=key_id
left join hr_department_team on team_id=prj_team
left join cust_company on com_id=customer_id
left join hr_user_tags on tag_username=outspay_salesman
left join hr_tags on tags_id=tag_region_id
where d_outs_type="实施" 
${if(len(pm)=0,"","and projectmanager in ('"+pm+"')")}
${if(len(teamid)=0,"","and team_id in ('"+teamid+"')")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(region)=0,"","and if(com_salesman='aaron'&&com_country='中国','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and com_salesman in ('"+salesman+"')")}
group by outspay_id)list
group by outspay_paydate,key_id
)list

select 1 as month,450 as goal
union
select 2 as month,694 as goal
union
select 3 as month,1470 as goal
union
select 4 as month,1970 as goal
union
select 5 as month,2823 as goal
union
select 6 as month,3682 as goal
union
select 7 as month,4541 as goal
union
select 8 as month,5400 as goal
union
select 9 as month,6259 as goal
union
select 10 as month,7865 as goal
union
select 11 as month,8931 as goal
union
select 12 as month,10641 as goal


select 1 as month,450 as goal
union
select 2 as month,244 as goal
union
select 3 as month,776 as goal
union
select 4 as month,500 as goal
union
select 5 as month,853 as goal
union
select 6 as month,859 as goal
union
select 7 as month,859 as goal
union
select 8 as month,859 as goal
union
select 9 as month,859 as goal
union
select 10 as month,1606 as goal
union
select 11 as month,1066 as goal
union
select 12 as month,1710 as goal

SELECT sum(amount*det_paid_g/det_paid) '商务费用',year(happenday) year,month(happenday) '月份',"fd" FROM finan_expense
LEFT JOIN (
select month(pay_enddate) month,year(pay_enddate) year,
sum(ifnull(pay_paid,0)*IFNULL(det_amount,0)/ctr_amount*f_amount) det_paid
from v_contract_detail
left join sale_payment ON pay_contract = det_contract
LEFT JOIN sale_contract_info ON pay_contract = ctr_id
left join cust_company on com_id=ctr_company
left join finan_other_statistics on f_type=pay_currency and f_remark="CNY"
where  pay_verified = 'valid' 
group by year,month
)a on a.year=year(happenday) and a.month=month(happenday) 
left join (
select month(pay_enddate) month,year(pay_enddate) year,
sum(ifnull(pay_paid,0)*IFNULL(det_amount,0)/ctr_amount*f_amount) det_paid_g
from v_contract_detail  join project_contract_link on det_contract = ctrlink_contract
left join sale_payment ON pay_contract = det_contract
LEFT JOIN sale_contract_info ON pay_contract = ctr_id
left join cust_company on com_id=ctr_company
left join finan_other_statistics on f_type=pay_currency and f_remark="CNY"
where  pay_verified = 'valid' 
and det_type='实施' 
group by year,month)b on b.year=year(happenday) and b.month=month(happenday)
left join hr_user_tags on tag_username=causer
left join hr_tags on tags_id=tag_region_id
where subject=11 and year(happenday) ="${year}"
${if(len(pm)=0,"","and 1=2")}
${if(len(teamid)=0,"","and 1=2")}
${if(len(com)=0,"","and com_name like '%"+com+"%'")}
${if(len(region)=0,"","and if(causer='aaron','上海',tags_name) in ('"+region+"')")}
${if(len(salesman)=0,"","and causer in ('"+salesman+"')")}
group by year(happenday),month(happenday)

select sum(ifnull(outs_paid,0)) "外包付款",yearouts "年份", monouts "月份" from 
(select sum(IFNULL(outspay_paid,0)*IFNULL(outs_prj_amount,0)/outs_amount) outs_paid,outs_contract,year(outspay_paydate) yearouts,month(outspay_paydate) monouts  
from sale_outsource_payment 
join (
select outs_id,outs_contract,sum(d_outstype_amount)outs_prj_amount,outs_amount 
from v_outsource_detail
left join sale_outsource on d_outs_id=outs_id
where  d_outs_type="实施"
group by outs_id,outs_contract
)outs on outs_id=outspay_outsource
join project_contract_link d on outs_contract = d.ctrlink_contract
where year(outspay_paydate)='2019'
group by  yearouts,monouts)main group by yearouts,monouts


