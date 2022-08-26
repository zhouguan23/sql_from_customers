  -- 中高层上年度数据从2021年开始可从系统获取（即2020年数据起），2020年之前从补录数据获取；
${if(LEFT(pDATES,4) > 2020,"","/*")}

with AC_BUSI_PARENT AS 
(
select 
ORG_CODE
,BUSI_EMPCN AS 业务人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级业务人数


,AC_FUNC_PARENT AS 
(
select 
ORG_CODE
,FUNC_EMPCN AS 职能人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级职能人数

, AC_RATE_PARENT AS 
(
select
T1.ORG_CODE
,业务人数/职能人数 as 业务职能比实际值
from
AC_BUSI_PARENT T1 
LEFT JOIN AC_FUNC_PARENT T2 
ON T1.ORG_CODE = T2.ORG_CODE 
) -- 所选层级业务职能比实际占比

, PL_PARENT AS 
(
select 
A.ORG_CODE
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
${if(SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50023969'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='14440000'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50018136'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50020639'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50022333'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50024301'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50024304'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50086104',",C.TARGET_VALUE AS PL_BUSI_FUNC_RATE",",PL_BUSI_FUNC_RATE")} -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
f_ehr_org_budget_d A
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID 
LEFT JOIN(
SELECT 
TYEAR, -- 年度
ORG_CODE, -- 组织ID
ORG_NAME, -- 组织名称
IDX_CODE, -- 指标ID
IDX_NAME, -- 指标名称
TARGET_VALUE -- 目标值
FROM ipt_ehr_org_effi_m
WHERE IDX_CODE='999999' AND TYEAR=LEFT('${pDATES}',4)
) C ON A.ORG_CODE = C.ORG_CODE
WHERE TMON = '${pDATES}'
and A.ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围数据
) -- 所选层级目标值、目标占比及上年度中高层实际占比


,AC_BUSI AS 
(
select 
ORG_CODE
,BUSI_EMPCN AS 业务人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级业务人数


,AC_FUNC AS 
(
select 
ORG_CODE
,FUNC_EMPCN AS 职能人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级职能人数

, AC_RATE AS 
(
select
T1.ORG_CODE
,业务人数/职能人数 as 业务职能比实际值
from
AC_BUSI T1 
LEFT JOIN AC_FUNC T2 
ON T1.ORG_CODE = T2.ORG_CODE 
) -- 所选层级子层级业务职能比实际占比


, PL AS 
(
select 
A.ORG_CODE
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
${if(SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))="50023969"||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='14000000',",C.TARGET_VALUE AS PL_BUSI_FUNC_RATE",",PL_BUSI_FUNC_RATE")} -- 中高层目标占比,选房产主业时使用补录数据 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
f_ehr_org_budget_d A
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID 
LEFT JOIN(
SELECT 
TYEAR, -- 年度
ORG_CODE, -- 组织ID
ORG_NAME, -- 组织名称
IDX_CODE, -- 指标ID
IDX_NAME, -- 指标名称
TARGET_VALUE -- 目标值
FROM ipt_ehr_org_effi_m
WHERE IDX_CODE='999999' AND TYEAR=LEFT('${pDATES}',4)
) C ON A.ORG_CODE = C.ORG_CODE
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级目标值、目标占比及上年度中高层实际占比


SELECT 
T1.ORG_CODE
,B.level -- 所属层级
,B.SMART_SHORTNAME -- 名称
,B.smart_order
,业务人数
,职能人数
,业务职能比实际值
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
AC_BUSI T1 
LEFT JOIN AC_FUNC T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN AC_RATE T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN PL T4 ON T1.ORG_CODE=T4.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE =B.ORG_ID 
where level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
and SMART_STATUS =1 -- 有效组织

UNION ALL 

SELECT 
T1.ORG_CODE
,B.level -- 所属层级
,B.SMART_SHORTNAME -- 名称
,B.smart_order
,业务人数
,职能人数
,业务职能比实际值
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
AC_BUSI_PARENT T1 
LEFT JOIN AC_FUNC_PARENT T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN AC_RATE_PARENT T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN PL_PARENT T4 ON T1.ORG_CODE=T4.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE =B.ORG_ID 
WHERE SMART_STATUS =1 -- 有效组织

ORDER BY LEVEL,smart_order

${if(LEFT(pDATES,4) > 2020,"","*/")}


${if(LEFT(pDATES,4) <= 2020,"","/*")}
with AC_BUSI_PARENT AS 
(
select 
ORG_CODE
,BUSI_EMPCN AS 业务人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级业务人数


,AC_FUNC_PARENT AS 
(
select 
ORG_CODE
,FUNC_EMPCN AS 职能人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级职能人数

, AC_RATE_PARENT AS 
(
select
T1.ORG_CODE
,业务人数/职能人数 as 业务职能比实际值
from
AC_BUSI_PARENT T1 
LEFT JOIN AC_FUNC_PARENT T2 
ON T1.ORG_CODE = T2.ORG_CODE 
) -- 所选层级业务职能比实际占比

, PL_PARENT AS 
(
select 
ORG_CODE
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
FROM 
f_ehr_org_budget_d A
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID 
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围数据
) -- 所选层级目标值、目标占比及上年度中高层实际占比

,LAST_RATE_PARENT as 
(
select 
COMPANY_ID AS ORG_CODE 
,FUN_OPE_RATE AS LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度业务职能比
FROM ipt_hr_manage_and_operation A -- 相关补录数据底表
WHERE YEAR = left('${pDATES}',4)-1
and COMPANY_ID = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围数据
) -- 上年度业务职能比

,AC_BUSI AS 
(
select 
ORG_CODE
,BUSI_EMPCN AS 业务人数 
FROM 
f_ehr_org_emp_d 
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级业务人数


,AC_FUNC AS 
(
select 
ORG_CODE
,FUNC_EMPCN AS 职能人数 
FROM 
f_ehr_org_emp_d
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级职能人数

, AC_RATE AS 
(
select
T1.ORG_CODE
,业务人数/职能人数 as 业务职能比实际值
from
AC_BUSI T1 
LEFT JOIN AC_FUNC T2 
ON T1.ORG_CODE = T2.ORG_CODE 
) -- 所选层级子层级业务职能比实际占比


, PL AS 
(
select 
ORG_CODE
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
FROM 
f_ehr_org_budget_d A
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID 
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
) -- 所选层级子层级目标值、目标占比

,LAST_RATE as 
(
select 
COMPANY_ID AS ORG_CODE 
,FUN_OPE_RATE AS LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度业务职能比
FROM ipt_hr_manage_and_operation A -- 相关补录数据底表
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
on A.COMPANY_ID=B.ORG_ID
WHERE YEAR = left('${pDATES}',4)-1
and B.SMART_PARENTID = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围数据
and level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
) -- 上年度业务职能比

SELECT 
T1.ORG_CODE
,B.level -- 所属层级
,B.SMART_SHORTNAME -- 名称
,B.smart_order
,业务人数
,职能人数
,业务职能比实际值
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
AC_BUSI T1 
LEFT JOIN AC_FUNC T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN AC_RATE T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN PL T4 ON T1.ORG_CODE=T4.ORG_CODE
LEFT JOIN LAST_RATE T5 ON T1.ORG_CODE=T5.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE =B.ORG_ID 
where level <= 4 -- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
and SMART_STATUS =1 -- 有效组织

UNION ALL 

SELECT 
T1.ORG_CODE
,B.level -- 所属层级
,B.SMART_SHORTNAME -- 名称
,B.smart_order
,业务人数
,职能人数
,业务职能比实际值
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
,PL_BUSI_FUNC_RATE -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
AC_BUSI_PARENT T1 
LEFT JOIN AC_FUNC_PARENT T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN AC_RATE_PARENT T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN PL_PARENT T4 ON T1.ORG_CODE=T4.ORG_CODE
LEFT JOIN LAST_RATE_PARENT T5 ON T1.ORG_CODE=T5.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE =B.ORG_ID 
WHERE SMART_STATUS =1 -- 有效组织
ORDER BY LEVEL,smart_order
${if(LEFT(pDATES,4) <= 2020,"","*/")}

SELECT max(W_INSERT_DT) as time FROM f_ehr_org_emp_d

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID

, TEMP AS (
SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
	,SMART_PARENTID -- 组织父ID
	,LEVEL -- 组织所属层级
	,SMART_ORGNO_FULLPATH
	,smart_order
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL in (2,3,4) -- 第二至四层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_ORGNO_FULLPATH like '%50023969%' -- 该页面仅房产主业数据
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
and ORG_ID <> 50031939 -- 剔除香港区域
ORDER BY LEVEL
) -- 获得用户权限下，生成下拉树的所需字段，但下一步需要清空根节点的父ID 

SELECT 
ORG_ID
,SMART_SHORTNAME
,CASE WHEN LEVEL = (SELECT DISTINCT MIN(LEVEL) FROM TEMP ) THEN REPLACE(SMART_PARENTID,SMART_PARENTID,"") 
ELSE SMART_PARENTID END AS SMART_PARENTID -- 将根节点（即所属层级为当前最小值的组织ID）其父ID清空，保证下拉树的形式正确及传参正常
FROM TEMP
order by level,smart_order


select 
A.ORG_CODE
,PL_BUSI_EMPCN -- 业务人数目标值
,PL_FUNC_EMPCN -- 职能人数目标值
${if(SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='14440000'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50018136'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50020639'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50022333'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50024301'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50024304'||SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))='50086104',",C.TARGET_VALUE AS PL_BUSI_FUNC_RATE",",PL_BUSI_FUNC_RATE")} -- 业务职能比目标值 
,LAST_YEAR_AC_BUSI_FUNC_RATE -- 上年度实际值
FROM 
f_ehr_org_budget_d A
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID 
LEFT JOIN(
SELECT 
TYEAR, -- 年度
ORG_CODE, -- 组织ID
ORG_NAME, -- 组织名称
IDX_CODE, -- 指标ID
IDX_NAME, -- 指标名称
TARGET_VALUE -- 目标值
FROM ipt_ehr_org_effi_m
WHERE IDX_CODE='999999' AND TYEAR=LEFT('${pDATES}',4)
) C ON A.ORG_CODE = C.ORG_CODE
WHERE TMON = '${pDATES}'
and A.ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围数据

