select item_name from item i,item_com  ic
where i.item_id=ic.item_id and ic.short_id='${shortid}'

select i.item_id,class_id,id,group_name,qty from item_class a,item_com i 
where dpt_sale_id='17010100' and a.item_id=i.item_id  and qty<>0
and i.short_id='${shortid}'  order by class_id

select id,count(1) groupcust from class_cust  a,cust c ,item_com i,cust_item_qty b
where a.cust_id=c.cust_id and c.status='02' and   a.item_id=i.item_id and
a.cust_id=b.cust_id and b.item_id=i.item_id and  i.short_id='${shortid}'
and  fxdate='${crtdate}' 
group by id

select  cc.id,aa.qty_ord,
case when cust_type1='01' then '农村'
when cust_type1='02' then '乡镇'
when cust_type1='03' then '城区'
else  '未维护'  end as cust_type1,
count(aa.cust_id) qtyd  from  class_cust cc,item_com i ,cust c,

( select c.co_num ,cust_id,qty_ord,item_id from co${years}  c ,co_line${years} cl 
where c.co_num=cl.co_num and c.crt_date='${crtdate}'
) aa
where cc.cust_id=aa.cust_id and cc.item_id=aa.item_id and cc.item_id=i.item_id and cc.cust_id=c.cust_id
and i.short_id='${shortid}'    and  aa.cust_id in (select distinct cust_id from cust_item_qty where fxdate='${fxdate}')
group by cc.id,aa.qty_ord,cust_type1
    order by aa.qty_ord desc

select count(1) hushu from class_cust a,cust cc,item_com ic
where a.cust_id=cc.cust_id and a.item_id=ic.item_id
and cc.status='02' and ic.short_id='${shortid}'

