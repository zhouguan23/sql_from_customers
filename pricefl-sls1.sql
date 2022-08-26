
select period,  sum(qty) qty from item_com ic,
(
select  i.item_id, sum(qty_sold*t_size)/50000 qty   from item_slsman_month a,plm_item i 
where a.item_id=i.item_id and date1>='${date1}' and date1<='${date2}'  and   a.slsman_id='${slsmanid}'  group by  i.item_id
) a where ic.item_id=a.item_id group by  period 


select  period, sum(qty) qty from item_com ic,
(
select  i.item_id, sum(qty_sold*t_size)/50000 qty   from item_slsman_month  a,plm_item i
where a.item_id=i.item_id and 
date1>=(select to_char( to_date('${date1}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)   and date1<=(select to_char( to_date('${date2}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)  and slsman_id='${slsmanid}'
 group by  i.item_id
) a where ic.item_id=a.item_id group by period  


select period,sum(qty) qtyt  from item_com ic,
(
select  i.item_id,sum(qty_sold*t_size)/50000 qty   from item_slsman_month a,plm_item i 
where a.item_id=i.item_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM')  from dual)   
and date1<=(select to_char(add_months(to_date('${date2}','yyyyMM'),-12),'yyyyMM')  from dual)    and slsman_id='${slsmanid}' group by  i.item_id 
) a where ic.item_id=a.item_id group by period 

select slsman_id,note  from slsman 
where dpt_sale_id='${dptid}'

select distinct period from item_com order by period asc

select note from slsman where slsman_id='${slsmanid}'

