select item_ID,item_name from item

select item_type1,substr(item_type1,2,20) a1,dpt_sale_id_new,dp.short_name,sum(qty_sold)/250 QTY FROM ITEM_COM IC,ITEM_DPT_SALE_MONTH A,dpt_sale dp
WHERE A.ITEM_ID=IC.ITEM_ID AND a.dpt_sale_id=dp.dpt_sale_id and A.DATE1>=${date1} AND DATE1<=${date2} GROUP BY ITEM_TYPE1,DPT_SALE_ID_new,short_name ORDER BY ITEM_TYPE1,dpt_sale_id_new

