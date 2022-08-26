WITH user_org as
(
  select * from fr_org where dept_id in (
		select dept_id from fr_user_org
			where user_id='${fine_username}' )
  UNION ALL
  select t.* from fr_org t inner join user_org tcte on t.parent_id = tcte.dept_id
)


SELECT 
yearmonth,
areaname,
cityname,
projectid,
projectname,
periodid,
periodname,
productid,
productname,
stock_order,
new_order,
stock_ks,
new_ks,
signamount1,
signamount2,
signamount,
income1,
income2,
income,
ksignamount1,
ksignamount2,
ksignamount,
kincome1,
kincome2,
kincome,
insertperson,
insertime
from  ipt_mkt_area_kpi_target_hz
where yearmonth = '${yearmonth}'
AND  PROJECTID IN
(
	SELECT DEPT_ID FROM user_org 
)

select distinct the_month from dim_time
where left(the_month,4) = '2021'

SELECT DISTINCT
  T1.AREA_CODE ,
 T1.AREA_NAME,
 T1.CITY_CODE,
 T1.CITY_NAME,
  T1.PROJECT_ID, 
 T1.project_name,
 T1.PERIOD_ID,
 T1.PERIOD_NAME,
 T1.PRODUCT_ID,
 T1.PRODUCT_NAME
 
 FROM MKT_PROJECT_ENTERING T1 
WHERE T1.DEL_FLAG=0
AND AREA_CODE='1099006'
AND PROJECT_ID NOT IN ('HZ2000000058','HZ2000000059','HZ2000000060','HZ2000000090','HZ2000000091','HZ2000000031','HZ2000000061','HZ2000000092','HZ2000000038','HZ2000000005','HZ2000000054','HZ2000000055','HZ2000000056','HZ2000000077')

