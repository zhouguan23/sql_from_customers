select substr(f.vend_name,1,4)  fact_name ,i.item_id,box_bar,ic.short_code  ,
item_name,kind,spec,pack_kind ,t_size , price_trn,
price_trade  ,price_retail   from plm_item i,plm_item_com ic,pi_vend f 
where i.item_id=ic.item_id and f.vend_id=i.brdowner_id  
 and ic.com_id='10371701'    and ic.short_code<>'000000'
  
order by vend_id,price_trade desc

