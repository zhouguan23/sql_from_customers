SELECT 
todate(time)  , /* 时间*/
displayName , /*报表名*/
type, /*访问方式*/
ip,
username,
consume   , /* 执行总耗时*/
memory, /*占用内存*/
complete /* 是否计算完成,若因宕机等情况计算中断，记录为0,若计算完成，记录为1*/
FROM fine_record_execute
where
username != 'huafa(huafa)' 
and username !='莫超杰(mochaojie)' 
and username!= '仲华龙(zhonghualong)' 
and username!='报表测试a(report01)' /*排除管理员*/
and todate(time) >= '${a}' and todate(time)<= '${b}'
and displayName like '%${C}%'
ORDER BY displayName

WITH RECURSIVE user_org as
(
select a.DEPT_LEVEL,a.SAP_DEPT_ID,a.SAP_DEPT_NAME,a.SAP_PARENT_ID,a.SAP_PARENT_NAME,b.USER_ID,b.USER_NAME from fr_org a
left join fr_user_org b 
on a.sap_dept_id=b.dept_id and a.org_type=b.org_type and a.org_type='组织' 
 and a.sap_dept_id!='E01' #如果=E01就是全权限的人
			where user_id in (select distinct USER_ID from fr_user_org )
  UNION ALL
  select t.DEPT_LEVEL,t.SAP_DEPT_ID,t.SAP_DEPT_NAME,t.SAP_PARENT_ID,t.SAP_PARENT_NAME,tcte.USER_ID,tcte.USER_NAME from fr_org t inner join user_org tcte on t.sap_parent_id = tcte.sap_dept_id 
), a as(
select sap_dept_id,sap_dept_name,SAP_PARENT_ID,SAP_PARENT_NAME,user_id,concat(USER_NAME,concat('(',user_id,')')) USER_NAME from user_org 
where DEPT_LEVEL='0' #股份
),b as (select sap_dept_id,sap_dept_name,SAP_PARENT_ID,SAP_PARENT_NAME,user_id,concat(USER_NAME,concat('(',user_id,')')) USER_NAME from user_org 
where DEPT_LEVEL='1' #区域
and USER_ID not in (select distinct USER_ID from a)
),c as (select sap_dept_id,sap_dept_name,SAP_PARENT_ID,SAP_PARENT_NAME,user_id,concat(USER_NAME,concat('(',user_id,')')) USER_NAME from user_org 
where DEPT_LEVEL='2' #1城市
and USER_ID not in (select distinct USER_ID from a)
and USER_ID not in (select distinct USER_ID from b)
),d as(
select * from a 
union 
select * from b
union 
select * from c
)SELECT *
FROM D
WHERE USER_NAME<>'报表测试a(report01)'
${IF(LEN(sap_dept_id)=0,"","and sap_dept_id IN ('"+sap_dept_id+"')")}


SELECT distinct 
	a.DEPT_LEVEL,
	a.SAP_DEPT_ID,
	a.SAP_DEPT_NAME
FROM
	fr_org a
INNER JOIN fr_user_org b ON a.sap_dept_id = b.dept_id 
where a.DEPT_LEVEL IN (0,1,2)
AND a.ORG_TYPE='组织'
order by a.SAP_DEPT_ID

SELECT 
displayName 
FROM fine_record_execute
where
username != 'huafa(huafa)' 
and username !='莫超杰(mochaojie)' 
and username!= '仲华龙(zhonghualong)' 
and username!='报表测试a(report01)' /*排除管理员*/
and todate(time) >= '${a}' and todate(time)<= '${b}'
ORDER BY displayName

