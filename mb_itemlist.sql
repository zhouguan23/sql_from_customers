
select i.item_id,ic.short_code ,item_name,kind,pack_kind ,(qty*i.t_size)/50000 qty, price_trn,
price_trade  ,price_retail   from plm_item i,plm_item_com ic,pi_item_invty p 
where i.item_id=ic.item_id and  ic.com_id='10371701' and i.item_id=p.item_id and p.com_id='10371701' and ic.short_code<>'000000' 
 and ic.is_mrb=1 and i.is_mrb=1   and p.qty<>0
order by   price_trade desc

 select i.item_id,sum(qty_ord*t_size)/50000 aqty 
 from co_co c,co_co_line cl ，plm_item i 
 where c.co_num=cl.co_num and
 i.item_id=cl.item_id and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and c.status<>'90' and qty_ord<>0  group by i.item_id 

 with cc as 
 (
 select co_num from ldm_dist a,ldm_dist_line b where a.dist_num=b.dist_num and a.dist_date=(select to_char(sysdate+1,'yyyyMMdd') from dual)
 )
 
 select i.item_id,sum(qty_ord*t_size)/50000 aqty 
 from co_co c,co_co_line cl ,plm_item i,cc
 where c.co_num=cl.co_num and c.co_num=cc.co_num and  
 i.item_id=cl.item_id and c.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and c.status<>'90' and qty_ord<>0  group by i.item_id 
 
 

