
  select c.cust_id,cust_short_name,busi_addr,tel,cust_type1,sls.note,qty from cust c,item_com ic,slsman sls,
  (
  select cust_id,item_id ,qty from cust_item_qty where   fxdate='${date1}' and  qty<>0
  ) aa where c.cust_id=aa.cust_id and aa.item_id=ic.item_id and ic.short_id='${shortid}' and c.slsman_id=sls.slsman_id

select cust_id,qty_ord from co c ,co_line cl,item_com ic
where c.co_num=cl.co_num and c.status<>'08'
and c.crt_date='${date1}' and cl.item_id=ic.item_id
and ic.com_id='10371701' and ic.short_id='${shortid}'

select item_name from item i,item_com ic
where i.item_id=ic.item_id and ic.short_id='${shortid}'

