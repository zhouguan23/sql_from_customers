
 
 select a.car_id,car_name ,a.custall, b.custsucc from 
 (
 select car_id ,ldc.car_name,count(1)  custall from ldm_dist_car ldc,co_co c,ldm_cust_dist lcd
 where ldc.region_id=lcd.rut_id and lcd.cust_id=c.cust_id and c.status!='90'
 and c.born_date>='${date1}' and c.born_date<='${date2}' and ldc.deliver_id='17040100' group by car_id,ldc.car_name
 ) a,
 (
 select car_id ,count(1)  custsucc from ldm_dist_car ldc,co_co c,ldm_cust_dist lcd
 where ldc.region_id=lcd.rut_id and lcd.cust_id=c.cust_id and c.status!='90' and c.pmt_status='1'
 and c.born_date>='${date1}' and c.born_date<='${date2}' and ldc.deliver_id='17040100' group by car_id ) b where b.car_id(+)=a.car_id
 order by  a.car_id

