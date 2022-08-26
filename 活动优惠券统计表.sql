with t1 as(
SELECT '${edate}'  CREDATE,
area.area_name area,
p.city,
p.projectname projectName,
p.hfProjectId projectId,
p.sale_org_id saleOrgId,
'领券数' AS dataTarget,
'优惠券'  AS activityType,
ad.activityName,
IFNULL(td.total,0) tomorrowCount,
IFNULL(ad.total,0) totalCount
FROM (
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.`status`,o.pageId,p.pid projectId,p.appid,o.amount activityId,o.payTime,
CASE o.amount
WHEN 880 THEN '8.8优惠券'
WHEN 990 THEN '9.9优惠券'
WHEN 1212 THEN '12.12优惠券'
ELSE '其他' END activityName
FROM from_oop_order o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`>0 AND o.amount in (880,990,1212)
)act WHERE date(payTime)>='2020-10-23' and date(payTime)<='${edate}' GROUP BY projectId,activityId
) ad 
LEFT JOIN(
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.`status`,o.pageId,p.pid projectId,p.appid,
o.amount activityId,o.payTime,
CASE o.amount
WHEN 880 THEN '8.8优惠券'
WHEN 990 THEN '9.9优惠券'
WHEN 1212 THEN '12.12优惠券'
ELSE '其他' END activityName
FROM from_oop_order o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`>0 AND o.amount in (880,990,1212)
)act WHERE  date(payTime)='${edate}'  GROUP BY projectId,activityId
) td ON (td.activityId=ad.activityId AND td.projectId=ad.projectId)
LEFT JOIN dh_project p ON p.Id=ad.projectId
LEFT JOIN sys_area_app area ON area.app_id=p.appid

UNION

SELECT '${edate}'  CREDATE,
area.area_name area,
p.city,
p.projectname projectName,
p.hfProjectId projectId,
p.sale_org_id saleOrgId,
'核销数' AS dataTarget,
'优惠券' AS activityType,
ad.activityName,
IFNULL(td.total,0) tomorrowCount,
IFNULL(ad.total,0) totalCount
FROM (
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.`status`,o.pageId,p.pid projectId,p.appid,o.amount activityId,o.prizeWriteOffTime payTime,
CASE o.amount
WHEN 880 THEN '8.8优惠券'
WHEN 990 THEN '9.9优惠券'
WHEN 1212 THEN '12.12优惠券'
ELSE '其他' END activityName
FROM from_oop_order o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`=3 AND o.amount in (880,990,1212)
)act WHERE date(payTime)>='2020-10-23' and date(payTime)<='${edate}' GROUP BY projectId,activityId
) ad 
LEFT JOIN(
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.`status`,o.pageId,p.pid projectId,p.appid,
o.amount activityId,o.prizeWriteOffTime payTime,
CASE o.amount
WHEN 880 THEN '8.8优惠券'
WHEN 990 THEN '9.9优惠券'
WHEN 1212 THEN '12.12优惠券'
ELSE '其他' END activityName
FROM from_oop_order o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`=3 AND o.amount in (880,990,1212)
)act WHERE  date(payTime)='${edate}' GROUP BY projectId,activityId
) td ON (td.activityId=ad.activityId AND td.projectId=ad.projectId)
LEFT JOIN dh_project p ON p.Id=ad.projectId
LEFT JOIN sys_area_app area ON area.app_id=p.appid
/*
UNION 
SELECT '${edate}'  CREDATE,
area.area_name area,
p.city,
p.projectname,

p.hfProjectId projectId,
p.sale_org_id saleOrgId,
'领券数' AS dataTarget,
'优惠券' AS activityType,
ad.activityName,
IFNULL(td.total,0) tomorrowCount,
IFNULL(ad.total,0) totalCount
FROM (
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.pageId,p.pid projectId,p.appid,0 activityId,'免费券' activityName
FROM from_oop_coupon o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`>0 AND date(o.exchangeTime)<='${edate}' and date(o.exchangeTime)>='2020-10-23'
)act  GROUP BY projectId,activityId
) ad 
LEFT JOIN(
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.pageId,p.pid projectId,p.appid,0 activityId,'免费券' activityName
FROM from_oop_coupon o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`>0 AND  date(o.exchangeTime)='${edate}'
)act GROUP BY projectId,activityId
) td ON (td.activityId=ad.activityId AND td.projectId=ad.projectId)
LEFT JOIN dh_project p ON p.Id=ad.projectId
LEFT JOIN sys_area_app area ON area.app_id=p.appid

UNION 
SELECT
'${edate}'  CREDATE,
area.area_name area,
p.city,
p.projectname,
p.hfProjectId projectId,
p.sale_org_id saleOrgId,
'核销数' AS dataTarget,
'优惠券' AS activityType,
ad.activityName,
IFNULL(td.total,0) tomorrowCount,
IFNULL(ad.total,0) totalCount
FROM (
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.pageId,p.pid projectId,p.appid,0 activityId,'免费券' activityName
FROM from_oop_coupon o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`=2 AND date(o.outTime)<='${edate}' and date(o.createTime)>= '2020-10-23'
)act  GROUP BY projectId,activityId
) ad 
LEFT JOIN(
SELECT projectId,activityName,activityId, COUNT(activityId) total FROM (
SELECT o.pageId,p.pid projectId,p.appid,0 activityId,'免费券' activityName
FROM from_oop_coupon o 
LEFT JOIN hb_page_info p ON p.id=o.pageId
WHERE o.`status`=2 AND date(o.outTime)='${edate}'
)act GROUP BY projectId,activityId
) td ON (td.activityId=ad.activityId AND td.projectId=ad.projectId)
LEFT JOIN dh_project p ON p.Id=ad.projectId
LEFT JOIN sys_area_app area ON area.app_id=p.appid
*/
)


select credate,activityName,dataTarget,area,city,projectname,sum(tomorrowcount)tomorrowcount, sum(totalcount)totalcount
from t1
where activityname in('免费券','12.12优惠券')
group by activityName,dataTarget,credate,area,city,projectname
order by  
 find_in_set(area,"珠海区域,华南区域,华东区域,华中区域,山东区域,北方区域,北京区域")
,city,projectname

