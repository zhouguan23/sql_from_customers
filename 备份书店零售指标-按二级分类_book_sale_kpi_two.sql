select distinct 区域名称 from cn_sisyphe_dds.dds_station_view
where 新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
ORDER BY CONVERT(区域名称 USING GBK) ASC

select distinct 新系统站点名称 from cn_sisyphe_dds.dds_station_view
where 新系统站点名称 like '%书店%'
${if(len(区域名称) == 0,"","and 区域名称 in ('" + 区域名称 + "')")}
and 新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
ORDER BY CONVERT(新系统站点名称 USING GBK) ASC

select 操作类型名称 from cn_sisyphe_dds.操作类型_view
where 类型='零售类型'
ORDER BY CONVERT(操作类型名称 USING GBK) ASC

select a.日期,
       a.区域名称,
       a.新系统站点名称,
       a.新系统站点ID,
       a.零售类型,
       a.是否属于会员,
       a.一级分类,
       a.二级分类,
       sum(in_out_flag) / 客流        as 成交率,
       客流,
       sum(in_out_flag)             as 交易笔数,
       sum(零售数)                     as 零售数,
       sum(零售码洋)                       零售码洋,
       sum(零售实洋)                       零售实洋,
       sum(零售码洋) / sum(in_out_flag) as 码洋客单价,
       sum(零售实洋) / sum(in_out_flag) as 实洋客单价,
       sum(零售数) / sum(in_out_flag)  as 客册数,
       sum(零售码洋) / sum(零售数)         as 码洋册单价,
       sum(零售实洋) / sum(零售数)         as 实洋册单价
from (select date(a.create_time)                    as 日期,
             a.sale_order_code                      as 零售单号,
             a.in_out_flag,
             b.区域名称,
             b.新系统站点名称,
             b.新系统站点ID,
             a.sale_type_name                       as 零售类型,
             a.member_type                          as 是否属于会员,
             d.category_two_name                    as 一级分类,
             d.category_three_name                  as 二级分类,
             sum(c.sale_amount * a.in_out_flag)     as 零售数,
             sum(c.sale_money * a.in_out_flag)      as 零售码洋,
             sum(c.sale_real_money * a.in_out_flag) as 零售实洋,
             info_value                             as 客流
      from cn_sisyphe_dwd.dwd_book_sale_v2_sale_order as a
               inner join cn_sisyphe_dds.dds_station_view as b on a.station_code = b.新系统站点ID
               inner join cn_sisyphe_dwd.dwd_book_sale_v2_sale_order_detail as c on a.sale_order_code = c.sale_order_code
               inner join cn_sisyphe_dds.product d on c.product_code = d.product_code
               inner join cn_sisyphe_dds.passenger_flow e
                          on a.station_code = e.station_code and date(a.create_time) = e.record_date
      where 1 = 1
${if(len(开始日期) == 0,"","and date(a.create_time) >= '" + 开始日期 + "'")}
${if(len(截止日期) == 0,"","and date(a.create_time) <= '" + 截止日期 + "'")}
${if(len(区域名称) == 0,"","and b.区域名称 in ('" + 区域名称 + "')")}
${if(len(站点名称) == 0,"","and b.新系统站点名称 in ('" + 站点名称 + "')")}
${if(len(站点编码) == 0,"","and b.新系统站点ID in ('" + 站点编码 + "')")}
${if(len(零售类型) == 0,"","and a.sale_type_name in ('" + 零售类型 + "')")}
${if(len(是否为会员) == 0,"","and a.member_type in ('" + 是否为会员 + "')")}
${if(len(一级分类) == 0,"","and d.category_two_name in ('" + 一级分类 + "')")}
${if(len(二级分类) == 0,"","and d.category_three_name in ('" + 二级分类 + "')")}
      group by b.新系统站点ID, a.member_type, date(a.create_time), d.category_three_name, a.sale_order_code, a.in_out_flag) a
where a.新系统站点名称 in (select distinct station_name
                    from cn_sisyphe_dds.dds_staff_permissions
                    where staff_code = '${fine_username}')
group by a.日期, a.新系统站点ID, a.零售类型, a.是否属于会员, a.二级分类;


SELECT distinct category_two_name as 一级分类 FROM cn_sisyphe_dds.product
ORDER BY CONVERT(category_two_name USING GBK) ASC

SELECT distinct category_three_name as 二级分类 FROM cn_sisyphe_dds.product
where 1=1
${if(len(一级分类) == 0,"","and category_two_name in ('" + 一级分类 + "')")}
ORDER BY CONVERT(category_three_name USING GBK) ASC

select distinct 新系统站点ID from cn_sisyphe_dds.dds_station_view
where 新系统站点名称 like '%书店%'
${if(len(区域名称) == 0,"","and 区域名称 in ('" + 区域名称 + "')")}
and 新系统站点名称 in (select  distinct station_name  from cn_sisyphe_dds.dds_staff_permissions
where staff_code='${fine_username}')
order by 新系统站点ID

