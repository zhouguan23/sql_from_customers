 select * from 
 (
 
select A.area_code,A.cus_code,B.CUS_NAME,D.goods_code,c.goods_name,c.specification,c.manufacturer,(case when e.new_attribute is null then '地采' else e.new_attribute end ) as gather,(case when f.goods_code is null then '否' else '是' end) as dtp,  
A.effective_period,
case
                 when a.effective_period < a.ddate then
                  '过效期'
                 when a.ddate <= (a.effective_period) and
                      (a.effective_period - a.ddate) <= 30 then
                  '一个月效期'
                 when 30 < (a.effective_period - a.ddate) and
                      (a.effective_period - a.ddate) <= 90 then
                  '2-3个月效期'
                 when 90 < (a.effective_period - a.ddate) and
                      (a.effective_period - a.ddate) <= 180 then
                  '4-6个月效期'
                 else
                  '正常效期' end xq_period,
no_tax_cost,stock_qty,approval_number,dr.sorted
from fact_stock_shop A 
inner join dim_region dr on a.area_code=dr.area_code
join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') and ${"ua.user_id='"+$fr_username+"'"}

inner join dim_cus B on a.area_code=b.area_code and a.cus_code=b.cus_code 

inner join dim_disable_code D on a.goods_code=d.disable_code

inner join dim_goods C on D.goods_code=c.goods_code

left join dim_net_catalogue_general_all E on a.area_code=e.area_code and a.goods_code=e.goods_code 
and e.create_month='${Date}'

left join dim_dtp F on a.area_code=f.area_code and a.goods_code=f.goods_code 
and f.CREATE_MONTH=to_char(add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-1),'YYYY-MM')

where ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 

AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when f.goods_code is null then '否' else '是' end) = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and (case when e.new_attribute is null then '地采' else e.new_attribute end ) in ('"+gather+"')")}
and 1=1 ${if(len(goods)=0,""," and d.goods_Code in ('"+goods+"')")}



and b.attribute='直营')
where  1=1 ${if(len(eff)=0,""," and xq_period in('"+eff+"')")} 
 order by sorted,cus_code,goods_code

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL

select AREA_code,AREA_name from DIM_REGION

SELECT 
A.CUS_CODE,
B.CUS_NAME
FROM 
(
select DISTINCT  
AREA_CODE,
CUS_CODE
from DM_STOCK_SHOP_DETAIL
where 
1=1 ${if(len(area)=0,""," and AREA_CODE  in ('"+area+"')")}
AND 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
) A,DIM_CUS B 
WHERE  
A.AREA_CODE  = B.AREA_CODE  
AND  
A.CUS_CODE  = B.CUS_CODE  
and B.ATTRIBUTE='直营'

select distinct b.goods_code,b.goods_code||'|'||C.goods_name goods_name
from dm_stock_shop_detail A left join dim_disable_code B on a.goods_code=b.disable_code
left join dim_goods C on B.goods_code=c.goods_Code
where 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and dtp = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${if(len(eff)=0,""," and effective='"+eff+"'")} 
and rownum<5000

SELECT 
A.CUS_CODE,
B.CUS_NAME
FROM 
(
select DISTINCT  
AREA_CODE,
CUS_CODE
from DM_STOCK_SHOP_DETAIL
where 
1=1 ${if(len(area)=0,""," and AREA_CODE  in ('"+area+"')")}
AND 
ddate = add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1
) A,DIM_CUS B 
WHERE  
A.AREA_CODE  = B.AREA_CODE  
AND  
A.CUS_CODE  = B.CUS_CODE  

 select '合计',sum(stock_qty) stock_qty,sum(no_tax_cost) no_tax_cost from 
 (
 
select A.area_code,A.cus_code,B.CUS_NAME,D.goods_code,c.goods_name,c.specification,c.manufacturer,(case when e.new_attribute is null then '地采' else e.new_attribute end ) as gather,(case when f.goods_code is null then '否' else '是' end) as dtp,  
A.effective_period,
(case when ddate > effective_period then '过效期' 
when  (DDATE <= EFFECTIVE_PERIOD and DDATE >= EFFECTIVE_PERIOD - 180) then '近效期'
 else '正常效期' end  ) as effective,
no_tax_cost,stock_qty,approval_number
from fact_stock_shop A 

inner join dim_cus B on a.area_code=b.area_code and a.cus_code=b.cus_code 

inner join dim_disable_code D on a.goods_code=d.disable_code

inner join dim_goods C on D.goods_code=c.goods_code

left join dim_net_catalogue_general_all E on a.area_code=e.area_code and a.goods_code=e.goods_code 
and e.create_month='${Date}'

left join dim_dtp F on a.area_code=f.area_code and a.goods_code=f.goods_code 
and f.CREATE_MONTH=to_char(add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-1),'YYYY-MM')

where ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 

AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
and 1=1 ${if(len(cus)=0,""," and a.cus_code in ('"+cus+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when f.goods_code is null then '否' else '是' end) = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and (case when e.new_attribute is null then '地采' else e.new_attribute end ) in ('"+gather+"')")}
and 1=1 ${if(len(goods)=0,""," and d.goods_Code in ('"+goods+"')")}



and b.attribute='直营')
where  1=1 ${if(len(eff)=0,""," and effective='"+eff+"'")} 

select '合计' 合计 from dual

