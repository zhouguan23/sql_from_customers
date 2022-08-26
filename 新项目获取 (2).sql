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

SELECT
	AREA_ORG_NAME,
	CITY_ORG_NAME,
	LAND_NAME,
	EQUITY_RATIO,
	sum(FLOOR_AREA) as FLOOR_AREA, #占地面积
	sum(SURFACE_BUILD_AREA) as SURFACE_BUILD_AREA, #计容建面
	sum(GET_PRICE) as GET_PRICE, #获取价格
	sum(EXPC_SUM_VALUE)/10000 as EXPC_SUM_VALUE,	#预计总货值(万元)
	sum(FLOOR_AREA*EQUITY_RATIO/100) as Q_FLOOR_AREA,
	sum(SURFACE_BUILD_AREA*EQUITY_RATIO/100) as Q_SURFACE_BUILD_AREA, #计容建面
	sum(GET_PRICE*EQUITY_RATIO/100) as Q_GET_PRICE, #权益获取价格
	sum(EXPC_RIGHT_VALUE)/10000 as EXPC_RIGHT_VALUE #预计权益货值（万元）
FROM dim_erp_land 
WHERE 1=1 
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITY_ORG_CODE in ('" + CITY + "')")}
${if(len(LAND) == 0,"","and LAND_CODE in ('" + LAND + "')")}
${if(len(BEGIN_DATE) == 0,"","and date_format(GET_DATE,'%Y-%m') >='"+BEGIN_DATE+"' AND date_format(GET_DATE,'%Y-%m') <='"+END_DATE+"' ")}
GROUP BY
	AREA_ORG_NAME,
	CITY_ORG_NAME,
	LAND_NAME,
	EQUITY_RATIO

