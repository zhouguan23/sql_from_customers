
select distinct FormatCode NodeCode ,FormatName NodeName ,'' AreaCode from 
dbo.TB部门信息表 a

where left(a.nodecode,1) in (1,2,6,7,8)  and a.nodecode not in (6601,6602) and len(AreaCode)<>0 and FormatCode in ('01','02','03','06','07','08')
union all 
select 
NodeCode,NodeCode+' '+NodeName  NodeName,FormatCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2,6,7,8)  and a.nodecode not in (6601,6602) and len(FormatCode)<>0 
and FormatCode in ('01','02','03','06','07','08')


select * from 
(select a.PromID,a.YM,a.CategoryCode,a.CateCatCode,a.GoodsCode,a.GoodsName,a.DeptCode,a.BaseBarCode,a.GoodsType,a.BaseMeasureUnit,a.WholePackRate,a.PackRate,a.SupplierCode,a.SupplierName,a.WorkStateCode,a.CirculationModeCode,a.PurchPrice,a.SaleMoney,a.StoreOrderAmount,a.StoreOrderMoney,a.BuyerOrderAmount,a.BuyerOrderMoney,a.OrderAmount,a.OrderMoney,case when a.Remark=2 then 0 else a.Remark end Remark
,isnull(c.LastyearAmount,0)LastyearAmount,isnull(c.LastyearMoney,0)LastyearMoney,
isnull(c.PreganglionicAmount,0)PreganglionicAmount,isnull(c.PreganglionicMoney,0)PreganglionicMoney,isnull(b.Amount,0)Amount,isnull(b.TaxCost,0)TaxCost,
case when a.CategoryCode like '3%' or a.CategoryCode like '14%' then '30' 
when a.CategoryCode like '5%' then '50' 
when a.CategoryCode like '4%' and a.CategoryCode not like '46%' and a.CategoryCode not like '47%' then '40'
when a.CategoryCode like '46%' or a.CategoryCode like '47%' then '46' end CateCatCode1 

 from 
TBYEARPOBILLDETAIL a
left join 
tbStocks b on a.deptcode=b.countercode and a.goodscode=b.goodscode
left join 
TBAnnualgoodsVSYear c on a.PromID=c.PromID


where  GoodsType='1')a
where  1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CateCatCode1 in ('" + replace(fl,",","','")+"')") }
and CateCatCode<>'333'

order by 25 desc ,13,7,1,4,5 asc

select SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%'
 and CounterCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
and 1=1 ${if(len(bm) == 0,   "",   "and CounterCode in ('" + replace(bm,",","','")+"')") }

select deptcode,round(sum(Salesindex),2) Salesindex
 from 含税分课预算表  a 
 where a.CategoryItemCode='0001'
and BudgetYM  between  convert(varchar(6),'201901',112) and  convert(varchar(6),'201902',112)
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }
group by deptcode 

SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))A

order by 1


select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

select A.DEPTCODE,LEFT(A.GoodsCode,1)CategoryCode1,LEFT(A.GoodsCode,2)CategoryCode,A.GOODSCODE,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,a.Suppliername ,a.SalePrice ,a.PurchPrice 
,SUM(ISNULL(Amount,0))Amount,SUM(ISNULL(PurchMoney,0))PurchMoney,SUM(ISNULL(PerformAmount,0))PerformAmount,SUM(ISNULL(PerformMoney,0))PerformMoney  from 
YEARPOBILLDETAIL  A
LEFT JOIN 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月


)B ON A.DEPTCODE =B.InDeptCode AND  A.GOODSCODE=B.GoodsCode
where a.DEPTCODE in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
group by A.DEPTCODE,LEFT(A.GoodsCode,2),A.GOODSCODE,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,
a.Suppliername ,a.SalePrice ,a.PurchPrice 
order by 1,2,10,3

select a.DeptCode,a.CategoryCode1,a.CategoryCode,isnull(a.Salesindex,0)Salesindex,isnull(a.Grossprofitindex,0)Grossprofitindex,
isnull(b.SaleMoney,0)SaleMoney,ISNULL(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(Amount,0)Amount,isnull(TaxCost,0)TaxCost,
isnull(d.BuyerOrderAmount,0)BuyerOrderAmount,isnull(d.BuyerOrderMoney,0)BuyerOrderMoney from 
(select a.DeptCode,left(CategoryCode,1)CategoryCode1,CategoryCode,round(sum(Salesindex),2) Salesindex,round(SUM(a.Grossprofitindex),2)Grossprofitindex
 from WHLessonBudget a 
 where BudgetYM  between  convert(varchar(6),'201801',112) and  convert(varchar(6),'201802',112) 
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
 group by a.DeptCode,a.CategoryCode)a
 left join 
 (select nodecode,left(goodscode,2)CategoryCode,sum(a.SaleIncome+a.SaleTax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from  [000]A .tb201701_GoodsDayPSSM where  OccurDate between '20180101' and '20180228' 
union all 
select * from  [000]A .tb201702_GoodsDayPSSM where  OccurDate between '20180101' and '20180228')a
where a.NodeCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
group by nodecode ,left(goodscode,2))b on a.DeptCode=b.NodeCode  and a.CategoryCode=b.CategoryCode 
 left join 
 (select CounterCode,left(goodscode,2)CategoryCode,SUM(Amount)Amount,SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%'
 and CounterCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
group by CounterCode,left(goodscode,2))c on a.CategoryCode=c.CategoryCode and a.DeptCode=c.CounterCode 
left join 
(select deptcode,left(goodscode,2)CategoryCode,sum(BuyerOrderMoney)BuyerOrderMoney,sum(BuyerOrderAmount)BuyerOrderAmount from 
YEARPOBILLDETAIL
where deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
group by deptcode,left(goodscode,2)) d on a.DeptCode=d.deptcode and a.CategoryCode=d.CategoryCode
order by 1,2,3


select a.deptcode,a.GoodsCode,a.BaseBarCode ,a.GoodsName,isnull(f.BrandName,'')BrandName,a.BaseMeasureUnit,a.WholePackRate,
b.SupplierCode+' '+c.SupplierName SupplierName,a.WorkStateCode,d.CirculationModeCode,
b.PurchPrice,case when a.SalePrice is null  then e.SalePrice else a.SalePrice end SalePrice


from 
(select a.deptcode,b.CategoryCode,a.GoodsCode,a.WorkStateCode,GoodsBrand BrandCode ,
b.GoodsName ,b.BaseBarCode ,b.WholePackRate ,b.BaseMeasureUnit,b.SalePrice
  from 
[000]A .TBDEPTWORKSTATE a 
,
[000]A .tbGoods  b 
where a.WorkStateCode in (1,2,5) and  a.GoodsCode =b.GoodsCode and b.GoodsType =0 
and  b.CategoryCode not like '0%' and  b.CategoryCode not like '1%'  and b.CategoryCode not like '6%' and  b.CategoryCode not like '2%'
and  b.CategoryCode not like '300%' and left(a.DeptCode,1) between 1 and 2 )a
left join 
[000]A .tbDeptGoodsSupp b on a.DeptCode =b.DeptCode and a.GoodsCode =b.GoodsCode 
left join 
[000]A .TBSUPPLIER c on b.SupplierCode =c.SupplierCode
left join 
[000]A .TBDEPTCIRCULATION d on a.DeptCode =d.DeptCode and a.GoodsCode =d.GoodsCode 
left join 
[000]A .TBDEPTSALEPRICE e on a.DeptCode =e.DeptCode and a.GoodsCode =e.GoodsCode 
left join 
[000]A .TBGOODSBRAND f on a.BrandCode=f.BrandCode 

where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and a.CategoryCode in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and b.SupplierCode in ('" + replace(gys,",","','")+"')") }

order by 1,2


select * from 
TBAnnualgoodsVSYear a


select * from 
TB分类对照表 a
where CategoryLevel not in (0,3)
and a.CategoryItemCode='0002'

