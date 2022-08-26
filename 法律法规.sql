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
case when t.xkzgl='1' then '许可证管理' else '' end as "xkzglName" ,
case when t.wfwgjy='1' then '违法违规经营' else '' end as "wfwgjyName",
case when t.zjyjb='1' then '真假烟鉴别' else '' end as "zjyjbName",
case when t.qt='1' then '其他' else '' end as "qtName"

from formtable_main_588 t
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
${if(len(xkzgl)==0,"",if(xkzgl==true,"and t.xkzgl='1'",""))}
${if(len(wfwgjy)==0,"",if(wfwgjy==true,"and t.wfwgjy='1'",""))}
${if(len(zjyjb)==0,"",if(zjyjb==true,"and t.zjyjb='1'",""))}
${if(len(qt)==0,"",if(qt==true,"and t.qt='1'",""))}
and d.departmentname not in ('局（营销部）领导','基层服务站')
AND (d.departmentname LIKE '%服务站%' or d.departmentname like '%中队%')
AND (d.departmentname not LIKE '%直属中队%')
order by m.createdate desc

