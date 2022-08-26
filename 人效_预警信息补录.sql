select distinct the_year,quarter_name from dim_time
where the_year = left(curdate(),4)




WITH T1 AS 
(select distinct the_year,quarter_name from dim_time
where the_year = left(curdate(),4)
) -- 取dim表季度

select * from(
SELECT 
distinct 
T1.quarter_name,
ORG_ID,
SMART_SHORTNAME,
T2.INDEX_NAME,
WARN_TYPE,
WARN_REASON,SMART_ORDER
from f_ehr_org_struc A
 inner JOIN T1 on 1=1
 inner join ipt_hr_dim_market_type T2 on 1=1 -- 取指标名称 
 LEFT JOIN ipt_hr_warn B
on A.ORG_ID=B.COMPANY_ID AND T1.quarter_name=B.quarter AND T2.INDEX_NAME=B.INDEX_NAME -- 关联得到预警灯信息
where 1=1
${if(len(TIME) == 0,"","and T1.quarter_name in ('" + TIME + "')")}
${if(len(ORG_1)==0,"AND 1=0"," and ORG_ID in ('" + ORG_1 + "')")}
${if(len(INDEX)==0,""," and T2.INDEX_NAME in ('" + INDEX + "')")}
UNION ALL 

SELECT 
distinct 
T1.quarter_name,
ORG_ID,
SMART_SHORTNAME,
T2.INDEX_NAME,
WARN_TYPE,
WARN_REASON,SMART_ORDER
from f_ehr_org_struc A
 inner JOIN T1 on 1=1
 inner join ipt_hr_dim_market_type T2 on 1=1 -- 取指标名称 
 LEFT JOIN ipt_hr_warn B
on A.ORG_ID=B.COMPANY_ID AND T1.quarter_name=B.quarter AND T2.INDEX_NAME=B.INDEX_NAME -- 关联得到预警灯信息
where 1=1
${if(len(TIME) == 0,"","and T1.quarter_name in ('" + TIME + "')")}
${if(len(ORG_2)==0,"AND 1=0"," and ORG_ID in ('" + ORG_2 + "')")}
${if(len(INDEX)==0,""," and T2.INDEX_NAME in ('" + INDEX + "')")}
UNION ALL 

SELECT 
distinct 
T1.quarter_name,
ORG_ID,
SMART_SHORTNAME,
T2.INDEX_NAME,
WARN_TYPE,
WARN_REASON,SMART_ORDER
from f_ehr_org_struc A
 inner JOIN T1 on 1=1
 inner join ipt_hr_dim_market_type T2 on 1=1 -- 取指标名称 
 LEFT JOIN ipt_hr_warn B
on A.ORG_ID=B.COMPANY_ID AND T1.quarter_name=B.quarter AND T2.INDEX_NAME=B.INDEX_NAME -- 关联得到预警灯信息
where 1=1
${if(len(TIME) == 0,"","and T1.quarter_name in ('" + TIME + "')")}
${if(len(ORG_3)==0,"AND 1=0"," and ORG_ID in ('" + ORG_3 + "')")}
${if(len(INDEX)==0,""," and T2.INDEX_NAME in ('" + INDEX + "')")}
UNION ALL 

SELECT 
distinct 
T1.quarter_name,
ORG_ID,
SMART_SHORTNAME,
T2.INDEX_NAME,
WARN_TYPE,
WARN_REASON,SMART_ORDER
from f_ehr_org_struc A
 inner JOIN T1 on 1=1
 inner join ipt_hr_dim_market_type T2 on 1=1 -- 取指标名称 
 LEFT JOIN ipt_hr_warn B
on A.ORG_ID=B.COMPANY_ID AND T1.quarter_name=B.quarter AND T2.INDEX_NAME=B.INDEX_NAME -- 关联得到预警灯信息
where 1=1
${if(len(TIME) == 0,"","and T1.quarter_name in ('" + TIME + "')")}
${if(len(ORG_4)==0,"AND 1=0"," and ORG_ID in ('" + ORG_4 + "')")}
${if(len(INDEX)==0,""," and T2.INDEX_NAME in ('" + INDEX + "')")}  ) aa
order by quarter_name,INDEX_NAME,SMART_ORDER

select mkt_type from ipt_hr_dim_market_type


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
AND LEVEL =2 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
${if(len(ORG_1)==0," "," and SMART_PARENTID in ('" + ORG_1 + "')")}
and ORG_ID <> 50023247 -- 股份本部没人效


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
ORDER BY SMART_ORDER

select * from ipt_hr_dim_market_type
order by index_code

