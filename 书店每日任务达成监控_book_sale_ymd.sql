select a.类型,sum(a.实际完成)/10000 as 实际完成,sum(a.计划完成)/10000 as 计划完成,统计类型 from (
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'营收' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡','纯零售实洋') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'提货' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('提货实洋') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'售卡' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,revenue as 计划完成,station_code,'营收' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,purchase as 计划完成,station_code,'提货' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,selling_cards as 计划完成,station_code,'售卡' as 类型,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')


union all


select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'营收' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡','纯零售实洋') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'提货' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('提货实洋', '纯零售实洋') and  create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'售卡' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,revenue as 计划完成,station_code,'营收' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,purchase as 计划完成,station_code,'提货' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select DATE,'' as 实际完成,selling_cards as 计划完成,station_code,'售卡' as 类型,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_month as a inner join cn_sisyphe_dds.Finance_view as b on a.create_year_month=b.fina_date where a.create_year_month = (select fina_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
)a inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where  1=1
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and a.统计类型='${统计类型}'
group by a.类型,统计类型

select distinct b.区域名称 from cn_sisyphe_dwd.book_sale_monitor_date a
inner join cn_sisyphe_dds.dds_station_view b on a.station_code=b.新系统站点ID
WHERE 
b.新系统站点名称 in(select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
ORDER BY CONVERT(b.区域名称 USING GBK) ASC

select distinct a.station_name from cn_sisyphe_dwd.book_sale_monitor_date a
inner join cn_sisyphe_dds.dds_station_view b on a.station_code=b.新系统站点ID
where 1=1 
${if(len(区域名称) == 0,"","and 区域名称 in ('" + 区域名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}') and a.station_name not like '%咖啡%'
ORDER BY CONVERT(a.station_name USING GBK) ASC

select a.类型,sum(a.实际完成)/10000 as 实际完成,sum(a.计划完成)/10000 as 计划完成 from (
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'营收' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡','纯零售实洋') and create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'提货' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('提货实洋', '纯零售实洋') and create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'售卡' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡') and create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,revenue as 计划完成,station_code,'营收' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,purchase as 计划完成,station_code,'提货' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,selling_cards as 计划完成,station_code,'售卡' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time = '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')

)a inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
group by a.类型

select count(station_code) as 门店数量,统计类型,类型 from (
select distinct '营收' as 类型,station_code,user_code,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where revenue>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select distinct '营收' as 类型,station_code,user_code,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where revenue>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')

union all
select distinct '提货' as 类型,station_code,user_code,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where purchase>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select distinct '提货' as 类型,station_code,user_code,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where purchase>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')

union all
select distinct '售卡' as 类型,station_code,user_code,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where selling_cards>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select distinct '售卡' as 类型,station_code,user_code,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_dwd.book_sale_monitor_date a
where selling_cards>0 and a.create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
)a inner join cn_sisyphe_dds.dds_station_view b on a.station_code=b.新系统站点ID
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
where 1=1
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and 统计类型='${统计类型}'
group by 统计类型,类型


select a.类型,sum(a.实际完成)/10000 as 实际完成,sum(a.计划完成)/10000 as 计划完成 from (
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'营收' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡','纯零售实洋') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and  '${日期}'
  and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'提货' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('提货实洋', '纯零售实洋') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
  and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,pay_money as 实际完成,'' as 计划完成,station_code,'售卡' as 类型 from cn_sisyphe_dws.book_sale_Monitor where type in('售卡') and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and  '${日期}'
  and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,revenue as 计划完成,station_code,'营收' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and  '${日期}'
  and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,purchase as 计划完成,station_code,'提货' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
  and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
union all
select create_time,'' as 实际完成,selling_cards as 计划完成,station_code,'售卡' as 类型 from cn_sisyphe_dwd.book_sale_monitor_date where create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID where start_time<='${日期}' and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')

)a inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
group by a.类型

select sum(累计天数)/sum(计划天数) as 本月时间进度 from (
select count(*) as 累计天数,'' as  计划天数 from cn_sisyphe_dds.Finance_view where DATE
between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and '${日期}'
union all
select '' as  累计天数,count(*) as 计划天数 from cn_sisyphe_dds.Finance_view where DATE
between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
)a

select type as 类型,sum(real_money)/10000 as 当日完成,sum(task_money)/10000 as 当日任务 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
and create_time='${日期}'
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in  (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
group by type
order by type

select * from (
select type as 类型,sum(real_money)/10000 as 当月截止目前实际完成,sum(task_money)/10000 as 当月截止目前计划完成,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and  '${日期}'
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and a.station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
group by type


union all

select type as 类型,sum(real_money)/10000 as 当月截止目前实际完成,sum(task_money)/10000 as 当月截止目前计划完成,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and  '${日期}'
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
group by type
    )a where 统计类型='${统计类型}'

select * from (
select type as 类型,sum(task_money)/10000 as 当月任务,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1 and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')  and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
group by type

union all

select type as 类型,sum(task_money)/10000 as 当月任务,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor  as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1 and  create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and (select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
group by type
)a where a.统计类型='${统计类型}'

select '不二' as 类别
union all
select '少儿' as 类别
union all
select '其他' as 类别

select * from (
select type as 类型,sum(real_money)/10000 as 当月实际完成,'按当前财务月已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and '${日期}'
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and a.station_code in (select new_station_code station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time<=(select end_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
group by type


union all


select type as 类型,sum(real_money)/10000 as 当月实际完成,'按当前日期已开门店统计' as 统计类型 from cn_sisyphe_edw.category_sale_Monitor as a
inner join cn_sisyphe_dds.dds_station_view as b on a.station_code=b.新系统站点ID
where 1=1
and create_time between (select begin_date from cn_sisyphe_dds.Finance_view where DATE='${日期}') and '${日期}'
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(门店名称) == 0,"","and b.新系统站点名称 in ('" + 门店名称 + "')")}
and b.新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
and station_code in (select new_station_code as station_code from cn_sisyphe_dds.dds_station a inner join cn_sisyphe_dds.dds_station_view b on a.new_station_code=b.新系统站点ID
where start_time <= '${日期}'  and end_time is null and b.新系统站点名称 like '%书店%'  and b.新系统站点名称 not like '%总部%')
group by type
)a where 统计类型 = '${统计类型}'

