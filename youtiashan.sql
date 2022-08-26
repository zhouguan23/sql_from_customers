select car_id,substr(dspt,1,2) dpt,dspt,cust_short_name,qty_ord,you from cust c,dist_car dr,cust_dist cd,
(
select cust_id,qty_ord,trunc(sum(qty_ord)/5) you from co c,co_line cl
where c.co_num=cl.co_num and item_id='6901028150194'
and c.crt_date='${date1}'
and c.status<>'08'
group  by cust_id,qty_ord having trunc(sum(qty_ord)/5)<>0
) a
where a.cust_id=c.cust_id and c.cust_id=cd.cust_id
and cd.region_id=dr.region_id and car_id like '${carid}%'
and dr.com_id='10371701' order by car_id


select car_id,substr(dspt,1,2) dpt,dspt,you from dist_car dr,cust_dist cd,
(
select cust_id,qty_ord,trunc(sum(qty_ord)/5) you from co c,co_line cl
where c.co_num=cl.co_num and item_id='6901028150194'
and c.crt_date='${date1}'
and c.status<>'08'
group  by cust_id,qty_ord having trunc(sum(qty_ord)/5)<>0
) a
where a.cust_id=cd.cust_id
and cd.region_id=dr.region_id 
and dr.com_id='10371701'  order by car_id

