select distinct  sls.slsman_id,sls.note from slsman sls ,co_cust c
 where  sls.com_id='10371701' and  c.sale_dept_id in ('${dptno}') and c.slsman_id=sls.slsman_id
 and c.status='02'
  
 

select slsman_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im 
   where isd.cust_id=im.cust_id and date1>='${time1}' 
        and date1<='${time2}'
        and im.sale_dept_id in ('${dptno}')
       

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by slsman_id

select slsman_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt2
   from pi_cust_item_month isd,co_cust im 
   where isd.cust_id=im.cust_id and date1>='${time3}' 
        and date1<='${time4}'
        and im.sale_dept_id in ('${dptno}')
    
   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by slsman_id

select i.item_id,ic.short_id||'-'||item_name itemname from item i,
item_com ic where i.item_id=ic.item_id and ic.com_id='10371701'
and i.is_mrb=1 and i.item_kind=1 order by ic.short_id

select ${pri} from dual

