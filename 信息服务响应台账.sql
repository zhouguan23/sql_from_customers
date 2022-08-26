select 
row_number() OVER(order by w.requestId asc) as "key",
w.requestId,
w.requestname,
w.xqr,
w.xqbm,
w.xqdw,
p.lastname,
d.departmentname,
c.subcompanyname,
w.fwlx,
fwlx.selectname as "fwlxName",
w.ejlx,
fwlx2.selectname as "fwlx2Name",
w.fwjb,
jb.selectname as "jbName",
w.xyr,
ms.name as "xyrName",
w.dd,
w.sfxy2,
xy.selectname as "xyName",
w.wtqr,
qr.selectname as "qrName",
w.cjTime,
w.xyTime,
cast(cast(w.xyDiffSs/(60*60*24) as INT) as VARCHAR)+'天'
+cast(cast(w.xyDiffSs%86400/3600 as INT) as VARCHAR)+'时'
+cast(cast(w.xyDiffSs%3600/60 as INT) as VARCHAR)+'分'
+cast(cast(w.xyDiffSs%60 as INT) as VARCHAR)+'秒' as "xy",
case when w.currentnodetype='3' then w.gdTime else '未归档' end as "gdTime",
case when w.currentnodetype='3' then 
cast(cast(w.gdDiffSs/(60*60*24) as INT) as VARCHAR)+'天'
+cast(cast(w.gdDiffSs%86400/3600 as INT) as VARCHAR)+'时'
+cast(cast(w.gdDiffSs%3600/60 as INT) as VARCHAR)+'分'
+cast(cast(w.gdDiffSs%60 as INT) as VARCHAR)+'秒' 
 else '未归档' end as "gd",
w.sfxy,
zt.selectname as "status",
w.ejxyr,
ms2.name as "ejxyrName"
from (
select 
t.requestId,
r.requestname,
t.xqr,
t.xqbm,
t.xqdw,
t.fwlx,
t.ejlx,
t.fwjb,
t.xyr,
t.dd,
t.sfxy2,
t.wtqr,
t.xxms,
t.sfxy,
t.ejxyr,
r.createdate+' '+r.createtime as "cjTime",
d.xyTimes as "xyTime",
DATEDIFF(SECOND, r.createdate+' '+r.createtime, d.xyTimes) as "xyDiffSs",
r.currentnodetype,
r.lastoperatedate+' '+r.lastoperatetime as "gdTime",
DATEDIFF(SECOND, r.createdate+' '+r.createtime, r.lastoperatedate+' '+r.lastoperatetime) as "gdDiffSs"
from formtable_main_716 t
left join (
select t.requestid,t.nodeid,MIN(t.operatedate+' '+t.operatetime) as "xyTimes" from workflow_requestLog t
where　 t.nodeid=5227　and t.logtype<>'t'
group by t.requestid,t.nodeid
) d on d.requestid=t.requestId
left join workflow_requestbase r on r.requestid=t.requestId)w
left join HrmResource p on p.id=w.xqr
left join HrmDepartment d on d.id=p.departmentid
left join HrmSubCompany c on c.id=p.subcompanyid1
left join mode_selectitempagedetail ms on ms.disorder=w.xyr and ms.mainid=83
left join workflow_SelectItem fwlx on fwlx.fieldid=24723 and fwlx.selectvalue=w.fwlx
left join workflow_SelectItem fwlx2 on fwlx2.fieldid=24732 and fwlx2.selectvalue=w.ejlx
left join workflow_SelectItem zt on zt.fieldid=24728 and zt.selectvalue=w.sfxy
left join workflow_SelectItem jb on jb.fieldid=24739 and jb.selectvalue=w.fwjb
left join workflow_SelectItem xy on xy.fieldid=24742 and xy.selectvalue=w.sfxy2
left join workflow_SelectItem qr on qr.fieldid=24741 and qr.selectvalue=w.wtqr
left join mode_selectitempagedetail ms2 on ms2.disorder=w.ejxyr and ms2.mainid=83
where 1=1
${if(len(company)==0,"","and c.id='"+company+"'")}
${if(len(depa)==0,"","and d.id='"+depa+"'")}
${if(len(xy)==0,"","and w.sfxy2='"+xy+"'")}
${if(len(status)==0,"",if(status=='0',"and w.wtqr='"+status+"'","and (w.wtqr='"+status+"' or w.wtqr is null)"))}
${if(len(key)==0,"","and (w.requestname like '%"+key+"%' or p.lastname like '%"+key+"%')")}

select t.id,t.subcompanyname from HrmSubCompany t
where t.id<>'7'

select id,departmentname from HrmDepartment
where (subcompanyid1='${company}' or supdepid='${company}')
and id <>'91'
order by subcompanyid1 asc;

