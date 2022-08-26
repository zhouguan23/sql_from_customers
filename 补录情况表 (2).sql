select 
  '营销' object,
	'开工未取证楼栋录入' topic,
  area_org_code,  
 	area_org_name, 
	city_org_code, 
	city_org_name, 
	sum(unfill_num) unfill_num,
	sum(all_num) all_num,
	group_concat(case when  unfill_Num <> 0 then concat(proj_name,stage_name,'：',unfill_num,'栋楼未录入\n') else null end) detail
from
(
select
	area_org_code,  
	area_org_name, 
	city_org_code, 
	city_org_name, 
	proj_code,
	proj_name,
	stage_code,
	stage_name,
	sum(case when t2.unit_price is not null then 1 else 0 end) fill_num,
	count(1) all_num,
	count(1)-sum(case when t2.unit_price is not null then 1 else 0 end) unfill_num
from
dm_resource_inventory t1 -- 楼栋维表
left join ( select * from ipt_mkt_build_price where version='${version}') t2 -- 填报楼栋单价存储表
on  t1.BUILD_CODE=t2.build_code 
and  t1.BUILD_PROD_TYPE_COMP_CODE=t2.build_TYPE_code     
where 
BUILD_PROD_TYPE_CODE is not null 
and  BUILD_PROD_TYPE_CODE<>''
AND START_NOT_CERT_FLAG='Y' 
AND PERIOD_WID='${version}'
group by
  area_org_code, 
	area_org_name, 
	city_org_code, 
	city_org_name, 
	proj_code,
	proj_name,
	stage_code,
	stage_name
) a
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
group by
  area_org_code,  
 	area_org_name, 
	city_org_code, 
	city_org_name





select distinct the_month from dim_time where the_date<now() AND the_month>='2020-12' order by the_month desc limit 12

WITH t1 as  (
SELECT
DISTINCT PROJ_ID
FROM `dim_mkt_project` a
where
OPERAT_FLAG='Y' -- 取出操盘项目
)
,t2 as (
select t2.AREA_ORG_CODE,T2.AREA_ORG_NAME,t2.CITY_ORG_CODE,t2.CITY_ORG_NAME,t2.PROJ_CODE,t2.PROJ_NAME,t2.MAKET_PROJ_ID,t1.proj_id
from t1 left join dim_project t2  on t1.proj_id=t2.MAKET_PROJ_ID )
,t3 as (select distinct t2.PROJ_CODE from t2 where t2.proj_code is not null ) 

select 
'营销' object,
'非操盘取证存货' topic,
AREA_ORG_CODE, -- 区域公司代码
AREA_ORG_NAME, -- 区域公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
sum(case when stock is not null then 1 else 0 end) fill_Num,
count(1) all_num,
count(1)-sum(case when stock is not null then 1 else 0 end) unfill_num,
group_concat(proj_name,stage_name,'\n') detail
from
dim_staging a
left join (
select * 
from ipt_mkt_stock
where version = '${version}'
)b on a.STAGE_CODE = b.STAGE_id
where 1=1
and STAGE_NAME!='跨期'
and a.PERIOD_WID='${version}'
and  proj_code not in (select PROJ_CODE from t3)
AND a.STAGE_CODE IN (
SELECT DISTINCT erp_stage_id FROM dim_mkt_project
WHERE cp_flag='N'
AND PERIOD_WID='2020-12')
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
group by 
AREA_ORG_CODE, -- 区域公司代码
AREA_ORG_NAME, -- 区域公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME -- 城市公司名称

select
'营销' object,
'营销代理费录入' topic,
	AREA_ORG_CODE , 
	AREA_ORG_NAME , 
	CITY_ORG_CODE , -- 城市公司代码
	CITY_ORG_NAME , -- 城市公司名称
	sum(case when AGENT_COST is not null then 1 else 0 end) fill_num,-- 代理费用
	count(proj_code) all_num,
	count(proj_code) - sum(case when AGENT_COST is not null then 1 else 0 end)  unfill_Num,
	group_concat(case when AGENT_COST is null then proj_name else null end) detail
from
dim_project t1 -- 项目分期维表
 left join (select * from ipt_mkt_agent_cost where VERSION='${version}') t2 
 on t1.PROJ_CODE=t2.STAGE_ID
 where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
GROUP BY
	AREA_ORG_CODE , 
	AREA_ORG_NAME  ,
	CITY_ORG_CODE ,
	CITY_ORG_NAME


SELECT
  '营销' object,
	'项目销售目标录入' topic,
	AREA_org_NAME,
	CITY_org_NAME,
  SUM(CASE WHEN AIM_ORDERTARGET IS NOT NULL OR AIM_CONTRACTTARGET IS NOT NULL OR AIM_RECEIPTTARGET IS NOT NULL OR AIM_EQUITY_ORDERTARGET IS NOT NULL OR AIM_EQUITY_CONTRACTTARGET IS NOT NULL OR AIM_EQUITY_RECEIPTTARGET  IS NOT NULL THEN 1 ELSE 0 END) FILL_NUM,
	COUNT(PROJ_CODE) ALL_NUM,
	COUNT(PROJ_CODE) - SUM(CASE WHEN AIM_ORDERTARGET IS NOT NULL OR AIM_CONTRACTTARGET IS NOT NULL OR AIM_RECEIPTTARGET IS NOT NULL OR AIM_EQUITY_ORDERTARGET IS NOT NULL OR AIM_EQUITY_CONTRACTTARGET IS NOT NULL OR AIM_EQUITY_RECEIPTTARGET  IS NOT NULL THEN 1 ELSE 0 END)  UNFILL_NUM,
	
	GROUP_CONCAT(case when  AIM_ORDERTARGET IS NULL and AIM_CONTRACTTARGET IS NULL and AIM_RECEIPTTARGET IS NULL and AIM_EQUITY_ORDERTARGET IS NULL and AIM_EQUITY_CONTRACTTARGET IS NULL and AIM_EQUITY_RECEIPTTARGET  IS NULL then PROJ_NAME else null end)DETAIL
FROM
dim_project a 
left join (select * from  ipt_mkt_sale_target where  LEFT(YEARMONTH,7)='${version}') b
on a.proj_code = b.projectcode
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
GROUP BY
AREA_org_NAME,
CITY_org_NAME




select
'投拓' object,
'实际投资额' topic,
t1.area_org_code,
t1.area_org_name,
group_concat(case when T2.INVEST_PRICE is null then city_org_name else null end) detail 
from (SELECT DISTINCT area_org_name,area_org_code,city_org_code,city_org_name FROM dim_project) t1 
left join (select * from ipt_invest_actual_price  where version='${version}') t2 on t1.city_org_code = t2.city_code
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
group by t1.area_org_code,
t1.area_org_name
ORDER BY  area_org_code

select
'投拓' object,
'投资目标额' topic,
t1.area_org_code,
t1.area_org_name,
group_concat(case when T2.INVEST_PRICE is null then city_org_name else null end) detail 
from (SELECT DISTINCT area_org_name,area_org_code,city_org_code,city_org_name FROM dim_project) t1 -- 楼栋维表
left join (select * from ipt_invest_aim_price  where version=left('${version}',4) )t2 
on t1.city_org_code = t2.city_code
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
group by
t1.area_org_code,
t1.area_org_name

select
'投拓' object,
'土储货值投拓版' topic,
case when area_org_name='股份本部及直辖' then '北京公司' else area_org_name end  area_org_name,
area_org_code,
city_org_code, -- 城市公司代码
city_org_name , -- 城市公司名称
sum(case when t2.STOCK_price is not null then 1 else 0 end) fill_num,
	count(1) all_num,
	count(1)-sum(case when t2.STOCK_price is not null then 1 else 0 end) unfill_num,
	group_concat(case when T2.STOCK_price is null then land_name else null end) detail 
from
dim_erp_land t1 -- 地块维表
left join ( select * from ipt_invest_land_price ) t2 -- 填报货值存储表
 on t1.LAND_CODE=t2.LAND_CODE 
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
 group by
 area_org_name,
area_org_code,
city_org_code, -- 城市公司代码
city_org_name

WITH T1 AS 
(select distinct
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
t1.PROJ_CODE, -- 项目编码
t1.PROJ_NAME, -- 项目名称
t1.STAGE_CODE, -- 分期编码
t1.STAGE_NAME -- 分期名称
from
dim_staging t1 -- 项目分期维表
WHERE t1.PERIOD_WID=left(now(),7)
UNION ALL
select
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
t1.PROJ_CODE, -- 项目编码
t1.PROJ_NAME, -- 项目名称
'wkg001' as STAGE_CODE, -- 分期编码
'尚未创建分期' as STAGE_NAME -- 分期名称
from
dim_project t1 -- 项目分期维表
),T2 AS 
( select * from ipt_pro_land_stock where version='${version}')  -- 填报地块单价存储表 
select
'运营' object,
'项目土储业态面积货值录入' topic,
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
COUNT(DISTINCT CASE WHEN t2.STOCK_SUM IS NULL THEN t1.stage_code ELSE NULL END) UNFILL_NUM,
COUNT(DISTINCT t1.stage_code ) ALL_NUM,
group_concat(DISTINCT case when T2.STOCK_SUM is null then concat(t1.PROJ_NAME,t1.stage_NAME)  else null end,'\n') detail 
FROM T1 LEFT JOIN T2 on t1.STAGE_CODE=t2.STAGE_CODE AND t1.PROJ_CODE=t2.PROJ_CODE
where t1.STAGE_CODE IN (
SELECT DISTINCT STAGE_CODE FROM dm_resource_inventory
WHERE NOT_START_FLAG ='Y'
AND PERIOD_WID='${version}')
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
and t1.stage_name <>'尚未创建分期'
and right(t1.stage_code,2) <>'KQ'
GROUP BY
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME




select 
'运营' object,
'项目经营数据ABC版补录' topic,
T1.VERSION,
t1.area_ORG_CODE, -- 城市公司代码
t1.area_ORG_NAME, -- 城市公司名称
t1.CITY_ORG_CODE, -- 城市公司代码
t1.CITY_ORG_NAME, -- 城市公司名称
count(distinct case when t2.order is not null and land_cost is not null then T1.PROJ_code else null end) fill_num,
	count(distinct T1.PROJ_code) all_num,
	count(distinct T1.PROJ_code)-count(distinct case when t2.order is not null and land_cost is not null then T1.PROJ_code else null end)  unfill_num,
	group_concat(case when T2.order is null or t2.land_cost is null then concat(t1.proj_name,'\n') else null end) detail 

from
(select DISTINCT
'A' VERSION,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME -- 项目名称
from dim_project 
UNION ALL
select DISTINCT
'B' VERSION,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME -- 项目名称
from dim_project 
UNION ALL
select DISTINCT
'C' VERSION,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME -- 项目名称
from dim_project
) t1 
left join ipt_opr_pro_all t2 
on t1.proj_code=t2.proj_code and t1.version = t2.version
left join ipt_opr_pro_all_exp t3 
on t1.proj_code=t3.proj_code and t1.version = t3.version
where 1=1
and t3.version is null
${if(len(AREANAME)=0,"","AND t1.area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND t1.city_org_code IN ('"+CITYNAME+"')")}
GROUP BY
T1.VERSION,
t1.area_ORG_CODE, -- 城市公司代码
t1.area_ORG_NAME, -- 城市公司名称
t1.CITY_ORG_CODE, -- 城市公司代码
t1.CITY_ORG_NAME

select
distinct AREA_ORG_CODE,AREA_ORG_NAME
from
dim_project

select
	distinct  CITY_ORG_CODE,CITY_ORG_NAME
from
dim_project
WHERE 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}

select 
'财务' object,
'项目分期经营数据补录' topic,
T1.VERSION,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
count(distinct case when t2.order is not null and land_cost is not null then T1.STAGE_CODE else null end) fill_num,
	count(distinct T1.STAGE_CODE) all_num,
	count(distinct T1.STAGE_CODE)-count(distinct case when t2.order is not null and land_cost is not null then T1.STAGE_CODE else null end)  unfill_num,
	group_concat(case when T2.order is null or t2.land_cost is null then concat(proj_name,stage_name,'\n') else null end) detail 

from
(
select DISTINCT
quarter_name version,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME, -- 项目名称
STAGE_CODE, -- 项目编码
STAGE_NAME -- 项目名称
from dim_staging
left join (
select distinct quarter_name from dim_time where the_date>='2020-01-01' and the_date<=now() ) t2 on 1=1
where PERIOD_WID='${version}'
) t1 
left join ipt_fnc_pro_all t2 
on t1.STAGE_CODE=t2.PROJ_CODE and t1.version = t2.version
where 1=1
${if(len(AREANAME)=0,"","AND area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND city_org_code IN ('"+CITYNAME+"')")}
AND t1.STAGE_CODE NOT LIKE '%KQ'
and stage_code not in (
select distinct  stage_code from ipt_fnc_pro_all_exp group by proj_code
)
GROUP BY
T1.VERSION,
area_ORG_CODE, -- 城市公司代码
area_ORG_NAME, -- 城市公司名称
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME

select
'财务' object,
'城市公司销售口径利润指标完成情况录入' topic,
the_month,
t1.area_org_code,
t1.area_org_name,
t1.city_org_code,
t1.city_org_name,
case when T2.GPROFIT_TAR_L is not null or T2.NPROFIT_TAR_L is not null or T2.GPROFIT_TAR_Q is not null or T2.NPROFIT_TAR_Q is not null  then '是' else '否' end detail 
from
(SELECT DISTINCT the_month,area_org_name,area_org_code,city_org_code,city_org_name FROM 
(select  distinct the_month from dim_time where the_month between '2020-12' and date_format(curdate(), '%Y-%m')
) a left join 
dim_project b on 1=1) t1
left join (select * from ipt_fnc_city_profit) t2 on t1.city_org_code = t2.city_org_code and t1.the_month = t2.version
where 1=1
${if(len(AREANAME)=0,"","AND t1.area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND t1.city_org_code IN ('"+CITYNAME+"')")}

ORDER BY  
the_month,
t1.area_org_code,
t1.area_org_name,
t1.city_org_code,
t1.city_org_name


select
'财务' object,
'财务-城市公司销售口径利润目标录入' topic,
the_month,
t1.area_org_code,
t1.area_org_name,
t1.city_org_code,
t1.city_org_name,
case when T2.GPROFIT_TAR_JL is not null or T2.NPROFIT_TAR_JL is not null or T2.GPROFIT_TAR_JQ is not null or T2.NPROFIT_TAR_JQ is not null  then '是' else '否' end detail 
from
(SELECT DISTINCT the_month,area_org_name,area_org_code,city_org_code,city_org_name FROM 
(select  distinct the_month from dim_time where the_month between '2020-12' and date_format(curdate(), '%Y-%m')
) a left join 
dim_project b on 1=1) t1
left join (select * from ipt_fnc_city_profit_tar) t2 on t1.city_org_code = t2.city_org_code and t1.the_month = t2.version
where 1=1
${if(len(AREANAME)=0,"","AND t1.area_org_code IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","AND t1.city_org_code IN ('"+CITYNAME+"')")}

ORDER BY  
the_month,
t1.area_org_code,
t1.area_org_name,
t1.city_org_code,
t1.city_org_name





