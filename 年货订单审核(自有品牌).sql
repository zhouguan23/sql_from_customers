

select distinct ColonyCode,ColonyName Node
,'' AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047,1070)
and len(ColonyCode)!=0
union all

select nodecode,nodecode+' '+NodeName Node
,ColonyCode AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047,1070)
and len(ColonyCode)!=0
order by 3,1



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
+  b.PURCHCOST+PurchTax --进货
+  b.REDEPLOYINCOST+RedeployinTax --拨入
+ b. PROFITCOST+ProfitTax --升溢
+  b.COUNTPROFITCOST+CountProfitTax --盘升
-  b.TaxSaleCost  --销售
-  b.REDEPLOYOUTCOST-RedeployoutTax --拨出
-  b.LOSSCOST-LossTax --损耗
-  b.COUNTLOSSCOST-CountLossTax --盘耗
- b.ToGiftCost-ToGiftTax --转赠品
,0
)TaxStockCost


 from 
(
select a.* from    [HLDDDW]A.[dbo]A.[tbYEARPOBILLDETAIL]A a ,[HLDW]A.[dbo]A.tb商品档案 b
where a.goodscode=b.goodscode and b.GoodsBrand='010001' 
and  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") } 
and
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in (  '" + replace(fl,",","','")+"')") }
) a
left join 
hldw.dbo.tb${YM}_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
TBNodeVS c on a.deptcode=c.nodecode
left join 
TBAnnualgoodsVSYear d on d.DataType='0' and  a.goodscode=d.goodscode and c.Y_VSnodecode=d.nodecode
left join 
TBAnnualgoodsVSYear e on e.DataType='1' and  a.goodscode=e.goodscode and c.M_VSnodecode=e.nodecode


order by 28 desc ,   3 asc

select round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0000'
and BudgetYM  between  convert(varchar(6),'202001',112) and  convert(varchar(6),'202002',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }



select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from TB商品分类表
  where CategoryItemCode='0000' and (left(CategoryCode,1) between 3 and 5  or  left(CategoryCode,2)=14 )
and CategoryLevel=2

select * from 
TBAnnualgoodsVSYear
where 

  SELECT CategoryCode,CategoryName,case when CategoryLevel='1' then '' else ParentCategoryCode end ParentCategoryCode FROM 
  [HLCWDW]A.[dbo]A.TB分类对照表
  WHERE CategoryItemCode='0002' and CategoryLevel>='1'
   AND CategoryCode NOT  LIKE '1%' AND ParentCategoryCode NOT  LIKE '1%' AND CategoryCode NOT  LIKE '2%' AND ParentCategoryCode NOT  LIKE '2%' 
  AND CategoryCode NOT  LIKE '6%' AND ParentCategoryCode NOT  LIKE '6%' 

