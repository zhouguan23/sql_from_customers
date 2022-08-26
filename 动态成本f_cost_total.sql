WITH RECURSIVE user_org as
(
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
AREA_ORG_CODE	-- 区域编码
,AREA_ORG_NAME	-- 区域名称
,CITY_ORG_CODE	-- 城市编码
,CITY_ORG_NAME	-- 城市名称
,PROJ_CODE	-- 项目编码
,PROJ_NAME	-- 项目名称
,STAGE_CODE	-- 分期编码
,STAGE_NAME	-- 分期名称
,DC_OBJ_COST_AMT	-- 目标成本金额（含税）
,DC_DYN_COST_AMT	-- 动态成本金额（含税）
,DC_DIFF_RATE_AMT	-- 动态成本偏差率
,DC_PROJ_VISA_AMT	-- 变更签证总额(含税)
,CONTRACT_AMT	-- 合同总金额(含税)
,PAY_AMT	-- 付款总金额

FROM f_cost_total
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
and PROJ_CODE in(
select distinct b.PROJ_CODE from user_org a left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
) 

WITH RECURSIVE user_org as
(
select * from gfreport.fr_org where sap_dept_id in (
select dept_id from gfreport.fr_user_org
where user_id='${fr_username}')
UNION ALL
select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
AREA_ORG_CODE	-- 区域编码
,AREA_ORG_NAME	-- 区域名称
FROM f_cost_total
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
AREA_ORG_CODE	-- 区域编码
,AREA_ORG_NAME	-- 区域名称
,CITY_ORG_CODE	-- 城市编码
,CITY_ORG_NAME	-- 城市名称

FROM f_cost_total
where 1=1 and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}



