select a.PromID,a.YM,a.CategoryCode,a.CateCatCode,a.GoodsCode,a.GoodsName,a.DeptCode,a.BaseBarCode,a.GoodsType,a.BaseMeasureUnit,a.WholePackRate,a.PackRate,a.SupplierCode,a.SupplierName,a.WorkStateCode,a.CirculationModeCode,a.PurchPrice,a.SaleMoney,a.StoreOrderAmount,a.StoreOrderMoney,a.BuyerOrderAmount,a.BuyerOrderMoney,a.OrderAmount,a.OrderMoney,a.Remark,isnull(c.LastyearAmount,0)LastyearAmount,isnull(c.LastyearMoney,0)LastyearMoney,
isnull(c.PreganglionicAmount,0)PreganglionicAmount,isnull(c.PreganglionicMoney,0)PreganglionicMoney,isnull(b.Amount,0)Amount,isnull(b.TaxCost,0)TaxCost from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.countercode and a.goodscode=b.goodscode
left join 
TBAnnualgoodsVSYear c on a.PromID=c.PromID
where 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and
1=1 ${if(len(zd) == 0,   "",   "and a.Remark in ('" + replace(zd,",","','")+"')") }
and
1=1 ${if(len(pp) == 0,   "",   "and a.GoodsType in ('" + replace(pp,",","','")+"')") }
and
1=1 ${if(len(tj) == 0,   "",   "and a.CirculationModeCode in ('" + replace(tj,",","','")+"')") }
and 
1=1 ${if(len(gys) == 0,   "",   "and a.SupplierCode in ('" + replace(gys,",","','")+"')") }
and CateCatCode<>'333'

order by 25 desc ,   1 asc

select round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'201901',112) and  convert(varchar(6),'201902',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }

select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

select * from 
TBAnnualgoodsVSYear a


