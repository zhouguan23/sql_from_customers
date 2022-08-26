
select  sale_dept_id,count(1) qtyno from csc_cust_orderdate a,co_cust c
where  a.cust_id=c.cust_id and a.call_date=(select to_char(sysdate,'yyyyMMdd') from dual)
and c.cust_id not in (Select cust_id from co_co where born_date=(select to_char(sysdate,'yyyyMMdd') from dual)  and status<>'90')
and c.status='02' group by sale_dept_id 


select  sale_dept_id,count(1) qtyall  from csc_cust_orderdate a,co_cust c
where  a.cust_id=c.cust_id and a.call_date=(select to_char(sysdate,'yyyyMMdd') from dual)
and c.status='02' group by sale_dept_id

