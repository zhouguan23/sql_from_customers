select dp.short_name,qty,amt,dxamt,custy,custn from dpt_sale dp,
(
select sale_dept_id, count(1) custy from csc_cust_orderdate a,co_cust c
 where  a.cust_id=c.cust_id and call_date=(select to_char(sysdate,'yyyyMMdd') from dual) group by sale_dept_id
) a,
(
 select c.sale_dept_id, count(distinct c.co_num) custn,round(sum(cl.qty_ord*t_size)/50000,2) qty,
 round(sum(cl.amt)/10000,2) amt,round(sum(cl.amt)*50000/sum(cl.qty_ord*t_size),2) dxamt from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id   and c.status<>'90' and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 group by  c.sale_dept_id
 ) b
 where a.sale_dept_id(+)=dp.dpt_sale_id
 and b.sale_dept_id(+)=dp.dpt_sale_id

 select    round(sum(cl.qty_ord*t_size)/50000,2) qty,
 round(sum(cl.amt)*50000/sum(cl.qty_ord*t_size),0) dxamt from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id   and c.status<>'90' and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 

