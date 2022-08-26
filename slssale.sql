 
select userid,item_id,item_name ,a.guige,a.um,a.pri_sale,sum(sl)sl ,sum(je) je 
from ddsal  a ,yao_cust c
 where   a.cust_id=c.license_code and 
 c.sale_dept_id='${dpt}' and dd_id>'201506300000000000000000000000'
 group by userid,item_id,item_name ,a.guige,a.um,a.pri_sale having sum(sl)<>0
order by userid,item_id
 

select * from dw

