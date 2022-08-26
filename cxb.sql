select i.item_id,item_name,kind,price_trade pri_wsale,sum(qty_sold*t_size)/50000 qty,sum(qty_eom*t_size)/50000 qtyoed, 
case when qty_sold=0 then 0
else round(sum(qty_eom*t_size)/sum(qty_sold*t_size),2)
end   as  cxb,'' note from pi_com_month  a,plm_item i,plm_item_com ic
where   i.item_id=a.item_id and ic.item_id=a.item_id and ic.com_id='10371701'
 and date1='${date1}' and (qty_purch<>0 or qty_sold<>0 or qty_eom<>0)

group by i.item_id,item_name,kind,price_trade,qty_sold
 order by kind asc ,price_trade desc

