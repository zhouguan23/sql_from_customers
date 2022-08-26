 select im.item_id,im.kind,ic.short_code short_id,im.item_name,ic.price_trade pri_wsale
  from plm_item im,plm_item_com ic,
  (select distinct item_id
  from pi_dept_item_day  
  where (
         (date1>='${time1}'  and date1<='${time2}')
       or (date1>='${time3}' and date1<='${time4}')
         )
      and qty_sold<>0 
     
      and sale_dept_id in ('${dptno}')
) a1
  where im.item_id=a1.item_id
       and im.item_id=ic.item_id
       and ic.com_id='10371701'
       and ic.short_code like '%${short_id}%'
       and im.yieldly_type like '%${is_imported}%'
       and im.kind in (${kind})
 and ic.price_trade>=${pri1}
      and ic.price_trade<${pri2}
  order by ic.short_code

 select isd.item_id,sum(qty_sold*im.t_size/200)/${um} qty1,sum(AMT_SOLD) amt1,
          sum(GROSS_PROFIT) gros1
   from pi_dept_item_day isd,plm_item im, plm_item_com ic
   where isd.item_id=im.item_id and isd.item_id=ic.item_id
   and ic.com_id='10371701' and date1>='${time1}'
        and date1<='${time2}'
        and sale_dept_id in ('${dptno}')
         
        and ic.price_trade>=${pri1}
        and ic.price_trade<${pri2}
   group by isd.item_id having sum(qty_sold)<>0

  select isd.item_id,sum(qty_sold*im.t_size/200)/${um} qty2,sum(AMT_SOLD) amt2,
          sum(GROSS_PROFIT) gros2
   from pi_dept_item_day isd,plm_item im,plm_item_com ic
   where isd.item_id=im.item_id and isd.item_id=ic.item_id and 
   ic.com_id='10371701' and date1>='${time3}'
        and date1<='${time4}'
        and sale_dept_id in ('${dptno}')

        and ic.price_trade>=${pri1}
        and ic.price_trade<${pri2}
   group by isd.item_id having sum(qty_sold)<>0

