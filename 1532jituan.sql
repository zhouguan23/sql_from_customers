 select im.item_name,
          ic.short_code,
          sum(p.qty_sold) a,sum(p.amt_sold) b
     from co_cust ct,pi_cust_item_day p,plm_item im,plm_item_com ic
     where  
           p.cust_id=ct.cust_id and
           p.item_id=im.item_id and im.item_id=ic.item_id and 
          p.date1>='${time1}' and
          p.date1<='${time2}' and
        ic.com_id='10371701' and
   ct.cust_id<>'1037170312899' and 
ct.cust_id<>'1037170906145' and 
             ct.cust_name like '${cust_name}'
     group by im.item_name,
          ic.short_code  having sum(p.qty_sold)<>0
     order by ic.short_code

 select ct.cust_id,cust_name,im.item_name,
          ic.short_code,
          sum(p.qty_sold) qty,sum(p.amt_sold) amt
     from co_cust ct,pi_cust_item_day p,plm_item im,plm_item_com ic
     where   p.cust_id=ct.cust_id and
           p.item_id=im.item_id and
           p.date1>='${time1}' and
           p.date1<='${time2}' and
           im.item_id=ic.item_id and
           ic.com_id='10371701'  and ct.cust_id<>'1037170312899'   and 
ct.cust_id<>'1037170906145'
           and  ct.cust_name like '${cust_name}'
     group by ct.cust_id,cust_name,im.item_name,
          ic.short_code  having sum(p.qty_sold)<>0
     order by ct.cust_id, im.item_name ,ic.short_code
           

 select dp.short_name,im.item_name,
          ic.short_code,
          sum(p.qty_sold) a,sum(p.amt_sold) b
     from co_cust ct,pi_cust_item_day p,plm_item im,plm_item_com ic,dpt_sale dp
     where   ct.sale_dept_id=dp.dpt_sale_id and 
           p.cust_id=ct.cust_id and
           p.item_id=im.item_id and im.item_id=ic.item_id and 
          p.date1>='${time1}' and
          p.date1<='${time2}' and
        ic.com_id='10371701' and
   ct.cust_id<>'1037170312899' and 
ct.cust_id<>'1037170906145' and 
             ct.cust_name like '${cust_name}'
     group by dp.short_name,im.item_name,
          ic.short_code  having sum(p.qty_sold)<>0
     order by dp.short_name,ic.short_code

