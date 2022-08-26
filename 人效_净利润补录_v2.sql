WITH T1 AS 
(select distinct the_year,the_month from dim_time
where the_year <= left(curdate(),4)
and IF(MONTH(CURDATE())>6,"1=1",the_month <> concat(left(curdate(),4),'下半年'))
) -- 取dim表半年度

, A AS (
select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
SMART_ORDER,
level
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
AND LENGTH(SMART_ORGNO_FULLPATH)= 17 -- 第一层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
SMART_ORDER,
level
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 26 -- 第二层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
SMART_ORDER,
level
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 35 -- 第三层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
SMART_ORDER,
level
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 44 -- 第四层级ID全路径长度
) -- 划分人力层级


SELECT 
distinct T1.the_month,
case 
  when level='1' then '一级组织' 
  when level='2' then '二级组织' 
  when level='3' then '三级组织' 
  when level='4' then '四级组织' 
  end as  HR_LEVEL,
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORDER,
level,
profit
from  A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_fnc_profit B
ON A.ORG_ID=B.COMPANY_ID AND T1.the_month=B.the_month 
where 1=1
${if(len(TIME) == 0,"","and T1.the_month in ('" + TIME + "')")}
${if(len(ORG_1)==0,"AND 1=0"," and ORG_ID in ('" + ORG_1 + "')")}
${if(len(LEVEL)==0,""," and HR_LEVEL in ('" + LEVEL + "')")}
UNION ALL 
SELECT 
distinct T1.the_month,
case 
  when level='1' then '一级组织' 
  when level='2' then '二级组织' 
  when level='3' then '三级组织' 
  when level='4' then '四级组织' 
  end as  HR_LEVEL,
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORDER,
level,
profit  as profit
from  A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_fnc_profit B
ON A.ORG_ID=B.COMPANY_ID AND T1.the_month=B.the_month 
where 1=1
${if(len(TIME) == 0,"","and T1.the_month in ('" + TIME + "')")}
${if(len(ORG_2)==0,"AND 1=0"," and ORG_ID in ('" + ORG_2 + "')")}
${if(len(LEVEL)==0,""," and HR_LEVEL in ('" + LEVEL + "')")}

UNION ALL
 
SELECT 
distinct T1.the_month,
case 
  when level='1' then '一级组织' 
  when level='2' then '二级组织' 
  when level='3' then '三级组织' 
  when level='4' then '四级组织' 
  end as  HR_LEVEL,
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORDER,
level,
profit  as profit
from  A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_fnc_profit B
ON A.ORG_ID=B.COMPANY_ID AND T1.the_month=B.the_month 
where 1=1
${if(len(TIME) == 0,"","and T1.the_month in ('" + TIME + "')")}
${if(len(ORG_3)==0,"AND 1=0"," and ORG_ID in ('" + ORG_3 + "')")}
${if(len(LEVEL)==0,""," and HR_LEVEL in ('" + LEVEL + "')")}

UNION ALL 

SELECT 
distinct T1.the_month,
case 
  when level='1' then '一级组织' 
  when level='2' then '二级组织' 
  when level='3' then '三级组织' 
  when level='4' then '四级组织' 
  end as  HR_LEVEL,
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORDER,
level,
profit  as profit
from  A 
 inner JOIN T1 on 1=1
 LEFT JOIN ipt_hr_fnc_profit B
ON A.ORG_ID=B.COMPANY_ID AND T1.the_month=B.the_month 
where 1=1
${if(len(TIME) == 0,"","and T1.the_month in ('" + TIME + "')")}
${if(len(ORG_4)==0,"AND 1=0"," and ORG_ID in ('" + ORG_4 + "')")}
${if(len(LEVEL)==0,""," and HR_LEVEL in ('" + LEVEL + "')")}

order by the_month,SMART_ORDER,level


select distinct the_year,year_half,the_month from dim_time
where the_year <= left(curdate(),4)
and the_month <= left(curdate(),7)

order by the_month desc

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
"一级组织" as HR_LEVEL
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
AND LENGTH(SMART_ORGNO_FULLPATH)= 17 -- 第一层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
"二级组织" as HR_LEVEL
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 26 -- 第二层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
"三级组织" as HR_LEVEL
from f_ehr_org_struc
where SMART_CATEGORY in (2,3,'B') -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 35 -- 第三层级ID全路径长度

union all 

select 
ORG_ID,
SMART_SHORTNAME,
SMART_PARENTID,
SMART_ORGNO_FULLPATH,
"四级组织" as HR_LEVEL
from f_ehr_org_struc
where SMART_CATEGORY in (2,3) -- 取华发股份及子层级ID类别
and SMART_ORGNO_FULLPATH like '%14000000%' -- 取华发股份及子层级ID
and SMART_STATUS=1 -- 组织标识为有效
and ORG_ID   <> 50031939 -- 剔除香港区域
AND LENGTH(SMART_ORGNO_FULLPATH)= 44 -- 第四层级ID全路径长度

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

