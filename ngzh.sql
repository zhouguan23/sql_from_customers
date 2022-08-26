select c.cust_id,cust_short_name,busi_addr ,

case
when c.cust_type3='011' or c.cust_type3='11' or c.cust_type3='12'  then '城区'
when c.cust_type3='012' or c.cust_type3='013' or c.cust_type3='31' or c.cust_type3='32'
or c.cust_type3='21'    then '乡镇'

when (c.cust_type3>='41' and  c.cust_type3<='46' )  or  c.cust_type3='023' or c.cust_type3='024'  then '农村'  else    'qt'   end dili,cust_seg,
qty1 ,item_name from co_cust c,plm_item i,
(
select cust_id,item_id,sum(qty_sold)  qty1 from pi_cust_item_month
where date1='${date1}' and item_id in ('6901028075022','6901028075015') group by cust_id,item_id having sum(qty_sold)>=${qty1}
) a where c.cust_id=a.cust_id and a.item_id=i.item_id
 order by qty1 desc,cust_id

select item_id,item_name from plm_item where item_id in ('6901028075022','6901028075015') 

