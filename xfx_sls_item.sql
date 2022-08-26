SELECT CUST.CUST_SHORT_NAME, 
        CUST.BUSI_ADDR,
       cust_kind_name,
        sum(CO.QTY_ord*item.t_size/200) qtyord,
       ITEM.ITEM_NAME,
       IC.SHORT_code,
       CUST.order_TEL,
       CUST.SLSMAN_ID,
       slsman.note,
       substr(periods_id,6,1) rut_name  FROM
 ( select co.cust_id,item_id,co.sale_dept_id,qty_ord  from  co_CO CO,
     co_CO_LINE CL where co.co_num=cl.co_num and co.status in ('30','40','50','60') and co.born_date>='${time1}' 
  and co.born_date<='${time2}' and co.sale_dept_id like '${DPTNO}' 
 ) co, 
     co_CUST CUST,
     plm_ITEM ITEM,
     plm_item_com ic,
     slsman slsman,
     csc_cust ccust
WHERE  item.item_id=ic.item_id
       and ic.com_id='10371701'
       and co.cust_id=cust.cust_id and co.cust_id=ccust.cust_id
       and co.item_id=item.item_id
       and slsman.slsman_id=cust.slsman_id
       and slsman.com_id='10371701'
       And CUST.CUST_ID like '${cust_id}'
       And IC.SHORT_code like '${short_id}'
       and slsman.slsman_id like '${slsman_id2}'
   
   
group by CUST.CUST_SHORT_NAME, 
        CUST.BUSI_ADDR,
       cust_kind_name,
       
       ITEM.ITEM_NAME,
       IC.SHORT_code,
       CUST.order_TEL,
       CUST.SLSMAN_ID,
       slsman.note,
       substr(periods_id,6,1)  

HAVING   sum(CO.QTy_ord)>=${QTY1} AND
           sum(CO.QTY_ord)<${QTY2}

