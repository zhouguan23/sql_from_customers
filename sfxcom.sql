
select s.com_id,sum(qty_sold*t_size)/50000 qtyday,sum(amt_sold) amtday from s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1=(select to_char(sysdate,'yyyyMMdd') from dual)
group by s.com_id

select s.com_id, sum(qty_sold*t_size)/50000 daysale, sum(qty_sold_month*t_size)/50000 qtymonth,sum(qty_sold_year*t_size)/50000 qtyyear,sum(amt_sold_month) amtmonth,
sum(amt_sold_year) amtyear,sum(gross_sold_month)/10000 grossmonth,
sum(gross_sold_year)/10000 grossyear from hz_s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1='${date1}'
group by s.com_id

select s.com_id,kind,sum(qty_sold_month*t_size)/50000 kindmonth,
sum(qty_sold_month_same*t_size)/50000  kindmonthsame,
sum(qty_sold_year*t_size)/50000 kindyear,
sum(qty_sold_year_same*t_size)/50000 kindyearsame

from hz_s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id
and date1='${date1}'
group by s.com_id,kind

select com_id,com_name,pop from s_com order by note

select distinct kind,kind||'类' from item


select daypastyue,thisyeardays,lastyear,yearpast from (select  to_date('${date1}','yyyymmdd') - to_date(to_char(to_date('${date1}','yyyymmdd') ,'yyyymm')||'01','yyyymmdd')+1  daypastyue  from dual 
 
),
 (SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') thisyeardays FROM DUAL),
 (
 SELECT   TRUNC(SYSDATE, 'YYYY')-ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), -12)  lastyear FROM DUAL
 ) ,
 (
 select  to_date('${date1}','yyyymmdd') - to_date(to_char(to_date('${date1}','yyyymmdd') ,'yyyy')||'0101','yyyymmdd')+1 yearpast  from dual
 
 )

select s.com_id,sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year_same*t_size)/50000 qtyyearsame,sum(amt_sold_month_same) amtmonthsame,
sum(amt_sold_year_same) amtyearsame,
sum(gross_sold_month_same)/10000 grossmonthsame,
sum(gross_sold_year_same)/10000 grossyearsame from hz_s_com_day a,s_com s,
plm_item i where a.com_id=s.com_id and a.item_id=i.item_id
and date1='${date1}'
group by s.com_id

select s.com_id,   i.brand_id,sum(qty_sold_month*t_size)/50000 qtymonth ,
sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year*t_size)/50000 qtyyear,
sum(qty_sold_year_same*t_size)/50000 qtyyearsame
 from hz_s_com_day a,s_com s,plm_item i 
where a.com_id=s.com_id and a.item_id=i.item_id  and i.yieldly_type=0
and date1='${date1}'
group by s.com_id, i.brand_id 

select s.com_id, sum(qty_sold*t_size)/50000 daysale, sum(qty_sold_month*t_size)/50000 qtymonth,sum(amt_sold_month) amtmonth,sum(gross_sold_month)/50000 grossmonth,
sum(gross_sold_year)/50000 grossyear from hz_s_com_day a,s_com s,plm_item i ,item_com ic
where a.com_id=s.com_id and a.item_id=i.item_id and i.brand_id='0046' and i.item_id=ic.item_id and ic.pri_rtl>=100
and date1='${date1}'
group by s.com_id

select com_id,qty_plan,dxamt_plan from com_plan where date1=(select substr('${date1}',1,6) from dual)

