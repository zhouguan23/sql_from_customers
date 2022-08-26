
with cc as (
select i.kind,sale_dept_id,round(sum(qty_sold_month*t_size)/50000,1) qty from
pi_dept_item_day  a,plm_item i 
where date1=(select max(date1) from pi_dept_item_day)   and a.item_id=i.item_id 
 group by i.kind,sale_dept_id)

 select dp.short_name ,  
 sum(decode(kind,1,qty))  kind1,
 sum(decode(kind,2,qty))  kind2,
 sum(decode(kind,3,qty))  kind3,
 sum(decode(kind,4,qty))  kind4,
 sum( case when kind>=5 then qty end )  kind5 from dpt_sale dp left join
 cc on dp.dpt_sale_id=cc.sale_dept_id group by dp.short_name 
 

with cc as (
select i.kind,sale_dept_id,round(sum(qty_sold_year*t_size)/50000,0) qty from
pi_dept_item_day  a,plm_item i 
where date1=(select max(date1) from pi_dept_item_day)   and a.item_id=i.item_id 
 group by i.kind,sale_dept_id)

 select dp.short_name ,  
 sum(decode(kind,1,qty))  kind1,
 sum(decode(kind,2,qty))  kind2,
 sum(decode(kind,3,qty))  kind3,
 sum(decode(kind,4,qty))  kind4,
 sum( case when kind>=5 then qty end )  kind5 from dpt_sale dp left join
 cc on dp.dpt_sale_id=cc.sale_dept_id group by dp.short_name 

