SELECT share_presales
,sum(ifnull(share_amount,0))amount
,concat(cast(count(*)as char),'篇')knowc 
FROM `kpi_pre_knowledge_share`
where share_ym =DATE_FORMAT(curdate(),'%Y-%m') 
and share_verified ='valid'
and share_presales='${pres}'
group by share_presales

select pres_name,min(opp)xs,concat('共',c,'个','，成功',cs,'个，失败',cf,'个')detail from(select pres_name,pres_parent,px,case when day(curdate())<=15 then ifnull(op1.c,0)/ifnull(op2.c,1) else ifnull(op3.c,0)/ifnull(op4.c,1) end opp from 
(SELECT p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,'',pres_parent)parent
,if(pres_name=pres_parent,'一级售前','二级售前')duty
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and (user_state='在职' )
and area_id<=10
ORDER BY area_id,px,pres_name)hr
left join(
/*本月之前机会跟进记录*/
select opp_presales,count(distinct try_opportunity)c from sale_trial
left join sale_opportunity on try_opportunity=opp_id
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where  opp_verified = 'valid' and opp_status in ('初期沟通','售前演示','客户选定','商务谈判')
and opp_recdate between '2017-07-01' and DATE_ADD(DATE_ADD(curdate(),interval -day(curdate())+1 day),INTERVAL -1 day)
and try_recdate BETWEEN DATE_ADD(curdate(),interval -day(curdate())+1 day) and DATE_ADD(curdate(),interval -day(curdate())+15 day)
and nm_state is null
#and opp_presales='${pres}'
GROUP BY opp_presales)op1 on hr.pres_name=op1.opp_presales
left join
(
/*所有本月之前进行中的机会*/
select opp_presales,count(*)c from sale_opportunity 
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where opp_verified = 'valid'and opp_status in ('初期沟通','售前演示','客户选定','商务谈判')
and opp_recdate between '2017-07-01' and DATE_ADD(DATE_ADD(curdate(),interval -day(curdate())+1 day),INTERVAL -1 day)
and nm_state is null 
GROUP BY opp_presales)op2 on hr.pres_name= op2.opp_presales
left join
(
select opp_presales,count(distinct try_opportunity)c from sale_trial
left join sale_opportunity on try_opportunity=opp_id
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where  opp_verified = 'valid' and opp_status in ('初期沟通','售前演示','客户选定','商务谈判')
and opp_recdate between '2017-07-01' and DATE_ADD(curdate(),interval -day(curdate())+15 day) 
and try_recdate BETWEEN DATE_ADD(curdate(),interval -day(curdate())+15 day) and LAST_DAY(DATE_ADD(curdate(),interval -day(curdate())+15 day))
and opp_id in 
(
	select distinct try_opportunity as oppid from sale_trial
	where try_recdate BETWEEN DATE_ADD(curdate(),interval -day(curdate())+1 day) and DATE_ADD(curdate(),interval -day(curdate())+15 day)
	union
	select opp_id as oppid from sale_opportunity 
	where opp_recdate BETWEEN DATE_ADD(curdate(),interval -day(curdate())+1 day) and DATE_ADD(curdate(),interval -day(curdate())+15 day)
)
and nm_state is null
GROUP BY opp_presales)op3 on  hr.pres_name= op3.opp_presales
left join
(
/*所有本月15号之前进行中的机会*/
select opp_presales,count(*)c from sale_opportunity 
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where opp_verified = 'valid'and opp_status in ('初期沟通','售前演示','客户选定','商务谈判')
and opp_recdate between '2017-07-01' and DATE_ADD(curdate(),interval -day(curdate())+15 day) 
and nm_state is null 
GROUP BY opp_presales)op4 on  hr.pres_name= op4.opp_presales
union all
select pres_name,pres_parent,px,case when ifnull(op6.c,0)=0 then 1 else if(ifnull(op6.c,0)>ifnull(op5.c,0),(ifnull(op6.c,0)-ifnull(op5.c,0))/ifnull(op6.c,1),0) end opp from 
(SELECT p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,'',pres_parent)parent
,if(pres_name=pres_parent,'一级售前','二级售前')duty
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and (user_state='在职' )
and area_id<=10
ORDER BY area_id,px,pres_name)hr
left join
(
select opp_presales,count(*)c from sale_opportunity
left join sale_value on opp_id= val_opportunity
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where opp_verified = 'valid'
and ifnull(val_summary,'') =''
and opp_enddate between '2018-01-01' and DATE_ADD(curdate(),interval -day(curdate())+15 day) 
and nm_state is null 
GROUP BY opp_presales)op5 on  hr.pres_name= op5.opp_presales
left join
(
/*上月16号到本月15号结束的机会*/
select opp_presales,count(*)c from sale_opportunity 
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where  opp_verified = 'valid'
and opp_enddate between date_sub(curdate()-day(curdate())+16,interval 1 month) and DATE_ADD(curdate(),interval -day(curdate())+15 day)
and nm_state is null
GROUP BY opp_presales)op6 on  hr.pres_name= op6.opp_presales)taball
left join
(select opp_presales p,count(*)c,sum(if(opp_status in ('合同签约','协议签约','变更签约'),1,0))cs,sum(if(opp_status ='跟进失败',1,0))cf from sale_opportunity 
LEFT JOIN pre_opp_maintenance nm on nm_opp=opp_id and nm_state=0
where opp_verified = 'valid'
and year(opp_recdate)=year(curdate())
and nm_state is null 
GROUP BY opp_presales)tabb on pres_name=p
where pres_name='${pres}' or pres_parent='${pres}'


select * from (select TABA.*,
concat('第',if(@s=TABA.df,@rank:=@rank,@rank:=@rank+1),'名')
as rank,
@s:=TABA.df

from(
SELECT user_username as pres_name,SUM(ifnull(task_score,time_ranges*ifnull(score,0)))df
FROM (
	SELECT user_username,task_id,task_score,task_action,task_predate
	,task_time_range,(task_time_range regexp '上午') + (task_time_range regexp '下午')time_ranges,score
	,case when task_action in('演示','调研','方案')then 2 when task_action in('培训','服务')then 1 else 0 end score2
	FROM `cust_task` 
	left join cust_trace on task_company=trace_company and task_id=trace_task
	join cust_company on com_id =task_company 
	left join commercial_act_dict on task_action = type2
	join 
	(
		SELECT user_username FROM hr_area 
		join hr_presales p on pres_parent = area_presales
		join hr_user on user_username = pres_name
		where (user_state='在职' or (user_state='离职' and left(user_leavedate,7) = left(curdate(),7)))
		and area_id<=10
	)presales 
	on FIND_IN_SET(user_username,task_actor)
	where task_status in ('结束','完成')
	and year(task_predate)=year(curdate()) 
and month(task_predate)=month(curdate())	
	GROUP BY user_username,task_id
)SC GROUP BY user_username
order by df desc
)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where pres_name='${pres}'


SELECT concat('上月：',cast(round(work,0) as char))detail FROM `presales_kpi`
where month =DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 month),'%Y%m')
and presales='${pres}'


${if(len(pres)=0 ||pres ="simon" || pres ="tony" ,"select 0 as pres_name,sum(s) s,'' as rank from (","")}
select * from (select TABA.*,
if(s>0,concat('第',if(@s=TABA.s,@rank:=@rank,@rank:=@rank+1),'名'),'')as rank
from(select region,r,ifnull(s,0)s from 
(select distinct pres_region region ,T.*from hr_presales left join
(select apply_creator user,pres_region r,ifnull(count(*),0) s from biaogan_apply
join hr_presales on pres_name=apply_creator
where year(apply_createtime)>=${year}
and apply_status=1
group by pres_region
order by count(*) desc)T on pres_region=r )T1
order by s desc
)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where 1=1
${if(len(pres)=0 ||pres="simon"|| pres ="tony","","and TABC.region=(select distinct pres_region from hr_presales where pres_name='"+pres+"')")}
${if(len(pres)=0 ||pres="simon"|| pres ="tony",")xiao","")}


${if(len(pres)=0 ||pres ="simon" || pres ="tony" ,"select 0 as pres_name,sum(c) c,'' as rank from (","")}
select * from (select TABA.*,
if(c>0,concat('第',if(@s=TABA.c,@rank:=@rank,@rank:=@rank+1),'名'),'')as rank
from(SELECT pres_region region,r,ifnull(c,0)c
from (select distinct pres_region from hr_presales)aaa
left join 
(select com_sales_region as r,count(*)as c from(SELECT comm_company,comm_opp,com_sales_region FROM cust_event_comment 
join dict_tags on tags_code=comm_event and tags_name regexp '${year}'
join cust_company on com_id=comm_company
LEFT JOIN cust_benchmark on comm_company=bm_company 
where comm_opp is not null and ifnull(comm_verified,'invalid')='valid' group by comm_opp)li
group by  com_sales_region)aa on pres_region=r
order by c desc)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where 1=1 
${if(len(pres)=0 ||pres="simon"|| pres ="tony","","and TABC.region=(select distinct pres_region from hr_presales where pres_name='"+pres+"')")}
${if(len(pres)=0 ||pres="simon"|| pres ="tony",")xiao","")}


${if(len(pres)=0 ||pres ="simon" || pres ="tony" ,"select 0 as pres_name,sum(s) s,'' as rank from (","")}
select * from (select TABA.*,
if(s>0,concat('第',if(@s=TABA.s,@rank:=@rank,@rank:=@rank+1),'名'),'') as rank
from(SELECT pres_name,sum(amount)/10000 s FROM(
select s.pres_name,sum(amount)amount
FROM
(select distinct pres_name from hr_presales,hr_user where pres_name=user_username and user_state='在职') AS s 
left join (select opp_presales,sum(amount)amount  from
(SELECT 
distinct ctr_id
,opp_presales
,if(det_type in('实施','服务','咨询'),det_type,if(det_type='产品',if(det_productline='FineBI','FBI','FR'),'其他'))type
,sum(det_amount*f_amount) as amount
from (select ctr_id,sum(det_amount)det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM (
SELECT ctr_id,sum(ifnull(det_amount,0))det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract
where year(ctr_signdate)=${year}
${if(year<=2017,"and ctr_status not in ('待审核','待录入','不合格')",
"and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))")}
group by ctr_id,det_type,det_productline
union#已作废合同
select ctr_id,-sum(ifnull(det_amount,0))amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${year} and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline
union#未作废合同中作废的回款
select ctr_id,-sum(ifnull(pay_bill,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and year(ifnull(pay_voiddate,ctr_signdate))=${year} and pay_status in ("记坏账","已作废") and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline
union#已作废合同中已回款的部分
select ctr_id,sum(ifnull(pay_paid,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=pay_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${year} and ifnull(pay_paid,0)>0 and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline
)l
group by ctr_id,det_type,det_productline)ctr
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
join cust_company on com_country='中国' and com_id=ctr_company
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(ctr_currency,'CNY') 
group by ctr_id,type
having type in ('FBI','实施')
)list1
group by opp_presales
union all
select ifnull(opp_presales,'无')presales,-sum(outs_amount)det_outstype_amount
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join cust_company on com_id=ctr_company 
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
where year(outs_recdate)='${year}' and com_country="中国"
and outs_status!="已作废"
group by presales

)ctr on opp_presales=pres_name
group by pres_name
)alla
group by pres_name
order by sum(amount) desc)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where 1=1 
${if(len(pres)=0 ||pres="simon"|| pres ="tony","","and pres_name='"+pres+"'")}
${if(len(pres)=0 ||pres="simon"|| pres ="tony",")xiao","")}


select concat(cast(count(*)as char),'类')as type,group_concat(failed_c)detail
from(select concat(ifnull(val_result,'无'),cast(count(*)as char),'次')failed_c from sale_opportunity
left join pre_opp_maintenance on opp_id=nm_opp and nm_state=0
left join sale_value on val_opportunity=opp_id 
where opp_status='跟进失败'
and opp_verified='valid'
and nm_state is null
and ifnull(val_result,'无') in ('项目搁置','丢给对手','无')
and year(opp_recdate )=${year}
${if(len(pres)=0 ||pres="simon"|| pres ="tony","","and opp_presales='"+pres+"'")}

group by val_result)a


${if(len(pres)=0 ||pres ="simon" || pres ="tony" ,"select 0 as pres_name,sum(s) s,'' as rank from (","")}
select * from (select TABA.*,
if(s>0,concat('第',if(@s=TABA.s,@rank:=@rank,@rank:=@rank+1),'名'),'') as rank
from(
select pres_region,sum(amount)s 
from(select opp_id,pres_region,sum(ctr_amount)/10000 amount 
from (
	SELECT opp.* 
	,min(if(opp_enddate>=task_predate,DATEDIFF(opp_enddate,task_predate),null))before_days 
	,min(if(task_predate>=opp_enddate,DATEDIFF(task_predate,opp_enddate),null))after_days
	from sale_opportunity opp
	left join(	
		select task_company,task_actor,task_predate from cust_task join hr_presales on FIND_IN_SET(pres_name,task_actor) 	where task_status <>'取消' 			
	)pre_task on opp_company = task_company   
	where opp_verified='valid' and year(opp_enddate) = ${year} and opp_status regexp'签约'
	GROUP BY opp_id
	having ( before_days is null or before_days>100) and (after_days is null or after_days>100)
)opps
join v_sale_contract_info_valid on opp_sign = sign_id
join (select DISTINCT pres_name,pres_region from hr_presales)hr_presales on opp_presales = pres_name
GROUP BY opp_id)aaa
group by pres_region
order by s desc)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where 1=1
${if(len(pres)=0 ||pres="simon"|| pres ="tony",""," and pres_region in(select pres_region from hr_presales where pres_name='"+pres+"')")}
${if(len(pres)=0 ||pres="simon"|| pres ="tony",")xiao","")}



${if(len(pres)=0 ||pres ="simon" || pres ="tony" ,"select 0 as pres_name,sum(s) s,'' as rank from (","")}
select *from (select TABA.*,
if(s>0,concat('第',if(@s=TABA.s,@rank:=@rank,@rank:=@rank+1),'名'),'') as rank
from(SELECT pres_name,sum(amount)/10000 s 

FROM
(select distinct pres_name from hr_presales,hr_user where pres_name=user_username and user_state='在职') AS s
left join
(select opp_presales,sum(amount)amount  from
(SELECT 
distinct ctr_id
,opp_presales
,if(det_type in('实施','服务','咨询'),det_type,if(det_type='产品',if(det_productline='FineBI','FBI','FR'),'其他'))type
,sum(det_amount*f_amount) as amount
from 
(select ctr_id,sum(det_amount)det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM (
SELECT ctr_id,sum(ifnull(det_amount,0))det_amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract
where year(ctr_signdate)=${year}
${if(year<=2017,"and ctr_status not in ('待审核','待录入','不合格')",
"and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))")}
group by ctr_id,det_type,det_productline
union#已作废合同
select ctr_id,-sum(ifnull(det_amount,0))amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
FROM v_contract_detail
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${year} and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline
union#未作废合同中作废的回款
select ctr_id,-sum(ifnull(pay_bill,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=det_contract
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and year(ifnull(pay_voiddate,ctr_signdate))=${year} and pay_status in ("记坏账","已作废") and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline
union#已作废合同中已回款的部分
select ctr_id,sum(ifnull(pay_paid,0)*IFNULL(det_amount,0)/ctr_amount) amount,ctr_currency,det_productline,det_type,ctr_company,ctr_agreement,ctr_role
from sale_payment
left join v_contract_detail on pay_contract=det_contract
left join sale_contract_info on ctr_id=pay_contract
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ifnull(ctr_voiddate,ctr_signdate))=${year} and ifnull(pay_paid,0)>0 and year(ctr_signdate)=${year}
group by ctr_id,det_type,det_productline

)l
group by ctr_id,det_type,det_productline)ctr
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
join cust_company on com_country='中国' and com_id=ctr_company
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(ctr_currency,'CNY') 
group by ctr_id,type
)list1
group by opp_presales
union all
select ifnull(opp_presales,'无')presales,-sum(outs_amount)det_outstype_amount
from sale_outsource
join v_sale_contract_info_valid on outs_contract=ctr_id
left join cust_company on com_id=ctr_company 
#left JOIN sale_opportunity ON ctr_id=opp_sign
LEFT JOIN sale_role ON ctr_role=role_id
LEFT JOIN sale_opportunity  ON role_opportunity =opp_id
where year(outs_recdate)='${year}' and com_country="中国"
and outs_status!="已作废"
group by presales
)alla on pres_name=opp_presales
group by pres_name
order by sum(amount) desc)TABA
,(select @rownum:=0,@rank:=0,@ranknum:=0,@s:=0)TABB)TABC
where 1=1 
${if(len(pres)=0 ||pres="simon"|| pres ="tony","","and pres_name='"+pres+"'")}
${if(len(pres)=0 ||pres="simon"|| pres ="tony",")xiao","")}


select concat("我的职级管理",l_level)levels,l_id,l_name,l_value,case when l_id in (3,4,5,6,7,8) then 1 when l_id in (9,10,11,12) then 2 else 3 end l_type
from hr_user
left join (
select l_level,1 as l_id,'执行力' as l_name ,l_execution as l_value
from presales_level
union
select l_level,2 ,'团队协作能力',l_teamwork
from presales_level
union
select l_level,3 ,'软件产品知识',l_software_pro
from presales_level
union
select l_level,4 ,'软件新技术',l_software_tech
from presales_level
union
select l_level,5 ,'行业业务知识',l_industry_bus
from presales_level
union
select l_level,6 ,'销售方法',l_sale_method
from presales_level
union
select l_level,7 ,'企业管理知识',l_bus_manage
from presales_level
union
select l_level,8 ,'咨询知识',l_consult
from presales_level
union
select l_level,9 ,'方案演讲制作能力',l_progarm_speech
from presales_level
union
select l_level,10 ,'POC、标书制作能力',l_POC_bid
from presales_level
union
select l_level,11 ,'需求调研、分析能力',l_demand_analy
from presales_level
union
select l_level,12 ,'活动组织能力',l_event_organize
from presales_level
union
select l_level,13 ,'方法论建设',l_methodology
from presales_level
union
select l_level,14 ,'知识传承',l_knowledge
from presales_level
union
select l_level,15 ,'人才培养',l_talent
from presales_level
)lev on user_level=l_level
where  user_username='${pres}'
order by field(l_id,3,4,5,6,7,8,9,10,11,12,1,2,13,14,15)


select * from (select pres_name,pres_region,px,df from (select *,if(average>0,average*800*c/ summ,0)df from(select *,avg(s)average 
from(
SELECT year,month,pres_name,pres_parent,pres_region,px,ifnull(sum(ifnull(task_score,time_ranges*ifnull(score,0))),0)s
from
(SELECT year(now()) year,month(now()) month,p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and user_state='在职' 
and area_id<=10)hr
left join (
	SELECT year(task_predate ) year1,month( task_predate ) month1,task_actor,task_id,task_score,task_action,task_predate
	,task_time_range,(task_time_range regexp '上午') + (task_time_range regexp '下午')time_ranges,score
	,case when task_action in('演示','调研','方案')then 2 when task_action in('培训','服务')then 1 else 0 end score2
	FROM 
`cust_task` 
	left join cust_trace on task_company=trace_company and task_id=trace_task
	join cust_company on com_id =task_company 
	left join commercial_act_dict on task_action = type2
	where task_status in ('结束','完成')
	and year(task_predate )=year(now()) and (month( task_predate )=month(now()))
	GROUP BY task_actor,task_id
)SC on FIND_IN_SET(pres_name,task_actor) and year=year1 and month=month1
GROUP BY pres_name,year,month
order by pres_region,px)aa 
	group by pres_region
	order by pres_region,px)bb
cross join 
(select count(distinct pres_region)c,sum(average)summ from(select *,avg(s)average from(
SELECT year,month,pres_name,pres_parent,pres_region,px,ifnull(sum(ifnull(task_score,time_ranges*ifnull(score,0))),0)s
from
(SELECT year(now()) year,month(now()) month,p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and user_state='在职'
and area_id<=10)hr
left join (
	SELECT year(task_predate ) year1,month( task_predate ) month1,task_actor,task_id,task_score,task_action,task_predate
	,task_time_range,(task_time_range regexp '上午') + (task_time_range regexp '下午')time_ranges,score
	,case when task_action in('演示','调研','方案')then 2 when task_action in('培训','服务')then 1 else 0 end score2
	FROM 
`cust_task` 
	left join cust_trace on task_company=trace_company and task_id=trace_task
	join cust_company on com_id =task_company 
	left join commercial_act_dict on task_action = type2
	where task_status in ('结束','完成')
	and year(task_predate )=year(now()) and (month( task_predate )=month(now()))
	GROUP BY task_actor,task_id
)SC on FIND_IN_SET(pres_name,task_actor) and year=year1 and month=month1
GROUP BY pres_name,year,month
order by pres_region,px
)aa 
	group by pres_region)su
)sum)t1
union
select pres_name,pres_region,px,df from
(select * ,if(summ>0,(s*c*800/summ ),0)df 
from(
SELECT year,month,pres_name,pres_parent,pres_region,px,ifnull(sum(ifnull(task_score,time_ranges*ifnull(score,0))),0)s,''
from
(SELECT year(now()) year,month(now()) month,p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and user_state='在职' 
and area_id<=10)hr
left join (
	SELECT year(task_predate ) year1,month( task_predate ) month1,task_actor,task_id,task_score,task_action,task_predate
	,task_time_range,(task_time_range regexp '上午') + (task_time_range regexp '下午')time_ranges,score
	,case when task_action in('演示','调研','方案')then 2 when task_action in('培训','服务')then 1 else 0 end score2
	FROM 
`cust_task` 
	left join cust_trace on task_company=trace_company and task_id=trace_task
	join cust_company on com_id =task_company 
	left join commercial_act_dict on task_action = type2
	where task_status in ('结束','完成')
	and year(task_predate )=year(now()) and (month( task_predate )=month(now()))
	GROUP BY task_actor,task_id
)SC on FIND_IN_SET(pres_name,task_actor) and year=year1 and month=month1
GROUP BY pres_name,year,month
order by pres_region,px)aa
cross JOIN
(select count(distinct pres_name)c,sum(s)summ
from(
SELECT year,month,pres_name,pres_parent,pres_region,px,ifnull(sum(ifnull(task_score,time_ranges*ifnull(score,0))),0)s
from
(SELECT year(now()) year,month(now()) month,p.*,user_name,user_state,num_start_ym
,if(pres_name=pres_parent,0,1)px 
FROM hr_area 
join hr_presales p on pres_parent = area_presales
join hr_user on user_username = pres_name
left join presales_kpi_number on pres_name = num_presales
where (pres_name=pres_parent or num_start_ym <= DATE_FORMAT(curdate(),'%Y-%m'))
and user_state='在职' 
and area_id<=10)hr
left join (
	SELECT year(task_predate ) year1,month( task_predate ) month1,task_actor,task_id,task_score,task_action,task_predate
	,task_time_range,(task_time_range regexp '上午') + (task_time_range regexp '下午')time_ranges,score
	,case when task_action in('演示','调研','方案')then 2 when task_action in('培训','服务')then 1 else 0 end score2
	FROM 
`cust_task` 
	left join cust_trace on task_company=trace_company and task_id=trace_task
	join cust_company on com_id =task_company 
	left join commercial_act_dict on task_action = type2
	where task_status in ('结束','完成')
	and year(task_predate )=year(now()) and (month( task_predate )=month(now()))
	GROUP BY task_actor,task_id
)SC on FIND_IN_SET(pres_name,task_actor) and year=year1 and month=month1
GROUP BY pres_name,year,month
order by pres_region,px
)aa )sum
where px=1
)t2)taal
where pres_name='${pres}'


select distinct concat(RIGHT(eva_year,2),'年','-',replace(replace(replace(replace(eva_jd,1,'一季度'),2,'二季度'),3,'三季度'),4,'四季度'),' 【',eva_value,'】')jd,eva_detail,eva_value,eva_year,eva_jd
from pres_evaluate_list
where eva_pres_name='${pres}' 
order by eva_year desc ,eva_jd desc 
limit 4

