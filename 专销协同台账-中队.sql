select 
c.id,
c.lastname,
de.departmentname,
com.subcompanyname,
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
from HrmResource c
left join HrmSubCompany com on com.id=c.subcompanyid1
left join HrmDepartment de on de.id=c.departmentid
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_575 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)zxlh on zxlh.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_579 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)scjh on scjh.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_582 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)tsjb on tsjb.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_583 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)gzxx on gzxx.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_585 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)ajxs on ajxs.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_586 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)gfjy on gfjy.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_587 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)xkgl on xkgl.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_588 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)flfg on flfg.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_589 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)jyzd on jyzd.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_590 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)hzxz on hzxz.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_591 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)khbf on khbf.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_592 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)khpj on khpj.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_593 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)shkc on shkc.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_595 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)mmsj on mmsj.fqr=c.id
left join (
select 
f.fqr,
sum(f.ygd) as "ygd",
sum(f.wgd) as "wgd",
count(1) as "counts"
from (
select 
t.requestId,
t.fqr,
case when m.currentnodetype in ('0','1','2') then 1 else 0 end as "wgd",
case when m.currentnodetype in ('3') then 1 else 0 end as "ygd"
from formtable_main_594 t
left join workflow_requestbase m on m.requestid=t.requestId
where 1=1
${if(len(begin)==0,"","and m.createdate>='"+begin+"'")}
${if(len(end)==0,"","and m.createdate<='"+end+"'")}
)f
group by f.fqr
)xyhj on xyhj.fqr=c.id
where
1=1
${if(len(person)==0,"","and p.id='"+person+"'")}
${if(len(company)==0,"",if(company=="9999","","and com.id='"+company+"'"))}
${if(len(depa)==0,"",if(depa=="9999","","and (de.id='"+depa+"' or de.supdepid='"+depa+"')"))}
${if(len(zd)==0,"",if(zd=="9999","","and de.id='"+zd+"'"))}
and de.departmentname not in ('局（营销部）领导','基层服务站')
AND (de.departmentname LIKE '%服务站%' or de.departmentname like '%中队%')
AND (de.departmentname not LIKE '%直属中队%')

select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'
${if(incompany=='all',"and 1=1","and t.id='"+incompany+"'")}
${if(incompany=='all',"
union all
select '9999' as 'id','全部' as 'subcompanyname'
","")}



select id,departmentname from HrmDepartment
where (subcompanyid1='${company}' or supdepid='${company}')
and id <>'91'
and departmentname like '%服务站%'
and departmentname<>'基层服务站'
${if(indepa=='all' && type==0,"and 1=1","and id='"+indepa+"'")}
${if(indepa=='all' && type==0,"
union all
select '9999' as 'id','全部' as 'departmentname'
","")}

select id,departmentname from HrmDepartment
where supdepid='${depa}'
and departmentname like '%中队%'
and departmentname not like '%直属%'
${if(inzd=='all',"and 1=1","and id='"+inzd+"'")}
${if(inzd=='all' && type==0,"
union all
select '9999' as 'id','全部' as 'departmentname'
","")}


