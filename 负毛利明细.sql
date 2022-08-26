select a.NodeCode,left(b.CategoryCode,2)CategoryCode2,b.CategoryCode,a.goodscode,b.GoodsName,b.BaseBarCode ,b.BaseMeasureUnit,b.GoodsType,c.SupplierCode+' '+c.SupplierName SupplierCode,
c.CirculationModeCode,c.WorkStateCode ,c.PurchPrice,isnull(f.PurchSign,0)PurchSign,c.SalePrice,isnull(f.CustomSign,0)CustomSign,case when  len(g.GoodsCode)>0 then 1 else 0 end PromotionSign,
isnull(g.SpecialPrice,0)SpecialPrice,isnull(g.SaleMoney,0) SpecialMoney,
SaleAmount,TaxSaleCost,(SaleIncome+SaleTax)SaleMoney ,TaxSaleGrossProfit,CommonSaleAgio,CommonDMS+PromotionDMS DMS,
FreshLossAmount,FreshLossCost+FreshLossTax FreshLoss,
StockAmount,PurchStockMoney from 
(select * from [000]A .TB${YM}_GoodsDayPSSM where round(TaxSaleGrossProfit,1)<0 and left(NodeCode ,1) between 1 and 2 and occurdate='${rq}')  a
left join 
[000]A .tbGoods b on a.GoodsCode =b.GoodsCode and b.GoodsType in (0,2) and left(b.CategoryCode,1) between 1 and 5
left join 
[000]A .TB${YM}_Reportinfo c on a.nodecode =c.DepartmentCode and a.GoodsCode =c.GoodsCode and a.OccurDate =c.ReportDate 
left join
(select nodecode,goodscode ,max(a.CustomSign)CustomSign,max(a.PurchSign)PurchSign from 
(select NodeCode,GoodsCode ,a.CustomSign,a.PurchSign from 
[000]A .TBCUSTOMPRICE a 
left join 
[000]A .TBCATTODEPARTMENT b on a.DeptCode =b.DeptCategoryCode and b.DeptCatItemCode='0000'
where DeptType =0  and CustomSign+PurchSign>0 
union all 
select DeptCode,GoodsCode,CustomSign ,PurchSign  from 
[000]A .TBCUSTOMPRICE
where DeptType =1 and CustomSign+PurchSign>0)a 
group by nodecode,goodscode)f on a.NodeCode =f.NodeCode and a.GoodsCode =f.GoodsCode 
left join 
(select  DeptCode ,GoodsCode,min(SpecialPrice)SpecialPrice,min(SaleMoney)SaleMoney
from [000]A .TBDEPTPROMPRICE 
where '${rq}' between BeginDate and EndDate and IsStop=0
group by deptCode ,GoodsCode)g on a.NodeCode =g.DeptCode and a.GoodsCode =g.GoodsCode 
where a.GoodsCode =b.GoodsCode and b.GoodsName not like '%白条%'

and  1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2)  in ('" + replace(fl2,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") }
order  by a.NodeCode,b.CategoryCode,a.goodscode




