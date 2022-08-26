select distinct a.CategoryCode
      ,a.CateCatCode
      ,a.GoodsCode
      ,a.GoodsName
      ,a.DeptCode
      ,a.BaseBarCode
      ,a.GoodsType
      ,a.BaseMeasureUnit
      ,a.WholePackRate
      ,a.PackRate
      ,a.SupplierCode
      ,a.SupplierName
      ,a.WorkStateCode
      ,a.CirculationModeCode
      ,a.PurchPrice
      ,a.SaleMoney
      ,d.SaleAmount LastyearAmount
      ,d.SaleMoney LastyearMoney
      ,e.SaleAmount PreganglionicAmount
      ,e.SaleMoney PreganglionicMoney
      ,F.SaleAmount Lastc2yearAmount
      ,F.SaleMoney Lastc2yearMoney
      ,a.StoreOrderAmount
      ,a.StoreOrderMoney
      ,a.BuyerOrderAmount
      ,a.BuyerOrderMoney
      ,a.OrderAmount
      ,a.OrderMoney
      ,a.Remark
      ,a.IsImportGoods
      ,a.InProm
      ,a.LYIsImportGoods
      ,a.LYInProm
      ,a.The1batch
      ,a.The2batch
      ,a.The3batch
,isnull(
  b.StartAmount --期初
+ b.PURCHAmount --进货
+ b.REDEPLOYINAmount --拨入
+ b.PROFITAmount --升溢
+ b.COUNTPROFITAmount --盘升
- b.SaleAmount  --销售
- b.REDEPLOYOUTAmount --拨出
- b.LOSSAmount --损耗
- b.COUNTLOSSAmount --盘耗
- b.ToGiftAmount
,0
)StockAmount
,isnull(
  b.StartCost+b.StartTax
+ b.PURCHCOST+b.PurchTax --进货
+ b.REDEPLOYINCOST+b.RedeployinTax --拨入
+ b.PROFITCOST+b.ProfitTax --升溢
+ b.COUNTPROFITCOST+b.CountProfitTax --盘升
- b.TaxSaleCost  --销售
- b.REDEPLOYOUTCOST-b.RedeployoutTax --拨出
- b.LOSSCOST-b.LossTax --损耗
- b.COUNTLOSSCOST-b.CountLossTax --盘耗
- b.ToGiftCost-b.ToGiftTax --转赠品
,0
)TaxStockCost


 from 
${TBName} a
left join 
hldw.dbo.tb${YM}_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
TBNodeVS c on a.deptcode=c.nodecode
left join 
TBAnnualgoodsVSYear d on d.DataType='0' and  a.goodscode=d.goodscode and c.Y_VSnodecode=d.nodecode
left join 
TBAnnualgoodsVSYear e on e.DataType='1' and  a.goodscode=e.goodscode and c.M_VSnodecode=e.nodecode
left join 
TBAnnualgoodsVSYear F on F.DataType='2' and  a.goodscode=F.goodscode and C.Y_VSnodecode=F.nodecode

where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }

order by a.IsImportGoods desc,a.LYIsImportGoods desc,a.Remark desc,a.InProm desc,a.LYInProm desc,   3 asc

select round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'202001',112) and  convert(varchar(6),'202002',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }



select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from TB商品分类表
  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

select sum(a.SeleMoney)SeleMoney2018,sum(b.SeleMoney)SeleMoney2019 from 
(select sum(a.SaleIncome+a.SaleTax)SeleMoney from 
(select * from tb201802_GoodsDayPSSM union all select * from tb201801_GoodsDayPSSM) a,
tb商品档案 b
where a.GoodsCode=b.goodscode and b.goodstype in (0) and CategoryCode not like '300%'
and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") })a,
(select sum(a.SaleIncome+a.SaleTax)SeleMoney from 
(select * from tb201902_GoodsDayPSSM union all select * from tb201901_GoodsDayPSSM) a,
tb商品档案 b
where a.GoodsCode=b.goodscode and b.goodstype in (0) and CategoryCode not like '300%' and
1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") })b

