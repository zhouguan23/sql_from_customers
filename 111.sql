{call dwuser.pro_query_shopstock('${fr_username}','${小区}','${门店}','${大类}','${小类}','${品牌编码}','${商品编码}','${尺码}','${系类名称}','${内部货号}',?)}

select categoryid,categoryname 
from dwuser.base_goods_category
where deptlevelid=1
order by categoryid


select cate3.categoryid,cate3.categoryname 
from dwuser.base_goods_category cate3
left join dwuser.base_goods_category cate2
on cate3.headcatid=cate2.categoryid
left join dwuser.base_goods_category cate1
on cate2.headcatid=cate1.categoryid
where 1=1 ${if(len(大类) == 0,"","and cate1.categoryid = '" + 大类 + "'")} 
order by cate3.categoryid

select regionid,regionname from dwuser.base_region
where regionlevel=3
order by regionid

select tbshop.shopid,tbshop.shopname from dwuser.base_shop tbshop
left join dwuser.base_region tbregion1
on tbshop.regionid=tbregion1.regionid
where tbshop.shoptype=11 and shopstatus=0
 ${if(len(小区) == 0,""," and tbregion1.regionid in ('" + 小区 + "')")}
order by tbshop.shopid 

