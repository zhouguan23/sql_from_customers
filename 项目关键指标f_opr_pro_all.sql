WITH RECURSIVE user_org as
(
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
B.AREA_ORG_CODE	-- 区域公司编码
,B.AREA_ORG_NAME	-- 区域公司名称
,B.CITY_ORG_CODE	-- 城市公司编码
,B.CITY_ORG_NAME	-- 城市公司名称
,A.PROJ_CODE	-- 项目编码
,B.PROJ_NAME -- 项目名称
,A.STAGE_CODE	-- 分期编码
,B.STAGE_NAME -- 分期名称
,A.VERSION	-- 版本ABC动态版四版C为目标版
,A.CASH_FLOW_JY	-- 经营性现金流回正周期
,A.IRR	-- IRR
,A.GROSS_PROFIT	-- 销售毛利润万元
,A.GROSS_PROFIT_RATE	-- 销售毛利润率
,A.NETPROFIT	-- 销售净利润万元
,A.NETPROFIT_RATE	-- 销售净利润率
FROM f_opr_pro_all A
LEFT JOIN
dim_erp_mkt B ON A.PROJ_CODE = B.PROJ_CODE AND A.STAGE_CODE = B.STAGE_CODE
where 1=1
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_CODE + "')")}
and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and A.PROJ_CODE in(
select distinct b.PROJ_CODE from user_org a left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
) 
order by area_org_code,city_org_code

WITH RECURSIVE user_org as
(
select * from gfreport.fr_org where sap_dept_id in (
select dept_id from gfreport.fr_user_org
where user_id='${fr_username}')
UNION ALL
select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
B.AREA_ORG_CODE	-- 区域公司编码
,B.AREA_ORG_NAME	-- 区域公司名称
,B.CITY_ORG_CODE	-- 城市公司编码
,B.CITY_ORG_NAME	-- 城市公司名称
FROM f_opr_pro_all A
LEFT JOIN
dim_erp_mkt B ON A.PROJ_CODE = B.PROJ_CODE AND A.STAGE_CODE = B.STAGE_CODE
where area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.dim_project b on a.SAP_DEPT_ID=b.proj_code
)
order by AREA_ORG_CODE


WITH RECURSIVE user_org as
(
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT
B.AREA_ORG_CODE	-- 区域公司编码
,B.AREA_ORG_NAME	-- 区域公司名称
,B.CITY_ORG_CODE	-- 城市公司编码
,B.CITY_ORG_NAME	-- 城市公司名称
FROM f_opr_pro_all A
LEFT JOIN
dim_erp_mkt B ON A.PROJ_CODE = B.PROJ_CODE AND A.STAGE_CODE = B.STAGE_CODE
where 1=1 and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}




