select
fine_user.email as 邮箱,
fine_user.mobile ,
fine_user.realName ,
fine_user.userName,
fine_user.workPhone as 手机,
fine_department.name as 部门,fine_post.name as 职务,
FINE_USER_POWER.shadow as 映射,
FINE_USER_POWER.shadow_role as 映射角色,
a.角色 as 角色
from  fine_user 
left join fine_user_role_middle  on fine_user.id=fine_user_role_middle.userId
left join fine_dep_role on fine_dep_role.id=fine_user_role_middle.roleId
left join fine_department on fine_department.id=fine_dep_role.departmentId
left join  fine_post on fine_post.id=fine_dep_role.postId
left join FINE_USER_POWER  on fine_user.username = FINE_USER_POWER.username
left join 
(
select
distinct fine_user.userName ,
fine_custom_role.name as 角色
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'
)a
on fine_user.userName=a.userName
where  fine_user_role_middle.roleType='1'
${if(len(role)=0,"","and a.角色 in('"+role+"')")}
${if(len(login)=0,"","and fine_user.username  in('"+login+"')")}
order  by a.角色

select   distinct name  from  fine_custom_role

select distinct fine_user.userName ,
fine_custom_role.name as 角色
from fine_user 
left join fine_user_role_middle  on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where 1=1 --fine_user_role_middle.roleType='2'
${if(len(role)=0,"","and fine_custom_role.name in('"+role+"')")}
order  by fine_custom_role.name

