select distinct fine_user.userName ,
fine_custom_role.name as 角色
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2' and 
fine_user.userName in ('jin-hong.wang@shell.com')
${if(len(role)=0,"","and fine_custom_role.name in('"+role+"')")}
order  by fine_custom_role.name

select   distinct name  from  fine_custom_role

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
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
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
where fine_user_role_middle.roleType='1'
${if(len(role)=0,"","and a.角色 in('"+role+"')")}
${if(len(login)=0,"","and fine_user.username  in('"+login+"')")}
order  by a.角色

select * from report.onepage_people_order_delivery_tracking_volume where oiltype = '${oiltype}'

select sd, CEILING(sum(c3)) as c3 from report.onepage_people_order_delivery_tracking_volume group by sd

select * from fine_user where realName = '${sdname}'

select sd, data_source, FLOOR(sum(c3)/ 1000) as c3, FLOOR(sum(volume)/1000) as volume from 
report.onepage_people_order_delivery_tracking_volume
where year =2020 and time_window = 'MTD' group by sd, data_source;


select a.sd, Convert(decimal(18,0),a.volume) as volume, Convert(decimal(18,0),a.c3) as c3, b.volume_target, cast(Convert(decimal(18,1),a.volume/b.volume_target*100) as varchar) +'%' as phasing from 
(select sd, data_source, sum(c3) as c3, sum(volume) as volume from 
report.onepage_people_order_delivery_tracking_volume
where year =2020 and time_window = 'MTD' group by sd, data_source) a
left join 
(select sd, sum(volume_target) as volume_target from report.onepage_people_order_delivery_tracking_target where data_source = 'HOTT' and time_window = 'MTD' and year =2020
  group by sd) b on a.sd = b.sd;

select * from (select *,RANK()OVER(ORDER BY volume_phasing desc) as volume_rank, RANK()OVER(ORDER BY c3_phasing desc) as c3_rank 
from report.onepage_bi_monthly_sales_performance where [month]A=(month(getdate())-1) and position = 'SD') as newtable where  [name]A=N'${name}';

select
distinct fine_user.userName ,
fine_custom_role.name as role
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'

