select a.sale_dept_id dpt_sale_id ,substr(vend_name,1,2) fact_name,ic.short_code short_id, item_name, price  pri_wsale,
 kind,sum(qty)  qty 
from 
(select c.sale_dept_id,i.item_id,item_name,brdowner_id,price,i.kind,
sum(cl.qty_ord*t_size)/50000  qty  from 
co_co c,co_co_line cl ,plm_item i 
where c.co_num=cl.co_num and cl.item_id=i.item_id  
and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
 
and c.com_id='10371701'
and c.status<>'90' 
group by c.sale_dept_id,i.item_id,item_name,brdowner_id,price,i.kind having sum(qty_ord)<>0
) a,  pi_vend  f,plm_item_com ic

where a.brdowner_id=f.vend_id  and a.item_id=ic.item_id and ic.com_id='10371701'

group by a.sale_dept_id   , vend_name ,ic.short_code  , item_name, price  , kind
order by vend_name ,kind asc


