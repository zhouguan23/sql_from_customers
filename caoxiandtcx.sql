select c.born_date,c.slsman_id,c.cust_id,cc.cust_name,cc.status,pl.item_id,pl.item_name,
sum(cl.qty_ord),sum(cl.qty_ord*pl.t_size)/200 销量条,sum(cl.qty_ord*pl.t_size)/50000  销量箱,sum(cl.amt)
from co_co c,co_co_line cl,plm_item pl,plm_item_com pc,co_cust cc
where cl.co_num=c.co_num
and pl.item_id=cl.item_id
and pc.item_id=cl.item_id
and pc.com_id='10371701'
and cc.cust_id=c.cust_id
and c.born_date>='${date1}'
and c.born_date<='${date2}'
/*and cc.status='02'*/
and c.status='60'
and c.sale_dept_id='11371703'
and cl.qty_ord>0
group by  c.born_date,c.slsman_id,c.cust_id,cc.cust_name,pl.item_id,pl.item_name,cc.status
order by cust_id

