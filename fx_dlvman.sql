select dlv.dlvman_id,dlv.note,ic.short_id,im.item_name,ic.pri_wsale ,
      sum(cl.qty_ord) qty
 from co co,co_line cl,cust_dist cd,dlvman dlv,
      item im,item_com ic
 where co.co_num=cl.co_num
       and co.status<>'08'
       and co.cust_id=cd.cust_id
       and cd.region_id=dlv.region_id
       and co.dpt_sale_id=${dptno}
       and co.crt_date>=${time1}
       and co.crt_date<=${time2}
       and (dlv.dlvman_id>='${dlv1}'
       and dlv.dlvman_id<='${dlv2}')
       and cl.item_id=im.item_id
       and cl.item_id=ic.item_id
       and ic.com_id='10371701'
  group by dlv.dlvman_id,dlv.note,ic.short_id,im.item_name,ic.pri_wsale
  having   sum(cl.qty_ord)<>0
  order by dlv.dlvman_id,ic.short_id

