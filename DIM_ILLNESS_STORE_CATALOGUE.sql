select a.area_code,dr.area_name,a.cus_code,dc.cus_name,a.goods_code,dg.goods_name,dg.specification,dg.manufacturer,a.ill_type,a.create_date from dim_illness_core_catalogue a,dim_region dr,USER_AUTHORITY  ua,dim_goods dg,dim_cus dc
where 
a.area_code=dr.area_code
--and a.goods_code='1110344'
and (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and a.goods_code=dg.goods_code(+)
and a.area_code=dc.area_code
and a.cus_code=dc.cus_code

and
1=1
${if(len(code) = 0, "", " and a.goods_code in ('" + code + "')")}
${if(len(ill) = 0, "", " and a.ill_type in ('" + ill + "')")}
${if(len(area) = 0, "", " and a.area_code in ('" + area + "')")}
${if(len(cus) = 0, "", " and a.cus_code in ('" + cus + "')")}
order by dr.sorted,a.cus_code,a.goods_code

select distinct ill_type from dim_illness_core_catalogue

select dg.goods_code||'|'||dg.goods_name goods_name,dg.goods_code
from 
(select distinct goods_code from dim_illness_core_catalogue ) dicc,dim_goods dg
where dicc.goods_code=dg.goods_code
order by dicc.goods_code

select distinct goods_code,goods_name from dim_goods

select  dr.area_code,dr.area_name from dim_region dr

select dc.cus_code,dc.cus_name  from dim_cus dc
where
 1=1
${if(len(region) = 0, "", " and dc.area_code in ('" + region + "')")}

