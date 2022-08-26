select ic.short_code ,item_name  ,sum(li.qty)  qty 
  from ldm_dist ld,ldm_dist_item li,plm_item_com ic,plm_item i
  where  ld.dist_num=li.dist_num
  and li.item_id=ic.item_id
  and li.item_id=i.item_id
  and ic.com_id='10371701'
  and ld.dist_date=(select to_char(to_date('${date1}','yyyy-mm-dd')+1,'yyyymmdd')from dual)  and li.qty>0
  ${if(len(deliverid)==0,"","and  ld.deliver_id='"+deliverid+"'")}
  and li.item_id in (select item_id from hz_item_abnormal)
  group by  ic.short_code ,item_name
  
  
  
  

select dpt_sale_name from dpt_sale where dpt_sale_id='${deliverid}'

