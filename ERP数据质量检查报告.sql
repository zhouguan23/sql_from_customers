SELECT DISTINCT DATUM as time FROM F_ERP_DATA_CHECK

WITH RECURSIVE USER_ORG AS -- 用户权限设置
( 
  SELECT * FROM FR_ORG WHERE SAP_DEPT_ID IN (
		SELECT DEPT_ID FROM FR_USER_ORG
			WHERE USER_ID='${fine_username}')
  UNION ALL
  SELECT T.* FROM FR_ORG T INNER JOIN USER_ORG TCTE ON T.SAP_PARENT_ID = TCTE.SAP_DEPT_ID
),
DATE_CHECK AS( -- 找出每个项目分期不同指标的最新修改时间
SELECT 
 AREA	-- 区域
,CITY	-- 所属城市
,PROJECT_NO	-- 项目编号
,STAGE_NO	-- 分期编号
,BUKRS	-- 公司代码
,CASE WHEN INDICATORS = '10' THEN '目标成本未录入'
 WHEN INDICATORS = '20' THEN '动态成本异常'
 WHEN INDICATORS = '30' THEN '主数据异常'
 WHEN INDICATORS = '40' THEN '二级开发计划异常'
 ELSE '' END INDICATORS_NAME
,INDICATORS	-- 数据质量自查指标项
,PROBLEM_DOC_NUM	-- 问题单据数
,PROBLEM_DESC	-- 问题描述
,DATUM	-- 记录建立日期
,RANK() OVER (PARTITION BY AREA,CITY,PROJECT_NO,STAGE_NO,INDICATORS ORDER BY DATUM DESC) NUMBER -- 相同项目分期和数据质量自查指标都相同通过分组排序只取最新的一条。
FROM F_ERP_DATA_CHECK
)
SELECT 
 ${ IF(INARRAY("1", SPLIT(SHOW, ",")) = 0,"","A.AREA,B.AREA_ORG_NAME," ) } 
 ${ IF(INARRAY("2", SPLIT(SHOW, ",")) = 0,"","A.CITY,B.CITY_ORG_NAME," ) }
 ${ IF(INARRAY("3", SPLIT(SHOW, ",")) = 0,"","A.PROJECT_NO,B.PROJ_NAME," ) }
 ${ IF(INARRAY("4", SPLIT(SHOW, ",")) = 0,"","A.STAGE_NO,B.STAGE_NAME," ) }
 INDICATORS_NAME -- 数据质量自查指标项名称
,A.INDICATORS-- 数据质量自查指标项
-- ,A.DATUM -- 记录建立日期
,SUM(A.PROBLEM_DOC_NUM) AS PROBLEM_DOC_NUM -- 问题单据数
FROM DATE_CHECK A 
LEFT JOIN(
SELECT DISTINCT
AREA_ORG_CODE -- 区域公司编码
,AREA_ORG_NAME -- 区域公司名称
,CITY_ORG_CODE -- 城市公司编码
,CITY_ORG_NAME -- 城市公司名称
,PROJ_CODE -- 项目编码
,PROJ_NAME -- 项目名称
,STAGE_CODE -- 分期编码
,STAGE_NAME -- 分期名称
FROM DIM_STAGING
WHERE PERIOD_WID=(SELECT MAX(PERIOD_WID) FROM DIM_STAGING) -- 取最新分区
) B 
ON A.AREA = B.AREA_ORG_CODE
AND A.CITY = B.CITY_ORG_CODE
AND A.PROJECT_NO = B.PROJ_CODE
AND A.STAGE_NO = B.STAGE_CODE
WHERE
A.NUMBER = 1 AND A.PROBLEM_DOC_NUM>0 AND
A.AREA IN( -- 区域权限
SELECT  DISTINCT B.AREA_ORG_CODE FROM USER_ORG A  LEFT JOIN FR_PO_PRIV  B ON A.SAP_DEPT_ID=B.PROJ_CODE
)
AND A.CITY IN( -- 城市公司权限
SELECT DISTINCT B.CITY_ORG_CODE FROM USER_ORG A  LEFT JOIN FR_PO_PRIV B ON A.SAP_DEPT_ID=B.PROJ_CODE
)
AND A.PROJECT_NO IN( -- 项目权限
SELECT DISTINCT B.PROJ_CODE FROM USER_ORG A LEFT JOIN FR_PO_PRIV B ON A.SAP_DEPT_ID=B.PROJ_CODE 
)
${IF(LEN(AREA_ORG_CODE) == 0,"","AND A.AREA IN ('" + AREA_ORG_CODE + "')")}
${IF(LEN(CITY_ORG_CODE) == 0,"","AND A.CITY IN ('" + CITY_ORG_CODE + "')")}
${IF(LEN(PROJ_CODE) == 0,"","AND A.PROJECT_NO IN ('" + PROJ_CODE + "')")}
${IF(LEN(STAGE_CODE) == 0,"","AND A.STAGE_NO IN ('" + STAGE_CODE + "')")}
${IF(LEN(INDICATORS) == 0,"","AND A.INDICATORS IN ('" + INDICATORS + "')")}
GROUP BY 
${ IF(INARRAY("1", SPLIT(SHOW, ",")) = 0,"","A.AREA,B.AREA_ORG_NAME," ) } 
${ IF(INARRAY("2", SPLIT(SHOW, ",")) = 0,"","A.CITY,B.CITY_ORG_NAME," ) }
${ IF(INARRAY("3", SPLIT(SHOW, ",")) = 0,"","A.PROJECT_NO,B.PROJ_NAME," ) }
${ IF(INARRAY("4", SPLIT(SHOW, ",")) = 0,"","A.STAGE_NO,B.STAGE_NAME," ) } 
A.INDICATORS,INDICATORS_NAME
ORDER BY A.AREA,A.CITY



WITH RECURSIVE user_org as -- 用户权限设置
( 
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
MAX_TIME AS( -- 找出每个项目分期不同指标的最新修改时间
SELECT
AREA	-- 区域
,CITY	-- 所属城市
,PROJECT_NO	-- 项目编号
,STAGE_NO	-- 分期编号
,BUKRS	-- 公司代码
,INDICATORS	-- 数据质量自查指标项
,MAX(DATUM) AS DATUM	-- 记录建立日期
FROM f_erp_data_check
group by AREA,CITY,PROJECT_NO,STAGE_NO,BUKRS,BUKRS,INDICATORS
)
SELECT 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","A.AREA,B.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","A.CITY,B.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","A.PROJECT_NO,B.PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","A.STAGE_NO,B.STAGE_NAME," ) }
CASE WHEN A.INDICATORS = '10' THEN '目标成本未录入'
 WHEN A.INDICATORS = '20' THEN '动态成本异常'
 WHEN A.INDICATORS = '30' THEN '主数据异常'
 WHEN A.INDICATORS = '40' THEN '二级开发计划异常'
 ELSE '' END INDICATORS_NAME
,A.INDICATORS-- 数据质量自查指标项
-- ,A.DATUM -- 记录建立日期
,SUM(A.PROBLEM_DOC_NUM) AS PROBLEM_DOC_NUM -- 问题单据数
FROM F_ERP_DATA_CHECK A 
LEFT JOIN(
SELECT DISTINCT
AREA_ORG_CODE -- 区域公司编码
,AREA_ORG_NAME -- 区域公司名称
,CITY_ORG_CODE -- 城市公司编码
,CITY_ORG_NAME -- 城市公司名称
,PROJ_CODE -- 项目编码
,PROJ_NAME -- 项目名称
,STAGE_CODE -- 分期编码
,STAGE_NAME -- 分期名称
FROM DIM_STAGING
WHERE PERIOD_WID='2021-05'
) B 
ON A.AREA = B.AREA_ORG_CODE
AND A.CITY = B.CITY_ORG_CODE
AND A.PROJECT_NO = B.PROJ_CODE
AND A.STAGE_NO = B.STAGE_CODE
/*INNER JOIN MAX_TIME C -- 项目分期每个指标最新时间
ON A.AREA = C.AREA
AND A.CITY = C.CITY
AND A.PROJECT_NO = C.PROJECT_NO
AND A.STAGE_NO = C.STAGE_NO
AND A.DATUM = C.DATUM*/
WHERE
A.AREA IN( -- 区域权限
SELECT  DISTINCT B.AREA_ORG_CODE FROM USER_ORG A  LEFT JOIN FR_PO_PRIV  B ON A.SAP_DEPT_ID=B.PROJ_CODE
)
AND A.CITY IN( -- 城市公司权限
SELECT DISTINCT B.CITY_ORG_CODE FROM USER_ORG A  LEFT JOIN FR_PO_PRIV B ON A.SAP_DEPT_ID=B.PROJ_CODE
)
AND A.PROJECT_NO IN( -- 项目权限
SELECT DISTINCT B.PROJ_CODE FROM USER_ORG A LEFT JOIN FR_PO_PRIV B ON A.SAP_DEPT_ID=B.PROJ_CODE 
) AND PROBLEM_DOC_NUM>0
${if(len(AREA_ORG_CODE) == 0,"","and A.AREA in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and A.CITY in ('" + CITY_ORG_CODE + "')")}
${if(len(PROJ_CODE) == 0,"","and A.PROJECT_NO in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and A.STAGE_NO in ('" + STAGE_CODE + "')")}
${if(len(INDICATORS) == 0,"","and A.INDICATORS in ('" + INDICATORS + "')")}
GROUP BY 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","A.AREA,B.AREA_ORG_NAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","A.CITY,B.CITY_ORG_NAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","A.PROJECT_NO,B.PROJ_NAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","A.STAGE_NO,B.STAGE_NAME," ) } 
A.INDICATORS,INDICATORS_NAME



WITH RECURSIVE user_org as
(
select * from fr_org where sap_dept_id in (
select dept_id from fr_user_org
where user_id='${fr_username}')
UNION ALL
select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT distinct
AREA_ORG_NAME,AREA_ORG_CODE
FROM DIM_PROJECT
where area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)
order by AREA_ORG_CODE

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct CITY_ORG_NAME,CITY_ORG_CODE
FROM DIM_PROJECT
where 1=1 and 
area_org_code in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA_ORG_CODE) == 0,"","and AREA_ORG_CODE in ('" + AREA_ORG_CODE + "')")}


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fr_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT 
distinct	A.PROJECT_NO,B.PROJ_NAME
FROM F_ERP_DATA_CHECK A 
LEFT JOIN(
SELECT DISTINCT
AREA_ORG_CODE -- 区域公司编码
,AREA_ORG_NAME -- 区域公司名称
,CITY_ORG_CODE -- 城市公司编码
,CITY_ORG_NAME -- 城市公司名称
,PROJ_CODE -- 项目编码
,PROJ_NAME -- 项目名称
,STAGE_CODE -- 分期编码
,STAGE_NAME -- 分期名称
FROM DIM_STAGING
WHERE PERIOD_WID = (SELECT MAX(PERIOD_WID) FROM DIM_STAGING)
) B ON A.PROJECT_NO = B.PROJ_CODE
where 1=1 
and 
A.AREA in(
select distinct b.AREA_ORG_CODE from user_org a  left join fr_po_priv  b on a.SAP_DEPT_ID=b.proj_code
)
and A.CITY in(
select distinct b.CITY_ORG_CODE from user_org a  left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code
)
and A.PROJECT_NO in(
select distinct b.PROJ_CODE from user_org a left join fr_po_priv b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA_ORG_CODE) == 0,"","and A.AREA in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and A.CITY in ('" + CITY_ORG_CODE + "')")}


SELECT 
distinct	A.STAGE_NO -- 分期编号
,B.STAGE_NAME -- 分期名称
FROM F_ERP_DATA_CHECK A 
LEFT JOIN(
SELECT DISTINCT
AREA_ORG_CODE -- 区域公司编码
,AREA_ORG_NAME -- 区域公司名称
,CITY_ORG_CODE -- 城市公司编码
,CITY_ORG_NAME -- 城市公司名称
,PROJ_CODE -- 项目编码
,PROJ_NAME -- 项目名称
,STAGE_CODE -- 分期编码
,STAGE_NAME -- 分期名称
FROM DIM_STAGING
WHERE PERIOD_WID = (SELECT MAX(PERIOD_WID) FROM DIM_STAGING)
) B ON A.STAGE_NO = B.STAGE_CODE
where 1=1 
${if(len(AREA_ORG_CODE) == 0,"","and A.AREA in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and A.CITY in ('" + CITY_ORG_CODE + "')")}
${if(len(PROJ_CODE) == 0,"","and A.PROJECT_NO in ('" + PROJ_CODE + "')")}


SELECT DISTINCT
A.INDICATORS,
CASE WHEN A.INDICATORS = '10' THEN '目标成本未录入'
 WHEN A.INDICATORS = '20' THEN '动态成本异常'
 WHEN A.INDICATORS = '30' THEN '主数据异常'
 WHEN A.INDICATORS = '40' THEN '二级开发计划异常'
 ELSE '' END INDICATORS_NAME -- 数据质量自查指标项
FROM F_ERP_DATA_CHECK A 
WHERE 1=1
${if(len(AREA_ORG_CODE) == 0,"","and A.AREA in ('" + AREA_ORG_CODE + "')")}
${if(len(CITY_ORG_CODE) == 0,"","and A.CITY in ('" + CITY_ORG_CODE + "')")}
${if(len(PROJ_CODE) == 0,"","and A.PROJECT_NO in ('" + PROJ_CODE + "')")}
${if(len(STAGE_CODE) == 0,"","and A.STAGE_NO in ('" + STAGE_CODE + "')")}



WITH RECURSIVE USER_ORG AS -- 用户权限设置
( 
  SELECT * FROM FR_ORG WHERE SAP_DEPT_ID IN (
		SELECT DEPT_ID FROM FR_USER_ORG
			WHERE USER_ID='${fine_username}')
  UNION ALL
  SELECT T.* FROM FR_ORG T INNER JOIN USER_ORG TCTE ON T.SAP_PARENT_ID = TCTE.SAP_DEPT_ID
),
DATE_CHECK AS( -- 找出每个项目分期不同指标的最新修改时间
SELECT 
 AREA	-- 区域
,CITY	-- 所属城市
,PROJECT_NO	-- 项目编号
,STAGE_NO	-- 分期编号
,BUKRS	-- 公司代码
,CASE WHEN INDICATORS = '10' THEN '目标成本未录入'
 WHEN INDICATORS = '20' THEN '动态成本异常'
 WHEN INDICATORS = '30' THEN '主数据异常'
 WHEN INDICATORS = '40' THEN '二级开发计划异常'
 ELSE '' END INDICATORS_NAME
,INDICATORS	-- 数据质量自查指标项
,PROBLEM_DOC_NUM	-- 问题单据数
,PROBLEM_DESC	-- 问题描述
,DATUM	-- 记录建立日期
,RANK() OVER (PARTITION BY AREA,CITY,PROJECT_NO,STAGE_NO,INDICATORS ORDER BY DATUM DESC) NUMBER -- 相同项目分期和数据质量自查指标都相同通过分组排序只取最新的一条。
FROM F_ERP_DATA_CHECK
)
SELECT 
A.AREA,B.AREA_ORG_NAME,
A.CITY,B.CITY_ORG_NAME,
A.PROJECT_NO,B.PROJ_NAME,
A.STAGE_NO,B.STAGE_NAME,
 INDICATORS_NAME -- 数据质量自查指标项名称
,A.INDICATORS-- 数据质量自查指标项
-- ,A.DATUM -- 记录建立日期
,number
FROM DATE_CHECK A 
LEFT JOIN(
SELECT DISTINCT
AREA_ORG_CODE -- 区域公司编码
,AREA_ORG_NAME -- 区域公司名称
,CITY_ORG_CODE -- 城市公司编码
,CITY_ORG_NAME -- 城市公司名称
,PROJ_CODE -- 项目编码
,PROJ_NAME -- 项目名称
,STAGE_CODE -- 分期编码
,STAGE_NAME -- 分期名称
FROM DIM_STAGING
WHERE PERIOD_WID=(SELECT MAX(PERIOD_WID) FROM DIM_STAGING) -- 取最新分区
) B 
ON A.AREA = B.AREA_ORG_CODE
AND A.CITY = B.CITY_ORG_CODE
AND A.PROJECT_NO = B.PROJ_CODE
AND A.STAGE_NO = B.STAGE_CODE
WHERE
A.NUMBER = 1 AND A.PROBLEM_DOC_NUM>0




