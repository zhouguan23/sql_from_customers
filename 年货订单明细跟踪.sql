select a.YM,a.CategoryCode,a.CateCatCode,a.GoodsCode,a.GoodsName,a.DeptCode,a.BaseBarCode,a.WholePackRate,a.PackRate,a.Remark,
sum(isnull(a.StoreOrderAmount,0))StoreOrderAmount,sum(isnull(a.StoreOrderMoney,0))StoreOrderMoney,sum(isnull(a.BuyerOrderAmount,0))BuyerOrderAmount,sum(isnull(a.BuyerOrderMoney,0))BuyerOrderMoney,sum(isnull(a.OrderAmount,0))OrderAmount,sum(isnull(a.OrderMoney,0))OrderMoney,
sum(isnull(c.LastyearAmount,0))LastyearAmount,sum(isnull(c.LastyearMoney,0))LastyearMoney,
sum(isnull(c.PreganglionicAmount,0))PreganglionicAmount,sum(isnull(c.PreganglionicMoney,0))PreganglionicMoney,sum(isnull(b.Amount,0))Amount,sum(isnull(b.TaxCost,0))TaxCost,
SUM(ISNULL(d.Amount,0))xdAmount,SUM(ISNULL(d.PurchMoney,0))xdPurchMoney,SUM(ISNULL(d.WayAmount,0))WayAmount,SUM(ISNULL(d.WayMoney,0))WayMoney,SUM(ISNULL(d.PerformAmount,0))PerformAmount,SUM(ISNULL(d.PerformMoney,0))PerformMoney from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.countercode and a.goodscode=b.goodscode
left join 
TBAnnualgoodsVSYear c on a.PromID=c.PromID 
left join 
tbAnnualorder d on a.DeptCode =d.DeptCode and a.GoodsCode =d.GoodsCode 
where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
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
and 
1=1 ${if(len(spbm) == 0,   "",   "and a.goodscode in ('" + replace(spbm,",","','")+"')") }
and 
1=1 ${if(len(jyzt) == 0,   "",   "and a.WorkStateCode in ('" + replace(jyzt,",","','")+"')") }
and a.CateCatCode<>'333'
and 
1=1 ${if(len(zykz) == 0,   "",   "and exists(select 1 from TB部门特殊商品对照 e where  a.DeptCode =e.NodeCode and a.GoodsCode =e.GoodsCode and e.GoodsPropertyCode='1999')") }




group by a.PromID,a.YM,a.CategoryCode,a.CateCatCode,a.GoodsCode,a.GoodsName,a.DeptCode,a.BaseBarCode,a.GoodsType,a.BaseMeasureUnit,a.WholePackRate,a.PackRate,a.SupplierCode,a.SupplierName,a.WorkStateCode,a.CirculationModeCode,a.PurchPrice,a.SaleMoney,a.StoreOrderAmount,a.StoreOrderMoney,a.BuyerOrderAmount,a.BuyerOrderMoney,a.OrderAmount,a.OrderMoney,a.Remark
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


