select soldkind ,count(distinct a.cust_id) hsb,sum(a.qty_sold)/250 qtyb from cust_sold a,co_cust cc
where
 a.cust_id=cc.cust_id and cc.slsman_id='${slsmanid}' and  date1>='${date1}' and date1<='${date2}' group by soldkind   


select soldkind ,count(distinct a.cust_id) hss,sum(a.qty_sold)/250 qtys from cust_sold a,co_cust cc
where  a.cust_id=cc.cust_id and 
date1>=(select to_char( to_date('${date1}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)   and date1<=(select to_char( to_date('${date2}','yyyyMM')-(to_date('${date2}','yyyyMM')-to_date('${date1}','yyyyMM')+1),'yyyyMM' ) from dual)   and cc.slsman_id='${slsmanid}'
 group by  soldkind 

select soldkind ,count(distinct a.cust_id) hst,sum(a.qty_sold)/250 qtyt from cust_sold a,co_cust cc
where a.cust_id=cc.cust_id and 
date1>=(select to_char(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM')  from dual)   
and date1<=(select to_char(add_months(to_date('${date2}','yyyyMM'),-12),'yyyyMM')  from dual)
and slsman_id='${slsmanid}'
group by soldkind  

select slsman_id,note from slsman where dpt_sale_id='${dptid}'


select  distinct soldkind from cust_sold where date1='201502'

select note from slsman where slsman_id='${slsmanid}'

