	select SupplierCode+' '+SupplierName supplierName,LEFT(a.CategoryCode,2)GoodsCatcode,a.GoodsCode,GoodsName,BarCode,DepartmentCode ,StockAmount,PurchStockMoney,WorkStateCode,CirculationModeCode,LastWorkStateDate,OutSign,
	(CommonDMS+PromotionDMS)DMS,DATEDIFF ( day , a.LastSaleDate , GETDATE())WUnSalaNotSellDay,b.UnSalaNotSellDay,a.SalePrice,a.PurchPrice PurchPrice,

	case when  (CommonDMS+PromotionDMS)=0 then 0 else  StockAmount/(CommonDMS+PromotionDMS) end kxts  from 
	[000]A .tb${TM}_REPORTINFO a 
	left join 
	[000]A .TBREPORTPARADEFINE b on left(a.CategoryCode,4)= b.GoodsCode and b.deptcode=''
	left join
	(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
	[000]A.TBCATTODEPARTMENT a
	left join
	[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
	where  a.DeptCatItemCode ='0011')c on a.DepartmentCode=c.nodecode
	left join
	(select a.DeptCategoryCode,b.CategoryName,a.NodeCode from 
	[000]A.TBCATTODEPARTMENT a
	left join
	[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0013'
	where  a.DeptCatItemCode ='0013')d on a.DepartmentCode=d.nodecode
	where ReportDate=convert(varchar(8),dateadd(mm,0,'${rq}'),112) and DepartmentCode in (
	select a.NodeCode   from 
	[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
	where	  a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
	and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,'${rq}'),112))
	and WorkStateCode in (3,50) and round(StockAmount,2)>0
	and  1=1 ${if(len(bm) == 0,   "",   "and a.DepartmentCode in ('" + replace(bm,",","','")+"')") }

	and  1=1 ${if(len(fl2) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
 and a.CategoryCode not like '35000'
	and  1=1 ${if(sx == 0,   "",   "and exists  ( select * from (select GoodsPropertyCode,GoodsCode,GoodsPropId from 
[000]A .TBGOODSPROPINCLUSIONS
where GoodsPropertyCode ='2001'
union all
select GoodsBrand ,GoodsCode ,'0'GoodsPropid from 
[000]A .tbGoods 
where GoodsBrand ='010001') b where a.goodscode=b.goodscode and b.GoodsPropertyCode='" +sx+"')") }
	order by 1,3,6


select distinct deptcode,goodscode from 
(select '1'DeptType,a.NodeCode DeptCode,a.DeptCatItemCode CategoryItemCode,b.GoodsCode,b.ForbidSupplier,b.dCCode,b.NGoodsRefundTerm,b.NBeginDate,b.NEndDate,b.Remark,b.SubHQCode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[6001]A.TBCATTODEPARTMENT a
left join
[6001]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") })a
left join 
(select * from 
[6001]A.TBRSKUPOLNO 
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select * from 
[6001]A.TBRSKUPOLNO where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate and  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
)a

select distinct deptcode,goodscode from 
(select '1'DeptType,a.NodeCode DeptCode,a.DeptCatItemCode CategoryItemCode,b.GoodsCode,b.ForbidSupplier,b.dCCode,b.NGoodsRefundTerm,b.NBeginDate,b.NEndDate,b.Remark,b.SubHQCode from 
(select  DeptCatItemCode,b.CategoryCode,b.CategoryName,a.NodeCode from 
[6001]A.TBCATTODEPARTMENT a
left join
[6001]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0001'
where  a.DeptCatItemCode ='0001' 	and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") })a
left join 
(select * from 
[6001]A.TBRSKUPOLNO 
where DeptType ='0' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate)b on a.CategoryCode=b.DeptCode and a.DeptCatItemCode=b.CategoryItemCode
union all 
select * from 
[6001]A.TBRSKUPOLNO where DeptType ='1' and convert(varchar(8),dateadd(mm,0,GETDATE()),112) between NBeginDate and NEndDate and  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
)a

select DeptCode ,GoodsCode ,case when DeptRemark like '%P%' or DeptRemark like '%p%' then 'P' when DeptRemark like '%R%' or DeptRemark like '%r%'  then 'R' else '' end DeptRemark,
case when LEN(DeptRemark)<>1  then SUBSTRING(DeptRemark,2,99) ELSE '' end  DeptRemarkDATE  from 
[000]A .tbDeptWorkState 
where len(DeptRemark)<>0 and  1=1 ${if(len(bm) == 0,   "",   "and DeptCode in ('" + replace(bm,",","','")+"')") }

select DeptCode ,GoodsCode ,BeginDate+'-'+EndDate Date,
CASE WHEN PriceMode=1 then   CAST(SaleMoney/10 AS varchar)+'折' else CAST(SaleMoney AS varchar) end SaleMoney from 
[000]A .TBDEPTPROMPRICE
where convert(varchar(8),dateadd(dd,0,GETDATE()),112) between BeginDate and EndDate and IsStop=0
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }

