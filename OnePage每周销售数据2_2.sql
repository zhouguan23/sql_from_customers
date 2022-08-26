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
from report.onepage_bi_monthly_sales_performance where [month]A=(month(getdate())-1) and position = 'SD') as newtable where [name]A=N'${name}';

select
distinct fine_user.userName ,
fine_custom_role.name as role
from  fine_user_role_middle 
left join fine_user on fine_user.id=fine_user_role_middle.userId
left join fine_custom_role on fine_custom_role.id=fine_user_role_middle.roleId
where fine_user_role_middle.roleType='2'

select a.sgm as name, a.year, a.[month]A, round(a.order_volume/1000,0) as ord_volume_kl, round(a.delivery_volume/1000,0) as del_volume_kl, round(a.c3/1000,0) as c3_k, b.[position]A, a.order_volume/b.total_volume_target as order_volume_phasing , a.delivery_volume/b.total_volume_target as del_volume_phasing, a.c3/b.total_c3_target as c3_phasing
from ((select sgm, year, [month]A, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume, sum(estimate_c3) as c3
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and month=month(getdate()-1) and date<=getdate()-1
    group by sgm, year, [month]A) as a left join report.onepage_bi_daily_sales_performance_target as b
    on a.year=b.year and a.sgm=b.name and b.position = 'SGM')
where delivery_volume is not null and c3 is not null and order_volume is not null and  [name]A=N'${name}';

select a.sgm as name, a.year, a.week_code, round(a.order_volume/1000,0) as ord_volume_kl, round(a.delivery_volume/1000,0) as del_volume_kl, round(a.c3/1000,0) as c3_k, b.[position]A, a.order_volume/b.total_volume_target as order_volume_phasing , a.delivery_volume/b.total_volume_target as del_volume_phasing, a.c3/b.total_c3_target as c3_phasing
from ((select sgm, year, week_code, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume, sum(estimate_c3) as c3
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and week_code=(datepart(week,getdate())-1)
    group by sgm, year, week_code) as a left join report.onepage_bi_daily_sales_performance_target as b
    on a.year=b.year and a.sgm=b.name and b.position = 'SGM')
where delivery_volume is not null and c3 is not null and order_volume is not null  and [name]A=N'${name}'

select format(min(distinct date),'MM-dd') as firstday, format(max(distinct date),'MM-dd') lastday
from report.onepage_bi_daily_sales_performance
where week_code=(datepart(week,getdate())-1) and year = year(getdate()-1);

with temp1 AS(
select sgm, year, month, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and month=month(getdate()-1) and date<=getdate()-1 and dpf1_group like 'CI%'
    group by sgm, year, month
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, a.month, round(a.order_volume/1000,0) as CI_order_volume, round(a.delivery_volume/1000,0) as CI_deliver_volume, round(a.order_volume/1000,0)/4000 as order_monthly_phasing , round(a.delivery_volume/1000,0)/4000 as Delivery_Month_Phasing,a.order_volume/b.ci_volume_target as Order_Yearly_Phasing,a.delivery_volume/b.ci_volume_target AS Delivery_Yearly_Phasing
from temp1 a LEFT JOIN temp2 b
ON a.year=b.year and a.sgm=b.name and b.position='SGM'
where a.delivery_volume is not null and a.order_volume is not null and a.sgm=N'${name}'

with temp1 AS(
select sgm, year, week_code, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and week_code=(datepart(week,getdate())-1) and dpf1_group like 'CI%'
    group by sgm, year, week_code
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, a.week_code, round(a.order_volume/1000,0) as CI_order_volume, round(a.delivery_volume/1000,0) as CI_deliver_volume, round(a.order_volume/1000,0)/4000 as order_monthly_phasing , round(a.delivery_volume/1000,0)/4000 as Delivery_Month_Phasing,a.order_volume/b.ci_volume_target as Order_Yearly_Phasing,a.delivery_volume/b.ci_volume_target AS Delivery_Yearly_Phasing
from temp1 a LEFT JOIN  temp2 b
ON a.year=b.year and a.sgm=b.name and b.POSITION='SGM'
where a.delivery_volume is not null and a.order_volume is not null and a.sgm=N'${name}'

with temp1 AS(
select sgm, year, month, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume, sum(estimate_c3) as c3
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and month=month(getdate()-1) and oil_level='PA'
    and date<=getdate()-1
    group by sgm, year, month
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, a.month, round(a.order_volume/1000,0) as PA_order_volume, round(a.delivery_volume/1000,0) as PA_deliver_volume, round(a.c3/1000,0) as PA_Estimate_c3,a.order_volume/b.pa_volume_target as PA_order_volume_phasing , a.delivery_volume/b.pa_volume_target as PA_del_volume_phasing, a.c3/b.pa_c3_target as PA_c3_phasing
from temp1 a left join temp2 b on a.year=b.year 
and a.sgm=b.name and b.position='SGM'
where a.delivery_volume is not null and a.c3 is not null and a.order_volume is not null and a.sgm=N'${name}'

with temp1 AS(
select sgm, year, week_code, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume, sum(estimate_c3) as c3
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and week_code=(datepart(week,getdate())-1) and oil_level='PA'
    group by sgm, year, week_code
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, a.week_code, round(a.order_volume/1000,0) as PA_order_volume, round(a.delivery_volume/1000,0) as PA_deliver_volume, round(a.c3/1000,0) as PA_Estimate_c3, b.[position]A, a.order_volume/b.pa_volume_target as PA_order_volume_phasing , a.delivery_volume/b.pa_volume_target as PA_del_volume_phasing, a.c3/b.pa_c3_target as PA_c3_phasing
from temp1 a left join temp2 b
ON a.year=b.year AND a.sgm=b.name and  b.POSITION='SGM'
where a.delivery_volume is not null and a.c3 is not null and a.order_volume is not null and a.sgm=N'${name}'

with temp1 AS(
select sgm, year, month, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and month=MONTH(getdate()-1) and date<=getdate()-1and dpf1_group='Ultra'
    group by sgm, year, month
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, month, round(a.order_volume/1000,0) as Ultra_order_volume, round(a.delivery_volume/1000,0) as Ultra_deliver_volume, round(a.order_volume/1000,0)/2000 as order_monthly_phasing ,  round(a.delivery_volume/1000,0)/2000 as Delivery_Month_Phasing,a.order_volume/b.ultra_volume_target as Order_Yearly_Phasing,a.delivery_volume/b.ultra_volume_target AS Delivery_Yearly_Phasing
from temp1 a LEFT JOIN temp2 b
on a.year=b.year and a.sgm=b.name and b.POSITION='SGM'
where a.delivery_volume is not null and a.order_volume is not null and a.sgm=N'${name}'

with temp1 AS(
select sgm, year, week_code, sum(order_volume) as order_volume, sum(delivery_volume) as delivery_volume
    from report.onepage_bi_daily_sales_performance
    where year=year(getdate()) and week_code=(datepart(week,getdate())-1) and dpf1_group='Ultra'
    group by sgm, year, week_code
),
temp2 AS(
SELECT * from report.onepage_bi_daily_sales_performance_target 
where name = N'孙凯'
)
SELECT a.sgm as name, a.year, a.week_code, round(a.order_volume/1000,0) as Ultra_order_volume, round(a.delivery_volume/1000,0) as Ultra_deliver_volume, round(a.order_volume/1000,0)/2000 as order_monthly_phasing , round(a.delivery_volume/1000,0)/2000 as Delivery_Month_Phasing,a.order_volume/b.ultra_volume_target as Order_Yearly_Phasing,a.delivery_volume/b.ultra_volume_target AS Delivery_Yearly_Phasing
from temp1 a LEFT JOIN temp2 b
ON a.year=b.year and a.sgm=b.name and b.POSITION='SGM'
where a.delivery_volume is not null and a.order_volume is not null and a.sgm=N'${name}'

select * from report.onepage_bi_daily_sales_performance

