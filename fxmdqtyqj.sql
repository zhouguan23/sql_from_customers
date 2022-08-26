select c.cust_id,cust_short_name,busi_addr,order_tel,b.qty,sls.note from co_cust c 
 left join  slsman sls on c.slsman_id=sls.slsman_id 
 right join
(
select cust_id,sum(qty_sold)  qty from
 Pi_Cust_Item_Bnd_Day where date1>='${date1}'  and date1<='${date2}' and 
 sale_Dept_id='${dpt}' group by cust_id
 having sum(qty_sold)>=${qty1} and sum(qty_sold)<=${qty2}
 ) b on c.cust_id=b.cust_id
 where  c.sale_dept_id='${dpt}' and c.status='02'
 order by sls.note,b.qty

