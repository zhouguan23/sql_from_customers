select fl,substr(fl,2,10) fl1,item_name,pri_wsale,sale_dept_id,sum(qty*t_size)/50000 qty from plm_item i,
(
select item_id,c.sale_dept_id,sum(cl.qty_ord) qty  from  co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${time1}' and c.born_date<='${time2}' 
and c.status<>'90'
 group by item_id,c.sale_dept_id having sum(qty_ord)<>0
 ) a,
 
(select item_id,pri_wsale,item_type1 fl from item_com@orahzbo order by item_type1)
 b where  a.item_id=i.item_id  and  a.item_id=b.item_id group by fl ,substr(fl,2,10),item_name,pri_wsale,sale_dept_id order by fl,pri_wsale desc

