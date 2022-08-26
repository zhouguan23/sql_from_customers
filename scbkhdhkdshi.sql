select distinct cust_seg from co_cust where status='02' order by cust_seg

 

select b.sale_dept_id dpt_sale_id,sum(a.hdkd) qty,sum(a.hdcs) amt  from custdhkd a,co_cust b
where  a.cust_id=b.cust_id    
 and a.date1>=(select dayf from year_week where year1='${byseason}')
and a.date1<=(select daye from year_week where year1='${byseason}')

and b.cust_id in (select cust_id from custseg  c where 
  c.date1=(select year1 from year_week where year1='${byseason}')
 and c.cust_seg>='${custseg1}' and c.cust_seg<='${custseg2}'
 )   group by b.sale_Dept_id
 
 

select year1,yname from year_week  where year1>'20174'

 

select  b.sale_dept_id  dpt_sale_id,sum(a.hdkd) qty,sum(a.hdcs) amt  from custdhkd a,co_cust b
where  a.cust_id=b.cust_id  
 and a.date1>=(select daysf from year_week where year1='${byseason}')
and a.date1<=(select dayse from year_week where year1='${byseason}')

and b.cust_id in (select cust_id from custseg  c where 
  c.date1=(select year2 from year_week where year1='${byseason}')
 and c.cust_seg>='${custseg1}' and c.cust_seg<='${custseg2}'
 )   group by b.sale_dept_id
 
  

with cc as (
select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt  from cust_sold  a,co_cust b 
where  a.cust_id=b.cust_id  and a.dpt_sale_id='${dptid}'
 
  and a.date1>=(select daysf from year_week where year1='${byseason}')
and a.date1<=(select dayse from year_week where year1='${byseason}') group by slsman_id )
 
select dpt_sale_id,fwzid,fwzname,a.slsman_id,sum(qty) qtysall ,sum(amt) amtsall from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,a.slsman_id

