select 
zcc.CUST_ID,
zcc.license_code,
zcc.cust_name,
zcc.sale_dept_id,
p.ITEM_ID,
p.ITEM_NAME,
depa.DPT_SALE_NAME
from (
select  
t.CUST_ID,
t.ITEM_ID
from PI_CUST_ITEM_MONTH t
LEFT JOIN ZCFW_CO_CUST cc on cc.cust_id=t.CUST_ID
where t.DATE1>='${begin}'
and t.DATE1<='${end}'
and t.QTY_SOLD>0
and cc.STATUS='02'
and t.cust_id='${code}'
group by t.CUST_ID,t.ITEM_ID)w
LEFT JOIN PLM_ITEM p on p.ITEM_ID=w.ITEM_ID
LEFT JOIN ZCFW_CO_CUST zcc on zcc.cust_id=w.CUST_ID
left join dpt_sale depa on depa.dpt_sale_id=zcc.SALE_DEPT_ID 

SELECT  dpt_sale_id,dpt_sale_name FROM dpt_sale

