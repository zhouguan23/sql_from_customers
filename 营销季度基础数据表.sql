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
${if(len(AREANAME)=0,"","and mkt_dept_id IN ('"+AREANAME+"')")}
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
   mkt_city_id as city_id,
   mkt_city_name as city_name
from 
 fr_erp_mkt_organization 
where 1=1
${if(len(E3)=0,"","and mkt_dept_name IN ('"+E3+"')")}
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

select distinct quarter_name
from dim_time 
where 
the_date between '2020-07-01' and now()

-- the_date between  left(now(),10) and date_add(now() interval -1 month)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
AREA_ID,AREA_NAME,
CITY_ID,CITY_NAME,
PROJ_NAME,EQUITY_RATIO, 
STAGE_NAME,
PRODUCT_TYPE_NAME,
WORDER_AMOUNT,
DORDER_AMOUNT,
WSIGN_AMOUNT,
DSIGN_AMOUNT,
WINCOME_AMOUNT,
DINCOME_AMOUNT,
WRGDQY,
DRGDQY,
WRGDHK,
DRGDHK,
WQYDHK,
DQYDHK,
DQYWHK,
QYWHK,
QYDHK,
SQZ,
SQZBRG,
BQZ,
BQZBRG,
USERNAME,
INSERTIME

from ipt_mkt_quarter a 
left join fr_erp_mkt_organization c on a.city_id = c.mkt_city_id

WHERE 1=1
and  quartername = '${quartername}'
${if(len(AREANAME)=0,"","and AREA_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
and  sap_city_id in(
	select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)
order by 
AREA_ID,AREA_NAME,
CITY_ID,CITY_NAME,
PROJ_NAME,EQUITY_RATIO, 
STAGE_NAME,
PRODUCT_TYPE_NAME

select  STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from 
(SELECT distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME FROM `dim_project_staging_product` ) a
where STAGE_PROD_TYPE_CODE is not null and STAGE_PROD_TYPE_CODE
order by STAGE_PROD_TYPE_CODE

