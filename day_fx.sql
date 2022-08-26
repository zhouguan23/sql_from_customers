select ic.short_code,item_name,ic.price_trade,sum(qty_ord*t_size)/50000 qtys from  co_co c,co_co_line cl,plm_item_com ic,plm_item i 
where c.co_num=cl.co_num and  cl.item_id=i.item_id and cl.item_id=ic.item_id and ic.com_id='10371701' and c.status<>'90' and c.born_date='${crtdate}' group by ic.short_code,item_name,ic.price_trade having sum(qty_ord)<>0 order by ic.price_trade  desc

