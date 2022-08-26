  with cc as (  
select cust_id,qty_sold,amt,case  when qty_sold/soldnum>100 then '100条以上' 
when  qty_sold/soldnum>90 and qty_sold/soldnum<=100 then '91-100条'
when qty_sold/soldnum>80 and qty_sold/soldnum<=90 then '81-90条'
when qty_sold/soldnum>70 and qty_sold/soldnum<=80 then  '71-80条'
when qty_sold/soldnum>60 and qty_sold/soldnum<=70 then  '61-70条'
when qty_sold/soldnum>50 and qty_sold/soldnum<=60 then '51-60条'
when qty_sold/soldnum>40 and qty_sold/soldnum<=50 then  '41-50条'
when qty_sold/soldnum>30 and qty_sold/soldnum<=40 then '31-40条'
when qty_sold/soldnum>20 and qty_sold/soldnum<=30 then  '21-30条'
when qty_sold/soldnum>15 and qty_sold/soldnum<=20 then  '16-20条'
when qty_sold/soldnum>10 and qty_sold/soldnum<=15 then  '11-15条'
when qty_sold/soldnum>5 and qty_sold/soldnum<=10 then  '6-10条'
when  qty_sold/soldnum<=5 then  '5条以下' end as mydh
from 
(
select * from cust_month2019  where date1='${date1}'
union 
select * from cust_month2018  where date1='${date1}'
)
  ) 
select  cc.mydh,
cust_type3, count(1) cusths,sum(qty_sold) qty,sum(amt) amt  
from cust c,  cc where c.cust_id=cc.cust_id 
 
${if(len(dptid)==0,""," and dpt_sale_id='"+dptid+"'")}
 
group by mydh, cust_type3 

