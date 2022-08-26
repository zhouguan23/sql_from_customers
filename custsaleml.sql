select c.cust_id,c.cust_name,busi_addr,order_tel,c.status,sum(a.qty_sold)  qty,
sum(a.amt_sold) amt,sum(a.amt_sold)*250/sum(a.qty_sold) dxamt,
sum(a.qty_sold*(p.price_trade-p.price_trn)) ml ,sls.note 
from pi_cust_item_day a,co_cust c,plm_item_com p,slsman sls
where a.cust_id=c.cust_id and a.item_id=p.item_id and p.com_id='10371701'
and c.slsman_id=sls.slsman_id and c.sale_dept_id='${dptno}'
and a.date1>='${date1}' and a.date1<='${date2}' and sls.slsman_id like '${slsmanid}%'
 group by 
c.cust_id,c.cust_name,c.busi_addr,order_tel,c.status,sls.note 
having (sum(a.qty_sold)>=${qty1} and sum(a.qty_sold)<${qty2})
${str1} (sum(a.amt_sold)>=${amt1} and sum(a.amt_sold)<${amt2})
 ${str2} (sum(a.amt_sold)*250/sum(a.qty_sold)>=${dx1} and sum(a.amt_sold)*250/sum(a.qty_sold)<${dx2}) 
 ${str3} ( sum(a.qty_sold*(p.price_trade-p.price_trn))>=${ml1} and sum(a.qty_sold*(p.price_trade-p.price_trn))<${ml2} )
 

select slsman_id,note from slsman where dpt_sale_id='${dptno}' order by slsman_id

select dpt_sale_id,short_name from dpt_sale

