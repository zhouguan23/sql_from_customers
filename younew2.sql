select car_id,substr(dspt,1,2) dpt,dspt,cust_short_name,qty_ord,you
from cust c,dist_car dr,cust_dist cd,
(
select cust_id,qty_ord,
case when qty_ord>=p1 and qty_ord<p2  then P1_1
when qty_ord=p2  then P2_1 
end as you 
from co c,co_line cl,
( select p1,p2 ,p1_1,P2_1 from promt_policy where item_id='${itemid}' and note=2)
where c.co_num=cl.co_num and item_id='${itemid}'
and c.crt_date='${date1}'
and c.status<>'08' and qty_ord>=p1
) a
where a.cust_id=c.cust_id and c.cust_id=cd.cust_id
and cd.region_id=dr.region_id and car_id like '${carid}%'
and dr.com_id='10371701' order by car_id


select ${date1},car_id,substr(dspt,1,2) dpt,dspt ,qty_ord, you from dist_car dr,cust_dist cd,
(
select ${date1},cust_id,qty_ord,
case when qty_ord>=p1 and qty_ord<p2  then P1_1
when qty_ord=p2  then P2_1 
end as you 
from co c,co_line cl,
( select p1,p2 ,p1_1,P2_1 from promt_policy where item_id='${itemid}' and note=2)
where c.co_num=cl.co_num and item_id='${itemid}'
and c.crt_date='${date1}'
and c.status<>'08' and qty_ord>=p1
) a
where a.cust_id=cd.cust_id
and cd.region_id=dr.region_id 
and dr.com_id='10371701'  order by car_id

select a.item_id,a.item_name,p1,p1_note,p2,p2_note from item a,promt_policy b
where a.item_id=b.item_id and b.note=2 and is_use=1

select item_name from promt_policy where item_id='${itemid}'

select 
case when p2 is null then  p1||'条-'||p1_note
else  p1||'条-'||p1_note||','||p2||'条-'||p2_note
end policy
 from promt_policy
where item_id='${itemid}'

select p1,substr(p1_note,1,1) pn1,p2,substr(p2_note,1,1) pn2 from promt_policy where item_id='${itemid}' and is_use=1

