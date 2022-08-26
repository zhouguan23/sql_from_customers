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
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
AND LEVEL =4 -- 层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 仅取最细粒度为公司级权限
and SMART_PARENTID in ('14500000','14530000') -- 商业公司、营销公司
${if(len(FUNCTION_TYPE)==0," "," and SMART_PARENTID in ('" + FUNCTION_TYPE + "')")}
ORDER BY SMART_ORGNO_FULLPATH

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
FROM f_ehr_org_struc b -- 组织表
where ORG_ID in ( select distinct ORG_ID from user_org  ) -- 从递归获取用户权限下所有组织ID
and ORG_ID in ('14500000','14530000') -- 商业公司、营销公司
ORDER BY SMART_ORGNO_FULLPATH

WITH T1 AS 
(select distinct the_year,year_half from dim_time
where the_year <= left(curdate(),4)
and IF(MONTH(CURDATE())>6,"1=1",year_half <> concat(left(curdate(),4),'下半年'))
) -- 取dim表半年度


SELECT DISTINCT T1.year_half,ORG_ID,SMART_SHORTNAME
,unilateral_area/10000 as unilateral_area
,LEVEL,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM f_ehr_org_struc A 
inner JOIN T1 on 1=1
LEFT JOIN ipt_hr_unilateral_area B
ON A.ORG_ID=B.COMPANY_ID AND T1.year_half=B.YEAR_HALF
where 1=1
${if(len(TIME) == 0,"","and T1.year_half in ('" + TIME + "')")}
${if(len(COMPANY)==0,"AND 1=0"," and ORG_ID in ('" + COMPANY + "')")}

UNION ALL 

SELECT DISTINCT 
T1.year_half
,ORG_ID
,SMART_SHORTNAME
,unilateral_area/10000 as unilateral_area
,LEVEL
,SMART_ORGNO_FULLPATH,SMART_ORDER
FROM f_ehr_org_struc A 
inner JOIN T1 on 1=1
LEFT JOIN ipt_hr_unilateral_area B
ON A.ORG_ID=B.COMPANY_ID AND T1.year_half=B.YEAR_HALF
where 1=1
${if(len(TIME) == 0,"","and T1.year_half in ('" + TIME + "')")}
${if(len(FUNCTION_TYPE)==0,"AND 1=0"," and ORG_ID in ('" + FUNCTION_TYPE + "')")}
ORDER BY year_half,LEVEL,SMART_ORDER,SMART_ORGNO_FULLPATH

select distinct the_year,year_half from dim_time
where the_year <= left(curdate(),4)
and IF(MONTH(CURDATE())>6,"1=1",year_half <> concat(left(curdate(),4),'下半年'))

