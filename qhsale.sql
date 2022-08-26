select a.sale_dept_id,nccust,ncco,round(ncco/nccust*100,2) ncbl,ncqty,ncqty12 from 
(
select sale_dept_id,count(1) nccust from co_cust c,csc_cust_orderdate_view cc 
where c.status='02' and (cust_type3='023' or cust_type3='024' or ( cust_type3>='41' and cust_type3<='45')  )
and c.cust_id=cc.cust_id and cc.call_date='${date1}'  
group by sale_dept_id
) a,
(
select c.sale_dept_id,count(distinct co.co_num) ncco,sum(qty_ord*t_size)/50000 ncqty from co_co co,co_co_line cl,co_cust c ,plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and  (cust_type3='023' or cust_type3='024' or ( cust_type3>='41' and cust_type3<='45')  ) and i.item_id=cl.item_id    and c.cust_id=co.cust_id and co.co_num=cl.co_num    
 group by c.sale_dept_id
) b,
(
select c.sale_dept_id, sum(qty_ord*t_size)/50000 ncqty12 from co_co co,co_co_line cl,co_cust c, plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and  (cust_type3='023' or cust_type3='024' or ( cust_type3>='41' and cust_type3<='45')  )  and i.item_id=cl.item_id    and c.cust_id=co.cust_id and co.co_num=cl.co_num    and i.kind in (${kind})
 group by c.sale_dept_id
) c

 where a.sale_dept_id=b.sale_dept_id and c.sale_dept_id(+)=a.sale_dept_id

select a.sale_dept_id,cqcust,cqco,round(cqco/cqcust*100,2) cqbl,cqqty,cqqty12 from 
(
select sale_dept_id,count(1) cqcust from co_cust c,csc_cust_orderdate_view cc
where c.status='02' and (cust_type3='011' or cust_type='11' or cust_type='12' or cust_type='21')
and c.cust_id=cc.cust_id   and cc.call_date='${date1}'
group by sale_dept_id
) a,
(
select c.sale_dept_id,count(distinct co.co_num) cqco,sum(qty_ord*t_size)/50000 cqqty from co_co co,co_co_line cl,co_cust c ,plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and 
(cust_type3='011' or cust_type='11' or cust_type='12' or cust_type='21')  and i.item_id=cl.item_id and  cust_type3<='23' and  c.cust_id=co.cust_id and co.co_num=cl.co_num  
 group by c.sale_dept_id
) b ,
(
select c.sale_dept_id, sum(qty_ord*t_size)/50000 cqqty12 from co_co co,co_co_line cl,co_cust c, plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and (cust_type3='011' or cust_type='11' or cust_type='12' or cust_type='21')  and i.item_id=cl.item_id and   c.cust_id=co.cust_id and co.co_num=cl.co_num     and i.kind in (${kind})
 group by c.sale_dept_id
) c
where a.sale_dept_id=b.sale_dept_id and c.sale_dept_id(+)=a.sale_dept_id

select a.sale_dept_id,xzcust,xzco,round(xzco/xzcust*100,2) xzbl,xzqty,xzqty12 from 
(
select sale_dept_id,count(1) xzcust from co_cust c,csc_cust_orderdate_view cc 
where c.status='02' and ( (cust_type3>='012' and cust_type3<='013') or ( cust_type3>='31' and cust_type3<='32'))
and c.cust_id=cc.cust_id and cc.call_date='${date1}' 
group by sale_dept_id
) a,
(
select c.sale_dept_id,count(distinct co.co_num) xzco,sum(qty_ord*t_size)/50000 xzqty from co_co co,co_co_line cl,co_cust c ,plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and ( (cust_type3>='012' and cust_type3<='013') or ( cust_type3>='31' and cust_type3<='32')) and i.item_id=cl.item_id   and c.cust_id=co.cust_id and co.co_num=cl.co_num  
 group by c.sale_dept_id
) b,
(
select c.sale_dept_id, sum(qty_ord*t_size)/50000 xzqty12 from co_co co,co_co_line cl,co_cust c, plm_item i where co.status<>'90'
and co.born_date='${date1}' and  c.status='02' and ( (cust_type3>='012' and cust_type3<='013') or ( cust_type3>='31' and cust_type3<='32')) and i.item_id=cl.item_id   and c.cust_id=co.cust_id and co.co_num=cl.co_num    and i.kind in (${kind})
 group by c.sale_dept_id
) c
where a.sale_dept_id=b.sale_dept_id and c.sale_dept_id(+)=a.sale_dept_id

select c.sale_dept_id,count(distinct c.cust_id) cqcustdh
 from pi_cust_item_day a,plm_item i,co_cust c
 where a.item_id=i.item_id and a.cust_id=c.cust_id  and a.qty_sold<>0
and (cust_type3='011' or cust_type='11' or cust_type='12' or cust_type='21')
  and i.kind in (${kind})
 and  date1=(select to_char(to_date('${date1}','yyyyMMdd')+1,'yyyyMMdd') from dual) group by c.sale_Dept_id

select c.sale_dept_id,count(distinct c.cust_id) nccustdh
 from pi_cust_item_day a,plm_item i,co_cust c
 where a.item_id=i.item_id and a.cust_id=c.cust_id  and a.qty_sold<>0
and  (cust_type3='023' or cust_type3='024' or ( cust_type3>='41' and cust_type3<='45')  )
  and i.kind in (${kind})
 and  date1=(select to_char(to_date('${date1}','yyyyMMdd')+1,'yyyyMMdd') from dual) group by c.sale_Dept_id

select c.sale_dept_id,count(distinct c.cust_id) xzcustdh
 from pi_cust_item_day a,plm_item i,co_cust c
 where a.item_id=i.item_id and a.cust_id=c.cust_id  and a.qty_sold<>0
and ( (cust_type3>='012' and cust_type3<='013') or ( cust_type3>='31' and cust_type3<='32'))
  and i.kind in (${kind})
 and  date1=(select to_char(to_date('${date1}','yyyyMMdd')+1,'yyyyMMdd') from dual) group by c.sale_Dept_id

