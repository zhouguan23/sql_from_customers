
select dpt_sale_id dptid,sum(qty_sold)/250 qs1 from cust_sold where qty_sold>=50 and qty_sold<100
and date1='${sdate}'
group by dpt_sale_ID


 
select dpt_sale_id dptid,sum(qty_sold)/250 qs2 from cust_sold  
 where date1='${sdate}' 
 and qty_sold>=100 and qty_sold<300
  group by dpt_sale_id

select dpt_sale_id dptid,sum(qty_sold)/250 qs3 from cust_sold  
 where date1='${sdate}' 
 and qty_sold>=300 and qty_sold<500
  group by dpt_sale_id


select dpt_sale_id dptid,sum(qty_sold)/250 qs4 from cust_sold  
 where date1='${sdate}' 
 and qty_sold>=500 and qty_sold<1000
  group by dpt_sale_id

select dpt_sale_id dptid,sum(qty_sold)/250 qs5 from cust_sold  
 where date1='${sdate}' 
 and   qty_sold>=1000
  group by dpt_sale_id


select dpt_Sale_id,sum(qty1)/250 qty1 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}>=50 and sum(qty_sold)/${smonth}<100
) group by dpt_sale_id

select dpt_Sale_id,sum(qty1)/250 qty2 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}>=100 and sum(qty_sold)/${smonth}<300
) group by dpt_sale_id

select dpt_Sale_id,sum(qty1)/250 qty3 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}>=300 and sum(qty_sold)/${smonth}<500
) group by dpt_sale_id

select dpt_Sale_id,sum(qty1)/250 qty4 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}>=500 and sum(qty_sold)/${smonth}<1000
) group by dpt_sale_id

select dpt_Sale_id,sum(qty1)/250 qty5 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}>=1000  
) group by dpt_sale_id


select sale_dept_id,count(1) c1  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold>=50 and a.qty_sold<100 
  and date1='${sdate}' 
  group by sale_dept_id 


 
select c.sale_dept_id  ,count(c.cust_id) c2  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold>=100 and a.qty_sold<300 
  and date1='${sdate}' 
  group by sale_dept_id 

 
select c.sale_dept_id  ,count(c.cust_id) c3  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold>=300 and a.qty_sold<500 
  and date1='${sdate}' 
  group by sale_dept_id 

 
select c.sale_dept_id  ,count(c.cust_id) c4  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold>=500 and a.qty_sold<1000 
  and date1='${sdate}' 
  group by sale_dept_id 

 
select c.sale_dept_id  ,count(c.cust_id) c5  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold>=1000 
  and date1='${sdate}' 
  group by sale_dept_id 

select sale_dept_id,count(1) cc1 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}>=50 and 
sum(a.qty_sold)/${smonth}<100
       ) group by sale_dept_id

select sale_dept_id,count(1) cc2 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}>=100 and 
sum(a.qty_sold)/${smonth}<300
       ) group by sale_dept_id

select sale_dept_id,count(1) cc3 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}>=300 and 
sum(a.qty_sold)/${smonth}<500
       ) group by sale_dept_id

select sale_dept_id,count(1) cc4 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}>=500 and 
sum(a.qty_sold)/${smonth}<1000
       ) group by sale_dept_id

select sale_dept_id,count(1) cc5 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}>=1000  
       ) group by sale_dept_id


select sale_dept_id,count(1) t1 from (
select c.sale_dept_id  ,c.cust_id  from cust_sold a,co_cust c
  where  c.cust_id=a.cust_id and c.status='02'  and  a.qty_sold<50 and date1='${sdate}'
union 
select  sale_dept_id  ,cust_id from co_cust where status='02'
 and cust_id in 
   (select cust_id from co_cust minus select cust_id from cust_sold 
     where    date1='${sdate}')
 ) group by sale_dept_id 

select sale_dept_id,count(1) tt1 from (
select c.sale_dept_id,c.cust_id from cust_sold a,co_cust c
where c.status='02' and c.cust_id=a.cust_id and date1>='${date1}' and date1<='${sdate}'
 group by c.sale_dept_id,c.cust_id having sum(a.qty_sold)/${smonth}<50
 union 
 select sale_dept_id ,cust_id from co_cust where status='02' and cust_id in 
  (select cust_id from co_cust  minus
    select distinct cust_id from cust_sold where date1>='${date1}' and date1<='${sdate}')
    ) a 

 group by sale_dept_id

select dpt_sale_id dptid,sum(qty_sold)/250 n1 from cust_sold where qty_sold<50
and date1='${sdate}'
group by dpt_sale_ID

select dpt_Sale_id,sum(qty1)/250 nn1 from (

select dpt_sale_id ,cust_id,sum(qty_sold) qty1 from cust_sold  
 where    date1>='${date1}' and date1<='${sdate}' 
 group by dpt_sale_id,cust_id having sum(qty_sold)/${smonth}<50
) group by dpt_sale_id

