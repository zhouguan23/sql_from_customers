select
ORG_ID
,SMART_SHORTNAME
,SMART_PARENTID 
from f_ehr_org_struc
where ORG_ID is not null
AND LEVEL <=4 -- 只取前4个层级
and SMART_STATUS=1 -- 组织标识为有效
and SMART_CATEGORY in (2,3) -- 用户数据权限对于股份本部仅直接分到股份本部整体，不细分到股份本部下各部门

WITH RECURSIVE dept_cte as
(
  select id,parentid,`name` from fine_department 
	where parentid ='old-platform-department-14000001'
  UNION ALL
  select t.id,t.parentid,concat(cte.`name`,'->',t.`name`) as namepath 
	from fine_department t 
	inner join dept_cte cte on t.parentid = cte.id
)
select 
	a.userName,
	a.realName,
	concat(d.name,'->',e.name," ",a.realName) as fullname, #用户名称（拼接部门名称）
	d.id as deptId,
	concat(d.name,'->',e.name) as deptName, #部门名称（拼接职位名称）
	d.parentId 
from fine_user a #用户表
left join fine_user_role_middle b on a.id=b.userid #用户角色、部门对应关系表
left join fine_dep_role c on b.roleId=c.id #部门、职位对应关系表
left join dept_cte d on c.departmentId=d.id #递归部门层级表
left join fine_post e on c.postId=e.id  #职位表

WITH RECURSIVE dept_cte as
(
  select 
  id
  ,parentid
  ,`name` as deptName
  ,`name` as fullpath 
  from finedb.fine_department 
	where parentid ='old-platform-department-14000001'
  UNION ALL
  select 
  t.id
  ,t.parentid
  ,t.`name`
  ,concat(cte.fullpath,'->',t.`name`)  
  from finedb.fine_department t 
  inner join dept_cte cte on t.parentid = cte.id
)

select 
	a.user_id, #用户登录名
	a.dept_id, #权限ID
	b.SMART_SHORTNAME, #权限名称
	c.userName, #FR用户登录名
	c.realName, #FR用户姓名
	f.id as deptId, #FR部门ID
	f.deptName, #FR部门名称
	f.parentId, #FR上级部门ID
	f.fullpath,  #FR部门层级全路径	 
	b.level
from fr_user_org_hr a
left join f_ehr_org_struc b on a.dept_id=b.ORG_ID
left join finedbv10.fine_user c on a.user_id=c.userName
left join finedbv10.fine_user_role_middle d on c.id=d.userid and d.roleType=1 #roleType:1 - 部门职位 2 - 自定义角色
left join finedbv10.fine_dep_role e on d.roleId=e.id
left join dept_cte f on e.departmentId=f.id
where 1=1
${if(len(userId)=0,"","and a.user_id='"+userId+"'")}
${if(len(deptId)==0,""," and a.dept_id in ("+"'"+treelayer(deptId,true,"\',\'")+"'"+")")}
order by a.user_id

with tmp_dept as(
	select 
		a.id,
		a.parentid,
		a.name as deptname,
		b.name as parentname 
	from fine_department a
	left join fine_department b on a.parentid=b.id
)
select 
	a.username,
	concat(d.PARENTNAME,'-',d.DEPTNAME,'-',e.name,'-',a.realName) as realname
from fine_user a #用户表
left join fine_user_role_middle b on a.id=b.userid #用户角色、部门对应关系表
left join fine_dep_role c on b.roleId=c.id #部门、职位对应关系表
left join tmp_dept d on c.departmentId=d.id #递归部门层级表
left join fine_post e on c.postId=e.id  #职位表

