select distinct area_name , area_code from dim_region
where area_code in ('15','16','32','31','36','37','70','71','72','73','74','75'
,'51','52','53','62','63','64','65','66','67')
and  type='OFFLINE' and area_name is not null
${if(len(AREA)=0,""," and AREA_NAME in ('"+AREA+"')")}
order by 2

select ddate from DIM_DAY
where ddate >= date '${AFTER1}'
      AND ddate <= date '${AFTER2}'
      order by 1 desc

select count(1) num, a.area_code ，sale_date
  from offline_ods_sale a 
 where sale_date between date '${AFTER1}' and date
'${AFTER2}'
 group by a.area_code, sale_date

select count(1) num, a.area_code ，sale_date
  from offline_ods_sale_oto a 
 where sale_date between date '${AFTER1}' and date
'${AFTER2}'
 group by a.area_code, sale_date


 
select count(1) num, a.area_code ，sale_date
  from offline_ods_delivery a
 where sale_date between date '${AFTER1}' and date
 '${AFTER2}'
 group by a.area_code, sale_date


select count(1) num, area_code ，order_date
  from offline_ods_purchase a
 where order_date between date '${AFTER1}' and date
'${AFTER2}'
 group by area_code, order_date

select count(1) num, a.area_code ，ddate
  from offline_ods_stock_general a 
 where ddate between date'${AFTER1}' and date
 '${AFTER2}'
 group by a.area_code, ddate


select count(1) num, a.area_code ，ddate
  from offline_ods_stock_shop a 
 where ddate between date'${AFTER1}' and date
 '${AFTER2}'
 group by a.area_code, ddate

select a.area_code, trunc(a.end_date-1) ddate, max(a.end_date) end_date
  from offline_log a
 where  trunc(a.end_date-1) between date '${AFTER1}' and date
'${AFTER2}'
 group by a.area_code, trunc(a.end_date-1)

select count(1) num, a.area_code  from offline_dim_vip a 
group by a.area_code

