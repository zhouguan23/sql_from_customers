WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   MKT_CITY_ID city_id,
   MKT_CITY_NAME city_name
from 
fr_erp_mkt_organization 
where 1=1
and  SAP_CITY_ID in(
	select distinct sap_dept_id from user_org 
)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   MKT_DEPT_ID area_id,
   MKT_DEPT_NAME area_name
from 
fr_erp_mkt_organization 
where 1=1
and  SAP_CITY_ID in(
	select distinct sap_dept_id from user_org 
)


select distinct the_month 
from dim_time 
where 
the_date between '2020-07-01' and curdate()

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
t1 as(
select distinct
a.area_name,
a.CITY_NAME,
a.city_id,
a.proj_name,
a.stage_name,
a.equity_ratio/100  equity_ratio,
a.PROD_TYPE_NAME,
a.PROD_TYPE_ID,
a.BUILD_NAME,
b.is_keep,
b.BUILD_AREA,
b.FLOOR_NUM,
b.standard,
b.ROOM_DIST,
ZNUM,
ZAREA,
ZPRICE/10000 ZPRICE,
ORDER_NUM,
ORDER_AREA,
ORDER_AMOUNT/10000 ORDER_AMOUNT,
SIGN_NUM,
SIGN_AREA, 
SIGN_AMOUNT/10000 SIGN_AMOUNT,
INCOME_AMOUNT/10000 INCOME_AMOUNT,
QZ_NUM,
QZ_AREA,
QZ_AMOUNT/10000 QZ_AMOUNT,
(QZ_NUM-WT_NUM-BKS_NUM) KS_NUM,
(QZ_AREA-WT_AREA-BKS_AREA) KS_AREA,
(QZ_AMOUNT-WT_AMOUNT-BKS_AMOUNT)/10000 KS_AMOUNT,
BKS_NUM,
BKS_AREA,
BKS_AMOUNT/10000 BKS_AMOUNT,
WT_NUM,
WT_AREA,
WT_AMOUNT/10000 WT_AMOUNT, 
'操盘' as cp_flag
from f_mkt_month_base_rpt a 
left join ipt_mkt_basic b on b.stage_id = a.stage_id and a.prod_type_id = b.prod_type_id and a.build_id = b.build_id
WHERE 1=1
${if(len(AREANAME)=0,"","and A.area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and A.CITY_ID IN ('"+CITYNAME+"')")}
AND A.YEARMONTH ='${YEARMONTH}'

union all 

select 
area_name,
CITY_NAME,
city_id,
proj_name,
stage_name,
equity_ratio,
PROD_TYPE_NAME,
PROD_TYPE_ID,
BUILD_NAME,
is_keep,
BUILD_AREA,
FLOOR_NUM,
standard,
ROOM_DIST,
ZNUM,
ZAREA,
ZPRICE,
ORDER_NUM,
ORDER_AREA,
ORDER_AMOUNT,
SIGN_NUM,
SIGN_AREA, 
SIGN_AMOUNT,
INCOME_AMOUNT,
QZ_NUM,
QZ_AREA,
QZ_AMOUNT,
(QZ_NUM-WT_NUM-BKS_NUM) KS_NUM,
(QZ_AREA-WT_AREA-BKS_AREA) KS_AREA,
(QZ_AMOUNT-WT_AMOUNT-BKS_AMOUNT) KS_AMOUNT,
BKS_NUM,
BKS_AREA,
BKS_AMOUNT,
WT_NUM,
WT_AREA,
WT_AMOUNT,
'非操盘' as cp_flag
from ipt_mkt_month
WHERE 1=1
${if(len(AREANAME)=0,"","and area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
AND YEARMONTH ='${YEARMONTH}'

)
   select 
    ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," AREA_NAME," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITY_NAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGE_NAME,EQUITY_RATIO," ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PROD_TYPE_NAME," ) }
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","BUILD_NAME,IS_KEEP,BUILD_AREA,FLOOR_NUM,STANDARD,
ROOM_DIST," ) }
${ if(INARRAY("7", SPLIT(rank, ",")) = 0,"","CP_FLAG," ) }
'a' as aa,
sum(ZNUM) ZNUM,
sum(ZAREA)ZAREA,
sum(ZPRICE)ZPRICE,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*ZPRICE/ZNUM" ) } ELSE 10000*ZPRICE/ZAREA END) AVG_ZPRICE,
sum(ORDER_NUM)ORDER_NUM,
sum(ORDER_AREA)ORDER_AREA,
sum(ORDER_AMOUNT)ORDER_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*ORDER_AMOUNT/ORDER_NUM" ) } ELSE 10000*ORDER_AMOUNT/ORDER_AREA END) AVG_ORDER_AMOUNT,
sum(SIGN_NUM)SIGN_NUM,
sum(SIGN_AREA)SIGN_AREA, 
sum(SIGN_AMOUNT)SIGN_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*SIGN_AMOUNT/SIGN_NUM" ) } ELSE 10000*SIGN_AMOUNT/SIGN_AREA END) AVG_SIGN_AMOUNT,
sum(INCOME_AMOUNT)INCOME_AMOUNT,
sum(QZ_NUM)QZ_NUM,
sum(QZ_AREA)QZ_AREA,
sum(QZ_AMOUNT)QZ_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*QZ_AMOUNT/QZ_NUM" ) } ELSE 10000*QZ_AMOUNT/QZ_AREA END) AVG_QZ_AMOUNT,
sum(KS_NUM)KS_NUM,
sum(KS_AREA)KS_AREA,
sum(KS_AMOUNT)KS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*KS_AMOUNT/KS_NUM" ) }  ELSE 10000*KS_AMOUNT/KS_AREA END) AVG_KS_AMOUNT,
sum(BKS_NUM)BKS_NUM,
sum(BKS_AREA)BKS_AREA,
sum(BKS_AMOUNT)BKS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL","10000*BKS_AMOUNT/BKS_NUM" ) } ELSE 10000*BKS_AMOUNT/BKS_AREA END) AVG_BKS_AMOUNT,
sum(WT_NUM)WT_NUM,
sum(WT_AREA)WT_AREA,
sum(WT_AMOUNT)WT_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*WT_AMOUNT/WT_NUM" ) }  ELSE 10000*WT_AMOUNT/WT_AREA END) AVG_WT_AMOUNT,
sum(QZ_NUM-WT_NUM) WS_NUM,
sum(QZ_AREA-WT_AREA) WS_AREA,
sum(QZ_AMOUNT-WT_AMOUNT) WS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*(QZ_AMOUNT-WT_AMOUNT)/(QZ_NUM-WT_NUM)" ) }  ELSE 10000*(QZ_AMOUNT-WT_AMOUNT)/(QZ_AREA-WT_AREA) END) AVG_WS_AMOUNT,


sum(EQUITY_RATIO*ZNUM) QY_ZNUM,
sum(EQUITY_RATIO*ZAREA)QY_ZAREA,
sum(EQUITY_RATIO*ZPRICE)QY_ZPRICE,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*ZPRICE/ZNUM" ) } ELSE 10000*EQUITY_RATIO*ZPRICE/ZAREA END) QY_AVG_ZPRICE,
sum(EQUITY_RATIO*ORDER_NUM)QY_ORDER_NUM,
sum(EQUITY_RATIO*ORDER_AREA)QY_ORDER_AREA,
sum(EQUITY_RATIO*ORDER_AMOUNT)QY_ORDER_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*ORDER_AMOUNT/ORDER_NUM" ) } ELSE 10000*EQUITY_RATIO*ORDER_AMOUNT/ORDER_AREA END) QY_AVG_ORDER_AMOUNT,
sum(EQUITY_RATIO*SIGN_NUM)QY_SIGN_NUM,
sum(EQUITY_RATIO*SIGN_AREA)QY_SIGN_AREA, 
sum(EQUITY_RATIO*SIGN_AMOUNT)QY_SIGN_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*SIGN_AMOUNT/SIGN_NUM" ) } ELSE 10000*EQUITY_RATIO*SIGN_AMOUNT/SIGN_AREA END) QY_AVG_SIGN_AMOUNT,
sum(EQUITY_RATIO*INCOME_AMOUNT)QY_INCOME_AMOUNT,
sum(EQUITY_RATIO*QZ_NUM)QY_QZ_NUM,
sum(EQUITY_RATIO*QZ_AREA)QY_QZ_AREA,
sum(EQUITY_RATIO*QZ_AMOUNT)QY_QZ_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*QZ_AMOUNT/QZ_NUM " ) } ELSE 10000*EQUITY_RATIO*QZ_AMOUNT/QZ_AREA END) QY_AVG_QZ_AMOUNT,
sum(EQUITY_RATIO*KS_NUM)QY_KS_NUM,
sum(EQUITY_RATIO*KS_AREA)QY_KS_AREA,
sum(EQUITY_RATIO*KS_AMOUNT)QY_KS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*KS_AMOUNT/KS_NUM " ) } ELSE 10000*EQUITY_RATIO*KS_AMOUNT/KS_AREA END) QY_AVG_KS_AMOUNT,
sum(EQUITY_RATIO*BKS_NUM)QY_BKS_NUM,
sum(EQUITY_RATIO*BKS_AREA)QY_BKS_AREA,
sum(EQUITY_RATIO*BKS_AMOUNT)QY_BKS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*KS_AMOUNT/KS_NUM " ) } ELSE 10000*EQUITY_RATIO*KS_AMOUNT/KS_AREA END) QY_AVG_BKS_AMOUNT,
sum(EQUITY_RATIO*WT_NUM)QY_WT_NUM,
sum(EQUITY_RATIO*WT_AREA)QY_WT_AREA,
sum(EQUITY_RATIO*WT_AMOUNT)QY_WT_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*EQUITY_RATIO*WT_AMOUNT/WT_NUM" ) } ELSE 10000*EQUITY_RATIO*WT_AMOUNT/WT_AREA END) QY_AVG_WT_AMOUNT,
sum(EQUITY_RATIO*QZ_NUM-EQUITY_RATIO*WT_NUM) QY_WS_NUM,
sum(EQUITY_RATIO*QZ_AREA-EQUITY_RATIO*WT_AREA) QY_WS_AREA,
sum(EQUITY_RATIO*QZ_AMOUNT-EQUITY_RATIO*WT_AMOUNT) QY_WS_AMOUNT,
AVG(CASE WHEN LEFT(PROD_TYPE_ID,2)='04' THEN ${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"NULL"," 10000*(QZ_AMOUNT-WT_AMOUNT)/(QZ_AREA-WT_AREA)" ) }  ELSE 10000*EQUITY_RATIO*(QZ_AMOUNT-WT_AMOUNT)/(QZ_AREA-WT_AREA) END) QY_AVG_WS_AMOUNT


from t1
left join  (select distinct mkt_city_id,sap_city_id from fr_erp_mkt_organization)T2 on t1.city_id = t2.mkt_city_id
inner join (select DISTINCT sap_dept_id from user_org ) t3 on t2.sap_city_id = t3.sap_dept_id
where 1=1
${if(len(cpflag)=0,"","and cp_flag in ('"+cpflag+"')")}
${if(len(PROJ)=0,"","and PROJ_NAME IN ('"+PROJ+"')")}
and  SAP_CITY_ID in(
	select distinct sap_dept_id from user_org 
)
group by 
 ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," AREA_NAME," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITY_NAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGE_NAME,EQUITY_RATIO," ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PROD_TYPE_NAME," ) }
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","BUILD_NAME,IS_KEEP,BUILD_AREA,FLOOR_NUM,STANDARD,
ROOM_DIST," ) }
${ if(INARRAY("7", SPLIT(rank, ",")) = 0,"","CP_FLAG," ) }
aa

order  by 
  ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,""," instr(
    '珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司',AREA_NAME)," ) }
		${ if(INARRAY("2", SPLIT(rank, ",")) = 0,""," CITY_NAME," ) } 
		${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) }
		${ if(INARRAY("4", SPLIT(rank, ",")) = 0,""," STAGE_NAME,EQUITY_RATIO," ) } 
		${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PROD_TYPE_NAME," ) }
		${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","BUILD_NAME,IS_KEEP,BUILD_AREA,FLOOR_NUM,STANDARD,
ROOM_DIST," ) }
${ if(INARRAY("7", SPLIT(rank, ",")) = 0,"","CP_FLAG," ) }
aa

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select 
distinct
proj_name
from f_mkt_month_base_rpt a
left join fr_erp_mkt_organization c on a.city_id = c.mkt_city_id
WHERE 1=1
${if(len(AREANAME)=0,"","and area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
and  sap_city_id in(
	select distinct sap_dept_id from user_org 
)

union all 

select
distinct
proj_name
from ipt_mkt_month a
left join fr_erp_mkt_organization c on a.city_id = c.mkt_city_id
WHERE 1=1
${if(len(AREANAME)=0,"","and area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
and  sap_city_id in(
	select distinct sap_dept_id from user_org
)

order by proj_name


