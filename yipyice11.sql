select distinct i.item_id ,item_name from sgp_item_spw a,plm_item i 
 
 where com_id='10371701'   and a.item_id=i.item_id
 and supply_way='32'  and qty_plan<>0

select item_id, c.cust_id,cust_short_name,busi_addr,cust_seg,qty_plan  from Sgp_Cust_Item_spw_hz a,co_cust c 
where a.cust_id=c.cust_id and   c.sale_dept_id='${dptid}' and c.status='02' and  qty_plan<>0 
and 
 a.com_id='10371701'  and   item_id in 
  (select distinct item_id from sgp_item_spw 
 
 where com_id='10371701'  
 and supply_way='32')
 

