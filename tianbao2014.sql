select fact_id,substr(fact_name,1,4) factname,i.item_id,item_name,qichushang,tzshang,qichuxia,tzxia,pri_wsale,kind from 
item i ,factory f,item_goujin a,item_com ic

 where f.fact_id=i.factory and i.item_id=a.item_id 　and years='2014'
and ic.item_id=i.item_id 

${if(len(fact)==0,"", " and fact_id in ('"+fact+"')")}


order by fact_name desc ,pri_wsale desc



 
select item_id, sum(qty_ord)/5 qty  from  po   p,
 po_line   pl
 where p.po_num=pl.po_num and p.crt_date>='20140101' and crt_date<='20140630' 
group by item_id 
 

 
select item_id, sum(qty_ord)/5 qty  from  po   p,
 po_line   pl
 where p.po_num=pl.po_num and p.crt_date>='20140701' and crt_date<='20141231' 
group by item_id 

select item_id,kuaban from item_goujin where years='2014'

select item_name,i.item_id,sum(qty*i.rods)/50000 qty  from  item i,item_swhse a
where a.item_id=i.item_id group by item_name,i.item_id

select a.item_id,sum(qty_sold*i.rods)/50000 qty from dpt_sale_day2014 a,item i
where a.item_id=i.item_id    group by a.item_id 

select item_id,sum(qtycomfirm) qty from itemgoujin_list where 
crt_date>='20130701' and crt_date<='20131231' group by item_id

select i.item_id,sum(qty_sold*i.rods)/50000 benyue from dpt_sale_day2014 a,item i 
where a.item_id=i.item_id and substr(iss_date,1,6)=(select substr(to_char(sysdate,'yyyymmdd'),1,6) from dual) group by i.item_id having
sum(qty_sold)<>0

