select car_id,substr(car_name,1,2) dpt,car_name dspt,cust_name,cust_short_name,qty_ord
from co_cust c,ldm_dist_car dr,ldm_cust_dist cd,
(
select c.cust_id,cl.qty_ord
from  co_co  c, co_co_line  cl
where c.co_num=cl.co_num and item_id='${itemid}' 
and c.born_date='${date1}'
and c.status in ('30','40','50','60') and cl.qty_ord>=(select p1 from promt_policy where item_id='${itemid}')
) a
where a.cust_id=c.cust_id and c.cust_id=cd.cust_id
and cd.rut_id=dr.region_id  and dr.car_id like '${carid}%'
and dr.com_id='10371701' order by car_id


select dr.car_id,substr(car_name,1,2) dpt,car_name dspt ,qty_ord,trunc(qty_ord/p1) you from ldm_dist_car dr,ldm_cust_dist cd,
(
select c.cust_id,cl.qty_ord  
 from co_co c,co_co_line cl
where c.co_num=cl.co_num and item_id='${itemid}'
and c.born_date='${date1}'
and c.status in ('30','40','50','60') and qty_ord>=(select p1 from promt_policy where item_id='${itemid}')
 ) a,
(select p1 from   promt_policy where item_id='${itemid}')
where a.cust_id=cd.cust_id
and cd.rut_id=dr.region_id 
and dr.com_id='10371701'  order by car_id

select a.item_id,a.item_name,p1,p1_note,p2,p2_note,p3,p3_note from plm_item a,promt_policy b
where a.item_id=b.item_id and b.note=1 and is_use=1

select item_name from plm_item where item_id='${itemid}'

select 
case when p2 is null then  p1||'条 赠'||p1_note
else  p1||'条 赠'||p1_note||','||p2||'条 赠'||p2_note
end policy,expr
 from promt_policy
where item_id='${itemid}'

select p1,p2 from promt_policy where item_id='${itemid}'

