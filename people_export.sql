select 
data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status,   --- 层级
sum(data1.carry_over) as carry_over,           --- ???
sum(data1.daily_order) as daily_order,
sum(data1.mtd_order) as mtd_order,
sum(data1.deliver) as deliver,         --- 销量
sum(b.target) as target,                             --- 目标值
sum(data1.deliver_last_year) as deliver_last_year,                  --- 去年销量
sum(data1.est_c3) as est_c3,              --- 利润
sum(data1.est_c3_last_year) as est_c3_last_year,                   --- 去年利润
sum(b.c3_target) as c3_target 
FROM
(
select  
  sd, rsm, icam, distributor_code,distributor,distributor_type,distributor_status,distributor_code_name,
  sum(carry_over)  carry_over,
  sum(daily_order)  daily_order,
  sum(mtd_order)  mtd_order,
  sum(deliver) deliver,
  sum(target) target,
  sum(deliver_last_year) deliver_last_year,
  sum(est_c3) est_c3,
  sum(est_c3_last_year) est_c3_last_year,
  sum(c3_target ) c3_target   
  from (
-- 今年的数据
select 
sd as sd,rsm as rsm,icam as icam,distributor_code,sold_to as distributor,distributor_type,distributor_status,distributor_code_name,   --- 层级
--sum(carry_over) as carry_over,           --- ???
--0 as daily_order,
--sum(order_volume) as mtd_order,
${if(len(times)=0 && data_from="OPMIS",0,"sum(carry_over)")} as carry_over,
0 as daily_order,
${if(len(times)=0 && data_from= "OPMIS",0,"sum(order_volume)")} as mtd_order,
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
--${if(len(dist)=0,"","and sold_to in(N'"+ dist +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ start_date +"' and '"+ end_date +"'"),"and year = DateName(year,GetDate()) and time_window='"+ times +"'")}
group by sd,rsm,icam,distributor_code,sold_to,distributor_type,distributor_status,distributor_code_name
-- 今天的数据
union all
select 
sd as sd,rsm as rsm,icam as icam,distributor_code,sold_to as distributor,distributor_type,distributor_status,distributor_code_name,   --- 层级
0 as carry_over,           --- ???
${if(times = 'MTD',"sum(order_volume)",0)} as daily_order,
0 as mtd_order,
0 as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
0 as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM report.[onepage_people_order_delivery_tracking_date]A
where 1 = 1
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
--${if(len(dist)=0,"","and sold_to in(N'"+ dist +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
and date = (select max(date) FROM report.[onepage_people_order_delivery_tracking_date]A)
group by sd,rsm,icam,distributor_code,sold_to,distributor_type,distributor_status,distributor_code_name
/*union all 
-- 今年目标值
select 
sd as sd,rsm as rsm,icam as icam,sold_to as distributor,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                
0 as deliver,              
sum(volume_target) as target,                    
0 as deliver_last_year,          
0 as est_c3,                   
0 as est_c3_last_year,    
sum(c3_target) as c3_target         
FROM report.[onepage_people_order_delivery_tracking_target]A
where 1 = 1
${if(len(times)=0,
if(data_from = "OPMIS",if(left(start_month,4)=left(end_month,4),"and time_window = 'YTD' and year = '"+left(start_month,4)+"'","and 1=2"),if(left(start_date,4)=left(end_date,4),"and time_window = 'YTD' and year = '"+left(start_date,4)+"'","and 1=2")),"and year = DateName(year,GetDate()) and time_window='"+ times +"'")}
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
${if(len(dist)=0,"","and sold_to in(N'"+ dist +"')")}
${if(len(p1)=0,"and product_filter_group='DPF1'","and product_filter_group='Oil level' and sub_type='"+ p1 +"'")}
and oil_type='${p2}'
${if(len(p3)=0,"","and sub_type in('"+ p1 +"')")}
group by sd,rsm,icam,distributor*/
union all 
-- 去年的数据
select 
sd as sd,rsm as rsm,icam as icam,distributor_code,sold_to as distributor,distributor_type,distributor_status,distributor_code_name,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                  
0 as deliver,              
0 as target,                    
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver_last_year,          
0 as est_c3,                   
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3_last_year,    
0 as c3_target         
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
--${if(len(dist)=0,"","and sold_to in(N'"+ dist +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ MONTHDELTA(start_date,-12) +"' and '"+ MONTHDELTA(end_date,-12) +"'"),"and year = DateName(year,GetDate())-1 and time_window='"+ times +"'")}
group by sd,rsm,icam,distributor_code,sold_to,distributor_type,distributor_status,distributor_code_name
) a group  by  sd, rsm, icam, distributor_code,distributor,distributor_type,distributor_status,distributor_code_name)data1
left  join
(
-- 今年目标值
select 
null as sd,null as rsm,null as icam,name as distributor,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                
0 as deliver,              
sum(volume_target) as target,                    
0 as deliver_last_year,          
0 as est_c3,                   
0 as est_c3_last_year,    
sum(c3_target) as c3_target         
FROM report.onepage_all_target
where 1 = 1
${if(len(p3)=0,if(len(p4)=0,"and flag='oil_level_year'","and flag='dpf1_group_year'"),"and flag='dpf1_year'")}
${if(len(times)=0,
if(data_from = "OPMIS",if(left(start_month,4)=left(end_month,4),"and year = '"+left(start_month,4)+"'","and 1=2"),if(left(start_date,4)=left(end_date,4)," and year = '"+left(start_date,4)+"'","and 1=2")),"and year = DateName(year,GetDate()) ")}
${if(len(p3)=0,if(len(p1)=0,"and oil_type='Total'","and oil_type='"+p1+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p2)=0,"and oil_level='Total'","and oil_level='"+p2+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p4)=0,"","and dpf1 in('"+p4+"')"),"")}
and position='distributor'
group by name) b  on data1.distributor_code_name=b.distributor
where 1=1
 and data1.sd in(
SELECT distinCt  sd
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
and data1.rsm in
(
SELECT distinCt  rsm
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")}
)
 and data1.icam in(
SELECT distinCt  icam
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='RSM',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
  and data1.distributor in(
SELECT distinCt  SOLD_TO
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='ICAM',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
group by data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status
order by case when data1.sd = N'杨磊' then 1
              when data1.sd = N'沈蜜苗' then 2
              when data1.sd = N'殷婕' then 3
              when data1.sd = N'李海' then 4
              when data1.sd = N'李刚' then 5
              else 6
               end

select 
data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status,   --- 层级
sum(data1.carry_over) as carry_over,           --- ???
sum(data1.daily_order) as daily_order,
sum(data1.mtd_order) as mtd_order,
sum(data1.deliver) as deliver,         --- 销量
sum(b.target) as target,                             --- 目标值
sum(data1.deliver_last_year) as deliver_last_year,                  --- 去年销量
sum(data1.est_c3) as est_c3,              --- 利润
sum(data1.est_c3_last_year) as est_c3_last_year,                   --- 去年利润
sum(b.c3_target) as c3_target 
FROM
(
select  
  sd, rsm, icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,
  sum(carry_over)  carry_over,
  sum(daily_order)  daily_order,
  sum(mtd_order)  mtd_order,
  sum(deliver) deliver,
  sum(target) target,
  sum(deliver_last_year) deliver_last_year,
  sum(est_c3) est_c3,
  sum(est_c3_last_year) est_c3_last_year,
  sum(c3_target ) c3_target   
  from (
-- 今年的数据
select 
  sd, rsm, icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,  --- 层级
${if(len(times)=0 && data_from="OPMIS",0,"sum(carry_over)")} as carry_over,
0 as daily_order,
${if(len(times)=0 && data_from="OPMIS",0,"sum(order_volume)")} as mtd_order,
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
--${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ start_date +"' and '"+ end_date +"'"),"and year = DateName(year,GetDate()) and time_window='"+ times +"'")}
and icam is not null
group by sd,rsm,icam
-- 今天的数据
union all
select 
  sd, rsm, icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,  --- 层级
0 as carry_over,           --- ???
${if(times = 'MTD',"sum(order_volume)",0)} as daily_order,
0 as mtd_order,
0 as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
0 as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM report.[onepage_people_order_delivery_tracking_date]A
where 1 = 1
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
--${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
and icam is not null
and date = (select max(date) FROM report.[onepage_people_order_delivery_tracking_date]A)
group by sd,rsm,icam
union all 
-- 去年的数据
select 
  sd, rsm, icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,  --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                  
0 as deliver,              
0 as target,                    
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver_last_year,          
0 as est_c3,                   
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3_last_year,    
0 as c3_target         
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
--${if(len(icam)=0,"","and icam in(N'"+ icam +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ MONTHDELTA(start_date,-12) +"' and '"+ MONTHDELTA(end_date,-12) +"'"),"and year = DateName(year,GetDate())-1 and time_window='"+ times +"'")}
and icam is not null
group by sd,rsm,icam
)a group  by sd,rsm,icam)data1
left  join
(
-- 今年目标值
select 
null as sd,null as rsm,name as icam,null as distributor,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                
0 as deliver,              
sum(volume_target) as target,                    
0 as deliver_last_year,          
0 as est_c3,                   
0 as est_c3_last_year,    
sum(c3_target) as c3_target         
FROM report.onepage_all_target
where 1 = 1
${if(len(p3)=0,if(len(p4)=0,"and flag='oil_level_year'","and flag='dpf1_group_year'"),"and flag='dpf1_year'")}
${if(len(times)=0,
if(data_from = "OPMIS",if(left(start_month,4)=left(end_month,4),"and year = '"+left(start_month,4)+"'","and 1=2"),if(left(start_date,4)=left(end_date,4)," and year = '"+left(start_date,4)+"'","and 1=2")),"and year = DateName(year,GetDate()) ")}
${if(len(p3)=0,if(len(p1)=0,"and oil_type='Total'","and oil_type='"+p1+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p2)=0,"and oil_level='Total'","and oil_level='"+p2+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p4)=0,"","and dpf1 in('"+p4+"')"),"")}
and position='ICAM'
group by name) b  on data1.icam=b.icam
where 1=1
and data1.sd in(
SELECT distinCt  sd
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
and data1.rsm in(
SELECT distinCt  rsm
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
group by data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status
order by case when data1.sd = N'杨磊' then 1
              when data1.sd = N'沈蜜苗' then 2
              when data1.sd = N'殷婕' then 3
              when data1.sd = N'李海' then 4
              when data1.sd = N'李刚' then 5
              else 6
               end

select 
data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status,   --- 层级
sum(data1.carry_over) as carry_over,           --- ???
sum(data1.daily_order) as daily_order,
sum(data1.mtd_order) as mtd_order,
sum(data1.deliver) as deliver,         --- 销量
sum(b.target) as target,                             --- 目标值
sum(data1.deliver_last_year) as deliver_last_year,                  --- 去年销量
sum(data1.est_c3) as est_c3,              --- 利润
sum(data1.est_c3_last_year) as est_c3_last_year,                   --- 去年利润
sum(b.c3_target) as c3_target 
FROM
(
select  
  sd, rsm,null as icam,null as distributor_code, null as distributor,null as distributor_type,null as distributor_status,
  sum(carry_over)  carry_over,
  sum(daily_order)  daily_order,
  sum(mtd_order)  mtd_order,
  sum(deliver) deliver,
  sum(target) target,
  sum(deliver_last_year) deliver_last_year,
  sum(est_c3) est_c3,
  sum(est_c3_last_year) est_c3_last_year,
  sum(c3_target ) c3_target   
  from (
-- 今年的数据
select 
sd, rsm,null as icam,null as distributor_code, null as distributor,null as distributor_type,null as distributor_status,  --- 层级
${if(len(times)=0 && data_from="OPMIS",0,"sum(carry_over)")} as carry_over,
0 as daily_order,
${if(len(times)=0 && data_from="OPMIS",0,"sum(order_volume)")} as mtd_order,
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
--${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ start_date +"' and '"+ end_date +"'"),"and year = DateName(year,GetDate()) and time_window='"+ times +"'")}
group by sd,rsm
-- 今天的数据
union all
select 
sd, rsm,null as icam,null as distributor_code, null as distributor,null as distributor_type,null as distributor_status, --- 层级
0 as carry_over,           --- ???
${if(times = 'MTD',"sum(order_volume)",0)} as daily_order,
0 as mtd_order,
0 as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
0 as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM report.[onepage_people_order_delivery_tracking_date]A
where 1 = 1
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
--${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
and date = (select max(date) FROM report.[onepage_people_order_delivery_tracking_date]A)
group by sd,rsm
union all 
-- 去年的数据
select 
sd, rsm,null as icam,null as distributor_code, null as distributor,null as distributor_type,null as distributor_status, --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                  
0 as deliver,              
0 as target,                    
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver_last_year,          
0 as est_c3,                   
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3_last_year,    
0 as c3_target         
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
--${if(len(rsm)=0,"","and rsm in(N'"+ rsm +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ MONTHDELTA(start_date,-12) +"' and '"+ MONTHDELTA(end_date,-12) +"'"),"and year = DateName(year,GetDate())-1 and time_window='"+ times +"'")}
group by sd,rsm
)a group  by sd,rsm)data1  
left  join
(
-- 今年目标值
select 
null  sd,name  as rsm,null as icam,null as distributor,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                
0 as deliver,              
sum(volume_target) as target,                    
0 as deliver_last_year,          
0 as est_c3,                   
0 as est_c3_last_year,    
sum(c3_target) as c3_target         
FROM report.onepage_all_target
where 1 = 1
${if(len(p3)=0,if(len(p4)=0,"and flag='oil_level_year'","and flag='dpf1_group_year'"),"and flag='dpf1_year'")}
${if(len(times)=0,
if(data_from = "OPMIS",if(left(start_month,4)=left(end_month,4),"and year = '"+left(start_month,4)+"'","and 1=2"),if(left(start_date,4)=left(end_date,4)," and year = '"+left(start_date,4)+"'","and 1=2")),"and year = DateName(year,GetDate()) ")}
${if(len(p3)=0,if(len(p1)=0,"and oil_type='Total'","and oil_type='"+p1+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p2)=0,"and oil_level='Total'","and oil_level='"+p2+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p4)=0,"","and dpf1 in('"+p4+"')"),"")}
and position='RSM'
group by name) b  on data1.rsm=b.rsm
where 1=1
and data1.sd in(
SELECT distinCt  sd
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
and data1.rsm in(
SELECT distinCt  rsm
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='RSM',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")})
 group by data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status
order by case when data1.sd = N'杨磊' then 1
              when data1.sd = N'沈蜜苗' then 2
              when data1.sd = N'殷婕' then 3
              when data1.sd = N'李海' then 4
              when data1.sd = N'李刚' then 5
              else 6
               end

select 
data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status,   --- 层级
sum(data1.carry_over) as carry_over,           --- ???
sum(data1.daily_order) as daily_order,
sum(data1.mtd_order) as mtd_order,
sum(data1.deliver) as deliver,         --- 销量
sum(b.target) as target,                             --- 目标值
sum(data1.deliver_last_year) as deliver_last_year,                  --- 去年销量
sum(data1.est_c3) as est_c3,              --- 利润
sum(data1.est_c3_last_year) as est_c3_last_year,                   --- 去年利润
sum(b.c3_target) as c3_target 
FROM
(
select  
  sd,null as rsm,null as icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,
  sum(carry_over)  carry_over,
  sum(daily_order)  daily_order,
  sum(mtd_order)  mtd_order,
  sum(deliver) deliver,
  sum(target) target,
  sum(deliver_last_year) deliver_last_year,
  sum(est_c3) est_c3,
  sum(est_c3_last_year) est_c3_last_year,
  sum(c3_target ) c3_target   
  from (
-- 今年的数据
select 
sd,null as rsm,null as icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status, --- 层级
${if(len(times)=0 && data_from="OPMIS",0,"sum(carry_over)")} as carry_over,
0 as daily_order,
${if(len(times)=0 && data_from="OPMIS",0,"sum(order_volume)")} as mtd_order,
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
--${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ start_date +"' and '"+ end_date +"'"),"and year = DateName(year,GetDate()) and time_window='"+ times +"'")}
group by sd
-- 今天的数据
union all
select 
sd,null as rsm,null as icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,  --- 层级
0 as carry_over,           --- ???
${if(times = 'MTD',"sum(order_volume)",0)} as daily_order,
0 as mtd_order,
0 as deliver,         --- 销量
0 as target,                             --- 目标值
0 as deliver_last_year,                  --- 去年销量
0 as est_c3,              --- 利润
0 as est_c3_last_year,                   --- 去年利润
0 as c3_target                           --- 目标利润
FROM report.[onepage_people_order_delivery_tracking_date]A
where 1 = 1
--${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
and date = (select max(date) FROM report.[onepage_people_order_delivery_tracking_date]A)
group by sd
union all 
-- 去年的数据
select 
sd,null as rsm,null as icam,null as distributor_code,null as distributor,null as  distributor_type,null as distributor_status,  --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                  
0 as deliver,              
0 as target,                    
${if(len(times)=0 && data_from <> "OPMIS","sum(delivery_volume)","sum(volume)")} as deliver_last_year,          
0 as est_c3,                   
${if(len(times)=0 && data_from <> "OPMIS","sum(estimate_c3)","sum(c3)")} as est_c3_last_year,    
0 as c3_target         
FROM 
${if(len(times)=0,if(data_from = "OPMIS","report.[onepage_overview_monthly_tracking]A","report.[onepage_people_order_delivery_tracking_date]A"),"report.[onepage_people_order_delivery_tracking_volume]A")}
where 1 = 1
and data_source='${data_from}'
--${if(len(sd)=0,"","and sd in(N'"+ sd +"')")}
${if(len(p1)=0,"","and product_filter_group='"+p1+"'")}
${if(len(p2)=0,"","and oil_type='"+p2+"'")}
${if(len(p3)=0,"","and sub_type in('"+p3+"')")}
${if(len(p4)=0,"","and dpf1_group in('"+p4+"')")}
${if(len(times)=0,
if(data_from = "OPMIS","and concat(year,'-',right(month*1001,2)) between '"+ start_month +"' and '"+ end_month +"'","and date between '"+ MONTHDELTA(start_date,-12) +"' and '"+ MONTHDELTA(end_date,-12) +"'"),"and year = DateName(year,GetDate())-1 and time_window='"+ times +"'")}
group by sd
)a group  by sd)data1
left  join
(
-- 今年目标值
select 
name as sd,null as rsm,null as icam,null as distributor,   --- 层级
0 as carry_over,        
0 as daily_order,
0 as mtd_order,                
0 as deliver,              
sum(volume_target) as target,                    
0 as deliver_last_year,          
0 as est_c3,                   
0 as est_c3_last_year,    
sum(c3_target) as c3_target         
FROM report.onepage_all_target
where 1 = 1
${if(len(p3)=0,if(len(p4)=0,"and flag='oil_level_year'","and flag='dpf1_group_year'"),"and flag='dpf1_year'")}
${if(len(times)=0,
if(data_from = "OPMIS",if(left(start_month,4)=left(end_month,4),"and year = '"+left(start_month,4)+"'","and 1=2"),if(left(start_date,4)=left(end_date,4)," and year = '"+left(start_date,4)+"'","and 1=2")),"and year = DateName(year,GetDate()) ")}
${if(len(p3)=0,if(len(p1)=0,"and oil_type='Total'","and oil_type='"+p1+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p2)=0,"and oil_level='Total'","and oil_level='"+p2+"'"),"and dpf1 in('"+p3+"')")}
${if(len(p3)=0,if(len(p4)=0,"","and dpf1 in('"+p4+"')"),"")}
and position='SD'
group by name) b  on data1.sd=b.sd
where 1=1
and data1.sd in(
SELECT distinCt  sd
 FROM report.[onepage_people_order_delivery_tracking_volume]A
 where 1=1
 ${if(or(u_role='ADMIN',login='admin',u_role='SD',fine_role='ADMIN'),"","and "+u_role+"=N'"+u_name+"'")}
)
group by data1.sd,data1.rsm,data1.icam,data1.distributor_code,data1.distributor,data1.distributor_type,data1.distributor_status
order by case when data1.sd = N'杨磊' then 1
              when data1.sd = N'沈蜜苗' then 2
              when data1.sd = N'殷婕' then 3
              when data1.sd = N'李海' then 4
              when data1.sd = N'李刚' then 5
              else 6
               end

