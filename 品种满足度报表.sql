       select date as 日期,
       station_region_name as 管理区域,
       new_station_code    as 站点编码,
       new_station_name as 站点名称,
       partition_name as 商品流区位,
       content_field_code  as 内容领域编码,
       territory_name  as 内容领域名称,
       sum(predict_variety_amount) as 预计品种数,
       sum(NORMAL_amount) as 实际品种数,
       sum(zone_size) as 系统区位数,
       abs(sum(NORMAL_amount)-sum(zone_size)) as 品种差额,
       case when sum(NORMAL_amount)-sum(zone_size)=0 then '标准'
            when sum(NORMAL_amount)-sum(zone_size)>0 then '高于标准'
            when sum(NORMAL_amount)-sum(zone_size)<0 then '低于标准'
            else '其他' end as 满足
from cn_sisyphe_edw.edw_zone_inventory_sum_v1
         where 1=1
           and  new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and new_station_code in ('" + 站点编码 + "')")}
             ${if(len(商品流区位) == 0,"","and partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and territory_name  in ('" + 内容领域 + "')")}
             group by
             date,
       new_station_code,
       partition_name,
       content_field_code
having 1=1
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}
       ${if(len(品种差额) == 0,"","and 品种差额 in ('" + 品种差额 + "')")}

select distinct a.logistics_name as 物流区域
from cn_sisyphe_dds.dds_station a
where new_station_code in (select distinct station_code
                    from cn_sisyphe_dds.dds_staff_permissions
                    where staff_code = '${fine_username}')
order by convert(a.station_region_name using gbk)  

select distinct a.station_region_name as 区域名称
from cn_sisyphe_dds.dds_station a
where new_station_code in (select distinct station_code
                    from cn_sisyphe_dds.dds_staff_permissions
                    where staff_code = '${fine_username}')
order by convert(a.station_region_name using gbk)  

select distinct a.new_station_code as station_code
from cn_sisyphe_dds.dds_station a
where new_station_code in (select distinct station_code
                    from cn_sisyphe_dds.dds_staff_permissions
                    where staff_code = '${fine_username}')
and a.category_code = 'BOOKSTORE'                    
${if(len(区域参数) == 0,"","and station_region_name in ('" + 区域参数 + "')")}
${if(len(物流区域) == 0,"","and logistics_name in ('" + 物流区域 + "')")}
order by convert(a.new_station_code using gbk)

select distinct a.new_station_name as station_name
from cn_sisyphe_dds.dds_station a
where new_station_code in (select distinct station_code
                    from cn_sisyphe_dds.dds_staff_permissions
                    where staff_code = '${fine_username}')
and a.category_code = 'BOOKSTORE'                    
${if(len(区域参数) == 0,"","and station_region_name in ('" + 区域参数 + "')")}
${if(len(物流区域) == 0,"","and logistics_name in ('" + 物流区域 + "')")}
order by convert(a.new_station_code using gbk)

select distinct category_name from cn_sisyphe_dds.dds_flow_control_category
order by convert(category_name using gbk)  

select distinct partition_name from cn_sisyphe_dds.dds_new_station_flow_partition
where partition_name like '%A%' or partition_name like '%B%' or partition_name like '%C%'
order by convert(partition_name using gbk)

       select date as 日期,
       station_region_name as 管理区域,
       new_station_code    as 站点编码,
       new_station_name as 站点名称,
       partition_name as 商品流区位,
       sum(predict_variety_amount) as 预计品种数,
       sum(NORMAL_amount) as 实际品种数,
       sum(zone_size) as 系统区位数,
       abs(sum(NORMAL_amount)-sum(zone_size)) as 品种差额,
       case when sum(NORMAL_amount)-sum(zone_size)=0 then '标准'
            when sum(NORMAL_amount)-sum(zone_size)>0 then '高于标准'
            when sum(NORMAL_amount)-sum(zone_size)<0 then '低于标准'
            else '其他' end as 满足
from cn_sisyphe_edw.edw_zone_inventory_sum_v1
         where 1=1
           and  new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and new_station_code in ('" + 站点编码 + "')")}
             ${if(len(商品流区位) == 0,"","and partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and territory_name  in ('" + 内容领域 + "')")}

             group by
             date,
       new_station_code,
       partition_name
       having 1=1
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}
       ${if(len(品种差额) == 0,"","and 品种差额 in ('" + 品种差额 + "')")}

       select date as 日期,
       station_region_name as 管理区域,
       new_station_code    as 站点编码,
       new_station_name as 站点名称,
       content_field_code  as 内容领域编码,
       territory_name  as 内容领域名称,
       sum(predict_variety_amount) as 预计品种数,
       sum(NORMAL_amount) as 实际品种数,
       sum(zone_size) as 系统区位数,
       abs(sum(NORMAL_amount)-sum(zone_size)) as 品种差额,
       case when sum(NORMAL_amount)-sum(zone_size)=0 then '标准'
            when sum(NORMAL_amount)-sum(zone_size)>0 then '高于标准'
            when sum(NORMAL_amount)-sum(zone_size)<0 then '低于标准'
            else '其他' end as 满足
from cn_sisyphe_edw.edw_zone_inventory_sum_v1
         where 1=1
           and  new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and new_station_code in ('" + 站点编码 + "')")}
             ${if(len(商品流区位) == 0,"","and partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and territory_name  in ('" + 内容领域 + "')")}

             group by
             date,
       new_station_code,
       content_field_code
              having 1=1
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}
       ${if(len(品种差额) == 0,"","and 品种差额 in ('" + 品种差额 + "')")}

select 日期,
       管理区域,
       站点编码,
       站点名称,
       内容领域编码,
       内容领域名称,
       sum(正常库存品种数)+sum(在途库存品种数) as 预计品种数,
       sum(正常库存品种数) as 实际品种数,
       sum(系统区位数*b.区位个数) as 系统区位数,
       case when sum(正常库存品种数)-sum(系统区位数*b.区位个数)=0 then '标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)>0 then '高于标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)<0 then '低于标准'
            else '其他' end as 满足

from (
         select a.date                as 日期,
                b.station_region_name as 管理区域,
                b.new_station_code    as 站点编码,
                b.new_station_name    as 站点名称,
                a.category_code       as 内容领域编码,
                a.category_name       as 内容领域名称,
                a.zone_size           as 系统区位数,
                a.collection_name     as 族群,
                count(a.product_code)              as 在途库存品种数,
                ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.category_code,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             count(distinct a.collection_name)              as 在途库存品种数,
             ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.collection_name,
             a.zone_size

         union all

         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(a.product_code)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.NORMAL_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.category_code,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(distinct a.collection_name)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and
             a.NORMAL_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.collection_name,
             a.zone_size
     )a left join
     (
         select a.date,b.new_station_code, a.category_code, a.zone_size, count(distinct a.partition_name) as 区位个数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
         group by
             a.date,
             b.new_station_code,
             a.category_code,
             a.zone_size
     )b on a.日期=b.date and a.站点编码=b.new_station_code and a.内容领域编码=b.category_code and a.系统区位数=b.zone_size
group by
    日期,
    站点编码,
    内容领域编码
having 1=1
    ${if(len(品种差额) == 0,"","and 品种差额 > '" + 品种差额 + "'")}
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}

select 日期,
       管理区域,
       站点编码,
       站点名称,
       内容领域编码,
       内容领域名称,
       商品流区位,
       sum(正常库存品种数)+sum(在途库存品种数) as 预计品种数,
       sum(正常库存品种数) as 实际品种数,
       sum(系统区位数*b.区位个数) as 系统区位数,
       case when sum(正常库存品种数)-sum(系统区位数*b.区位个数)=0 then '标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)>0 then '高于标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)<0 then '低于标准'
            else '其他' end as 满足

from (
         select a.date                as 日期,
                b.station_region_name as 管理区域,
                b.new_station_code    as 站点编码,
                b.new_station_name    as 站点名称,
                a.category_code       as 内容领域编码,
                a.category_name       as 内容领域名称,
                a.partition_name      as 商品流区位,
                a.zone_size           as 系统区位数,
                a.collection_name     as 族群,
                count(a.product_code)              as 在途库存品种数,
                ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.category_code,
             a.partition_name,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             count(distinct a.collection_name)              as 在途库存品种数,
             ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.collection_name,
             a.partition_name,
             a.zone_size

         union all

         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(a.product_code)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.NORMAL_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.category_code,
             a.partition_name,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.category_code       as 内容领域编码,
             a.category_name       as 内容领域名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(distinct a.collection_name)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and
             a.NORMAL_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.collection_name,
             a.partition_name,
             a.zone_size
     )a left join
     (
         select a.date,b.new_station_code, a.category_code, a.zone_size, count(distinct a.partition_name) as 区位个数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
         group by
             a.date,
             b.new_station_code,
             a.category_code,
             a.zone_size
     )b on a.日期=b.date and a.站点编码=b.new_station_code and a.内容领域编码=b.category_code and a.系统区位数=b.zone_size
group by
    a.日期,
    a.站点编码,
    a.内容领域编码,
    a.商品流区位
having 1=1
    ${if(len(品种差额) == 0,"","and 品种差额 > '" + 品种差额 + "'")}
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}

select 日期,
       管理区域,
       站点编码,
       站点名称,
       商品流区位,
       sum(正常库存品种数)+sum(在途库存品种数) as 预计品种数,
       sum(正常库存品种数) as 实际品种数,
       sum(系统区位数*b.区位个数) as 系统区位数,
       case when sum(正常库存品种数)-sum(系统区位数*b.区位个数)=0 then '标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)>0 then '高于标准'
            when sum(正常库存品种数)-sum(系统区位数*b.区位个数)<0 then '低于标准'
            else '其他' end as 满足

from (
         select a.date                as 日期,
                b.station_region_name as 管理区域,
                b.new_station_code    as 站点编码,
                b.new_station_name    as 站点名称,
                a.partition_name      as 商品流区位,
                a.zone_size           as 系统区位数,
                a.collection_name     as 族群,
                count(a.product_code)              as 在途库存品种数,
                ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.partition_name,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             count(distinct a.collection_name)              as 在途库存品种数,
             ''                    as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.ON_STORAGE_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.partition_name,
             a.zone_size

         union all

         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(a.product_code)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and  a.NORMAL_amount > 0 and a.collection_name is null
         group by a.date,
             b.new_station_code,
             a.partition_name,
             a.zone_size
         union all
         select a.date                as 日期,
             b.station_region_name as 管理区域,
             b.new_station_code    as 站点编码,
             b.new_station_name    as 站点名称,
             a.partition_name      as 商品流区位,
             a.zone_size           as 系统区位数,
             a.collection_name     as 族群,
             ''                    as 在途库存品种数,
             count(distinct a.collection_name)              as 正常库存品种数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
             inner join cn_sisyphe_dds.dds_station as b
         on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
             from cn_sisyphe_dds.dds_staff_permissions
             where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
           and
             a.NORMAL_amount > 0 and a.collection_name is not null
         group by a.date,
             b.new_station_code,
             a.partition_name,
             a.zone_size
     )a left join
     (
         select a.date,b.new_station_code, a.category_code, a.zone_size, count(distinct a.partition_name) as 区位个数
         from cn_sisyphe_edw.edw_zone_inventory_sum as a
                  inner join cn_sisyphe_dds.dds_station as b
                             on a.station_code = b.new_station_code
         where 1=1
           and  b.new_station_code in (select distinct station_code
                                       from cn_sisyphe_dds.dds_staff_permissions
                                       where staff_code = '${fine_username}')
             ${if(len(开始日期) == 0,"","and a.date >= '" + 开始日期 + "'")}
             ${if(len(截止日期) == 0,"","and a.date <= '" + 截止日期 + "'")}
             ${if(len(区域参数) == 0,"","and b.station_region_name in ('" + 区域参数 + "')")}
             ${if(len(站点名称) == 0,"","and b.new_station_name in ('" + 站点名称 + "')")}
             ${if(len(站点编码) == 0,"","and b.new_station_code in ('" + 站点编码 + "')")}
             ${if(len(物流区域) == 0,"","and b.logistics_name in ('" + 物流区域 + "')")}
             ${if(len(商品流区位) == 0,"","and a.partition_name in ('" + 商品流区位 + "')")}
             ${if(len(内容领域) == 0,"","and a.category_name in ('" + 内容领域 + "')")}
         group by
             a.date,
             b.new_station_code,
             a.category_code,
             a.zone_size
     )b on a.日期=b.date and a.站点编码=b.new_station_code and a.系统区位数=b.zone_size
group by
    日期,
    站点编码,
    商品流区位
having 1=1
    ${if(len(品种差额) == 0,"","and 品种差额 > '" + 品种差额 + "'")}
       ${if(len(满足) == 0,"","and 满足 in ('" + 满足 + "')")}

SELECT * FROM 销量

