--门店实时库存查询
--查询条件：小区（下拉），门店（下拉），大类（下拉),小类（下拉），品牌编码（输入），商品编号（输入）
select  tbreg1.regionname big,tbreg2.regionname smal,tbshop.shopid,tbshop.shopname,
trunc(tbg.categoryid/10000) pl,tbgc1.categoryname,tbg.categoryid,tbgc2.categoryname,tbg.brandid,tbgb.brandname,
tbstock.goodsid,tbg.goodsname,tbg.barcode,tbbg.col6, tbbg.col18,tbbg.col16,
tbstock.qty
from  dwuser.EF_SHOPSTOCK tbstock
inner join dwuser.base_shop tbshop
on tbstock.shopid=tbshop.shopid
inner join dwuser.base_goods tbg
on tbstock.goodsid=tbg.goodsid
left join dwuser.BASE_GOODSEXTPUB tbbg on tbbg.goodsid=tbg.goodsid
inner join dwuser.base_goods_category tbgc1
on trunc(tbg.categoryid/10000)=tbgc1.categoryid
inner join dwuser.base_goods_category tbgc2
on tbg.categoryid=tbgc2.categoryid
left join dwuser.base_goods_brand tbgb
on tbg.brandid=tbgb.brandid
left join dwuser.base_region tbreg2
on tbshop.regionid=tbreg2.regionid
left join dwuser.base_region tbreg1
on tbreg2.headregionid=tbreg1.regionid
where tbshop.shoptype='11' and tbshop.shopstatus=0
and tbshop.shopid in(select shopid 
from(
select tbshop.shopid
from dwuser.BASE_USER_SHOPALL tbus,dwuser.base_shop tbshop
where tbus.loginid='${fr_username}' and tbus.flag='0000' and tbshop.shoptype=11
union all
select shopid from dwuser.base_ef_user_shop
where LOGINID='${fr_username}'
) group by shopid
)
${if(len(小区) == 0,"","and tbreg2.regionid = '" + 小区 + "'")}
${if(len(门店) == 0,"","and tbshop.shopid = '" + 门店 + "'")}
${if(len(大类) == 0,"","and trunc(tbg.categoryid/10000) = '" + 大类 + "'")}
${if(len(小类) == 0,"","and tbg.categoryid = '" + 小类 + "'")}
${if(len(品牌编码) == 0,"","and tbg.brandid = '" + 品牌编码 + "'")}
${if(len(商品编码) == 0,"","and tbstock.goodsid = '" + 商品编码 + "'")}
${if(len(内部货号) == 0,"","and tbbg.col18= '" + 内部货号 + "'")}
${if(len(系列名称) == 0,"","and tbbg.col6= '" + 系列名称 + "'")}
${if(len(尺码) == 0,"","and tbbg.col16= '" + 尺码 + "'")}

order by tbreg1.regionname,tbreg2.regionname,tbshop.shopid,
trunc(tbg.categoryid/10000) ,tbg.categoryid,tbg.brandid,tbstock.goodsid



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

