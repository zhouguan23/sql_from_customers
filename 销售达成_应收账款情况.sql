WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID,AREANAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID,CITYNAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID,PROJECTNAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PERIODID,PERIODNAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROD_TYPE_ROOTID AS PRODUCTID,PROD_TYPE_ROOTNAME AS PRODUCTNAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FUNDTYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","AGINGTYPE," ) }
sum(PLAN_COLLECTION)/10000 as PLAN_COLLECTION,
sum(ACTUAL_COLLECTION)/10000 as ACTUAL_COLLECTION,
sum(YQ_COLLECTION)/10000 as YQ_COLLECTION,
sum(WYQ_COLLECTION)/10000 as WYQ_COLLECTION,
'' aa
from f_mkt_project_fund_age
where 1=1
AND period_wid= '${YEARMONTH}'
${if(len(AREANAME) == 0,"and AREANAME in(
	select distinct c.area_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"and CITYNAME in(
	select distinct c.city_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0," and PROJECTNAME in(
	select distinct c.proj_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and PROJECTNAME in ('" + PROJECTNAME + "')")}
${if(len(PERIODNAME) == 0,"","and PERIODNAME in ('" + PERIODNAME + "')")}
${if(len(PRODUCTNAME) == 0,"","and PROD_TYPE_ROOTID in ('" + PRODUCTNAME + "')")}
${if(len(FUNDTYPE) == 0,"","and FUNDTYPE in ('" + FUNDTYPE + "')")}
${if(len(AGINGTYPE) == 0,"","and AGINGTYPE in ('" + AGINGTYPE + "')")}

group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID,AREANAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID,CITYNAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID,PROJECTNAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PERIODID,PERIODNAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROD_TYPE_ROOTID,PROD_TYPE_ROOTNAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FUNDTYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","AGINGTYPE," ) }
aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECTID,PERIODID," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODUCTID," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FIND_IN_SET
(AGINGTYPE,'0~1个月,1~3个月,3~6个月,6~12个月,大于12个月')," ) }
2



WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREANAME
FROM f_mkt_project_fund
where 1=1 
and areaname in(
	select distinct c.area_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	CITYNAME
FROM f_mkt_project_fund
where 1=1 
and cityname in(
	select distinct c.city_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJECTNAME
FROM f_mkt_project_fund
where 1=1 
and projectid in(
	select distinct c.proj_id from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
)
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"","and CITYNAME in ('" + CITYNAME + "')")}

SELECT 
distinct	PERIODNAME
FROM f_mkt_project_fund
where 1=1 
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"","and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0,"","and PROJECTNAME in ('" + PROJECTNAME + "')")}

SELECT 
distinct	PROD_TYPE_ROOTID,PROD_TYPE_ROOTNAME
FROM f_mkt_project_fund
where 1=1 
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"","and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0,"","and PROJECTNAME in ('" + PROJECTNAME + "')")}
${if(len(PERIODNAME) == 0,"","and PERIODNAME in ('" + PERIODNAME + "')")}

SELECT max(W_INSERT_DT) as time FROM f_mkt_project_fund

SELECT 
distinct	FUNDTYPE
FROM f_mkt_project_fund
where 1=1 
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"","and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0,"","and PROJECTNAME in ('" + PROJECTNAME + "')")}
${if(len(PERIODNAME) == 0,"","and PERIODNAME in ('" + PERIODNAME + "')")}

SELECT 
distinct	AGINGTYPE
FROM f_mkt_project_fund_age
where 1=1 
${if(len(AREANAME) == 0,"","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"","and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0,"","and PROJECTNAME in ('" + PROJECTNAME + "')")}
${if(len(PERIODNAME) == 0,"","and PERIODNAME in ('" + PERIODNAME + "')")}

WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID,AREANAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID,CITYNAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID,PROJECTNAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PERIODID,PERIODNAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROD_TYPE_ROOTID AS PRODUCTID,PROD_TYPE_ROOTNAME AS PRODUCTNAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FUNDTYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","AGINGTYPE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","FIRST_PAYMENT_FLAG," ) }

sum(PLAN_COLLECTION)/10000 as PLAN_COLLECTION,
sum(ACTUAL_COLLECTION)/10000 as ACTUAL_COLLECTION,
sum(YQ_COLLECTION)/10000 as YQ_COLLECTION,
sum(WYQ_COLLECTION)/10000 as WYQ_COLLECTION,
'' aa
from f_mkt_project_fund_age
where 1=1
AND period_wid= '${YEARMONTH}'
${if(len(AREANAME) == 0,"and AREANAME in(
	select distinct c.area_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) ","and AREANAME in ('" + AREANAME + "')")}
${if(len(CITYNAME) == 0,"and CITYNAME in(
	select distinct c.city_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and CITYNAME in ('" + CITYNAME + "')")}
${if(len(PROJECTNAME) == 0," and PROJECTNAME in(
	select distinct c.proj_name from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code
	inner join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on b.maket_proj_id=c.proj_id
) "," and PROJECTNAME in ('" + PROJECTNAME + "')")}
${if(len(PERIODNAME) == 0,"","and PERIODNAME in ('" + PERIODNAME + "')")}
${if(len(PRODUCTNAME) == 0,"","and PROD_TYPE_ROOTID in ('" + PRODUCTNAME + "')")}
${if(len(FUNDTYPE) == 0,"","and FUNDTYPE in ('" + FUNDTYPE + "')")}
${if(len(AGINGTYPE) == 0,"","and AGINGTYPE in ('" + AGINGTYPE + "')")}
${if(len(FIRSTPAY) == 0,"","and FIRST_PAYMENT_FLAG in ('" + FIRSTPAY + "')")}

group by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID,AREANAME," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID,CITYNAME," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID,PROJECTNAME," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PERIODID,PERIODNAME," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PROD_TYPE_ROOTID,PROD_TYPE_ROOTNAME," ) }
${ if(INARRAY("6", SPLIT(show, ",")) = 0,"","FUNDTYPE," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","AGINGTYPE," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","FIRST_PAYMENT_FLAG," ) }

aa
order by 
${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","AREAID," ) } 
${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","CITYID," ) }
${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","PROJECTID," ) }
${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","PROJECTID,PERIODID," ) }
${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","PRODUCTID," ) }
${ if(INARRAY("7", SPLIT(show, ",")) = 0,"","FIND_IN_SET
(AGINGTYPE,'0~1个月,1~3个月,3~6个月,6~12个月,大于12个月')," ) }
${ if(INARRAY("8", SPLIT(show, ",")) = 0,"","FIRST_PAYMENT_FLAG," ) }

2



