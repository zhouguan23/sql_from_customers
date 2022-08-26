select ic.short_code,item_name,ic.price_trade,(qty*t_size)/50000 qtyb,(qtys*t_size)/50000 qtys, 
nvl((qty*t_size)/50000,0)-nvl((qtys*t_size)/50000,0) cz,ccum,ccums,nvl(ccum,0)-nvl(ccums,0) cz1 from plm_item i ,plm_item_com ic,
(
select item_id,sum(qty_ord) qty ,count(distinct c.cust_id ) ccum
 from  co_co c,co_co_line cl  where qty_ord<>0 and c.co_num=cl.co_num and c.born_date='${date1}'  and c.status<>'90' group by item_id
 ) a,
 (
 select item_id,sum(qty_sold) qtys ,count(distinct cust_id ) ccums
  from  pi_cust_item_bnd_day where qty_sold<>0 and date1=(select to_char(to_date('${date1}','yyyymmdd')-7,'yyyymmdd') from dual)  group by item_id
  ) b,
  (
  select distinct item_id from pi_cust_item_bnd_day 
    where qty_sold<>0 and date1=(select to_char(to_date('${date1}','yyyymmdd')-7,'yyyymmdd') from dual)   
    union select distinct item_id from co_co_line where qty_ord<>0 and  co_num in (select co_num from co_co where born_date='${date1}' and status<>'90')
    ) c
  
  where i.item_id=c.item_id  and i.item_id=ic.item_id and a.item_id(+)=i.item_id and b.item_id(+)=i.item_id order by ic.price_trade desc

