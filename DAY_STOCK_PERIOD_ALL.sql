select 
a.area_code
,c.goods_code
,c.goods_name
,C.SPECIFICATION
,c.manufacturer
,a.effective_period
,a.dtp
,a.gather
,a.effective
,c.category 品类--“品类”：取自字典“品类”字段
,c.composition 成分--“成分”：取自字典“成分”字段
,c.function 功能主治 --“功能主治”：取自字典“功能主治”字段
,c.FINISHING_MANUFACTURER 整理厂家--“整理厂家”：取自字典“整理厂家”字段
,gd.last_time as 入库时间 --入库时间：显示该区域品种对应批号的入库时间
,trunc(sysdate)-gd.last_time as 库龄
,sum(dc_qty) as dc_qty
,sum(dc_cost) as dc_cost
,sum(zy_qty) as zy_qty
,sum(zy_cost) as zy_cost
,a.approval_number
,min(sorted) 
 from day_dm_stock_period_all a
inner join dim_region dr on a.area_code=dr.area_code
join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
left join dim_disable_code b on a.goods_code=b.disable_code 
left join dim_goods c on a.goods_code=c.goods_code
left join 
(select area_code
,goods_code
,max(order_date) last_time --商品首次入库的时间
from (
select area_code,goods_code, order_date from fact_purchase 
union all 
select r.area_code,nsr.item,tran_date from new_shop_reaserch nsr ,dim_region r
where nsr.region_name=r.area_all_name)
group by area_code,goods_code
) gd on a.area_code=gd.area_code and a.goods_code=gd.goods_code
where 
1=1 
--ddate=to_date('2020/12/9','yyyy/mm/dd')
--and c.goods_name like '%口罩%' 
${if(len(area)=0,""," and A.area_code in ('"+area+"')")}
${if(len(dtp)=0,""," and dtp= '"+dtp+"'")}
${if(len(gather)=0,""," and gather in ('"+gather+"')")}
${if(len(goods)=0,""," and b.goods_code in ('"+goods+"')")}
${if(len(goods_name)=0,""," and c.goods_name like ('"+goods_name+"')")}
${if(len(eff)=0,""," and a.effective in ('"+eff+"')")} 
${if(len(start_date)=0,""," and gd.last_time>=to_date('"+start_date+"','yyyy/mm/dd')")}
${if(len(end_date)=0,""," and gd.last_time<=to_date('"+end_date+"','yyyy/mm/dd')")}  
${if(len(stockage_start)=0,""," and trunc(sysdate)-gd.last_time>="+stockage_start+" ")}
${if(len(stockage_end)=0,""," and trunc(sysdate)-gd.last_time<="+stockage_end+"")} 
${if(len(category)=0,""," and c.category in ('"+category+"')")} ----“品类”
${if(len(composition)=0,""," and c.composition in ('"+composition+"')")} --成分
${if(len(func)=0,""," and trim(c.function) in ('"+func+"')")} --功能主治
${if(len(fm)=0,""," and c.FINISHING_MANUFACTURER in ('"+fm+"')")} --整理厂家  
group by a.area_code
                ,c.goods_code
                ,c.goods_name
                ,C.SPECIFICATION
                ,c.manufacturer
                ,a.effective_period
                ,a.dtp
                ,a.gather
                ,a.effective
                ,a.approval_number
                ,c.category --“品类”：取自字典“品类”字段
                ,c.composition --“成分”：取自字典“成分”字段
                ,c.function  --“功能主治”：取自字典“功能主治”字段
                ,c.FINISHING_MANUFACTURER --“整理厂家”：取自字典“整理厂家”字段
                ,gd.last_time
order by min(sorted),c.goods_code


select area_code,area_name from dim_region

select distinct new_attribute from dim_net_catalogue_general_all
union
select '地采' as new_attribute from dual

select distinct b.goods_code,c.Goods_name
from dm_stock_period_all A left join dim_disable_code B
on a.goods_code=b.disable_code
left join dim_goods c on B.goods_code=c.goods_code
--where ddate=to_date('2020/12/9','yyyy/mm/dd')
--and 1=1 ${if(len(area)=0,""," and area_code in ('"+area+"')")}
--and 1=1 ${if(len(dtp)=0,""," and dtp= '"+dtp+"'")}
--and 1=1 ${if(len(gather)=0,""," and gather in ('"+gather+"')")}
--and 1=1 ${if(len(eff)=0,""," and a.effective = '"+eff+"'")}
--and rownum<5000

select distinct category 品类
  from dim_goods 
 order by 1

select distinct composition 成分          
  from dim_goods 
 order by 1

select distinct trim(function) 功能主治
  from dim_goods 
 order by 1

select distinct b.FINISHING_MANUFACTURER 整理厂家
  from dim_goods b 
 order by 1

