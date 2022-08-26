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

with tmp_resource as(#资源货值（不含车位）
select
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	A.PROJ_CODE,
	A.PROJ_NAME,
	A.STAGE_CODE,
	A.STAGE_NAME,
	sum(case when a.MON_PLAN_START_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_START, #计划新开工货值
	sum(case when a.MON_AC_START_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_START, #实际新开工货值
	sum(case when a.MON_PLAN_REACH_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_REACH, #计划新达工程预售
	sum(case when a.MON_AC_REACH_AREA='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_REACH, #实际计划新达工程预售
	sum(case when a.MON_PLAN_NEWCERT_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_NEWCERT, #计划新取证
	sum(a.AC_HOUSE_SUM_INSIDE_PRICE) as AC_NEWCERT #实际新取证
from dm_resource_inventory	a
left join (select VERSION,BUILD_CODE,BUILD_TYPE_code,UNIT_PRICE from ipt_mkt_build_price where version= DATE_FORMAT(DATE_ADD(concat('2019-12','-01'),INTERVAL 1 MONTH) ,'%Y-%m') #业务上是1~5号填报上月单价，所以计算货值的时候需要取+1月的单价
)b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code 
where a.BUILD_PROD_LV1_TYPE_CODE <> '04'
and a.PERIOD_WID='${pDates}'
GROUP BY
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	A.PROJ_CODE,
	A.PROJ_NAME,
	A.STAGE_CODE,
	A.STAGE_NAME
),tmp_resource_carport as(#车位货值
select
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	A.PROJ_CODE,
	A.PROJ_NAME,
	A.STAGE_CODE,
	A.STAGE_NAME,
	sum(case when a.MON_PLAN_START_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_START, #计划新开工货值
	sum(case when a.MON_AC_START_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_START, #实际新开工货值
	sum(case when a.MON_PLAN_REACH_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_REACH, #计划新达工程预售
	sum(case when a.MON_AC_REACH_AREA='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_REACH, #实际计划新达工程预售
	sum(case when a.MON_PLAN_NEWCERT_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PLAN_NEWCERT, #计划新取证
	sum(a.AC_HOUSE_SUM_INSIDE_PRICE) as AC_NEWCERT #实际新取证
from dm_resource_inventory	a
left join (select VERSION,BUILD_CODE,BUILD_TYPE_code,UNIT_PRICE from ipt_mkt_build_price where version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m') #业务上是1~5号填报上月单价，所以计算货值的时候需要取+1月的单价
)b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code 
where a.BUILD_PROD_LV1_TYPE_CODE = '04'
and a.PERIOD_WID='${pDates}'
GROUP BY
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	A.PROJ_CODE,
	A.PROJ_NAME,
	A.STAGE_CODE,
	A.STAGE_NAME
),FULL_PROJ AS(
-- 获取所有项目
SELECT DISTINCT A.AREA_ORG_CODE,A.AREA_ORG_NAME,A.CITY_ORG_CODE,A.CITY_ORG_NAME,A.PROJ_CODE,A.PROJ_NAME,A.STAGE_CODE,A.STAGE_NAME FROM(
SELECT 	A.AREA_ORG_CODE,A.AREA_ORG_NAME,A.CITY_ORG_CODE,A.CITY_ORG_NAME,A.PROJ_CODE,A.PROJ_NAME,A.STAGE_CODE,A.STAGE_NAME FROM tmp_resource A
UNION ALL
SELECT 	B.AREA_ORG_CODE,B.AREA_ORG_NAME,B.CITY_ORG_CODE,B.CITY_ORG_NAME,B.PROJ_CODE,B.PROJ_NAME,B.STAGE_CODE,B.STAGE_NAME FROM tmp_resource_carport B
)A
)
select
	1 AS A,
	${ IF(INARRAY("1", SPLIT(show, ",")) = 0,"","F.AREA_ORG_NAME," ) }
	${ IF(INARRAY("2", SPLIT(show, ",")) = 0,"","F.CITY_ORG_NAME," ) }
	${ IF(INARRAY("3", SPLIT(show, ",")) = 0,"","F.PROJ_NAME," ) }
	${ IF(INARRAY("4", SPLIT(show, ",")) = 0,"","F.STAGE_NAME," ) }
	ROUND(SUM(ifnull(a.PLAN_START,0)+ifnull(b.PLAN_START,0))/10000,2) as PLAN_START ,
	ROUND(SUM(ifnull(a.AC_START,0)+ifnull(b.AC_START,0))/10000,2) as AC_START ,
	ROUND(SUM(ifnull(a.PLAN_REACH,0)+ifnull(b.PLAN_REACH,0))/10000,2) as PLAN_REACH ,
	ROUND(SUM(ifnull(a.AC_REACH,0)+ifnull(b.AC_REACH,0))/10000,2) as AC_REACH ,
	ROUND(SUM(ifnull(a.PLAN_NEWCERT,0)+ifnull(b.PLAN_NEWCERT,0))/10000,2) as PLAN_NEWCERT, 
	ROUND(SUM(ifnull(a.AC_NEWCERT,0)+ifnull(b.AC_NEWCERT,0))/10000,2) as AC_NEWCERT 
from FULL_PROJ F
LEFT JOIN tmp_resource a ON F.STAGE_CODE = A.STAGE_CODE
LEFT JOIN tmp_resource_carport b ON F.STAGE_CODE = B.STAGE_CODE
where 1=1
${if(len(AREA) == 0,"","and f.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and f.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"","and f.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE) == 0,"","and f.STAGE_CODE in ('" + STAGE + "')")}
GROUP BY
	${ IF(INARRAY("1", SPLIT(show, ",")) = 0,"","F.AREA_ORG_NAME," ) }
	${ IF(INARRAY("2", SPLIT(show, ",")) = 0,"","F.CITY_ORG_NAME," ) }
	${ IF(INARRAY("3", SPLIT(show, ",")) = 0,"","F.PROJ_NAME," ) }
	${ IF(INARRAY("4", SPLIT(show, ",")) = 0,"","F.STAGE_NAME," ) }
	A
order by f.area_org_name

