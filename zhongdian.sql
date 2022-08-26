select it.itemgr_id,itemgr_name,dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a,itemgr it,item i 
where a.item_id=i.item_id and i.itemgr_id=it.itemgr_id   
and i.itemgr_id in ('0144', '0170','0028','0108')
 and a.date1='${date1}' group by it.itemgr_id,itemgr_name,dpt_sale_id having sum(qty_sold)<>0

select it.itemgr_id,itemgr_name,dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a,itemgr it,item i 
where a.item_id=i.item_id and i.itemgr_id=it.itemgr_id 
and i.itemgr_id in ('0144', '0170','0028','0108')
and a.date1=(SELECT TO_CHAR(add_months(to_date(${date1},'yyyymm'),-12),'YYYYMM')  FROM DUAL) group by it.itemgr_id,itemgr_name,dpt_sale_id having sum(qty_sold)<>0

select  dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a, item i 
where a.item_id=i.item_id  and i.itemgr_id='0046'
and a.date1='${date1}'  group by  dpt_sale_id having sum(qty_sold)<>0

select  dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a, item i 
where a.item_id=i.item_id  and i.itemgr_id='0046'
and a.date1=(SELECT TO_CHAR(add_months(to_date(${date1},'yyyymm'),-12),'YYYYMM') from dual)  group by  dpt_sale_id having sum(qty_sold)<>0

select  dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a, item i ,item_com ic
where a.item_id=i.item_id  and i.itemgr_id='0046' and i.item_id=ic.item_id and ic.com_id='10371701' and  ic.pri_rtl>=100
and a.date1=(SELECT TO_CHAR(add_months(to_date(${date1},'yyyymm'),-12),'YYYYMM')  FROM DUAL) group by  dpt_sale_id having sum(qty_sold)<>0

select  dpt_sale_id,sum(qty_sold)/250 qty from item_dpt_sale_month a, item i ,item_com ic
where a.item_id=i.item_id  and i.itemgr_id='0046' and i.item_id=ic.item_id and ic.com_id='10371701' and  ic.pri_rtl>=100
and a.date1='${date1}' group by  dpt_sale_id having sum(qty_sold)<>0

select itemgr_id,itemgr_name from itemgr where itemgr_id in ('0144', '0170','0028','0108')

