SELECT distinct sales_name,(
/*每个销售取值*/
select if(count(swll_id)=0,"",concat(format(count(swll_id),0),'个不合格')) 
from kpi_i_result_detail_swll 
where swll_year ='${year}' 
and swll_month ='${month}' 
and swll_salesman=sales_name
and swll_verified='valid'
/*取值结束*/
) as unqualified 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
select if(count(jh_id)=0,"",concat(format(count(jh_id),0),'个不合格'))
from kpi_i_result_detail_jh
where jh_year ='${year}' 
and jh_month ='${month}' 
and jh_salesman=sales_name
and jh_verified='valid'
/*取值结束*/
) as unqualified 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
select if(count(rw_id)=0,"",concat(format(count(rw_id),0),'个不合格'))
from kpi_i_result_detail_rw
where rw_year ='${year}' 
and rw_month ='${month}' 
and rw_salesman=sales_name
and rw_verified='valid'
/*取值结束*/
) as unqualified 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

select  distinct sales_name,concat(if(quantity>=goal,0,goal-quantity),'个待提高') improvable from
(
SELECT sales_name,if(sales_name in ('aaron','bruce'),200,if(month(curdate())=2,300,400))goal,(
/*每个销售取值*/
SELECT ifnull(SUM(CASE 
WHEN trace_action = '电话' AND trace_detail NOT REGEXP '空号|关机|停机|无人接听' THEN 1
WHEN trace_action NOT IN ('电话','方案','其它','机会检查','','其他') THEN 20 
ELSE 0 END ) ,0) AS quantity 
FROM cust_trace 
WHERE trace_recdate between DATE_ADD(curdate(),interval -day(curdate())+1 day) 
				and last_day(curdate())
AND trace_recorder = sales_name
AND CHAR_LENGTH(trace_detail) >= 10 
AND trace_action NOT IN ('方案','其它','机会检查','','其他') 
/*取值结束*/	
)as quantity 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/
)gzl

${if(year==year(today())&&month==month(today()),"SELECT '合格' unqualified",
"SELECT case when count(com_id) = 0 then '合格'
else concat(format(count(com_id),0),'个不合格') end unqualified
FROM cust_company
left join cust_blacklist on blacklist_company = com_id
WHERE com_verified = 'valid' and (blacklist_rule <> 'KPI之合作客户联系频率' or blacklist_rule is NULL)
AND com_status = '合作' AND com_type = '软件公司'
AND com_salesman='"+salesman+"'
AND NOT EXISTS (SELECT * FROM cust_trace
	WHERE com_id=trace_company
	AND TRIM(trace_detail) NOT REGEXP TRIM('空号|关机|停机|无人接听')
	AND CHAR_LENGTH(trace_detail) >= 10
	AND trace_recdate between date_add('"+year+"-"+month+"-01',interval -2 month) and last_day('"+year+"-"+month+"-01'))")}

SELECT distinct sales_name,concat(sales_name,'-',user_name ) username
FROM hr_salesman join hr_user on sales_name= user_username
where sales_parent is not null and sales_parent <> ''and sales_name not in('public','channel')
${IF(FIND("销售",fr_userposition)>0&&fr_username<>"marks"&&fr_username<>"Jason.Jing"&&fr_username<>"Bean"&&fr_username<>"Eric.Xu"&&fr_username<>"pello"&&fr_username<>"light"," and (sales_parent = '"+fr_username+"' or sales_name = '"+fr_username+"')","")}
order by sales_name

SELECT distinct sales_name,(
/*每个销售取值*/
select concat(format(count(com_id),0),'个待提高')  
from cust_company 
where com_salesman =sales_name
and com_verified = 'valid'
and com_status='尚未联络' 
and((area_id<11 and com_country ='中国' and com_province <>'台湾' and com_source<>'线下活动')or (area_id>=11 and com_country <>'中国'))
) as improvable 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
select concat(format(count(com_id),0),'个待提高') from cust_company 
left join (select blacklist_company from cust_blacklist where blacklist_rule ='KPI之跟进客户联系频率')blacklist on blacklist_company = com_id
where com_salesman =sales_name
and com_verified = 'valid'
and com_status='跟进'
and((area_id<11 and com_country ='中国' and com_province <>'台湾' )or (area_id>=11 and com_country <>'中国'))
and blacklist_company is NULL
AND NOT EXISTS (
	SELECT 1 FROM cust_trace
	WHERE trace_company = com_id
	AND trace_recorder = com_salesman
	AND trace_recdate >= 
  LEAST(date_add(CURDATE(),INTERVAL -15 DAY),date_add(CURDATE(),INTERVAL 1-day(CURDATE()) DAY))
	AND CHAR_LENGTH(trace_detail) >= 10
	AND trace_detail NOT REGEXP '空号|关机|停机|无人接听'
	)
/*取值结束*/	
)as improvable 
FROM hr_sales
join hr_area on area_region=sales_region 
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

select com_salesman,concat(format(count(com_id),0),'个待提高') improvable from cust_company 
left join (select blacklist_company from cust_blacklist where blacklist_rule ='KPI之合作客户联系频率')blacklist on blacklist_company = com_id
where com_salesman ='${salesman}'
and com_verified = 'valid'
and com_status = '合作' 
and com_type = '软件公司'
and blacklist_company is NULL
AND NOT EXISTS (
	SELECT 1 FROM cust_trace
	WHERE trace_company = com_id
	AND trace_recorder = com_salesman
	AND trace_recdate > date_add(CURDATE(),INTERVAL -3 month)
	AND CHAR_LENGTH(trace_detail) >= 10
	AND trace_detail NOT REGEXP '空号|关机|停机|无人接听'
	)

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT concat(format(count(opp_id),0),'个待提高') improvable
FROM sale_opportunity 
join cust_company on opp_company = com_id
WHERE com_salesman = sales_name
AND (opp_predate <=  
(/*当月第二个工作日之前的，或今天之前的*/
	select GREATEST(curdate(),date)date from hr_workdays where date >= DATE_ADD(curdate(),INTERVAL 1-DAY(curdate()) day) and state =0 ORDER by date limit 1,1
) OR com_status = '潜在')
AND opp_verified = 'valid' 
AND com_verified = 'valid' 
AND opp_status IN ('初期沟通','售前演示','客户选定','商务谈判') 
/*取值结束*/	
)as improvable 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT concat(format(count(task_id),0),'个待提高') improvable
from cust_task
join cust_company on task_company = com_id
where task_status = '待办' and com_verified='valid'
and concat(",",task_actor,",") regexp concat(",",sales_name,",")
and task_predate 
between 
(select date from hr_workdays where date<curdate() and state =0 ORDER BY date desc limit 0,1)
and (select date from hr_workdays where date>curdate() and state =0 ORDER BY date limit 4,1)
/*上一个工作日，今天之后第五个工作日*/

/*取值结束*/	
)as improvable 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

select sum(ifnull(ctr_amount,0)-ifnull(outs_amount,0)-ifnull(prj_cost,0))/sum(ifnull(sales_objectives,0)) as finishingrate from (SELECT sales_name FROM hr_sales  /*取销售*/
join v_sales_kpi_numbers on sales_name=kpi_username
where /*kpi_has=1 and*/ user_state='在职'
${if(t=1,"and sales_region not in('英文区','台湾','日本','韩国') 
and sales_name not in ('channel','marks','public','max','Alex.Luo','Jason.Jing','serimna','Brian','Eric.Xu','Sakurai') ","and sales_region in('英文区','台湾','日本','韩国') and sales_name not in ('channel','marks','public','max','Alex.Luo') ")} 
and '${salesman}' in(sales_name,sales_parent_I,sales_parent_II)
 or sales_name ='${salesman}'/*其他当月不算KPI的销售也能看到*/
)users
LEFT JOIN /*实际签*/
(	select ctr_salesman,sum(amount*f_amount)/10000 as ctr_amount from 
(
SELECT year(ctr_signdate) year,sum(ctr_amount*ifnull(yj_percent,1))amount,ctr_currency,com_country,month(ctr_signdate) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
FROM sale_contract_info
left join cust_company on com_id=ctr_company
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where ${if(t=1,"com_country='中国'","com_country<>'中国'")} and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman)
union#已作废合同
select year(ifnull(ctr_voiddate,ctr_signdate)) year,-sum(ctr_amount*ifnull(yj_percent,1)) amount,ctr_currency,com_country,month(ifnull(ctr_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_contract_info
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where ${if(t=1,"com_country='中国'","com_country<>'中国'")} and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废"  and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman)
union#未作废合同中作废的财务记录
select year(ifnull(pay_voiddate,ctr_signdate)) year,-sum(ifnull(pay_bill*ifnull(yj_percent,1),0)) amount,ifnull(pay_currency,ctr_currency) ctr_currency,com_country,month(ifnull(pay_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where ${if(t=1,"com_country='中国'","com_country<>'中国'")} and year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废"  and pay_status in ("记坏账","已作废") and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman)
union#已作废合同中已回款的部分
select year(ifnull(ctr_voiddate,ctr_signdate)) year,sum(ifnull(pay_paid,0)*ifnull(yj_percent,1)) amount,ifnull(pay_currency,ctr_currency) ctr_currency,com_country,month(ifnull(ctr_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where ${if(t=1,"com_country='中国'","com_country<>'中国'")} and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman)
)s
left join finan_other_statistics on f_type=ctr_currency and  f_remark='CNY'
group by ctr_salesman
)ctrs on sales_name = ctr_salesman 
LEFT JOIN  /*已外包*/
(	select ifnull(yj_salesman,ctr_salesman) outs_salesman,sum(outs_amount*f_amount*ifnull(yj_percent,1))/10000 outs_amount
	from sale_outsource join v_sale_contract_info_valid on outs_contract=ctr_id
	left join finan_other_statistics on f_type=ctr_currency and  f_remark='CNY'
	join cust_company on com_id=ctr_company
	/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
	where outs_recdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY) and outs_status!='已作废'
	${if(t=1,"and com_country='中国' and IFNULL(ctr_currency,'CNY')='CNY'","and com_country<>'中国'")}
	group by ifnull(yj_salesman,ctr_salesman)
)outs on sales_name = outs_salesman
LEFT JOIN (/*项目成本扣减*/
SELECT prj_salesman,sum(prj_cost)/10000 as prj_cost
FROM `project_rentian`
where prj_year=year(curdate()) 
group by prj_salesman
)prj on prj_salesman=sales_name
LEFT JOIN  /*任务*/
(select sales_salesman,sum(sales_objectives)as sales_objectives from kpi_sales 
where sales_year =year(CURDATE()) and sales_month <=  month(CURDATE())
GROUP BY sales_salesman
)rw on sales_name = sales_salesman

select sum(ifnull(ctr_amount,0))/sum(ifnull(opp_amount,0)) as op from 
(SELECT sales_name FROM hr_sales  /*取销售*/
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and '${salesman}' in(sales_name,sales_parent_I,sales_parent_II)
 or sales_name ='${salesman}'/*其他当月不算KPI的销售也能看到*/
)users
LEFT JOIN /*实际签*/
(SELECT ctr_salesman,SUM(ctr_amount) as ctr_amount FROM sale_contract_info
/*left join sale_outsource on outs_contract=ctr_id and outs_status!="已作废"*/
WHERE ctr_verified = 'valid' 
/*and ctr_agreement is null */
and(( ctr_id not in('3cf81504-7497-4d3e-b738-d0768d36338a')
and ctr_signdate>=DATE_ADD(CURDATE(),INTERVAL 1-day(CURDATE()) day))
or (curdate()<'2019-01-01' and ctr_id='996d76c9-a1d2-44fa-bcf0-5c9f92d779e6'))
GROUP BY ctr_salesman
)shiji on sales_name = ctr_salesman 
LEFT JOIN  /*预计签*/
(select opp_salesman,SUM(opp_amount) as opp_amount from sale_opportunity_monthly
WHERE /*opp_verified = 'valid' and opp_status<>'协议签约' and*/
opp_predate>=DATE_ADD(CURDATE(),INTERVAL 1-day(CURDATE()) day)
GROUP BY opp_salesman
)yuce on sales_name = opp_salesman

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT COUNT(DISTINCT cont_email) c FROM cust_contact AS cont1
JOIN cust_company AS com1 ON cont_company=com_id
WHERE cont_verified='valid' AND com_verified='valid'
AND com_salesman= sales_name
AND cont_email IS NOT NULL AND cont_email<>'' AND length(cont_email)>=5
AND EXISTS(
  SELECT cont_id FROM cust_contact cont2
	JOIN cust_company AS com2 ON cont_company=com_id
	WHERE cont2.cont_verified='valid'AND com2.com_verified='valid'
	AND cont2.cont_email= cont1.cont_email AND cont2.cont_id<>cont1.cont_id
)
/*取值结束*/	
) AS improvable 
FROM hr_sales
join hr_area on area_region=sales_region
JOIN v_sales_kpi_numbers ON sales_name=kpi_username
WHERE kpi_has=1 AND  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT COUNT(DISTINCT cont_qq) c FROM cust_contact AS cont1
JOIN cust_company AS com1 ON cont_company=com_id
WHERE cont_verified='valid' AND com_verified='valid'
AND com_salesman= sales_name
AND cont_qq IS NOT NULL AND cont_qq<>'' AND length(cont_qq)>=5
AND EXISTS(
  SELECT cont_id FROM cust_contact cont2
	JOIN cust_company AS com2 ON cont_company=com_id
	WHERE cont2.cont_verified='valid'AND com2.com_verified='valid'
	AND cont2.cont_qq= cont1.cont_qq AND cont2.cont_id<>cont1.cont_id
)
/*取值结束*/	
) AS improvable 
FROM hr_sales
join hr_area on area_region=sales_region
JOIN v_sales_kpi_numbers ON sales_name=kpi_username
WHERE kpi_has=1 AND  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT COUNT(DISTINCT cont_mobile) c FROM cust_contact AS cont1
JOIN cust_company AS com1 ON cont_company=com_id
WHERE cont_verified='valid' AND com_verified='valid'
AND com_salesman= sales_name
AND cont_mobile IS NOT NULL AND cont_mobile<>'' AND length(cont_mobile)>=5
AND cont_mobile<>'15751172121'
AND EXISTS(
  SELECT cont_id FROM cust_contact cont2
	JOIN cust_company AS com2 ON cont_company=com_id
	WHERE cont2.cont_verified='valid'AND com2.com_verified='valid'
	AND cont2.cont_mobile= cont1.cont_mobile AND cont2.cont_id<>cont1.cont_id
)
/*取值结束*/	
) AS improvable 
FROM hr_sales
join hr_area on area_region=sales_region
JOIN v_sales_kpi_numbers ON sales_name=kpi_username
WHERE kpi_has=1 AND  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
SELECT concat(format(count(pay_id),0),'个待提高') improvable
FROM sale_payment
join v_sale_contract_info_valid on ctr_id = pay_contract
LEFT JOIN sale_opportunity on opp_sign=sign_id 
LEFT JOIN cust_company_valid ON  ifnull(opp_company,ctr_company)=com_id
WHERE com_salesman = sales_name 
and pay_predate <=  
(/*当月第二个工作日之前的，或今天之前的*/
	select GREATEST(curdate(),date)date from hr_workdays where date >= DATE_ADD(curdate(),INTERVAL 1-DAY(curdate()) day) and state =0 ORDER by date limit 1,1
)
AND pay_verified = 'valid' /*泛微致远的订单不算*/
AND com_id not in('5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc','8a959f9a-f426-435b-b0fa-10cb19c46400')
AND com_verified = 'valid' 
and((area_id<11 and ctr_currency='CNY')or (area_id>=11))
and ctr_id <>'a2d752b7-eb46-43ab-b44c-a9cb095ced45'
AND pay_status IN ('待收款','未开票','已到期')
AND ifnull(pay_paid,0)=0 
/*取值结束*/	
)as improvable 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT  distinct sales_name,(
/*每个销售取值*/
select if(count(hk_id)=0,"",concat(format(count(hk_id),0),'个不合格'))
from kpi_i_result_detail_hk
where hk_year ='${year}' 
and hk_month ='${month}' 
and hk_salesman=sales_name
and hk_verified='valid'
/*取值结束*/
) as unqualified 
FROM hr_sales
join hr_area on area_region=sales_region
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and  ((ifnull(sales_parent_II,sales_parent_I)='${salesman}' and sales_name<>sales_parent_I) or  (sales_name='${salesman}' ${if(salesman='aaron'," and area_id<11","")}) ${if(salesman='aaron'," or ('aaron'='"+salesman+"' and area_id=11)","")})
or (kpi_has=0 and (ifnull(sales_parent_II,sales_parent_I)='${salesman}' or  sales_name ='${salesman}') and area_id<11)/*国内未转正销售的信息不显示了*/

SELECT user_username,user_name,user_duty,if(user_duty in('区域经理','大区经理'),1,0)is_parent
from hr_user 
where user_username = '${salesman}'  

select sum(ifnull(paid,0)-ifnull(op_amount,0)-ifnull(prj_cost,0))/sum(ifnull(sales_objectives,0)) as finishingrate from (SELECT sales_name FROM hr_sales  /*取销售*/
join v_sales_kpi_numbers on sales_name=kpi_username
where /*kpi_has=1 and*/ user_state='在职'
${if(t=1,"and sales_region not in('英文区','台湾','日本','韩国') 
and sales_name not in ('channel','marks','public','max','Alex.Luo','Jason.Jing','serimna','Brian','Eric.Xu','Sakurai') ","and sales_region in('英文区','台湾','日本','韩国') and sales_name not in ('channel','marks','public','max','Alex.Luo') ")}
and '${salesman}' in(sales_name,sales_parent_I,sales_parent_II)
 or sales_name ='${salesman}'/*其他当月不算KPI的销售也能看到*/
)users
LEFT JOIN /*回款*/
(	select ifnull(dis_salesman,pay_salesman)as pay_salesman,sum(pay_paid*ifnull(dis_percent,1)*ifnull(f_amount,1))/10000 paid
from sale_payment 
join sale_contract_info on pay_contract=ctr_id 
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
left join cust_company on com_id=ctr_company
/*回款分配*/
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where  year(dis_recdate)>=year(curdate()) group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=year(curdate()) group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
where  pay_verified = 'valid'  and pay_enddate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)  
${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
group by ifnull(dis_salesman,pay_salesman)
)huikuan on sales_name = pay_salesman 
LEFT JOIN  /*外包付款*/
(	SELECT ifnull(dis_salesman,outspay_salesman) as op_salesman,sum(outspay_paid*ifnull(f_amount,1)*ifnull(dis_percent,1))/10000 op_amount
FROM sale_outsource
	join v_sale_contract_info_valid on outs_contract=ctr_id
	left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
	join cust_company on com_id=ctr_company
	join sale_outsource_payment on outs_id=outspay_outsource
	/*回款分配*/
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where  year(dis_recdate)>=year(curdate()) group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=year(curdate()) group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
	where outspay_paydate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)  and outs_status!='已作废'
${if(t=1,"and com_country='中国' and IFNULL(ctr_currency,'CNY')='CNY'","and com_country<>'中国'")}
	group by ifnull(dis_salesman,outspay_salesman) 
)outs on sales_name = op_salesman
LEFT JOIN  /*任务*/
(select sales_salesman,sum(IFNULL(sales_objectives_paid,IFNULL(sales_objectives,0)*0.80)) as sales_objectives from kpi_sales 
where sales_year =year(CURDATE()) and sales_month <=  month(CURDATE())
GROUP BY sales_salesman
)rw on sales_name = sales_salesman
left join(/*项目成本*/
SELECT prj_salesman,sum(prj_cost)/10000 as prj_cost
FROM `project_rentian`
where prj_year=year(curdate())
group by prj_salesman
)prj on prj_salesman=sales_name

SELECT sum(sales_companies)sales_companies,sum(sales_followings)sales_followings
,sum(sales_followings)/sum(sales_companies) AS sales_followings_rate,
sum(sales_keys)/sum(sales_followings) AS sales_keys_rate,
/*机会/(跟进+合作)*/
sum(sales_opportunities)/sum(sales_companies) AS sales_opportunities_rate
FROM(
  SELECT
  /*有效客户数：跟进+合作的客户总数*/
  sum(com_status in('跟进','合作'))as sales_companies,
  sum(com_status = '跟进')as sales_followings,
  /*重点跟进数：跟进级别为重点的客户数*/
  sum(com_status = '跟进' and com_follow_level='1')as sales_keys,
  sum(com_status = '合作')as sales_partners,
  sum(com_status = '合作' and com_type = '软件公司')as sales_partners_sw,
  sum(sales_opportunities) AS sales_opportunities
  FROM (
    SELECT com_id,com_status,com_key,com_follow_level,com_type,sales_name,
    count(opp_id) as sales_opportunities
    FROM hr_sales
    JOIN v_sales_kpi_numbers ON sales_name=kpi_username
    LEFT JOIN cust_company ON sales_name = com_salesman AND com_verified = 'valid'
    LEFT JOIN sale_opportunity ON opp_company=com_id 
    AND opp_verified = 'valid' AND opp_status not REGEXP '签约|失败'
    WHERE (kpi_has=1 AND '${salesman}' IN (sales_name,sales_parent_I,sales_parent_II) OR sales_name ='${salesman}')
    GROUP BY sales_name,com_id
  ) AS list GROUP BY sales_name
) AS final

SELECT sales_region,sales_name
FROM hr_sales
join v_sales_kpi_numbers on sales_name=kpi_username
where /*kpi_has=1 and 主管层面，未转正的销售也把KPI显示出来*/
ifnull(sales_parent_II,sales_parent_I)='${salesman}' 
and sales_name <> '${salesman}'
and sales_region not in('日本','韩国')
union
select sales_region,sales_name from hr_sales where sales_region='台湾'
and '${salesman}' ='aaron'
order by sales_region

select 
sales_name
,date_month
,sum(sales_objectives)sales_objectives
,sum(sales_objectives_paid)sales_objectives_paid
,sum(IFNULL(ctr_amount,0)-IFNULL(outs_amount,0))-sum(ifnull(prj_cost,0)) as ctr_amount
,sum(IFNULL(paid,0)-IFNULL(op_amount,0))-sum(ifnull(prj_cost,0)) as paid
,SUM(ifnull(guss_amount,0))guss_amount
,SUM(ifnull(guss_pay_bill,0))guss_pay_bill 
from (
select sales.*,date_month,sales_objectives,sales_objectives_paid,ctr_amount,outs_amount,paid,op_amount,guss_amount,guss_pay_bill,prj_cost
from (#销售名下销售
	select s.* from hr_sales s
	join hr_user on sales_name=user_username where 
 	(user_state="在职" or (user_state="离职" and ifnull(year(user_leaveDate),2016)>='2018')) and user_department=2 
	${if(t=1,"and sales_region in (select area_region from hr_area where area_id <11)","and sales_region in (select area_region from hr_area where area_id >=11) and sales_name not in ('channel','aaron')")}
	and '${salesman}' in (sales_name,sales_parent_I,sales_parent_II)
)sales  
CROSS join (#月份
	select date_month from dict_date where date_month>=1)m
	/*项目成本，即-k*/
LEFT JOIN (select prj_month,prj_salesman,sum(prj_cost/10000) as prj_cost from project_rentian where prj_year='${year}' group by prj_month,prj_salesman)p on prj_salesman=sales_name and prj_month=date_month


LEFT JOIN (#已经保存的每月目标数据
	select sales_salesman kpi_salesman,sales_month,sales_objectives
,IFNULL(sales_objectives_paid,IFNULL(sales_objectives,0)*0.80) sales_objectives_paid from kpi_sales where sales_year = '${year}'
)kpi on sales_name=kpi_salesman and date_month = sales_month

LEFT JOIN (#销售每月签单
select ctr_salesman,sum(amount)/10000 ctr_amount,month
from(
SELECT ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,sum(ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1)) AS amount
,month(ctr_signdate) month
FROM sale_contract_info
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = paid.pay_contract 
where year(ctr_signdate)='${year}'  
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by ifnull(yj_salesman,ctr_salesman),month(ctr_signdate)

union#已作废合同(当年签单当年作废才算是作废)
select ifnull(yj_salesman,ctr_salesman) as ctr_salesman
,-sum(ifnull(yj_percent,1)*ctr_amount*ifnull(f_amount,1)) as amount
,month(ctr_signdate) month
from sale_contract_info 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
and year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and year(ctr_signdate)='${year}'
group by ifnull(yj_salesman,ctr_salesman),month(ctr_signdate)

union#未作废合同中作废的财务记录
select ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(ifnull(yj_percent,1)*pay_bill*ifnull(f_amount,1)) as bill
,month(ctr_signdate) month
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废" and pay_status in ("记坏账","已作废") and year(ctr_signdate)='${year}'
group by ifnull(yj_salesman,ctr_salesman),month(ctr_signdate)

union#已作废合同中已回款的部分
select  ifnull(yj_salesman,ctr_salesman)as ctr_salesman
,-sum(ifnull(yj_percent,1)*pay_paid*ifnull(f_amount,1)) as paid
,month(ctr_signdate) month
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 and year(ctr_signdate)='${year}'
group by ifnull(yj_salesman,ctr_salesman),month(ctr_signdate)
)list 
group by ctr_salesman,month
)qiandan on ctr_salesman= sales_name and date_month = month

LEFT JOIN (#销售每月外包
select ifnull(yj_salesman,ctr_salesman) as outs_salesman
,sum(if(year(outs_recdate)='${year}',ifnull(yj_percent,1)*outs_amount,0))/10000 outs_amount
,month(outs_recdate) outs_month
from sale_outsource
left join sale_contract_info on outs_contract=ctr_id
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)='${year}' group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
where year(outs_recdate)='${year}' 
and outs_status!="已作废"
group by ifnull(yj_salesman,ctr_salesman),month(outs_recdate)	
)waibao on outs_salesman= sales_name and outs_month = date_month

LEFT JOIN (#销售每月回款
select ifnull(dis_salesman,pay_salesman)as pay_salesman
,sum(ifnull(dis_percent,1)*pay_paid*f_amount)/10000 paid
,month(pay_enddate) hk_month
from sale_payment 
join sale_contract_info on pay_contract=ctr_id
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)='${year}' and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)='${year}' and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
left join finan_other_statistics on f_remark='CNY' and f_type=ifnull(pay_currency,ctr_currency) 
join cust_company on com_id=ctr_company ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}
where  pay_verified = 'valid' and year(pay_enddate)='${year}'
group by ifnull(dis_salesman,pay_salesman),month(pay_enddate)
)huikuan on pay_salesman= sales_name and date_month = hk_month

LEFT JOIN (#外包每月付款
SELECT ifnull(dis_salesman,outspay_salesman)as op_salesman
,sum(ifnull(dis_percent,1)*outspay_paid)/10000 op_amount
,month(outspay_paydate) op_month
FROM `sale_outsource` a
left join sale_contract_info b on outs_contract=ctr_id
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where year(dis_recdate)='${year}' and year(dis_recdate)>=2019 group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)='${year}' and year(dis_recdate)>=2019 group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
inner join sale_opportunity c on ifnull(ctr_agreement,ctr_id)=opp_sign or ctr_agreement=opp_sign
inner join cust_company d on opp_company=com_id
left join sale_outsource_payment e on outs_id=outspay_outsource
left join (select distinct sales_name,sales_region from hr_salesman) f on ctr_salesman=sales_name
where year(outspay_paydate)='${year}'
and outs_status!="已作废" ${if(t=1,"and com_country='中国'","and com_country<>'中国'")}

group by ifnull(dis_salesman,outspay_salesman),month(outspay_paydate)

)op ON op_salesman=sales_name AND op_month=date_month


LEFT JOIN (select opp_salesman,month(opp_predate) guss_month,sum(opp_amount/10000)guss_amount from sale_opportunity
	where year(opp_predate)='${year}' and opp_status not regexp '失败|签约' group by opp_salesman,month(opp_predate)
)guss on opp_salesman = sales_name and date_month = guss_month

LEFT JOIN (SELECT com_salesman pay_sales,MONTH(ifnull(pay_enddate,pay_predate))pay_month,sum(pay_bill/10000)guss_pay_bill FROM sale_payment
join v_sale_contract_info_valid on ctr_id = pay_contract
LEFT JOIN sale_opportunity on opp_sign=sign_id 
LEFT JOIN cust_company_valid ON  ifnull(opp_company,ctr_company)=com_id
WHERE year(ifnull(pay_enddate,pay_predate)) ='${year}'and pay_status not in ('已作废','记坏账')
AND pay_verified = 'valid' /*泛微致远的订单不算*/
AND com_id not in('5ccd6fc6-133a-4d2f-a7d1-8d709081e1bc','8a959f9a-f426-435b-b0fa-10cb19c46400')
AND com_verified = 'valid' AND ctr_currency ='CNY'
GROUP BY com_salesman,pay_month
)pay_guss on pay_sales = sales_name and pay_month = date_month
)sssss
group BY date_month  having date_month <= '${month}'

select * from (
SELECT 1 id, kpi_year,kpi_month,kpi_ii_score*kpi_i_score as kpi_score FROM `kpi_result` 
where kpi_year = year(DATE_SUB(CURDATE(),INTERVAL 1 month))
and kpi_salesman ='${salesman}'
union
SELECT 2 id, num_year,num_month,'待确认' as kpi_score FROM kpi_numbers_month
where num_year = year(DATE_SUB(CURDATE(),INTERVAL 1 month)) 
and num_month = month(DATE_SUB(CURDATE(),INTERVAL 1 month)) 
and num_salesman ='${salesman}'
)kpi group by kpi_year,kpi_month

	select group_concat(distinct sales_name separator "','" )as namesale 
	from hr_sales s
	join hr_user on sales_name=user_username 
	where
	(user_state="在职" or (user_state="离职" and ifnull(year(user_leaveDate),2016)>='2018')) and 	user_department=2 
	and '${salesman}' in (sales_name,sales_parent_I,sales_parent_II)
	and sales_name not in("oliver","Jesse.Lin","Dgeneral","channel")


select parent,sum(ifnull(paid,0)-ifnull(op_amount,0)-ifnull(prj_cost,0))/sum(ifnull(sales_objectives,0)) as finishingrate 
from (SELECT aa.sales_name as sales,ifnull((select bb.sales_parent from hr_salesman bb join hr_user on user_username=bb.sales_parent and user_duty<>'大区经理' where sales_parent<>'${salesman}' and bb.sales_name=sales),aa.sales_name)parent
FROM hr_salesman aa
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and sales_parent='${salesman}' 
and sales_name <> '${salesman}'
)users
LEFT JOIN /*回款*/
(	select ifnull(dis_salesman,pay_salesman)as pay_salesman,sum(pay_paid*f_amount*ifnull(dis_percent,1))/10000 paid
from sale_payment 
join sale_contract_info on pay_contract=ctr_id 
left join finan_other_statistics on f_remark='CNY' and f_type=ctr_currency
left join cust_company on com_id=ctr_company
/*回款分配*/
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where  year(dis_recdate)>=year(curdate()) group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=year(curdate()) group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
where  pay_verified = 'valid'  and pay_enddate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)  

group by ifnull(dis_salesman,pay_salesman) 
)huikuan on sales = pay_salesman 
LEFT JOIN  /*外包付款*/
(	SELECT ifnull(dis_salesman,outspay_salesman) as op_salesman,sum(outspay_paid*ifnull(dis_percent,1))/10000 op_amount
FROM sale_outsource
	join v_sale_contract_info_valid on outs_contract=ctr_id
	join cust_company on com_id=ctr_company
	join sale_outsource_payment on outs_id=outspay_outsource
	/*回款分配*/
left join 
(select dis_contract,dis_salesman,dis_percent from sale_distribute_apply where  year(dis_recdate)>=year(curdate()) group by dis_contract,dis_salesman
union
select dis_contract,dis_salesman_2nd,dis_percent_2nd from sale_distribute_apply where year(dis_recdate)=year(curdate()) group by dis_contract,dis_salesman_2nd)distr on dis_contract=ctr_id
	where outspay_paydate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)  and outs_status!='已作废' and IFNULL(ctr_currency,'CNY')='CNY'
	group by ifnull(dis_salesman,outspay_salesman)
)outs on sales = op_salesman
LEFT JOIN  /*任务*/
(select sales_salesman,sum(IFNULL(sales_objectives_paid,IFNULL(sales_objectives,0)*0.80)) as sales_objectives from kpi_sales 
where sales_year =year(CURDATE()) and sales_month <=  month(CURDATE())
GROUP BY sales_salesman
)rw on sales= sales_salesman
left join(/*项目成本*/
SELECT prj_salesman,sum(prj_cost)/10000 as prj_cost
FROM `project_rentian`
where prj_year=year(curdate())
group by prj_salesman
)prj on prj_salesman=sales
group by parent

select parent,sum(ifnull(ctr_amount,0)-ifnull(outs_amount,0)-ifnull(prj_cost,0))/sum(ifnull(sales_objectives,0)) as finishingrate from (SELECT aa.sales_name as sales,ifnull((select bb.sales_parent from hr_salesman bb join hr_user on user_username=bb.sales_parent and user_duty<>'大区经理' where sales_parent<>'${salesman}' and bb.sales_name=sales),aa.sales_name)parent
FROM hr_salesman aa
join v_sales_kpi_numbers on sales_name=kpi_username
where kpi_has=1 and sales_parent='${salesman}' 
and sales_name <> '${salesman}'
)users
LEFT JOIN /*实际签*/
(	select ctr_salesman,sum(amount*f_amount)/10000 as ctr_amount from 
(
SELECT year(ctr_signdate) year,sum(ctr_amount*ifnull(yj_percent,1))amount,ctr_currency,com_country,month(ctr_signdate) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
FROM sale_contract_info
left join cust_company on com_id=ctr_company
LEFT JOIN (select pay_contract,sum(IFNULL(pay_paid,0))sumpay_paid from sale_payment where pay_status not in('记坏账','已作废') and pay_verified="valid" group by pay_contract)paid  ON ctr_id = pay_contract 
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
and (ctr_status in ('已收回','已存档','订单已处理','已作废') or (ctr_status not in ('待审核','待录入','不合格','已收回','已存档') and sumpay_paid>0))
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman) 
union#已作废合同
select year(ifnull(ctr_voiddate,ctr_signdate)) year,-sum(ctr_amount*ifnull(yj_percent,1)) amount,ctr_currency,com_country,month(ifnull(ctr_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_contract_info
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废"  and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman) 
union#未作废合同中作废的财务记录
select year(ifnull(pay_voiddate,ctr_signdate)) year,-sum(ifnull(pay_bill*ifnull(yj_percent,1),0)) amount,ifnull(pay_currency,ctr_currency) ctr_currency,com_country,month(ifnull(pay_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where year(ifnull(pay_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status<>"已作废"  and pay_status in ("记坏账","已作废") and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman) 
union#已作废合同中已回款的部分
select year(ifnull(ctr_voiddate,ctr_signdate)) year,sum(ifnull(pay_paid,0)*ifnull(yj_percent,1)) amount,ifnull(pay_currency,ctr_currency) ctr_currency,com_country,month(ifnull(ctr_voiddate,ctr_signdate)) month,ifnull(yj_salesman,ctr_salesman) as ctr_salesman
from sale_payment
left join sale_contract_info on ctr_id=pay_contract
left join cust_company on com_id=ctr_company
/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
where year(ifnull(ctr_voiddate,ctr_signdate))=year(ctr_signdate) and ctr_status="已作废" and ifnull(pay_paid,0)>0 and ctr_signdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY)
group by year,com_country,ctr_currency,month,ifnull(yj_salesman,ctr_salesman) 
)s
left join finan_other_statistics on f_type=ctr_currency and  f_remark='CNY'
group by ctr_salesman
)ctrs on sales = ctr_salesman 
LEFT JOIN  /*已外包*/
(	select ifnull(yj_salesman,ctr_salesman)  outs_salesman,sum(outs_amount*ifnull(yj_percent,1))/10000 outs_amount
	from sale_outsource join v_sale_contract_info_valid on outs_contract=ctr_id
	join cust_company on com_id=ctr_company
	/*业绩分配，两个销售分*/
left join 
(select yj_contract,yj_salesman,yj_percent from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman
union
select yj_contract,yj_salesman_2nd,yj_percent_2nd from sale_distribute_apply_yeji where year(yj_recdate)=year(curdate()) group by yj_contract,yj_salesman_2nd)distr on yj_contract=ctr_id
	where outs_recdate>=DATE_SUB(CURDATE(),INTERVAL dayofyear(now())-1 DAY) and outs_status!='已作废' and IFNULL(ctr_currency,'CNY')='CNY'
	group by ifnull(yj_salesman,ctr_salesman) 
)outs on sales = outs_salesman
LEFT JOIN (/*项目成本扣减*/
SELECT prj_salesman,sum(prj_cost)/10000 as prj_cost
FROM `project_rentian`
where prj_year=year(curdate()) 
group by prj_salesman
)prj on prj_salesman=sales
LEFT JOIN  /*任务*/
(select sales_salesman,sum(sales_objectives)as sales_objectives from kpi_sales 
where sales_year =year(CURDATE()) and sales_month <=  month(CURDATE())
GROUP BY sales_salesman
)rw on sales = sales_salesman
group by parent

