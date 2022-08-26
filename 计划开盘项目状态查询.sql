select 
	area_org_name,
	city_org_name,
	proj_name,
	stage_name,
	DATE_FORMAT(PLAN_EDATE,'%Y/%m/%d') as PLAN_EDATE,
	DATE_FORMAT(AC_EDATE,'%Y/%m/%d') as AC_EDATE,
	LIGHT_STATUS_NAME 
from f_plan_eng_plan
where nd_code='R220000095' #开盘节点
${if(len(plan_begin_date)=0,""," AND DATE_FORMAT(plan_edate,'%Y-%m-%d')>= '"+plan_begin_date+"'
and DATE_FORMAT(plan_edate,'%Y-%m-%d') <= '"+plan_end_date+"' ")}
${if(len(ac_begin_date)=0,""," AND DATE_FORMAT(ac_edate,'%Y-%m-%d')>= '"+ac_begin_date+"'
and DATE_FORMAT(ac_edate,'%Y-%m-%d') <= '"+ac_end_date+"' ")}
${if(len(AREAID)=0,""," AND AREA_ORG_CODE IN('"+AREAID+"')")}
${if(len(CITYID)=0,""," AND CITY_ORG_CODE IN('"+CITYID+"')")}
${if(len(PROJID)=0,""," AND PROJ_CODE IN('"+PROJID+"')")}
${if(len(STAGEID)=0,""," AND STAGE_CODE IN('"+STAGEID+"')")}
${if(len(LIGHTCODE)=0,""," and LIGHT_STATUS_CODE in('"+LIGHTCODE+"') ")}

SELECT 
distinct	area_org_code,area_org_name
FROM f_plan_eng_plan

SELECT 
distinct	city_org_code,city_org_name
FROM f_plan_eng_plan
where 1=1 
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}

SELECT 
distinct	PROJ_CODE,PROJ_NAME
FROM f_plan_eng_plan
where 1=1 
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}

SELECT 
distinct	STAGE_CODE,STAGE_NAME
FROM f_plan_eng_plan
where 1=1 
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"","and PROJ_CODE in ('" + PROJID + "')")}

SELECT max(W_INSERT_DT) as time FROM f_mkt_project_sale

select distinct light_status_code,light_status_name from f_plan_eng_plan


