select item_type3,dpt_sale_id,sum(qty_sold*t_size)/50000 QTY FROM ITEM_COM IC,ITEM_DPT_SALE_MONTH A,plm_item i 
WHERE ic.item_id=i.item_id and 
A.ITEM_ID=IC.ITEM_ID  and A.DATE1>=${date1} AND DATE1<=${date2} GROUP BY ITEM_TYPE3 ,dPT_SALE_ID 





select  distinct item_type3,substr(item_type3,2,20) type1 from item_com

select dpt_sale_id,short_name from dpt_sale where dpt_sale_id<>'17010100'
order by dpt_sale_id_new

