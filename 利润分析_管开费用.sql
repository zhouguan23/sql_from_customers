WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ID,AREA_NAME
FROM f_fin_acdoca_fee
where area_id in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	CITY_ID,CITY_NAME
FROM f_fin_acdoca_fee
where city_id in(
	select distinct city_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ID) == 0,"","and AREA_ID in ('" + AREA_ID+ "')")}

WITH RECURSIVE USER_ORG AS
(
  SELECT * FROM FR_ORG WHERE SAP_DEPT_ID IN (
		SELECT DEPT_ID FROM FR_USER_ORG WHERE USER_ID='${FINE_USERNAME}')
  UNION ALL
  SELECT T.* FROM FR_ORG T INNER JOIN USER_ORG TCTE ON T.SAP_PARENT_ID = TCTE.SAP_DEPT_ID
)
SELECT 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,""," a.area_id,a.area_name, " ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,""," a.city_id,a.city_name, " ) }
	'fu' as fu,
	sum(A.ADM_BUSI_AMOUNT) as ADM_BUSI_AMOUNT, #管理费用-业务招待费
	sum(A.ADM_TRIP_AMOUNT) as ADM_TRIP_AMOUNT, #管理费用-差旅费
	sum(A.ADM_OFFICE_AMOUNT) as ADM_OFFICE_AMOUNT, #管理费用-办公费
	sum(A.ADM_SALARY_AMOUNT) as ADM_SALARY_AMOUNT, #管理费用-职工薪酬
	sum(A.DEV_TRIP_AMOUNT) as DEV_TRIP_AMOUNT, #开发费用-差旅费
	sum(A.DEV_OFFICE_AMOUNT) as DEV_OFFICE_AMOUNT, #开发费用-办公费
	sum(A.DEV_SALARY_AMOUNT) as DEV_SALARY_AMOUNT, #开发费用-职工薪酬
	sum(A.TOTAL_AMOUNT) as TOTAL_AMOUNT, #总费用
	sum(A.EQUITY_ORDER_AMOUNT) as EQUITY_ORDER_AMOUNT, #权益认购额
	sum(A.TOTAL_AMOUNT)/sum(A.EQUITY_ORDER_AMOUNT)  AS GK_RAT #管开费率
FROM  f_fin_acdoca_fee a
WHERE 1=1
and TMON between '${YEARMONTH}' and '${YEARMONTHEND}'
${if(len(AREA_ID) == 0,"and a.area_id in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
) ","and a.AREA_ID in ('" + AREA_ID + "')")}
${if(len(CITY_ID) == 0,"and a.city_id in(
	select distinct city_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
) "," and a.CITY_ID in ('" + CITY_ID + "')")}
group by 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,""," area_id,area_name, " ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,""," city_id,city_name, " ) }
	fu

