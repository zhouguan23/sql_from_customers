select '1137'||substr(dpt_sale_id,1,4) sale_dept_id ,qty_plan/250 qtyplan,
dxamt_plan,case when days is null then 0 else qty_plan/250/days end avgqtyplan
from plan a,sale_days b where a.type='01'
and a.date1=(select to_char(sysdate-1,'yyyyMM') from dual)
and b.date1=(select to_char(sysdate-1,'yyyyMM') from dual)


select a.sale_dept_id,sum(qty_sold*t_size)/50000 qtyday ,case when sum(qty_sold)<=0 then 0 else round(sum(amt_sold)*50000/sum(qty_sold*t_size),0) end  dxamtday,sum(amt_sold) amt from pi_dept_item_day a ,plm_item i
where a.item_id=i.item_id 
and date1=(select to_char(sysdate,'yyyyMMdd') from dual)  
group by a.sale_dept_id

select a.sale_dept_id,sum(qty_sold*t_size)/50000 qtymonth,
sum(amt_sold) amtmonth
 from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id 
and date1>=(select substr(to_char(sysdate,'yyyyMMdd'),1,6)||'01' from dual)
and date1<=(select to_char(sysdate,'yyyyMMdd') from dual)
group by a.sale_dept_id


select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold*t_size)/50000 qtyyear,
sum(amt_sold_with_tax) amtyear
 from dpt_sale_day2015 a,plm_item i 
where a.item_id=i.item_id 
 
group by  '1137'||substr(dpt_sale_id,1,4)

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id ,qty_plan/250 yearplan,
dxamt_plan yeardx  
from plan   where type='03'
and  date1='2015'


select sale_dept_id,sum(tsday) tsday from (
select cc.sale_dept_id,sum(cl.qty_ord)/250 tsday  from co_co cc,co_co_line cl
where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and item_id in 
('6901028157216','6901028156783','6901028148955' ) 
group by cc.sale_dept_id
union
select cc.sale_dept_id,sum(cl.qty_ord)/250*2 tsday  from co_co cc,co_co_line cl
where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and item_id='6901028150194' 
group by cc.sale_dept_id
) group  by sale_dept_id



select sale_dept_id,sum(tsmonth) tsmonth  from (
select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold)/250 tsmonth
 from dpt_sale_day2015 
where iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and item_id in ('6901028157216','6901028156783','6901028148955')
group by  '1137'||substr(dpt_sale_id,1,4)

union
select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold)/250*2 tsmonth
 from dpt_sale_day2015 
where iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and item_id='6901028150194' group by  '1137'||substr(dpt_sale_id,1,4)
) group by sale_dept_id

select cc.sale_dept_id,sum(cl.qty_ord)/250 hhlday  from co_co cc,co_co_line cl,plm_item i where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and cl.item_id=i.item_id and i.brand_id='0144'
group by cc.sale_dept_id

select sale_dept_id,round(sum(fgday),2) fgday from (
select cc.sale_dept_id,sum(cl.qty_ord)/250 fgday  from co_co cc,co_co_line cl
where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and item_id='6901028148603' 
group by cc.sale_dept_id
union 
select cc.sale_dept_id,sum(cl.qty_ord)/250/3 fgday  from co_co cc,co_co_line cl
where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and item_id='6901028159753'
group by cc.sale_dept_id
) group by sale_dept_id

select sale_dept_id,round(sum(fgmonth),4) fgmonth from (
select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold)/250 fgmonth
 from dpt_sale_day2015 
where iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and item_id='6901028148603' 
group by  '1137'||substr(dpt_sale_id,1,4)
union 
select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold)/250/3 fgmonth
 from dpt_sale_day2015 
where iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and item_id='6901028159753' 
group by  '1137'||substr(dpt_sale_id,1,4)
) group by sale_dept_id

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold*t_size)/50000 hhlmonth
 from dpt_sale_day2015  a,plm_item i
where a.item_id=i.item_id
and  iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and i.brand_id='0144'
group by  '1137'||substr(dpt_sale_id,1,4)

select dept_sale_id,ppkh_id,khqty from ppkh 

select cc.sale_dept_id,sum(cl.qty_ord*t_size)/50000 price1day 
 from co_co cc,co_co_line cl,plm_item i,plm_item_com ic
where cc.co_num=cl.co_num and cl.item_id=i.item_id and cl.item_id=ic.item_id and ic.com_id='10371701'
and ic.price_trade>=78 and ic.price_trade<95 and i.item_id<>'6901028151634'
and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90'
group by cc.sale_dept_id

select cc.sale_dept_id,sum(cl.qty_ord*t_size)/50000 price1day 
 from co_co cc,co_co_line cl,plm_item i,plm_item_com ic
where cc.co_num=cl.co_num and cl.item_id=i.item_id and cl.item_id=ic.item_id and ic.com_id='10371701'
and ic.price_trade>=95 and ic.price_trade<170  
and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90'
group by cc.sale_dept_id

select cc.sale_dept_id,sum(cl.qty_ord*t_size)/50000 price1day 
 from co_co cc,co_co_line cl,plm_item i,plm_item_com ic
where cc.co_num=cl.co_num and cl.item_id=i.item_id and cl.item_id=ic.item_id and ic.com_id='10371701'
and ic.price_trade>=170 and ic.price_trade<290  
and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90'
group by cc.sale_dept_id

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold*t_size)/50000 price1month
 from dpt_sale_day2015  a,plm_item i,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id 
and ic.pri_wsale>=78 and ic.pri_wsale<95 and i.item_id<>'6901028151634'
and  iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)

group by  '1137'||substr(dpt_sale_id,1,4)

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold*t_size)/50000 price1month
 from dpt_sale_day2015  a,plm_item i,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id 
and ic.pri_wsale>=95 and ic.pri_wsale<170
and  iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)

group by  '1137'||substr(dpt_sale_id,1,4)

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold*t_size)/50000 price1month
 from dpt_sale_day2015  a,plm_item i,item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id 
and ic.pri_wsale>=170 and ic.pri_wsale<290
and  iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)

group by  '1137'||substr(dpt_sale_id,1,4)

select cc.sale_dept_id,sum(cl.qty_ord)/250 yxday  from co_co cc,co_co_line cl  where cc.co_num=cl.co_num and cc.born_date=(select to_char(sysdate,'yyyyMMdd') from dual) and cc.status<>'90' and item_id='6901028317177'
group by cc.sale_dept_id

select '1137'||substr(dpt_sale_id,1,4) sale_dept_id,sum(qty_sold)/250 yxmonth
 from dpt_sale_day2015  a 
where  iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
and  item_id='6901028317177'
group by  '1137'||substr(dpt_sale_id,1,4)

select trunc(sysdate)-to_date('20150101','yyyymmdd') daypast from dual

select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id,pop from pop_xian

select substr(to_char(sysdate+1,'yyyyMMdd'),5,2) yd from dual

select  dxamt_plan 
from plan a where  a.type='02' and a.date1=(select to_char(sysdate+1,'yyyyMM') from dual)
 

select   dxamt_plan 
from plan a where  a.type='04' and a.date1='2015'

select round(daypast/days*100,0)||'%' daypp from (
select  count(1)  daypast from (
select iss_date,sum(qty_sold*t_size)/50000 qtymonth,
sum(amt_sold_with_tax) amtmonth
 from dpt_sale_day2015 a,plm_item i 
where a.item_id=i.item_id 
and a.iss_date>=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6)||'01' from dual)
group by   iss_date)
),
( select  days from sale_days where date1=(select substr(to_char(sysdate+1,'yyyyMMdd'),1,6) from dual)
)

