select item_name,qty_ord,price,amt from co_co_line cl,co_co c,plm_item  i
where c.co_num=cl.co_num
and cl.item_id=i.item_id
and c.cust_id='${custid}'
and c.status<>'90'  and qty_ord<>0
and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual)
order by price desc

select cust_short_name from co_cust where cust_id='${custid}'

