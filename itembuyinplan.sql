 
select item_id, sum(qty_ord)/5 qty  from  po   p,
 po_line  pl
 where p.po_num=pl.po_num and p.crt_date>='20130101' and crt_date<='20130630' and 
crt_date<(select to_char(sysdate-1,'yyyymmdd') from dual)
group by item_id 

select fact_id,substr(fact_name,1,4) fact_name,i.item_id,is_imported,itemgr_id, item_name,kind,pri_puh*1.17　prione,pri_wsale,ic.item_type1,ic.item_type2 from
 item i,item_com ic ,factory f where i.item_id=ic.item_id and ic.is_mrb=1
and  ic.com_id='10371701'  and i.factory=f.fact_id and item_kind=1

  order by fact_name desc,kind asc,pri_wsale desc

select item_id,qichushang,tzshang ,qichuxia,tzxia from item_goujin where years='2014'

select item_id, sum(qty_ord)/5 qty  from  po   p,
 po_line  pl
 where p.po_num=pl.po_num and p.crt_date>='20130701' and crt_date<='20131231' and 
crt_date<(select to_char(sysdate-1,'yyyymmdd') from dual)
group by item_id 

select i.item_id,qty,qty*i.rods/50000 qtyx from item_swhse a,item i 
 where a.item_id=i.item_id and qty<>0

select fact_id, fact_name from factory where fact_id in 
( select   vend_id from com_vend a,plm_item i,plm_item_com ic  where
 a.vend_id=i.factory and a.com_id='10371701' and i.item_id=ic.item_id and ic.com_id='10371701'
and factory<>'11310001' and i.is_mrb=1)
order by fact_name desc

select item_id, sum(qty_ord)/5  qtytoday  from  po  p,
 po_line  pl
 where p.po_num=pl.po_num and 
crt_date=(select to_char(sysdate,'yyyymmdd') from dual)
group by item_id 

