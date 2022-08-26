select c.cust_id,cust_short_name,busi_addr,order_tel,count(distinct i.item_id) itemnum,
sum(a.qty_need) qtyneed,sum(a.qty_sold) qtysold,sum(a.amt_sold) amtsold
 from pi_cust_item_day a ,co_cust c,plm_item i 
 where  a.item_id=i.item_id and  a.cust_id=c.cust_id  and a.qty_sold<>0
and ( ${strings} )
  and i.kind in (${kind}) and c.sale_dept_id='${dptid}'
 and  date1=(select to_char(to_date('${date1}','yyyyMMdd')+1,'yyyyMMdd') from dual) group by c.cust_id,cust_short_name,busi_addr,c.order_tel

