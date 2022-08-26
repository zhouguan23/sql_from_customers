select * from di_where where isstatefl=1

select dpt_sale_id,sale_dept_id,short_name from dpt_sale 
where dpt_sale_id<>'17010100' 
${if(len(dptid)==0,""," and   dpt_sale_id in 
   ('"+dptid+"')")} 
 order by dpt_sale_id_new 

select cc.dpt_sale_id,cc.cust_type5 base_type,   
sum(a.qty_sold*i.t_size)/50000 qty from  plm_item i ,cust@orahzbo cc ,pi_cust_item_month a
 where i.item_id=a.item_id    and cc.cust_id=a.cust_id
 ${if(len(dili)==0,""," and cc.cust_type3 in ('"+dili+"')")}
 
  and  cc.dpt_sale_id in 
   ('${dptid}') 
and date1>='${date1}' and date1<='${date2}' 
group by cc.dpt_sale_id,cc.cust_type5

select cc.dpt_sale_id,cc.cust_type5 base_type,   
sum(a.qty_sold*i.t_size)/50000 qtyt from  plm_item i ,cust@orahzbo cc ,pi_cust_item_month a
 where i.item_id=a.item_id    and cc.cust_id=a.cust_id
 ${if(len(dili)==0,""," and cc.cust_type3 in ('"+dili+"')")}
 
  and  cc.dpt_sale_id in    ('${dptid}') 
and date1>=(select to_char(add_months(to_date('${date1}','yyyymm'),-12),'yyyymm' ) from dual)
 and date1<=(select to_char(add_months(to_date('${date2}','yyyymm'),-12),'yyyymm' ) from dual)
group by cc.dpt_sale_id,cc.cust_type5

select cc.dpt_sale_id,cc.cust_type5 base_type,   
sum(a.qty_sold*i.t_size)/50000 qtys from  plm_item i ,cust@orahzbo cc ,pi_cust_item_month a
 where i.item_id=a.item_id    and cc.cust_id=a.cust_id
 ${if(len(dili)==0,""," and cc.cust_type3 in ('"+dili+"')")}
 
  and   cc.dpt_sale_id in    ('${dptid}') 
and date1>=(select to_char( to_date('${date1}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
 and date1<=(select to_char( to_date('${date2}','yyyymm')-(to_date('${date2}','yyyymm')-to_date('${date1}','yyyymm')+1),'yyyymm') from dual)
group by cc.dpt_sale_id,cc.cust_type5

select cust_type5 base_type,dpt_sale_id,count(1)custnum from  cust 
where status='02' and dpt_sale_id in 
('${dptid}')  group by cust_type5,dpt_sale_id

select  DISTINCT   B.DICT_KEY  BASE_TYPE,B.DICT_VALUE  from co_cust cc,  base_dict  b 
where  cc.base_type=b.dict_key and b.dict_id='BASE_TYPE'
and cc.status='02' order by B.DICT_KEY desc

