select 
row_number() OVER(order by d.id asc) as "key",
case when  t.shzt='0' then '通过' else '驳回' end as "status",
m.id,m.xtmc,m.url,p.lastname,de.departmentname,c.subcompanyname,d.ip,d.phone,w.createdate from formtable_main_713 t 
left join formtable_main_713_dt1 d on d.mainid=t.id
left join uf_ywxtbmd m on m.id=d.xtmc
left join HrmResource p on p.id=d.syr
left join HrmSubCompany c on c.id=p.subcompanyid1
left join HrmDepartment de on de.id=p.departmentid
left join workflow_requestbase w on w.requestid=t.requestId
where
1=1
${if(len(begin)==0,"","and w.createdate>='"+begin+"'")}
${if(len(end)==0,"","and w.createdate<='"+end+"'")}
${if(len(status)==0,"","and t.shzt='"+status+"'")}
${if(len(key)==0,"","and (m.xtmc like '%"+key+"%') or (m.url like '%"+key+"%') or (p.lastname like '%"+key+"%') or (c.subcompanyname like '%"+key+"%') or (de.departmentname like '%"+key+"%') ")}
and w.currentnodetype=3
order by w.createdate desc




