select *,if(customvalue in ("SL1","SL2"),1,0) as judge
from
(select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,C.stringvalue,D.customvalue,
E.datevalue as kehu_create,F.stringvalue as product_line,G.pname as bugstatus,count(*) as num,
reporter,if(G.pname="BUG已解决","已解决","未解决") as bug_status,H.lower_user_name,system_time,vv.customvalue as verified
from jiraissue A
/*SL等级*/
left join (select * from customfieldvalue where CUSTOMFIELD=14301) C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
/*客户提出时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=14302) E on E.issue=A.ID
/*产品线*/
left join (select * from customfieldvalue where CUSTOMFIELD=11814) F on F.issue=A.ID
/*bug状态*/
left join issuestatus G on A.issuestatus=G.ID
/*技术支持责任人*/
left join (select * from customfieldvalue where CUSTOMFIELD=10518) I on I.issue=A.ID
left join (select  * from  app_user where  user_key not REGEXP '#') H on I.stringvalue=H.user_key
/*系统恢复时间*/
left join 
(select H.issueid,H.created,max(H.created) as system_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="系统恢复" and newstring="已恢复" group by issueid)S on S.issueid=A.ID
 /*是否有效*/
left JOIN (select * from customfieldvalue where CUSTOMFIELD=12600)verified on verified.issue=A.ID
left join customfieldoption vv on vv.ID=verified.stringvalue
where A.PROJECT=10600 and C.stringvalue is not null and A.created>="2020-04-07" and F.stringvalue="FR"
and G.pname="BUG已解决"
and vv.customvalue="有效"
group by H.lower_user_name,if(D.customvalue in ("SL1","SL2"),1,0)
)AA

select lower(support_name) as supportor,support_group,support_name from support_user
where support_label not regexp "3"
and support_group=(select support_group from support_user where support_name='${group}')
order by support_group

select support_name,support_group from support_user
where support_duty=1 or support_duty=0

select *,count(*) num from
(select *,
if(TIMESTAMPDIFF(SECOND,kehu_create,if(system_time is null,endtime,system_time))/3600<24 and SL_level="SL1",1,0) as SL1_dabiao,
if(TIMESTAMPDIFF(SECOND,kehu_create,if(confirm_time is not null,confirm_time,endtime))/3600<7*24 and SL_level in ("SL1","SL2"),1,0) as SL2_dabiao
from
(select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,C.stringvalue,D.customvalue as SL_level,
E.datevalue as kehu_create,F.stringvalue as product_line,G.pname as bugstatus,
reporter,if(G.pname="BUG已解决","已解决","未解决") as bug_status,supportor.lower_user_name,system_time,
confirm_time,O.customvalue as point,
if(endtime_b.datevalue is not null,endtime_b.datevalue,endtime.datevalue) as endtime,vv.customvalue as verified
from jiraissue A
/*SL等级*/
left join (select * from customfieldvalue where CUSTOMFIELD=14301) C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
/*客户提出时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=14302) E on E.issue=A.ID
/*产品线*/
left join (select * from customfieldvalue where CUSTOMFIELD=11814) F on F.issue=A.ID
/*bug状态*/
left join issuestatus G on A.issuestatus=G.ID
left join (select  * from  app_user where  user_key not REGEXP '#') H on A.REPORTER=H.user_key
/*系统恢复时间*/
left join 
(
select H.issueid,H.created,max(H.created) as system_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="系统恢复" and newstring="已恢复" group by issueid
)S on S.issueid=A.ID
/*解决方案确诊时间*/
left join 
(
 select H.issueid,H.created,max(H.created) as confirm_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="当前问题关键点" and newstring="给出解决方案（确诊）" group by issueid
)fangan on fangan.issueid=A.ID
/*当前问题关键点*/
left join (select * from customfieldvalue where CUSTOMFIELD=14304) N on N.issue=A.ID
left join customfieldoption O on O.ID=N.stringvalue
/*解决时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=10819) endtime on endtime.issue=A.ID
/*技术支持完成时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=10746) endtime_b on endtime_b.issue=A.ID
/*技术支持责任人*/
left join (select * from customfieldvalue where CUSTOMFIELD=10518) support on support.issue=A.ID
left join (select  * from  app_user where  user_key not REGEXP '#') supportor on support.stringvalue=supportor.user_key
/*是否有效*/
left JOIN (select * from customfieldvalue where CUSTOMFIELD=12600)verified on verified.issue=A.ID
left join customfieldoption vv on vv.ID=verified.stringvalue
where A.PROJECT=10600 and C.stringvalue is not null  and F.stringvalue="FR" 
and G.pname="BUG已解决" and A.created>="2020-04-07"
)AA
where verified="有效"
)BB
where (SL_level="SL1" and SL1_dabiao=1 and SL2_dabiao=1) 
or (SL_level="SL2" and SL2_dabiao=1)
group by lower_user_name

select *,count(bug_id) as num,lower(support) as supportor from
(select * from
(select *,if(sum(s_time_hour) is null,0,sum(s_time_hour)) as hours from 
(select bug_id,jira_keys,support,support_bug_sl,support_bug_time,s_time_hour,s_time_date,endtime,support_bug_leader from fr_t_system1
left join support_custbug_time on support_bug_jira=jira_keys
left join support_daily_email_time on s_time_jirakey=jira_keys
where support_bug_sl="SL3" and support_bug_status="BUG已解决" and productline="FR"
and CREATEDATE>="2020-04-07" and support_bug_verified="有效"
and support_bug_leader is not null
)A
group by bug_id
order by endtime
)B
where hours<8 and support_bug_time<7
)C
group by support

select *,count(*) as num
from
(select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,C.stringvalue,D.customvalue,
E.datevalue as kehu_create,F.stringvalue as product_line,G.pname as bugstatus,
reporter,if(G.pname="BUG已解决","已解决","未解决") as bug_status,if(H.lower_user_name is null,assignee.lower_user_name,H.lower_user_name) as support,system_time,vv.customvalue as verified
from jiraissue A
/*SL等级*/
left join (select * from customfieldvalue where CUSTOMFIELD=14301) C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
/*客户提出时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=14302) E on E.issue=A.ID
/*产品线*/
left join (select * from customfieldvalue where CUSTOMFIELD=11814) F on F.issue=A.ID
/*bug状态*/
left join issuestatus G on A.issuestatus=G.ID
/*技术支持责任人*/
left join (select * from customfieldvalue where CUSTOMFIELD=10518) I on I.issue=A.ID
left join (select  * from  app_user where  user_key not REGEXP '#') H on I.stringvalue=H.user_key
/*系统恢复时间*/
left join 
(select H.issueid,H.created,max(H.created) as system_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="系统恢复" and newstring="已恢复" group by issueid)S on S.issueid=A.ID
 /*是否有效*/
left JOIN (select * from customfieldvalue where CUSTOMFIELD=12600)verified on verified.issue=A.ID
left join customfieldoption vv on vv.ID=verified.stringvalue
/*经办人*/
left join (select  * from  app_user where  user_key not REGEXP '#') assignee on A.ASSIGNEE=assignee.user_key
where A.PROJECT=10600 and C.stringvalue is not null and A.created>="2020-04-07" and F.stringvalue="FR" 
and G.pname<>"BUG已解决"
)AA
where customvalue in ("SL1","SL2") and verified="有效"
group by support

select *,count(*) as num,lower(提问人) as support from
(select c.*,d.OWNER_DISPLAY_NAME as 提问人 from (SELECT a.CREATION_DATE ,a.POST_ID,a.VOTE_TYPE_ID,b.DISPLAY_NAME as 点灭人 FROM AO_144497_VOTES a ,(select DISPLAY_NAME,ID from AO_144497_USERS) b where a.CREATION_DATE> ${DATETONUMBER(CONCATENATE(format(dateinmonth(today(),1),'yyyy-MM-dd'),' ','16:15:00'))} and  a.CREATION_DATE< ${DATETONUMBER(CONCATENATE(format(today(),'yyyy-MM-dd'),' ','16:15:00'))}
and a.USER_ID=b.ID
and a.VOTE_TYPE_ID =2 ) c ,AO_144497_POSTS d
where c.POST_ID=d.ID
and c.点灭人='Armstrong(帆迪塞尔)'
)AA
group by 提问人

select ID,lower_user_name,display_name from  cwd_user
where active=1 

select qid,lower(author) as member,count(*) as num from q_review where questionType='提了BUG' group by author

select * from
(SELECT distinct 问题ID,问题标题,问题标签,提问人,count(问题ID) as num,lower(提问人) as support
from 问题同步表 
where 提出时间 >'${if(month(today())<3,"2019-12-01",if(month(today())<6,"2020-02-29",if(month(today())<9,"2020-05-31","2020-08-31")))}'
and 提出时间 < '${if(month(today())<3,"2020-03-01",if(month(today())<6,"2020-06-01",if(month(today())<9,"2020-09-01","2020-12-01")))}'
group by 提问人
)A

select *,count(*) as num from
(select * from
(select A.ID,A.created,A.ASSIGNEE,concat("CUSTBUG-",A.issuenum)jirakey,J.ID as yanfa_id,
concat(K.pkey,"-",J.issuenum) as yanfa_key,J.CREATED as yanfa_created,
N.datevalue as endtime,
D.customvalue as SL_level,
F.stringvalue as product_line,G.pname as bugstatus,L.pname as yanfa_status,S.customvalue as label,
P.lower_user_name as support,K.pkey,Q.datevalue as yanfatime,
if((L.pname="被否决" and K.pkey in ("REPORT","DEC","MOBILE","CHART","BI") and S.customvalue in ("代码修改","产品改进","延迟处理","重复bug","未知改动")) or L.pname="已解决",1,0) as judge
from jiraissue A
left join issuestatus on issuestatus.id=A.issuestatus
/*SL级别*/
left join (select * from customfieldvalue where CUSTOMFIELD=14301) C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
/*产品线*/
left join (select * from customfieldvalue where CUSTOMFIELD=11814) F on F.issue=A.ID
left join issuestatus G on A.issuestatus=G.ID
/*连接类型是等待研发修复*/
left join issuelink I on I.DESTINATION=A.ID and I.LINKTYPE="10300"
left join jiraissue J on J.ID=I.SOURCE
left join project K on K.ID=J.PROJECT
left join issuestatus L on L.id=J.issuestatus
/*解决时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=10819) N on N.issue=A.ID
/*技术支持责任人*/
left join (select * from customfieldvalue where CUSTOMFIELD=10518) O on O.issue=A.ID
left join (select  * from  app_user where  user_key not REGEXP '#') P on O.stringvalue=P.user_key
/*是否转研发模块*/
left join (select * from customfieldvalue where CUSTOMFIELD=10747) Q on Q.issue=A.ID
/*问题解决方案*/
left join (select * from customfieldvalue where CUSTOMFIELD=10716) R on R.issue=J.ID
left join customfieldoption S on R.stringvalue=S.ID
where A.PROJECT=10600 and C.stringvalue is not null and J.ID is not null
and F.stringvalue="FR" and L.pname in ("被否决","已解决") and A.CREATED>="2020-04-07"
and Q.datevalue is not null
order by field(if((L.pname="被否决" and K.pkey in ("REPORT","DEC","MOBILE","CHART","BI") and S.customvalue in ("代码修改","产品改进","延迟处理","重复bug","未知改动")) or L.pname="已解决",1,0),1,0)
)A
group by jirakey
order by judge desc
)B
group by support,judge
order by judge desc

select *,count(*) as num from
(select * from
(select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader)) as leader,
if(support_bug_status="BUG已解决","已解决","未解决") as status,
if(support_bug_sl in ("SL1","SL2"),1,0) as sl_judge
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
where LENGTH(support_bug_sl)<>0 and createdate>="2020-04-07" and support_bug_verified="有效" and productline="FR"
union
select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
g2.support_name as leader,
if(support_bug_status="BUG已解决","已解决","未解决") as status,
if(support_bug_sl in ("SL1","SL2"),1,0) as sl_judge
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
left join support_user g1 on g1.support_name=a.support
left join support_user g2 on g1.support_group=g2.support_group and g2.support_duty=1
where LENGTH(support_bug_sl)<>0 and createdate>="2020-04-07" and support_bug_verified="有效"
and if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader))<>g2.support_name
and productline="FR"
)AA
order by support_bug_jira
)BB
group by leader,status,sl_judge

select *,count(*) as num from
(select *,
if(TIMESTAMPDIFF(SECOND,support_bug_kehu,if(support_bug_system is null,endtime,support_bug_system))/3600<24 and support_bug_sl="SL1",1,0) as SL1_dabiao,
if(TIMESTAMPDIFF(SECOND,support_bug_kehu,if(support_bug_confirm is not null,support_bug_confirm,endtime))/3600<7*24 and support_bug_sl in ("SL1","SL2"),1,0) as SL2_dabiao 
from
(select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader)) as leader,
if(support_bug_sl in ("SL1","SL2"),1,0) as sl_judge
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
where support_bug_sl in ("SL1","SL2") and createdate>="2020-04-07"
and support_bug_status="BUG已解决" and productline="FR"
union
select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
g2.support_name as leader,
if(support_bug_sl in ("SL1","SL2"),1,0)
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
left join support_user g1 on g1.support_name=a.support
left join support_user g2 on g1.support_group=g2.support_group and g2.support_duty=1
where support_bug_sl in ("SL1","SL2") and createdate>="2020-04-07"
and support_bug_status="BUG已解决"
and if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader))<>g2.support_name
and productline="FR"
)AA
where support_bug_verified="有效"
)BB
where (support_bug_sl="SL1" and SL1_dabiao=1 and SL2_dabiao=1) 
or (support_bug_sl="SL2" and SL2_dabiao=1)
group by leader

select *,lower(support_name) as supportor from support_user
left join (select support_name as leader,support_group as groups from support_user where support_duty=1)a on a.groups=support_group
order by support_group 

select *,count(*) as num from
(select *,
if(TIMESTAMPDIFF(SECOND,support_bug_kehu,if(support_bug_system is null,endtime,support_bug_system))/3600<24 and support_bug_sl="SL1",1,0) as SL1_dabiao,
if(TIMESTAMPDIFF(SECOND,support_bug_kehu,if(support_bug_confirm is not null,support_bug_confirm,endtime))/3600<7*24 and support_bug_sl in ("SL1","SL2"),1,0) as SL2_dabiao 
from
(select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader)) as leader,
if(support_bug_sl in ("SL1","SL2"),1,0) as sl_judge
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
where support_bug_sl in ("SL1","SL2") and createdate>="2020-04-07"
and support_bug_status="BUG已解决" and productline="FR"
union
select a.bug_id,a.company,b.com_salesman,a.ENDTIME,c.*,
g2.support_name as leader,
if(support_bug_sl in ("SL1","SL2"),1,0)
from fr_t_system1 a
left join support_custbug_time c on a.jira_keys=c.support_bug_jira
left join cust_company b on a.COMPANY=b.com_id
left join sale_support d on d.ss_salesman=b.com_salesman
LEFT JOIN (
  SELECT dist_province,ss_support_leader AS dist_support_leader,dist_region AS dist_region 
  FROM dict_district JOIN sale_support ON dist_salesman=ss_salesman GROUP BY dist_province
)e ON b.com_province=dist_province
left join special_company_support f on f.sc_company=a.company
left join support_user g1 on g1.support_name=a.support
left join support_user g2 on g1.support_group=g2.support_group and g2.support_duty=1
where support_bug_sl in ("SL1","SL2") and createdate>="2020-04-07"
and support_bug_status="BUG已解决"
and if(sc_support_leader is not null,sc_support_leader,if(ss_support_leader is null,dist_support_leader,ss_support_leader))<>g2.support_name
and productline="FR"
)AA
where support_bug_verified="有效"
)BB
where (support_bug_sl="SL1" and (SL1_dabiao<>1 or SL2_dabiao<>1)) 
or (support_bug_sl="SL2" and SL2_dabiao<>1)
group by leader

select *,count(*) as num,lower(supportor) as low_support from
(select bug_id,jira_keys,if(length(support)<>0,support,CHARGER) as supportor,b.*,
if(support_bug_status="BUG已解决","已解决","未解决") as status
from fr_t_system1 a
left join support_custbug_time b on jira_keys=support_bug_jira
where CREATEDATE>="2020-04-07" 
and length(support_bug_leader)<>0
and support_bug_verified="有效"
and support_bug_sl="SL3"
and productline="FR"
)A
group by supportor,status

select *,count(*) as num,lower(supportor) as low_support from
(select bug_id,jira_keys,if(length(support)<>0,support,CHARGER) as supportor,b.*,
if(support_bug_status="BUG已解决","已解决","未解决") as status
from fr_t_system1 a
left join support_custbug_time b on jira_keys=support_bug_jira
where CREATEDATE>="2020-04-07" 
and length(support_bug_leader)<>0
and support_bug_verified="有效"
and support_bug_sl="SL3"
and productline="FR"
)A
group by support_bug_leader,status

select *,count(bug_id) as num,lower(support) as supportor from
(select * from
(select *,if(sum(s_time_hour) is null,0,sum(s_time_hour)) as hours from 
(select bug_id,jira_keys,support,support_bug_sl,support_bug_time,s_time_hour,s_time_date,endtime,support_bug_leader from fr_t_system1
left join support_custbug_time on support_bug_jira=jira_keys
left join support_daily_email_time on s_time_jirakey=jira_keys
where support_bug_sl="SL3" and support_bug_status="BUG已解决" and productline="FR"
and CREATEDATE>="2020-04-07" and support_bug_verified="有效"
and support_bug_leader is not null
)A
group by bug_id
order by endtime
)B
where hours>=8 or support_bug_time>=7
)C
group by support

select *,count(*) num from
(select *,
if(TIMESTAMPDIFF(SECOND,kehu_create,if(system_time is null,endtime,system_time))/3600<24 and SL_level="SL1",1,0) as SL1_dabiao,
if(TIMESTAMPDIFF(SECOND,kehu_create,if(confirm_time is not null,confirm_time,endtime))/3600<7*24 and SL_level in ("SL1","SL2"),1,0) as SL2_dabiao
from
(select A.ID,A.created,concat("CUSTBUG-",A.issuenum)jirakey,C.stringvalue,D.customvalue as SL_level,
E.datevalue as kehu_create,F.stringvalue as product_line,G.pname as bugstatus,
reporter,if(G.pname="BUG已解决","已解决","未解决") as bug_status,supportor.lower_user_name,system_time,
confirm_time,O.customvalue as point,
if(endtime_b.datevalue is not null,endtime_b.datevalue,endtime.datevalue) as endtime,vv.customvalue as verified
from jiraissue A
/*SL等级*/
left join (select * from customfieldvalue where CUSTOMFIELD=14301) C on C.issue=A.ID
left join customfieldoption D on C.stringvalue=D.ID
/*客户提出时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=14302) E on E.issue=A.ID
/*产品线*/
left join (select * from customfieldvalue where CUSTOMFIELD=11814) F on F.issue=A.ID
/*bug状态*/
left join issuestatus G on A.issuestatus=G.ID
left join (select  * from  app_user where  user_key not REGEXP '#') H on A.REPORTER=H.user_key
/*系统恢复时间*/
left join 
(
select H.issueid,H.created,max(H.created) as system_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="系统恢复" and newstring="已恢复" group by issueid
)S on S.issueid=A.ID
/*解决方案确诊时间*/
left join 
(
 select H.issueid,H.created,max(H.created) as confirm_time from changegroup H
 join changeitem I on I.groupid=H.ID and FIELD="当前问题关键点" and newstring="给出解决方案（确诊）" group by issueid
)fangan on fangan.issueid=A.ID
/*当前问题关键点*/
left join (select * from customfieldvalue where CUSTOMFIELD=14304) N on N.issue=A.ID
left join customfieldoption O on O.ID=N.stringvalue
/*解决时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=10819) endtime on endtime.issue=A.ID
/*技术支持完成时间*/
left join (select * from customfieldvalue where CUSTOMFIELD=10746) endtime_b on endtime_b.issue=A.ID
/*技术支持责任人*/
left join (select * from customfieldvalue where CUSTOMFIELD=10518) support on support.issue=A.ID
left join (select  * from  app_user where  user_key not REGEXP '#') supportor on support.stringvalue=supportor.user_key
/*是否有效*/
left JOIN (select * from customfieldvalue where CUSTOMFIELD=12600)verified on verified.issue=A.ID
left join customfieldoption vv on vv.ID=verified.stringvalue
where A.PROJECT=10600 and C.stringvalue is not null  and F.stringvalue="FR" 
and G.pname="BUG已解决" and A.created>="2020-04-07"
)AA
where verified="有效"
)BB
where (SL_level="SL1" and (SL1_dabiao<>1 or SL2_dabiao<>1)) 
or (SL_level="SL2" and SL2_dabiao<>1)
group by lower_user_name

select *,count(bug_id) as num,lower(support) as supportor from
(select * from
(select *,if(sum(s_time_hour) is null,0,sum(s_time_hour)) as hours from 
(select bug_id,jira_keys,support,support_bug_sl,support_bug_time,s_time_hour,s_time_date,endtime,support_bug_leader from fr_t_system1
left join support_custbug_time on support_bug_jira=jira_keys
left join support_daily_email_time on s_time_jirakey=jira_keys
where support_bug_sl="SL3" and support_bug_status="BUG已解决" and productline="FR"
and CREATEDATE>="2020-04-07" and support_bug_verified="有效"
and support_bug_leader is not null
)A
group by bug_id
order by endtime
)B
where hours<8 and support_bug_time<7
)C
group by support_bug_leader

select *,count(bug_id) as num,lower(support) as supportor from
(select * from
(select *,if(sum(s_time_hour) is null,0,sum(s_time_hour)) as hours from 
(select bug_id,jira_keys,support,support_bug_sl,support_bug_time,s_time_hour,s_time_date,endtime,support_bug_leader from fr_t_system1
left join support_custbug_time on support_bug_jira=jira_keys
left join support_daily_email_time on s_time_jirakey=jira_keys
where support_bug_sl="SL3" and support_bug_status="BUG已解决" and productline="FR"
and CREATEDATE>="2020-04-07" and support_bug_verified="有效"
and support_bug_leader is not null
)A
group by bug_id
order by endtime
)B
where hours>=8 or support_bug_time>=7
)C
group by support_bug_leader

