
  select ic.short_code ,item_name  ,sum(cl.qty_ord)  qty 
  from co_co c,co_co_line cl,plm_item_com ic,plm_item i ,ldm_dist_region lr,
  ldm_cust_dist  lc
  where c.co_num=cl.co_num and c.status<>'90'  and c.type<>'62'
  and cl.item_id=i.item_id and cl.item_id=ic.item_id 
  and c.born_date='${date1}'  and cl.qty_ord<>0 and
  lc.cust_id=c.cust_id and lc.rut_id=lr.region_id  
    
  ${if(len(deliverid)==0,"","  and  lr.deliver_id='"+deliverid+"'")}
  
 
  and cl.item_id in (select item_id from hz_item_abnormal)
 
   group by ic.short_code  ,item_name

select dpt_sale_name from dpt_sale where dpt_sale_id='${deliverid}'

