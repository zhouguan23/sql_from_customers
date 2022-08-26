WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
,T1 AS(
SELECT 
AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_LVL,ND_LVL_NAME,
COUNT(ND_CODE) AS A,
sum(CASE WHEN (CASE WHEN AC_EDATE IS NULL OR AC_EDATE ='' THEN DATE_FORMAT(CURDATE(),'%Y%m%d') ELSE AC_EDATE END > PLAN_EDATE )THEN 0 ELSE 1 END )B 
FROM f_plan_all_v T1
 INNER JOIN (SELECT DISTINCT sap_dept_id FROM user_org where dept_level=2) t3 ON T1.CITY_ORG_CODE=t3.sap_dept_id 
WHERE  1=1
 ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点
 ${if(len(begin_date)=0,"","AND DATE_FORMAT(t1.plan_edate,'%Y-%m-%d')>= '"+begin_date+"'")}
 ${if(len(end_date)=0,"","AND DATE_FORMAT(t1.plan_edate,'%Y-%m-%d')<= '"+end_date+"'")}
 ${if(len(nd_name)=0,""," AND nd_code IN('"+nd_name+"')")}
GROUP BY AREA_ORG_NAME,AREA_ORG_CODE,CITY_ORG_NAME,CITY_ORG_CODE,PROJ_NAME,PROJ_CODE,STAGE_NAME,STAGE_CODE,ND_LVL,ND_LVL_NAME
),DTL AS (
SELECT    
 STAGE_CODE,ND_LVL,ND_LVL_NAME,ND_CODE,ND_NAME,PLAN_EDATE,AC_EDATE,BATCH_CODE,BATCH_NAME, BUILD_CODE,BUILD_NAME
 FROM 
 f_plan_all_v T1
 INNER JOIN (SELECT DISTINCT sap_dept_id FROM user_org where dept_level=2) t3 ON T1.CITY_ORG_CODE=t3.sap_dept_id 
 WHERE  1=1
  ${if(len(NODE_LVL)=0,"","and t1.ND_LVL in('"+NODE_LVL+"')")} #一级节点
  ${if(len(begin_date)=0,"","AND DATE_FORMAT(t1.plan_edate,'%Y-%m-%d')>= '"+begin_date+"'")}
  ${if(len(end_date)=0,"","AND DATE_FORMAT(t1.plan_edate,'%Y-%m-%d')<= '"+end_date+"'")}
   ${if(len(nd_name)=0,""," AND nd_code IN('"+nd_name+"')")}
 )-- --------------------------------------- 以上是分期、批次、楼栋计划的明细数据
SELECT 
  ${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t1.area_org_name,t1.area_org_code, " ) }
	${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t1.city_org_name,t1.city_org_code, " ) }
	${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," t1.proj_name,t1.proj_code, " ) }
	${ if(INARRAY("4", SPLIT(dims, ",")) = 0,""," t1.stage_name,t1.stage_code," ) }	
	${ if(INARRAY("5", SPLIT(dims, ",")) = 0,""," 
	CASE WHEN D.OPERAT_FLAG = 'Y' THEN '操盘' WHEN D.OPERAT_FLAG = 'N' THEN '非操盘' ELSE '联合操盘' END OPERAT_FLAG," ) }	
	${ if(INARRAY("6", SPLIT(dims, ",")) = 0,""," D.EQUITY_RATIO/100 AS EQUITY_RATIO," ) }	
  ${ if(INARRAY("7", SPLIT(dims, ",")) = 0,""," t1.ND_LVL,t1.ND_LVL_NAME, " ) }
	${ if(SHOW_DETAIL=0,""," ND_NAME,ND_CODE,BATCH_NAME,BATCH_CODE, BUILD_CODE, BUILD_NAME,PLAN_EDATE,AC_EDATE,CASE WHEN (AC_EDATE> PLAN_EDATE OR AC_EDATE IS NULL )THEN '否' ELSE '是' END IS_INTIME," ) }
	${ if(SHOW_DETAIL=0,"
SUM(ifnull(T1.A,0)) AS 计划节点数,
SUM(ifnull(T1.B,0)) AS 实际节点数,
SUM(ifnull(T1.A,0))-SUM(ifnull(T1.B,0)) 计划减实际,
SUM(ifnull(T1.B,0))/SUM(ifnull(T1.A,0)) AS 完成率,","")}
'FU' as FU
FROM T1 
left join (SELECT DISTINCT PROJ_CODE,EQUITY_RATIO,OPERAT_FLAG FROM dim_project) D on t1.proj_code=D.proj_code
${IF(SHOW_DETAIL = 0 ,"","LEFT JOIN DTL ON T1.STAGE_CODE=DTL.STAGE_CODE and T1.ND_LVL = DTL.ND_LVL ")}   -- 在汇总表的最细粒度基础上再关联明细表
 
where 1=1
${if(len(OPERAT_FLAG)=0,"","and D.OPERAT_FLAG IN ('"+OPERAT_FLAG+"')")} #是否操盘
${if(len(AREAID) == 0,"","and t1.AREA_ORG_CODE in ('" + AREAID + "')")}
${if(len(CITYID) == 0,"","and t1.CITY_ORG_CODE in ('" + CITYID + "')")}
${if(len(PROJID) == 0,"","and t1.PROJ_CODE in ('" + PROJID + "')")}
${if(len(STAGEID)=0,""," AND T1.STAGE_CODE IN('"+STAGEID+"')")}

-- ${if(len(AREANAME) == 0,"","and LEFT(t1.AREA_ORG_NAME,2) ='"+AREANAME+"'")} -- 区域城市驾驶舱穿透
-- ${if(len(CITYNAME) == 0,"","and LEFT(t1.CITY_ORG_NAME,2) ='"+CITYNAME+"'")}  

GROUP BY
  ${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t1.area_org_name,t1.area_org_code, " ) }
	${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t1.city_org_name,t1.city_org_code, " ) }
	${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," t1.proj_name,t1.proj_code, " ) }
	${ if(INARRAY("4", SPLIT(dims, ",")) = 0,""," t1.stage_name,t1.stage_code," ) }	
	${ if(INARRAY("5", SPLIT(dims, ",")) = 0,""," OPERAT_FLAG," ) }	
	${ if(INARRAY("6", SPLIT(dims, ",")) = 0,""," EQUITY_RATIO," ) }	
  ${ if(INARRAY("7", SPLIT(dims, ",")) = 0,""," t1.ND_LVL,t1.ND_LVL_NAME, " ) }
	${ if(SHOW_DETAIL=0,""," ND_NAME,ND_CODE,BATCH_NAME,BATCH_CODE, BUILD_CODE, BUILD_NAME,PLAN_EDATE,AC_EDATE," ) }
  FU

order by 
  ${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," t1.area_org_code, " ) }
	${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," t1.city_org_code, " ) }
	${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," t1.proj_code, " ) }
	${ if(INARRAY("4", SPLIT(dims, ",")) = 0,""," t1.stage_code, " ) }	
  ${ if(INARRAY("7", SPLIT(dims, ",")) = 0,""," t1.ND_LVL, " ) }
	${ if(SHOW_DETAIL=0,""," INSTR('土地获取|项目启动会|定位与产品建议|土地出让合同签订|取得《建设用地规划许可证》|★产品与经营方案评审|
取得《国有土地使用权证》|规划方案批复|取得《建设工程规划许可证》|基础施工图|工程策划与合约规划评审|★开工|
运营策划书评审|总包招标定队|取得《建筑工程施工许可证》|达±0（注明批次）|★示范区开放（销售中心、样板房、园林示范区等分别注明）|
主体达预售形象进度（注明批次楼栋）|开盘方案评审|办理预售许可证|★开盘（注明批次楼栋）|开盘总结|经营现金流回正|主体结构封顶|
外架拆除|精装修工程|园林绿化工程|竣工验收|★竣工备案|股份综合验收|★交付（注明批次）|大产权确权|结算|项目后评估',ND_NAME),BATCH_CODE," ) }
  FU

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
)
order by AREA_ORG_CODE

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

select distinct nd_lvl,nd_lvl_name from f_plan_eng_plan
where nd_lvl is not null 
and nd_lvl in ('R0','R1')

select distinct nd_code,nd_name from f_plan_all_v
order by INSTR('土地获取|项目启动会|定位与产品建议|土地出让合同签订|取得《建设用地规划许可证》|★产品与经营方案评审|
取得《国有土地使用权证》|规划方案批复|取得《建设工程规划许可证》|基础施工图|工程策划与合约规划评审|★开工|
运营策划书评审|总包招标定队|取得《建筑工程施工许可证》|达±0（注明批次）|★示范区开放（销售中心、样板房、园林示范区等分别注明）|
主体达预售形象进度（注明批次楼栋）|开盘方案评审|办理预售许可证|★开盘（注明批次楼栋）|开盘总结|经营现金流回正|主体结构封顶|
外架拆除|精装修工程|园林绿化工程|竣工验收|★竣工备案|股份综合验收|★交付（注明批次）|大产权确权|结算|项目后评估',ND_NAME)

