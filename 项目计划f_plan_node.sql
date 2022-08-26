WITH RECURSIVE user_org as
(
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
AREA_ORG_CODE	-- 区域公司编码
,AREA_ORG_NAME	-- 区域公司名称
,CITY_ORG_CODE	-- 城市公司编码
,CITY_ORG_NAME	-- 城市公司名称
,PROJ_CODE	-- 项目编码
,PROJ_NAME	-- 项目名称
,STAGE_CODE	-- 分期编码
,STAGE_NAME	-- 分期名称
,ND_CODE	-- 节点编号
,ND_NAME	-- 节点名称
,BATCH_CODE	-- 批次编码
,BATCH_NAME	-- 批次名称
,LIGHT_STATUS_CODE	-- 状态灯编码
,LIGHT_STATUS_NAME	-- 状态灯名称
,PLAN_EDATE -- 批次计划节点计划完成日期
,AC_EDATE -- 批次计划节点实际完成日期
,BUILD_CODE_RANGE	-- 楼栋编码范围
,BUILD_NAME_RANGE	-- 楼栋名称范围
,EXBUILD_FLAG	-- 楼栋展开标识
FROM f_plan_node
where
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
) 
and 1=1
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_CODE + "')")}
${if(len(PROJ_CODE) == 0,"","and PROJ_CODE in ('" + PROJ_CODE + "')")}
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
AREA_ORG_CODE	-- 区域公司编码
,AREA_ORG_NAME	-- 区域公司名称
FROM f_plan_node
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
AREA_ORG_CODE	-- 区域公司编码
,AREA_ORG_NAME	-- 区域公司名称
,CITY_ORG_CODE	-- 城市公司编码
,CITY_ORG_NAME	-- 城市公司名称
FROM f_plan_node
where 1=1 and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}





WITH RECURSIVE user_org as
(
  select * from gfreport.fr_org where sap_dept_id in (
		select dept_id from gfreport.fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from gfreport.fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT
AREA_ORG_CODE	-- 区域公司编码
,AREA_ORG_NAME	-- 区域公司名称
,CITY_ORG_CODE	-- 城市公司编码
,CITY_ORG_NAME	-- 城市公司名称
,PROJ_CODE	-- 项目编码
,PROJ_NAME	-- 项目名称
FROM f_plan_node
where
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join gfreport.fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and proj_code in(
select distinct b.PROJ_CODE from user_org a left join gfreport.fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
) 
and 1=1
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and CITY_ORG_CODE in ('" + CITY_ORG_CODE + "')")}
order by area_org_code,city_org_code


