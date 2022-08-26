select dr.car_id,substr(dr.car_name,1,2) dpt,dr.car_name,c.cust_short_name,a.qty_ord,you
from  co_cust c,ldm_dist_car dr,ldm_cust_dist cd,
(
select c.cust_id,cl.qty_ord,
case when cl.qty_ord>=p1 and cl.qty_ord<p2  then P1_1
when cl.qty_ord=p2  then P2_1 
end as you 
from co_co c,co_co_line cl,
( select p1,p2 ,p1_1,P2_1 from promt_policy where item_id='${itemid}' and note=2)
where c.co_num=cl.co_num and cl.item_id='${itemid}'
and c.born_date='${date1}'
and c.status in ('30','50','60','40') and cl.qty_ord>=p1
) a
where a.cust_id=c.cust_id and c.cust_id=cd.cust_id
and cd.rut_id=dr.region_id and car_id like '${carid}%'
and dr.com_id='10371701' order by car_id

select ${date1},dr.car_id,substr(dr.car_name,1,2) dpt,dr.car_name ,qty_ord, you 
from ldm_dist_car dr,ldm_cust_dist cd,
(
select ${date1},c.cust_id,cl.qty_ord,
case when cl.qty_ord>=p1 and cl.qty_ord<p2  then P1_1
when cl.qty_ord=p2  then P2_1 
end as you 
from co_co c,co_co_line cl,
( select p1,p2 ,p1_1,P2_1 from promt_policy where item_id='${itemid}' and note=2)
where c.co_num=cl.co_num and cl.item_id='${itemid}'
and c.born_date='${date1}'
and c.status in ('30','40','50','60') and cl.qty_ord>=p1
) a
where a.cust_id=cd.cust_id
and cd.rut_id=dr.region_id 
and dr.com_id='10371701'  order by dr.car_id

select 
case when p2 is null then  p1||'条-'||p1_note
else  p1||'条-'||p1_note||','||p2||'条-'||p2_note
end policy,expr
 from promt_policy
where item_id='${itemid}'

select item_name from plm_item where item_id='${itemid}'

select a.item_id,a.item_name,p1,p1_note,p2,p2_note from plm_item a,promt_policy b
where a.item_id=b.item_id and b.note=2 and is_use=1

