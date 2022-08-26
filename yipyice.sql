select distinct i.item_id ,item_name from sgp_item_spw a,plm_item i 
 
 where com_id='10371701'   and a.item_id=i.item_id
 and supply_way='32'  and qty_plan<>0 

select item_id, c.cust_id,cust_short_name,busi_addr,cust_seg,cc.periods_id,periods_name,qty_remain as qty_plan from Sgp_Cust_Item_spw a,co_cust c ,csc_cust cc,csc_order_periods cs
where a.cust_id=c.cust_id and c.cust_id=cc.cust_id and cc.periods_id=cs.periods_id
and   qty_plan<>0 
and  a.com_id='10371701'  and   item_id='${itemid}'
and week='${week}'
order by cc.periods_id

select distinct week from sgp_item_spw where com_id='10371701' and week>='2016011'

select  cust_id,sum(qty_sold) qty from pi_cust_item_bnd_day 
where date1>=(select distinct begin_date from sgp_item_spw where week='${week}' and com_id='10371701')
and  date1<=(select distinct end_date from sgp_item_spw where week='${week}' and com_id='10371701')
and item_id='${itemid}'
group by cust_id

