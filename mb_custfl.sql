select *  from pub_base   where custfl='custseg' order by base_type desc



 select case aa.base_type when 'B' then '使利店' when 'Z' then '食杂店'
 when 'Y' then '烟酒店' when 'N' then '商场' when 'S' then '超市'
 when 'F' then '娱乐服务' when'Q' then '其他'  else '未维护' end as base_type, custnum, qtyyt  from 
  (select base_type ,round(sum( qty_sold*t_size)/50000,0) qtyyt 
from ytsale_month c, plm_item i
where c.item_id=i.item_id  and date1>='${date1}' and date1<='${date2}' 
group by base_type)  aa  ,  pub_base bb where  aa.base_type=bb.base_type and bb.custfl='yetai'


select *  from pub_base   where custfl='dili'


select *  from pub_base   where custfl='yetai'

select *  from pub_base   where custfl='orderway'

