select * from 
(
select A.AREA_CODE,a.ddate,C.GOODS_CODE,c.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.EFFECTIVE_PERIOD,A.DTP,A.GATHER,A.EFFECTIVE,SUM(DC_QTY) as DC_QTY,SUM(DC_COST) as DC_COST,SUM(ZY_QTY) as ZY_QTY,sum(ZY_COST) as ZY_COST,a.approval_number,min(sorted) sorted,case when a.effective_period<a.ddate then '过效期'
            when a.ddate<=(a.effective_period)  and (a.effective_period-a.ddate) <=30 then '一个月效期'
            when 30<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=90 then '2-3个月效期'
            when 90<(a.effective_period-a.ddate) and (a.effective_period-a.ddate)<=180 then '4-6个月效期'
            else '正常效期' end xq_period from dm_stock_period_all A 
inner join dim_region dr on a.area_code=dr.area_code
join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
left join dim_disable_code B
on a.goods_code=b.disable_code inner join DIM_GOODS C on B.GOODS_CODE=c.GOODS_CODE

where ddate=add_months(to_date('${Date}'||'-01','yyyy-mm-dd'),1)-1 
and 1=1 ${if(len(area)=0,""," and A.area_code in ('"+area+"')")}
and 1=1 ${if(len(dtp)=0,""," and dtp= '"+dtp+"'")}
and 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
and 1=1 ${if(len(goods)=0,""," and b.goods_code in ('"+goods+"')")}
and (a.dc_qty is not null or a.dc_cost is not null)

group by A.AREA_CODE,a.ddate,C.GOODS_CODE,c.GOODS_NAME,C.SPECIFICATION,C.MANUFACTURER,A.EFFECTIVE_PERIOD,A.DTP,A.GATHER,A.EFFECTIVE,a.approval_number
) where   1=1  ${if(len(eff)=0,""," and xq_period in ('"+eff+"')")}
order by sorted,GOODS_CODE

select area_code,area_name from dim_region

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

