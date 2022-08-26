select  qty,amt,dxamt,custy,custn from  
(
select   count(1) custy from csc_cust_orderdate a,co_cust c
 where  a.cust_id=c.cust_id and call_date=(select to_char(sysdate,'yyyyMMdd') from dual)  
 and c.status='02') a,
(
 select   count(distinct c.co_num) custn,round(sum(cl.qty_ord*t_size)/50000,2) qty,
 round(sum(cl.amt)/10000,2) amt,round(sum(cl.amt)*50000/sum(cl.qty_ord*t_size),2) dxamt from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id   and c.status<>'90' and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 
 ) b
 

 select    round(sum(cl.qty_ord*t_size)/50000,2) qty,
 round(sum(cl.amt)*50000/sum(cl.qty_ord*t_size),0) dxamt from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id   and c.status<>'90' and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 

select kind ,round(sum(qty_ord*t_size)/50000,1) qty 
from co_co_line cl,co_co c ,plm_item i  
where cl.co_num=c.co_num and cl.item_id=i.item_id
and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
and c.status<>'90' group by kind order by kind

select item_name,qty from (
select  item_name, round(sum(cl.qty_ord*t_size)/50000,1) qty 
from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id
 and c.status<>'90' and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 group by item_name order by sum(qty_ord) desc 
 ) where rownum<=10



select  a.order_way   as orderway ,count(1) qty
 from csc_cust_orderdate a,co_cust  c where  a.cust_id=c.cust_id and call_date=(select to_char(sysdate,'yyyyMMdd') from dual)  and c.status='02' group by a.order_way



select   c.type  ,count(distinct c.co_num) conum ,round(sum(qty_ord*t_size)/50000,2) qty,
sum(cl.amt) amt
from co_co_line cl,co_co c   ,plm_item i 
where cl.co_num=c.co_num   and cl.item_id=i.item_id 
and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
and c.status<>'90' group by c.type

