

select BudgetYM,DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex
 from 含税分课预算表 a 
 
 where BudgetYM  = left('${jsrq}',6)
 group by BudgetYM,deptcode,CategoryCode

declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),'${jsrq}',112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),'${qsrq}',112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,SFXD,a.Categorycode,a.jyyt,isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0)SaleMoney,isnull(d.TaxSaleGrossProfit,0)+isnull(c.PaymentMoney,0) TaxSaleGrossProfit
,isnull(b.SaleCount,0)SaleCount,case when isnull(b.SaleCount,0)=0 or (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))=0 then 0 else (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))/isnull(b.SaleCount,0) end kl from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,C.Categorycode,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode,b.CategoryCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount   from 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@qsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'' ) 
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@jsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'') 
group by NodeCode)a
group by NodeCode

)b on a.NodeCode =b.NodeCode 
left join 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney from 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@qsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode
union all 
select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@jsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode)a
group by NodeCode
)c on a.NodeCode=c.NodeCode
left join 
(select NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE  NOT LIKE ''0%'' AND GOODSCODE  NOT LIKE ''6%''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE
union all 
select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE  NOT LIKE ''0%'' AND GOODSCODE  NOT LIKE ''6%''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE)a
group by nodecode

)d on a.NodeCode=d.NodeCode



order by 3,2,1

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),'${tqjsrq}',112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),'${tqqsrq}',112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,SFXD,a.jyyt,isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0)SaleMoney,isnull(d.TaxSaleGrossProfit,0)+isnull(c.PaymentMoney,0) TaxSaleGrossProfit
,isnull(b.SaleCount,0)SaleCount,isnull(b.SaleCount,0)SaleCount,case when isnull(b.SaleCount,0)=0 or (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))=0 then 0 else (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))/isnull(b.SaleCount,0) end kl from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount   from 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@qsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'') 
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@jsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'') 
group by NodeCode)a
group by NodeCode

)b on a.NodeCode =b.NodeCode 
left join 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney from 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@qsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode
union all 
select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@jsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode)a
group by NodeCode
)c on a.NodeCode=c.NodeCode
left join 

(select NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  LEFT(GOODSCODE,1) between ''1'' and ''5''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE
union all 
select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  LEFT(GOODSCODE,1) between ''1'' and ''5''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE)a
group by nodecode

)d on a.NodeCode=d.NodeCode
order by 4,2,1


'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),'${Hqjsrq}',112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),'${Hqqsrq}',112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,SFXD,a.jyyt,isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0)SaleMoney,isnull(d.TaxSaleGrossProfit,0)+isnull(c.PaymentMoney,0) TaxSaleGrossProfit
,isnull(b.SaleCount,0)SaleCount,isnull(b.SaleCount,0)SaleCount,case when isnull(b.SaleCount,0)=0 or (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))=0 then 0 else (isnull(b.SaleMoney,0)+isnull(c.PaymentMoney,0))/isnull(b.SaleCount,0) end kl from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount   from 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@qsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'') 
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@jsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  (NodeCode like ''1%'' or  NodeCode like ''2%'') 
group by NodeCode)a
group by NodeCode

)b on a.NodeCode =b.NodeCode 
left join 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney from 
(select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@qsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode
union all 
select NodeCode ,SUM(PaymentMoney) PaymentMoney
from [000]A .tb'+@jsny+'_CASHIERDSUM
where occurdate between '+@qsrq+' and '+@dqrq+' and  PaymentModeCode=''0013'' and LEFT(NodeCode ,1) between 1 and 2 
group by NodeCode)a
group by NodeCode
)c on a.NodeCode=c.NodeCode
left join 

(select NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  LEFT(GOODSCODE,1) between ''1'' and ''5''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE
union all 
select  NodeCode,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  LEFT(GOODSCODE,1) between ''1'' and ''5''  and LEFT( NODECODE,1) between 1 and 2
group by NODECODE)a
group by nodecode

)d on a.NodeCode=d.NodeCode
order by 4,2,1


'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,
case when convert(varchar(8),dateadd(YY,1,b.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end fl,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
union all 
select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+' and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)

)a
left join 
[000]A.TBDEPARTMENT b on a.nodecode=b.nodecode  
group by a.nodecode,b.OpenDate,case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end 

order by 3,2,1

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${tqjsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,
case when convert(varchar(8),dateadd(YY,1,b.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end fl,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
union all 
select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+' and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)

)a
left join 
[000]A.TBDEPARTMENT b on a.nodecode=b.nodecode  
group by a.nodecode,b.OpenDate,case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end 

order by 3,2,1

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${tqjsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
select a.NodeCode,
case when convert(varchar(8),dateadd(YY,1,b.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end fl,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
union all 
select  NodeCode,left(goodscode,3)fl,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+' and  NodeCode like ''9%''   and (goodscode like ''3%'' or goodscode like ''6%'') 
group by NODECODE,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)
 union all 
select zb.DeptCode,left(goodscode,3)fl,sum(SaleEarning+SaleTax)SaleMoney,0 TaxSaleGrossProfit
 from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (3,6) 
 and EnterAccountDate between '+@qsrq+' and '+@dqrq+' and  zb.deptcode like ''9%''
 group by zb.DeptCode,left(goodscode,3)

)a
left join 
[000]A.TBDEPARTMENT b on a.nodecode=b.nodecode  
group by a.nodecode,b.OpenDate,case when fl=612 then 610 when fl between 614 and 619  then 613
when fl =300  then 613 when fl between 622 and 639  then 622
when fl =643  then 641 when fl =644   then 642 
  else fl end 

order by 3,2,1

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),@tqdqrq varchar(8),@hqdqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8),
@tqjsny varchar(6), @tqqsny varchar(6), @tqqsrq varchar(8),
@hqjsny varchar(6), @hqqsny varchar(6), @hqqsrq varchar(8)

set @dqrq= convert(varchar(8),'${jsrq}',112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),'${qsrq}',112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @tqdqrq= convert(varchar(8),'${tqjsrq}',112)
set @tqjsny= @tqdqrq
set @tqqsrq= convert(varchar(8),'${tqqsrq}',112)
set @tqqsny= convert(varchar(6),dateadd(mm,-1,@tqdqrq),112) 

set @hqdqrq= convert(varchar(8),'${hqjsrq}',112)
set @hqjsny= @hqdqrq
set @hqqsrq= convert(varchar(8),'${hqqsrq}',112)
set @hqqsny= convert(varchar(6),dateadd(mm,-1,@hqdqrq),112) 

set @sql1='

select a.NodeCode,
case when convert(varchar(8),dateadd(YY,1,d.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,
SUM(a.SaleCount)SaleCount,sum(a.SaleMoney)/SUM(a.SaleCount)kl,
SUM(b.SaleCount)tqSaleCount,sum(b.SaleMoney)/SUM(b.SaleCount)tqkl,
SUM(c.SaleCount)hqSaleCount,sum(c.SaleMoney)/SUM(c.SaleCount)hqkl   from 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@qsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  NodeCode like ''9%''
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@jsny+'_CASHIERMSUM 
where occurdate between '+@qsrq+' and '+@dqrq+' and  NodeCode like ''9%''
group by NodeCode)a
left join 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@tqqsny+'_CASHIERMSUM 
where occurdate between '+@tqqsrq+' and '+@tqdqrq+' and  NodeCode like ''9%''
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@tqjsny+'_CASHIERMSUM 
where occurdate between '+@tqqsrq+' and '+@tqdqrq+' and  NodeCode like ''9%''
group by NodeCode)b on a.nodecode=b.nodecode
left join 
(select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@hqqsny+'_CASHIERMSUM 
where occurdate between '+@hqqsrq+' and '+@hqdqrq+' and  NodeCode like ''9%''
group by NodeCode
union all 
select NodeCode,sum(SaleMoney)SaleMoney,SUM(SaleCount)SaleCount  
from [000]A .tb'+@hqjsny+'_CASHIERMSUM 
where occurdate between '+@hqqsrq+' and '+@hqdqrq+' and  NodeCode like ''9%''
group by NodeCode)c on a.nodecode=c.nodecode
left join 
[000]A.TBDEPARTMENT d on a.nodecode=d.nodecode  

group by a.NodeCode,case when convert(varchar(8),dateadd(YY,1,d.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END 

order by 2,1

'exec (@sql1)





select * from
(select a.NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'H4' ,''),'修文店' ,'修文二店'),'修文一店' ,'修文二店'),'遵义' ,''),'亿足鞋业' ,''),'百货' ,''),'修文一店' ,'修文二店'),'修文店' ,'修文一店')  nodename 
,case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '新店' ELSE '老店' END SFXD
   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) = 9
and a.State=0 and b.NodeType=0)a
,
(select  CategoryCode ,case when CategoryName ='服装' then '服装、小商品'  else CategoryName end CategoryName
from [000]A .TBGOODSCATEGORY where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) = 6  and CategoryCode<>63  )b

declare @sql1 varchar(8000),@dqrq varchar(8),@sql2 varchar(8000),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)


set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 


set @sql1='

select a.NodeCode,SFXD,a.Categorycode,a.jyyt,b.fl1,b.fl2,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0) TaxSaleGrossProfit from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,C.Categorycode,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode,b.CategoryCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(select NodeCode,fl1,fl2,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select nodecode,fl1,fl2,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''  and  (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end
union all 
select   NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''   and (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end)a
group by nodecode,fl1,fl2

union all 
select  DeptCode nodecode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end  fl,SUM(SaleEarning +SaleTax)as SaleMoney,0 TaxSaleGrossProfit
from 
(select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
Union All
select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+'  )a
group by DeptCode,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end )a
group by nodecode ,fl1,fl2
)b on a.NodeCode=b.NodeCode

order by 3,2,1,5,6
'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),@sql2 varchar(8000),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)


set @dqrq= convert(varchar(8),dateadd(dd,0,'${tqjsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${tqqsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 


set @sql1='

select a.NodeCode,SFXD,a.Categorycode,a.jyyt,b.fl1,b.fl2,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0) TaxSaleGrossProfit from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,C.Categorycode,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode,b.CategoryCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(select NodeCode,fl1,fl2,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select nodecode,fl1,fl2,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''  and  (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end
union all 
select   NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''   and (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end)a
group by nodecode,fl1,fl2

union all 
select  DeptCode nodecode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end  fl,SUM(SaleEarning +SaleTax)as SaleMoney,0 TaxSaleGrossProfit
from 
(select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
Union All
select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+'  )a
group by DeptCode,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end )a
group by nodecode ,fl1,fl2
)b on a.NodeCode=b.NodeCode

order by 3,2,1,5,6
'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),@sql2 varchar(8000),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)


set @dqrq= convert(varchar(8),dateadd(dd,0,'${hqjsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${hqqsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 


set @sql1='

select a.NodeCode,SFXD,a.Categorycode,a.jyyt,b.fl1,b.fl2,isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0) TaxSaleGrossProfit from 
(select a.NodeCode,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then ''新店'' ELSE ''老店'' END SFXD,C.Categorycode,
C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(dd,1,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode,b.CategoryCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
left join 
(select NodeCode,fl1,fl2,sum(SaleMoney)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select nodecode,fl1,fl2,sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
(select  NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@qsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''  and  (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end
union all 
select   NodeCode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl2,sum(SaleIncome+SaleTax)SaleMoney,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
[000]A .tb'+@jsny+'_GOODSDAYPSSM
where OCCURDATE between '+@qsrq+' and '+@dqrq+'  and  GOODSCODE not  LIKE ''0%'' and GOODSCODE not  LIKE ''6%''   and (NODECODE LIKE ''1%'' or   NODECODE LIKE ''2%'')
group by NODECODE,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end)a
group by nodecode,fl1,fl2

union all 
select  DeptCode nodecode,left(goodscode,1)fl1,case when left(goodscode,2)=29then 20 else left(goodscode,2) end  fl,SUM(SaleEarning +SaleTax)as SaleMoney,0 TaxSaleGrossProfit
from 
(select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
Union All
select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5) and EnterAccountDate between '+@qsrq+' and '+@dqrq+'  )a
group by DeptCode,left(goodscode,1),case when left(goodscode,2)=29then 20 else left(goodscode,2) end )a
group by nodecode ,fl1,fl2
)b on a.NodeCode=b.NodeCode

order by 3,2,1,5,6
'exec (@sql1)





