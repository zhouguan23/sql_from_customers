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
SELECT DISTINCT b.proj_code,b.proj_name 
FROM user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
where 1=1
${if(len(areaname)=0,"","and area_org_code in ('"+areaname+"')")}
${if(len(cityname)=0,"","and city_org_code in ('"+cityname+"')")}
order by proj_code

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT DISTINCT stage_code,stage_name
FROM dim_project_staging_product
where 1=1
${if(len(areaname)=0,"","and area_org_code in ('"+areaname+"')")}
${if(len(cityname)=0,"","and city_org_code in ('"+cityname+"')")}
${if(len(projname)=0,"","and proj_code in ('"+projname+"')")}
and proj_code in (
select distinct sap_dept_id from user_org 
)
order by stage_code


WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)

select 	
AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,
PROJ_CODE,PROJ_NAME,T1.STAGE_CODE,CONCAT(T1.PROJ_NAME,'  ',T1.stage_name)stage_name,stage_profile,t1.ND_CODE,t1.ND_NAME,
CASE WHEN nd_name = '项目后评估' and AC_EDATE IS not NULL THEN 1 ELSE 0 END IS_SHOW,  -- 用来控制是否显示老项目
CASE WHEN BUILD_CODE IS NULL THEN 1 ELSE 0 END CENTER,  -- 用来控制字段是否居中
count(t2.nd_code) is_file,
${if(detail = 0 ,"max(plan_edate)","GROUP_CONCAT(case when batch_name <>'' then concat('▶', batch_name,'\n',build_name,': ') else '' end, case when plan_edate <>'' and plan_edate is not null then plan_edate else '未录入' end order by t1.batch_code separator '\n------------------------\n') ")} PLAN_EDATE,
${if(detail = 0 ,"max(ac_edate)","GROUP_CONCAT(case when batch_name <>'' then concat('▶', batch_name,'\n',build_name,': ') else '' end, case when ac_edate <>'' and ac_edate is not null then ac_edate else '暂无' end order by t1.batch_code separator '\n------------------------\n') ")} ac_edate

from f_plan_all_v t1
left join ipt_plan_stage_profile GK on t1.STAGE_CODE = GK.STAGE_CODE
left join(
select  distinct stage_code,nd_code
from f_plan_fb_attach_guid t2
left join f_plan_fb_attachfile_d t3 on t2.addads = t3.guid
where file_url is not null
)t2 on t1.stage_code = t2.stage_code  and t1.nd_code = t2.nd_code

/*
left join f_plan_fb_attach_guid t2
on t1.stage_code = t2.stage_code and t1.batch_code = t2.batch_code and t1.nd_code = t2.nd_code
*/
/*(
(t2.batch_code <> '' and t1.stage_code = t2.stage_code and t1.batch_code = t2.batch_code and t1.nd_code = t2.nd_code)
or
(t2.batch_code = '' and t1.stage_code = t2.stage_code and t1.nd_code = t2.nd_code)
)*/
-- 判断是否有附件
where 1=1
${if(len(areaname)=0,"","and AREA_ORG_CODE in ('"+areaname+"')")}
${if(len(cityname)=0,"","and CITY_ORG_CODE in ('"+cityname+"')")}
${if(len(projname)=0,"","and PROJ_CODE in ('"+projname+"')")}
${if(len(stagename)=0,"","and T1.STAGE_CODE in ('"+stagename+"')")}
and PROJ_CODE in (
select distinct sap_dept_id from user_org 
)
GROUP BY 
AREA_ORG_CODE,AREA_ORG_NAME,CITY_ORG_CODE,CITY_ORG_NAME,PROJ_CODE,PROJ_NAME,T1.STAGE_CODE,stage_name,stage_profile,t1.ND_CODE,t1.ND_NAME,IS_SHOW,CENTER
and PROJ_CODE in (
select distinct sap_dept_id from user_org 
)
order by PROJ_CODE,STAGE_CODE,INSTR('土地获取|项目启动会|定位与产品建议|土地出让合同签订|取得《建设用地规划许可证》|★产品与经营方案评审|
取得《国有土地使用权证》|规划方案批复|取得《建设工程规划许可证》|基础施工图|工程策划与合约规划评审|★开工|
运营策划书评审|总包招标定队|取得《建筑工程施工许可证》|达±0（注明批次）|★示范区开放（销售中心、样板房、园林示范区等分别注明）|
主体达预售形象进度（注明批次楼栋）|开盘方案评审|办理预售许可证|★开盘（注明批次楼栋）|开盘总结|经营性现金流回正|主体结构封顶|
外架拆除|精装修工程|园林绿化工程|竣工验收|★竣工备案|股份综合验收|★交付（注明批次）|大产权确权|结算|项目后评估',ND_NAME)

select nd_num,nd_level,nd_name,comp_std,judge_dept
from ipt_plan_comp_std

