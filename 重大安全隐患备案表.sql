select 
AREAname,
CITYNAME,
PROJECTID,
PROJECTname,
DANGER_SITE,
DISCOVER_TIME,
DANGER_COMMENT,
DEAL_MEASURE,
LIMIT_TIME,
DEAL_PERSON,
DEAL_CONDITION,
CHECK_PERSON,
CHECK_CONDITION,
COMMENTS,
SAFE_MANAGER,
ENTERPERSON,
ENTERTIME
from ipt_engin_dangers
WHERE YEARMONTH = '${YEARMONTH}'
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

WITH RECURSIVE user_org as
(
  select * from f_engin_structorg where strucode in (
		select strucode from f_engin_userpermission
			where username='${fine_username}' )
  UNION ALL
  select t.* from f_engin_structorg t inner join user_org tcte on t.parentstrucode = tcte.strucode
)

SELECT DISTINCT
PROJECTCODE,
CONCAT(PROJECTNAME,IFNULL(SECTIONNAME,"")) PROJECTNAME
FROM dim_engin_projectstage
where 1=1
and citystruname is not null
and projectcode in (select strucode from user_org)
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
${if(len(cityname)=0,"","and citystrucode in ('"+cityname+"')")}
union 
select projectid,projectname
from ipt_engin_dangers
where 1=1
and cityid in (select strucode from user_org)
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

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
and projectcode in (select strucode from user_org)
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
order by citystrucode


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
and areacode is not null
 and projectcode in (select strucode from user_org)
order by areacode



select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND NOW()

