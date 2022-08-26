select  cust_id, i.item_id,i.item_name,sum(a.qty_sold) qty,
sum(a.amt_sold) amt,sum(a.amt_sold_no_tax) amtnotax from pi_cust_item_day a,plm_item i 
where a.item_id=i.item_id 
and a.date1>='${date1}' and a.date1<='${date2}'
 and  cust_id='${custid}'
group by  cust_id, i.item_id,i.item_name having sum(a.qty_sold)<>0

select cust_name from co_cust where cust_id='${custid}'

