WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT  
AREANAME,
AREAID,
CITYNAME,
CITYID,
PROJECTNAME,
STAGENAME,
TENDERS,
PRODTYPE,
BUILD_NAME,
IS_OPERAT,
CPORG,
PARTNER,
GET_LAND_ORG,
convert(GET_DATE,char) GET_DATE,
IS_KEEP,
IS_BUILD,
RATIO,
BUILD_AREA,
SURFACE_BUILD_AREA,
SALE_AREA,
STOCK_PRICE,
SUITE_NUM,
FLOOR_NUM,
REACH_CONDITION,
REMARK,
STAGE,
LAND_PRICE,
LAND_AREA,
ON_WAY_PRICE,	
ON_WAY_AREA,	
START_NREACH_PRICE,
START_NREACH_AREA,
REACH_PRICE,	
REACH_AREA,	
SALE_CONT_PRICE,
SALE_CONT_AREA,
ASSET_SCU_PRICE,
ASSET_SCU_AREA,
OTHER_UNSALE_PRICE,
OTHER_UNSALE_AREA,
CERT_NPUSH_PRICE,
CERT_NPUSH_AREA,
PUSH_NORDER_PRICE,
PUSH_NORDER_AREA,
CERT_PRICE,
CERT_AREA,
PLAN_REACH_PRICE,
PLAN_REACH_AREA,
QH_PRICE,
QH_AREA,
INSERTIME,
USERNAME,
INSERTDATE

FROM  ipt_oprate_dtl 
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(AREANAME)=0,"","and areaid IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and cityid IN ('"+CITYNAME+"')")}
and  cityid in(
	select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)

order by
AREANAME,
AREAID,
CITYNAME,
CITYID,
PROJECTNAME,
STAGENAME,
TENDERS,
PRODTYPE,
BUILD_NAME


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

select distinct YEARMONTH
from user_org b inner join ipt_operate_control a   on a.dept_id = b.sap_dept_id

UNION 
select CASE WHEN DAY(current_date())>=29 THEN LEFT(current_date(),7) ELSE left(DATE_ADD(current_date(), interval -1 MONTH),7) end YEARMONTH


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   area_org_name,
   area_org_code
from 
dim_project
where 1=1
and  area_org_code in(
	select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   city_org_name,
   city_org_code
from 
dim_project
where 1=1
${if(len(D7)=0,"","and area_org_name = '"+D7+"'")}

and  city_org_code in(
	select distinct b.city_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   city_org_name,
   city_org_code
from 
dim_project
where 1=1
${if(len(AREANAME)=0,"","and area_org_name IN ('"+AREANAME+"')")}

and  city_org_code in(
	select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)


select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '??????' prod from dim_mkt_project
union
select '?????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '??????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '??????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project
union
select '???????????????' prod from dim_mkt_project
union
select '??????' prod from dim_mkt_project
union
select '????????????' prod from dim_mkt_project


select '??????' saletype from dim_mkt_project
union
select '??????' saletype from dim_mkt_project
union
select '????????????' saletype from dim_mkt_project

select '??????' cptype from dim_mkt_project
union
select '?????????' cptype from dim_mkt_project
union
select '????????????' cptype from dim_mkt_project
union
select '??????' cptype from dim_mkt_project
union
select '????????????' cptype from dim_mkt_project


select '?????????' buildtype from dim_mkt_project
union
select '??????' buildtype from dim_mkt_project
union
select '??????' buildtype from dim_mkt_project
union
select '??????' buildtype from dim_mkt_project



