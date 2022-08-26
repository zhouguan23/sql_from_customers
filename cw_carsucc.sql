with cc as (
select distinct cust_id from co_trans_flow where trade_date='${date1}' and trade_flag=0 
union 
select cust_id from hzdjcust  
)

select car_id,car_name , sum(amt_sold) amtsucc
 from pi_cust_item_bnd_day c,cc ,ldm_dist_car lc,ldm_cust_dist ld
 
 where   c.date1='${date1}' 
 and c.cust_id=cc.cust_id  and c.cust_id=ld.cust_id and ld.rut_id=lc.region_id
 and lc.deliver_id='${dpt}' group by car_id,car_name


select car_id,car_name , sum(amt_sold) amtall
 from pi_cust_item_bnd_day c, ldm_dist_car lc,ldm_cust_dist ld
 
 where   c.date1='${date1}' 
 and   c.cust_id=ld.cust_id and ld.rut_id=lc.region_id
 and lc.deliver_id='${dpt}' group by car_id,car_name
 order by car_id

