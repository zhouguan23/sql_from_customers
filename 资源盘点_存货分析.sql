SELECT distinct
	AREA_ORG_CODE,
	AREA_ORG_NAME
FROM DIM_STAGING

SELECT distinct
	a.city_org_code,
	a.city_org_name
FROM DIM_STAGING a
where 1=1 
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}

SELECT DISTINCT
	B.PROJ_CODE,
	B.PROJ_NAME
FROM ipt_fnc_pro_all  A
LEFT JOIN  DIM_STAGING B ON A.PROJ_CODE = B.STAGE_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}


SELECT DISTINCT
	B.STAGE_CODE,
	B.STAGE_NAME
FROM ipt_fnc_pro_all  A
LEFT JOIN  DIM_STAGING B ON A.PROJ_CODE = B.STAGE_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"","and B.PROJ_CODE in ('" + PROJ + "')")}

with tmp_resource as( #不含车位资源货值
select 
	a.area_org_code,
	a.area_org_name,
	a.CITY_ORG_NAME,
	a.proj_name,
	a.STAGE_CODE,
	a.STAGE_NAME,
	a.BUILD_PROD_TYPE_NAME,
	K_AGE,
	sum(case when REACH_NOT_CERT_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end)  as REACH_NOT_CERT #达工程预售未取证
from dm_resource_inventory	a
left join (select VERSION,BUILD_CODE,BUILD_TYPE_code,UNIT_PRICE from ipt_mkt_build_price where version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m') #业务上是1~5号填报上月单价，所以计算货值的时候需要取+1月的单价
)b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code 
WHERE 1=1
and BUILD_PROD_LV1_TYPE_CODE <> '04' #不含车位货值
and a.period_wid='${pDates}' #货值版本
${if(len(AREA)=0,""," and a.area_org_code='"+AREA+"'")}
group by a.area_org_code,a.area_org_name,a.CITY_ORG_NAME,a.proj_name,a.STAGE_CODE,a.STAGE_NAME,a.BUILD_PROD_TYPE_NAME,K_AGE
),tmp_resource_carport as( #车位货值
select 
	a.area_org_name,
	a.CITY_ORG_NAME,
	a.proj_name,
	a.STAGE_CODE,
	a.STAGE_NAME,
	a.BUILD_PROD_TYPE_NAME,
	K_AGE,
	sum(case when REACH_NOT_CERT_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end)  as REACH_NOT_CERT #达工程预售未取证
from dm_resource_inventory	a
left join (select VERSION,BUILD_CODE,BUILD_TYPE_code,UNIT_PRICE from ipt_mkt_build_price where version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m') #业务上是1~5号填报上月单价，所以计算货值的时候需要取+1月的单价
)b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code 
WHERE 1=1
and BUILD_PROD_LV1_TYPE_CODE = '04' #不含车位货值
and a.period_wid='${pDates}' #货值版本
${if(len(AREA)=0,""," and a.area_org_code='"+AREA+"'")}
group by a.area_org_name,a.CITY_ORG_NAME,a.proj_name,a.STAGE_CODE,a.STAGE_NAME,a.BUILD_PROD_TYPE_NAME,K_AGE
),tmp_resource_cert as(#全周期资源盘点：取证未认购需先去重
select 
	a.area_org_name,a.CITY_ORG_NAME,a.proj_name,a.STAGE_CODE,a.STAGE_NAME,a.BUILD_PROD_TYPE_NAME,K_AGE,
	sum(CERT_UNORDER_NOCARPORT_PRICE) as cert_unorder #取证未认购不含车位
from (select distinct area_org_code,area_org_name,city_org_name,proj_name,stage_code,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,period_wid,MARKET_BUILD_ID,CERT_UNORDER_NOCARPORT_PRICE from dm_resource_inventory) a
WHERE 1=1
and period_wid='${pDates}'
${if(len(AREA)=0,""," and a.area_org_code='"+AREA+"'")}
group by a.area_org_name,a.CITY_ORG_NAME,a.proj_name,a.STAGE_CODE,a.STAGE_NAME,a.BUILD_PROD_TYPE_NAME,K_AGE
),tmp_resource_cert_carport as(
select 
	a.area_org_name,
	a.CITY_ORG_NAME,
	a.proj_name,
	a.STAGE_CODE,
	a.STAGE_NAME,
	a.BUILD_PROD_TYPE_NAME,
	K_AGE,
	sum(CERT_UNORDER_PRICE - CERT_UNORDER_NOCARPORT_PRICE) as cert_unorder #取证未认购车位货值
from (select distinct area_org_code,area_org_name,city_org_name,proj_name,stage_code,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,period_wid,MARKET_BUILD_ID,CERT_UNORDER_PRICE,CERT_UNORDER_NOCARPORT_PRICE from dm_resource_inventory) a
WHERE 1=1
and period_wid='${pDates}'
${if(len(AREA)=0,""," and a.area_org_code='"+AREA+"'")}
group by a.area_org_name,a.CITY_ORG_NAME,a.proj_name,a.STAGE_CODE,a.STAGE_NAME,a.BUILD_PROD_TYPE_NAME,K_AGE
)
select  
	area_org_name as area_name, #区域
	city_org_name as city_name, #城市
	proj_name, #项目
	stage_code, #分期编码
	stage_name, #分期
	build_prod_type_name as prodtypename, #业态
	k_age as kage, #库龄
	sum(nocarport_gv)/10000 as nocarport_gv, #不含车位货值
	sum(carport_gv)/10000 as carport_gv, #车位货值
	sum(gv)/10000 as gv  #总货值
from(
	select area_org_name,CITY_ORG_NAME,proj_name,STAGE_CODE,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,REACH_NOT_CERT as nocarport_gv,0 as carport_gv,REACH_NOT_CERT as gv from tmp_resource
	union all
	select area_org_name,CITY_ORG_NAME,proj_name,STAGE_CODE,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,0 as nocarport_gv,REACH_NOT_CERT as carport_gv,REACH_NOT_CERT as gv from tmp_resource_carport
	union all 
	select area_org_name,CITY_ORG_NAME,proj_name,STAGE_CODE,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,cert_unorder as nocarport_gv,0 as carport_gv,cert_unorder as gv from tmp_resource_cert
	union all 
	select area_org_name,CITY_ORG_NAME,proj_name,STAGE_CODE,STAGE_NAME,BUILD_PROD_TYPE_NAME,K_AGE,0 as nocarport_gv,cert_unorder as carport_gv,cert_unorder as gv from tmp_resource_cert_carport
) a
group by area_org_name,city_org_name,proj_name,stage_code,stage_name,build_prod_type_name,k_age
order by find_in_set(area_org_name,"珠海区域,华南区域,华东区域,华中区域,山东区域,北方区域,北京公司")

