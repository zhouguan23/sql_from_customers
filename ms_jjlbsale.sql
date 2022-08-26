   select  i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold_month*t_size)/50000 qty,sum(amt_sold_month) amt,
sum(qty_sold_year*t_size)/50000 qtyy,sum(amt_sold_year) amty,
sum(qty_sold_month_same*t_size)/50000 qtymt,sum(amt_sold_month_same) amtmt,
sum(qty_sold_year_same*t_size)/50000 qtyyt,sum(amt_sold_year_same) amtyt

from plm_item i ,item_com@orahzbo ic,plm_brand pp,pi_dept_item_day qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id
and qh.date1=(SELECT  max(date1) from pi_dept_item_day)
 
group by   i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl


select di_id,di_name from di_where where isstatefl=1

select distinct is_prm,substr(is_prm,2,16) pricefl from item_com

