select dPT_sale_ID,sum(qty_sold*t_size)/50000 qtyday from plm_item p,item_dpt_Sale_day a
where p.item_id=a.item_id
and date1='${date1}' group by dPT_sale_ID

select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qty,
sum(id.amt_sold_with_tax) amt,

sum(id.gross_profit) pro
from item_dpt_sale_day id,plm_item im
where id.date1>=(select substr('${date1}',1,6)||'01' from dual)
and id.date1<='${date1}'
and id.item_id=im.item_id
group by id.dpt_sale_id

select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qty 
 
 
from item_dpt_sale_day id,plm_item im
where id.date1>=(select substr( '${date1}', 1,6)||'01' from dual)
and id.date1<='${date1}'
and kind<=2
and id.item_id=im.item_id
group by id.dpt_sale_id

select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qty
from item_dpt_sale_month id,plm_item im
where id.date1=(select substr(to_char(add_months(to_date('${date1}','yyyymmdd'),-1),'yyyymmdd'),1,6) from dual)
and id.item_id=im.item_id
group by id.dpt_sale_id

select days
from sale_days
where date1=(select  to_char(add_months(to_date('${date1}','yyyymmdd'),-1),'yyyyMM') from dual)


select count(1) days from(
select date1,sum(qty_sold)/250 qty
from item_dpt_sale_day
where date1>=(select  to_char(to_date('${date1}','yyyyMMdd'),'yyyyMM')||'01' from dual)
and date1<='${date1}'
group by date1)
where qty>200


select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qty,
sum(amt_sold_with_tax) amt,sum(gross_profit) pro
from item_dpt_sale_month id,plm_item im
where id.date1>=(select  substr('${date1}',1,4)||'01' from dual)
and id.date1<=(select  to_char(add_months(to_date('${date1}','yyyy-mm-dd'),-1),'yyyyMM') from dual)
and id.item_id=im.item_id
group by id.dpt_sale_id


select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,qty_plan/250 qtyplan,dxamt_plan
from plan
where type='01'
and date1=(select substr('${date1}',1,6) from dual)

select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,qty_plan/250 qtyplan,dxamt_plan
from plan
where type='03'
and date1=(select substr('${date1}',1,4)||'  ' from dual)

 

select count(1) saledays from (
select date1,sum(qty_sold) from pi_dept_item_day 
where date1>=(select to_char(to_date('${date1}','yyyymmdd'),'yyyymm')||'01' from dual)
and date1<='${date1}'  and qty_sold<>0 group  by  date1
)

select to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyy')||'1231','yyyy-mm-dd')
- to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyy')||'0101','yyyy-mm-dd')+1 yeard
 from dual

select to_date( '${date1}' ,'yyyy-mm-dd')
- to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyyMM')||'01','yyyy-mm-dd')+1 yuepast
 from dual

select last_day(to_date('${date1}','yyyy-mm-dd'))-to_date(to_char(substr('${date1}',1,6)||'01' ),'yyyy-mm-dd')+1 daythismonth from dual


select days from  sale_days where date1=substr('${date1}',1,6)

select to_date('${date1}','yyyy-mm-dd')- to_date(to_char(to_date('${date1}','yyyymmdd'),'yyyy')||'0101','yyyy-mm-dd')+1 daypasthisyear
from dual

select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qtyyear 

from item_dpt_sale_day id,plm_item im
where id.date1>=(select substr('${date1}',1,4)||'0101' from dual)
and id.date1<='${date1}'
and kind<=2
and id.item_id=im.item_id
group by id.dpt_sale_id

select id.dpt_sale_id,sum(id.qty_sold*im.t_size)/50000 qtyyear,
sum(amt_sold_with_tax) amt,
sum(gross_profit) profit

from item_dpt_sale_day id,plm_item im
where id.date1>=(select substr('${date1}',1,4)||'0101' from dual)
and id.date1<='${date1}'
 and id.item_id=im.item_id
group by id.dpt_sale_id

select planyue,planyear from 
(
select  dxamt_plan planyear
from plan where type='04'
and date1=(select substr('${date1}',1,4) from dual)||'  ' 
),
(
select  dxamt_plan planyue
from plan where type='02'
and date1=(select substr('${date1}',1,6) from dual)  
)


select sale_dept_id,i.kind,sum(qty_sold*t_size)/50000 qtyday,sum(qty_sold_month*t_size)/50000  qtymonth,sum(qty_sold_year*t_size)/50000 qtyyear,sum(amt_sold_month) amtmonth,sum(amt_sold_year) amtyear,sum(gross_sold_month) mlmonth,sum(gross_sold_year) mlyear from pi_dept_item_day  a,plm_item i
where  a.item_id=i.item_id and date1='${date1}' group by sale_dept_id,i.kind

