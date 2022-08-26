select dpt_sale_id,date1,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amtsold,sum(qty_sold*pri_rtl) amtcustml from item_dpt_Sale_month a,item i,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and 
date1>=(select to_char(to_date(${date1},'yyyymm'),'yyyy')||'01' from dual)
and date1<=${date1} group by dpt_sale_id,date1

select dpt_sale_id,date1,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amtsold,sum(qty_sold*pri_rtl) amtcustml from item_dpt_Sale_month a,item i,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and 
date1>=(select to_char(add_months(to_date(${date1},'yyyymm'),-12),'yyyy')||'01' from dual)
and date1<=(select to_char(add_months(to_date(${date1},'yyyymm'),-12),'yyyymm') from dual)  group by dpt_sale_id,date1

select dpt_sale_id,count(1) custnum from cust where status='02' group by dpt_sale_id

 select to_char(add_months(to_date(${date1},'yyyymm'),-12),'yyyymm') rqtong from dual

