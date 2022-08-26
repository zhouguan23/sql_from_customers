WITH T1 AS 
(select distinct the_year,THE_MONTH from dim_time
where the_year < left(curdate(),4)
) -- 取dim表年份
select * from (

SELECT distinct 
T1.THE_MONTH
,ORG_ID
,SMART_SHORTNAME
,NUM 
,level
,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM `f_ehr_org_struc` A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_history_num B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 
SMART_CATEGORY in (2,3,"B")
and SMART_ORGNAME_FULLPATH like '%华发股份%'
and SMART_STATUS=1
and ORG_ID   <> 50031939
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(ORG_1)==0,"AND 1=0"," and ORG_ID in ('" + ORG_1 + "')")}


UNION ALL 

SELECT distinct 
T1.THE_MONTH
,ORG_ID
,SMART_SHORTNAME
,NUM 
,level
,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM `f_ehr_org_struc` A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_history_num B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 
SMART_CATEGORY in (2,3,"B")
and SMART_ORGNAME_FULLPATH like '%华发股份%'
and SMART_STATUS=1
and ORG_ID   <> 50031939
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(ORG_2)==0,"AND 1=0"," and ORG_ID in ('" + ORG_2 + "')")}


UNION ALL 

SELECT distinct 
T1.THE_MONTH
,ORG_ID
,SMART_SHORTNAME
,NUM 
,level
,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM `f_ehr_org_struc` A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_history_num B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 
SMART_CATEGORY in (2,3,"B")
and SMART_ORGNAME_FULLPATH like '%华发股份%'
and SMART_STATUS=1
and ORG_ID   <> 50031939
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(ORG_3)==0,"AND 1=0"," and ORG_ID in ('" + ORG_3 + "')")}


UNION ALL

SELECT distinct 
T1.THE_MONTH
,ORG_ID
,SMART_SHORTNAME
,NUM 
,level
,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM `f_ehr_org_struc` A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_history_num B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 
SMART_CATEGORY in (2,3,"B")
and SMART_ORGNAME_FULLPATH like '%华发股份%'
and SMART_STATUS=1
and ORG_ID   <> 50031939
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(ORG_4)==0,"AND 1=0"," and ORG_ID in ('" + ORG_4 + "')")}
) a
order by   the_month,SMART_ORDER


select distinct the_year,quarter_name,the_month from dim_time
where the_year < '2020'
order by the_month

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
	,SMART_ORDER
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

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID

SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
	,SMART_ORDER
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL =2 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
${if(len(ORG_1)==0," "," and SMART_PARENTID in ('" + ORG_1 + "')")}
and ORG_ID <> 50023247 -- 股份本部没人效
order by SMART_ORDER

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID

SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
	,SMART_ORGNO_FULLPATH
	,SMART_ORDER
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL =3 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
and ORG_ID   <> 50031939 -- 剔除香港区域
${if(len(ORG_2)==0," "," and SMART_PARENTID in ('" + ORG_2 + "')")}
ORDER BY SMART_ORDER

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID

SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
	,SMART_ORGNO_FULLPATH
	,SMART_ORDER
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL =4 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
${if(len(ORG_3)==0," "," and SMART_PARENTID in ('" + ORG_3 + "')")}
order by SMART_ORDER

WITH RECURSIVE user_org as
(
  select * from f_ehr_org_struc where ORG_ID in
  (
		select dept_id from fr_user_org_hr
			where user_id='${fr_username}')
  UNION ALL
  select t.* from f_ehr_org_struc t inner join user_org tcte on t.SMART_PARENTID = tcte.ORG_ID
  
) -- 递归获取用户权限下相应的组织ID


SELECT distinct
	ORG_ID -- 组织ID
	,SMART_SHORTNAME -- 组织名称
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL =1 -- 层级
and SMART_STATUS=1 -- 组织标识为有效


