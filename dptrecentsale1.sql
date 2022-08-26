select dpt_sale_id,date1,sum(qty_sold)/250 qty from item_dpt_sale_month
where  item_id='${itemid}' and
 date1>=( select to_char(add_months(to_date(to_char(sysdate,'yyyymm'),'yyyymm'),-12),'yyyymm')
 from dual)  group by dpt_sale_id,date1 having sum(qty_sold)<>0
order by date1 desc

select item_name from item where  item_id='${itemid}'

select ic.item_id,ic.short_id||'-'||item_name||'-'||pri_wsale itemname from plm_item p,item_com ic
where p.item_id=ic.item_id and p.is_mrb=1 and ic.is_mrb=1  and p.item_kind=1
order by ic.pri_wsale desc

