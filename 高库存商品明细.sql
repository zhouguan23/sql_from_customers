select b.商品编码,b.商品名称,b.库存数量,b.含税库存成本,b.正常DMS+b.促销DMS DMS,b.最后销货日,b.最后进货日,
b.库存数量/(case when (b.正常DMS+b.促销DMS)=0 then 0.01 else(b.正常DMS+b.促销DMS) end )可销天数

from 
 TB商品档案 a 
 left join 
 tb${YM}_报表数据源 b on a.GoodsCode =b.商品编码
 left join 
 TBREPORTPARADEFINE c on c.DeptCode ='' and left(a.CategoryCode,4)=c.GoodsCode
 where LEFT(a.CategoryCode ,1 ) in ('1','2','3','4','5')
 and a.GoodsType in ('0','2')  and b.经营状态 in ('1','2','3','4','5','50')
 and  1=1 ${if(len(bm) == 0,   "",   "and b.部门编码 in ('" + replace(bm,",","','")+"')") }
 and  1=1 ${if(len(fl2) == 0,   "",   "and LEFT(a.CategoryCode ,2 ) in ('" + replace(fl2,",","','")+"')") }
 and b.报表日期='${rq}'
 and b.库存数量>=3 and b.含税库存成本>500 
 and  LEN(b.本期促销起止日期)=0 and DATEDIFF(DAY,b.最后进货日 ,报表日期)>=20
 and  b.库存数量/(case when (b.正常DMS+b.促销DMS)=0 then 0.01 else(b.正常DMS+b.促销DMS) end )>c.HighStockCanSellDay
 


