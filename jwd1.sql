select sale_dept_id,dili,sum(qty) qty,sum(amt) amt from (
select c.sale_dept_id,
case when c.cust_type3='011' or c.cust_type3='11' or cust_type3='12'  then 'cq'
when c.cust_type3='012' or c.cust_type3='013' or 
 (cust_type3>='21' and cust_type3<='32')  then 'xz'

when ( cust_type3>='023' and cust_type3<='024') 
 or (c.cust_type3>='41' and  c.cust_type3<='46' )  then 'nc'
 
else    'qt'   end dili,
sum(a.qty_sold)/250 qty,sum(a.amt) amt
 from  co_cust c,cust_sold a 
where c.cust_id=a.cust_id 
and a.date1>='${date1}' and a.date1<='${date2}' group by c.sale_dept_id,c.cust_type3
) group by sale_dept_id,dili

select sale_dept_id,dili,sum(qtys) qtys,sum(amts) amts from (
select c.sale_dept_id,
case when c.cust_type3='011' then 'cq'
when c.cust_type3='012' or c.cust_type3='013'   then 'xz'
when c.cust_type3='11' or c.cust_type3='12' then 'cq'
when c.cust_type3='31' or c.cust_type3='32'  or c.cust_type3='21'   then 'xz'
when c.cust_type3>='41' and  c.cust_type3<='46'   then 'nc'
 when c.cust_type3='023' or c.cust_type3='024'   then 'nc'
else    'qt'   end dili,
sum(a.qty_sold)/250 qtys,sum(a.amt) amts
 from  co_cust c,cust_sold a

where c.cust_id=a.cust_id 
and  a.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'YYYYMM') FROM DUAL)
and a.date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMM'),-12),'YYYYMM') FROM DUAL) group by c.sale_dept_id,c.cust_type3
) group by sale_dept_id,dili

select dept_sale_id,dili,count(1) custnum from 
(
select sale_dept_id dept_sale_id,
case when c.cust_type3='011' or c.cust_type3='11'  then 'cq'
when c.cust_type3='012' or c.cust_type3='013' or 
 (cust_type3>='12' and cust_type3<='32')   then 'xz'

when ( cust_type3>='023' and cust_type3<='024') 
 or (c.cust_type3>='41' and  c.cust_type3<='46' )  then 'nc'
 
else    'qt'   end dili,cust_id
 from co_cust c where status='02'  
) group by  dept_sale_id,dili

 

