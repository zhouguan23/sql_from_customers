select distinct cust_seg from co_cust where status='02' order by cust_seg

with cc as (  

select slsman_id,sum(a.qty_sold)/250 qty,sum(amt) amt   from co_cust b,cust_sold a
where  a.cust_id=b.cust_id  

${if(len(dptid)==0, "", " and b.sale_dept_id='"+dptid+"'")}
 and a.date1>=(select dayf from year_week where year1='${byseason}')
and a.date1<=(select daye from year_week where year1='${byseason}')
    group by slsman_id
 )

 
select dpt_sale_id,fwzid,fwzname,struid,struname,sum(qty)  qtyben,sum(amt) amt  from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,struid,struname

select year1,yname from year_week  where year1>'20174'

with cc as (  

select slsman_id,sum(a.qty_sold)/250 qty ,sum(amt) amt  from co_cust b,cust_sold a
where  a.cust_id=b.cust_id 
${if(len(dptid)==0, "", " and b.sale_dept_id='"+dptid+"'")}

 and a.date1>=(select dayts from year_week where year1='${byseason}')
and a.date1<=(select dayte from year_week where year1='${byseason}')

    group by slsman_id
 )
 
select dpt_sale_id,fwzid,fwzname,struid,struname ,sum(qty) qtys,sum(amt) amts  from strutofwz a,cc where a.slsman_id=cc.slsman_id
group by dpt_sale_id,fwzid,fwzname,struid,struname

select qty_plan/250 benall,amt_plan  from plan where date1=substr('${byseason}',1,4)||'  ' 
and stru_id='${dptid}'

select qty_plan/250 qtytall,amt_plan amtt from plan 
where date1=(select substr(yeart,1,4)||'  ' from year_week where year1='${byseason}')
and stru_id='${dptid}'

select distinct fwzid,fwzname,struid,struname from strutofwz
${if(len(dptid)==0,"", " where dpt_sale_id='"+dptid+"'") }
order by fwzid,struid

