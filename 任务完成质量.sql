select distinct id,jirakey,summary,issuenum,created,项目,问题类型,问题状态,开发截止日期,开发者,开发完成日期,tag from (select  distinct jiraissue.ID,concat(project.pkey,"-",issuenum)jirakey,summary,issuenum,date(created)created,project.pname 项目,issuetype.pname 问题类型,issuestatus.pname 问题状态,if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE) 开发截止日期,j.lower_user_name 开发者,
date(if(project.pkey="FXD",i.DATEVALUE,ifnull(b.DATEVALUE,q.DATEVALUE))) 开发完成日期,
if(date(if(project.pkey="FXD",i.DATEVALUE,ifnull(b.DATEVALUE,q.DATEVALUE)))  is null and if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE)>=curdate(),1,if(if(project.pkey="FXD",i.DATEVALUE,ifnull(b.DATEVALUE,q.DATEVALUE))  is null and if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE)<curdate(),2,if(if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE)>=date(if(project.pkey="FXD",i.DATEVALUE,ifnull(b.DATEVALUE,q.DATEVALUE))) ,3,4)))tag
from jira.jiraissue
left join jira.customfieldvalue e on e.ISSUE=jiraissue.ID and e.customfield=10904 #开发截止日期
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and h.customfield=12638 #迭代截止日期
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue k on k.ISSUE=jiraissue.ID and k.customfield=10430 #处理人
left join jira.customfieldvalue b on b.ISSUE=jiraissue.ID and b.customfield=10303 #开发完成时间
left join jira.customfieldvalue i on i.ISSUE=jiraissue.ID and i.customfield=12631 #迭代完成时间
left join jira.customfieldvalue q on q.ISSUE=jiraissue.ID and q.customfield=10819 #统一完成时间
left join jira.project on project.ID=jiraissue.PROJECT
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
left join jira.app_user j on ifnull(if(issuestatus.pname="研发组员问题解决中",ASSIGNEE,a.STRINGVALUE),k.STRINGVALUE)=j.user_key
left join jira.cwd_user d on d.lower_user_name=j.lower_user_name
left join jira.cwd_membership f on d.id=child_id
left join jira.cwd_group g on parent_id=g.id
where issuestatus.pname not in ('被否决') and group_name regexp "研发" and year(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE))="${year}" and month(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE)) in ('${month}')
union
select  distinct jiraissue.ID,concat(project.pkey,"-",issuenum)jirakey,summary,issuenum,date(created)created,project.pname 项目,issuetype.pname 问题类型,issuestatus.pname 问题状态,
ifnull(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE),开发截止日期)开发截止日期,
j.lower_user_name 开发者,
if(project.pkey="FXD",i.DATEVALUE,ifnull(b.datevalue,q.DATEVALUE)) 开发完成日期,
if(if(project.pkey="FXD",i.DATEVALUE,b.DATEVALUE) is null and date(ifnull(if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE),开发截止日期))>=curdate(),1,if(if(project.pkey="FXD",i.DATEVALUE,b.DATEVALUE) is null and date(ifnull(if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE),开发截止日期))<curdate(),2,if(date(ifnull(if(project.pkey="FXD",date_add(h.DATEVALUE,interval 1 day),e.DATEVALUE),开发截止日期))>=date(if(project.pkey="FXD",i.DATEVALUE,b.DATEVALUE)),3,4)))tag
from jira.jiraissue
join jira.issuelink on jiraissue.ID=DESTINATION and LINKTYPE=10100
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue k on k.ISSUE=jiraissue.ID and k.customfield=10430 #处理人
left join jira.customfieldvalue b on b.ISSUE=jiraissue.ID and b.customfield=10303 #开发完成时间
left join jira.customfieldvalue i on i.ISSUE=jiraissue.ID and i.customfield=12631 #迭代完成时间
left join jira.customfieldvalue q on q.ISSUE=jiraissue.ID and q.customfield=10819 #统一完成时间
left join jira.customfieldvalue e on e.ISSUE=jiraissue.ID and e.customfield=10904 #开发截止日期
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and h.customfield=12638 #迭代截止日期
join jira.project on project.ID=jiraissue.PROJECT
join jira.issuetype on issuetype.ID=jiraissue.issuetype 
join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus and issuestatus.pname<>"被否决"
left join jira.app_user j on ifnull(if(issuestatus.pname="研发组员问题解决中",ASSIGNEE,a.STRINGVALUE),k.STRINGVALUE)=j.user_key
left join jira.cwd_user d on d.lower_user_name=j.lower_user_name
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
join (select distinct jiraissue.ID p_id,concat(project.pkey,"-",issuenum)p_jirakey,summary p_summary,issuenum p_issuenum,created p_created,project.pname p_projectname,issuetype.pname p_issuetype,issuestatus.pname p_issuestatus,j.lower_user_name p_开发者,if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE) 开发截止日期
from jira.jiraissue
join jira.issuelink on jiraissue.ID=SOURCE and LINKTYPE=10100
left join jira.customfieldvalue e on e.ISSUE=jiraissue.ID and e.customfield=10904 #开发截止日期
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and h.customfield=12638 #迭代截止日期
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue k on k.ISSUE=jiraissue.ID and k.customfield=10430 #处理人
join jira.project on project.ID=jiraissue.PROJECT
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
left join jira.app_user j on ifnull(if(issuestatus.pname="研发组员问题解决中",ASSIGNEE,a.STRINGVALUE),k.STRINGVALUE)=j.user_key
left join jira.cwd_user d on d.lower_user_name=j.lower_user_name
join jira.cwd_membership f on d.id=child_id
join jira.cwd_group g on parent_id=g.id and group_name regexp "研发"
where 1=1
and year(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE))="${year}" and month(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE)) in ('${month}')
)list on list.p_id=SOURCE  
where 1=1 and year(ifnull(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE),开发截止日期))="${year}" and month(ifnull(if(project.pkey="FXD",h.DATEVALUE,e.DATEVALUE),开发截止日期)) in ('${month}'))h
where h.id not in (SELECT  c.id from  
jira.changeitem a 
left join jira.changegroup b on a.groupid=b.ID 
left join jira.jiraissue c on b.issueid=c.ID
left join jira.issuetype  d on c.issuetype=d.ID 
left join jira.issuestatus  h on c.issuestatus=h.ID
left join 
(select * from jira.customfieldvalue where CUSTOMFIELD="10302")  e on c.ID=e.ISSUE
left join
(select * from jira.customfieldvalue where CUSTOMFIELD="10303") f on  c.ID=f.ISSUE
where  a.FIELDTYPE="jira"  and a.FIELD="status" and ( a.OLDVALUE="10303" and a.NEWVALUE="10563") 
and b.CREATED >='2019-01-01'
and c.CREATED >='2019-01-01' 
and d.pname="开发测试任务"
and LENGTH(e.DATEVALUE) >0 and  f.DATEVALUE is null 
and h.pname <>"研发组员问题解决中")
group by h.id

select user_username,user_name,team_name,user_type,user_entrydate,TIMESTAMPDIFF(MONTH,user_firstConventionDate ,curdate()) silin from hr_user 
left join hr_department_team on user_team=team_id
left join v_hr_contract on user_username = hr_ctr_user
where user_department=10 and user_state="在职" and user_type="正式"
${if(len(team)=0,"","and team_name in ('"+team+"')")}
${if(len(username)=0,"","and user_username in ('"+username+"')")}
order by team_name,silin desc

SELECT * FROM `hr_department_team` where team_department=10 and team_verified="valid" 

select  distinct jiraissue.ID,concat(project.pkey,"-",issuenum)jirakey,summary,issuenum,date(created)created,project.pname 项目,issuetype.pname 问题类型,issuestatus.pname 问题状态,j.lower_user_name 开发者
from jira.jiraissue
left join jira.customfieldvalue a on a.ISSUE=jiraissue.ID and a.customfield=10435 #开发者
left join jira.customfieldvalue k on k.ISSUE=jiraissue.ID and k.customfield=10430 #处理人
left join jira.customfieldvalue h on h.ISSUE=jiraissue.ID and a.customfield=10706
#问题解决方案
left join jira.project on project.ID=jiraissue.PROJECT
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
left join jira.app_user j on ifnull(a.STRINGVALUE,k.STRINGVALUE)=j.user_key
left join jira.cwd_user d on d.lower_user_name=j.lower_user_name
left join jira.cwd_membership f on d.id=child_id
left join jira.cwd_group g on parent_id=g.id
where issuestatus.pname not in ('重复BUG待解决','被否决') and group_name regexp "研发" and year(created)="${year}" and month(created)="${month}"
and issuetype.pname in ('一般BUG','开发测试任务','开发测试子任务')
/*or jira.jiraissue.id in (select DESTINATION from jira.jiraissue
join jira.issuelink on jiraissue.ID=SOURCE and LINKTYPE=10100
join jira.jiraissue b on b.id=DESTINATION and year(b.created)="${year}" and month(b.created)="${month}"
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus
where issuestatus.pname not in ('重复BUG待解决') and group_name regexp "研发" 
and issuetype.pname in ('一般BUG','开发测试任务'))*/
and jiraissue.id not in (select jiraissue.id from jira.jiraissue 
left join jira.issuetype on issuetype.ID=jiraissue.issuetype
left join jira.issuestatus on issuestatus.ID=jiraissue.issuestatus 
where issuestatus.pname in ('被否决','创建者确认') and h.STRINGVALUE in ("10642","10643","10648","11415","13433") or issuestatus.pname in ('创建者验收','创建者确认','被否决','已解决','验收通过待发布','产品场景确认') and h.STRINGVALUE in ("10649"))
group by jiraissue.ID

select user_username,user_name,team_name,user_type,user_entrydate,TIMESTAMPDIFF(MONTH,user_firstConventionDate ,curdate()) silin,concat(user_username,'-',user_name)name from hr_user 
left join hr_department_team on user_team=team_id
left join v_hr_contract on user_username = hr_ctr_user
where user_department=10 and user_state="在职" and user_type="正式" 
${if(len(team)=0,"","and team_name in ('"+team+"')")}
order by team_name,silin desc

