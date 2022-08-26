select 
d.id,
d.departmentname,
case when w.syCount is null then 0 else w.syCount end as "syCount",
case when w.sfCount is null then 0 else w.sfCount end as "sfCount",
case when w.yjCount is null then 0 else w.yjCount end as "yjCount",
case when w.tjCount is null then 0 else w.tjCount end as "tjCount",
case when w.ymqCount is null then 0 else w.ymqCount end as "ymqCount",
case when w.ppqCount is null then 0 else w.ppqCount end as "ppqCount",
case when w.lqCount is null then 0 else w.lqCount end as "lqCount",
case when w.yyCount is null then 0 else w.yyCount end as "yyCount",
case when w.cyCount is null then 0 else w.cyCount end as "cyCount",
case when w.ysCount is null then 0 else w.ysCount end as "ysCount",
case when w.msCount is null then 0 else w.msCount end as "msCount",
case when w.gcCount is null then 0 else w.gcCount end as "gcCount",
case when w.yqCount is null then 0 else w.yqCount end as "yqCount",
case when w.wyxsCount is null then 0 else w.wyxsCount end as "wyxsCount",
case when w.qtCount is null then 0 else w.qtCount end as "qtCount"
from HrmDepartment d
left join (
select 
p.departmentid as "ssbm",
sum(case when t.sy='1' then 1 else 0 end) as "syCount",
sum(case when t.sf='1' then 1 else 0 end) as "sfCount",
sum(case when t.yj='1' then 1 else 0 end) as "yjCount",
sum(case when t.tj='1' then 1 else 0 end) as "tjCount",
sum(case when t.ymq='1' then 1 else 0 end) as "ymqCount",
sum(case when t.ppq='1' then 1 else 0 end) as "ppqCount",
sum(case when t.lq='1' then 1 else 0 end) as "lqCount",
sum(case when t.yy='1' then 1 else 0 end) as "yyCount",
sum(case when t.cy='1' then 1 else 0 end) as "cyCount",
sum(case when t.ys='1' then 1 else 0 end) as "ysCount",
sum(case when t.ms='1' then 1 else 0 end) as "msCount",
sum(case when t.gc='1' then 1 else 0 end) as "gcCount",
sum(case when t.yq='1' then 1 else 0 end) as "yqCount",
sum(case when t.wyxs='1' then 1 else 0 end) as "wyxsCount",
sum(case when t.qt='1' then 1 else 0 end) as "qtCount"
from formtable_main_718 t
left join HrmResource p on p.id=t.jsr
group by p.departmentid
)w on w.ssbm=d.id
where d.subcompanyid1=5
and d.supdepid=27
and d.id not in (91)
order by d.id asc

select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'

select id,departmentname from HrmDepartment
where (subcompanyid1='${company}' or supdepid='${company}')
and id <>'91'
order by subcompanyid1 asc;

