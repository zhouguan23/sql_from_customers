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
${if(len(AREANAME)=0,"","and areacode in ('"+AREANAME+"')")}
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
and areaname is not null
 and projectcode in (select strucode from user_org)
order by areacode



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

SELECT 
GENERRAL_SITUATION,
MONTHLY,
RELATE_IMAGE1,
RELATE_IMAGE2,
RELATE_IMAGE3,
RELATE_IMAGE4,
RELATE_IMAGE5,
RELATE_IMAGE6,
IMAGE_DES1,
IMAGE_DES2,
IMAGE_DES3,
IMAGE_DES4,
IMAGE_DES5,
IMAGE_DES6,
TRAIN_NUM1,
TRAIN_NUM2,
TRAIN_NUM3,
TRAIN_NUM4,
TRAIN_NUM5,
TRAIN_NUM6,
TRAIN_NUM7,
TRAIN_DES7,
FEE_INPUT1,
FEE_INPUT2,
MONTH_PLAN,
SAFE_MANAGER,
ENTERPERSON,ENTERTIME
FROM `ipt_engin_monthly`
WHERE YEARMONTH = '${YEARMONTH}'
${if(len(AREANAME)=0,"","and areaid in ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and cityid in ('"+CITYNAME+"')")}
and cityid in (select strucode from user_org)

