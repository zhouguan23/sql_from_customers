select distinct concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region
from hr_salesman 
left join support_success_customer on find_in_set(sales_name,success_salesman)
where sales_region in ("北京","上海","南京","成都","杭州","武汉","沈阳","济南","深圳","西安")
order by sales_region


select * from(select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,
success_user,year(ctr_signdate)y,c.com_id,c.com_type,year(sev_enddate)dy,c.com_name,v_sale_contract_info_valid.*,c.com_verified
from v_sale_contract_info_valid
inner JOIN cust_company c ON ctr_company=c.com_id
left join hr_user a on a.user_username=ctr_salesman
left join hr_user b on b.user_username=ctr_presales
inner join(select sev_contract,sev_enddate from sale_contract_of_service group by sev_contract)sev on sev.sev_contract=ctr_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
)m
where ctr_status not in ("已作废","不合格", "待审核","待录入") 
and com_type in ("最终用户")
and ctr_currency in ("CNY")
and region is not null
and dy is not null
and ctr_signdate is not null
and com_verified = "valid"
and region='${region}'
and dy<='2020'
and y<'2020'
and com_id not in (select score_company from support_label_score where score_index=26)
group by com_id
order by y desc,region

select * from xufei_cust_aim where year='${year}'

select region,season,sum(total_num) from (select t2.region,t2.month,t2.season,(ifnull(num,0)-ifnull(d_num,0))total_num from (select region,month(ctr_signdate)month,if(month(ctr_signdate)<=3,"S1",if(month(ctr_signdate)<=6,"S2",if(month(ctr_signdate)<=9,"S3","S4")))season,count(*)num
from (select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' and year(ctr_signdate)=2020/* and sev_years%1<>0 是否需要限制维保期条件*/
group by ctr_id/*2020年的续费个数*/
union
select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' 
and ((year(ctr_signdate)=2019 and sev_years=2) or (year(ctr_signdate)=2018 and sev_years=3))
group by ctr_id/*2019、2018年分别签了2年、3年的续费个数*/
union
select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' 
and ((year(ctr_signdate)=2020 and sev_years_rewrite=1 and sev_years%1<>0) or (year(ctr_signdate)=2019 and sev_years_rewrite=2 and sev_years%1<>0) or (year(ctr_signdate)=2018 and sev_years_rewrite=3 and sev_years%1<>0))
group by ctr_id)t1
group by region,month(ctr_signdate))t2
left join 

(select region,month(ctr_signdate)month,count(*)d_num from (select * from (select part5.*,left(ctr_signdate,7)month,round(count(id)/12,2)zixun_num  from (select part3.*,count(task_id)genjin_num from (

select * from (select part1.*,if(opp_name is not null,"有","无")jihui from (select concat(ifnull(sales_region,""),'-',ifnull(success_user,"")) region,ctr_signdate,com_salesman,c.com_id,c.com_name,type
from v_sale_contract_info_valid
inner JOIN cust_company c ON ctr_company=c.com_id
join sale_contract_of_service on sev_contract=ctr_id
left join success_nianxing_xufei on nx_com_id=c.com_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格", "待审核","待录入") 
and ctr_currency in ("CNY")
/*and com_sales_region is not null*/
and sev_type="续服务"
and year(ctr_signdate) is not null
and com_verified = "valid"
and com_type in ("最终用户")
and year(ctr_signdate) =2020
)part1
left join /*续费机会是无的*/
(
select com_id,opp1.* from 
cust_company 
	LEFT JOIN (SELECT opp_support,opp_id,opp_com,opp_name,opp_create,opp_status,opp_label,genjin_date,writetime
FROM
	( SELECT * FROM support_opportunity LEFT JOIN dict_type ON find_in_set( type_id, opp_label )  ) a 
	) opp1 ON opp1.opp_com = com_id
where  com_verified = 'valid' and length(opp_status) > 0 and opp_name is not null and opp_name<>''
GROUP BY
	com_id,
	opp_name, 
	genjin_date,
	writetime	
)part2
on   part2.opp_create>= date_sub(ctr_signdate,interval 1 year)
and  part2.opp_create<= part1.ctr_signdate
and part2.com_id=part1.com_id
order by opp_name desc)part2_1
group by com_id,ctr_signdate

)part3
left join 

(select * from(select  
review_id task_id,review_company task_company,review_date task_date,if(review_genjin_label is null,"无",review_genjin_label) task_genjin_label
from cust_review
union 
select
sum_id task_id,sum_company task_company,sum_date task_date,if(sum_genjin_label is null,"无",sum_genjin_label) task_genjin_label
FROM cust_sum) A 
where task_genjin_label not regexp '7'/*无效记录标签*/
group by task_id
)part4
on part3.com_id=part4.task_company
and part4.task_date >= date_sub(part3.ctr_signdate,interval 4 month)
and part4.task_date <= date_sub(part3.ctr_signdate,interval -2 month)
where jihui='无' or type='无服务粘性续费'
group by part3.com_id,part3.ctr_signdate
)part5


left join
(
select gp_date date,gp_com com_id,gp_id id
from group_support_problem 
where gp_date>='2019-07-01' 
union
select date(createdate),company,BUG_ID
from fr_t_system1
where (bugkind="客户BUG" or bugkind="BI客户BUG" or jira_keys like "PT%" or BUGKIND="客户需求")
and date(createdate)>='2019-07-01' 

union
select ptime,com_id,id from(select a.id,com_id,service_number,sup_name,support_group,tag,tag2,ptime
from(
SELECT r.*,date(r.push_time) ptime,com_id,
num.sup_name,if(support_group1 is not null,support_group1,if(support_group2 is not null,support_group2,null))support_group from
(SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, "single",cont_company,cont_name from service_satisfaction_evaluation force index(index_pushtime)
join  cust_contact on (im=cont_qq) and cont_verified='valid'
where 1=1 and push_time>='2019-07-01' 
union
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, "single", cont_company,cont_name from service_satisfaction_evaluation force index(index_pushtime)
join  cust_contact on (im=cont_mobile) and cont_verified='valid'
 where push_time>='2019-07-01' 
union
select list.*, cont_company,cont_name from (
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, way_contact from service_satisfaction_evaluation force index(index_pushtime)
join cust_contact_way on way_type = 'mobile' and way_verified = 'valid' and way_entity = IM
 where push_time>='2019-07-01' 
) as list
join cust_contact on cont_way_mark = 1 and cont_verified = 'valid' and cont_id = way_contact
union
select list.*, cont_company,cont_name  from (
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2,way_contact from service_satisfaction_evaluation force index(index_pushtime)
join cust_contact_way on way_type = 'qq' and way_verified = 'valid' and way_entity = IM
where push_time>='2019-07-01' 
) as list
join cust_contact on cont_way_mark = 1 and cont_verified = 'valid' and cont_id = way_contact
)r 
LEFT JOIN cust_company on cont_company=com_id and com_verified='valid'
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id
LEFT JOIN (select DISTINCT dialogue_ID,solution_dialogue id from service_satisfaction_evaluation where solution_dialogue is not null)red on r.id = red.id
LEFT JOIN support_company_bind ON sup_company = com_id
left join (select * from support_servicenum_ship)num
on (num.service_number=r.service_number and date(startdate)<=date(r.push_time) and date(enddate)>=date(r.push_time))
left join (select support_name,support_group as support_group1,support_starttime,support_endtime from support_user_history)support1 
on (support1.support_name=num.sup_name and support1.support_starttime<=date(r.push_time) and support1.support_endtime>=date(r.push_time))
left join (select support_name,support_group as support_group2,support_starttime,support_endtime from support_user_history)support2
on (support2.support_name=r.service_number and support2.support_starttime<=date(r.push_time) and support2.support_endtime>=date(r.push_time))
group by id
)a
where cont_name is not null  
and support_group is not null 
and (tag in ('产品','方案','其他','其它','BI其它') or tag in ('产品','方案','其他','其它','BI其它')) 
order by support_group)q
)part6 	
on part5.com_id = part6.com_id and part6.date <= date_sub(part5.ctr_signdate,interval -6 month) and  part6.date >= date_sub(part5.ctr_signdate,interval 6 month)
group by part5.com_id,part5.ctr_signdate)total
where  (zixun_num<'1' and genjin_num<'5') 
or type='无服务粘性续费')total
group by region,month(ctr_signdate)


)t3 on t2.region =t3.region and t2.month=t3.month)total
group by region,season

select t2.region,t2.month,t2.season,(ifnull(num,0)-ifnull(d_num,0))total_num from (select region,month(ctr_signdate)month,if(month(ctr_signdate)<=3,"S1",if(month(ctr_signdate)<=6,"S2",if(month(ctr_signdate)<=9,"S3","S4")))season,count(*)num
from (select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' and year(ctr_signdate)=2020/* and sev_years%1<>0 是否需要限制维保期条件*/
group by ctr_id/*2020年的续费个数*/
union
select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' 
and ((year(ctr_signdate)=2019 and sev_years=2) or (year(ctr_signdate)=2018 and sev_years=3))
group by ctr_id/*2019、2018年分别签了2年、3年的续费个数*/
union
select concat(ifnull(sales_region,""),'-',ifnull(success_user,""))region,ctr_signdate,ctr_id
from v_sale_contract_info_valid
LEFT JOIN (select opp_sign,opp_id,opp_company from sale_opportunity where opp_sign is not null) opp on opp_sign=sign_id
LEFT JOIN cust_company_valid c ON if(opp_company='5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc',ctr_company,ifnull(opp_company,ctr_company))=c.com_id
inner join (select sev_id,sev_contract,sev_productline,sev_amount,sev_startdate,sev_enddate,sev_remark,sev_verified,sev_verifier,sev_verdate,sev_level,sev_type,case when sev_contract is not null then "技术支持服务" end contract_type
from sale_contract_of_service
union all
select main_id,main_contract,main_productline,main_amount,main_startdate,main_enddate,main_remark,main_verified,main_verifier,main_verdate,main_type,main_way,case when main_contract is not null then "运维" end contract_type
from sale_contract_of_maintain)sev_and_main on sev_and_main.sev_contract=ctr_id
left join sale_contract_of_service on sev_and_main.sev_id=sale_contract_of_service.sev_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格") and sev_and_main.sev_verified="valid" 
and com_verified = "valid"
and com_type in ("最终用户")
and ((c.com_salesman in (select distinct sales_name from (SELECT distinct sales_name FROM hr_salesman where sales_region in(select area_region from hr_area ))a)) or (c.com_salesman='public' and c.com_sales_region in (select area_region from hr_area)))
and (ifnull(sev_and_main.sev_amount,0)<>0  or 
(sev_and_main.sev_level='其他专项服务' and sev_isrear='是' and sev_days=5) or
(sev_and_main.sev_level in ('标准服务（铜牌）' , '银牌服务' ,'金牌服务') and
(sev_and_main.sev_type is null or sev_and_main.sev_type=''))) and sev_and_main.sev_type ='续服务' 
and ((year(ctr_signdate)=2020 and sev_years_rewrite=1 and sev_years%1<>0) or (year(ctr_signdate)=2019 and sev_years_rewrite=2 and sev_years%1<>0) or (year(ctr_signdate)=2018 and sev_years_rewrite=3 and sev_years%1<>0))
group by ctr_id)t1
group by region,month(ctr_signdate))t2
left join 

(select region,month(ctr_signdate)month,count(*)d_num from (select * from (select part5.*,left(ctr_signdate,7)month,round(count(id)/12,2)zixun_num  from (select part3.*,count(task_id)genjin_num from (

select * from (select part1.*,if(opp_name is not null,"有","无")jihui from (select concat(ifnull(sales_region,""),'-',ifnull(success_user,"")) region,ctr_signdate,com_salesman,c.com_id,c.com_name,type
from v_sale_contract_info_valid
inner JOIN cust_company c ON ctr_company=c.com_id
join sale_contract_of_service on sev_contract=ctr_id
left join success_nianxing_xufei on nx_com_id=c.com_id
left join support_success_customer on find_in_set(com_salesman,success_salesman) 
left join hr_salesman on com_salesman=sales_name
where ctr_status not in ("已作废","不合格", "待审核","待录入") 
and ctr_currency in ("CNY")
/*and com_sales_region is not null*/
and sev_type="续服务"
and year(ctr_signdate) is not null
and com_verified = "valid"
and com_type in ("最终用户")
and year(ctr_signdate) =2020
)part1
left join /*续费机会是无的*/
(
select com_id,opp1.* from 
cust_company 
	LEFT JOIN (SELECT opp_support,opp_id,opp_com,opp_name,opp_create,opp_status,opp_label,genjin_date,writetime
FROM
	( SELECT * FROM support_opportunity LEFT JOIN dict_type ON find_in_set( type_id, opp_label )  ) a 
	) opp1 ON opp1.opp_com = com_id
where  com_verified = 'valid' and length(opp_status) > 0 and opp_name is not null and opp_name<>''
GROUP BY
	com_id,
	opp_name, 
	genjin_date,
	writetime	
)part2
on   part2.opp_create>= date_sub(ctr_signdate,interval 1 year)
and  part2.opp_create<= part1.ctr_signdate
and part2.com_id=part1.com_id
order by opp_name desc)part2_1
group by com_id,ctr_signdate

)part3
left join 

(select * from(select  
review_id task_id,review_company task_company,review_date task_date,if(review_genjin_label is null,"无",review_genjin_label) task_genjin_label
from cust_review
union 
select
sum_id task_id,sum_company task_company,sum_date task_date,if(sum_genjin_label is null,"无",sum_genjin_label) task_genjin_label
FROM cust_sum) A 
where task_genjin_label not regexp '7'/*无效记录标签*/
group by task_id
)part4
on part3.com_id=part4.task_company
and part4.task_date >= date_sub(part3.ctr_signdate,interval 4 month)
and part4.task_date <= date_sub(part3.ctr_signdate,interval -2 month)
where jihui='无' or type='无服务粘性续费'
group by part3.com_id,part3.ctr_signdate
)part5


left join
(
select gp_date date,gp_com com_id,gp_id id
from group_support_problem 
where gp_date>='2019-07-01' 
union
select date(createdate),company,BUG_ID
from fr_t_system1
where (bugkind="客户BUG" or bugkind="BI客户BUG" or jira_keys like "PT%" or BUGKIND="客户需求")
and date(createdate)>='2019-07-01' 

union
select ptime,com_id,id from(select a.id,com_id,service_number,sup_name,support_group,tag,tag2,ptime
from(
SELECT r.*,date(r.push_time) ptime,com_id,
num.sup_name,if(support_group1 is not null,support_group1,if(support_group2 is not null,support_group2,null))support_group from
(SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, "single",cont_company,cont_name from service_satisfaction_evaluation force index(index_pushtime)
join  cust_contact on (im=cont_qq) and cont_verified='valid'
where 1=1 and push_time>='2019-07-01' 
union
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, "single", cont_company,cont_name from service_satisfaction_evaluation force index(index_pushtime)
join  cust_contact on (im=cont_mobile) and cont_verified='valid'
 where push_time>='2019-07-01' 
union
select list.*, cont_company,cont_name from (
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2, way_contact from service_satisfaction_evaluation force index(index_pushtime)
join cust_contact_way on way_type = 'mobile' and way_verified = 'valid' and way_entity = IM
 where push_time>='2019-07-01' 
) as list
join cust_contact on cont_way_mark = 1 and cont_verified = 'valid' and cont_id = way_contact
union
select list.*, cont_company,cont_name  from (
SELECT id,push_time,solution_dialogue,service_number,SUBSTRING_INDEX(tags,'-->',1)tag,SUBSTRING_INDEX(tags,'-->',-1)tag2,way_contact from service_satisfaction_evaluation force index(index_pushtime)
join cust_contact_way on way_type = 'qq' and way_verified = 'valid' and way_entity = IM
where push_time>='2019-07-01' 
) as list
join cust_contact on cont_way_mark = 1 and cont_verified = 'valid' and cont_id = way_contact
)r 
LEFT JOIN cust_company on cont_company=com_id and com_verified='valid'
LEFT JOIN v_service_satisfaction_evaluation r2 on r.solution_dialogue=r2.id
LEFT JOIN (select DISTINCT dialogue_ID,solution_dialogue id from service_satisfaction_evaluation where solution_dialogue is not null)red on r.id = red.id
LEFT JOIN support_company_bind ON sup_company = com_id
left join (select * from support_servicenum_ship)num
on (num.service_number=r.service_number and date(startdate)<=date(r.push_time) and date(enddate)>=date(r.push_time))
left join (select support_name,support_group as support_group1,support_starttime,support_endtime from support_user_history)support1 
on (support1.support_name=num.sup_name and support1.support_starttime<=date(r.push_time) and support1.support_endtime>=date(r.push_time))
left join (select support_name,support_group as support_group2,support_starttime,support_endtime from support_user_history)support2
on (support2.support_name=r.service_number and support2.support_starttime<=date(r.push_time) and support2.support_endtime>=date(r.push_time))
group by id
)a
where cont_name is not null  
and support_group is not null 
and (tag in ('产品','方案','其他','其它','BI其它') or tag in ('产品','方案','其他','其它','BI其它')) 
order by support_group)q
)part6 	
on part5.com_id = part6.com_id and part6.date <= date_sub(part5.ctr_signdate,interval -6 month) and  part6.date >= date_sub(part5.ctr_signdate,interval 6 month)
group by part5.com_id,part5.ctr_signdate)total
where  (zixun_num<'1' and genjin_num<'5') 
or type='无服务粘性续费')total
group by region,month(ctr_signdate)


)t3 on t2.region =t3.region and t2.month=t3.month

