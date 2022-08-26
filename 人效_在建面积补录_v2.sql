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
and SMART_PARENTID = 50023969 -- 房产主业
${if(len(PARENT)==0," "," and SMART_PARENTID in ('" + PARENT + "')")}
and ORG_ID   <> 50031939 -- 剔除香港区域
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
and SMART_ORGNO_FULLPATH like '%50023969%' -- 取房产主业及子层级ID
${if(len(AREA)==0," "," and SMART_PARENTID in ('" + AREA + "')")}
ORDER BY SMART_ORDER

WITH T1 AS 
(select distinct the_year,the_month from dim_time
where the_year <= left(curdate(),4)
) -- 取dim表年份

SELECT DISTINCT T1.THE_MONTH,ORG_ID,SMART_SHORTNAME,
CONST_AREA  as CONST_AREA -- 在建面积（操盘+代建）
,CONST_AREA_JOINT  as CONST_AREA_JOINT -- 包含联合操盘在建面积
,LEVEL,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM f_ehr_org_struc A 
inner JOIN T1 on 1=1
LEFT JOIN ipt_hr_const_area B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 1=1
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(PARENT)==0,"AND 1=0"," and ORG_ID in ('" + PARENT + "')")}

UNION ALL

SELECT DISTINCT T1.THE_MONTH,ORG_ID,SMART_SHORTNAME,
CONST_AREA  as CONST_AREA -- 在建面积（操盘+代建）
,CONST_AREA_JOINT  as CONST_AREA_JOINT -- 包含联合操盘在建面积
,LEVEL,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM f_ehr_org_struc A 
inner JOIN T1 on 1=1
LEFT JOIN ipt_hr_const_area B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 1=1
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(AREA)==0,"AND 1=0"," and ORG_ID in ('" + AREA + "')")}

UNION ALL 

SELECT DISTINCT T1.THE_MONTH,ORG_ID,SMART_SHORTNAME,
CONST_AREA  as CONST_AREA -- 在建面积（操盘+代建）
,CONST_AREA_JOINT  as CONST_AREA_JOINT -- 包含联合操盘在建面积
,LEVEL,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM f_ehr_org_struc A 
inner JOIN T1 on 1=1
LEFT JOIN ipt_hr_const_area B
ON A.ORG_ID=B.COMPANY_ID AND T1.THE_MONTH=B.THE_MONTH
where 1=1
${if(len(TIME) == 0,"","and T1.THE_MONTH in ('" + TIME + "')")}
${if(len(CITY)==0,"AND 1=0"," and ORG_ID in ('" + CITY + "')")}

ORDER BY THE_MONTH,LEVEL,SMART_ORDER,SMART_ORGNO_FULLPATH

select distinct the_year,quarter_name,the_month from dim_time
where the_month<= '2021-12'-- left(curdate(),7)
order by the_month desc

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
and ORG_ID = 50023969 -- 房产主业

