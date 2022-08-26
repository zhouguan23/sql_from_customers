select  '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,  short_name from dpt_sale   where  dpt_sale_id<>'17010100' and com_id='10371701' order by dpt_sale_id_new


select dpt_sale_id, cust_type1 ,note,count(1) countcust from
(select  distinct c.cust_id,c.sale_dept_id dpt_sale_id,sl.note,cust_type1,trade_date from co_trans_flow  a,co_cust c,slsman sl  
   where a.cust_id=c.cust_id  and c.slsman_id=sl.slsman_id and sl.com_id='10371701'
 and c.status='02' and trade_date>='${starttime}'
and trade_date<='${endtime}'
)

group by dpt_sale_id, cust_type1,note



select dpt_sale_id, cust_type1 ,note,count(1) countcust from
(select  distinct c.cust_id,c.sale_dept_id dpt_sale_id,sl.note,cust_type1,trade_date from co_trans_flow  a,co_cust c,slsman sl  
   where a.cust_id=c.cust_id  and c.slsman_id=sl.slsman_id and sl.com_id='10371701'
 and c.status='02'  and trade_date>='${starttime}'
and trade_date<='${endtime}' and trade_flag=0
)

group by dpt_sale_id, cust_type1,note



select sls.dpt_sale_id,sls.note,count(1) from slsman sls,co_cust c
where sls.slsman_id=c.slsman_id  and c.status='02' group by sls.dpt_sale_id,sls.note

