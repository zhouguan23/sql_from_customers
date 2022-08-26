select qty,amt,dxamt,custy,custn from  
(
select  count(1) custy from csc_cust_orderdate a,co_cust c
 where  a.cust_id=c.cust_id and call_date=to_char(sysdate,'yyyyMmdd')
 and c.slsman_id='${slsmanid}' and c.status='02'
) a,
(
 select   count(distinct c.co_num) custn,round(sum(cl.qty_ord*t_size)/50000,2) qty,
 round(sum(cl.amt),0) amt,round(sum(cl.amt)*50000/sum(cl.qty_ord*t_size),0) dxamt from co_co c,co_co_line cl,plm_item i  
 where  c.co_num=cl.co_num and cl.item_id=i.item_id   and c.status<>'90' and c.born_date=to_char(sysdate,'yyyyMmdd')
   and c.slsman_id='${slsmanid}'
 ) b 


 select substr(c.cust_id,5,9) cust_id,cust_short_name cust_name,busi_addr,case domain_id when 'HZ001' then '电访' else '网订' end as dhfs,
 order_tel from co_cust c ,csc_cust  a where  a.cust_id=c.cust_id and c.status='02' and slsman_id='${slsmanid}'
 and c.cust_id in 
 (select cust_id from csc_cust_orderdate where call_date=to_char(sysdate,'yyyyMmdd')
 minus
 select cust_id from co_co where born_date=to_char(sysdate,'yyyyMmdd') and slsman_id='${slsmanid}'
 )

select slsman_id, note from slsman  where dpt_sale_id='${dptid}'

