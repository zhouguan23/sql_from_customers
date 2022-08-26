select s.com_name,s.note, kind,
sum(qty_sold_month*t_size)/50000 qtymonth,
sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year*t_size)/50000 qtyyear,
sum(qty_sold_year_same*t_size)/50000 qtyyearsame

 from hz_s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1='${date1}'
group by s.com_name,s.note,kind order by s.note

select distinct kind,kind||'类' from item

