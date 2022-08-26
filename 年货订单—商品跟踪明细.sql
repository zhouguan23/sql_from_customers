select a.DeptCode,LEFT(A.GoodsCode,1)CategoryCode1,LEFT(A.GoodsCode,2)CategoryCode,a.GoodsCode ,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,a.Suppliername ,a.SalePrice ,a.PurchPrice ,
isnull(a.BuyerOrderAmount,0)BuyerOrderAmount,isnull(a.BuyerOrderMoney,0)BuyerOrderMoney,
isnull(b.SaleMoney,0)SaleMoney,ISNULL(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(Amount,0)Amount,isnull(TaxCost,0)TaxCost
from 
(select deptcode,A.GOODSCODE,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,a.Suppliername ,a.SalePrice ,a.PurchPrice ,
sum(BuyerOrderMoney)BuyerOrderMoney,sum(BuyerOrderAmount)BuyerOrderAmount from 
YEARPOBILLDETAIL a
where BuyerOrderMoney>0  
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and LEFT(GoodsCode,2) in ('" + replace(fl,",","','")+"')") }
group by deptcode,goodscode,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,a.Suppliername ,a.SalePrice ,a.PurchPrice )a
 left join 
 (select nodecode,goodscode,sum(a.SaleIncome+a.SaleTax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from  [000]A .tb201701_GoodsDayPSSM where  OccurDate between '20180101' and '20180228' 
union all 
select * from  [000]A .tb201702_GoodsDayPSSM where  OccurDate between '20180101' and '20180228')a

group by nodecode ,goodscode)b on a.DeptCode=b.NodeCode  and a.goodscode=b.GoodsCode 
 left join 
 (select CounterCode,GoodsCode ,SUM(Amount)Amount,SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%'
group by CounterCode,GoodsCode )c on a.GoodsCode =c.GoodsCode  and a.DeptCode=c.CounterCode 

order by 1,8,2


select A.DEPTCODE,LEFT(A.GoodsCode,1)CategoryCode1,LEFT(A.GoodsCode,2)CategoryCode,A.GOODSCODE,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,a.Suppliername ,a.SalePrice ,a.PurchPrice 
,SUM(ISNULL(Amount,0))Amount,SUM(ISNULL(PurchMoney,0))PurchMoney,SUM(ISNULL(PerformAmount,0))PerformAmount,SUM(ISNULL(PerformMoney,0))PerformMoney  from 
YEARPOBILLDETAIL  A
LEFT JOIN 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
group by zb.InDeptCode,GoodsCode

union all 

select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201701_PURORDERBILL zb ,
[6001]A .tb201701_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228'and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201701_PURORDERBILL zb ,
[6001]A .tb201701_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201701_DISTORDERBILL zb ,
[6001]A .tb201701_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
group by zb.InDeptCode,GoodsCode

union all 

select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201702_PURORDERBILL zb ,
[6001]A .tb201702_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201702_PURORDERBILL zb ,
[6001]A .tb201702_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201702_DISTORDERBILL zb ,
[6001]A .tb201702_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
group by zb.InDeptCode,GoodsCode
)B ON A.DEPTCODE =B.InDeptCode AND  A.GOODSCODE=B.GoodsCode
where a.DEPTCODE in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and LEFT(A.GoodsCode,2) in ('" + replace(fl,",","','")+"')") }
group by A.DEPTCODE,LEFT(A.GoodsCode,2),A.GOODSCODE,a.GoodsName ,
a.WorkStateCode,a.CirculationModeCode,a.WholePackRate,a.BaseMeasureUnit,
a.Suppliername ,a.SalePrice ,a.PurchPrice 

order by 1,2,10,3




