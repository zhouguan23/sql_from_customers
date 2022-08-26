select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'

select id,departmentname from HrmDepartment
where (subcompanyid1='${company}' or supdepid='${company}')
and id <>'91'
and departmentname like '%服务站%'
and departmentname<>'基层服务站'
order by subcompanyid1 asc;

select id,departmentname from HrmDepartment
where supdepid='${depa}'
and departmentname like '%中队%'
and departmentname not like '%直属%'
${if(inzd=='all',"and 1=1","and id='"+inzd+"'")}

select 
t.*,
m.requestname,
p.lastname,
d.departmentname,
c.subcompanyname,
case when m.currentnodetype in ('3') then '已归档' else '未归档' end as "gd",
m.createdate,
p1.lastname as "zxrName",
case when t.jgdy='1' then '价签对应' else '' end as "jgdyName" ,
case when t.jqqs='1' then '价签缺失' else '' end as "jqqsName",
case when t.jjxs='1' then '降价销售信息' else '' end as "jjxsName",
case when t.qt='1' then '其他' else '' end as "qtName"

from formtable_main_595 t
left join workflow_requestbase m on m.requestid=t.requestId  
left join HrmResource p on p.id=t.fqr
left join HrmDepartment d on d.id=t.ssbm
left join HrmSubCompany c on c.id=d.subcompanyid1
left join HrmResource p1 on p1.id=t.zxr
where 
1=1
${if(len(person)==0,"","and p.id='"+person+"'")}
${if(len(company)==0,"","and t.ssgs='"+company+"'")}
${if(len(depa)==0,"",if(len(zd)==0,"and (t.ssbm='"+depa+"')","and t.ssbm='"+zd+"'"))}
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
${if(len(status)==0,"",if(status=='0',"and m.currentnodetype in ('0','1','2')","and m.currentnodetype in ('3')"))}
${if(len(jgdy)==0,"",if(jgdy==true,"and t.jgdy='1'",""))}
${if(len(jqqs)==0,"",if(jqqs==true,"and t.jqqs='1'",""))}
${if(len(jjxs)==0,"",if(jjxs==true,"and t.jjxs='1'",""))}
${if(len(qt)==0,"",if(qt==true,"and t.qt='1'",""))}
and d.departmentname not in ('局（营销部）领导','基层服务站')
AND (d.departmentname LIKE '%服务站%' or d.departmentname like '%中队%')
AND (d.departmentname not LIKE '%直属中队%')
order by m.createdate desc

