WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
T1 AS(
 SELECT  -- 分期
 AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BATCH_CODE,BATCH_NAME, BUILD_CODE,BUILD_NAME,
 PLAN_EDATE,AC_EDATE,
 CASE WHEN (CASE WHEN AC_EDATE IS NULL OR AC_EDATE ='' THEN DATE_FORMAT(CURDATE(),'%Y%m%d') ELSE AC_EDATE END > PLAN_EDATE )THEN 0 ELSE 1 END  IS_INTIME
 FROM  f_plan_all_v T1
 where 1=1
  ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点
)

SELECT 
AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,ENTITY_ORG_CODE,ENTITY_ORG_NAME,PROJ_NAME,t1.PROJ_CODE,
CASE WHEN D.OPERAT_FLAG = 'Y' THEN '操盘' WHEN D.OPERAT_FLAG = 'N' THEN '非操盘' ELSE '联合操盘' END OPERAT_FLAG,EQUITY_RATIO/100 EQUITY_RATIO,
STAGE_NAME,STAGE_CODE,BATCH_CODE,BATCH_NAME, BUILD_CODE,BUILD_NAME,ND_CODE,ND_NAME,
PLAN_EDATE,AC_EDATE,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME,
CASE WHEN t1.AC_EDATE IS NULL OR t1.AC_EDATE = '' THEN DATEDIFF(	DATE_FORMAT(CURDATE(),'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d')) 
  ELSE DATEDIFF(	DATE_FORMAT(t1.AC_EDATE,'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d')) END as dates #延误天数

FROM T1 
left join (SELECT DISTINCT PROJ_CODE,EQUITY_RATIO,OPERAT_FLAG,ENTITY_ORG_CODE,ENTITY_ORG_NAME FROM dim_project) D on t1.proj_code=D.proj_code
WHERE 1=1
${if(len(plan_begin_date)=0,"","AND DATE_FORMAT(plan_edate,'%Y-%m-%d')>= '"+plan_begin_date+"'")}
${if(len(plan_end_date)=0,"","and DATE_FORMAT(plan_edate,'%Y-%m-%d') <= '"+plan_end_date+"'")}
${if(len(ac_begin_date)=0,""," AND DATE_FORMAT(ac_edate,'%Y-%m-%d')>= '"+ac_begin_date+"'")}
${if(len(ac_end_date)=0,"","and DATE_FORMAT(ac_edate,'%Y-%m-%d') <= '"+ac_end_date+"' ")}
${if(len(OPERAT_FLAG)=0,"","and t2.OPERAT_FLAG='"+OPERAT_FLAG+"'")} #是否操盘
${if(len(AREAID) == 0,"and t1.AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"and t1.CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"and t1.PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and t1.PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID)=0,""," AND T1.STAGE_CODE IN('"+STAGEID+"')")}
${if(len(NDCODE)=0,""," AND T1.ND_CODE IN('"+NDCODE+"')")}
${if(len(LIGHTCODE)=0,""," AND T1.LIGHT_STATUS_CODE IN('"+LIGHTCODE+"')")}
${if(len(DONEFLAG)=0,"",if(DONEFLAG="N"," AND T1.LIGHT_STATUS_CODE <> '02' "," AND T1.LIGHT_STATUS_CODE = '02'"))}
${if(len(DATES)=0,"","and DATEDIFF(	DATE_FORMAT(t1.AC_EDATE,'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d'))>"+DATES)}

order by AREA_ORG_CODE,CITY_ORG_CODE,ENTITY_ORG_CODE,STAGE_CODE,ND_CODE,BATCH_CODE,BUILD_CODE

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	AREA_ORG_CODE,AREA_ORG_NAME
FROM F_PLAN_ENG_PLAN
where area_org_code in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)ORDER BY AREA_ORG_CODE

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	CITY_ORG_CODE,CITY_ORG_NAME
FROM f_plan_eng_plan
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
FROM f_plan_eng_plan
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

SELECT max(W_INSERT_DT) as time FROM f_plan_eng_plan

select distinct light_status_code,light_status_name from f_plan_eng_plan


select distinct ND_LVL,ND_LVL_NAME from f_plan_eng_plan


select distinct nd_code,nd_name from f_plan_eng_plan
order by nd_code 

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
T1 AS(
 SELECT  -- 分期
 AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,'' BATCH_CODE,'' BATCH,
 PLAN_EDATE,AC_EDATE,T1.LIGHT_STATUS_CODE,T1.LIGHT_STATUS_NAME,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME
 FROM  F_PLAN_ENG_PLAN T1
 where 1=1
  ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点
 AND  ND_CODE NOT IN ('R220000060','R220000095','R220000053','R220000092','R220000043','R220000106','R220000105','R220000041')

/*
 UNION ALL
 SELECT   -- 批次
 AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BATCH_CODE,BATCH_NAME,
 PLAN_EDATE,AC_EDATE,LIGHT_STATUS_CODE,LIGHT_STATUS_NAME,IS_INTIME
 FROM(
 SELECT  AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BATCH_NAME,BATCH_CODE,
 PLAN_EDATE,AC_EDATE,LIGHT_STATUS_CODE,LIGHT_STATUS_NAME,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME
FROM f_plan_batch_all_node_d T1-- 批次计划
WHERE ND_CODE IN ('R220000043','R220000106','R220000105','R220000041')   -- 开工  外架拆除  主体结构封顶  取得《建筑工程施工许可证》
  ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点 
AND PERIOD_WID=left(curdate(),7)
) A */

UNION ALL
SELECT    -- 楼栋
AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BUILD_CODE,BUILD_NAME,
PLAN_EDATE,AC_EDATE,LIGHT_STATUS_CODE,LIGHT_STATUS_NAME,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME
from(
select 
AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BUILD_CODE,BUILD_NAME,
PLAN_EDATE,AC_EDATE,LIGHT_STATUS_CODE,LIGHT_STATUS_NAME,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME
FROM f_plan_batch_build_all_d T1-- 楼栋计划
WHERE ND_CODE IN ('R220000060','R220000095','R220000053','R220000092','R220000043','R220000106','R220000105','R220000041')  -- 达+-0 达预售 开盘 办理预售许可证
 ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点
AND PERIOD_WID=left(curdate(),7)
) A
)

SELECT 
AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,ENTITY_ORG_CODE,ENTITY_ORG_NAME,PROJ_NAME,t1.PROJ_CODE,
CASE WHEN D.OPERAT_FLAG = 'Y' THEN '操盘' WHEN D.OPERAT_FLAG = 'N' THEN '非操盘' ELSE '联合操盘' END OPERAT_FLAG,EQUITY_RATIO/100 EQUITY_RATIO,
STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BATCH,
PLAN_EDATE,AC_EDATE,LIGHT_STATUS_CODE,LIGHT_STATUS_NAME,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN 0 ELSE 1 END IS_INTIME,
CASE WHEN t1.AC_EDATE IS NULL OR t1.AC_EDATE = '' THEN DATEDIFF(	DATE_FORMAT(CURDATE(),'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d')) 
  ELSE DATEDIFF(	DATE_FORMAT(t1.AC_EDATE,'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d')) END as dates #延误天数

FROM T1 
left join (SELECT DISTINCT PROJ_CODE,EQUITY_RATIO,OPERAT_FLAG,ENTITY_ORG_CODE,ENTITY_ORG_NAME FROM dim_project) D on t1.proj_code=D.proj_code
WHERE 1=1
${if(len(plan_begin_date)=0,"","AND DATE_FORMAT(plan_edate,'%Y-%m-%d')>= '"+plan_begin_date+"'")}
${if(len(plan_end_date)=0,"","and DATE_FORMAT(plan_edate,'%Y-%m-%d') <= '"+plan_end_date+"'")}
${if(len(ac_begin_date)=0,""," AND DATE_FORMAT(ac_edate,'%Y-%m-%d')>= '"+ac_begin_date+"'")}
${if(len(ac_end_date)=0,"","and DATE_FORMAT(ac_edate,'%Y-%m-%d') <= '"+ac_end_date+"' ")}
${if(len(OPERAT_FLAG)=0,"","and t2.OPERAT_FLAG='"+OPERAT_FLAG+"'")} #是否操盘
${if(len(AREAID) == 0,"and t1.AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"and t1.CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and t1.CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"and t1.PROJ_CODE in( select distinct b.PROJ_CODE from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code )","and t1.PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID)=0,""," AND T1.STAGE_CODE IN('"+STAGEID+"')")}
${if(len(NDCODE)=0,""," AND T1.ND_CODE IN('"+NDCODE+"')")}
${if(len(LIGHTCODE)=0,""," AND T1.LIGHT_STATUS_CODE IN('"+LIGHTCODE+"')")}
${if(len(DONEFLAG)=0,"",if(DONEFLAG="N"," AND T1.LIGHT_STATUS_CODE <> '02' "," AND T1.LIGHT_STATUS_CODE = '02'"))}
${if(len(DATES)=0,"","and DATEDIFF(	DATE_FORMAT(t1.AC_EDATE,'%Y/%m/%d') , DATE_FORMAT(t1.PLAN_EDATE,'%Y/%m/%d'))>"+DATES)}

order by AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,ENTITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_CODE,ND_NAME,BATCH_CODE


