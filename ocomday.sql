select ic.SHORT_CODE short_id,item_name,PRICE_TRADE pri_wsale,qty_purch  qty_purch,amt_purch,qty_sold  qty_sold ,round(amt_sold_NO_TAX,1) amt_sold_NO_TAX,amt_sold ,qty_eod  qty_eod,round(amt_eod,1) amteod, round(gross_profit,1) gross_profit from PLM_item i,PLM_item_com ic,
 PI_com_day o where date1='${date1}'
and ( qty_purch<>0 or qty_sold<>0 or qty_eod<>0) and 
 i.item_id=o.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
order by ic.short_CODE

