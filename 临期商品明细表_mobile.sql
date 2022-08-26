
select * from 
(select  b.DepartmentCode,a.GoodsCode ,a.GoodsName,left(b.CategoryCode,2)CategoryCode,left(b.CategoryCode,1)CategoryCode1,a.BaseMeasureUnit,b.CirculationModeCode,a.BaseBarCode,b.SupplierName,b.WorkStateCode,
		b.CommonDMS+b.PromotionDMS average,b.StockAmount,b.StockMoney,
		b.SalePrice,b.SupplierCode,b.lastPurchDate,b.LastSaleDate,
   DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112)) StockNumber,durability,--判断它从进货日期到昨天多少天了
   DATEDIFF(day,b.LastSaleDate,convert(varchar(8),dateadd(dd,-1,getdate()),112)) unmarketableNumber,--判断它有多少天没有销售
case 
--常温
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability>365 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112)) between 1 and 90 then '临期'--判断保质期大于365天的并且剩余保质期天数在90天以内的为临期
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability between 181 and 364 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 1 and 60 then '临期'--判断保质期大于181到365天的并且剩余保质期天数在60天以内的为临期
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability between 91 and 180 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 1 and 30 then '临期'--判断保质期<180天的并且剩余保质期天数在30天以内的为临期
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability between 31 and 90 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 1 and 20 then '临期'--判断保质期大于30到90天的并且剩余保质期天数在15天以内的为临期
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability between 16 and 30 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 1 and 10 then '临期'--判断保质期大于16到30天的并且剩余保质期天数在7天以内的为临期
when left(a.CategoryCode,3) not in ('341','340','342','344') and  durability between 1 and 15 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 1 and 5 then '临期'--判断保质期大于1到15天的并且剩余保质期天数在4天以内的为临期
--低温
when left(a.CategoryCode,3) in ('341','340','342','344') and  durability >20 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112)) between 1 and 7 then '临期'--判断保质期21天到60天的并且剩余保质期天数在7天以内的为临期
when left(a.CategoryCode,3) in ('341','340','342','344') and  durability between 4 and 20 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))between 2 and 5 then '临期'--判断保质期4天到20天的并且剩余保质期天数在前5天以内的为临期
when left(a.CategoryCode,3) in ('341','340','342','344') and  durability=3 and durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))=1 then '临期'--判断保质期等于3的并且剩余保质期天数在1天以内的为临期

when durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112))<=0 then '已过期'--大于保质期的商品为已过期
else '未到期' end  expire ,--大于临期的日期的商品为未到期
durability-DATEDIFF(day,b.lastPurchDate,convert(varchar(8),dateadd(dd,-1,getdate()),112)) Time --判断它还有多少天过期
From "000" .tbGoods a,--商品档案
"000" .tb${YM}_Reportinfo b  --报表信息
where 
a.GoodsCode =b.GoodsCode --判断两张表商品编码完全相同的
and (a.CategoryCode like '1%' or a.CategoryCode like '2%' or a.CategoryCode like '3%' or a.CategoryCode like '5%')--取商品分类编码左等于1生鲜,2加工,3食品,5日化的商品

and durability>0 and b.StockAmount>0		--取保质期大于0的商品,库存数量大于0的商品
 and a.BaseBarCode<>''  and LEN(b.lastPurchDate)>0--商品条码不为空的商品 ,进货日期不为空的商品
and a.GoodsType =0							--商品类型等于0的商品
 and ReportDate ='${rq}' 
 and  1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl,",","','")+"')") } 
 and  1=1 ${if(len(bm)==0,"","and b.DepartmentCode in ('"+replace(bm,",","','")+"')")} 
)a
where expire not like '未到期'  and  1=1 ${if(len(lx)==0,"","and expire in ('"+replace(lx,",","','")+"')")} 
order by 1,4,3


select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' 
  else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<=2
 order by 1

select ParentCategoryCode,CategoryCode,case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<3

