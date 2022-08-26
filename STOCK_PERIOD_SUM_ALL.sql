select AREA_CODE,sum(过效期) as 大仓过效期,sum(一个月效期) 大仓一个月效期,
     sum(两到三个月效期) 大仓两到三个月效期,sum(四到六个月效期) 大仓四到六个月效期,sum(正常效期) 大仓正常效期

from (
select AREA_CODE,过效期,一个月效期,两到三个月效期,四到六个月效期,正常效期
from
(


select AREA_CODE,xq_period,SUM(DC_QTY) as DC_QTY,SUM(DC_COST) as DC_COST from 
(
select A.AREA_CODE,
       DC_QTY,
       DC_COST,
       case when a.effective_period<a.ddate then '过效期'
            when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
            when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '2-3个月效期'
            when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
            else '正常效期'
       end xq_period
  from dm_stock_period_all A
 inner join dim_region dr
    on a.area_code = dr.area_code
  join USER_AUTHORITY ua
    on (dr.UNION_AREA_NAME = ua.UNION_AREA_NAME or
       ua.UNION_AREA_NAME = 'ALL')
   and ${"ua.user_id='" + $fr_username + "'"}
  left join dim_disable_code B
    on a.goods_code = b.disable_code
 inner join DIM_GOODS C
    on B.GOODS_CODE = c.GOODS_CODE

 where 
--     ddate = date '2020-03-31'
 --  and a.area_code = '10'
 ddate = add_months(to_date('${Date}' || '-01', 'yyyy-mm-dd'), 1) - 1
   and 1 = 1
 ${if(len(area) = 0, "", " and A.area_code in ('" + area + "')") }
   and 1 = 1 ${if(len(dtp) = 0, "", " and dtp= '" + dtp + "'") }
   and 1 = 1
 ${if(len(gather) = 0, "", " and gather in ('" + gather + "')") }
   and 1 = 1
 ${if(len(goods) = 0, "", " and b.goods_code in ('" + goods + "')") }
 
 )
 where 1 = 1 ${if(len(eff) = 0, "", " and xq_period in ('" + eff + "')") }
 group by AREA_CODE,xq_period
 )
 PIVOT(sum(DC_COST)
   FOR xq_period IN('过效期' as 过效期,'一个月效期' as 一个月效期,'2-3个月效期' as 两到三个月效期,'4-6个月效期' 
     as 四到六个月效期,'正常效期' as 正常效期)
     )
)
group by AREA_CODE

select area_code,area_name from dim_region dr
--join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AR--EA_NAME='ALL') and ${"ua.user_id='"+$fr_username+"'"}
order by sorted

select distinct new_attribute from dim_net_catalogue_general_all
union
select '地采' as new_attribute from dual

select distinct b.goods_code,c.Goods_name
from dm_stock_period_all A left join dim_disable_code B
on a.goods_code=b.disable_code
left join dim_goods c on B.goods_code=c.goods_code
where ddate=add_months(to_date('${Date}'||'-01','yyyy-mm-dd'),1)-1 
and 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
and 1=1 ${if(len(dtp)=0,""," and dtp= '"+dtp+"'")}
and 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${if(len(eff)=0,""," and a.effective = '"+eff+"'")}
and rownum<5000

select A.AREA_CODE,C.GOODS_CODE,c.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.EFFECTIVE_PERIOD,A.DTP,A.GATHER,A.EFFECTIVE,SUM(DC_QTY) as DC_QTY,SUM(DC_COST) as DC_COST,SUM(ZY_QTY) as ZY_QTY,sum(ZY_COST) as ZY_COST from dm_stock_period_all A left join dim_disable_code B
on a.goods_code=b.disable_code inner join DIM_GOODS C on B.GOODS_CODE=c.GOODS_CODE

where ddate=add_months(to_date('${Date}'||'-01','yyyy-mm-dd'),1)-1 
and 1=1 ${if(len(area)=0,""," and A.area_code in ('"+area+"')")}
and 1=1 ${if(len(dtp)=0,""," and dtp= '"+dtp+"'")}
and 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${if(len(goods)=0,""," and b.goods_code in ('"+goods+"')")}
and 1=1 ${if(len(eff)=0,""," and a.effective = '"+eff+"'")}
group by A.AREA_CODE,C.GOODS_CODE,c.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.EFFECTIVE_PERIOD,A.DTP,A.GATHER,A.EFFECTIVE

select AREA_CODE,sum(过效期) as 直营过效期,sum(一个月效期) 直营一个月效期,
     sum(两到三个月效期) 直营两到三个月效期,sum(四到六个月效期) 直营四到六个月效期,sum(正常效期) 直营正常效期

from (

select AREA_CODE,过效期,一个月效期,两到三个月效期,四到六个月效期,正常效期

from
(
 select area_code,xq_period,sum(no_tax_cost) no_tax_cost,sum(stock_qty) stock_qty from 
 (
 
select A.area_code,
case when a.effective_period<a.ddate then '过效期'
            when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
            when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '2-3个月效期'
            when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
            else '正常效期' end xq_period,
no_tax_cost,stock_qty
from fact_stock_shop A 
inner join dim_region dr on a.area_code=dr.area_code
join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') and ${"ua.user_id='"+$fr_username+"'"}

inner join dim_cus B on a.area_code=b.area_code and a.cus_code=b.cus_code 

inner join dim_disable_code D on a.goods_code=d.disable_code

inner join dim_goods C on D.goods_code=c.goods_code

left join dim_net_catalogue_general_all E on a.area_code=e.area_code and a.goods_code=e.goods_code 
 and e.create_month='${Date}'
  --and e.create_month='2020-03'

left join dim_dtp F on a.area_code=f.area_code and a.goods_code=f.goods_code 
 --and f.create_month='2020-02'
and f.CREATE_MONTH=to_char(add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),-1),'YYYY-MM')

where --ddate=to_date('2020-03-31','yyyy-mm-dd')
  --and a.AREA_CODE=10
ddate= add_months(to_date('${Date}'||'-01','yyyy/mm/dd'),1)-1 

AND 1=1 ${if(len(area)=0,""," and a.area_code in ('"+area+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when f.goods_code is null then '否' else '是' end) = '"+dtp+"'")}
AND 1=1 ${if(len(gather)=0,""," and (case when e.new_attribute is null then '地采' else e.new_attribute end ) in ('"+gather+"')")}
and 1=1 ${if(len(goods)=0,""," and d.goods_Code in ('"+goods+"')")}
and b.attribute='直营'
) 
where 1=1 ${if(len(eff)=0,""," and xq_period in('"+eff+"')")} 
group by area_code,xq_period
) 
PIVOT(sum(no_tax_cost)
   FOR xq_period IN('过效期' as 过效期,'一个月效期' as 一个月效期,'2-3个月效期' as 两到三个月效期,'4-6个月效期' 
     as 四到六个月效期,'正常效期' as 正常效期)
     )
) group by area_code

