select b.cust_seg,cust_type3,sale_dept_id,count(1) hus from co_cust c,custsegmonth b
where status='02' and c.cust_id=b.cust_id and b.date1='${date1}'
and b.cust_seg<>'ZZ'
group by b.cust_seg,cust_type3,sale_dept_id order by b.cust_seg desc


select cust_seg,cust_type3,sale_dept_id,sum(hdkd) dhkd ,sum(hdcs) cs from co_cust c,custdhkd b
 where   cust_seg<>'ZZ' and c.cust_id=b.cust_id and b.date1='${date1}' and c.status='02'
group by cust_seg,cust_type3,sale_dept_id 

