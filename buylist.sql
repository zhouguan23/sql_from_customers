select im.item_name,im.item_id,po.pose_date,po.contr_num,(pl.qty_ord*um.um_size)/50000 AS poqty,
amt_tax AS amount
from pi_contract po,pi_contract_line pl,plm_item im,plm_um um
where po.contr_num=pl.contr_num
and pl.um_id=um.um_id
and pl.item_id=im.item_id
and pl.item_id='${item_id}'
and po.pose_date>='${time1}'
and po.pose_date<='${time2}'
and po.com_id='10371701'
and pl.com_id='10371701'
order by po.pose_date

  select cs.ref_num,sum(cs.qty*im.rods/200)/250 qty1,round(sum(cs.amt),0) amt1
  from po po,COMTRANS cs,item im
  where po.crt_date>=${time1}
      and po.crt_date<=${time2}
      and po.po_num=cs.ref_num
and po.com_id='10371701'
      and cs.ref_type='10'
      and cs.item_id=im.item_id
      and cs.item_id='${item_id}'
  group by cs.ref_num

 select rct.po_num,sum(rctline.qty*um.um_size*im.rods/200)/50000 qty1,round(sum(rctline.amt),0) amt1
  from po po,RCPTBILl rct,RCPTBILl_LINE rctline,um um,item im
  where po.crt_date>=${time1}
      and rctline.item_id=im.item_id
      and po.crt_date<=${time2}
      and po.po_num=rct.po_num
      and rct.bill_num=rctline.bill_num
      and rctline.um_id=um.um_id
      and rctline.item_id='${item_id}'
and po.com_id='10371701' and rct.com_id='10371701'
  group by rct.po_num

