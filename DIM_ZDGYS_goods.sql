select a.*,b.goods_name,b.specification,b.manufacturer,b.large_cate,
b.medium_cate,b.small_cate
from DIM_ZDGYS_goods a,dim_goods b where 
a.goods_code=b.goods_code
and
1=1 ${if(len(cjmc)=0,""," and  CJMC in('"+cjmc+"')" )}
and 1=1 ${if(len(goods_code)=0,""," and  a.goods_code in ('"+goods_code+"')" )}
and 1=1 ${if(len(year)=0,""," and  create_year in ('"+year+"')" )}
and 1=1 ${if(len(month)=0,""," and  create_month in ('"+month+"')" )}
order by create_year desc,a.cjmc,a.goods_code

select distinct a.goods_code as goods_code,a.goods_code||'|'||b.goods_name as goods_name from DIM_ZDGYS_goods a
left join dim_goods b
on a.goods_code=b.goods_code
order by 1




select distinct cjmc from DIM_ZDGYS_goods



select distinct create_year from DIM_ZDGYS_goods

