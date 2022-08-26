select 
t.jsr,
p.lastname,
t.ssbm,
d.departmentname,
t.ssdw,
c.subcompanyname,
case when t.sy='1' then '选中' else '未选' end as "syStatus",
case when t.sf='1' then '选中' else '未选' end as "sfStatus",
case when t.yj='1' then '选中' else '未选' end as "yjStatus",
case when t.tj='1' then '选中' else '未选' end as "tjStatus",
case when t.ymq='1' then '选中' else '未选' end as "ymqStatus",
case when t.ppq='1' then '选中' else '未选' end as "ppqStatus",
case when t.lq='1' then '选中' else '未选' end as "lqStatus",
case when t.yy='1' then '选中' else '未选' end as "yyStatus",
case when t.cy='1' then '选中' else '未选' end as "cyStatus",
case when t.ys='1' then '选中' else '未选' end as "ysStatus",
case when t.ms='1' then '选中' else '未选' end as "msStatus",
case when t.gc='1' then '选中' else '未选' end as "gcStatus",
case when t.yq='1' then '选中' else '未选' end as "yqStatus",
case when t.wyxs='1' then '选中' else '未选' end as "wyxsStatus",
case when t.qt='1' then '选中' else '未选' end as "qtStatus",
t.bz
from formtable_main_718 t
left join HrmResource p on p.id=t.jsr
left join HrmDepartment d on d.id=p.departmentid
left join HrmSubCompany c on c.id=p.subcompanyid1
where 1=1
${if(len(company)==0,"","and c.id='"+company+"'")}
${if(len(depa)==0,"","and d.id='"+depa+"'")}
${if(len(key)==0,"","and p.lastname like '%"+key+"%'")}

select t.id,t.subcompanyname from HrmSubCompany t
where t.id='5'

select id,departmentname from HrmDepartment
where subcompanyid1='${company}' 
and id <>'91'
and supdepid=27
order by subcompanyid1 asc;

