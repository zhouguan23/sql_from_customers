select  
cc.CUST_ID,
cc.license_code,
cc.cust_name,
cc.sale_dept_id,
p.ITEM_ID,
p.ITEM_NAME,
depa.DPT_SALE_NAME,
t.item_id,
p.PRICE_RETAIL/10 as price
from PI_CUST_ITEM_MONTH t
LEFT JOIN ZCFW_PLM_ITEM_COM p on p.ITEM_ID=t.ITEM_ID
LEFT JOIN ZCFW_CO_CUST cc on cc.cust_id=t.CUST_ID
LEFT JOIN PLM_ITEM p on p.ITEM_ID=t.ITEM_ID
left join dpt_sale depa on depa.dpt_sale_id=cc.SALE_DEPT_ID
where t.DATE1>='${begin}'
and t.DATE1<='${end}'
and t.QTY_SOLD>0
and cc.STATUS='02'
and t.CUST_ID='${code}'
ORDER BY p.PRICE_RETAIL desc

SELECT  dpt_sale_id,dpt_sale_name FROM dpt_sale

