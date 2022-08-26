select substr(vend_name,1,4)  fact_name, i.item_id,item_name,kind,unit_cost,price_trn pri_puh,price_trade pri_wsale,price_retail pri_rtl 
 from plm_item i,
plm_item_com ic,pi_vend f 
where i.item_id=ic.item_id   and i.brdowner_id=f.vend_id and  ic.is_mrb=1 and i.is_mrb=1 
and i.item_id in (select distinct item_id from 
 (select item_id from pi_com_month where date1>=(SELECT  TO_CHAR(add_months(sysdate,-3),'yyyyMM') 
FROM DUAL)
union 
select item_id from lwm_whse_item 
)
) order by fact_name desc 

