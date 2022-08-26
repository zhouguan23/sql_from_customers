select cust_id,ic.short_id,item_name,pri_wsale,qty_sold,amt_sold from item i ,item_com ic,
(
select a.cust_id,item_id, qty_sold,amt_sold  from   item_cust_month${years} a  ,cust_prop cp
  where    a.cust_id=cp.cust_id and iss_date=${date1}  and cp.z_Cun_id=${zcn} and qty_sold<>0
) a where a.item_id=i.item_id and a.item_id=ic.item_id 


select a.cust_id, cust_short_name,z_cun_name,qty_sold,amt  from   cust_month${years} a  ,cust_prop cp,cust cc ,z_cun z
  where  cp.z_Cun_id=z.z_cun_id and cc.cust_id=a.cust_id and  a.cust_id=cp.cust_id and  date1=${date1}  and cp.z_Cun_id=${zcn} and qty_sold<>0 and cc.status='02'


