SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )A
WHERE   1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")}
order by 1


select a.deptcode,
a.GoodsCode,a.BaseBarCode,a.GoodsName,a.BaseMeasureUnit,
a.WholePackRate,a.Suppliername,a.WorkStateCode,a.CirculationModeCode,
a.PurchPrice,a.SalePrice,a.Remark,

(b.qn_SaleAmount)qn_SaleAmount,(b.qn_SaleMoney)qn_SaleMoney,
(a.jq_SaleAmount)jq_SaleAmount,(a.jq_SaleMoney)jq_SaleAmount,
(a.kcAmount),(a.kcMoney)kcMoney,
(a.StoreOrderAmount)StoreOrderAmount,(a.StoreOrderMoney)StoreOrderMoney,
(a.BuyerOrderAmount)BuyerOrderAmount,(a.BuyerOrderMoney)BuyerOrderMoney
from 
YEARPOBILLDETAIL a
left join 
YEARPOBILLDETAIL b on a.goodscode =b.goodscode 
and 1=1 ${if(len(ckbm) == 0,   "",   "and b.deptcode in ('" + replace(ckbm,",","','")+"')") }
where 
1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and a.goodscode like '" + fl+"%" + "'")}
and 1=1 ${if(pp == 0,"","and a.Remark like '" +"%" +pp+"%" + "'")}

order by 7,2 

select  CounterCode,left(GoodsCode,2)CategoryCode,goodscode,SUM(Amount)Amount,SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%'
 and 1=1 ${if(len(bm) == 0,   "",   "and CounterCode in ('" + replace(bm,",","','")+"')") }
group by CounterCode,left(GoodsCode,2),goodscode

select round(sum(Salesindex),2) Salesindex
 from WHLessonBudget a 
 where BudgetYM  between  convert(varchar(6),'201801',112) and  convert(varchar(6),'201802',112) and 1=1 ${if(len(bm) == 0,   "",   "and deptcode in ('" + replace(bm,",","','")+"')") }
 and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }



SELECT * FROM 
( 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 )A

order by 1


select CategoryCode,CategoryCode+' '+CategoryName CategoryName 
from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 3 and 5  
and CategoryLevel=2






SELECT 
a.DeptCode ,a.Suppliername,A.GoodsCode ,a.GoodsName ,packrate,a.WholePackRate,a.PurchPrice,a.SalePrice ,a.WorkStateCode,a.CirculationModeCode ,a.BaseMeasureUnit
,a.kcAmount ,a.kcMoney,left(A.GoodsCode,2)CategoryCode,
isnull(b.PerformAmount,0)  ActAmount,isnull(b.PerformMoney,0) ActMoney,
isnull(c.Amount,0) WayAmount,isnull(c.PurchMoney,0) WayPurchMoney,
(a.kcAmount-isnull(b.PerformAmount,0)-isnull(c.Amount,0))UnReachAmount,(a.kcMoney-ISNULL(b.PerformAmount,0)-ISNULL(c.PurchMoney,0))UnReachMoney,
cs.defday cs,
ceiling((a.kcAmount-isnull(b.PerformAmount,0)-isnull(c.Amount,0))/cs.defday  /packrate)*PackRate as  SugAmount
,
ceiling((a.kcAmount-isnull(b.PerformAmount,0)-isnull(c.Amount,0))/cs.defday /packrate)*PackRate*a.PurchPrice as  SugMoney
   FROM 
YEARPOBILLDETAIL A 
LEFT JOIN 
( select  InDeptCode DeptCode ,GoodsCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月
union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a
group by InDeptCode  ,GoodsCode

)B on a.DeptCode =b.DeptCode and a.GoodsCode =b.GoodsCode 

LEFT JOIN 
( select  InDeptCode DeptCode ,GoodsCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a
group by InDeptCode  ,GoodsCode

)c on a.DeptCode =c.DeptCode and a.GoodsCode =c.GoodsCode 
left join 
(select '1' CirculationModeCode,count(convert(varchar(10),dateadd(dd,number,getdate()),112))defday
from master..spt_values 
where type='p' and convert(varchar(10),dateadd(dd,number,getdate()),112) <= '20180206'  and 
datepart(weekday,convert(varchar(10),dateadd(dd,number,getdate()),112))-1 in (2) 
union all 
select '3' CirculationModeCode,count(convert(varchar(10),dateadd(dd,number,getdate()),112))defday
from master..spt_values 
where type='p' and convert(varchar(10),dateadd(dd,number,getdate()),112) <= '20180206'  and 
datepart(weekday,convert(varchar(10),dateadd(dd,number,getdate()),112))-1 in (2) 

union all 
select '2' CirculationModeCode,count(convert(varchar(10),dateadd(dd,number,getdate()),112))+1 defday
from master..spt_values 
where type='p' and convert(varchar(10),dateadd(dd,number,getdate()),112) <= '20180206'  and 
datepart(weekday,convert(varchar(10),dateadd(dd,number,getdate()),112))-1 in (1,4) )cs on a.CirculationModeCode =cs.CirculationModeCode

WHERE kcAmount >0 
and 

1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 
1=1 ${if(len(fl) == 0,"","and a.goodscode like '" + fl+"%" + "'")}
and 
1=1 ${if(pp == 0,"","and a.Remark like '" +"%" +pp+"%" + "'")}
and
1=1 ${if(len(zt) == 0,"","and  a.CirculationModeCode ='" + zt + "'")}  
ORDER BY 2,3





select a.DeptCode,a.CategoryCode1,a.CategoryCode,isnull(a.Salesindex,0)Salesindex,isnull(a.Grossprofitindex,0)Grossprofitindex,
isnull(b.SaleMoney,0)SaleMoney,ISNULL(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,isnull(Amount,0)Amount,isnull(TaxCost,0)TaxCost,
isnull(d.BuyerOrderAmount,0)BuyerOrderAmount,isnull(d.BuyerOrderMoney,0)BuyerOrderMoney from 
(select a.DeptCode,left(CategoryCode,1)CategoryCode1,CategoryCode,round(sum(Salesindex),2) Salesindex,round(SUM(a.Grossprofitindex),2)Grossprofitindex
 from WHLessonBudget a 
 where BudgetYM  between  convert(varchar(6),'201801',112) and  convert(varchar(6),'201802',112) 
 and CategoryCode not like '1%' and CategoryCode not like '2%' 
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
 group by a.DeptCode,a.CategoryCode )a
 left join 
 (select nodecode,left(goodscode,2)CategoryCode,sum(a.SaleIncome+a.SaleTax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select * from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and '20180228' 
union all 
select * from  [000]A .tb201702_GoodsDayPSSM where  OccurDate between '20180101' and '20180228')a
where a.NodeCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) 
group by nodecode ,left(goodscode,2))b on a.DeptCode=b.NodeCode  and a.CategoryCode=b.CategoryCode 
 left join 
 (select CounterCode,left(goodscode,2)CategoryCode,SUM(Amount)Amount,SUM(TaxCost)TaxCost
 from [000]A. TBSTOCKS where GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%'
 and CounterCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0) 
group by CounterCode,left(goodscode,2))c on a.CategoryCode=c.CategoryCode and a.DeptCode=c.CounterCode 
left join 
(select deptcode,left(goodscode,2)CategoryCode,sum(kcMoney)BuyerOrderMoney,sum(kcAmount)BuyerOrderAmount from 
YEARPOBILLDETAIL
where deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0  )
group by deptcode,left(goodscode,2)) d on a.DeptCode=d.deptcode and a.CategoryCode=d.CategoryCode
order by 1,2,3



SELECT 
a.DeptCode ,left(A.GoodsCode,2)CategoryCode
,sum(a.kcAmount)kcAmount ,sum(a.kcMoney)kcMoney,
sum(isnull(b.PerformAmount,0))  ActAmount,sum(isnull(b.PerformMoney,0)) ActMoney,
sum(isnull(c.Amount,0)) WayAmount,sum(isnull(c.PurchMoney,0)) WayPurchMoney
   FROM 
YEARPOBILLDETAIL A 
LEFT JOIN 
( select  InDeptCode DeptCode ,GoodsCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月
union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (2) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a
group by InDeptCode  ,GoodsCode

)B on a.DeptCode =b.DeptCode and a.GoodsCode =b.GoodsCode 

LEFT JOIN 
( select  InDeptCode DeptCode ,GoodsCode ,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by InDeptCode,GoodsCode

union all 
select zb.DirectDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=1
group by zb.DirectDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20180122' and '20180210' and DirectSign=0
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a
group by InDeptCode  ,GoodsCode

)c on a.DeptCode =c.DeptCode and a.GoodsCode =c.GoodsCode 


WHERE kcAmount >0 
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
group by a.DeptCode ,left(A.GoodsCode,2)
ORDER BY 1,2




