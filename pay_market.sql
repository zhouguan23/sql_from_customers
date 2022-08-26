select cc.sale_dept_id dpt_sale_id,cust_type1,count(1) custtotal from  co_cust cc,co_debit_acc c,
(select distinct  cust_id,trade_date
 from co_trans_flow   where  
trade_date>=(select to_char(to_date('${date1}'-1,'yyyyMMdd'),'yyyyMMdd') from dual) and trade_date<=(select to_char(to_date('${date2}'-1,'yyyyMMdd'),'yyyyMMdd') from dual)

) a where cc.cust_id=a.cust_id and cc.status='02' and cc.cust_id=c.cust_id
  group by  cc.sale_dept_id,cust_type1

select cc.sale_dept_id dpt_sale_id,cust_type1,count(1) custtotal from  co_cust cc,co_debit_acc c,
(select distinct  cust_id,trade_date 
 from co_trans_flow  where  trade_date>=(select to_char(to_date('${date1}'-1,'yyyyMMdd'),'yyyyMMdd') from dual) 
and trade_date<=(select to_char(to_date('${date2}'-1,'yyyyMMdd'),'yyyyMMdd') from dual)
and trade_flag=0  

) a where cc.cust_id=a.cust_id and cc.status='02'   and cc.cust_id=c.cust_id
 group by  cc.sale_dept_id ,cust_type1

