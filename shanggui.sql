
select dp.dpt_sale_id,dp.short_name,short_id,pri_wsale,item_id,item_name,count(distinct cust_id) qty from dpt_sale dp,
(
select c.dpt_sale_id,c.cust_id,i.item_id,ic.short_id,ic.pri_wsale,item_name,iss_date from item_cust_month${years} a,item i ,cust  c,item_com ic 
where  a.item_id=i.item_id and iss_date>='${time1}'  and iss_date<='${time2}' and a.cust_id=c.cust_id and c.status='02'
and i.item_id in ('${itemid}') and i.item_id=ic.item_id 
group by  c.dpt_sale_id,c.cust_id,i.item_id,ic.short_id,ic.pri_wsale,item_name,iss_date having sum(qty_sold)<>0
)  b  where  dp.dpt_sale_id=b.dpt_sale_id  group by dp.dpt_sale_id,dp.short_name,short_id,pri_wsale,item_id,item_name



select dpt_sale_id,count(1) custnum from  cust where status='02' group by dpt_sale_id

select fact_id,substr(fact_name,1,4) fact_name  
from factory where fact_id in (select distinct factory from item i,item_com ic where i.item_id=ic.item_id and ic.is_mrb=1) and  fact_id in 
(select vend_id from com_vend where com_id='10371701')

order by fact_name 

select ic.item_id,ic.short_id||'-'||item_name  iname  from item i,item_com ic
where i.item_id=ic.item_id and ic.com_id='10371701'
and ic.is_mrb=1 and i.factory in ('${factid}') order by ic.short_id

select dp.dpt_sale_id,dp.short_name,i.item_id,item_name,
case when cust_type2_root='01' then 1
 when cust_type2_root='02' then 2 
 when cust_type2_root='03' then 3
 when cust_type2_root='04' then 4
 when cust_type2_root='05' then 5
 when cust_type2_root='06' then 6
 when cust_type2_root='07' then 7
else 8
end cust_type2_root,count(distinct b.cust_id) qty from dpt_sale dp,cust c,item i,
(
select  cust_id,item_id from item_cust_month${years}
where item_id in ('${itemid}')  and iss_date>='${time1}' and iss_date<='${time2}'
group by  cust_id,item_id having sum(qty_sold)<>0
)  b  where  b.cust_id=c.cust_id   and dp.dpt_sale_id=c.dpt_sale_id 
and c.status='02'  and b.item_id=i.item_id  
group by dp.dpt_sale_id,dp.short_name,i.item_id,item_name,c.cust_type2_root
order by c.cust_type2_root asc

select dpt_sale_id,
case when cust_type2_root='01' then 1
 when cust_type2_root='02' then 2
 when cust_type2_root='03' then 3
 when cust_type2_root='04' then 4
 when cust_type2_root='05' then 5
 when cust_type2_root='06' then 6
 when cust_type2_root='07' then 7
else 8
end cust_type2_root
,count(1) custcm  from cust
where  status='02' group by dpt_sale_id,cust_type2_root order by dpt_sale_id,cust_type2_root  asc

