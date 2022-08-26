
select c.sale_dept_id dpt_sale_id, count(distinct co_num) countcust from
  co_trans_flow  a,co_cust c 
   where a.cust_id=c.cust_id   and c.status='02' 
and trade_date>='${starttime}'
and trade_date<='${endtime}'
 
group by  c.sale_dept_id 


select dpt_sale_id, count(1) countcust from
(select  distinct c.cust_id,c.sale_dept_id dpt_sale_id,trade_date from  co_trans_flow  a,co_cust c 
   where a.cust_id=c.cust_id    and c.status='02' 
and trade_date>='${starttime}'
and trade_date<='${endtime}' and trade_flag=0
 )
group by dpt_sale_id


select sale_dept_id dpt_sale_id,count(co_num) liansuo from 
 co_co  where born_date>='${starttime}' and born_date<='${endtime}' and  status in ('30','40','50','60','09','04')
and  cust_id in 
(
select cust_id from hzdjcust
) group by sale_dept_id

