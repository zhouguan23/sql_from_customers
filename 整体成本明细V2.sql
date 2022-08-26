 -- 整体成本
WITH T1 AS 
(
SELECT 
SUM_OVERALL_COST_UNEXP_AMT AS COST_1 -- 不含佣金
,SUM_OVERALL_BDGET_AMT AS BDGET_COST_1 -- 预算值
,ORG_CODE -- 组织ID
FROM 
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围
) -- 所选年月的全年预算值，1-所选年月实际累计值

,T2 AS 
(
select 
LEFT(TMON,4) AS YEAR
,SUM(OVERALL_COST_UNEXP_AMT) AS COST_2 -- 不含佣金
,SUM(OVERALL_BDGET_AMT) AS BDGET_COST_2 -- 预算值
,ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE  LEFT (TMON,4) = LEFT('${pDATES}',4)
and tmon <= '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围
GROUP BY LEFT(TMON,4),ORG_CODE
) -- 所选年月的1-N月累计值

,T3 AS 
(
SELECT 
OVERALL_COST_UNEXP_AMT AS COST_3 -- 不含佣金
,OVERALL_BDGET_AMT AS BDGET_COST_3 -- 预算值
,ORG_CODE -- 组织ID
FROM 
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围
) -- 所选年月值

,T4 AS 
(
select 
LEFT(TMON,4) AS YEAR
,SUM(OVERALL_COST_UNEXP_AMT) AS COST_4 -- 不含佣金实际值
,SUM(OVERALL_BDGET_AMT) AS BDGET_COST_4 -- 不含佣金预算值
,ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE  LEFT (TMON,4) = LEFT('${pDATES}',4)
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围
GROUP BY LEFT(TMON,4),ORG_CODE
) -- 所选年月全年实际累计值

,T5 AS
(
select 
TMON,
SUM_RX_COST_AMT,
ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE   TMON='${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围

)

SELECT 
T1.ORG_CODE
,B.SMART_SHORTNAME
,COST_1
,BDGET_COST_1 
,COST_2
,BDGET_COST_2 
,COST_3
,BDGET_COST_3 
,COST_4
,BDGET_COST_4 
,T5.SUM_RX_COST_AMT/10000 as SUM_RX_COST_AMT
FROM T1 
LEFT JOIN T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN T4 ON T1.ORG_CODE=T4.ORG_CODE
LEFT JOIN T5 ON T1.ORG_CODE=T5.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE=B.ORG_ID

 -- 整体成本
WITH T1 AS 
(
SELECT 
SUM_OVERALL_COST_UNEXP_AMT AS COST_1 -- 不含佣金
,SUM_OVERALL_BDGET_AMT AS BDGET_COST_1 -- 预算值
,ORG_CODE -- 组织ID
FROM 
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围子层级
) -- 所选年月的全年预算值，1-所选年月实际累计值

,T2 AS 
(
select 
LEFT(TMON,4) AS YEAR
,SUM(OVERALL_COST_UNEXP_AMT) AS COST_2 -- 不含佣金
,SUM(OVERALL_BDGET_AMT) AS BDGET_COST_2 -- 预算值
,ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE  LEFT (TMON,4) = LEFT('${pDATES}',4)
AND TMON <= '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围子层级
GROUP BY LEFT(TMON,4),ORG_CODE
) -- 所选年月的1-N月累计值


,T3 AS 
(
SELECT 
OVERALL_COST_UNEXP_AMT AS COST_3 -- 不含佣金
,OVERALL_BDGET_AMT AS BDGET_COST_3 -- 预算值
,ORG_CODE -- 组织ID
FROM 
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围子层级
) -- 所选年月固定成本

,T4 AS 
(
select 
LEFT(TMON,4) AS YEAR
,SUM(OVERALL_COST_UNEXP_AMT) AS COST_4 -- 不含佣金
,SUM(OVERALL_BDGET_AMT) AS BDGET_COST_4 -- 不含佣金预算值
,ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE  LEFT (TMON,4) = LEFT('${pDATES}',4)
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围子层级
GROUP BY LEFT(TMON,4),ORG_CODE
) -- 所选年月全年实际累计值

,T5 AS
(
select 
TMON,
SUM_RX_COST_AMT,
ORG_CODE -- 组织ID
from
f_ehr_org_cost_d -- 成本及编制分析-组织成本执行情况表
WHERE   TMON='${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}' -- 所选范围

)

SELECT 
T1.ORG_CODE
,B.SMART_SHORTNAME
,COST_1
,BDGET_COST_1 
,COST_2
,BDGET_COST_2 
,COST_3
,BDGET_COST_3 
,COST_4
,BDGET_COST_4 
,T5.SUM_RX_COST_AMT/10000 AS SUM_RX_COST_AMT
FROM T1 
LEFT JOIN T2 ON T1.ORG_CODE=T2.ORG_CODE
LEFT JOIN T3 ON T1.ORG_CODE=T3.ORG_CODE
LEFT JOIN T4 ON T1.ORG_CODE=T4.ORG_CODE
LEFT JOIN T5 ON T1.ORG_CODE=T5.ORG_CODE
INNER JOIN f_ehr_org_struc B -- 关联此表，与下拉树统一组织名称写法
ON T1.ORG_CODE=B.ORG_ID
where level <= 4 and SMART_CATEGORY IN (2,3) 
-- 子层级不显示部门级数据，如所选范围选择城市公司时，不展示城市公司下的部门级数据
and smart_status = 1 -- 有效组织
ORDER BY smart_order,org_code

SELECT max(W_INSERT_DT) as time FROM f_ehr_org_cost_d

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

