select i.item_id,item_name,ic.short_code||'-'||item_name  from plm_item i,plm_item_com 
ic
where i.item_id=ic.item_id and i.is_mrb=1 and ic.is_mrb=1 and ic.com_id='10371701'
and i.item_kind=1
order by i.brdowner_id,ic.price_trade desc

select item_id,sum(qty_ord)/250 qty1,count(co_num) djcount1 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>=${qty1}
and qty_ord<=${qty2}
) group by item_id

select item_id,sum(qty_ord)/250 qty2,count(co_num) djcount2 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>${qty2}
and qty_ord<=${qty3}
) group by item_id

select item_id,sum(qty_ord)/250 qty3,count(co_num) djcount3 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>${qty3}
and qty_ord<=${qty4}
) group by item_id

select item_id,sum(qty_ord)/250 qty4,count(co_num) djcount4 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>${qty4}
and qty_ord<=${qty5}
) group by item_id

select item_id,sum(qty_ord)/250 qty5,count(co_num) djcount5 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>${qty5}
and qty_ord<=${qty6}
) group by item_id

select item_id,sum(qty_ord)/250 qty6,count(co_num) djcount6 from 

(select c.co_num,item_id,qty_ord from co_co c,co_co_line cl
where c.co_num=cl.co_num and c.born_date>='${date1}' 
and c.born_date<='${date2}' and c.status<>'90'
and item_id='${itemid}' and  qty_ord>${qty6}
and qty_ord<=${qty7}
) group by item_id

select item_id,item_name from plm_item where item_id='${itemid}'

