select aa.dpt_sale_id,qty,pop from 
(
select * from pop_xian 
) aa,
(
select dpt_sale_id,sum(qty*i.rods)/200 qty from item i ,
(
select dpt_sale_id,item_id,sum(qty_sold) qty from item_dpt_sale_month
where date1>='${years2}01' and date1<='${years2}12'
group by dpt_sale_id,item_id having sum(qty_sold)<>0
) a where i.item_id=a.item_id group by dpt_Sale_id
) bb where aa.dpt_sale_id=bb.dpt_sale_id

select dpt_sale_id,sum(qty_sold)/250/255 avgday from item_dpt_sale_month where 
date1>=(select  to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyy')||'01' from dual)

 and date1<=(select  to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyy')||'12' from dual)
group by dpt_Sale_id

select dpt_sale_id,is_imported,sum(qty_sold*i.rods)/50000 qty,sum(amt_sold_with_tax) amt  from dpt_sale_day${years} a,item i
 where iss_date=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymmdd') from dual)
and a.item_id=i.item_id group by dpt_Sale_id,is_imported  having sum(qty_sold)<>0

select dpt_sale_id,is_imported,sum(qty*i.rods)/50000 qty,sum(amt) amt from 
(
select dpt_sale_id,item_id, sum(qty_sold) qty,sum(amt_sold_with_tax) amt  from dpt_sale_day${years}   where
 iss_date>=substr('${date1}',1,6)||'01' 
and iss_date<='${date1}'
 group  by  dpt_sale_id,item_id having sum(qty_sold)<>0
) a,item i where a.item_id=i.item_id group by dpt_sale_id,is_imported



select dpt_Sale_id,is_imported, sum(qty*i.rods/50000) qty, sum(amt) amt from item i ,
(
select dpt_sale_id,item_id,sum(qty_sold) qty,sum(amt_sold_with_tax) amt 
 from dpt_sale_day${years} where iss_date<='${date1}' group by dpt_sale_id,item_id having sum(qty_sold)<>0
) a where    a.item_id=i.item_id  group by dpt_Sale_id,is_imported

select dpt_Sale_id,is_imported, sum(qty*i.rods)/50000 qty,sum(amt) amt   from item i ,
(
select dpt_sale_id,item_id,sum(qty_sold) qty,sum(amt_sold_with_tax) amt 
 from dpt_sale_day${years2} where iss_date<=(select to_char(add_months(to_date(${date1},'yyyymmdd'),-12),'yyyymmdd') from dual) group by dpt_sale_id,item_id having sum(qty_sold)<>0
) a where    a.item_id=i.item_id  group by dpt_Sale_id,is_imported

select dpt_Sale_id,is_imported, sum(qty*i.rods)/50000 qty,sum(amt) amt   from item i ,
(
select dpt_sale_id,item_id,sum(qty_sold) qty,sum(amt_sold_with_tax) amt 
 from dpt_sale_day${years2} where 
iss_date>=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymm')||'01' from dual)

 and iss_date<=(select to_char(add_months(to_date('${date1}','yyyymmdd'),-12),'yyyymmdd') from dual)
 group by dpt_sale_id,item_id having sum(qty_sold)<>0
) a where    a.item_id=i.item_id  group by dpt_Sale_id,is_imported

select  thisyearpast, thismonthpast,daythismonth
from 
(
 select to_number(to_char(to_date('${date1}','yyyyMMdd'),'DDD'))   thisyearpast from  dual
),
(
  select to_number(to_char(to_date('${date1}','yyyyMMdd'),'DD') )  thismonthpast from  dual 
 ),
(
SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('${date1}','YYYYMMDD')),'dd')) daythismonth FROM DUAL

)

