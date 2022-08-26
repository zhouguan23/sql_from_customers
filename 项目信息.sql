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
) and PERIOD_WID = (SELECT MAX(PERIOD_WID) FROM DIM_STAGING)

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
and city_org_code in(select distinct sap_dept_id from user_org a )
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
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
	*
FROM dim_staging a 
left join dim_erp_mkt b on a.stage_code=b.stage_code
WHERE 1=1
${if(len(AREA) == 0," and  a.area_org_code in(select distinct sap_dept_id from user_org a )"," and a.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0," and a.city_org_code in(select distinct sap_dept_id from user_org a )"," and B.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"and a.proj_code in(select distinct b.proj_code from user_org a )","and B.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE) == 0,"","and a.STAGE_CODE in ('" + STAGE + "')")}
order by a.area_org_code,a.city_org_code

