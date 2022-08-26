select c.cust_id,cust_short_name,busi_addr,dc.car_id,
dc.car_name,cd.rut_id,dr.region_name, 
periods_name periods_id
 from co_cust c,ldm_cust_dist cd,
 ldm_dist_region dr,
 ldm_dist_car dc, 
 csc_cust l,csc_order_periods aa
where c.cust_id=cd.cust_id  and cd.rut_id=dc.region_id
 and c.cust_id=l.cust_id  
and cd.rut_id=dr.region_id and l.periods_id=aa.periods_id
 
and c.status='02' and dr.com_id='10371701' and dc.com_id='10371701'
and  c.sale_dept_id='${dptno}'
 ${if(len(carid)==0,"", " and dc.car_id='"+carid+"'")} 
 ${if(len(custid)==0,""," and c.cust_id='"+custid+"'")} 


