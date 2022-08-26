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




select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND NOW()

select 
yearmonth,
AREANAME,
CITYNAME,
PROJECTNAME,
DAGER_NUM,
GENERAL_DANGER_NUM,
GENERAL_DANGER_DEALNUM,
GENERAL_DANGER_DEALRATE,
MAJOR_DANGER_NUM,
MAJOR_DANGER_DEALNUM,
MAJOR_DANGER_DEALRATE,
MAJOR_DANGER_TAKE_AMOUNT,
MAJOR_DANGER_TAKE_STOP,
MAJOR_DANGER_TAKE_CLOSE,
DANGER_LOCATION,
DANGER_FACTORY,
DANGER_DENSE_PLACES,
DANGER_ONWAY,
DANGER_OTHERS,
COMMENTS,
SAFE_MANAGER,
ENTERPERSON,ENTERTIME
from ipt_engin_danger_self
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
AREACODE,citystrucode,
PROJECTCODE,
CONCAT(PROJECTNAME,IFNULL(SECTIONNAME,"")) PROJECTNAME
FROM dim_engin_projectstage
where 1=1
and citystruname is not null
and projectcode in (select strucode from user_org)
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
${if(len(cityname)=0,"","and citystrucode in ('"+cityname+"')")}
union 
select AREAID AREACODE,CITYID citystrucode,projectid,projectname
from ipt_engin_danger_SELF
where 1=1 -- YEARMONTH = '${YEARMONTH}'
and cityid in (select strucode from user_org)
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}
ORDER BY AREACODE,citystrucode

