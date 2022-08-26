SELECT 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," AREANAME, " ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," CITYNAME, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," PROJECTNAME, " ) }
${ if(INARRAY("4", SPLIT(dims, ",")) = 0,""," PERIODNAME,RATIO,HF_RATIO, " ) }
${ if(INARRAY("5", SPLIT(dims, ",")) = 0,""," SHORTNAME, " ) }
SUM(YRWQ)YRWQ,
SUM(YRWQ_HK)YRWQ_HK,
SUM(YRWQ_HK1)YRWQ_HK1,
SUM(YQY)YQY,
SUM(YQY_HK)YQY_HK,
SUM(YQY_HK1)YQY_HK1,
SUM(XZ_RQY)XZ_RQY,
SUM(XZ_RQY_HK)XZ_RQY_HK
FROM (
SELECT 
T1.AREANAME,
T1.CITYNAME,
T1.PROJECTNAME,
PERIODNAME,RATIO,HF_RATIO,
SHORTNAME,
'A' A,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YRWQ/10000 YRWQ,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YRWQ_HK/10000 YRWQ_HK,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YRWQ_HK1/10000 YRWQ_HK1,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YQY/10000 YQY,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YQY_HK/10000 YQY_HK,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}YQY_HK1/10000 YQY_HK1,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}XZ_RQY/10000 XZ_RQY,
${SWITCH(TYPE,0,"",1,"RATIO*",2,"HF_RATIO*")}XZ_RQY_HK/10000 XZ_RQY_HK

FROM INT_INCOME_ASSESSMENT T1
LEFT JOIN DIM_PRODUCT_TYPE T2 ON T1.PRODUCTID = T2.PRODUCTID 
LEFT JOIN (SELECT DISTINCT PROJECTID,PERIODID,PERIODNAME,RATIO,HF_RATIO FROM DIM_MKT_PROJECT) T3 ON T1.PERIODID = T3.PERIODID AND T1.PROJECTID = T3.PROJECTID
where 1=1
${if(len(AREA)=0,"","and T1.AREANAME in ('"+AREA+"')")}
${if(len(CITY)=0,"","and T1.CITYNAME in ('"+CITY+"')")}
${if(len(PRO) == 0,"","and T1.PROJECTID in ('" + PRO+ "')")}
and credate = '${version}'
) T1

GROUP BY 
${ if(INARRAY("1", SPLIT(dims, ",")) = 0,""," AREANAME, " ) }
${ if(INARRAY("2", SPLIT(dims, ",")) = 0,""," CITYNAME, " ) }
${ if(INARRAY("3", SPLIT(dims, ",")) = 0,""," PROJECTNAME, " ) }
${ if(INARRAY("4", SPLIT(dims, ",")) = 0,""," PERIODNAME,RATIO,HF_RATIO, " ) }
${ if(INARRAY("5", SPLIT(dims, ",")) = 0,""," SHORTNAME, " ) }
A


WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

select AREANAME FROM (
SELECT  distinct AREANAME 
FROM   DIM_MKT_PROJECT 
WHERE PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)) A



WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT CITYNAME FROM (
select distinct CITYNAME from DIM_MKT_PROJECT 
WHERE PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)

${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")} ) A


WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT DISTINCT PROJECTID,'('+PROJECTID+')'+ ISNULL(SALERGROUPNAME,PROJECTNAME) PROJECTNAME FROM DIM_MKT_PROJECT
WHERE PROJECTID IN
(
	SELECT DISTINCT DEPT_ID FROM user_org 
)  
${if(len(AREA) == 0,"","and AREANAME in ('" + AREA + "')")}
${if(len(CITY) == 0,"","and CITYNAME in ('" + CITY + "')")}

 
select  distinct right(quarter_name,3)
from dim_time 
where the_date = date_add('${version}',interval -3 month)

union select  distinct right(quarter_name,3)
from dim_time 
where the_date = '${version}'



