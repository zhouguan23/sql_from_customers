select ic.short_code,i.item_name,d.pri  price_trade,sum(d.qty) qty,sum(d.amt) amt from 
ldm_dist l,ldm_dist_item d,plm_item_com ic,plm_item i
where  l.dist_num=d.dist_num  
and d.item_id=i.item_id 
and ic.item_id=i.item_id
and ic.com_id='10371701' 
and l.dist_date>='${time1}' 
and l.dist_date<='${time2}'
${if(len(deliver)==0,"", "and l.deliver_id='"+deliver+"'")}
and l.is_mrb='1'
group by  ic.short_code,i.item_name,d.pri 
order by ic.short_code


