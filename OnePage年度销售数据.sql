select   distinct  'SD'  as role,2 as rank  from   report.onepage_bi_daily_sales_performance  where SD=N'xulizhu'

with ds1 as (
select 
 sum(order_volume) as order_volume,
 sum(delivery_volume) as delivery_volume, 
 sum(estimate_c3) as c3
 from report.onepage_bi_daily_sales_performance
 where year='2020'
${if(or(u_role='ADMIN',login='admin'),"","and "+u_role+"=N'"+name+"'")}
),
ds2 as (
select   
sum(volume_target)  total_volume_target,
sum(c3_target)  total_c3_target
from 
report.onepage_all_target
where year='2020'
  and oil_level = 'TOTAL'
  and oil_type = 'TOTAL'
  and flag = 'oil_level_year'
${if(or(u_role='ADMIN',login='admin'),"and position='SGM' and name=N'孙凯' ","and name=N'"+name+"'  and position='"+u_role+"'" )}
)
select a.order_volume/1000 order_volume,
a.delivery_volume/1000 delivery_volume,
a.c3/1000 c3,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.order_volume/b.total_volume_target end  as order_phasing,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.delivery_volume/b.total_volume_target end  as deli_phasing,
case  when isnull(b.total_c3_target,0)=0 then '0'  else a.c3/b.total_c3_target end  as c3_phasing
from  ds1 a left  join    ds2  b  on 1=1



with ds1 as (
select 
 sum(order_volume) as order_volume,
 sum(delivery_volume) as delivery_volume, 
 sum(estimate_c3) as c3
 from report.onepage_bi_daily_sales_performance
 where year='2020'
 and dpf1_group='Ultra'
${if(or(u_role='ADMIN',login='admin'),"","and "+u_role+"=N'"+name+"'")}
),
ds2 as (
select   
sum(volume_target)  total_volume_target,
sum(c3_target)  total_c3_target
from 
report.onepage_all_target
where year='2020'
  and oil_level='TOTAL'
  and flag = 'dpf1_group_year'
  and dpf1= 'Ultra'
${if(or(u_role='ADMIN',login='admin'),"and position='SGM' and name=N'孙凯' ","and name=N'"+name+"'  and position='"+u_role+"'" )}
)
select a.order_volume/1000 order_volume,
a.delivery_volume/1000 delivery_volume,
a.c3/1000 c3,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.order_volume/b.total_volume_target end  as order_phasing,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.delivery_volume/b.total_volume_target end  as deli_phasing
from  ds1 a left  join    ds2  b  on 1=1

with ds1 as (
select 
 sum(order_volume) as order_volume,
 sum(delivery_volume) as delivery_volume, 
 sum(estimate_c3) as c3
 from report.onepage_bi_daily_sales_performance
 where year='2020'
 and oil_level='PA'
${if(or(u_role='ADMIN',login='admin'),"","and "+u_role+"=N'"+name+"'")}
),
ds2 as (
select   
sum(volume_target)  total_volume_target,
sum(c3_target)  total_c3_target
from 
report.onepage_all_target
where year='2020'
  and oil_level = 'PA'
  and oil_type = 'TOTAL'
  and flag = 'oil_level_year'
${if(or(u_role='ADMIN',login='admin'),"and position='SGM' and name=N'孙凯' ","and name=N'"+name+"'  and position='"+u_role+"'" )}
)
select a.order_volume/1000 order_volume,
a.delivery_volume/1000 delivery_volume,
a.c3/1000 c3,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.order_volume/b.total_volume_target end  as order_phasing,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.delivery_volume/b.total_volume_target end  as deli_phasing,
case  when isnull(b.total_c3_target,0)=0 then '0'  else a.c3/b.total_c3_target end  as c3_phasing
from ds1 a left join ds2 b on 1=1

with ds1 as (
select 
 sum(order_volume) as order_volume,
 sum(delivery_volume) as delivery_volume, 
 sum(estimate_c3) as c3
 from report.onepage_bi_daily_sales_performance
 where year='2020'
 and dpf1_group like 'CI%'
${if(or(u_role='ADMIN',login='admin'),"","and "+u_role+"=N'"+name+"'")}
),
ds2 as (
select   
sum(volume_target)  total_volume_target,
sum(c3_target)  total_c3_target
from 
report.onepage_all_target
where year='2020'
  and oil_level='TOTAL'
  and flag = 'dpf1_group_year'
  and dpf1 like 'CI%'
${if(or(u_role='ADMIN',login='admin'),"and position='SGM' and name=N'孙凯' ","and name=N'"+name+"'  and position='"+u_role+"'" )}
)
select a.order_volume/1000 order_volume,
a.delivery_volume/1000 delivery_volume,
a.c3/1000 c3,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.order_volume/b.total_volume_target end  as order_phasing,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.delivery_volume/b.total_volume_target end  as deli_phasing
from  ds1 a left  join    ds2  b  on 1=1

with ds1 as (
select 
 sum(order_volume) as order_volume,
 sum(delivery_volume) as delivery_volume, 
 sum(estimate_c3) as c3
 from report.onepage_bi_daily_sales_performance
 where year='2020'
 and dpf1_group like 'CK%'
${if(or(u_role='ADMIN',login='admin'),"","and "+u_role+"=N'"+name+"'")}
),
ds2 as (
select   
sum(volume_target)  total_volume_target,
sum(c3_target)  total_c3_target
from 
report.onepage_all_target
where year='2020'
  and oil_level='TOTAL'
  and flag = 'dpf1_group_year'
  and dpf1 like 'CK%'
${if(or(u_role='ADMIN',login='admin'),"and position='SGM' and name=N'孙凯' ","and name=N'"+name+"'  and position='"+u_role+"'" )}
)
select a.order_volume/1000 order_volume,
a.delivery_volume/1000 delivery_volume,
a.c3/1000 c3,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.order_volume/b.total_volume_target end  as order_phasing,
case  when isnull(b.total_volume_target,0)=0 then '0'  else a.delivery_volume/b.total_volume_target end  as deli_phasing
from  ds1 a left  join    ds2  b  on 1=1

