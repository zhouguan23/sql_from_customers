
select period,substr(period,2,10) p1, dpt_sale_id,sum(qty) qty from item_com ic,
(
select  i.item_id,dpt_sale_id,sum(qty_sold*t_size)/50000 qty   from item_dpt_sale_day a,plm_item i 
where a.item_id=i.item_id and date1>='${date1}' and date1<='${date2}'     group by  i.item_id,dpt_sale_id
) a where ic.item_id=a.item_id group by period ,substr(period,2,10),dpt_sale_id order by period asc


select  period, dpt_sale_id, sum(qty) qty from item_com ic,
(
select  i.item_id,dpt_sale_id,sum(qty_sold*t_size)/50000 qty   from item_dpt_sale_day   a,plm_item i
where a.item_id=i.item_id and 
date1>=(select to_char( to_date('${date1}','yyyyMMdd')-(to_date('${date2}','yyyyMMdd')-to_date('${date1}','yyyyMMdd')+1),'yyyyMMdd' ) from dual)   and date1<=(select to_char( to_date('${date2}','yyyyMMdd')-(to_date('${date2}','yyyyMMdd')-to_date('${date1}','yyyyMMdd')+1),'yyyyMMdd' ) from dual)    group by  i.item_id,dpt_sale_id
) a where ic.item_id=a.item_id group by  period,dpt_sale_id


select period,dpt_sale_id,sum(qty) qtyt  from item_com ic,
(
select  i.item_id,dpt_sale_id,sum(qty_sold*t_size)/50000 qty   from item_dpt_sale_day a,plm_item i 
where a.item_id=i.item_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyyMMdd'),-12),'yyyyMMdd')  from dual)   
and date1<=(select to_char(add_months(to_date('${date2}','yyyyMMdd'),-12),'yyyyMMdd')  from dual) 
    group by  i.item_id ,dpt_sale_id
) a where ic.item_id=a.item_id group by period ,dpt_sale_id

select distinct period from item_com order by period asc

