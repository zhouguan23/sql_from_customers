select  ct.sale_dept_id,ct.cust_id,ct.status,length(order_tel) tel,pay_type,domain_id,count(1) qty from  co_cust ct , csc_cust l
where  ct.status<='03'  and ct.sale_dept_id is not null
and l.cust_id(+)=ct.cust_id group by  ct.sale_dept_id,  ct.cust_id,ct.status,order_tel,pay_type,domain_id

select sale_dept_id,sum(custnum) custnum from (
select sale_dept_id,count(1) custnum from co_cust c,co_debit_acc a
 where c.status='02' and c.cust_id=a.cust_id   and c.pay_type='20' and a.status=1
group by sale_dept_id 

union
select sale_dept_id,count(distinct cust_id) custnum from 
(select sale_dept_id,cust_id from co_cust where status='02' and tax_account in ('372901777743705X','372901724812645','91371700056224644Q')
union
select a.sale_dept_id,a.cust_id from hzdjcust a,co_cust c where a.cust_id=c.cust_id and c.status='02'
)
group by sale_dept_id
) group by sale_dept_id

