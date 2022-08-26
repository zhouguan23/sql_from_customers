WITH RECURSIVE user_org as
(#数据权限
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
	t1.area_org_name, #区域
	t1.city_org_name, #城市
	t1.proj_name, #项目
	t1.stage_name, #分期
	t1.BATCH_NAME,#批次
	t1.BUILD_NAME, #楼栋
	DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d') as PLAN_EDATE, #计划完成时间
	DATE_FORMAT(t1.AC_EDATE,'%Y/%m/%d') as AC_EDATE, #实际完成时间
	IS_FINISHED, #是否已完成
	IS_DELAYED, #是否已延期
	DELAY_DAYS #延误天数
from f_plan_batch_build_d t1
where 1=1
and period_wid=date_format( date_add(sysdate(), interval -1 day),'%Y-%m')
${if(len(plan_begin_date)=0,""," AND DATE_FORMAT(plan_edate,'%Y-%m-%d')>= '"+plan_begin_date+"'")}
${if(len(plan_end_date)=0,""," AND DATE_FORMAT(plan_edate,'%Y-%m-%d')<= '"+plan_end_date+"'")}
${if(len(AREAID) == 0,"and t1.AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"and t1.CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"and t1.PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and t1.PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID)=0,""," AND T1.STAGE_CODE IN('"+STAGEID+"')")}
${if(len(BATCH_CODE)=0,""," AND T1.BATCH_CODE IN('"+BATCH_CODE+"')")}
${if(len(BUILD_CODE)=0,""," AND T1.BUILD_CODE IN('"+BUILD_CODE+"')")}
-- ${if(len(DONEFLAG)=0,""," AND T1.IS_FINISHED = '"+DONEFLAG+"'")}
-- ${if(len(DELAYED_FLAG)=0,""," AND T1.IS_DELAYED = '"+DELAYED_FLAG+"'")}
${if(len(DELAY_DAYS)=0,"","and T1.DELAY_DAYS>"+DELAY_DAYS)}
order by t1.area_org_name,t1.PLAN_EDATE asc

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ORG_CODE,AREA_ORG_NAME
FROM f_plan_batch_build_d
where area_org_code in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	CITY_ORG_CODE,CITY_ORG_NAME
FROM f_plan_batch_build_d
where 1=1 
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_CODE,PROJ_NAME
FROM f_plan_batch_build_d
where 1=1 
and proj_code in( 
	select distinct b.PROJ_CODE from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}

SELECT 
distinct	STAGE_CODE,STAGE_NAME
FROM f_plan_eng_plan
where 1=1 
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"","and PROJ_CODE in ('" + PROJID + "')")}

SELECT max(W_INSERT_DT) as time FROM f_plan_batch_build_d

select distinct BUILD_CODE,BUILD_NAME from f_plan_batch_build_d
where 1=1
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"","and PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID) == 0,"","and STAGE_CODE in ('" + STAGEID + "')")}

select distinct BATCH_CODE,BATCH_NAME from f_plan_batch_build_d
where 1=1
${if(len(AREAID) == 0,"","and AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"","and PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID) == 0,"","and STAGE_CODE in ('" + STAGEID + "')")}

