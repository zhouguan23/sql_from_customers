select ic.SHORT_CODE  short_id,item_name,price_trade pri_wsale,kind,YIELDLY_TYPE is_imported,
qty_usable qty,qty_usable*t_size/50000 qtywz,qty_usable*price_puh kcamt from plm_item i ,plm_item_com ic,
lwm_whse_item  it where i.item_id=ic.item_id and i.item_id=it.item_id and qty_usable<>0 and ic.com_id='10371701' and it.com_id='10371701'  and price_trade>=${pri1} and price_trade<=${pri2} order by ic.short_code

