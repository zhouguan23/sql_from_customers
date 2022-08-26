WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
	AREA_ORG_CODE,
	AREA_ORG_NAME
FROM dim_erp_land
where area_org_code in(
	select distinct area_org_code from user_org a left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
GROUP BY
     AREA_ORG_CODE,
	AREA_ORG_NAME
ORDER BY find_in_set(AREA_ORG_NAME,"珠海区域,华南区域,华东区域,华中区域,山东区域,北方区域,北京区域")

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	city_org_code,city_org_name
FROM dim_erp_land
where 1=1 
and city_org_code in(
select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code
)
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
SELECT 
distinct	PROJ_CODE,PROJ_NAME
FROM dim_project
where 1=1 
and proj_code in( 
	select distinct b.PROJ_CODE from user_org a 
	left join dim_project b on a.SAP_DEPT_ID=b.proj_code 
)
${if(len(AREA) == 0,"","and AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITY_ORG_CODE in ('" + CITY + "')")}

SELECT DISTINCT
	A.STAGE_CODE,
	A.STAGE_NAME
FROM dm_resource_inventory  A
LEFT JOIN  dim_erp_PROJECT B ON A.PROJ_CODE = B.PROJ_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"","and A.PROJ_CODE in ('" + PROJ + "')")}

select distinct 
(case when p.OPERAT_FLAG='Y' then "操盘" when p.OPERAT_FLAG='N'  then "非操盘"   when p.OPERAT_FLAG='U' then '联合操盘'  else p.OPERAT_FLAG end) as OPERAT_FLAG from dim_project p

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}') AND ORG_TYPE='组织'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id WHERE t.ORG_TYPE='组织'
)
, tmp_land as ( #项目土地储备货值
select 
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_CODE, #项目ID
b.PROJ_NAME,
a.STAGE_CODE, #项目分期ID
b.STAGE_NAME,
a.TYPE as build_prod_type_code,
c.STAGE_PROD_TYPE_name as build_prod_type_name,
sum(STOCK_AREA) as STOCK_AREA,
sum(STOCK_SUM) as STOCK_SUM
from ipt_pro_land_stock  a 
left join (select
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME, -- 项目名称
STAGE_CODE, -- 分期编码
STAGE_NAME -- 分期名称
from
dim_staging  -- 项目分期维表
WHERE PERIOD_WID='${pDates}'
UNION ALL
select
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME, -- 项目名称
'wkg001' as STAGE_CODE, -- 分期编码
'尚未创建分期' as STAGE_NAME -- 分期名称
from
dim_project) b on a.STAGE_CODE=b.STAGE_CODE and a.PROJ_CODE=b.PROJ_CODE 
left join (select distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from dim_project_staging_product ) c on a.type = c.STAGE_PROD_TYPE_CODE
where version ='${pDates}'
GROUP BY 
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_CODE, #项目ID
b.PROJ_NAME,
a.STAGE_CODE, #项目分期ID
b.STAGE_NAME,
build_prod_type_code,
build_prod_type_name
)
, tmp_resource as(	 #在途与达工程预售
select
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name,
	sum(case when a.START_NOT_REACH_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as onway_gv, #在途资源
	sum(case when a.REACH_NOT_CERT_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as rpnf_gv #达工程预售未取证
from dm_resource_inventory	a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_COMP_CODE=b.BUILD_TYPE_code and b.version='${pDates}'
WHERE 1=1
and period_wid='${pDates}'
and BUILD_PROD_LV1_TYPE_CODE<>'04'
#${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
group by 
	a.city_org_name,
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
     a.build_prod_type_code,
     a.build_prod_type_name
union
select 
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name,
	sum(case when a.START_NOT_REACH_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as onway_gv, #在途资源
	sum(case when a.REACH_NOT_CERT_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as rpnf_gv #达工程预售未取证
from dm_resource_inventory	a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_COMP_CODE=b.BUILD_TYPE_code and b.version='${pDates}'
WHERE 1=1
and period_wid='${pDates}'
# ${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
and BUILD_PROD_LV1_TYPE_CODE='04'
group by
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name
),tmp_resource_cert as( #全周期资源盘点：取证未认购需先去重
select 
   t1.area_org_code,
   t1.area_org_name,
	 t1.city_org_code,
	 t1.city_org_name,
	 t1.proj_code,
	 t1.proj_name,
	 t1.stage_code,
	 t1.stage_name,
   t1.build_prod_type_code,
   t1.build_prod_type_name,
 case when t2.cert_unorder_gv <>0 and t2.cert_unorder_gv is not null and t2.cert_unorder_gv<>'' then t2.cert_unorder_gv else t3.cert_unorder_gv end cert_unorder_gv  
 -- 当dm表不是0且不为空的时候，取dm表，否则取填报表
from                      -- 维度表，取填报表和资源表的所有项目
(select distinct
  area_org_code,
  area_org_name,
	city_org_code,
	city_org_name,
	proj_code,
	proj_name,
	stage_code,
	stage_name,
  build_prod_type_code,
  build_prod_type_name
	from dm_resource_inventory
	where  period_wid='${pDates}'
	union
	select 
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_ID as PROJ_CODE,
b.PROJ_NAME,
a.STAGE_ID as STAGE_CODE,
b.STAGE_NAME,
a.TYPE as build_prod_type_code,
c.STAGE_PROD_TYPE_name as build_prod_type_name
from ipt_mkt_stock a 
LEFT JOIN dim_staging b on a.STAGE_ID=b.STAGE_CODE
left join (select distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from dim_project_staging_product) c on a.type = c.STAGE_PROD_TYPE_CODE
where version='${pDates}' and PERIOD_WID=left(now(),7)
and STOCK<> 0 and STOCK is not null and STOCK <>''
)t1 
left join 
(select                         -- 系统数据
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
     a.build_prod_type_code,
     a.build_prod_type_name,
	sum(CERT_UNORDER_PRICE) as cert_unorder_gv #取证未认购
from (
select distinct 
	area_org_code,
	area_org_name,
	city_org_code,
	city_org_name,
	proj_code,
	proj_name,
	stage_code,
	stage_name,
     build_prod_type_code,
     build_prod_type_name,
	period_wid,
	MARKET_BUILD_ID,
	CERT_UNORDER_PRICE 
	from dm_resource_inventory) a
WHERE 1=1
and period_wid='${pDates}'
#${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
group by
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name
	) t2 on t1.stage_code = t2.stage_code and t1.build_prod_type_code= t2.build_prod_type_code
left join
(                   -- 填报数据
	select 
a.VERSION as PERIODID,
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_ID as PROJ_CODE,
b.PROJ_NAME,
a.STAGE_ID as STAGE_CODE,
b.STAGE_NAME,
a.TYPE as build_prod_type_code,
c.STAGE_PROD_TYPE_name as build_prod_type_name,
sum(STOCK)*10000 as cert_unorder_gv
from ipt_mkt_stock a 
LEFT JOIN dim_staging b on a.STAGE_ID=b.STAGE_CODE
left join (select distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from dim_project_staging_product) c on a.type = c.STAGE_PROD_TYPE_CODE
where version='${pDates}' and PERIOD_WID=left(now(),7)
and STOCK<> 0 and STOCK is not null and STOCK <>''
GROUP BY 
PERIODID,
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_ID,
b.PROJ_NAME,
a.STAGE_ID,
b.STAGE_NAME,
build_prod_type_code,
build_prod_type_name
) t3  on t1.stage_code = t3.stage_code and t1.build_prod_type_code= t3.build_prod_type_code
),

full_name as(
select distinct a.* from (
select a.area_org_code,a.area_org_name,a.city_org_code,a.city_org_name,a.proj_code,a.proj_name,a.stage_code,a.stage_name,build_prod_type_name,build_prod_type_CODE from tmp_resource a
union 
select c.area_org_code,c.area_org_name,c.city_org_code,c.city_org_name,c.proj_code,c.proj_name,c.stage_code,c.stage_name,build_prod_type_name,build_prod_type_CODE from tmp_resource_cert c
UNION 
select d.AREA_ORG_CODE,d.AREA_ORG_NAME,d.CITY_ORG_CODE,d.CITY_ORG_NAME,d.PROJ_CODE,d.PROJ_NAME,d.STAGE_CODE, d.STAGE_NAME,build_prod_type_name,build_prod_type_CODE from tmp_land d
)a
)


select 
	1 as a,
		${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
ROUND(SUM(ifnull(d.STOCK_SUM,0)),2)  AS '项目土储',
ROUND(SUM(ifnull(a.onway_gv,0))/10000,2)  AS '在途资源',
	ROUND(SUM(ifnull(a.rpnf_gv,0))/10000,2)  AS '达工程预售未取证',
	ROUND(SUM(ifnull(C.cert_unorder_gv,0))/10000,2)  AS '取证未认购'
	from full_name f
left join tmp_resource a on a.STAGE_CODE = f.STAGE_CODE and a.build_prod_type_code = f.build_prod_type_code
left join tmp_resource_cert c on c.STAGE_CODE = f.STAGE_CODE and c.build_prod_type_code = f.build_prod_type_code
left join tmp_land d on  d.STAGE_CODE=f.STAGE_CODE and d.build_prod_type_code = f.build_prod_type_code AND F.proj_code=D.proj_code
left join dim_project p on   f.proj_code=p.PROJ_CODE 
where 
1=1
${if(len(OPERAT_FLAG) == 0,"","and (case when p.OPERAT_FLAG='Y' then '操盘' when p.OPERAT_FLAG='N'  then '非操盘'  when p.OPERAT_FLAG='U' then '联合操盘'  else p.OPERAT_FLAG end) in('" + OPERAT_FLAG + "')")}
${if(len(AREA) == 0,"and f.AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and f.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"and f.CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and f.CITY_ORG_CODE in ('" + CITY + "')")}
${if(len(PROJ) == 0,"and f.PROJ_CODE in( select distinct sap_dept_id from user_org a )","and f.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE)=0,""," AND f.STAGE_CODE IN('"+STAGE+"')")}
${if(len(PROD)=0,""," AND f.build_prod_type_code IN('"+PROD+"')")}
GROUP BY
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
a
order by 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
a



SELECT DISTINCT
	A.BUILD_PROD_TYPE_CODE,
     A.BUILD_PROD_TYPE_NAME
FROM dm_resource_inventory  A
LEFT JOIN  dim_erp_PROJECT B ON A.PROJ_CODE = B.PROJ_CODE
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.city_org_code in ('" + CITY + "')")}
${if(len(PROJ) == 0,"","and A.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE) == 0,"","and A.STAGE_CODE in ('" + STAGE + "')")}

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org where user_id='${fine_username}') AND ORG_TYPE='组织'
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id WHERE t.ORG_TYPE='组织'
)
, tmp_land as ( #项目土地储备货值
select 
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_CODE, #项目ID
b.PROJ_NAME,
a.STAGE_CODE, #项目分期ID
b.STAGE_NAME,
a.TYPE as build_prod_type_code,
c.STAGE_PROD_TYPE_name as build_prod_type_name,
sum(STOCK_AREA) as STOCK_AREA,
sum(STOCK_SUM) as STOCK_SUM
from ipt_pro_land_stock  a 
left join (select
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME, -- 项目名称
STAGE_CODE, -- 分期编码
STAGE_NAME -- 分期名称
from
dim_staging  -- 项目分期维表
WHERE PERIOD_WID='${pDates}'
UNION ALL
select
AREA_ORG_CODE,
AREA_ORG_NAME,
CITY_ORG_CODE, -- 城市公司代码
CITY_ORG_NAME, -- 城市公司名称
PROJ_CODE, -- 项目编码
PROJ_NAME, -- 项目名称
'wkg001' as STAGE_CODE, -- 分期编码
'尚未创建分期' as STAGE_NAME -- 分期名称
from
dim_project) b on a.STAGE_CODE=b.STAGE_CODE and a.PROJ_CODE=b.PROJ_CODE 
left join (select distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from dim_project_staging_product ) c on a.type = c.STAGE_PROD_TYPE_CODE
where version ='${pDates}'
GROUP BY 
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_CODE, #项目ID
b.PROJ_NAME,
a.STAGE_CODE, #项目分期ID
b.STAGE_NAME,
build_prod_type_code,
build_prod_type_name
)
, tmp_resource as(	 #在途与达工程预售不含车位货值
select
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name,
	sum(case when a.START_NOT_REACH_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as onway_gv, #在途资源
	sum(case when a.REACH_NOT_CERT_FLAG='Y' then a.SALE_AREA * ifnull(b.UNIT_PRICE,0) else 0 end) as rpnf_gv #达工程预售未取证
from dm_resource_inventory	a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_COMP_CODE=b.BUILD_TYPE_code and b.version='${pDates}'
WHERE 1=1
and period_wid='${pDates}'
and BUILD_PROD_LV1_TYPE_CODE<>'04'
#${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
group by 
	a.city_org_name,
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
     a.build_prod_type_code,
     a.build_prod_type_name
union
select 
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name,
	sum(case when a.START_NOT_REACH_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as onway_gv, #在途资源
	sum(case when a.REACH_NOT_CERT_FLAG='Y' then a.CARPORT_NUM * ifnull(b.UNIT_PRICE,0) else 0 end) as rpnf_gv #达工程预售未取证
from dm_resource_inventory	a
left join ipt_mkt_build_price b on a.BUILD_CODE=b.BUILD_CODE and a.BUILD_PROD_TYPE_COMP_CODE=b.BUILD_TYPE_code and b.version='${pDates}'
WHERE 1=1
and period_wid='${pDates}'
# ${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
and BUILD_PROD_LV1_TYPE_CODE='04'
group by
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name
),tmp_resource_cert as( #全周期资源盘点：取证未认购需先去重
select 
	a.PERIOD_WID as PERIODID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
     a.build_prod_type_code,
     a.build_prod_type_name,
	sum(CERT_UNORDER_PRICE) as cert_unorder_gv #取证未认购
from (
select distinct 
	area_org_code,
	area_org_name,
	city_org_code,
	city_org_name,
	proj_code,
	proj_name,
	stage_code,
	stage_name,
     build_prod_type_code,
     build_prod_type_name,
	period_wid,
	MARKET_BUILD_ID,
	CERT_UNORDER_PRICE 
	from dm_resource_inventory) a
WHERE 1=1
and period_wid='${pDates}'
#${if(len(pArea)=0," "," and a.area_org_code ='"+pArea+"'")}
group by
	a.PERIOD_WID,
	a.area_org_code,
	a.area_org_name,
	a.city_org_code,
	a.city_org_name,
	a.proj_code,
	a.proj_name,
	a.stage_code,
	a.stage_name,
  a.build_prod_type_code,
  a.build_prod_type_name
	
	union all  #拼接非营销操盘取证未认购存货

	select 
a.VERSION as PERIODID,
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_ID as PROJ_CODE,
b.PROJ_NAME,
a.STAGE_ID as STAGE_CODE,
b.STAGE_NAME,
a.TYPE as build_prod_type_code,
c.STAGE_PROD_TYPE_name as build_prod_type_name,
sum(STOCK)*10000 as cert_unorder_gv
from ipt_mkt_stock a LEFT JOIN dim_staging b on a.STAGE_ID=b.STAGE_CODE
left join (select distinct STAGE_PROD_TYPE_CODE,STAGE_PROD_TYPE_NAME from dim_project_staging_product) c on a.type = c.STAGE_PROD_TYPE_CODE
where version='${pDates}' and PERIOD_WID=left(now(),7)
and STOCK<> 0 and STOCK is not null and STOCK <>''
GROUP BY 
PERIODID,
b.AREA_ORG_CODE,
b.AREA_ORG_NAME,
b.CITY_ORG_CODE,
b.CITY_ORG_NAME,
a.PROJ_ID,
b.PROJ_NAME,
a.STAGE_ID,
b.STAGE_NAME,
build_prod_type_code,
build_prod_type_name
),full_name as(
select distinct a.* from (
select a.area_org_code,a.area_org_name,a.city_org_code,a.city_org_name,a.proj_code,a.proj_name,a.stage_code,a.stage_name,build_prod_type_name,build_prod_type_CODE from tmp_resource a
union all
select c.area_org_code,c.area_org_name,c.city_org_code,c.city_org_name,c.proj_code,c.proj_name,c.stage_code,c.stage_name,build_prod_type_name,build_prod_type_CODE from tmp_resource_cert c
UNION ALL 
select d.AREA_ORG_CODE,d.AREA_ORG_NAME,d.CITY_ORG_CODE,d.CITY_ORG_NAME,d.PROJ_CODE,d.PROJ_NAME,d.STAGE_CODE, d.STAGE_NAME,build_prod_type_name,build_prod_type_CODE from tmp_land d
)a
)


select 
	1 as a,
		${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
ROUND(SUM(ifnull(d.STOCK_SUM,0)),2)  AS '项目土储',
ROUND(SUM(ifnull(a.onway_gv,0))/10000,2)  AS '在途资源',
	ROUND(SUM(ifnull(a.rpnf_gv,0))/10000,2)  AS '达工程预售未取证',
	ROUND(SUM(ifnull(C.cert_unorder_gv,0))/10000,2)  AS '取证未认购'
	from full_name f
left join tmp_resource a on a.STAGE_CODE = f.STAGE_CODE and a.build_prod_type_code = f.build_prod_type_code
left join tmp_resource_cert c on c.STAGE_CODE = f.STAGE_CODE and c.build_prod_type_code = f.build_prod_type_code
left join tmp_land d on  d.STAGE_CODE=f.STAGE_CODE and d.build_prod_type_code = f.build_prod_type_code AND F.proj_code=D.proj_code
left join dim_project p on   f.proj_code=p.PROJ_CODE 
where 
1=1
${if(len(OPERAT_FLAG) == 0,"","and (case when p.OPERAT_FLAG='Y' then '操盘' when p.OPERAT_FLAG='N'  then '非操盘'  when p.OPERAT_FLAG='U' then '联合操盘'  else p.OPERAT_FLAG end) in('" + OPERAT_FLAG + "')")}
${if(len(AREA) == 0,"and f.AREA_ORG_CODE in ( select distinct b.AREA_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and f.AREA_ORG_CODE in ('" + AREA + "')")}
${if(len(CITY) == 0,"and f.CITY_ORG_CODE in ( select distinct b.CITY_ORG_CODE from user_org a  left join dim_project b on a.SAP_DEPT_ID=b.proj_code)","and f.CITY_ORG_CODE in ('" + CITY + "')")}
${if(len(PROJ) == 0,"and f.PROJ_CODE in( select distinct sap_dept_id from user_org a )","and f.PROJ_CODE in ('" + PROJ + "')")}
${if(len(STAGE)=0,""," AND f.STAGE_CODE IN('"+STAGE+"')")}
${if(len(PROD)=0,""," AND f.build_prod_type_code IN('"+PROD+"')")}
GROUP BY
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
a
order by 
	${ if(INARRAY("1", SPLIT(show, ",")) = 0,"","f.area_org_name," ) }
	${ if(INARRAY("2", SPLIT(show, ",")) = 0,"","f.city_org_name," ) }
	${ if(INARRAY("3", SPLIT(show, ",")) = 0,"","f.proj_name," ) }
	${ if(INARRAY("4", SPLIT(show, ",")) = 0,"","f.stage_name," ) }
  ${ if(INARRAY("5", SPLIT(show, ",")) = 0,"","f.build_prod_type_name," ) }
a



