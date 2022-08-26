select c.cust_id,cust_short_name,busi_addr,order_tel tel,
ic.short_code short_id,i.item_name,qty*i.t_size/200 qty,sls.note slsname
  from co_cust  c,plm_item i,plm_item_com ic,slsman sls,
(
select c.cust_id,item_id,sum(qty_ord) qty from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.status in ('30','40','50','60')
and c.born_date>='${date1}' and c.born_date<='${date2}'
${ if(len(c.sale_dept_id)==0,""," and c.sale_dept_id='"+dptno+"'")}
${ if(len(slsmanid)==0,""," and c.slsman_id='"+slsmanid+"'")}
${ if(len(custid)==0,""," and c.cust_id='"+custid+"'")}
 group by  c.cust_id,item_id having sum(qty_ord)<>0
) b where b.cust_id=c.cust_id and i.item_id=b.item_id and i.item_id=ic.item_id and ic.com_id='10371701' and c.slsman_id=sls.slsman_id 
and sls.com_id='10371701' 
${ if(len(shortid)==0,""," and ic.short_code='"+shortid+"'")}

