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
and areaname is not null
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
from ipt_engin_safepro
where 1=1
and cityid in (select strucode from user_org)
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

SELECT 
PROJECTNAME,
BDSTID,
BDSTNAME,
ACC_TIME,
ACC_SPACE,
ACC_DESCRIPT,
ACC_TYPE,
ACC_REASON,
ACC_NATURE,
DIRECT_LOSS,
TOTAL_LOSS,
MON_QSNUM,
MON_ZSNUM,
MON_DENUM,
YEAR_QSNUM,
YEAR_ZSNUM,
YEAR_DENUM,
COMMENTS,
RES_PERSON,
ENTERPERSON,
ENTERTIME
FROM ipt_engin_safepro
WHERE YEARMONTH = '${YEARMONTH}'
${if(len(areaname)=0,"","and areaid in ('"+areaname+"')")}
${if(len(cityname)=0,"","and cityid in ('"+cityname+"')")}

select -4 num,'高处坠落' name union
select -3 num,'物体打击' name union
select -2 num,'坍塌' name union
select -1 num,'火灾' name union
select 0 num,'触电' name union
select 1 num,'车辆伤害' name union
select 2 num,'起重伤害' name union
select 3 num,'容器爆炸' name union
select 4 num,'车辆伤害' name union
select 5 num,'起重伤害' name union
select 6 num,'容器爆炸' name union
select 7 num,'机械伤害' name union
select 8 num,'淹溺' name union
select 9 num,'中毒和窒息' name union
select 10 num,'灼烫' name union
select 11 num,'其它爆炸' name union
select 12 num,'其它伤害' name
order by num 


