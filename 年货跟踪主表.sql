select a.DeptCode ,A.CategoryCode1,a.CategoryCode ,
SUM(isnull(B.Salesindex,0))Salesindex,SUM(ISNULL(B.Grossprofitindex,0))Grossprofitindex,
SUM(isnull(C.SaleMoney,0))zSaleMoney,SUM(isnull(C.TaxSaleGrossProfit,0))zTaxSaleGrossProfit,
SUM(isnull(A.SaleMoney,0))SaleMoney,SUM(isnull(A.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
SUM(isnull(A.Amount,0))Amount,SUM(isnull(A.Money,0))money,
SUM(isnull(A.kcAmount,0))kcAmount,SUM(isnull(A.kcCost,0))kcCost 
FROM 
(SELECT CategoryCode1,CategoryCode,DeptCode,
SUM(Amount)Amount ,SUM(Money)Money,SUM(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,
SUM(kcAmount)kcAmount,SUM(kcCost)kcCost  FROM 
(select left(a.GoodsCode,1)CategoryCode1,left(a.GoodsCode,2)CategoryCode,a.GoodsCode,b.DeptCode ,c.CirculationModeCode,d.SupplierCode+' '+g.SupplierName SupplierName
,ISNULL(kcAmount,0)Amount ,ISNULL(kcMoney,0)Money,ISNULL(F.SaleMoney,0)SaleMoney,ISNULL(F.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
ISNULL(I.Amount,0)kcAmount,ISNULL(I.taxCost,0)kcCost 
  from 
[000]A .tbGoods a
left join 
[000]A .tbDeptWorkState b on a.GoodsCode=b.GoodsCode 
left join 
[000]A .tbDeptCirculation c on b.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode
left join  
[000]A .tbDeptGoodsSupp d on b.DeptCode=d.DeptCode and a.GoodsCode=d.GoodsCode
left join 
[000]A .TBSUPPLIER g on d.SupplierCode =g.SupplierCode
LEFT JOIN 
YEARPOBILLDETAIL E ON  b.DeptCode=E.DeptCode and a.GoodsCode=E.GoodsCode
left join 
(select NodeCode,GoodsCode,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(TaxSaleGrossProfit) TaxSaleGrossProfit from
(select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201801_SaleBill  a,
[000]A .tb201801_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'


union all 
select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201802_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201802_SaleBill  a,
[000]A .tb201802_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'

)a
group by NodeCode,GoodsCode
)F ON  b.DeptCode=F.NodeCode  and a.GoodsCode=F.GoodsCode

LEFT JOIN 
[000]A. TBSTOCKS I ON  b.DeptCode=I.CounterCode  and a.GoodsCode=I.GoodsCode
where   A.GoodsType LIKE '0' AND (A.GoodsCode like '3%' or A.GoodsCode like '4%' or A.GoodsCode like '5%')

 and b.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 )  AND 1=1 ${if(zt ==0,   "",   "and a.GoodsBrand ='010001' ") })A
GROUP BY CategoryCode1,CategoryCode,DeptCode

)A
LEFT JOIN 
(select DeptCode ,CategoryCode ,SUM(Salesindex )Salesindex,SUM(Grossprofitindex )Grossprofitindex from 
WHLessonBudget
where BudgetYM in ('201801','201802') 
group by DeptCode ,CategoryCode )B ON A.CategoryCode=B.CategoryCode AND A.DeptCode =B.DeptCode 
LEFT JOIN 
(select NodeCode ,left(GoodsCode,2)CategoryCode ,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201801_SaleBill  a,
[000]A .tb201801_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'
union all 
select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201802_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201802_SaleBill  a,
[000]A .tb201802_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'
)a

group by NodeCode ,left(GoodsCode,2)  )C on a.DeptCode=C.NodeCode and a.CategoryCode=C.CategoryCode



where  1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and a.CategoryCode in  ('" + replace(fl,",","','")+"')")}
GROUP BY a.DeptCode ,A.CategoryCode1,a.CategoryCode
order by 1,2,3

 select  InDeptCode DeptCode,left(a.GoodsCode,2)CategoryCode ,SUM(Amount-PerformAmount)Amount,SUM(PurchMoney-PerformMoney)PurchMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode


)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode,left(a.GoodsCode,2)
order by 1,2



SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )A
WHERE   1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")}
order by 1


select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

select convert(varchar(10),dateadd(dd,0,a.defday),120)defday ,a.deptcode,
a.SaleMoney xsys,b.SaleMoney,isnull(d.SaleMoney,0) tqSaleMoney,E.SaleMoney qhSaleMoney,
a.Grossprofitindex mlys,isnull(c.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(d.TaxSaleGrossProfit,0) tqTaxSaleGrossProfit,E.TaxSaleGrossProfit qhTaxSaleGrossProfit
from 
(select defday ,deptcode,SUM(Salesindex)SaleMoney ,SUM(Grossprofitindex)Grossprofitindex
from wh_day_tbBudgetTargetDefine
where defday between '20180101' and convert(varchar(8),GETDATE(),112)
and DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )
and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
group by defday,deptcode)a
left join 
(
select OccurDate ,NodeCode ,SUM(SaleMoney)SaleMoney ,SUM(SaleCount)SaleCount
from  [000]A .tb201801_CASHIERMSUM
where OccurDate between '20180101' and convert(varchar(8),dateadd(dd,-1,convert(varchar(8),GETDATE(),112)),112)
group by OccurDate,NodeCode
union all 
select BulidDate ,DeptCode ,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(SaleCount)SaleCount
from  [000]A .tb201801_SALEMOMENT
where BulidDate =convert(varchar(8),GETDATE(),112) and GoodsCatCode not like ''
group by BulidDate ,DeptCode
)b on a.DeptCode =b.NodeCode and a.defday =b.OccurDate 
left join 
(select OccurDate ,NodeCode ,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from  [000]A .tb201801_GoodsDayPSSM 
where OccurDate between '20180101' and convert(varchar(8),dateadd(dd,0,convert(varchar(8),GETDATE(),112)),112)
group by OccurDate,NodeCode
)c on a.DeptCode =c.NodeCode and a.defday =c.OccurDate 
left join 

(select convert(varchar(8),dateadd(dd,384,convert(varchar(8),OccurDate,112)),112)jnrq,* from 
(select OccurDate ,NodeCode ,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from  [000]A .tb201612_GoodsDayPSSM 
where OccurDate between '20161213' and '20170209'
group by OccurDate,NodeCode
union all 
select OccurDate ,NodeCode ,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from  [000]A .tb201701_GoodsDayPSSM 
where OccurDate between '20161213' and '20170209'
group by OccurDate,NodeCode
union all 
select OccurDate ,NodeCode ,SUM(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from  [000]A .tb201702_GoodsDayPSSM 
where OccurDate between '20161213' and '20170209'
group by OccurDate,NodeCode)a) d on a.defday=d.jnrq and a.DeptCode=d.NodeCode 
left join 
(
select OccurDate ,NodeCode ,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from  [000]A .tb201801_GoodsDayPSSM 
where OccurDate between '20180101' and convert(varchar(8),dateadd(dd,-1,convert(varchar(8),GETDATE(),112)),112) AND 
 goodscode in(select  goodscode  from [000]A .tbGoods where GoodsBrand ='010001') 
group by OccurDate,NodeCode

)E on a.DeptCode =E.NodeCode and a.defday =E.OccurDate 
order by 2,1

select DeptCode ,left(CategoryCode,1)CategoryCode1,CategoryCode ,SUM(Salesindex )Salesindex,SUM(Grossprofitindex )Grossprofitindex from 
WHLessonBudget
where BudgetYM in ('201801','201802') and 
1=1 ${if(len(bm) == 0,"","and deptcode in  ('" + replace(bm,",","','")+"')")}
group by DeptCode ,CategoryCode 


select A.CategoryCode1,A.CategoryCode,isnull(A.SupplierName,'未挂供应商')SupplierName,
SUM(isnull(A.SaleMoney,0))LJSaleMoney,SUM(isnull(A.TaxSaleGrossProfit,0))LJTaxSaleGrossProfit,
SUM(isnull(A.Amount,0))JHAmount,SUM(isnull(A.Money,0))JHMoney,
SUM(isnull(A.kcAmount,0))KCAmount,SUM(isnull(A.kcCost,0))KCMoney 
FROM 
(SELECT CategoryCode1,CategoryCode,SupplierName,
SUM(Amount)Amount ,SUM(Money)Money,SUM(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,
SUM(kcAmount)kcAmount,SUM(kcCost)kcCost  FROM 
(select left(a.GoodsCode,1)CategoryCode1,left(a.GoodsCode,2)CategoryCode,a.GoodsCode,b.DeptCode ,c.CirculationModeCode,d.SupplierCode+' '+g.SupplierName SupplierName
,ISNULL(kcAmount,0)Amount ,ISNULL(kcMoney,0)Money,ISNULL(F.SaleMoney,0)SaleMoney,ISNULL(F.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
ISNULL(I.Amount,0)kcAmount,ISNULL(I.taxCost,0)kcCost 
  from 
[000]A .tbGoods a
left join 
[000]A .tbDeptWorkState b on a.GoodsCode=b.GoodsCode 
left join 
[000]A .tbDeptCirculation c on b.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode
left join  
[000]A .tbDeptGoodsSupp d on b.DeptCode=d.DeptCode and a.GoodsCode=d.GoodsCode
left join 
[000]A .TBSUPPLIER g on d.SupplierCode =g.SupplierCode
LEFT JOIN 
YEARPOBILLDETAIL E ON  b.DeptCode=E.DeptCode and a.GoodsCode=E.GoodsCode
left join 
(select NodeCode,GoodsCode,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(TaxSaleGrossProfit) TaxSaleGrossProfit from
(select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201801_SaleBill  a,
[000]A .tb201801_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'
union all 

select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201802_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201802_SaleBill  a,
[000]A .tb201802_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'
)a
group by NodeCode,GoodsCode
)F ON  b.DeptCode=F.NodeCode  and a.GoodsCode=F.GoodsCode

LEFT JOIN 
[000]A. TBSTOCKS I ON  b.DeptCode=I.CounterCode  and a.GoodsCode=I.GoodsCode
where   A.GoodsType LIKE '0' AND (A.GoodsCode like '3%' or A.GoodsCode like '4%' or A.GoodsCode like '5%')

 and b.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 )  
and 1=1 ${if(len(bm) == 0,   "",   "and B.deptcode in ('" + replace(bm,",","','")+"')") }
AND 1=1 ${if(zt ==0,   "",   "and a.GoodsBrand ='010001' ") }

)A
GROUP BY CategoryCode1,CategoryCode,SupplierName

)A




where   1=1 ${if(len(fl) == 0,"","and a.CategoryCode in  ('" + replace(fl,",","','")+"')")}
GROUP BY  A.CategoryCode1,A.CategoryCode,isnull(A.SupplierName,'未挂供应商')
order by 1,2,3


 select  InDeptCode DeptCode ,left(a.GoodsCode,2)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode
)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode  ,left(a.GoodsCode,2)
order by 1,2



SELECT CategoryCode1,DeptCode,CirculationModeCode,
SUM(Amount)Amount ,SUM(Money)Money,SUM(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,
SUM(kcAmount)kcAmount,SUM(kcCost)kcCost  FROM 
(select left(a.GoodsCode,1)CategoryCode1,left(a.GoodsCode,2)CategoryCode,a.GoodsCode,b.DeptCode ,c.CirculationModeCode,d.SupplierCode+' '+g.SupplierName SupplierName
,ISNULL(kcAmount,0)Amount ,ISNULL(kcMoney,0)Money,ISNULL(F.SaleMoney,0)SaleMoney,ISNULL(F.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
ISNULL(I.Amount,0)kcAmount,ISNULL(I.taxCost,0)kcCost 
  from 
[000]A .tbGoods a
left join 
[000]A .tbDeptWorkState b on a.GoodsCode=b.GoodsCode 
left join 
[000]A .tbDeptCirculation c on b.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode
left join  
[000]A .tbDeptGoodsSupp d on b.DeptCode=d.DeptCode and a.GoodsCode=d.GoodsCode
left join 
[000]A .TBSUPPLIER g on d.SupplierCode =g.SupplierCode
LEFT JOIN 
YEARPOBILLDETAIL E ON  b.DeptCode=E.DeptCode and a.GoodsCode=E.GoodsCode
left join 
(select NodeCode,GoodsCode,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(TaxSaleGrossProfit) TaxSaleGrossProfit from
(select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201801_SaleBill  a,
[000]A .tb201801_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'
union all 

select NodeCode,GoodsCode,SaleIncome ,SaleTax ,TaxSaleGrossProfit 
 from  [000]A .tb201802_GoodsDayPSSM where  OccurDate between '20180101' and '${jsrq}'
union all 
select a.DeptCode ,b.GoodsCode ,SaleEarning,SaleTax,0 TaxSaleGrossProfit from 
[000]A .tb201802_SaleBill  a,
[000]A .tb201802_SALERENTDETAIL b 
where a.BillNumber =b.BillNumber  and a.DeptCode =b.DeptCode and  a.IsOutRule=0 and 
a.BuildDate between '20180101' and '${jsrq}'

)a
group by NodeCode,GoodsCode
)F ON  b.DeptCode=F.NodeCode  and a.GoodsCode=F.GoodsCode
left join

[000]A. TBSTOCKS I ON  b.DeptCode=I.CounterCode  and a.GoodsCode=I.GoodsCode
where   A.GoodsType LIKE '0' AND (A.GoodsCode like '3%' or A.GoodsCode like '4%' or A.GoodsCode like '5%')

 and b.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 )  
AND 1=1 ${if(zt ==0,   "",   "and a.GoodsBrand ='010001' ") }
)A
where  1=1 ${if(len(bm) == 0,   "",   "and a.DeptCode  in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and a.CategoryCode in  ('" + replace(fl,",","','")+"')")}
GROUP BY CategoryCode1,DeptCode,CirculationModeCode
order by 1,2,3

 select  InDeptCode DeptCode ,CirculationModeCode,left(a.GoodsCode,1)CategoryCode ,SUM(Amount-PerformAmount)Amount,SUM(PurchMoney-PerformMoney)PurchMoney from 
(select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode ,CirculationModeCode ,left(a.GoodsCode,1)
order by 1,2



 select  InDeptCode DeptCode ,CirculationModeCode,left(a.GoodsCode,1)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
union all 
select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode
)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode ,CirculationModeCode ,left(a.GoodsCode,1)
order by 1,2



 select  InDeptCode DeptCode ,b.SupplierCode+' '+c.SupplierName SupplierName,left(a.GoodsCode,2)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode
)a 
left join 
[6001]A .tbDeptGoodsSupp b on a.InDeptCode =b.DeptCode and a.GoodsCode =b.GoodsCode 
left join 
[6001]A .TBSUPPLIER c on b.SupplierCode =c.SupplierCode
where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode ,b.SupplierCode+' '+c.SupplierName ,left(a.GoodsCode,2)
order by 1,2



 select  InDeptCode DeptCode,left(a.GoodsCode,2)CategoryCode ,SUM(Amount-PerformAmount)Amount,SUM(PurchMoney-PerformMoney)PurchMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode,left(a.GoodsCode,2)
order by 1,2



 select  InDeptCode DeptCode ,left(a.GoodsCode,2)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode




)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode  ,left(a.GoodsCode,2)
order by 1,2



 select  InDeptCode DeptCode ,left(a.GoodsCode,2)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode  ,left(a.GoodsCode,2)
order by 1,2



 select  InDeptCode DeptCode ,CirculationModeCode,left(a.GoodsCode,1)CategoryCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'  and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月

union all 
select InDeptCode,GoodsCode,'1'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201802_PURORDERBILL zb ,
[6001]A .tb201802_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'3'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,'2'CirculationModeCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201802_DISTORDERBILL zb ,
[6001]A .tb201802_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '${jsrq}' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 and a.OpenDate<'20180101'
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%'
group by zb.InDeptCode,GoodsCode
)a 

where  1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and a.InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(a.GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode ,CirculationModeCode ,left(a.GoodsCode,1)
order by 1,2



