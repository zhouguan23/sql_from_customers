select ic.short_code,item_name,cl.price,sum(qty_ord) qty,sum(amt) amt from co_co c,co_co_line cl, plm_item_com ic,plm_item i
where c.co_num=cl.co_num and cl.item_id=i.item_id and 
cl.item_id=ic.item_id and ic.com_id='10371701'
 and c.born_date>='${date1}' and c.born_date<='${date2}'   and
 c.status='60' and cl.qty_ord<>0   ${string1}  and c.cust_id in 
(select cust_id from co_cust where tax_account='${string2}')
group by ic.short_code,item_name,cl.price
order by ic.short_code,item_name,cl.price

