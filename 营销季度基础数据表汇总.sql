WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
),
t1 as(
select 
AREA_ID,AREA_NAME,
CITY_ID,CITY_NAME,
PROJ_NAME,EQUITY_RATIO, 
STAGE_NAME,
PRODUCT_TYPE_NAME,
'非操盘' cp_flag,
WORDER_AMOUNT,
DORDER_AMOUNT,
WSIGN_AMOUNT,
DSIGN_AMOUNT,
WINCOME_AMOUNT,
DINCOME_AMOUNT,
WRGDQY,
DRGDQY,
WRGDHK,
DRGDHK,
WQYDHK,
DQYDHK,
DQYWHK,
QYWHK,
QYDHK,
SQZ,
SQZBRG,
BQZ,
BQZBRG

from ipt_mkt_quarter
WHERE 1=1
and  quartername = '${quartername}'
${if(len(AREANAME)=0,"","and area_id IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and city_id IN ('"+CITYNAME+"')")}

UNION ALL

select 
AREA_ID,AREA_NAME,
CITY_ID,CITY_NAME,
PROJ_NAME,EQUITY_RATIO/100, 
STAGE_NAME,
PRODUCT_TYPE_NAME,
'操盘' cp_flag,
WORDER_AMOUNT/10000,
DORDER_AMOUNT/10000,
WSIGN_AMOUNT/10000,
DSIGN_AMOUNT/10000,
WINCOME_AMOUNT/10000,
DINCOME_AMOUNT/10000,
WRGDQY/10000,
DRGDQY/10000,
WRGDHK/10000,
DRGDHK/10000,
WQYDHK/10000,
DQYDHK/10000,
DQYWHK/10000,
QYWHK/10000,
QYDHK/10000,
SQZ/10000,
SQZBRG/10000,
BQZ/10000,
BQZBRG/10000


from f_mkt_quart_base_rpt a

where 1=1
${if(len(AREANAME)=0,"","and a.area_id IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and a.city_id IN ('"+CITYNAME+"')")}
and credate in (
select max(credate) 
from f_mkt_quart_base_rpt a left join (select the_date,quarter_name from dim_time )b on a.credate = b.the_date  
where  quarter_name = '${quartername}')
)

select

${ if(INARRAY("1", SPLIT(rank, ",")) = 0,"","AREA_ID,AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(rank, ",")) = 0,"","CITY_ID,CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(rank, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PRODUCT_TYPE_NAME,EQUITY_RATIO," ) }
${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","cp_flag," ) }
'a' as a,
SUM(WORDER_AMOUNT) WORDER_AMOUNT,
SUM(DORDER_AMOUNT)DORDER_AMOUNT,
SUM(WSIGN_AMOUNT)WSIGN_AMOUNT,
SUM(DSIGN_AMOUNT)DSIGN_AMOUNT,
SUM(WINCOME_AMOUNT)WINCOME_AMOUNT,
SUM(DINCOME_AMOUNT)DINCOME_AMOUNT,
SUM(WRGDQY)WRGDQY,
SUM(DRGDQY)DRGDQY,
SUM(WRGDHK)WRGDHK,
SUM(DRGDHK)DRGDHK,
SUM(WQYDHK)WQYDHK,
SUM(DQYDHK)DQYDHK,
SUM(DQYWHK)DQYWHK,
SUM(QYWHK)QYWHK,
SUM(QYDHK)QYDHK,
SUM(SQZ)SQZ,
SUM(SQZBRG)SQZBRG,
SUM(BQZ)BQZ,
SUM(BQZBRG)BQZBRG

from  t1 
left join (select distinct mkt_city_id,sap_city_id from fr_erp_mkt_organization) t2 on t1.city_id = t2.mkt_city_id
inner join (select distinct sap_dept_id from user_org ) t3 on t2.sap_city_id = t3.sap_dept_id
where 1=1 
 ${if(len(cpflag)=0,"","and  cp_flag IN ('"+cpflag+"')")}
 ${if(len(PROJ)=0,"","and PROJ_NAME IN ('"+PROJ+"')")}
group by 
${ if(INARRAY("1", SPLIT(rank, ",")) = 0,"","AREA_ID,AREA_NAME," ) } 
${ if(INARRAY("2", SPLIT(rank, ",")) = 0,"","CITY_ID,CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(rank, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PRODUCT_TYPE_NAME,EQUITY_RATIO," ) }
${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","cp_flag," ) }
a
order by
    ${ if(INARRAY("1", SPLIT(rank, ",")) = 0,"","instr(
    '珠海区域|华南区域|华东区域|华中区域|山东区域|北方区域|北京公司',AREA_NAME)," ) } ${ if(INARRAY("2", SPLIT(rank, ",")) = 0,"","CITY_ID,CITY_NAME," ) }
${ if(INARRAY("3", SPLIT(rank, ",")) = 0,"","PROJ_NAME," ) } 
${ if(INARRAY("4", SPLIT(rank, ",")) = 0,"","STAGE_NAME," ) }
${ if(INARRAY("5", SPLIT(rank, ",")) = 0,"","PRODUCT_TYPE_NAME,EQUITY_RATIO," ) }
${ if(INARRAY("6", SPLIT(rank, ",")) = 0,"","cp_flag," ) }
a

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   mkt_city_id as city_id,
   mkt_city_name as city_name
from 
 fr_erp_mkt_organization 
where 1=1
${if(len(AREANAME)=0,"","and mkt_dept_id IN ('"+AREANAME+"')")}
and  sap_city_id in(
	select distinct sap_dept_id from user_org 
)

select distinct quarter_name
from dim_time 
where 
the_date between '2020-07-01' and curdate()

-- the_date between  left(now(),10) and date_add(now() interval -1 month)

WITH RECURSIVE user_org as
(
  select * from fr_org where sap_dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}')
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id
)
select distinct 
   mkt_dept_id as area_id,
   mkt_dept_name as area_name
from 
 fr_erp_mkt_organization 
where 1=1
and  sap_city_id in(
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
from ipt_mkt_quarter a
left join fr_erp_mkt_organization c on a.city_id = c.mkt_city_id
WHERE 1=1
${if(len(AREANAME)=0,"","and area_ID IN ('"+AREANAME+"')")}
${if(len(CITYNAME)=0,"","and CITY_ID IN ('"+CITYNAME+"')")}
and  sap_city_id in(
	select distinct sap_dept_id from user_org
)

order by proj_name



