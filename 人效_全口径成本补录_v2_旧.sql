WITH T1 AS 
(select distinct the_year,year_half from dim_time
where the_year < left(curdate(),4)
) -- 取dim表半年度

SELECT distinct T1.year_half,ORG_ID,SMART_SHORTNAME,
COST/10000 as COST,SMART_ORGNO_FULLPATH,SMART_ORDER
 FROM `f_ehr_org_struc` A 
 inner JOIN T1 on 1=1
 LEFT JOIN  ipt_hr_efficiency_cost_copy1 B
ON A.ORG_ID=B.COMPANY_ID AND T1.year_half=B.year_half
where SMART_CATEGORY in (2,3) -- 取相应层级类别,含股份本部各部门
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
${if(len(TIME) == 0,"","and T1.year_half in ('" + TIME + "')")}
${if(len(ORG_ID)==0,""," and ORG_ID in ("+"'"+treelayer(ORG_ID,true,"\',\'")+"'"+")")}

order by T1.year_half,SMART_ORDER,SMART_ORGNO_FULLPATH


select distinct the_year,year_half from dim_time
where the_year < left(curdate(),4)

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
order by level,SMART_ORDER

