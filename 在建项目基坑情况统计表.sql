
WITH RECURSIVE user_org as
(
  select * from f_engin_structorg where strucode in (
		select strucode from f_engin_userpermission
			where username='${fine_username}' )
  UNION ALL
  select t.* from f_engin_structorg t inner join user_org tcte on t.parentstrucode = tcte.strucode
)
SELECT DISTINCT
areacode,areaname
FROM dim_engin_projectstage
where 1=1
and areaname is not null
and projectcode in (select strucode from user_org)




WITH RECURSIVE user_org as
(
  select * from f_engin_structorg where strucode in (
		select strucode from f_engin_userpermission
			where username='${fine_username}' )
  UNION ALL
  select t.* from f_engin_structorg t inner join user_org tcte on t.parentstrucode = tcte.strucode
)
SELECT DISTINCT
citystrucode,citystruname
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
and projectcode in (select strucode from user_org)


select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND NOW()

WITH RECURSIVE user_org as
(
  select * from f_engin_structorg where strucode in (
		select strucode from f_engin_userpermission
			where username='${fine_username}' )
  UNION ALL
  select t.* from f_engin_structorg t inner join user_org tcte on t.parentstrucode = tcte.strucode
)
SELECT DISTINCT
areacode,areaname,citystrucode,citystruname,PROJECTCODE,PROJECTNAME
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
and projectcode in (select strucode from user_org)
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and citystrucode in ('"+CITYNAME+"')")}
union 
select areaid areacode,areaname,cityid citystrucode,cityname citystruname,projectid PROJECTCODE,projectname
from ipt_engin_excavation
where  cityid in (select strucode from user_org)
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
order by  areacode,citystrucode


WITH RECURSIVE user_org as
(
  select * from f_engin_structorg where strucode in (
		select strucode from f_engin_userpermission
			where username='${fine_username}' )
  UNION ALL
  select t.* from f_engin_structorg t inner join user_org tcte on t.parentstrucode = tcte.strucode
)
SELECT 
*
FROM `ipt_engin_excavation`
where 1=1
and YEARMONTH = '${YEARMONTH}'
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
and cityid in (select strucode from user_org)
order by AREAID,AREANAME,CITYID,CITYNAME

