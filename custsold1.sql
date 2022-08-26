select soldkind ,dpt_sale_id,count(distinct cust_id) hsb,sum(qty_sold)/250 qtyb from cust_sold
where date1>='${date1}' and date1<='${date2}' group by soldkind ,dpt_sale_id order by soldkind asc


select soldkind, dpt_sale_id,count(distinct cust_id) hss,sum(qty_sold)/250 qtys from cust_sold
where 
date1>=(select to_char( to_date('${date1}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)   and date1<=(select to_char( to_date('${date2}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)  
 group by  soldkind, dpt_sale_id order by soldkind asc

select soldkind ,dpt_sale_id,count(distinct cust_id) hst,sum(qty_sold)/250 qtyt from cust_sold
where    
date1>=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM')  from dual)   
and date1<=(select to_char(add_months(to_date('${date2}','yyyyMM'),-12),'yyyyMM')  from dual)

group by soldkind ,dpt_sale_id 

