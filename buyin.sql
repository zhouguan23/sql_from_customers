SELECT substr(vend_name,1,4) fact_name,ITEM_COM.SHORT_code short_ID ,item.item_id, ITEM.ITEM_NAME , ITEM.KIND  , ITEM_COM.price_trade PRI_WSALE  , SUM((po_line.qty_ord*um.um_size)/50000) AS poqty
     , SUM(amt_tax) AS amount
FROM pi_contract PO
     , pi_contract_line PO_LINE
     , plm_ITEM ITEM
   
     , plm_UM UM
     , pi_vend FACTORY
     , plm_ITEM_COM ITEM_COM
 WHERE  PO.contr_NUM=PO_LINE.contr_NUM
      AND PO_LINE.ITEM_ID=ITEM.ITEM_ID
   and po.com_id='10371701'
      AND PO_LINE.UM_ID=UM.UM_ID
      AND ITEM.brdowner_id=FACTORY.vend_ID
      AND PO.COM_ID=ITEM_COM.COM_ID and item_com.com_id='10371701' 
      AND PO_LINE.ITEM_ID=ITEM_COM.ITEM_ID
    AND   PO.pose_DATE >='${time1}' AND
     PO.pose_DATE <= '${time2}' 
   and ITEM_com.price_trade>=${pri1} 
   and ITEM_com.price_trade<=${pri2} 
   ${if(len(is_imported)==0,"", " and ITEM.yieldly_type='"+is_imported+"'")} 
 GROUP BY substr(vend_name,1,4),ITEM_COM.SHORT_code , ITEM.ITEM_NAME ,item.item_id, ITEM.KIND  , ITEM_COM.PRIce_trade 
 ORDER BY ITEM_COM.SHORT_code

