
declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8),@bm1 varchar(8000),@fl1 varchar(8000)

set @dqrq=convert(varchar(8),dateadd(dd,-1,GETDATE()),112)
set @jsny= @dqrq
set @qsrq=convert(varchar(8),dateadd(dd,-day(dateadd(month,1,getdate()) - day(getdate())) ,@dqrq),112)
set @qsny=convert(varchar(8),dateadd(MM,-1,@dqrq),112)

set @sql1='



select a.DeptCode,a.goodscode,a.WorkStateCode,SUM(isnull(b.SaleAmount,0))SaleAmount,
sum(isnull(c.StartAmount,0)+isnull(c.PURCHAMOUNT,0) + isnull(c.REDEPLOYINAMOUNT,0) + isnull(c.PROFITAMOUNT,0) + isnull(c.COUNTPROFITAMOUNT ,0)- isnull(c.SALEAMOUNT,0) - isnull(c.REDEPLOYOUTAMOUNT,0) - isnull(c.LOSSAMOUNT ,0)- isnull(c.COUNTLOSSAMOUNT,0)-isnull(c.ToGiftAmount,0)+isnull(c.FreshLossAmount,0))Amount
into #sj
  from 
(

select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from
 [000]A .TBDEPTWORKSTATE a ,
[000]A.tbGoods b 

where  a.deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) and 
a.GoodsCode =b.GoodsCode and 
 left(a.DeptCode,1) between 1 and 2 and b.GoodsType =''0'' and a.WorkStateCode <>09
 and (a.GoodsCode  like ''3%'' or a.GoodsCode like ''4%'' or a.GoodsCode like ''5%'')

)a
 left join 
(select * from [000]A .tb'+@qsny+'_GoodsDayPSSM where OccurDate between '+@qsrq+'  and '+@dqrq+'
union all 
select * from [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between  '+@qsrq+'  and '+@dqrq+')b on a.DeptCode=b.NodeCode and a.GoodsCode =b.GoodsCode 
left join 
 "000" .tb'+@jsny+'_GoodsMonPSSM c on a.DeptCode =c.nodecode and a.goodscode=c.goodscode 

group by a.DeptCode,a.goodscode,a.WorkStateCode


select '+@dqrq+' BuildDate, a.NodeCode DeptCode,left(a.CategoryCode,1)CategoryCode1,left(a.CategoryCode,2)CategoryCode2,left(a.CategoryCode,3)CategoryCode3
,left(a.CategoryCode,4)CategoryCode4,a.CategoryCode CategoryCode5,a.WorkStateCode,isnull(b.sl,0) PinSKU,isnull(d.sl,0) NonPinSKU,isnull(c.sl,0) SKU  from 
(select distinct deptcode Nodecode,WorkStateCode,left(goodscode,5)CategoryCode from #sj  ) a
left join 
(select deptcode,left(goodscode,5)CategoryCode,WorkStateCode,count(goodscode)sl
from #sj where SaleAmount>0 group by deptcode,left(goodscode,5),WorkStateCode)b on a.nodecode=b.deptcode and  a.CategoryCode=b.CategoryCode and a.WorkStateCode=b.WorkStateCode
left join 
(select deptcode,left(goodscode,5)CategoryCode,WorkStateCode,count(goodscode)sl
from #sj where Amount>0 group by deptcode,left(goodscode,5),WorkStateCode)c on a.nodecode=c.deptcode and  a.CategoryCode=c.CategoryCode and a.WorkStateCode=c.WorkStateCode
left join 
(select deptcode,left(goodscode,5)CategoryCode,WorkStateCode,count(goodscode)sl
from #sj where Amount>0 and SaleAmount<=0 group by deptcode,left(goodscode,5),WorkStateCode)d on a.nodecode=d.deptcode and  a.CategoryCode=d.CategoryCode and a.WorkStateCode=d.WorkStateCode

order by 1,2,3,4,5,6
'exec (@sql1)


