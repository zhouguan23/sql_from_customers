select calls,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im ,
   hz_cust_view a
   where isd.cust_id=im.cust_id and a.cust_id=im.cust_id and im.slsman_id='${sls}'
   and date1>='${time1}'         and date1<='${time2}'
  
   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by calls

  

select calls,count(1) custnum from  hz_cust_view a,co_cust c where a.cust_id=c.cust_id and c.slsman_id='${sls}' and c.status='02'
 group by calls order by calls

select calls,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im ,
     hz_cust_view  a
   where isd.cust_id=im.cust_id and a.cust_id=im.cust_id and im.slsman_id='${sls}'
   and date1>='${time3}' 
        and date1<='${time4}'
           

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by calls

select note from slsman where slsman_id='${sls}'

select ${pri} from dual

