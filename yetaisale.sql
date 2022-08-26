select c.sale_dept_id,
case when base_type is null then 'W'  else base_type end as base_type ,
sum(a.qty_sold)/250 qty,sum(a.amt) amt
 from  co_cust c,cust_sold a
where c.cust_id=a.cust_id 
and a.date1>='${date1}' and a.date1<='${date2}' group by c.sale_dept_id,c.base_type

select c.sale_dept_id,

case when base_type is null then 'W' else base_type end as base_type ,
sum(a.qty_sold)/250 qtys,sum(a.amt) amts
 from  co_cust c,cust_sold a

where c.cust_id=a.cust_id  
and  a.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'YYYYMM') FROM DUAL)
and a.date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMM'),-12),'YYYYMM') FROM DUAL) group by c.sale_dept_id,c.base_type

select sale_dept_id,case when base_type is null then 'W' else base_type end as base_type ,count(1) custnum 
 
 from co_cust where status='02'  
  group by  sale_dept_id,base_type 

select case when base_type is null then 'W' else base_type end as base_type from 
(
select distinct base_type  from co_cust where status='02')

