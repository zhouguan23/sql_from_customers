select * from (
select 
c.id,
c.subcompanyname,
case when zxlh.counts is null then '0' else zxlh.counts end as "zxlhCount",
case when zxlh.ygd is null then '0' else zxlh.ygd end as "zxlhCountygd",
case when zxlh.wgd is null then '0' else zxlh.wgd end as "zxlhCountwgd",
case when scjh.counts is null then '0' else scjh.counts end as "scjhCount",
case when scjh.ygd is null then '0' else scjh.ygd end as "scjhhCountygd",
case when scjh.wgd is null then '0' else scjh.wgd end as "scjhhCountwgd",
case when tsjb.counts is null then '0' else tsjb.counts end as "tsjbCount",
case when tsjb.ygd is null then '0' else tsjb.ygd end as "tsjbhCountygd",
case when tsjb.wgd is null then '0' else tsjb.wgd end as "tsjbhCountwgd",
case when gzxx.counts is null then '0' else gzxx.counts end as "gzxxCount",
case when gzxx.ygd is null then '0' else gzxx.ygd end as "gzxxhCountygd",
case when gzxx.wgd is null then '0' else gzxx.wgd end as "gzxxhCountwgd",
case when ajxs.counts is null then '0' else ajxs.counts end as "ajxsCount",
case when ajxs.ygd is null then '0' else ajxs.ygd end as "ajxshCountygd",
case when ajxs.wgd is null then '0' else ajxs.wgd end as "ajxshCountwgd",
case when gfjy.counts is null then '0' else gfjy.counts end as "gfjyCount",
case when gfjy.ygd is null then '0' else gfjy.ygd end as "gfjyCountygd",
case when gfjy.wgd is null then '0' else gfjy.wgd end as "gfjyCountwgd",
case when xkgl.counts is null then '0' else xkgl.counts end as "xkglCount",
case when xkgl.ygd is null then '0' else xkgl.ygd end as "xkglCountygd",
case when xkgl.wgd is null then '0' else xkgl.wgd end as "xkglCountwgd",
case when flfg.counts is null then '0' else flfg.counts end as "flfgCount",
case when flfg.ygd is null then '0' else flfg.ygd end as "flfgCountygd",
case when flfg.wgd is null then '0' else flfg.wgd end as "flfgCountwgd",
case when jyzd.counts is null then '0' else jyzd.counts end as "jyzdCount",
case when jyzd.ygd is null then '0' else jyzd.ygd end as "jyzdCountygd",
case when jyzd.wgd is null then '0' else jyzd.wgd end as "jyzdCountwgd",
case when hzxz.counts is null then '0' else hzxz.counts end as "hzxzCount",
case when hzxz.ygd is null then '0' else hzxz.ygd end as "hzxzCountygd",
case when hzxz.wgd is null then '0' else hzxz.wgd end as "hzxzCountwgd",
case when khbf.counts is null then '0' else khbf.counts end as "khbfCount",
case when khbf.ygd is null then '0' else khbf.ygd end as "khbfCountygd",
case when khbf.wgd is null then '0' else khbf.wgd end as "khbfCountwgd",
case when khpj.counts is null then '0' else khpj.counts end as "khpjCount",
case when khpj.ygd is null then '0' else khpj.ygd end as "khpjCountygd",
case when khpj.wgd is null then '0' else khpj.wgd end as "khpjCountwgd",
case when shkc.counts is null then '0' else shkc.counts end as "shkcCount",
case when shkc.ygd is null then '0' else shkc.ygd end as "shkcCountygd",
case when shkc.wgd is null then '0' else shkc.wgd end as "shkcCountwgd",
case when mmsj.counts is null then '0' else mmsj.counts end as "mmsjCount",
case when mmsj.ygd is null then '0' else mmsj.ygd end as "mmsjCountygd",
case when mmsj.wgd is null then '0' else mmsj.wgd end as "mmsjCountwgd",
case when xyhj.counts is null then '0' else xyhj.counts end as "xyhjCount",
case when xyhj.ygd is null then '0' else xyhj.ygd end as "xyhjCountygd",
case when xyhj.wgd is null then '0' else xyhj.wgd end as "xyhjCountwgd"
from HrmSubCompany c
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_575 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)zxlh on zxlh.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_579 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)scjh on scjh.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_582 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)tsjb on tsjb.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_583 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)gzxx on gzxx.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_585 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)ajxs on ajxs.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_586 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)gfjy on gfjy.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_587 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)xkgl on xkgl.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_588 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)flfg on flfg.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_589 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)jyzd on jyzd.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_590 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)hzxz on hzxz.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_591 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)khbf on khbf.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_592 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)khpj on khpj.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_593 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)shkc on shkc.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_595 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)mmsj on mmsj.ssgs=c.id
left join (
select 
f.ssgs,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.ssgs,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_594 t
left join workflow_requestbase m on m.requestid=t.requestId
left join HrmDepartment de on de.id=t.ssbm
where 1=1
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.ssgs
)xyhj on xyhj.ssgs=c.id
where c.id<>'7')w
where 1=1
${if(len(company)==0,"","and w.id='"+company+"'")}

select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'

