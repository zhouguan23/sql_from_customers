select   /*+USE_HASH(a,b,c,d,e,f,h)*/ c.shopid 门店编码 ,c.shopname 门店名称,d.goodsid 商品编码,d.goodsname 商品名称 ,
d.barcode 商品条码,d.categoryid 三级分类编码,d.categoryname 三级分类名称,
b.qty 销售数量,b.xse 销售额,b.cb 销售成本,
 a.qty 库存数量,a.costvalue  库存成本 from dwuser.ef_shopstock a
 left join 
(select a.shopid,b.goodsid,sum(qty) qty,sum(salevalue)-sum(discvalue) xse ,
sum(costvalue) cb  
 from dwuser.ef_salegoods a
 left join dwuser.ef_salegoodsitem b 
  on a.sheetid=b.sheetid  
      where  sdate >=to_date('${开始查询日期}','yyyymmdd') and sdate<=to_date('${结束查询日期}','yyyymmdd')  
       group by 
       a.shopid ,b.goodsid
) b 
 on a.shopid=b.shopid and a.goodsid=b.goodsid  
  left join dwuser.vw_base_shop c
   on a.shopid=c.shopid
   left join dwuser.topic_base_goods d
    on a.goodsid=d.goodsid
      left join dwuser.vw_base_goodsextpub f
       on a.goodsid=f.goodsid   
  where   d.categoryid_dl>=70
    and exists (select s.shopid from dwuser.vw_user_shop s 
    where s.loginid = '${fr_username}' and s.shopid=a.shopid) 
   ${if(len(大区) == 0,""," and c.regionname_dq in ('" + 大区 + "')")}
    ${if(len(小区) == 0,""," and c.regionname in ('" + 小区 + "')")}
    ${if(len(门店) == 0,""," and c.shopname in ('" + 门店 + "')")}
     ${if(len(供应商编码) == 0,""," and d.advender in ('" + 供应商编码 + "')")}
     ${if(len(品牌编码) == 0,""," and d.brandid in ('" + 品牌编码 + "')")}
    ${if(len(商品编码) == 0,""," and d.goodsid in ('" + 商品编码 + "')")}
     ${if(len(商品条码) == 0,""," and d.barcode in ('" + 商品条码 + "')")}
    ${if(len(货号) == 0,""," and f.COL18 in ('" + 货号 + "')")}
    ${if(len(季节) == 0,""," and f.col7 in ('" + 季节 + "')")}
    ${if(len(年份) == 0,""," and f.COL17 in ('" + 年份 + "')")}  
  ${if(len(品类) == 0,""," and d.categoryname_dl in ('" + 品类 + "')")}        
  order by a.shopid
 

SELECT distinct regionid_dq,regionname_dq FROM Dwuser.Vw_Base_Shop  
 where flag <>5 
  and regionid_dq>=3701 
  and regionid_dq<3708
   order by regionid_dq

 SELECT distinct regionid_xq,regionname FROM Dwuser.Vw_Base_Shop  
 where flag <>5 
  and regionid_dq>=3701 
  and regionid_dq<3708
   ${if(len(大区) == 0,""," and  regionname_dq  in('" + 大区 + "')")}  

SELECT distinct shopid,shopname FROM Dwuser.Vw_Base_Shop  
 where flag <>5 
  and regionid_dq>=3701 
  and regionid_dq<3708
   ${if(len(大区) == 0,""," and  regionname_dq  in('" + 大区 + "')")}  
      ${if(len(大区) == 0,""," and  regionname  in('" + 小区 + "')")}  
   order by shopid


 select  distinct categoryid_dl  firstcode, categoryname_dl  firstname  from  dwuser.topic_base_goods
  where categoryid_dl>=90
   order by  categoryid_dl

/*select * from  dwuser.base_cloth_lab
 order by firstcode*/

