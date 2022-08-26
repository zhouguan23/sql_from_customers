WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

SELECT  
    ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," AREANAME," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITYNAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJECTNAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGENAME,IS_OPERAT,
CPORG,
PARTNER,
GET_LAND_ORG,
GET_DATE,
RATIO," ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,""," TENDERS," ) } 
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","PRODTYPE," ) }
		${ if(INARRAY("7", SPLIT(rank, ",")) = 0,""," BUILD_NAME,
IS_KEEP,
IS_BUILD,
SUITE_NUM,
FLOOR_NUM,
REACH_CONDITION,
STAGE,REMARK," ) } 
'aa' as aa,
SUM(build_area) build_area,
sum(SURFACE_BUILD_AREA) SURFACE_BUILD_AREA,
sum(SALE_AREA) SALE_AREA,
sum(STOCK_PRICE) STOCK_PRICE,
sum(LAND_PRICE) LAND_PRICE,
sum(LAND_AREA) LAND_AREA,
sum(ON_WAY_PRICE) ON_WAY_PRICE,	
sum(ON_WAY_AREA) ON_WAY_AREA,	
sum(START_NREACH_PRICE)START_NREACH_PRICE,
sum(START_NREACH_AREA)START_NREACH_AREA,
sum(REACH_PRICE) REACH_PRICE,	
sum(REACH_AREA) REACH_AREA,	
sum(CERT_PRICE) CERT_PRICE,
sum(CERT_AREA) CERT_AREA,
sum(SALE_CONT_PRICE)SALE_CONT_PRICE,
sum(SALE_CONT_AREA)SALE_CONT_AREA,
sum(ASSET_SCU_PRICE)ASSET_SCU_PRICE,
sum(ASSET_SCU_AREA)ASSET_SCU_AREA,
sum(OTHER_UNSALE_PRICE)OTHER_UNSALE_PRICE,
sum(OTHER_UNSALE_AREA)OTHER_UNSALE_AREA,
sum(CERT_NPUSH_PRICE)CERT_NPUSH_PRICE,
sum(CERT_NPUSH_AREA)CERT_NPUSH_AREA,
sum(PUSH_NORDER_PRICE)PUSH_NORDER_PRICE,
sum(PUSH_NORDER_AREA)PUSH_NORDER_AREA,
sum(PLAN_REACH_PRICE) PLAN_REACH_PRICE,
sum(PLAN_REACH_AREA) PLAN_REACH_AREA,
sum(QH_PRICE) QH_PRICE,
sum(QH_AREA) QH_AREA,


sum(ratio*LAND_PRICE) QY_LAND_PRICE,
sum(ratio*LAND_AREA) QY_LAND_AREA,
sum(ratio*ON_WAY_PRICE) QY_ON_WAY_PRICE,	
sum(ratio*ON_WAY_AREA) QY_ON_WAY_AREA,
sum(ratio*START_NREACH_PRICE)QY_START_NREACH_PRICE,
sum(ratio*START_NREACH_AREA)QY_START_NREACH_AREA,	
sum(ratio*REACH_PRICE) QY_REACH_PRICE,	
sum(ratio*REACH_AREA) QY_REACH_AREA,	
sum(ratio*CERT_PRICE) QY_CERT_PRICE,
sum(ratio*CERT_AREA) QY_CERT_AREA,
sum(ratio*SALE_CONT_PRICE)QY_SALE_CONT_PRICE,
sum(ratio*SALE_CONT_AREA)QY_SALE_CONT_AREA,
sum(ratio*ASSET_SCU_PRICE)QY_ASSET_SCU_PRICE,
sum(ratio*ASSET_SCU_AREA)QY_ASSET_SCU_AREA,
sum(ratio*OTHER_UNSALE_PRICE)QY_OTHER_UNSALE_PRICE,
sum(ratio*OTHER_UNSALE_AREA)QY_OTHER_UNSALE_AREA,
sum(ratio*CERT_NPUSH_PRICE)QY_CERT_NPUSH_PRICE,
sum(ratio*CERT_NPUSH_AREA)QY_CERT_NPUSH_AREA,
sum(ratio*PUSH_NORDER_PRICE)QY_PUSH_NORDER_PRICE,
sum(ratio*PUSH_NORDER_AREA)QY_PUSH_NORDER_AREA,
sum(ratio*PLAN_REACH_PRICE) QY_PLAN_REACH_PRICE,
sum(ratio*PLAN_REACH_AREA) QY_PLAN_REACH_AREA,
sum(ratio*QH_PRICE) QY_QH_PRICE,
sum(ratio*QH_AREA) QY_QH_AREA
FROM  ipt_oprate_dtl 
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}
${if(len(projname)=0,"","and projectname in ('"+projname+"')")}
${if(len(PRODTYPE)=0,"","and PRODTYPE in ('"+PRODTYPE+"')")}
${if(len(SALETYPE)=0,"","and IS_KEEP in ('"+SALETYPE+"')")}
${if(len(CP_FLAG)=0,"","and IS_OPERAT in ('"+CP_FLAG+"')")}
${if(len(IS_BUILD)=0,"","and IS_BUILD in ('"+IS_BUILD+"')")}


and  cityid in(
	select distinct b.city_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)

group by 
    ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," AREANAME," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITYNAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJECTNAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGENAME,IS_OPERAT,
CPORG,
PARTNER,
GET_LAND_ORG,
GET_DATE,RATIO,
" ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,""," TENDERS," ) } 
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","PRODTYPE," ) }
		${ if(INARRAY("7", SPLIT(rank, ",")) = 0,""," BUILD_NAME,
IS_KEEP,
IS_BUILD,
SUITE_NUM,
FLOOR_NUM,
REACH_CONDITION,
STAGE,REMARK," ) } 
aa

order by 
    ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," instr(
    '珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京区域',AREANAME)," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITYNAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJECTNAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGENAME,IS_OPERAT,
CPORG,
PARTNER,
GET_LAND_ORG,
GET_DATE,RATIO,
" ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,""," TENDERS," ) } 
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","PRODTYPE," ) }
		${ if(INARRAY("7", SPLIT(rank, ",")) = 0,""," BUILD_NAME,
IS_KEEP,
IS_BUILD,
SUITE_NUM,
FLOOR_NUM,
REACH_CONDITION,
STAGE,REMARK," ) } 
aa


select distinct the_month 
from dim_time 
where 
the_date
 between '2020-05-01' AND NOW()

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
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
${if(len(AREANAME)=0,"","and area_org_code in ('"+AREANAME+"')")}
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
SELECT DISTINCT PROJECTNAME 
FROM IPT_OPRATE_DTL
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

and  cityid in(
	select distinct b.city_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)

select distinct prodtype  
from ipt_oprate_dtl
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

SELECT DISTINCT IS_KEEP FROM IPT_OPRATE_DTL
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

SELECT DISTINCT IS_OPERAT 
FROM IPT_OPRATE_DTL
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

SELECT DISTINCT IS_BUILD FROM IPT_OPRATE_DTL
where 1=1
${if(len(yearmonth)=0,"","and yearmonth='"+yearmonth+"'")}
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

