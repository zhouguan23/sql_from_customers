SELECT
	count( DISTINCT ps.sup_id ) AS cntsup,
	count( DISTINCT psc.coop_id ) AS cntcoop,
	count( DISTINCT po1.prj_number ) AS cntprj,
	sum( IF ( pqs.out_type = '0' AND pqs.STATUS <> '1', 0.5, 0 ) ) AS ljkqrts,
	sum( IF ( pqs.STATUS = '2', 0.5, 0 ) ) AS dshrts,
/*count( DISTINCT ps.sup_id, IF ( pqs.USER IS NULL AND pqs2.USER IS NOT NULL, TRUE, NULL ) ) AS wqdsup,*/
	sum( IF ( pqs.day IS NULL AND state = '0', 0.5, 0 ) ) AS wqdrts,
	count(DISTINCT ppr.role_project, IF ( pqs2.USER IS NULL, TRUE, NULL ) ) AS 0qdprj 
FROM
	prj_project_role ppr
	LEFT JOIN ( SELECT USER, project, min( DAY ) minday FROM prj_qiandao_supplier WHERE user_type = '0'and status <>'1' GROUP BY  USER,project) g ON ppr.role_user = g.USER 
	AND g.project = ppr.role_project 
 JOIN project_opportunity1 po1 ON  po1.key_id = ppr.role_project
 AND ppr.role_verified = 'valid' AND ppr.role_type = 0 AND ppr.role_plan_end >= '${startdate}' and ppr.role_plan_start <= SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 )
	LEFT JOIN prj_supervise_manage psm ON po1.key_id = psm.sup_keyid
	JOIN project_status prjs ON po1.prj_status = prjs.prj_status 
	AND prjs.project_qiandao = '签到衡量'
	JOIN hr_department_team hdt ON hdt.team_id = po1.prj_team
	JOIN prj_team_forsupplier ptf ON hdt.team_id = ptf.team_id 
	AND ptf.team_supplier = 72
	JOIN project_supplier_cooperation psc ON psc.coop_id = ppr.role_user 
	AND psc.coop_enabled = 'true' 
	AND psc.coop_state <> '离职'
	JOIN project_supplier ps ON ps.sup_id = psc.coop_supplier 
	AND ps.sup_available = 'true' 
	AND ps.sup_service_state = '启用'
	JOIN ( SELECT date, state, type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t ) hw ON hw.date BETWEEN ifnull( ppr.role_actual_start, ifnull( g.minday, ppr.role_plan_start ) ) 
	AND ppr.role_plan_end 
	AND hw.date NOT BETWEEN '2020-01-31' 
	AND '2020-02-23' 
	AND hw.date BETWEEN '${startdate}' 
	AND SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 )
	LEFT JOIN (
SELECT USER
	,
	count( id ) 
FROM
	prj_qiandao_supplier pqs 
WHERE
	pqs.DAY BETWEEN '${startdate}' 
	AND SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 ) 
	AND pqs.STATUS <> '1' 
GROUP BY
USER 
	) pqs2 ON ppr.role_user = pqs2.USER 
		LEFT JOIN (select le_keyid as project,le_coop as user,date as day ,type as day_type,'0'as status,'0'as out_type from prj_coop_leave pcl JOIN ( SELECT date,type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t ) hw on hw.date between le_startdate and le_enddate GROUP BY le_keyid,le_coop,date,type
union select project,user,day,day_type,status,out_type from prj_qiandao_supplier where STATUS <> '1' GROUP BY user,project,day,day_type) pqs ON ppr.role_user = pqs.USER 
	AND hw.date = pqs.DAY 
	AND hw.type = pqs.day_type 	
WHERE
	'${sheet}' = "项目经理" 
	and ifnull(psm.sup_type,'监管') <> '不监管' 
	and po1.prj_is_check <>'1'
	${IF(len(team) = 0, "", "and po1.prj_team in('" + team + "')" ) } 
	${IF(len(prjnum) = 0, "", "and po1.prj_number like '%" + prjnum + "%' " ) }
	${IF(len( pm ) = 0, "", "and po1.projectmanager in('" + pm + "')" ) } 
	${IF(len( region ) = 0, "", "and hdt.team_region in('" + region + "')" ) } 
	${IF(len( supplier ) = 0, "", "and ps.sup_id in ('" + supplier + "')" ) }
	${IF(len( coop ) = 0, "", "and psc.coop_id in('" + coop + "')" ) }

select hdt.team_id,hdt.team_name,hdt.team_region,po1.projectmanager,po1.projectmanager_name as pmname 
from hr_department_team hdt 
join project_opportunity1 po1 on hdt.team_id = po1.prj_team 
join project_status prjs on po1.prj_status = prjs.prj_status
and prjs.project_qiandao  = '签到衡量'
join prj_team_forsupplier ptf on hdt.team_id = ptf.team_id and ptf.team_supplier = 72 
${if(len(region)=0,"","and hdt.team_region in('"+region+"')")}
${if(len(team)=0,"","and po1.prj_team in('"+team+"')")}
order by hdt.team_paixu

select ps.sup_id,ps.sup_name,psc.coop_id,psc.coop_name
from project_supplier ps join project_supplier_cooperation psc 
on ps.sup_new_id = psc.coop_supplier_id where ps.sup_available = 'true' and ps.sup_service_state = '启用'
AND psc.coop_enabled = 'true' and psc.coop_state <> '离职'
${if(len(supplier)=0,"","and ps.sup_id in('"+supplier+"')")}

SELECT
	hdt.team_region AS 区域,
	hdt.team_id AS 团队,
	hdt.team_name,
	count( DISTINCT po1.prj_number ) AS 项目总数,
	count( DISTINCT po1.prj_number, IF ( ( pqs.USER IS NULL ), TRUE, NULL ) ) AS 未满签项目数,
	sum(if( state ='0' ,0.5,0) ) AS 应签人天数,
	sum( IF ( pqs.USER IS NULL AND state = '0', 0.5, 0 ) ) AS 未满签人天数,
	sum( IF ( pqs.STATUS = '0', 0.5, 0 ) ) AS 已签已审人天数,
	sum( IF ( ( pqs.STATUS = '2' ), 0.5, 0 ) ) AS 待审核人天数 
FROM
  prj_project_role ppr
	LEFT JOIN ( SELECT USER, project, min( DAY ) minday FROM prj_qiandao_supplier  where  status <>'1' GROUP BY USER,project ) g ON ppr.role_user = g.USER 
	AND g.project = ppr.role_project 	
	 /* 项目中为外包人员 且状态有效 时间为统计的时间段*/
	JOIN project_opportunity1  po1 ON po1.key_id = ppr.role_project 

	AND ppr.role_type = 0 
	AND ppr.role_verified = 'valid' 
	AND ppr.role_plan_end >= '${startdate}' 
	and ppr.role_plan_start <='${enddate}'
	left join prj_supervise_manage psm on po1.key_id  = psm.sup_keyid  /* 统计时间段内有效的项目*/
	JOIN project_status prjs ON po1.prj_status = prjs.prj_status 
	AND prjs.project_qiandao = '签到衡量'
	JOIN hr_department_team hdt ON po1.prj_team = hdt.team_id
	JOIN prj_team_forsupplier ptf ON hdt.team_id = ptf.team_id 
	AND ptf.team_supplier = 72
	JOIN project_supplier_cooperation psc  ON ppr.role_user = psc.coop_id 
	AND psc.coop_enabled = 'true' 
	AND psc.coop_state <> '离职' /*启用状态下的供应商的可用人员*/
	join project_supplier ps ON ps.sup_id = psc.coop_supplier
	AND ps.sup_available = 'true' 
	AND ps.sup_service_state = '启用' 
	JOIN ( SELECT date, state, type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t ) hw ON hw.date BETWEEN ifnull( g.minday, ppr.role_plan_start ) 
	AND ppr.role_plan_end 
	AND hw.date >= '${startdate}' 
	AND hw.date <= '${enddate}' 
	AND hw.date NOT BETWEEN '2020-01-31' 
	AND '2020-02-23' 
	and hw.state = '0'
	LEFT JOIN (select le_keyid as project,le_coop as user,date as day ,type as day_type,'0'as status,'0'as out_type from prj_coop_leave pcl JOIN ( SELECT date,type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t ) hw on hw.date between le_startdate and le_enddate GROUP BY le_keyid,le_coop,date,type
union select project,user,day,day_type,status,out_type from prj_qiandao_supplier where STATUS <> '1' GROUP BY user,project,day,day_type) pqs ON ppr.role_user = pqs.USER 
	AND hw.date = pqs.DAY 
	AND hw.type = pqs.day_type 
where  
'${sheet}'="项目经理"
and ifnull(psm.sup_type,'监管') <> '不监管'  
and po1.prj_is_check <>'1'
${if(len(team)=0,"","and po1.prj_team in('"+team+"')")}
${if(len(prjnum)=0,"","and po1.prj_number like '%"+prjnum+"%' ")}
${if(len(pm)=0,"","and po1.projectmanager in('"+pm+"')")}
${if(len(region)=0,"","and hdt.team_region in('"+region+"')")}
${if(len(supplier)=0,"","and ps.sup_id in ('"+supplier+"')")}
${if(len(coop)=0,"","and psc.coop_id in('"+coop+"')")}
GROUP BY hdt.team_region,hdt.team_id
order by hdt.team_region,hdt.team_paixu


select *,max(d_day) AS mday,max(d_night) AS mnight from(
select sup_id,sup_name,role_user coop_id,coop_name,date,if(day_type=0,"✔",null)as d_day,if(day_type=1,"✔",null) as d_night,state  from (
select a.team_region,h.key_id,i.role_user,d.coop_name,c.sup_id,c.sup_name, if(ifnull(min(j.day),min(i.role_plan_start))<'${startdate}','${startdate}',ifnull(min(j.day),min(i.role_plan_start))) startdate,if(max(i.role_plan_end)>='${enddate}','${enddate}',max(i.role_plan_end)) enddate from project_opportunity1 h 
join hr_department_team a on h.prj_team  = a.team_id
join project_status prjs on h.prj_status = prjs.prj_status
and prjs.project_qiandao  = '签到衡量'
join prj_team_forsupplier ptf on a.team_id = ptf.team_id and ptf.team_supplier = 72 
join prj_project_role i on h.key_id = i.role_project and i.role_type ='0' and i.role_plan_end >='${startdate}'
join project_supplier c on i.role_supplier = c.sup_id and c.sup_service_state ='启用'	AND c.sup_available = 'true' 
join project_supplier_cooperation d on i.role_user = d.coop_id and d.coop_state<>'离职' and d.coop_enabled ='true'
join (select user,min(day) minday from prj_qiandao_supplier where user_type ='0' group by user) g on d.coop_id = g.user and minday <= SUBDATE(current_date(),DATE_FORMAT(current_date(),'%w')+2) /*最小签到日期*/
left join prj_qiandao_supplier j on ((h.key_id = j.project and j.project_type ='项目实施' and i.role_user = j.user and i.role_type = j.user_type ) or (h.prj_number = j.project and j.project_type ='需求评估' and i.role_user = j.user and i.role_type = j.user_type)) and j.status =0 and j.`day` >='2019-07-01'
where 1=1
${if(mingxi="false","and 1=2","")}
${if(len(team)=0,"","and h.prj_team in('"+team+"')")}
${if(len(prjnum)=0,"","and h.prj_number like '%"+prjnum+"%' ")}
${if(len(pm)=0,"","and h.projectmanager in('"+pm+"')")}
${if(len(region)=0,"","and a.team_region in('"+region+"')")}
${if(len(supplier)=0,"","and sup_id in ('"+supplier+"')")}
${if(len(coop)=0,"","and coop_id in('"+coop+"')")}
group by team_region,h.key_id,i.role_user)a
join (select date,state,type from hr_workdays cross join(select 0 as type union select 1)as t ) b on b.date between a.startdate and a.enddate  and 
b.date not between '2020-01-31'and '2020-02-23' 
left join prj_qiandao_supplier c on a.role_user = c.user and b.type = c.day_type and c.`day` = b.date and c.status<>1
order by date,sup_id,role_user
) AS final
GROUP BY sup_id,coop_id,date
order by date
 

select * from hr_department_team hdt join prj_team_forsupplier ptf on hdt.team_id = ptf.team_id and ptf.team_supplier = 72 
${if(len(region)=0,"","and hdt.team_region in('"+region+"')")}
group by hdt.team_paixu

select hdt.team_id,hdt.team_name,hdt.team_region from hr_department_team hdt where team_name like '项目%组' 

/*供应商视角*/
SELECT
	count( DISTINCT ps.sup_id ) AS cntsup,
	count( DISTINCT pqs.USER ) AS cntcoop,
	count( DISTINCT ppr.role_project) AS cntprj,
	sum( IF ( ( pqs.day_type = 0 AND pqs.STATUS <> 1 ), 0.5, 0 ) ) + sum( IF ( ( pqs.day_type = 1 AND pqs.STATUS <> 1 ), 0.5, 0 ) ) AS ljkqrts,
	sum( IF ( ( pqs.day_type = 0 AND pqs.STATUS = 2 ), 0.5, 0 ) ) + sum( IF ( ( pqs.day_type = 1 AND pqs.STATUS = 2 ), 0.5, 0 ) ) AS dshrts,
	count( DISTINCT ps.sup_id, IF ( pqs.USER IS NULL and hw.state = '0', TRUE, NULL ) ) AS wqdsup,
	sum(if(pqs.user is null and pqs2.user is not null,0.5,0)) AS wqdrts,
	count( DISTINCT ppr.role_project, IF ( pqs2.USER IS NULL, TRUE, NULL ) ) AS 0qdprj 
FROM
	project_supplier ps
	JOIN ( SELECT dist_province, dist_region FROM dict_district GROUP BY dist_province ) b ON ps.sup_province = b.dist_province
	LEFT JOIN hr_area bb ON b.dist_region = bb.area_region
	JOIN project_supplier_cooperation psc ON ps.sup_id = psc.coop_supplier 
	AND ps.sup_available = 'true' and ps.sup_service_state = '启用'
	AND psc.coop_enabled = 'true' and psc.coop_state <> '离职'
	JOIN  (select * from prj_project_role ppr 
	left join  (select user,project,min(day) minday from prj_qiandao_supplier where user_type ='0' group by user,project) g on  ppr.role_user = g.user  and g.project=ppr.role_project and minday <= now()) ppr ON psc.coop_id = ppr.role_user 
	AND ppr.role_verified = 'valid' 
	 AND ppr.role_plan_end >= '2019-07-01'
	JOIN ( SELECT date, state, type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t  ) hw ON hw.date BETWEEN ifnull(ppr.role_actual_start,ifnull(ppr.minday,ppr.role_plan_start))  
	AND ppr.role_plan_end 
	and hw.date not between '2020-01-31'and '2020-02-23' 
	AND hw.date BETWEEN '2019-07-01' 
	AND SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 )
	JOIN project_opportunity1 po1 ON ppr.role_project = po1.key_id
	left join prj_supervise_manage psm on psm.sup_keyid  = po1.key_id 
	LEFT JOIN prj_qiandao_supplier pqs ON ppr.role_user = pqs.USER 
	AND pqs.DAY = hw.date 
	and pqs.day_type = hw.type
	AND pqs.DAY BETWEEN '2019-07-01' 
	AND SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 ) 
	AND pqs.STATUS <> 1 
	AND pqs.user_type = '0'
	LEFT JOIN (
SELECT USER
	,
	count( * ) 
FROM
	prj_qiandao_supplier pqs 
WHERE
	pqs.DAY BETWEEN '2019-07-01' 
	AND SUBDATE( CURRENT_DATE ( ), DATE_FORMAT( CURRENT_DATE ( ), '%w' ) + 2 ) 
	AND pqs.STATUS <> 1 
	AND pqs.user_type = '0' 
GROUP BY
USER 
	) pqs2 ON ppr.role_user = pqs2.USER
where
'${sheet}'="供应商"
and ifnull(psm.sup_type,'监管') <> '不监管' 
${IF(len( region ) = 0, "", " and replace(replace(area_area,'京津','北京'),'区','组') in ('" + region + "')" ) } 
${if(len(supplier)=0,"","and ps.sup_id in ('"+supplier+"')")}
${if(len(coop)=0,"","and psc.coop_id in('"+coop+"')")}

SELECT REPLACE(REPLACE ( area_area, '京津', '北京' ), '区', '组' ) AS 区域,
	count( DISTINCT po1.prj_number ) AS 项目总数,
	count( DISTINCT po1.prj_number, IF ( ( pqs.USER IS NULL ), TRUE, NULL ) ) AS 未满签项目数,
	count( ppr.role_user ) * 0.5 AS 应签人天数,
	sum( IF ( pqs.USER IS NULL, 0.5, 0 ) ) AS 未满签人天数,
	sum( IF ( ( pqs.day_type = 0 AND pqs.STATUS = 2 ), 0.5, 0 ) ) + sum( IF ( ( pqs.day_type = 1 AND pqs.STATUS = 2 ), 0.5, 0 ) ) AS 待审核人天数,
	count( DISTINCT ps.sup_id ) AS supcnt,
	count( DISTINCT ps.sup_id, IF ( ( pqs.USER IS NULL ), TRUE, NULL ) ) AS wmsupcnt,
	count( DISTINCT ppr.role_user ) AS coopcnt,
	count( DISTINCT ppr.role_user, IF ( ( pqs.USER IS NULL ), TRUE, NULL ) ) AS wmcoopcnt,
	area_area 
FROM
	project_supplier ps
	JOIN ( SELECT dist_province, dist_region FROM dict_district GROUP BY dist_province ) b ON ps.sup_province = b.dist_province
	LEFT JOIN hr_area bb ON b.dist_region = bb.area_region
	JOIN project_supplier_cooperation psc ON ps.sup_id = psc.coop_supplier 
	AND ps.sup_available = 'true' 
	AND ps.sup_service_state = '启用' 
	AND psc.coop_enabled = 'true' 
	AND psc.coop_state <> '离职'
	JOIN  (select * from prj_project_role ppr 
	left join  (select user,project,min(day) minday from prj_qiandao_supplier where user_type ='0' group by user,project) g on  ppr.role_user = g.user  and g.project=ppr.role_project and minday <= '${enddate}') ppr   ON psc.coop_id = ppr.role_user 
	AND ppr.role_type = 0 
	AND ppr.role_verified = 'valid' 
	AND  ppr.role_plan_end >= '${startdate}'
	JOIN ( SELECT date, state, type FROM hr_workdays CROSS JOIN ( SELECT 0 AS type UNION SELECT 1 ) AS t ) hw ON hw.date BETWEEN ifnull(ppr.role_actual_start,ifnull(ppr.minday,ppr.role_plan_start))
	AND ppr.role_plan_end 
	AND hw.state = 0 
	AND hw.date BETWEEN '${startdate}' 
	AND '${enddate}' 
	AND hw.date NOT BETWEEN '2020-01-31' 
	AND '2020-02-23'
	JOIN project_opportunity1 po1 ON ppr.role_project = po1.key_id
	left join prj_supervise_manage psm on psm.sup_keyid  = po1.key_id and psm.sup_type <> '不监管'
	LEFT JOIN prj_qiandao_supplier pqs ON ppr.role_user = pqs.USER 
	AND pqs.DAY = hw.date 
	AND pqs.day_type = hw.type 
	AND pqs.DAY BETWEEN '${startdate}' 
	AND '${enddate}' 
	AND pqs.STATUS <> 1 
	AND pqs.user_type = '0'
	left JOIN (
SELECT USER
	,
	count( * ) 
FROM
	prj_qiandao_supplier pqs 
WHERE
	pqs.DAY BETWEEN '${startdate}' 
	AND '${enddate}' 
	AND pqs.STATUS <> 1 
	AND pqs.user_type = '0' 
GROUP BY
USER 
	) pqs2 ON ppr.role_user = pqs2.USER 
WHERE
	'${sheet}' = "供应商"
and ifnull(psm.sup_type,'监管') <> '不监管' 
${IF(len(region) = 0, "", " and replace(replace(area_area,'京津','北京'),'区','组') in ('" + region + "')" ) } 
	${IF(len(supplier ) = 0, "", "and ps.sup_id in ('" + supplier + "')" ) } 
	${IF(len( coop ) = 0, "", "and psc.coop_id in('" + coop + "')" ) } 
GROUP BY
	bb.area_region


select hdt.team_id,hdt.team_name,hdt.team_region from hr_department_team hdt where team_name like '项目%组'
${if(len(region)=0,"","and hdt.team_region in('"+region+"')")}
group by hdt.team_paixu

select distinct team_region,team_id,team_name 
from prj_team_forsupplier where team_supplier ='72'
${if(len(region)=0,"","and team_region in('"+region+"')")}
${if(len(team)=0,"","and team_id in('"+team+"')")}
order by team_region,team_paixu 

select hdt.team_id,hdt.team_name,hdt.team_region from hr_department_team hdt where team_name like '项目%组' 
${if(len(region)=0,"","and team_region in('"+region+"')")}
${if(len(team)=0,"","and team_id in('"+team+"')")}
and team_verified = 'valid'

