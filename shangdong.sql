select  i.item_id,itemgr_id,pri_rtl,sum(qty_sold*i.rods)/50000 qtyben,sum(amt_sold_with_tax) amtben from item_dpt_sale_day a ,item i,item_com ic
where date1>='${date1}' and date1<=${date2} and is_imported=0  
and a.item_id=i.item_id  and a.item_id=ic.item_id and ic.com_id='10371701'
and dpt_sale_id like '%${dpt}%'
group by i.item_id ,itemgr_id,pri_rtl having sum(qty_sold)<>0

select i.item_id,item_name,pri_wsale,itemgr_id from item i,item_com ic
where i.item_id=ic.item_id  and ic.com_id='10371701' and is_imported=0 and ic.is_mrb=1
and i.is_mrb=1  and i.item_id in 
(  select distinct item_id from ocom_day where date1>=(select to_char(add_months(to_date(${date1},'yyyymmdd'),-12),'yyyymmdd')  from dual)
and date1<=(select to_char(add_months(to_date(${date2},'yyyymmdd'),-12),'yyyymmdd')  from dual)
 group by item_id  having sum(qty_sold)>0
union
select distinct item_id from  ocom_day where date1>=${date1} and date1<=${date2}
 group by item_id  having sum(qty_sold)>0
 )



order by pri_wsale desc

select   i.item_id,itemgr_id,pri_rtl,sum(qty_sold*i.rods)/50000 qtytong,sum(amt_sold_with_tax) amttong from item_dpt_sale_day a ,item i,item_com ic
where 
date1>=(select to_char(add_months(to_date(${date1},'yyyymmdd'),-12),'yyyymmdd')  from dual)
and date1<=(select to_char(add_months(to_date(${date2},'yyyymmdd'),-12),'yyyymmdd') from dual)
 and is_imported=0  and a.item_id=ic.item_id and ic.com_id='10371701'
and dpt_sale_id like '%${dpt}%'
and a.item_id=i.item_id  group by  i.item_id,itemgr_id,pri_rtl having sum(qty_sold)<>0

