SELECT MAX(INSERTIME) INSERTIME FROM INT_SIGNINCOME_RATE
WHERE CREDATE='${CREDATE}'

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT  AREAID,AREANAME FROM DIM_MKT_PROJECT
WHERE cityNAME IN
(
 SELECT DISTINCT DEPT_NAME FROM user_org
)
GROUP BY AREAID,AREANAME
order by charindex(AREANAME,'珠海区域|华南区域|华东区域|华中区域|北方区域|山东区域|北京公司')

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT  DISTINCT PERIODID,'('+PERIODID+')'+PROJECTNAME PROJECTNAME FROM DIM_MKT_PROJECT
WHERE  PROJECTID IN
(
 SELECT DISTINCT DEPT_ID FROM user_org
)
${if(len(AREANAME)=0,""," AND AREAID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYID IN ('"+CITYNAME+"')")}

WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)

SELECT  DISTINCT CITYID,CITYNAME FROM DIM_MKT_PROJECT
WHERE  CITYNAME IN
(
	 SELECT DISTINCT DEPT_NAME FROM user_org
)   
${if(len(AREANAME)=0,""," AND AREAID IN ('"+AREANAME+"')")}

with user_org as(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)
SELECT
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME,")}
  ${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME,")}
  ${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTNAME,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","A.PERIODID,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODNAME,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTNAME,")}
  CYEAR,
	${SWITCH(ISQY,0,"SUM(ZQY)/10000",1,"SUM(ZQY*RATIO)/10000")} ZQY,
	${SWITCH(ISQY,0,"SUM(DQY)/10000",1,"SUM(DQY*RATIO)/10000")} DQY,
	${SWITCH(ISQY,0,"SUM(DQYHK)/10000",1,"SUM(DQYHK*RATIO)/10000")} DQYHK,
	${SWITCH(ISQY,0,"SUM(DQYWHK)/10000",1,"SUM(DQYWHK*RATIO)/10000")} DQYWHK,
	${SWITCH(ISQY,0,"SUM(ZQYDHK)/10000",1,"SUM(ZQYDHK*RATIO)/10000")} ZQYDHK,
	${SWITCH(ISQY,0,"SUM(ZQYWHK)/10000",1,"SUM(ZQYWHK*RATIO)/10000")} ZQYWHK
FROM
	INT_SIGNINCOME_RATE A
LEFT JOIN (SELECT DISTINCT PERIODID,RATIO FROM DIM_MKT_PROJECT)B ON A.PERIODID=B.PERIODID
WHERE CREDATE='${CREDATE}'
${if(len(AREANAME)=0,""," AND AREAID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYID IN ('"+CITYNAME+"')")}
${if(LEN(PROJECTID)=0,""," AND PERIODID IN ('"+PROJECTID+"')")}
${if(LEN(PRODUCTID)=0,""," AND PRODUCTID IN ('"+PRODUCTID+"')")}
and projectid in (SELECT DISTINCT DEPT_ID FROM user_org )
GROUP BY 
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME,")}
  ${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME,")}
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTNAME,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","A.PERIODID,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODNAME,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTNAME,")}
  CYEAR

ORDER BY 
${if(INARRAY("1", SPLIT(counts, ",")) = 0,"","charindex(AREANAME,'华南区域|华东区域|华中区域|山东区域|北方区域|北京公司|'),")}
${if(INARRAY("2", SPLIT(counts, ",")) = 0,"","charindex(CITYNAME,'珠海华欣|珠海华景珠海西区|中山|广州|南宁|上海|南京|沈阳|大连|包头|'),")}
${if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
${if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODID,")}
${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
CYEAR

SELECT DISTINCT PRODUCTID,PRODUCTNAME FROM INT_SIGNINCOME_RATE
WHERE 1=1
${if(len(AREANAME)=0,""," AND AREAID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,""," AND CITYID IN ('"+CITYNAME+"')")}
${if(LEN(PROJECTID)=0,""," AND PERIODID IN ('"+PROJECTID+"')")}
ORDER BY PRODUCTID

SELECT
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME,")}
  ${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME,")}
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTNAME,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODID,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODNAME,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTNAME,")}
   CYEAR,
  SUM(ZQY)/10000 ZQY,
  SUM(DQY)/10000 DQY,
  SUM(DQYHK)/10000 DQYHK,
  SUM(DQYWHK)/10000 DQYWHK,
  SUM(ZQYDHK)/10000 ZQYDHK,
  SUM(ZQYWHK)/10000 ZQYWHK
FROM
	INT_SIGNINCOME_RATE
WHERE CREDATE='${CREDATE}'
${if(LEN(AREANAME)=0,""," AND AREAID IN ('"+AREANAME+"')")}
${if(LEN(CITYNAME)=0,""," AND CITYID IN ('"+CITYNAME+"')")}
${if(LEN(PROJECTID)=0,""," AND PERIODID IN ('"+PROJECTID+"')")}
${if(LEN(PRODUCTID)=0,""," AND PRODUCTID IN ('"+PRODUCTID+"')")}
GROUP BY 
  ${ if(INARRAY("1", SPLIT(counts, ",")) = 0,"","AREANAME,")}
  ${ if(INARRAY("2", SPLIT(counts, ",")) = 0,"","CITYNAME,")}
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
	${ if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTNAME,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODID,")} 
	${ if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODNAME,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
  ${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTNAME,")}
  CYEAR

ORDER BY 
${if(INARRAY("1", SPLIT(counts, ",")) = 0,"","charindex(AREANAME,'华南区域|华东区域|华中区域|山东区域|北方区域|北京公司|'),")}
${if(INARRAY("2", SPLIT(counts, ",")) = 0,"","charindex(CITYNAME,'珠海华欣|珠海华景珠海西区|中山|广州|南宁|上海|南京|沈阳|大连|包头|'),")}
${if(INARRAY("3", SPLIT(counts, ",")) = 0,"","PROJECTID,")} 
${if(INARRAY("4", SPLIT(counts, ",")) = 0,"","PERIODID,")}
${ if(INARRAY("5", SPLIT(counts, ",")) = 0,"","PRODUCTID,")}
CYEAR

