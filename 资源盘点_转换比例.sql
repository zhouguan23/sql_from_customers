SELECT distinct
	AREA_ORG_CODE,
	AREA_ORG_NAME
FROM dim_erp_land

SELECT 
distinct	city_org_code,city_org_name
FROM dim_erp_land
where 1=1 
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}

SELECT
	A.LAND_CODE,
	B.LAND_NAME
FROM ipt_mkt_land_price  A
LEFT JOIN  dim_erp_land B ON A.LAND_CODE = B.LAND_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}


SELECT
	A.TYPE
FROM ipt_mkt_land_price  A
LEFT JOIN  dim_erp_land B ON A.LAND_CODE = B.LAND_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}
${if(len(LAND) == 0,"","and A.LAND_CODE in ('" + LAND + "')")}

WITH tmp_land AS ( #本期土地储备 a
SELECT
	B.AREA_ORG_CODE,
	b.area_org_name,
	B.CITY_ORG_CODE,
	B.CITY_ORG_NAME,
	sum(ifnull(a.unit_price,0) * ifnull(a.land_area,0)) as land_gv #货值单价*可售面积
FROM ipt_mkt_land_price a #单价来源填报
LEFT JOIN dim_erp_land b ON a.land_code = b.land_code #土地维表
WHERE 1=1
and a.version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m') #业务上是1~5号填报上月单价，所以计算货值的时候需要取+1月的填报数据
group by
	b.area_org_name,
	B.AREA_ORG_CODE,
	B.CITY_ORG_CODE,
	B.CITY_ORG_NAME
),tmp_land_pre as( #上期末土地储备货值 b
SELECT
	B.AREA_ORG_CODE,
	b.area_org_name,
	B.CITY_ORG_CODE,
	B.CITY_ORG_NAME,
	sum(ifnull(a.unit_price,0) * ifnull(a.land_area,0)) as pre_land_gv #货值单价*可售面积
FROM ipt_mkt_land_price a #单价来源填报
LEFT JOIN dim_erp_land b ON a.land_code = b.land_code #土地维表
WHERE 1=1
and a.version= '${pDates}'
GROUP BY 
	b.area_org_name,
	B.AREA_ORG_CODE,
	B.CITY_ORG_CODE,
	B.CITY_ORG_NAME
),tmp_resource as( #本期资源货值（不含车位） c
select
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	sum(case when a.MON_AC_START_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_START_GV, #实际新开工货值
	sum(case when a.MON_AC_REACH_AREA='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_REACH_GV, #实际计划新达工程预售
	sum(AC_HOUSE_SUM_INSIDE_PRICE) as AC_NEWCERT_GV #实际新取证
from dm_resource_inventory a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code and b.version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m')
WHERE 1=1
and period_wid='${pDates}'
and BUILD_PROD_LV1_TYPE_CODE <> '04'
GROUP BY 
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME
),tmp_resource_pre as( #上期资源货值（不含车位） d
select 
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	sum(case when a.MON_AC_START_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as PRE_AC_START_GV, #实际新开工货值
	sum(case when a.MON_AC_REACH_AREA='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as PRE_AC_REACH_GV, #实际计划新达工程预售
	sum(AC_HOUSE_SUM_INSIDE_PRICE) as AC_NEWCERT_GV #实际新取证
from dm_resource_inventory a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code and b.version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m')
WHERE 1=1
and a.period_wid= left(DATE_ADD(DATE_FORMAT(concat('${pDates}','-01'),'%Y-%m-%d'),INTERVAL -1 month),7) 
and BUILD_PROD_LV1_TYPE_CODE <> '04'
GROUP BY
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME
),tmp_resource_carport as( #本期车位货值 e
select
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	sum(case when a.MON_AC_START_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_START_GV, #实际新开工货值
	sum(case when a.MON_AC_REACH_AREA='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as AC_REACH_GV, #实际计划新达工程预售
	sum(AC_HOUSE_SUM_INSIDE_PRICE) as AC_NEWCERT_GV #实际新取证
from dm_resource_inventory a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code and b.version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m')
WHERE 1=1
and a.period_wid='${pDates}'
and a.BUILD_PROD_LV1_TYPE_CODE = '04'
GROUP BY 
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME
),tmp_resource_carport_pre as( #上期车位货值 f
select 
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME,
	sum(case when a.MON_AC_START_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PRE_AC_START_GV, #实际新开工货值
	sum(case when a.MON_AC_REACH_AREA='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PRE_AC_REACH_GV, #实际计划新达工程预售
	sum(case when a.MON_PLAN_NEWCERT_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as PRE_AC_NEWCERT_GV #计划新取证
from dm_resource_inventory a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_CODE=b.BUILD_TYPE_code and b.version= DATE_FORMAT(DATE_ADD(concat('${pDates}','-01'),INTERVAL 1 MONTH) ,'%Y-%m')
WHERE 1=1
and a.period_wid= left(DATE_ADD(DATE_FORMAT(concat('${pDates}','-01'),'%Y-%m-%d'),INTERVAL -1 month),7) 
and a.BUILD_PROD_LV1_TYPE_CODE = '04'
GROUP BY
	A.AREA_ORG_CODE,
	A.AREA_ORG_NAME,
	A.CITY_ORG_CODE,
	A.CITY_ORG_NAME
),FULL_NAME AS(
SELECT DISTINCT A.* FROM (
SELECT	A.AREA_ORG_CODE,A.AREA_ORG_NAME,A.CITY_ORG_CODE,A.CITY_ORG_NAME FROM TMP_LAND A
UNION ALL
SELECT	B.AREA_ORG_CODE,B.AREA_ORG_NAME,B.CITY_ORG_CODE,B.CITY_ORG_NAME FROM TMP_LAND_PRE B
UNION ALL
SELECT	C.AREA_ORG_CODE,C.AREA_ORG_NAME,C.CITY_ORG_CODE,C.CITY_ORG_NAME FROM TMP_RESOURCE C
UNION ALL
SELECT	D.AREA_ORG_CODE,D.AREA_ORG_NAME,D.CITY_ORG_CODE,D.CITY_ORG_NAME FROM TMP_RESOURCE_PRE D
UNION ALL
SELECT	E.AREA_ORG_CODE,E.AREA_ORG_NAME,E.CITY_ORG_CODE,E.CITY_ORG_NAME FROM TMP_RESOURCE_CARPORT E
UNION ALL
SELECT	F.AREA_ORG_CODE,F.AREA_ORG_NAME,F.CITY_ORG_CODE,F.CITY_ORG_NAME FROM TMP_RESOURCE_CARPORT_PRE F
) A
)
SELECT
	FN.AREA_ORG_NAME,
	FN.CITY_ORG_NAME,
	(ifnull( c.ac_start_gv, 0 ) + ifnull( e.ac_start_gv, 0 ) ) / ( ifnull(b.pre_land_gv, 0 ) + ifnull( a.land_gv, 0 ) ) AS land_pec,#土储转在途比例：新开工面积/（上期末土地储备面积+本期新增土地储备面积）
	(ifnull( c.ac_reach_gv, 0 ) + ifnull( e.ac_reach_gv, 0 ) ) / (
	ifnull( d.pre_ac_start_gv, 0 ) + ifnull( f.pre_ac_start_gv, 0 ) + ifnull(c.ac_start_gv, 0 ) + ifnull( e.ac_start_gv, 0 ) 
	) AS sale_pec,#在途转可售比例：新达工程预售/上期末在途+本期新增在途
	(ifnull( c.ac_newcert_gv, 0 ) + ifnull( e.ac_newcert_gv, 0 ) ) / (
	ifnull( d.pre_ac_reach_gv, 0 ) + ifnull(f.pre_ac_reach_gv, 0 ) + ifnull(c.ac_reach_gv, 0 ) + ifnull( e.ac_reach_gv, 0 ) 
	) AS cert_pec #可售新取证比例：新取证/上期末新达工程预售+本期新增新达工程预售
	
FROM FULL_NAME FN
LEFT JOIN TMP_LAND A ON A.AREA_ORG_CODE = FN.AREA_ORG_CODE AND A.CITY_ORG_CODE = FN.CITY_ORG_CODE
LEFT JOIN TMP_LAND_PRE B ON B.AREA_ORG_CODE = FN.AREA_ORG_CODE AND B.CITY_ORG_CODE = FN.CITY_ORG_CODE
LEFT JOIN TMP_RESOURCE C ON C.AREA_ORG_CODE = FN.AREA_ORG_CODE AND C.CITY_ORG_CODE = FN.CITY_ORG_CODE
LEFT JOIN TMP_RESOURCE_PRE D ON D.AREA_ORG_CODE = FN.AREA_ORG_CODE AND D.CITY_ORG_CODE = FN.CITY_ORG_CODE
LEFT JOIN TMP_RESOURCE_CARPORT E ON E.AREA_ORG_CODE = FN.AREA_ORG_CODE AND E.CITY_ORG_CODE = FN.CITY_ORG_CODE
LEFT JOIN TMP_RESOURCE_CARPORT_PRE F ON F.AREA_ORG_CODE = FN.AREA_ORG_CODE AND F.CITY_ORG_CODE = FN.CITY_ORG_CODE
WHERE 1=1
${if(len(CITY)=0," "," and FN.CITY_ORG_CODE IN('"+CITY+"')")}
${if(len(AREA)=0," "," and FN.AREA_ORG_CODE IN('"+AREA+"')")}
ORDER BY 
	FN.AREA_ORG_NAME,
	FN.CITY_ORG_NAME

