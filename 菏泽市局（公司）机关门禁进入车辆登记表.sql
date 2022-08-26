select 
ROW_NUMBER() OVER (ORDER BY w.requestId) AS "key",
w.* from (
select 
t.requestId,
p.lastname,
d.departmentname,
c.subcompanyname,
'个人' as "type",
s.name as "sqlx",
t.ycph as "cph",
case when t.sqlx='0' then '' else t.xcph end as "xcph",
s2.name as "clsx",
case when t.clsx='0' then '长期' else t.jzsj end as "jzsj",
p.mobile,
'1677' as "wfId"
from formtable_main_720 t
left join HrmResource p on p.id=t.sqr
left join HrmDepartment d on d.id=t.ssbm
left join HrmSubCompany c on c.id=t.ssdw
left join mode_selectitempagedetail s on s.mainid=85 and s.disorder=t.sqlx
left join mode_selectitempagedetail s2 on s2.mainid=86 and s2.disorder=t.clsx
where 1=1
${if(len(company)==0,"","and t.ssdw='"+company+"'")}
${if(len(depa)==0,"","and t.ssbm='"+depa+"'")}
${if(len(type)==0,"","and t.sqlx-"+type+"=0")}
${if(len(times)==0,"","and t.clsx-"+times+"=0")}
${if(len(key)==0,"","and (t.ycph like '%"+key+"%' or t.xcph like '%"+key+"%' or p.lastname like '%"+key+"%' or p.mobile like '%"+key+"%') ")}
union all 
select 
m.requestId,
p.lastname,
d.departmentname,
c.subcompanyname,
'公务' as "type",
s.name as "sqlx",
t.ycph as "cph",
case when t.sqlx='0' then '' else t.xcph end as "xcph",
'长期' as "clsx",
'长期' as "jzsj",
t.phone as "mobile",
'1676' as "wfId"
from formtable_main_719_dt1 t
left join HrmResource p on p.id=t.jsy
left join HrmDepartment d on d.id=p.departmentid
left join HrmSubCompany c on c.id=t.clssdw
left join mode_selectitempagedetail s on s.mainid=85 and s.disorder=t.sqlx
left join formtable_main_719 m on m.id=t.mainid
where 1=1
${if(len(company)==0,"","and t.clssdw='"+company+"'")}
${if(len(depa)==0,"","and p.departmentid='"+depa+"'")}
${if(len(type)==0,"","and t.sqlx-"+type+"=0")}
${if(len(times)==0,"",if(times=='0',"and 1=1","and 8<7"))}
${if(len(key)==0,"","and (t.ycph like '%"+key+"%' or t.xcph like '%"+key+"%' or p.lastname like '%"+key+"%' or t.phone like '%"+key+"%') ")})w

select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'

select id,departmentname from HrmDepartment
where subcompanyid1='${company}' 
and id <>'91'
order by subcompanyid1 asc;

select disorder,name from mode_selectitempagedetail
where mainid=85

select disorder,name from mode_selectitempagedetail
where mainid=86

