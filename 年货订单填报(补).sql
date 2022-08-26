SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )A
WHERE   1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")}
order by 1


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
      ,a.StoreOrderAmount
      ,a.StoreOrderMoney
      ,a.BuyerOrderAmount
      ,a.BuyerOrderMoney
      ,a.OrderAmount
      ,a.OrderMoney
      ,a.Remark
      ,a.IsImportGoods
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
  StartCost+StartTax
+ PURCHCOST+PurchTax --进货
+ REDEPLOYINCOST+RedeployinTax --拨入
+ PROFITCOST+ProfitTax --升溢
+ COUNTPROFITCOST+CountProfitTax --盘升
- TaxSaleCost  --销售
- REDEPLOYOUTCOST-RedeployoutTax --拨出
- LOSSCOST-LossTax --损耗
- COUNTLOSSCOST-CountLossTax --盘耗
-ToGiftCost-ToGiftTax --转赠品
,0
)TaxStockCost


 from 
tbYEARPOBILLDETAIL a
left join 
hldw.dbo.tb${YM}_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
TBNodeVS c on a.deptcode=c.nodecode
left join 
TBAnnualgoodsVSYear d on d.DataType='0' and  a.goodscode=d.goodscode and c.Y_VSnodecode=d.nodecode
left join 
TBAnnualgoodsVSYear e on e.DataType='1' and  a.goodscode=e.goodscode and c.M_VSnodecode=e.nodecode

where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and
1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }

order by 28 desc ,   3 asc

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

select * from 
TBAnnualgoodsVSYear
where 

