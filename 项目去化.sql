WITH RECURSIVE user_org as
(
  select m.* from fr_org_mkt m inner join (select dept_id from fr_user_org_mkt where user_id='${fine_username}' )l on m.dept_id=l.dept_id
  UNION ALL
  select t.* from fr_org_mkt t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT 
distinct	AREA_ID,AREA_NAME
FROM f_mkt_project_sale
where area_id in(
	select distinct c.area_id from user_org a 
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on a.dept_id=c.proj_id
)

WITH RECURSIVE user_org as
(
  select m.* from fr_org_mkt m inner join (select dept_id from fr_user_org_mkt where user_id='${fine_username}' )l on m.dept_id=l.dept_id
  UNION ALL
  select t.* from fr_org_mkt t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT 
distinct	CITY_ID,CITY_NAME
FROM f_mkt_project_sale
where area_id in(
	select distinct c.area_id from user_org a 
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on a.dept_id=c.proj_id
)
${if(len(AREA) == 0,"","and area_id in ('" + AREA + "')")}

WITH RECURSIVE user_org as
(
  select m.* from fr_org_mkt m inner join (select dept_id from fr_user_org_mkt where user_id='${fine_username}' )l on m.dept_id=l.dept_id
  UNION ALL
  select t.* from fr_org_mkt t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT 
distinct	PROJ_ID,PROJ_NAME
FROM f_mkt_project_sale
where area_id in(
	select distinct c.area_id from user_org a 
	left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from dim_mkt_project) c on a.dept_id=c.proj_id
)
${if(len(AREA) == 0,"","and area_id in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and city_id in ('" + CITY + "')")}

SELECT DISTINCT
	B.STAGE_ID,
	B.STAGE_NAME
FROM f_mkt_project_quhua a
LEFT JOIN  gfreport.dim_mkt_project B ON A.STAGE_ID = B.STAGE_ID
WHERE 1=1 
${if(len(AREA) == 0,"","and B.AREA_ID in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and B.CITY_ID in ('" + CITY + "')")}
${if(len(PROJ) == 0,"","and B.PROJ_ID in ('" + PROJ + "')")}

WITH RECURSIVE user_org as
(
  select m.* from gfreport.fr_org_mkt m inner join (select dept_id from gfreport.fr_user_org_mkt where user_id='${fine_username}' )l on m.dept_id=l.dept_id
  UNION ALL
  select t.* from gfreport.fr_org_mkt t inner join user_org tcte on t.parent_id = tcte.dept_id
)
select
a.id,
a.yearmonth,
a.areaname,
a.cityname,
a.projectid,
a.projectname,
a.stage_id,
a.stage_name,
a.ks_suit,
a.ks_inside_amount,
a.xtp_suit,
a.xtp_inside_amount,
a.ks_sale_suit,
a.ks_sale_amount,
a.xtp_sale_suit,
a.xtp_sale_amount,
a.xkp_sale_suit,
a.xkp_sale_amount,
a.stock_amount,
a.sale_amount,
(a.xtp_sale_amount+a.xkp_sale_amount) / a.ks_inside_amount as qh_rat,
a.w_insert_dt
from
f_mkt_project_quhua a 
left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name,stage_id,stage_name from gfreport.dim_mkt_project) b on a.stage_id=b.stage_id
WHERE 1=1
${if(len(AREA) == 0," and b.area_id in(
	select distinct b.area_id from user_org a left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from gfreport.dim_mkt_project) b on a.dept_id=b.proj_id
)","and b.AREA_ID in ('" + AREA + "')")}
${if(len(CITY) == 0," and b.city_id in(
	select distinct b.city_id from user_org a left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from gfreport.dim_mkt_project) b on a.dept_id=b.proj_id
)","and b.city_id in ('" + CITY + "')")}
${if(len(PROJ) == 0," and b.proj_id in(
	select distinct b.proj_id from user_org a left join (select distinct area_id,area_name,city_id,city_name,proj_id,proj_name from gfreport.dim_mkt_project) b on a.dept_id=b.proj_id
)","and b.proj_id in ('" + PROJ + "')")}
${if(len(STAGE) == 0," ","and b.stage_id in ('" + STAGE + "')")}
order by b.area_id,b.city_id

