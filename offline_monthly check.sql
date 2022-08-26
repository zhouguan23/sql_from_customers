select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between  '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select area_code,area_name from dim_region 
where type='OFFLINE' and area_code in ('31','15','16','37','36','70','71','72','73','74','75','62','63','64','65','66','67')
order by 1 

 select sum(no_tax_amount), a.area_code
   from offline_ods_sale a, dim_cus b
  where sale_date between date'${date1}' and date'${date2}'
    and a.area_code = b.area_code
    and a.cus_code = b.cus_code
    and b.attribute = '直营'
  group by a.area_code

 select sum(no_tax_amount), a.area_code
   from offline_ods_delivery a, dim_cus b
  where sale_date between date'${date1}' and date'${date2}'
    and a.area_code = b.area_code
    and a.cus_code = b.cus_code
    and b.attribute = '加盟'
  group by a.area_code

select  sum(no_tax_amount) jmps ,a.AREA_CODE
  from OFFLINE_ODS_DELIVERY a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '10'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

select  sum(no_tax_amount) zyxs , a.area_code
  from offline_ods_sale a, OFFLINE_DIM_SHOP b
 where a.area_code = b.area_code
   and a.cus_code = b.cus_code
   and b.cus_type = '00'
   and a.sale_date between '${date1}' and '${date2}'
   group by a.area_code

