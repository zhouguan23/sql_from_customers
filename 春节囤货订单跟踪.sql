SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))A
WHERE   1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")}
order by 1


select row_number() over (order by a.GoodsCode) as xh ,
a.DeptCode,a.GoodsCode,a.BaseBarCode,a.GoodsName,a.BaseMeasureUnit,
a.WholePackRate,a.Suppliername,a.WorkStateCode,a.CirculationModeCode,
a.PurchPrice,a.SalePrice,b.qn_SaleAmount,b.qn_SaleMoney,a.jq_SaleAmount,
a.jq_SaleMoney,a.kcAmount,a.kcMoney,a.StoreOrderAmount,a.StoreOrderMoney,
a.BuyerOrderAmount,a.BuyerOrderMoney,a.Remark
,isnull(f.Amount,0)Amount,isnull(TaxCost,0)tAXStockCost from 
YEARPOBILLDETAIL a
left join 
[000]A. TBSTOCKS f on a.DeptCode =f.CounterCode and a.goodscode=f.goodscode
left join 
YEARPOBILLDETAIL b on a.goodscode =b.goodscode and 
1=1 ${if(len(ckbm) == 0,   "",   "and b.deptcode in ('" + replace(ckbm,",","','")+"')") }
where 
1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 
1=1 ${if(len(fl) == 0,"","and a.goodscode like '" + fl+"%" + "'")}
and 
1=1 ${if(pp == 0,"","and a.Remark ='" + pp + "'")}
order by 2,1,8

select BudgetYM,DeptCode,left(CategoryCode,1)CategoryCode1,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex
 from WHLessonBudget a 
 where BudgetYM  between  convert(varchar(6),'201801',112) and  convert(varchar(6),'201802',112) and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
 group by BudgetYM,deptcode,CategoryCode


select nodecode ,left(a.goodscode,2)fl ,sum(SaleIncome+SaleTax )SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit,SUM(b.Amount)Amount,SUM(TaxCost)TaxCost from 
(select * from  [000]A .tb201701_GoodsDayPSSM where  OccurDate between '20170101' and '20170228' 
union all 
select * from  [000]A .tb201702_GoodsDayPSSM where  OccurDate between '20170101' and '20170228'  
)a 
left join 
[000]A. TBSTOCKS b on a.nodecode=b.CounterCode and a.GoodsCode =b.GoodsCode 
where a.nodecode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and (a.goodscode like '3%' or a.goodscode like '4%' or a.goodscode like '5%')
group by nodecode,left(a.goodscode,2)
order by 2,1,3




select convert(varchar(10),dateadd(dd,0,a.OccurDate),120)OccurDate,
d.SaleMoney ys_SaleMoney,c.SaleMoney SaleMoney,b.SaleMoney qn_SaleMoney,

e.SaleCount SaleCount,b.SaleCount qn_SaleCount from 

(select row_number() over (order by convert(varchar(10),dateadd(dd,number,convert(varchar(8),'20180101',112)),112)) as xh,
convert(varchar(10),dateadd(dd,number,convert(varchar(8),'20180101',112)),112)OccurDate
from master..spt_values 
where type='p' and number <= datediff(dd,convert(varchar(8),'20180101',112),convert(varchar(8),'20180228',112)))a
left join 


(select row_number() over (order by OccurDate) as xh,OccurDate  ,sum(SaleMoney )/10000SaleMoney,SUM(SaleCount)SaleCount from 
(select * from  [000]A .tb201612_CASHIERMSUM where OccurDate between '20161213' and '20170210' 
union all 
select * from  [000]A .tb201701_CASHIERMSUM where  OccurDate between '20161213' and '20170210' 
union all 
select * from  [000]A .tb201702_CASHIERMSUM where  OccurDate between '20161213' and '20170210' 
)a 
where a.nodecode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
and 1=1 ${if(len(bm) == 0,   "","and nodecode in ('" + replace(bm,",","','")+"')") }
group by OccurDate)b on a.xh=b.xh
left join 
(select row_number() over (order by BulidDate) as xh,BulidDate OccurDate  ,sum(SaleIncome+SaleTax )/10000SaleMoney,SUM(SaleCount)SaleCount from 
(select * from  [000]A .tb201709_SALEMOMENT where BulidDate between '20170901' and '20171028' and GoodsCatCode<>''
union all 
select * from  [000]A .tb201710_SALEMOMENT where BulidDate between '20170901' and '20171028' and GoodsCatCode<>''
)a 
where a.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
and 1=1 ${if(len(bm) == 0,   "","and deptcode in ('" + replace(bm,",","','")+"')") }
group by BulidDate)c on a.xh=c.xh

left join 
(select row_number() over (order by BulidDate) as xh,BulidDate OccurDate  ,sum(SaleIncome+SaleTax )/10000SaleMoney,SUM(SaleCount)SaleCount from 
(select * from  [000]A .tb201709_SALEMOMENT where BulidDate between '20170901' and '20171028' and GoodsCatCode=''
union all 
select * from  [000]A .tb201710_SALEMOMENT where BulidDate between '20170901' and '20171028' and GoodsCatCode=''
)a 
where a.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
and 1=1 ${if(len(bm) == 0,   "","and deptcode in ('" + replace(bm,",","','")+"')") }
group by BulidDate)e on a.xh=e.xh
left join 
(select row_number() over (order by defday)xh ,defday ,ROUND(SUM(Salesindex)/10000,2)SaleMoney 
from wh_day_tbBudgetTargetDefine
where defday between '20170901' and '20171028' and 
deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and 1=1 ${if(len(bm) == 0,   "","and deptcode in ('" + replace(bm,",","','")+"')") }
group by defday)d on a.xh=d.xh



select SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%'
 and CounterCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) 
and 1=1 ${if(len(bm) == 0,   "",   "and CounterCode in ('" + replace(bm,",","','")+"')") }


select a.GoodsCatCode  ,b.Categoryname,sum(SaleIncome+SaleTax )/10000 SaleMoney from 
(select * from  [000]A .tb201701_SALEMOMENT  where GoodsCatCode<>'' and  BulidDate between '20170101' and '20170228' 
union all 
select * from  [000]A .tb201702_SALEMOMENT where  GoodsCatCode<>'' and  BulidDate between '20170101' and '20170228' 
 )a 
left join 
[000]A.TBGOODSCATEGORY  b on a.GoodsCatCode=b.CategoryCode
where a.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and a.GoodsCatCode not like '0%' and a.GoodsCatCode not like '6%'

group by a.GoodsCatCode,b.Categoryname
order by 1

select round(sum(Salesindex),2) Salesindex
 from WHLessonBudget a 
 where BudgetYM  between  convert(varchar(6),'201801',112) and  convert(varchar(6),'201802',112) and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
 and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }



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


select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2

SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))A

order by 1


