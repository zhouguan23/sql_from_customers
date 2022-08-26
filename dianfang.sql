select crt_user_name,born_date,sum(qty_sum) qty from co_co  
where status='60'
 and born_date>='${date1}' and born_date<='${date2}'
and type='10' group by crt_user_name,born_date order by born_date asc

