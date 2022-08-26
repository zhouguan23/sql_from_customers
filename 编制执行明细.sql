with temp as(
SELECT 
ORG_ID,	-- 组织编号
SMART_TYPE,	-- 组织类型
DEPARTMENT_NAME,	-- 组织名称
SMART_SHORTNAME,	-- 组织简称
level,	-- 所属层级
SMART_CATEGORY,	-- 组织分类,1是总部，2是平台公司，3是下属公司  A是中心、B是部门、C是组
SMART_PARENTID,	-- 父节点编号
SMART_STATUS,	-- 组织状态  0：禁用   1：启用
SMART_ORDER	-- 组织排序号
FROM f_ehr_org_struc
WHERE SMART_STATUS='1' -- 组织标识为有效,无效组织无数据，不在明细中展示
AND ORG_ID   <> '50031939' -- 剔除香港区域，香港区域无数据，不在明细中展示
UNION ALL
-- 由于组织架构调整2021年1月至4月需要显示华中区域公司的数据
SELECT
ORG_ID,	-- 组织编号
SMART_TYPE,	-- 组织类型
DEPARTMENT_NAME,	-- 组织名称
SMART_SHORTNAME,	-- 组织简称
level,	-- 所属层级
SMART_CATEGORY,	-- 组织分类,1是总部，2是平台公司，3是下属公司  A是中心、B是部门、C是组
SMART_PARENTID,	-- 父节点编号
SMART_STATUS,	-- 组织状态  0：禁用   1：启用
SMART_ORDER	-- 组织排序号
FROM ipt_f_ehr_org_struc_cancel -- 人力组织属性表_历史取消组织
)



select 
A.ORG_CODE
,B.SMART_SHORTNAME
,B.SMART_ORDER
,LEVEL -- 所属层级
,PL_EMPCN -- 编制计划
,AC_EMPCN -- 在岗人数
,DIFF_EMPCN -- 空编人数
,EXC_BUDGET_RATE -- 编制执行率(在岗人数/编制计划)
from
f_ehr_org_budget_d A
INNER JOIN temp B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID
WHERE TMON = '${pDATES}'
and ORG_CODE = '${treelayer(pORG_ID,true,"\',\'")}' 
and  ORG_ID NOT IN ( '50031939','8329757152') -- 剔除香港区域
and smart_status = 1 -- 有效组织

union all 

select 
A.ORG_CODE
,B.SMART_SHORTNAME
,B.SMART_ORDER
,LEVEL -- 所属层级
,PL_EMPCN -- 编制计划
,AC_EMPCN -- 在岗人数
,DIFF_EMPCN -- 空编人数
,EXC_BUDGET_RATE -- 编制执行率(在岗人数/编制计划)
from
f_ehr_org_budget_d A
INNER JOIN temp B -- 关联此表，与下拉树统一组织名称写法
ON A.ORG_CODE =B.ORG_ID
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'
and ORG_ID NOT IN ( '50031939','8329757152') -- 剔除香港区域
and smart_status = 1 -- 有效组织

ORDER BY LEVEL,smart_order -- 顺序上先展现高层级内容



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
AND LEVEL <=4 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
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

SELECT max(W_INSERT_DT) as time FROM f_ehr_org_budget_d

