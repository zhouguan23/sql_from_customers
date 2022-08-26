select '全市' ,qty,dxamt,
round(qty*250/pop/saledays*yeardays,2) renj from 
(
select round(sum(qty_sold*i.t_size)/50000,2) qty,round(sum(amt_sold_with_tax)*5/sum(qty_sold*i.t_size),4) dxamt  from dpt_sale_day2020 a,plm_item i 
where  a.item_id=i.item_id 
and a.iss_date>=(select substr(to_char(sysdate+1,'yyyymmdd'),1,6)||'01' from dual)
and a.iss_date<=(select to_char(sysdate+1,'yyyymmdd') from dual) 
 ) dp,
(select sum(pop) pop from pop_xian) ,
( select to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd')
- to_date(to_char(to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd'),'yyyymm')||'01','yyyymmdd')+1 saledays
 from dual),
  (SELECT ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY') yeardays FROM DUAL) 

select  issdate,round(qty,2) qty,dxamt 
 from 
(
select  
  substr(iss_date,1,6) issdate,sum(qty_sold*i.t_size)/50000 qty,round(sum(amt_sold_with_tax)*5/sum(qty_sold*i.t_size),4) dxamt  from  dpt_sale_day2020 a,plm_item i 
where  a.item_id=i.item_id  group by substr(iss_date,1,6)
union 
select substr(iss_date,1,6) issdate,sum(qty_sold*i.t_size)/50000 qty,round(sum(amt_sold_with_tax)*5/sum(qty_sold*i.t_size),4) dxamt  from  dpt_sale_day2019 a,plm_item i 
where  a.item_id=i.item_id  and iss_date>=(SELECT to_char(add_months(to_date(to_char(sysdate,'yyyymmdd'),'yyyymmdd'),-5),'yyyymm')||'01' FROM DUAL) group by substr(iss_date,1,6)
 ) dp

