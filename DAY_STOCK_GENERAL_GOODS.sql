Select a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,(case when new_attribute is null then '地采' else new_attribute end) as attribute,(case when D.goods_code is not null then '是' else '否' end) as dtp,sum(stock_qty),sum(no_tax_cost) from dm_stock_general_day A left join dim_region dr on a.area_code=dr.area_code join USER_AUTHORITY  ua on (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
 left join dim_disable_code E on a.goods_code=e.disable_code
left join
dim_goods B on e.goods_code=b.goods_code left join dim_net_catalogue_general_all C on a.area_code=c.area_code and a.goods_code=c.goods_code 
and c.create_month=to_char(ddate,'yyyy-mm') left join DIM_DTP D on a.area_code=d.area_code and a.goods_code=d.goods_code
 and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm')



 where 
 --ddate=last_day(to_date('${Date}'||'-01','yyyy-mm-dd')) AND 1=1 
1=1 ${IF(LEN(AREA)=0,"","AND a.AREA_CODE IN ('"+AREA+"')")}
AND 1=1 ${IF(LEN(goods)=0,"","AND e.goods_CODE IN ('"+goods+"')")}
 
 group by a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,new_attribute,(case when D.goods_code is not null then '是' else '否' end) 
order by a.area_code

Select a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,(case when new_attribute is null then '地采' else new_attribute end) as attribute,(case when D.goods_code is not null then '是' else '否' end) as dtp,sum(stock_qty),sum(no_tax_cost) from dm_stock_general_day A 
 left join dim_disable_code E on a.goods_code=e.disable_code
left join
dim_goods B on e.goods_code=b.goods_code left join dim_net_catalogue_general_all C on a.area_code=c.area_code and a.goods_code=c.goods_code 
and c.create_month=to_char(ddate,'yyyy-mm') left join DIM_DTP D on a.area_code=d.area_code and a.goods_code=d.goods_code
and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm')



where effective_period < ddate 
--and ddate=last_day(to_date('${Date}'||'-01','yyyy-mm-dd'))  
AND 1=1 ${IF(LEN(AREA)=0,"","AND a.AREA_CODE IN ('"+AREA+"')")} 
AND 1=1 ${IF(LEN(goods)=0,"","AND e.goods_CODE IN ('"+goods+"')")}
 group by a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,new_attribute,(case when D.goods_code is not null then '是' else '否' end) 

Select a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,(case when new_attribute is null then '地采' else new_attribute end) as attribute,(case when D.goods_code is not null then '是' else '否' end) as dtp,sum(stock_qty),sum(no_tax_cost) from dm_stock_general_day A 
 left join dim_disable_code E on a.goods_code=e.disable_code
left join
dim_goods B on e.goods_code=b.goods_code left join dim_net_catalogue_general_all C on a.area_code=c.area_code and a.goods_code=c.goods_code 
and c.create_month=to_char(ddate,'yyyy-mm') left join DIM_DTP D on a.area_code=d.area_code and a.goods_code=d.goods_code
and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm')

where effective_period < add_months(ddate,6)  and ddate <= effective_period


--and ddate=last_day(to_date('${Date}'||'-01','yyyy-mm-dd')) 
AND 1=1 ${IF(LEN(AREA)=0,"","AND a.AREA_CODE IN ('"+AREA+"')")} 
AND 1=1 ${IF(LEN(goods)=0,"","AND e.goods_CODE IN ('"+goods+"')")}

 group by a.area_code,e.goods_code,b.goods_name,b.specification,b.manufacturer,new_attribute,(case when D.goods_code is not null then '是' else '否' end) 

select area_code,area_name from dim_region

select distinct c.goods_code,c.goods_code||'|'||b.goods_name goods_name from fact_stock_general A 
left join dim_disable_code c on a.goods_code=c.disable_code
left join dim_goods b on C.goods_code=b.goods_code 
 where to_char(ddate,'yyyy-mm') ='${date}' 
AND 1=1 ${IF(LEN(AREA)=0,"","AND a.AREA_CODE IN ('"+AREA+"')")}
--and rownum<5000
order by 1

