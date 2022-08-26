select b.areaid,b.areaname,u.username,u.userid,u.employeename from businessarea b,usr u where b.depthead=u.userid

select u.userid,u.username,u.employeename,u.username||'_'||u.employeename codename,u.attri02,u.attri03,u.jobtitlecode,d.valuename from usr u left join dictionary d on u.jobtitlecode=d.value where d.type ='JobTitle' and d.languagecode='cn'
and u.jobtitlecode in ('20','22')

select usercode,username,jobstatus,begindate,enddate,altertype,job_type,dept,post from bd_psnpost where altertype in ('员工初始化','雇佣入职')

select usercode,username,jobstatus,begindate,enddate,altertype,job_type,dept,post from bd_psnpost where altertype in ('辞退','辞职','退休')

select * from v_target_data_yd where year=substr('${month1}',1,4)

--为任职记录追加上下游变动类型，剔除转正记录，剔除2019年以前结束的记录
with t1 as --找到最早入职记录
(select usercode,username,min(begindate) begindate,'入职' ru from bd_psnpost group by usercode,username)
,t2 as --找到离职人员的非离职记录
(select * from bd_psnpost where usercode in(select usercode from bd_psnpost where altertype in ('辞职','辞退','退休')) and altertype  not in ('辞职','辞退','退休'))
,t3 as --找到离职人员的最大非离职记录
(select usercode,username,max(begindate) begindate,'离职' li from t2 group by usercode,username)
,t4 as --为所有记录添加入职、离职字段，无入职、离职字段的为转岗
(select p.*,nvl(t1.ru,'转岗') ru,nvl(t3.li,'转岗') li from bd_psnpost p 
left join t1 on p.usercode=t1.usercode and p.begindate=t1.begindate
left join t3 on p.usercode=t3.usercode and p.begindate=t3.begindate)
,p1 as --过滤所有记录的"转正"记录
(select usercode,username,min(begindate) begindate,max(enddate) enddate,dept,post
from t4 where jobstatus in ('正式员工','试用员工') group by usercode,username,dept,post)
,p2 as --过滤2019年前的结束日期和岗位
(select p1.usercode,p1.username,p1.begindate,p1.enddate,p1.post,p1.dept,substr(p1.dept,instr(p1.dept,'_',-1)+1) diqu,t4.ru,t4.altertype,t4.li from p1 left join t4 on p1.usercode=t4.usercode and p1.dept=t4.dept and p1.post=t4.post and p1.begindate=t4.begindate
where p1.enddate>'2019-12-31' and p1.post in ('基层产品信息联络专员','零售产品信息联络专员','医学产品信息联络专员','小连锁产品信息联络员','医学产品信息联络员','终端产品信息联络员') and substr(p1.enddate,1,7)>='${month1}')
,p3 as
(select distinct userid,usercode,catn,prodid from
(select distinct u.userid,u.usercode,p.catn,t.prodid from target_data t,cmi_user u,cmi_prod p where t.userid=u.userid and t.prodid=p.prodid and t.year=substr('${month1}',1,4) union all
select distinct u.userid,u.usercode,p.catn,p.prodid from historyofmonthsales@cmilink h,cmi_user u,cmi_prod p where h.buyerrepid is not null and h.buyerrepid=u.userid and h.prodid=p.prodid and to_char(h.salesdate,'yyyy')=substr('${month1}',1,4)
))
--人员关联产品
select p2.diqu,p3.userid,p2.usercode,p2.username,p2.begindate,p2.enddate,p2.ru,p2.altertype,p2.li,p2.post,p3.catn,p3.prodid from p2 left join p3 on p2.usercode=p3.usercode
where 1=1 ${if(len(usercode)=0,"","and p2.usercode in ('"+usercode+"')")}
${if(len(daqu)=0,"","and p3.daqu in ('"+daqu+"')")}
${if(len(areaname)=0,"","and p3.areaname in ('"+areaname+"')")}
${if(len(prdn)=0,"","and p3.prodid in ('"+prdn+"')")}
${if(len(catn)=0,"","and p3.catn in ('"+catn+"')")}
order by p2.usercode,p2.dept,p2.post

select * from cmi_area 
where 1=1 ${if(len(daqu)=0,"","and daquname in ('"+daqu+"')")}

select * from cmi_prod
where 1=1 ${if(len(catn)=0,"","and catn in ('"+catn+"')")}

select * from v_fr_sales_yd where year=substr('${month1}',1,4)

select * from v_fr_sales_yd where year=substr('${month1}',1,4)-1

