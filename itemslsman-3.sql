select short_code,item_name,ic.price_trade,date1,sum(qty_sold) qty from pi_cust_item_month a,plm_item i,plm_item_com ic
where cust_id='${cust_id}'
and date1 in ('${time1}','${time2}','${time3}','${time4}')
and a.item_id=ic.item_id and a.item_id=i.item_id and qty_sold<>0

   ${if(len(item_id)==0,"", " and i.item_id='"+item_id+"'")}
group by short_code,item_name,ic.price_trade,date1 order by short_code,date1 desc

select cust_name from cust where cust_id='${cust_id}'

