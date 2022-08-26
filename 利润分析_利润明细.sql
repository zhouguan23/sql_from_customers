WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
	AREA_ORG_CODE,
	AREA_ORG_NAME
FROM DIM_STAGING
where area_org_code in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
	a.city_org_code,
	a.city_org_name
FROM DIM_STAGING a
where city_org_code in(
	select distinct sap_dept_id from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
) 
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT DISTINCT
	B.PROJ_CODE,
	B.PROJ_NAME
FROM ipt_fnc_pro_all  A
LEFT JOIN  DIM_STAGING B ON A.PROJ_CODE = B.STAGE_CODE
where b.proj_code in(
	select distinct b.proj_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
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

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
	B.AREA_ORG_CODE,
	B.AREA_ORG_NAME,
	B.CITY_ORG_CODE,
	B.CITY_ORG_NAME,
	B.PROJ_CODE,
	B.PROJ_NAME,
	B.STAGE_CODE,
	B.STAGE_NAME,
	A.VERSION,
	A.`ORDER` '认购额(不含税)/万元',
	A.LAND_COST '土地成本（不含税）/万元',
	A.PRO_KF_COST '项目开发成本(不含土地及利息)/万元',
	A.INVEST_INTEREST '全投资利息(不含税)/万元',
	A.LAND_TAX '土地增值税/万元',
	A.TAXES '税金及附加/万元',
	A.MANAGE_COST '管理费用/万元',
	A.MKT_COST '营销费用/万元',
	A.FNC_COST '财务费用/万元',
	A.INCOME_TAX '企业所得税/万元',
	A.GROSS_PROFIT '销售毛利润/万元',
	A.GROSS_PROFIT_RATE 销售毛利润率,
	A.NETPROFIT '销售净利润/万元',
	A.NETPROFIT_RATE 销售净利润率,
	A.CASH_FLOW_JY 经营性现金流回正周期,
	A.CASH_FLOW_RZ 含融资现金流回正周期,
	A.IRR,
	A.BUSSINESS_ZCDJ 商业自持地价,
	A.BUSSINESS_ZCLX 商业自持利息,
	A.BUSSINESS_ZCJA 商业自持建安,
	A.PT_ZCDJ 配套自持地价,
	A.PT_ZCLX 配套自持利息,
	A.PT_ZCJA 配套自持建安,
	INSERTTIME
FROM ipt_fnc_pro_all A
LEFT JOIN DIM_STAGING B ON A.PROJ_CODE = B.STAGE_CODE AND B.PERIOD_WID = 
(select distinct the_month from dim_time where quarter_name='${VERSION}' order by the_month desc limit 1)
WHERE 1=1
${if(len(AREA) == 0," and  b.area_org_code in(
	select distinct sap_dept_id from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0," and b.city_org_code in(
	select distinct sap_dept_id from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)","and B.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"and b.proj_code in(
	select distinct b.proj_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)","and B.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE) == 0,"","and B.STAGE_CODE in ('" + STAGE + "')")}
AND VERSION= '${VERSION}'

select distinct quarter_name from dim_time  
where the_month>='2019-12' and the_month<=left(now(),7)


(select distinct the_month from dim_time where quarter_name='${VERSION}' order by the_month desc limit 1) #拿出这个季度某个月份的维表

