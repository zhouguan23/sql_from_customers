select sap_dept_id,sap_dept_name,sap_parent_id from fr_org
where sap_dept_id is not null
and org_type ='${F2}'
ORDER BY DEPT_LEVEL,sap_dept_id

WITH RECURSIVE dept_cte as
(
  select id,parentid,`name` as deptName,`name` as fullpath from finedb.fine_department 
	where parentid ='old-platform-department-14000001'
  UNION ALL
  select t.id,t.parentid,t.`name`,concat(cte.fullpath,'->',t.`name`)  
  from finedb.fine_department t 
  inner join dept_cte cte on t.parentid = cte.id
)
select 
	a.user_id, #用户登录名
	a.dept_id, #权限ID
	b.sap_dept_name, #权限名称
	c.userName, #FR用户登录名
	c.realName, #FR用户姓名
	f.id as deptId, #FR部门ID
	f.deptName, #FR部门名称
	f.parentId, #FR上级部门ID
	f.fullpath,  #FR部门层级全路径	 
	b.dept_level,
	a.org_type
from fr_user_org a
left join fr_org b on a.dept_id=b.sap_dept_id and a.org_type=b.org_type
left join finedbv10.fine_user c on a.user_id=c.userName
left join finedbv10.fine_user_role_middle d on c.id=d.userid and d.roleType=1 #roleType:1 - 部门职位 2 - 自定义角色
left join finedbv10.fine_dep_role e on d.roleId=e.id
left join dept_cte f on e.departmentId=f.id
where 1=1
${if(find("全部",userId)>0,"","and a.user_id='"+userId+"'")}
${if(len(deptId)==0,""," and a.dept_id in ("+"'"+treelayer(deptId,true,"\',\'")+"'"+")")}
order by a.user_id,a.org_type

WITH C AS (
	SELECT DISTINCT
    A.DEPTID,
		A.PARENTID,
		B.DEPTNAME PARENTNAME
	FROM
		DIM_DEPT A
	LEFT JOIN DIM_DEPT B ON A.PARENTID = B.DEPTID
) SELECT
	B.USERID,
	C.PARENTNAME+'-'+B.DEPTNAME+'-'+B.USERNAME USERNAME
FROM
 DIM_USER B
LEFT JOIN  C ON B.DEPTID = C.DEPTID

select distinct org_type from fr_org

