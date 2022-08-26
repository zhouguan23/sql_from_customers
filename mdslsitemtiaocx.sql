select sale_dept_id,short_name from dpt_sale 
where dpt_sale_id<>'17010100' 
  and   sale_dept_id='${dptid}' 
 order by dpt_sale_id_new 

select slsman_id,count(distinct cust_id) djcust
  from   pi_cust_item_bnd_day  
 where   slsman_id in ('${sls}') 

and date1>='${date1}' and date1<='${date2}' 
group by slsman_id

select slsman_id,count(distinct cust_id) djitemcust,sum(qty_sold*t_size)/50000 qty
  from   pi_cust_item_bnd_day  a,plm_item i 
 where  a.item_id=i.item_id and  slsman_id in ('${sls}') 
  and i.item_id='${itemid}' and qty_sold<>0
and date1>='${date1}' and date1<='${date2}' 
group by slsman_id

select slsman_id,dp.short_name||'-'||sls.note ,dpt_sale_id_new from   slsman sls,dpt_sale dp
where sls.dpt_sale_id=dp.dpt_sale_id
and dp.sale_dept_id='${dptid}' order by dp.dpt_sale_id_new,slsman_id

select  item_id,item_name from  plm_item i 
where item_id in ('${itemid}')

select ic.item_id,item_name,ic.short_id||'-'||item_name||'-'||pri_wsale  from item_com ic,plm_item i 
where ic.item_id=i.item_id  and ic.is_mrb=1 order by ic.short_id

select sls.slsman_id,sls.note,count(cust_id) custall from slsman sls,co_cust cc 
where sls.slsman_id=cc.slsman_id and cc.status='02' and sls.slsman_id in ('${sls}')
group by sls.slsman_id,sls.note

