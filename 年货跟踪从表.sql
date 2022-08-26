select * from 
(select a.DeptCode ,a.GoodsCode,d.GoodsName  ,a.WorkStateCode ,c.CirculationModecode
,e.SupplierCode+' '+g.SupplierName  SupplierName,e.PurchPrice,
case when f.SalePrice<>'' then f.SalePrice else d.SalePrice end SalePrice,
SUM(isnull(b.kcAmount,0))JHAmount,SUM(ISNULL(b.kcMoney,0))JHMoney,
SUM(ISNULL(i.Amount,0))KCAmount,SUM(ISNULL(i.TaxCost,0))KCMoney,
SUM(ISNULL(J.SaleMoney,0))LJSaleMoney,SUM(ISNULL(J.TaxSaleGrossProfit,0))LJTaxSaleGrossProfit  from
[000]A .tbDeptWorkState  a
left join 
YEARPOBILLDETAIL b on a.DeptCode =b.DeptCode and a.GoodsCode =b.GoodsCode 
left join 
[000]A .tbDeptCirculation c on a.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode
left join 
[000]A .tbDeptGoodsSupp e on a.DeptCode =e.DeptCode and a.GoodsCode =e.GoodsCode 
left join 
[000]A .TBDEPTSALEPRICE f on a.DeptCode=f.DeptCode and a.GoodsCode=f.GoodsCode 
left join 
[000]A .TBSUPPLIER g on e.SupplierCode =g.SupplierCode
left join 
[000]A. TBSTOCKS i on a.DeptCode =i.CounterCode and a.GoodsCode =i.GoodsCode 
LEFT JOIN 
(select NodeCode,GoodsCode,SUM(SaleIncome+SaleTax)SaleMoney ,SUM(TaxSaleGrossProfit) TaxSaleGrossProfit
 from  [000]A .tb201801_GoodsDayPSSM where  OccurDate between '20180101' and convert(varchar(8),dateadd(dd,-1,convert(varchar(8),GETDATE(),112)),112)
 GROUP BY NodeCode ,GoodsCode 
 )J ON A.DeptCode=J.NodeCode AND A.GoodsCode=J.GoodsCode 
 
 ,[000]A .tbGoods d 

where 
a.GoodsCode =d.GoodsCode and 
d.GoodsType =0 and (a.GoodsCode like '3%' or a.GoodsCode like '4%' or a.GoodsCode like '5%') 
and a.DeptCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2  and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112) 
and a.State=0 and b.NodeType=0 ) 
and 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and a.goodscode like '" + fl+"%" + "'")}
and 1=1 ${if(len(gys) == 0,"","and  e.SupplierCode ='" + gys + "'")}  
and 1=1 ${if(zt ==0,   "",   "and a.goodscode in(select  goodscode  from [000]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(tj) == 0,"","and  c.CirculationModecode ='" + tj + "'")}  
GROUP BY a.DeptCode ,a.GoodsCode,d.GoodsName  ,a.WorkStateCode ,c.CirculationModecode
,e.SupplierCode+' '+g.SupplierName ,e.PurchPrice,
case when f.SalePrice<>'' then f.SalePrice else d.SalePrice end)a
WHERE JHAmount<>0 or LJSaleMoney<>0 
order by 6,5,2,1,4

 select  InDeptCode DeptCode ,goodscode,SUM(Amount-PerformAmount)Amount,SUM(PurchMoney-PerformMoney)PurchMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a 
where  
1=1 ${if(zt ==0,   "",   "and goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and left(GoodsCode,2) in  ('" + replace(fl,",","','")+"')")}
group by InDeptCode  ,goodscode
order by 1,2



select * from 
[6666]A.TBSTOCKS
where (goodscode like '3%' or goodscode like '4%' or goodscode like '5%')
and Amount>0

 select  InDeptCode DeptCode ,goodscode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
(select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201712_PURORDERBILL zb ,
[6001]A .tb201712_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201712_DISTORDERBILL zb ,
[6001]A .tb201712_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接1月2月

union all 
select InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney from 
[6001]A .tb201801_PURORDERBILL zb ,
[6001]A .tb201801_POBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=1
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

union all 
select zb.InDeptCode,GoodsCode,SUM(Amount)Amount,SUM(PurchMoney)PurchMoney,SUM(PerformAmount)PerformAmount,SUM(PerformMoney)PerformMoney  from 
[6001]A .tb201801_DISTORDERBILL zb ,
[6001]A .tb201801_DOBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.BuildDeptCode=cb.BuildDeptCode
and zb.BillCate=1 and zb.BillState in (1,2) and LEFT(SubmitTime,8) between '20171222' and '20180228' and DirectSign=0
and zb.InDeptCode in (select a.NodeCode   from 
[6001]A .TBDEPARTMENT a ,[6001]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 ) and GoodsCode not like '0%' and GoodsCode not like '6%' and GoodsCode not like '1%' and GoodsCode not like '2%' and GoodsCode not like '300%' 
group by zb.InDeptCode,GoodsCode

--往下UNION ALL 接2月
)a 
where  
1=1 ${if(zt ==0,   "",   "and goodscode in(select  goodscode  from [6001]A .tbGoods where GoodsBrand ='010001') ") }
and 1=1 ${if(len(bm) == 0,   "",   "and InDeptCode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,"","and a.goodscode like '" + fl+"%" + "'")}
group by InDeptCode  ,goodscode
order by 1,2



