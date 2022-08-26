 
  select   i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com@orahzbo ic,plm_brand pp,pi_dept_item_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id
and qh.date1>='${date1}' 
and qh.date1<='${date2}'
  ${if(len(dptid)==0,"", " and qh.sale_dept_id='"+dptid+"'")}
group by  i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl



  select  i.kind,ic.is_prm,is_thin,yieldly_type,
case  when i.tar_cont is null  then 0 else  tar_cont end as tars, 
case pp.is_key_brd when '1' then 1 else 0 end as note,i.brand_id,ic.pri_rtl,
sum(qty_sold*t_size)/50000 qty,sum(amt_sold) amt

from plm_item i ,item_com@orahzbo ic,plm_brand pp,pi_dept_item_month qh
where i.item_id=ic.item_id and i.item_id=qh.item_id
and i.brand_id=pp.brand_id

${if(len(dptid)==0,"", " and qh.sale_dept_id='"+dptid+"'")}

and qh.date1>=(SELECT TO_CHAR(add_months(to_date('${date1}','yyyyMM'),-12),'yyyyMM') FROM DUAL)  
and qh.date1<=(SELECT TO_CHAR(add_months(to_date('${date2}','yyyyMM'),-12),'yyyyMM') FROM DUAL)  group by   i.kind,ic.is_prm,is_thin,yieldly_type,tar_cont,is_key_brd,i.brand_id,ic.pri_rtl


select distinct is_prm,substr(is_prm,2,16) pricefl from item_com

