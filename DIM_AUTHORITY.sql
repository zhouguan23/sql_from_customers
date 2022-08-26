select uap.user_id,uap.user_name,uap.area_name area_code,nvl(dr.area_name,'国大药房总部') area_name
from USER_AUTHORITY_PRE uap,dim_region dr 
where uap.area_name=dr.area_code(+)

and
1=1
${if(len(area) = 0, "", " and uap.area_name in ('" + area + "')")}
${if(len(user_name) = 0, "", " and uap.user_id in ('" + user_name + "')")}
order by uap.area_name,uap.user_id

select distinct ill_type from dim_illness_core_catalogue

select dg.goods_code||'|'||dg.goods_name goods_name,dg.goods_code
from 
(select distinct goods_code from dim_illness_core_catalogue ) dicc,dim_goods dg
where dicc.goods_code=dg.goods_code
order by dicc.goods_code

select distinct goods_code,goods_name from dim_goods

select decode(area_code,'00','ALL',area_code) area_code,area_name from 
(
select distinct /*decode(area_code,'00','ALL',area_code)*/ area_code,area_code||'|'||area_name  area_name
from dim_region order by area_code
)

select uap.user_id||'|'||uap.user_name user_name,uap.user_id from user_authority_pre uap order by uap.user_id

