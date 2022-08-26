WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   mkt_city_id as city_id,
   mkt_city_name as city_name
from 
 fr_erp_mkt_organization 
where 1=1
and  sap_city_id in (
	select distinct sap_dept_id from user_org 
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
   mkt_city_id as city_id,
   mkt_city_name as city_name
from 
 fr_erp_mkt_organization 
where 1=1
${if(len(E5)=0,"","and mkt_dept_name IN ('"+E5+"')")}
and  sap_city_id in(
	select distinct sap_dept_id from user_org 
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
   mkt_dept_id as area_id,
   mkt_dept_name as area_name
from 
 fr_erp_mkt_organization 
where 1=1
and  sap_city_id in(
	select distinct sap_dept_id from user_org
)

select distinct the_month 
from dim_time 
where 
the_date between '2020-07-01' and date_add(curdate(),interval 0 month)
order by the_month desc


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
area_name,
CITY_NAME,
proj_name,
stage_name,
equity_ratio,
PROD_TYPE_NAME,
BUILD_NAME,
is_keep,
BUILD_AREA,
FLOOR_NUM,
standard,
ROOM_DIST,
ZNUM,
ZAREA,
ZPRICE,
ORDER_NUM,
ORDER_AREA,
ORDER_AMOUNT,
SIGN_NUM,
SIGN_AREA, 
SIGN_AMOUNT,
INCOME_AMOUNT,
QZ_NUM,
QZ_AREA,
QZ_AMOUNT,
KS_NUM,
KS_AREA,
KS_AMOUNT,
BKS_NUM,
BKS_AREA,
BKS_AMOUNT,
WT_NUM,
WT_AREA,
WT_AMOUNT,
WS_NUM,
WS_AREA,
WS_AMOUNT,
username,
insertime
from ipt_mkt_month a
left join fr_erp_mkt_organization c on a.city_id = c.mkt_city_id
WHERE 1=1
${if(len(AREANAME)=0,"","and area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
AND YEARMONTH ='${YEARMONTH}'
and  sap_city_id in(
	select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)

select  STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from 
(SELECT distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME FROM `dim_project_staging_product` ) a
where STAGE_PROD_TYPE_CODE is not null and STAGE_PROD_TYPE_CODE
order by STAGE_PROD_TYPE_CODE

