select dp.short_name,slsman_id,sls.note from slsman sls,dpt_sale dp
 where dp.dpt_sale_id=sls.dpt_sale_id and sls.com_id='10371701' and dp.dpt_sale_id in ('${dptno}')
and dp.com_id='10371701' and sls.is_mrb=1

select slsman_id,sum(qty_sold*im.rods/200)/${um} qty1,sum(AMT_SOLD_WITH_TAX) amt1,
          sum(GROSS_PROFIT) gros1
   from item_slsman_day isd,item im 
   where isd.item_id=im.item_id and date1>='${time1}' 
        and date1<='${time2}'
        and dpt_sale_id in ('${dptno}')
       
        
   ${if(len(item_id)==0,"", " and im.item_id='"+item_id+"'")}
   group by slsman_id

select slsman_id,sum(qty_sold*im.rods/200)/${um} qty1,sum(AMT_SOLD_WITH_TAX) amt1,
          sum(GROSS_PROFIT) gros1
   from item_slsman_day isd,item im 
   where isd.item_id=im.item_id and date1>=${time3} 
        and date1<=${time4}
        and dpt_sale_id in ('${dptno}')
         
   ${if(len(item_id)==0,"", " and im.item_id='"+item_id+"'")}
   group by slsman_id

select i.item_id,ic.short_id||'-'||item_name itemname from item i,
item_com ic where i.item_id=ic.item_id and ic.com_id='10371701'
and i.is_mrb=1 and i.item_kind=1 order by ic.short_id

