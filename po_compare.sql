select im.item_name,im.item_id,po.crt_date,po.po_num,(pl.qty_ord*um.um_size)/50000 AS poqty,
round((pl.qty_ord*pl.pri_no_tax)*1.17,0) AS amount
from po po,po_line pl,item im,um um
where po.po_num=pl.po_num
and pl.um_id=um.um_id
and pl.item_id=im.item_id

and po.crt_date>=${time1}
and po.crt_date<=${time2}
and po.status='05'
order by po.crt_date

  select cs.ref_num,im.item_id,sum(cs.qty*im.rods/200)/250 qty1,round(sum(cs.amt),0) amt1
  from po po,COMTRANS cs,item im
  where po.crt_date>=${time1}
      and po.crt_date<=${time2}
      and po.po_num=cs.ref_num
      and cs.ref_type='10'
      and cs.item_id=im.item_id
     
  group by cs.ref_num,im.item_id

 select rct.po_num,im.item_id,sum(rctline.qty*um.um_size*im.rods/200)/50000 qty1,round(sum(rctline.amt),0) amt1
  from po po,RCPTBILl rct,RCPTBILl_LINE rctline,um um,item im
  where po.crt_date>=${time1}
         and po.crt_date<=${time2}
    and rctline.item_id=im.item_id
      and po.po_num=rct.po_num
      and rct.bill_num=rctline.bill_num
      and rctline.um_id=um.um_id
     
  group by rct.po_num,im.item_id

SELECT substr(fact_name,1,4) fact_name,ITEM_COM.SHORT_ID ,item.item_id, ITEM.ITEM_NAME , ITEM.KIND  , ITEM_COM.PRI_WSALE  , SUM((po_line.qty_ord*um.um_size)/50000) AS poqty
     , round(SUM((po_line.qty_ord*po_line.pri_no_tax)*1.17),0) AS amount
FROM SDYCDEVUSER.PO PO
     , SDYCDEVUSER.PO_LINE PO_LINE
     , SDYCDEVUSER.ITEM ITEM
   
     , SDYCDEVUSER.UM UM
     , SDYCDEVUSER.FACTORY FACTORY
     , SDYCDEVUSER.ITEM_COM ITEM_COM
 WHERE  PO.PO_NUM=PO_LINE.PO_NUM
      AND PO_LINE.ITEM_ID=ITEM.ITEM_ID
  
      AND PO_LINE.UM_ID=UM.UM_ID
      AND ITEM.FACTORY=FACTORY.FACT_ID
      AND PO.COM_ID=ITEM_COM.COM_ID
      AND PO_LINE.ITEM_ID=ITEM_COM.ITEM_ID
   and  PO.STATUS = '05' AND
     PO.CRT_DATE >=${time1} AND
     PO.CRT_DATE <= ${time2} 
  
 
 GROUP BY fact_name,ITEM_COM.SHORT_ID , ITEM.ITEM_NAME ,item.item_id, ITEM.KIND  , ITEM_COM.PRI_WSALE  
 ORDER BY fact_name,ITEM_COM.SHORT_ID

