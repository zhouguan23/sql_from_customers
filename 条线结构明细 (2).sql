-- 城市和区域公司业务条线名称合并，但编码仍是分开的，故以业务条线名称分组统计

with t1 as 
(
select 
sum(EMPCN) as EMPCN -- 业务条线人数
from
f_ehr_emp_struct_d
WHERE TMON = '${pDATES}'
and P_ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'  -- 所选范围
)


, t2 as 
(
select 
BUSI_LINE_NAME -- 业务条线名称
,sum(EMPCN) as BUSI_EMPCN -- 业务条线人数
from
f_ehr_emp_struct_d
WHERE TMON = '${pDATES}'
and ORG_CODE = '${SLICEARRAY(split(pORG_ID,","),len(split(pORG_ID,",")))}'  -- 所选范围
group by BUSI_LINE_NAME
ORDER BY BUSI_LINE_NAME 
)


select 
BUSI_LINE_NAME
,BUSI_EMPCN
,BUSI_EMPCN/EMPCN as RATE
from 
t2 left join t1 on 1=1 
order by rate desc
 

SELECT max(W_INSERT_DT) as time FROM f_ehr_emp_struct_d

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


