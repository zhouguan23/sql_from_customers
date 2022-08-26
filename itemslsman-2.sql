select im.cust_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im , hz_cust_view    a
   where isd.cust_id=im.cust_id and a.cust_id=im.cust_id and im.slsman_id='${sls}'
   and a.calls='${calls}'
   and date1>='${time1}' and date1<='${time2}' 
 and im.status='02'  

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by im.cust_id

  

select c.cust_id,cust_short_name from co_cust c, hz_cust_view cs
  where cs.cust_id=c.cust_id and c.slsman_id='${sls}' and c.status='02'
  and cs.calls='${calls}' 

select im.cust_id,sum(isd.qty_sold) qty1,sum(isd.amt_sold) amt
   from pi_cust_item_month isd,co_cust im , hz_cust_view     a
   where isd.cust_id=im.cust_id and a.cust_id=im.cust_id and im.slsman_id='${sls}'
      and a.calls='${calls}'
   and date1>='${time3}' and date1<='${time4}' 
 and im.status='02'  

   ${if(len(item_id)==0,"", " and isd.item_id='"+item_id+"'")}
   group by im.cust_id


select ${pri} from dual

select years,years2 from 
(
select to_char(sysdate,'yyyy') years from dual
),
(
SELECT  TO_CHAR(add_months(to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd'),-12),'YYYY' ) years2 FROM DUAL
)

