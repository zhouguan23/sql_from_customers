select '全部' citystrucode,'全部' citystruname
union
SELECT DISTINCT
citystrucode,citystruname
FROM dim_engin_projectstage
where 1=1
and citystrucode is not null
${if(len(AREANAME)=0,"","and areacode in ('"+AREANAME+"')")}
ORDER BY citystrucode




select '全部' areacode,'全部' areaname
union
SELECT DISTINCT
areacode,areaname
FROM dim_engin_projectstage
where 1=1
and areaCODE is not null
ORDER BY areacode






select distinct the_month 
from dim_time 
where 
the_date
 between '2020-01-01' AND NOW()

SELECT 
${if(AREANAME='全部'||CITYNAME='全部',"","GENERRAL_SITUATION,")}
${if(AREANAME='全部'||CITYNAME='全部',"","MONTHLY,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE1,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE2,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE3,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE4,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE5,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE6,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES1,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES2,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES3,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES4,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES5,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES6,")}
${if(AREANAME='全部'||CITYNAME='全部',"","MONTH_PLAN,")}
${if(AREANAME='全部'||CITYNAME='全部',"","SAFE_MANAGER,")}
${if(AREANAME='全部'||CITYNAME='全部',"","ENTERPERSON,")}
${if(AREANAME='全部'||CITYNAME='全部',"","ENTERTIME,")}
'a' as a,
sum(TRAIN_NUM1)TRAIN_NUM1,
sum(TRAIN_NUM2)TRAIN_NUM2,
sum(TRAIN_NUM3)TRAIN_NUM3,
sum(TRAIN_NUM4)TRAIN_NUM4,
sum(TRAIN_NUM5)TRAIN_NUM5,
sum(TRAIN_NUM6)TRAIN_NUM6,
sum(TRAIN_NUM7)TRAIN_NUM7,
sum(FEE_INPUT1)FEE_INPUT1,
sum(FEE_INPUT2)FEE_INPUT2

FROM `ipt_engin_monthly`
WHERE YEARMONTH = '${YEARMONTH}'
${if(AREANAME='全部',"","and areaid in ('"+AREANAME+"')")}
${if(CITYNAME='全部',"","and cityid in ('"+CITYNAME+"')")}
group by 
${if(AREANAME='全部'||CITYNAME='全部',"","GENERRAL_SITUATION,")}
${if(AREANAME='全部'||CITYNAME='全部',"","MONTHLY,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE1,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE2,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE3,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE4,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE5,")}
${if(AREANAME='全部'||CITYNAME='全部',"","RELATE_IMAGE6,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES1,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES2,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES3,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES4,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES5,")}
${if(AREANAME='全部'||CITYNAME='全部',"","IMAGE_DES6,")}
${if(AREANAME='全部'||CITYNAME='全部',"","MONTH_PLAN,")}
${if(AREANAME='全部'||CITYNAME='全部',"","SAFE_MANAGER,")}
${if(AREANAME='全部'||CITYNAME='全部',"","ENTERPERSON,")}
${if(AREANAME='全部'||CITYNAME='全部',"","ENTERTIME,")}
a



