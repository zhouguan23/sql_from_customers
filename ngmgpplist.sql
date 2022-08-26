select ic.short_code,item_name,qty_ord from co_co_line a,plm_item i,plm_item_com ic
where  a.item_id=i.item_id and a.item_id=ic.item_id and qty_ord<>0  and co_num='${conum}'

