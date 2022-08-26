select substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr,sum(amt_sold) amt,
 round(sum(gross_profit)/10000,1) grossr 
from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id and date1='${date1}'   group by substr(sale_dept_id,5,4)||'0100'

select dpt_sale_id,round(sum(qty_sold*i.rods)/50000,2) qtyy,sum(amt_sold_with_tax) amt ,round(sum(gross_profit)/10000,1) grossy 
from item_dpt_sale_day a,item i 
where a.item_id=i.item_id 
and date1>=(select substr('${date1}',1,6)||'01' from dual)  
and date1<='${date1}' group by dpt_Sale_id

select sale_dept_id dpt_sale_id,
sum(qty_sold*t_size)/50000 qty,
sum(amt_sold) amt, 
sum(gross_profit)/10000 gross, 

sum(qty_sold_month*t_size)/50000 qtymonth,
sum(amt_sold_month) amtmonth, 
sum(gross_sold_month)/10000 grossmonth,


sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(amt_sold_month_same) amtmonthsame, 
sum(gross_sold_month_same)/10000 grossmonthsame,

sum(qty_sold_year*t_size)/50000  qtyyear,
sum(amt_sold_year) amtyear,
sum(gross_sold_year)/10000 grossyear ,


sum(qty_sold_year_same*t_size)/50000  qtyyearsame,
sum(amt_sold_year_same) amtyearsame,
sum(gross_sold_year_same)/10000 grossyearsame 


from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id 
and date1='${date1}'
 group by sale_dept_id

select substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtytong,sum(amt_sold) amt ,round(sum(gross_profit)/10000,1) grosstong 
from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id 
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by substr(sale_dept_id,5,4)||'0100' 

select dpt_sale_id,round(sum(qty_sold*i.rods)/50000,2) qtytong,sum(amt_sold_with_tax) amt, round(sum(gross_profit)/10000,1) grosstong 
from item_dpt_sale_day a,item i 
where a.item_id=i.item_id 
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,4)||'0101' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by dpt_Sale_id

select im.itemgr_id itemgr_id,sum(qty_sold*t_size)/50000 qty,
sum(qty_sold_month*t_size)/50000 qtymonth,
sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year*t_size)/50000  qtyyear,
sum(qty_sold_year_same*t_size)/50000  qtyyearsame
from pi_com_item_day a,plm_item i,
(select itemgr_id,note from bohzuser.itemgr@orahzbo)  im
where a.item_id=i.item_id  and i.brand_id=im.itemgr_id  and 
im.note='key' and qty_sold<>0
 
and  date1='${date1}' group by im.itemgr_id


select im.itemgr_id itemgr_id,sum(qty_sold*t_size)/50000 qtyy,sum(amt_sold) amt  
from pi_com_day a,plm_item i ,
(select itemgr_id,note from bohzuser.itemgr@orahzbo)  im
where a.item_id=i.item_id  and i.brand_id=im.itemgr_id  and 
im.note  like '%30%'
and  date1>=(select substr('${date1}',1,6)||'01' from dual)  
and  date1<='${date1}' group by im.itemgr_id


select im.itemgr_id itemgr_id,sum(qty_sold*t_size)/50000 qtyy,sum(amt_sold) amt  
from pi_com_day a,plm_item i ,
(select itemgr_id,note from bohzuser.itemgr@orahzbo)  im
where a.item_id=i.item_id  and i.brand_id=im.itemgr_id  and 
im.note  like '%30%'
and  date1>=(select substr('${date1}',1,4)||'0101' from dual)  
and  date1<='${date1}' group by im.itemgr_id

select im.itemgr_id itemgr_id,sum(qty_sold*t_size)/50000 qtyy,sum(amt_sold) amt  
from pi_com_day a,plm_item i ,
(select itemgr_id,note from bohzuser.itemgr@orahzbo)  im
where a.item_id=i.item_id  and i.brand_id=im.itemgr_id  and 
im.note  like '%30%'
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by im.itemgr_id


select im.itemgr_id itemgr_id,sum(qty_sold*t_size)/50000 qtyy,sum(amt_sold) amt  
from pi_com_day a,plm_item i ,
(select itemgr_id,note from bohzuser.itemgr@orahzbo)  im
where a.item_id=i.item_id  and i.brand_id=im.itemgr_id  and 
im.note  like '%30%'
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,4)||'0101' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by im.itemgr_id




select '1137'||substr(dpt_sale_id,1,4) dpt_sale_id ,qty_plan/250  qtyplan,dxamt_plan from plan
 where type='01' and date1=(select substr(${date1},1,6) from dual)

select  dxamt_plan from plan
 where type='02' and date1=(select substr(${daet1},1,6) from dual)

select itemgr_id,itemgr_name from itemgr where note='key' order by itemgr_type

select  sale_dept_id dpt_sale_id,
sum(qty_sold*t_size)/50000 qtyr,
sum(qty_sold_month*t_size)/50000 qtymonth,

sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year*t_size)/50000  qtyyear,
sum(qty_sold_year_same*t_size)/50000  qtyyearsame

from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id and date1='${date1}'
and brand_id='0046'   group by  sale_dept_id 

select brand_id itemgr_id,substr(sale_dept_id,5,4)||'0100',round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id  
and date1>=(select substr('${date1}',1,6)||'01' from dual)  
and date1<='${date1}'
and brand_id in ('0046','0144','0028','0170','0108')   group by brand_id  ,substr(sale_dept_id,5,4)||'0100'

select brand_id itemgr_id,substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id  
and date1>=(select substr('${date1}',1,4)||'0101' from dual)  
and date1<='${date1}'
and brand_id in ('0046','0144','0028','0170','0108')   group by brand_id,substr(sale_dept_id,5,4)||'0100'

select itemgr_id,dpt_sale_id,round(sum(qty_sold*i.rods)/50000,2) qtytong 
from item_dpt_sale_day a,item i 
where a.item_id=i.item_id and itemgr_id in ('0046','0144','0028','0170','0108') 
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by itemgr_id,dpt_Sale_id

select brand_id itemgr_id,substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtytong 
from pi_dept_item_day a,plm_item i 
where a.item_id=i.item_id and  brand_id in ('0046','0144','0028','0170','0108') 
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,4)||'0101' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) group by brand_id  ,substr(sale_dept_id,5,4)||'0100'

select  sale_dept_id dpt_sale_id,

sum(qty_sold*t_size)/50000 qtyr,
sum(qty_sold_month*t_size)/50000 qtymonth,

sum(qty_sold_month_same*t_size)/50000 qtymonthsame,
sum(qty_sold_year*t_size)/50000  qtyyear,
sum(qty_sold_year_same*t_size)/50000  qtyyearsame

from pi_dept_item_day a,plm_item i ,plm_item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
 and date1='${date1}' and ic.price_retail>=100
and brand_id='0046'   group by sale_dept_id 

select  substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i ,plm_item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
and date1>=(select substr('${date1}',1,6)||'01' from dual)  
and date1<='${date1}' and ic.price_retail>=100
and brand_id='0046'   group by substr(sale_dept_id,5,4)||'0100'

select  substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i ,plm_item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
and date1>=(select substr('${date1}',1,4)||'0101' from dual)  
and date1<='${date1}' and ic.price_retail>=100
and brand_id='0046'   group by substr(sale_dept_id,5,4)||'0100'

select  substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i ,plm_item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,6)||'01' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) 
 and ic.price_retail>=100
and brand_id='0046'   group by substr(sale_dept_id,5,4)||'0100'




select  substr(sale_dept_id,5,4)||'0100' dpt_sale_id,round(sum(qty_sold*t_size)/50000,2) qtyr
from pi_dept_item_day a,plm_item i ,plm_item_com ic
where a.item_id=i.item_id and i.item_id=ic.item_id and ic.com_id='10371701'
and date1>=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,4)||'0101' FROM DUAL) and  date1<=(SELECT SUBSTR(TO_CHAR(add_months(to_date('${date1}','yyyymmdd'),-12),'YYYYMMdd'),1,8) FROM DUAL) 
 and ic.price_retail>=100
and brand_id='0046'   group by substr(sale_dept_id,5,4)||'0100'

