

select  sale_dept_id,count(1) qtyno from  co_cust 
where   cust_id  in (
select  cust_id from co_cust where status='02' minus
select distinct cust_id from cust_sold where date1>='${date1}' and date1<='${date2}')
and  status='02' group by sale_dept_id

select sale_dept_id,count(1) qtyall from co_cust where status='02' group by sale_dept_id

