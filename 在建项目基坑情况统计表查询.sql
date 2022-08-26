
SELECT DISTINCT
areacode,areaname
FROM dim_engin_projectstage
where 1=1
and areaname is not null






SELECT DISTINCT
citystrucode,citystruname
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}


select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND NOW()

/*
SELECT DISTINCT
areacode,areaname,citystrucode,citystruname,PROJECTCODE,PROJECTNAME
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
and projectcode in (select strucode from user_org)
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and citystrucode in ('"+CITYNAME+"')")}
union 
*/
select areaid areacode,areaname,cityid citystrucode,cityname citystruname,projectid PROJECTCODE,projectname
from ipt_engin_excavation
where 1=1
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
order by  areacode,citystrucode


SELECT 
*
FROM `ipt_engin_excavation`
where 1=1
and YEARMONTH = '${YEARMONTH}'
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
order by AREAID,AREANAME,CITYID,CITYNAME

