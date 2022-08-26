select  pi.sale_dept_id,c.license_code,c.cust_id,c.cust_name,s.slsman_name,sum(pi.qty_sold)
from plm_item  p,pi_cust_item_month pi,plm_item_com pc,co_cust c,slsman s
where  pi.cust_id=c.cust_id
and pi.item_id=pc.item_id
and pi.item_id=p.item_id
and c.slsman_id=s.slsman_id
and date1='202101'
and c.status='02'
and  pc.price_trade>=${p1}
and  pc.price_trade<=${p2}
group by  pi.sale_dept_id,c.license_code,c.cust_id,c.cust_name,s.slsman_name
having sum(pi.qty_sold)>0
order by sum(pi.qty_sold)  desc


