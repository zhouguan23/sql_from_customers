select a.project,a.id,a.version,a.startdate,a.releasedate,a.codedate,a.real_reldate,b.docurl,a.docdate,b.point_name,b.point_jiraid,point_jira_keys,point_bugids,point_id,task_status from ver_devplan a
left join  demand_function_point b
on b.point_mudole = a.project and b.project_version=a.version and (b.valid is null or b.valid='valid')
where 1=1
${if(len(project)==0,""," and a.project in ('"+project+"')")}
order by a.project,a.startdate desc



select vname from jira.projectversion 
/*where project in 
(
     select id from jira.project
	where originalkey=${if(project='图表','CHART',if(project='平台','DEC',if(project='BI','BI',if(project='移动端','MOBILE',if(project='报表','REPORT','')))))}

)
*/

