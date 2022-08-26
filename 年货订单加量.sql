select a.PromID,a.YM,a.CategoryCode,a.CateCatCode,a.GoodsCode,a.GoodsName,a.DeptCode,a.BaseBarCode,a.GoodsType,a.BaseMeasureUnit,a.WholePackRate,a.PackRate,a.SupplierCode,a.SupplierName,a.WorkStateCode,a.CirculationModeCode,a.PurchPrice,a.SaleMoney,a.StoreOrderAmount,a.StoreOrderMoney,a.BuyerOrderAmount+a.OrderAmount BuyerOrderAmount,a.BuyerOrderMoney+a.OrderMoney BuyerOrderMoney,a.OrderAmount,a.OrderMoney,a.Remark
,isnull(c.LastyearAmount,0)LastyearAmount,isnull(c.LastyearMoney,0)LastyearMoney,
isnull(c.PreganglionicAmount,0)PreganglionicAmount,isnull(c.PreganglionicMoney,0)PreganglionicMoney,isnull(b.Amount,0)Amount,isnull(b.TaxCost,0)TaxCost

 from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.countercode and a.goodscode=b.goodscode
left join 
TBAnnualgoodsVSYear c on a.PromID=c.PromID


where  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and CateCatCode<>'333'
and a.Remark <>'0'

order by 13,7,1,3,5 asc

select deptcode,round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'201901',112) and  convert(varchar(6),'201902',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }
group by deptcode 

select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

