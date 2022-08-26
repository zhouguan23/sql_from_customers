SELECT DISTINCT
areacode,areaname
FROM dim_engin_projectstage
where 1=1
and areacode is not null
ORDER BY areacode



SELECT DISTINCT
citystrucode,citystruname
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
ORDER BY citystrucode


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
${if(len(areaname)=0,"","and areacode in ('"+areaname+"')")}
union 
*/

select areaid areacode,areaname,cityid citystrucode,cityname citystruname,projectid PROJECTCODE,projectname
from ipt_engin_cip
where 1=1
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
order by  areacode,citystrucode



SELECT 
AREAID,AREANAME,CITYID,CITYNAME,PROJECTNAME,projectid,
PADDRESS,JF_COMPANY,JF_PERSON,JF_PHONE,
BUILD_COMPANY,MAN_COMPANY,PRO_TYPE,IMA_PROGRESS,
RELATE_IMAGE,COMMENTS,ENTERPERSON,ENTERTIME
FROM `ipt_engin_cip`

where 1=1
and YEARMONTH = '${YEARMONTH}'
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}
AND IMA_PROGRESS  IS NOT NULL AND   IMA_PROGRESS <>''
order by AREAID,AREANAME,CITYID,CITYNAME,projectid

