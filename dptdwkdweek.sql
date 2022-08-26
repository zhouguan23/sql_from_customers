with cc as
(
select distinct cust_id from pi_cust_item_bnd_day
where date1>=(select distinct  begin_date from sgp_custtype_item_spw where week='${myweek}')
and  date1<=(select  distinct end_date from sgp_custtype_item_spw where week='${myweek}')
)
select c.cust_seg,cust_type3,sale_dept_id,count(1) hus from co_cust c,cc
where status='02' and c.cust_id=cc.cust_id  
and c.cust_seg<>'ZZ'
group by c.cust_seg,cust_type3,sale_dept_id order by c.cust_seg desc


with cc as
(
select distinct cust_id,count(1) hdkd from pi_cust_item_bnd_day
where date1>=(select distinct  begin_date from sgp_custtype_item_spw where week='${myweek}')
and  date1<=(select  distinct end_date from sgp_custtype_item_spw where week='${myweek}')

group by cust_id
)

select cust_seg,cust_type3,sale_dept_id,sum(cc.hdkd) dhkd   from co_cust c,cc 
 where   cust_seg<>'ZZ' and c.cust_id=cc.cust_id   and c.status='02'
group by cust_seg,cust_type3,sale_dept_id 

select distinct week,week||':日期 '||begin_date||'--'||end_date myweek from SGP_CUSTTYPE_ITEM_SPW
order by week desc

