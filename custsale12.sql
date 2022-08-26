select c.cust_id,cust_short_name,ic.short_id,item_name,kind,pri_wsale,pri_rtl,iss_date,qty_sold,amt_sold,qty_sold*pri_rtl lsamt from 
item_com ic,item i,
(
select cust_id,iss_date,item_id, qty_sold,amt_sold from item_cust_month${years} 
where cust_id='${custid}'  and 
iss_date>=(select to_char(add_months(to_date(to_char(sysdate,'yyyymm'),'yyyymm'),-12),'yyyymm') from dual) 
and iss_date<=(select to_char(sysdate,'yyyymm') from dual)

union all
select cust_id,iss_date,item_id, qty_sold,amt_sold from item_cust_month${years2} 
where cust_id='${custid}'  and 
iss_date>=(select to_char(add_months(to_date(to_char(sysdate,'yyyymm'),'yyyymm'),-12),'yyyymm') from dual) 
 and  iss_date<=(select to_char(sysdate,'yyyymm') from dual)
 ) a,cust c
where a.item_id=i.item_id and a.item_id=ic.item_id and a.cust_id=c.cust_id order by iss_date desc


