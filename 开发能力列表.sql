select  distinct jiraissue.ID,concat(project.pkey,"-",issuenum)jirakey,summary,issuenum,created,project.pname 项目,issuetype.pname 问题类型,issuestatus.pname 问题状态,k.lower_user_name 开发者,TIMESPENT/3600 耗时,h.STRINGVALUE 完成评价,list.*
from jira.jiraissue
join jira.issuelink on jiraissue.ID=DESTINATION and LINKTYPE=10100
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue j on j.ISSUE=jiraissue.ID and j.customfield=10430 #处理人
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and h.customfield=11309#完成评价
join jira.project on project.ID=jiraissue.PROJECT 
join jira.issuetype on issuetype.ID=jiraissue.issuetype 
join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus and issuestatus.pname<>"被否决"
left join jira.app_user k on ifnull(a.STRINGVALUE,j.STRINGVALUE)=k.user_key
left join jira.cwd_user d on d.lower_user_name=k.lower_user_name
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
join (select distinct jiraissue.ID p_id,concat(project.pkey,"-",issuenum)p_jirakey,summary p_summary,issuenum p_issuenum,created p_created,project.pname p_projectname,issuetype.pname p_issuetype,issuestatus.pname p_issuestatus,k.lower_user_name p_开发者,TIMESPENT/3600 P_耗时,h.STRINGVALUE p_难度系数,ifnull(i.STRINGVALUE,0) p_产品重点场景
from jira.jiraissue
join jira.issuelink on jiraissue.ID=SOURCE and LINKTYPE=10100
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue j on j.ISSUE=jiraissue.ID and j.customfield=10430 #处理人
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and h.customfield=10307 #难度系数
left join jira.customfieldvalue i on i.ISSUE=jiraissue.ID and i.customfield=10735 #产品重点场景
join jira.project on project.ID=jiraissue.PROJECT
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
left join jira.app_user k on ifnull(a.STRINGVALUE,j.STRINGVALUE)=k.user_key
left join jira.cwd_user d on d.lower_user_name=k.lower_user_name
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
where issuetype.pname in ('迭代任务','重构任务')
${if(len(type)=0,"","and h.STRINGVALUE in ('"+type+"')")}
)list on list.p_id=SOURCE  
where issuetype.pname not in ('快速任务') 
${if(len(startdate)=0,"","and RESOLUTIONDATE>='"+startdate+"'")}
${if(len(enddate)=0,"","and RESOLUTIONDATE<='"+enddate+"'")}
${if(len(username)=0,"","and (project.pkey='KERNEL' and (k.lower_user_name in ('"+lower(username)+"') or p_开发者 in ('"+lower(username)+"')) or (project.pkey<>'KERNEL' and k.lower_user_name in ('"+lower(username)+"')))")}
group by jiraissue.ID

select * from jira.customfieldoption where customfield=10307

select id,if(customvalue regexp '2018' or customvalue regexp '2019','是','否')tag from jira.customfieldoption where customfield=10735
union
select 0,"否"

select  jiraissue.ID,concat(project.pkey,"-",issuenum)jirakey,summary,issuenum,created,project.pname 项目,issuetype.pname 问题类型,issuestatus.pname 问题状态,a.STRINGVALUE 开发者,TIMESPENT/3600 耗时,list.*
from jira.jiraissue
join jira.issuelink on jiraissue.ID=DESTINATION and LINKTYPE=10100
join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
join jira.project on project.ID=jiraissue.PROJECT and project.pkey<>"FXD"
join jira.issuetype on issuetype.ID=jiraissue.issuetype 
join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus and issuestatus.pname<>"被否决"
join jira.cwd_user d on user_name=a.STRINGVALUE
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
join (select jiraissue.ID p_id,concat(project.pkey,"-",issuenum)p_jirakey,summary p_summary,issuenum p_issuenum,created p_created,project.pname p_projectname,issuetype.pname p_issuetype,issuestatus.pname p_issuestatus,a.STRINGVALUE p_开发者,TIMESPENT/3600 P_耗时
from jira.jiraissue
join jira.issuelink on jiraissue.ID=SOURCE and LINKTYPE=10100
join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
join jira.project on project.ID=jiraissue.PROJECT and project.pkey<>"FXD"
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
join jira.cwd_user d on user_name=a.STRINGVALUE
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
group by p_id
)list on list.p_id=SOURCE 
group by jiraissue.ID

select * from jira.customfieldoption where customfield=11309

select replace(user_username,' ','.')user_username,user_name,team_name,user_type,user_entrydate,TIMESTAMPDIFF(MONTH,user_firstConventionDate ,curdate()) silin,concat(replace(user_username,' ','.'),'-',user_name)name from hr_user 
left join hr_department_team on user_team=team_id
left join v_hr_contract on user_username = hr_ctr_user
where user_department=10 and user_state="在职" and user_type="正式"
${if(len(team)=0,"","and team_name in ('"+team+"')")}
order by team_name,silin desc

SELECT * FROM `hr_department_team` where team_department=10 and team_verified="valid" 

