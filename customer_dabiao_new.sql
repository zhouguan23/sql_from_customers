select * from (select *,GROUP_CONCAT(pro_productline)product  from (select *,if(f_date="0000-01-01","",f_date) as final_date from
(select com_id,com_type,com_sales_region,com_salesman,com_presales,success_user,pro_productline,due_date,opp_predate,overdue_enddate,
greatest(if(due_date="" or due_date is null,"0000-01-01",due_date),if(opp_predate="" or opp_predate is null,"0000-01-01",opp_predate),if(overdue_enddate="" or overdue_enddate is null,"0000-01-01",overdue_enddate),if(OPERATIONENDDATE="" or OPERATIONENDDATE is null,"0000-01-01",OPERATIONENDDATE)) as f_date,ifnull(bm_mark,'0') mark,bg_case,if(com_salesman='public','lidre',success_user)success
from cust_company c
left join sale_contract_info s on s.ctr_company=c.com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
left join presales_biaogan_list on bg_comid=c.com_id
LEFT JOIN cust_benchmark on c.com_id=bm_company 
left join v_support_service_due sd on sd.due_company=c.com_id
left join (select opp_id,opp_company,max(opp_predate) opp_predate from sale_opportunity where opp_verified="valid" group by opp_company order by opp_predate desc)o on opp_company=com_id
left join (select overdue_id,overdue_comid,max(overdue_enddate) overdue_enddate from support_overdue_service group by overdue_comid order by overdue_enddate desc)ov on overdue_comid=com_id
 left join (select CUSID, OPERATIONENDDATE from (select * from OPR_F_OPERATIONMANAGE order by OPERATIONENDDATE desc)opr1 group by CUSID)opr on CUSID=com_id
left join support_success_customer on  find_in_set(com_salesman,success_salesman)
where com_verified="valid" and ctr_verified="valid" and pro_productline regexp 'FineReport'
and c.com_type='最终用户'
and c.com_sales_region  not in ('日本','韩国','台湾','英文区')
${if(len(presman) == 0," ","and FIND_IN_SET(c.com_presales,'" + presman + "')")}
${if(len(salesman) == 0," ",if(find('public',salesman)>0,"and ((FIND_IN_SET(c.com_salesman,'" + salesman + "')and  c.com_salesman<>'public') or (c.com_salesman='public' and find_in_set(c.com_sales_region,'"+region+"')))","and FIND_IN_SET(c.com_salesman,'" + salesman + "')"))}
 and com_status="合作" 
 group by com_id)A
where  f_date>='${date}'
${if(len(success)=0,"","and success in ('"+success+"')")})AA
group by com_id)total_com
where product<>'FineBI'

select com_id,com_name from cust_user_biaogan_visit where com_name is not null and com_name<>''

select *,ifnull(length(dbcom2),0) len2 from (select * from (select * from ( SELECT
	a.appID,type,com_id,com_name,date_format(concat(ym,'-01'), '%Y%m' ) yearMonth,b.downTime,ifnull(b.宕机次数,0)宕机次数,daily_visit*valid_days sumVisit,valid_days,month_visit_cpt,month_visit_user,daily_visit ,if(daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0,1,0)dabiao
FROM(select * from 

/*start---达标原数据范围*/
(select * from (select  *,group_concat(pro_productline) productline from (select biaogan.*,pro_productline 
from v_cust_user_biaogan_visit_fr biaogan/*视图v_cust_user_biaogan_visit_fr*/
left join sale_contract_info s on s.ctr_company=com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
group by id,type,pro_productline)a
group by id ,type
)a
where  productline regexp 'FineReport' and ((productline regexp 'FineBI' and type<>'固化埋点') or productline  not regexp 'FineBI')
)data
/*end---达标原数据范围*/
where type<>'手动录入' order by field(type,'固化埋点','云端运维数据'))a
	LEFT JOIN ( SELECT downTime, appId,yearMonth,sum(downTime) 宕机次数 FROM system_usage_info GROUP BY appId,yearMonth ) b ON a.appid = b.appid 
	AND a.ym = date_format(b.yearMonth,'%Y-%m') 
WHERE 1=1
and a.appID not in ('197ee1e8-d206-4fcc-892e-ab3ec3018f25','15f8f068-0365-4e85-8e0a-8bfd74213585','3e57b912-e2c1-4a02-b7cd-a40a47eed69d','da03b569-a4be-44a8-bb77-d24d00ed9919','d1cb20ee-f99e-4ae3-85a9-9ed26f06f09b')
/*剔除appid重复问题客户*/
and (date_format(CONCAT(ym,'-01'),'%Y%m')=concat('${year}','${month}') 
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 1 month)=concat('${year}','-','${month}','-01')
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 2 month)=concat('${year}','-','${month}','-01'))

order by ym desc,if(daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0,1,0)desc,field(type,'固化埋点','云端运维数据')/*先按年月筛选符合的*/)a group by appID)total
where  dabiao=1
${if(len(customer) == 0,"","and com_id in ('" + customer+ "')")}	
union
select * from (select * from ( SELECT
	appID,type,com_id,com_name,date_format(concat(ym,'-01'), '%Y%m' ) yearMonth,"-" downTime,"-" 宕机次数,daily_visit*valid_days sumVisit,valid_days,month_visit_cpt,month_visit_user,daily_visit ,''dabiao
FROM (select * from (select * from 

/*start---达标原数据范围*/
(select * from (select  *,group_concat(pro_productline) productline from (select biaogan.*,pro_productline 
from v_cust_user_biaogan_visit_fr biaogan/*视图v_cust_user_biaogan_visit_fr*/
left join sale_contract_info s on s.ctr_company=com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
group by id,type,pro_productline)a
group by id ,type
)a
where  productline regexp 'FineReport' and ((productline regexp 'FineBI' and type<>'固化埋点') or productline  not regexp 'FineBI')
)data
/*end---达标原数据范围*/

order by  field(type,'固化埋点','云端运维数据','手动录入'))a group by com_id,ym)b
WHERE type='手动录入'
and (date_format(CONCAT(ym,'-01'),'%Y%m')=concat('${year}','${month}') 
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 1 month)=concat('${year}','-','${month}','-01')
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 2 month)=concat('${year}','-','${month}','-01'))
order by ym desc)a group by com_id)total
where  daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0
${if(len(customer) == 0,"","and com_id in ('" + customer+ "')")}	
)T1
left join (
select appid,com_id,max(yearMonth)yearMonth from (
/*------以下与第一部分相同*/
select * from (select * from ( SELECT
	a.appID,type,com_id,com_name,date_format(concat(ym,'-01'), '%Y%m' ) yearMonth,b.downTime,ifnull(b.宕机次数,0)宕机次数,daily_visit*valid_days sumVisit,valid_days,month_visit_cpt,month_visit_user,daily_visit ,if(daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0,1,0)dabiao
FROM(select * from 

/*start---达标原数据范围*/
(select * from (select  *,group_concat(pro_productline) productline from (select biaogan.*,pro_productline 
from v_cust_user_biaogan_visit_fr biaogan/*视图v_cust_user_biaogan_visit_fr*/
left join sale_contract_info s on s.ctr_company=com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
group by id,type,pro_productline)a
group by id ,type
)a
where  productline regexp 'FineReport' and ((productline regexp 'FineBI' and type<>'固化埋点') or productline  not regexp 'FineBI')
)data
/*end---达标原数据范围*/
where type<>'手动录入' order by field(type,'固化埋点','云端运维数据'))a
	LEFT JOIN ( SELECT downTime, appId,yearMonth,sum(downTime) 宕机次数 FROM system_usage_info GROUP BY appId,yearMonth ) b ON a.appid = b.appid 
	AND a.ym = date_format(b.yearMonth,'%Y-%m') 
WHERE 1=1
and a.appID not in ('197ee1e8-d206-4fcc-892e-ab3ec3018f25','15f8f068-0365-4e85-8e0a-8bfd74213585','3e57b912-e2c1-4a02-b7cd-a40a47eed69d','da03b569-a4be-44a8-bb77-d24d00ed9919','d1cb20ee-f99e-4ae3-85a9-9ed26f06f09b')
/*剔除appid重复问题客户*/
and (date_format(CONCAT(ym,'-01'),'%Y%m')=concat('${year}','${month}') 
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 1 month)=concat('${year}','-','${month}','-01')
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 2 month)=concat('${year}','-','${month}','-01'))
order by ym desc,if(daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0,1,0)desc,field(type,'固化埋点','云端运维数据')/*先按年月筛选符合的*/)a group by appID)total
where  dabiao=1
${if(len(customer) == 0,"","and com_id in ('" + customer+ "')")}	
union
select * from (select * from ( SELECT
	appID,type,com_id,com_name,date_format(concat(ym,'-01'), '%Y%m' ) yearMonth,"-" downTime,"-" 宕机次数,daily_visit*valid_days sumVisit,valid_days,month_visit_cpt,month_visit_user,daily_visit ,''dabiao
FROM (select * from (select * from 

/*start---达标原数据范围*/
(select * from (select  *,group_concat(pro_productline) productline from (select biaogan.*,pro_productline 
from v_cust_user_biaogan_visit_fr biaogan/*视图v_cust_user_biaogan_visit_fr*/
left join sale_contract_info s on s.ctr_company=com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
group by id,type,pro_productline)a
group by id ,type
)a
where  productline regexp 'FineReport' and ((productline regexp 'FineBI' and type<>'固化埋点') or productline  not regexp 'FineBI')
)data
/*end---达标原数据范围*/

order by  field(type,'固化埋点','云端运维数据','手动录入'))a group by com_id,ym)b
WHERE type='手动录入'
and (date_format(CONCAT(ym,'-01'),'%Y%m')=concat('${year}','${month}') 
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 1 month)=concat('${year}','-','${month}','-01')
or date_add(date_format(concat(ym,'-01'),'%Y-%m-%d'),interval 2 month)=concat('${year}','-','${month}','-01'))
order by ym desc)a group by com_id)total
where  daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0
${if(len(customer) == 0,"","and com_id in ('" + customer+ "')")}	
/*------以上与第一部分相同*/
)t2_1
group by appid,com_id)t2 on ifnull(t1.appId,t1.com_id)=ifnull(t2.appid,t1.com_id) and t1.com_id=t2.com_id and t1.yearMonth=t2.yearMonth

left join /*历史未达标过排除当期*/
(select distinct com_id dbcom2 from (select * from (select * from (select *,TIMESTAMPDIFF(MONTH,DATE_FORMAT(concat(ym,'-01'),'%Y-%m-%d %H:%i:%S'),DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%S')) as month_diff,if(type='云端运维数据' or type='固化埋点',2,1)filed,if(daily_visit>='1000'
and (month_visit_cpt>='100' or month_visit_user>='100')
and valid_days is not null and valid_days<>'' and valid_days<>0,1,0)dabiao from 

/*start---达标原数据范围*/
(select * from (select  *,group_concat(pro_productline) productline from (select biaogan.*,pro_productline 
from v_cust_user_biaogan_visit_fr biaogan/*视图v_cust_user_biaogan_visit_fr*/
left join sale_contract_info s on s.ctr_company=com_id
left join sale_contract_detail d on s.ctr_id=d.pro_contract
group by id,type,pro_productline)a
group by id ,type
)a
where  productline regexp 'FineReport' and ((productline regexp 'FineBI' and type<>'固化埋点') or productline  not regexp 'FineBI')
)data
/*end---达标原数据范围*/

where ym<concat('${year}','-','${month}') )a 
where   ( a.appID is null  or a.appID not in ('197ee1e8-d206-4fcc-892e-ab3ec3018f25','15f8f068-0365-4e85-8e0a-8bfd74213585','3e57b912-e2c1-4a02-b7cd-a40a47eed69d','da03b569-a4be-44a8-bb77-d24d00ed9919','d1cb20ee-f99e-4ae3-85a9-9ed26f06f09b'))
order by ym desc,filed desc,dabiao desc)b
group by com_id,ym)c 
where dabiao=1
group by com_id,appid)history_dabiao on t1.com_id=dbcom2
where t2.yearMonth is not null
order by t1.yearMonth desc


select distinct sales_region from hr_salesman
where sales_region is not null
and sales_region  not in ('日本','韩国','台湾','英文区')

SELECT distinct sales_name,concat(sales_name,'-',user_name) name,sales_region
FROM hr_salesman
left join hr_user on user_username=sales_name
where 1=1
${if(len(region)=0,"","and FIND_IN_SET(sales_region,'" + region+ "')")}
union
SELECT 'public','public-售前公共销售号',null




SELECT distinct pres_name,concat(pres_name,'-',user_name) name,pres_region
FROM hr_presales
left join hr_user on user_username=pres_name
where 1=1
${if(len(region)=0,"","and FIND_IN_SET(pres_region,'" + region+ "')")}





select distinct sales_region from hr_salesman
where sales_region is not null
${if(len(region)=0,"","and find_in_set(sales_region,'"+region+"')")}


select * from support_success_customer where success_salesman is not null and success_salesman<>''

