select distinct cust_seg from co_cust where status='02' order by cust_seg

with cc as (
select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt  from cust_sold  a,co_cust b,custseg c
where  a.cust_id=b.cust_id and a.cust_id=c.cust_id and a.dpt_sale_id='${dptid}'
and c.date1=(select year1 from year_week where year1='${byseason}')
 and c.cust_seg between '${custseg1}' and '${custseg2}' 
 and c.date1='${byseason}' and a.date1>=(select dayf from year_week where year1='${byseason}')
and a.date1<=(select daye from year_week where year1='${byseason}') group by slsman_id )
 
select dpt_sale_id,fwzid,fwzname,a.slsman_id,sum(qty)  qtyben,sum(amt) amtben from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,a.slsman_id

select year1,yname from year_week  where year1>'20174'

with cc as (
select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt  from cust_sold  a,co_cust b,custseg c
where  a.cust_id=b.cust_id and a.cust_id=c.cust_id and a.dpt_sale_id='${dptid}'
and c.date1=(select year2 from year_week where year1='${byseason}')
 and c.cust_seg  between '${custseg1}' and '${custseg2}'
 
 and a.date1>=(select daysf from year_week where year1='${byseason}')
and a.date1<=(select dayse from year_week where year1='${byseason}') group by slsman_id )
 
select dpt_sale_id,fwzid,fwzname,a.slsman_id ,sum(qty) qtys,sum(amt) amts from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,a.slsman_id

with cc as (
select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt  from cust_sold  a,co_cust b 
where  a.cust_id=b.cust_id  and a.dpt_sale_id='${dptid}'
 
  and a.date1>=(select dayf from year_week where year1='${byseason}')
and a.date1<=(select daye from year_week where year1='${byseason}') group by slsman_id )
 
select dpt_sale_id,fwzid,fwzname,a.slsman_id,sum(qty) qtybenall ,sum(amt) amtbenall from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,a.slsman_id

with cc as (
select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt  from cust_sold  a,co_cust b 
where  a.cust_id=b.cust_id  and a.dpt_sale_id='${dptid}'
 
  and a.date1>=(select daysf from year_week where year1='${byseason}')
and a.date1<=(select dayse from year_week where year1='${byseason}') group by slsman_id )
 
select dpt_sale_id,fwzid,fwzname,a.slsman_id,sum(qty) qtysall ,sum(amt) amtsall from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,a.slsman_id

select fwzid,fwzname,slsman_id,slsman_name from strutofwz where dpt_sale_id='${dptid}'
order by fwzid,slsman_id

