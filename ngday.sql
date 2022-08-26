select ic.short_code,c.born_date,item_name,cl.price,sum(cl.qty_ord) qty  from  co_co c,co_co_line cl,plm_item i ,plm_item_com ic where c.co_num=cl.co_num and cl.qty_ord<>0  and 
cl.item_id=i.item_id and i.item_id=ic.item_id and  ic.com_id='10371701' and 
 c.born_date>='${date1}' and c.born_date<='${date2}' and c.status<>'90' and c.cust_id in  
(select cust_id from co_cust where license_code='${liceid}' or cust_id='${liceid}')
group by ic.short_code,c.born_date,item_name,cl.price  order by c.born_date,cl.price desc

select c.cust_id,c.license_code,cust_name,order_tel,sls.note,busi_addr,
case when pay_type='20' then '电结户' else '非电结户' end as js, 
case when cc.domain_id='HZ001' then '电访户'
else  '网订户' end  as dhfs, cust_type4 from co_cust c,csc_cust cc,slsman sls
where c.slsman_id=sls.slsman_id and cc.cust_id=c.cust_id and  (license_code='${liceid}' or c.cust_id='${liceid}')

