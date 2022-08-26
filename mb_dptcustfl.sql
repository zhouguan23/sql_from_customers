select *  from pub_base   where custfl='custseg' order by base_type desc

 

select case cust_type3 when '011' then '城区'  when '012' then '镇区'
when '013' then '特殊镇区' when '023' then '农村较好'
when '024' then '农村较差' end dili,count(1) custn from cust where dpt_sale_id='${dpt}' and status='02' 
group by cust_type3

select dict_value,count(1) csutyt  from cust c,   
(select * from base_dict@hzyx where dict_id='BASE_TYPE') b
where c.status='02' and c.cust_type5=b.dict_key  and c.dpt_sale_id='${dpt}'
group by dict_value

select dhfs,sum(qty) qty from (
select case c.domain_id when 'HZ001' then '电访' else '网订' end as dhfs,count(1) qty
from csc_cust c,co_cust a    where c.cust_id=a.cust_id and a.status='02'
and substr(a.sale_dept_id,5,4)||'0100'='${dpt}'
group by  c.domain_id ) group by dhfs

