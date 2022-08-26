
select substr(sale_dept_id,5,4) sale_dept_id ,count(1) qty from co_cust where status='02' group by substr(sale_dept_id,5,4)

select i.item_id,ic.short_code,item_name,price_trade,i.kind,round(qty*t_size/50000/daysale,2) avgsold ,round(qty_usable*t_size/50000,2)  kc
from LWM_WHSE_ITEM a,plm_item i,plm_item_com ic,
(
select  item_id, count(distinct date1) daysale,sum(qty_sold) qty from pi_com_item_day
where  date1>=(select  to_char(sysdate-30,'yyyyMMdd')  from dual)
group by item_id
) b
where a.item_id=i.item_id and b.item_id=i.item_id and 
a.com_id='10371701' and ic.com_id='10371701'
and ic.item_id=i.item_id and qty<>0 and qty_usable<>0 order by kind   ,qty_usable desc

select ${ss} from dual

