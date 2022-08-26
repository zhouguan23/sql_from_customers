select * from  WHProcurcategory

SELECT * FROM 
( select '' NodeCode,'' nodename
union all 
select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))A
WHERE   1=1 ${if(len(CONCATENATE(GETUSERDEPARTMENTS())) == 0,"","and a.nodecode in (" + CONCATENATE(GETUSERDEPARTMENTS()) + ")")}
order by 1






declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8),@bm1 varchar(8000),@fl1 varchar(8000)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${rq}'),112)
set @jsny= @dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=convert(varchar(8),dateadd(MM,-1,@dqrq),112)

set @sql1='



select a.DeptCode,a.goodscode,a.WorkStateCode,isnull(b.SaleAmount,0)SaleAmount,
isnull(c.StartAmount,0)+isnull(Amount,0)Amount
into #sj
  from 
(

select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from 
 [000]A .TBDEPTWORKSTATE a 
,[000]A .tbGoods b 
 where  a.GoodsCode =b.GoodsCode  and   GoodsType =0  and a.WorkStateCode <>09 
and deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and (a.goodscode like ''3%'' or a.goodscode like ''14%'' or  a.goodscode like ''4%''  or  a.goodscode like ''5%'') and a.goodscode not like ''300%''

)a
 left join 
(select nodecode,goodscode ,sum(SaleAmount)SaleAmount from 
(select * from  [000]A .tb'+@qsny+'_GoodsDayPSSM where OccurDate between '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)
union all 
 select * from  [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between  '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0))a
 group by nodecode,goodscode)b on a.DeptCode=b.NodeCode and a.GoodsCode =b.GoodsCode 
left join 
(select *  from  [000]A .tb'+@jsny+'_GoodsMonPSSM 
where GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)) c on a.DeptCode =c.nodecode and a.goodscode=c.goodscode 
left join 
(select nodecode,goodscode,sum(isnull(PURCHAMOUNT,0) + isnull(REDEPLOYINAMOUNT,0) + isnull(PROFITAMOUNT,0) + isnull(COUNTPROFITAMOUNT ,0)- isnull(SALEAMOUNT,0) - isnull(REDEPLOYOUTAMOUNT,0) - isnull(LOSSAMOUNT ,0)- isnull(COUNTLOSSAMOUNT,0)-isnull(ToGiftAmount,0)+isnull(FreshLossAmount,0))Amount
 from   [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between '+@jsny+'+''01'' and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsType =0) 
  group by  nodecode ,goodscode)d on a.deptcode=d.nodecode and a.goodscode=d.goodscode  
  
  
  

select  a.DeptCode,left(a.CategoryCode,1)fl1,left(a.CategoryCode,2)fl,a.CategoryItemCode,a.CategoryCode,count(b.goodscode) PinSKU,count(c.goodscode) SKU  from 

(select  a.DeptCode ,a.GoodsCode,b.CategoryCode,b.CategoryItemCode,b.CategoryItemName   from 
(select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from 
 [000]A .TBDEPTWORKSTATE a 
,[000]A .tbGoods b 
 where  a.GoodsCode =b.GoodsCode  and   GoodsType =0  and a.WorkStateCode <>09 
  and (a.GoodsCode  like ''3%''or a.GoodsCode like ''4%''or a.GoodsCode like ''5%'')
and deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
)a
 left join 
 WHProcurcategory b on a.GoodsCode like b.CategoryCode+''%'') a
left join 
(select deptcode,goodscode from #sj where SaleAmount>0 )b on a.DeptCode=b.deptcode and a.goodscode=b.goodscode
left join 
(select deptcode,goodscode from #sj where WorkStateCode in (1,2,5)
union all 
select deptcode,goodscode from #sj where WorkStateCode in (3,4,50) and Amount>0 )c on a.DeptCode=c.deptcode and a.goodscode=c.goodscode

group by a.DeptCode,left(a.CategoryCode,1),left(a.CategoryCode,2),a.CategoryItemCode,a.CategoryCode
order by 1,2,3,4

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8),@bm1 varchar(8000),@fl1 varchar(8000)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${rq}'),112)
set @jsny= @dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=convert(varchar(8),dateadd(MM,-1,@dqrq),112)

set @sql1='


select a.DeptCode,a.goodscode,a.WorkStateCode,isnull(b.SaleAmount,0)SaleAmount,
isnull(c.StartAmount,0)+isnull(Amount,0)Amount
into #sj
  from 
(

select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from 
 [000]A .TBDEPTWORKSTATE a 
,[000]A .tbGoods b 
 where  a.GoodsCode =b.GoodsCode  and   GoodsType =0  and a.WorkStateCode <>09 
and deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and (a.goodscode like ''3%''  or  a.goodscode like ''4%''  or  a.goodscode like ''5%'') and a.goodscode not like ''300%''

)a
 left join 
(select nodecode,goodscode ,sum(SaleAmount)SaleAmount from 
(select * from  [000]A .tb'+@qsny+'_GoodsDayPSSM where OccurDate between '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)
union all 
 select * from  [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between  '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0))a
 group by nodecode,goodscode)b on a.DeptCode=b.NodeCode and a.GoodsCode =b.GoodsCode 
left join 
(select *  from  [000]A .tb'+@jsny+'_GoodsMonPSSM 
where GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)) c on a.DeptCode =c.nodecode and a.goodscode=c.goodscode 
left join 
(select nodecode,goodscode,sum(isnull(PURCHAMOUNT,0) + isnull(REDEPLOYINAMOUNT,0) + isnull(PROFITAMOUNT,0) + isnull(COUNTPROFITAMOUNT ,0)- isnull(SALEAMOUNT,0) - isnull(REDEPLOYOUTAMOUNT,0) - isnull(LOSSAMOUNT ,0)- isnull(COUNTLOSSAMOUNT,0)-isnull(ToGiftAmount,0)+isnull(FreshLossAmount,0))Amount
 from   [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between '+@jsny+'+''01'' and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsType =0) 
  group by  nodecode ,goodscode)d on a.deptcode=d.nodecode and a.goodscode=d.goodscode  
  

select  a.NodeCode DeptCode,left(a.CategoryCode,1)CategoryCode1,left(a.CategoryCode,2)CategoryCode2,isnull(b.sl,0) PinSKU,isnull(c.sl,0) SKU  from 
(select distinct deptcode Nodecode,left(goodscode,2)CategoryCode from #sj  ) a
left join 
(select deptcode,left(goodscode,2)CategoryCode,count(goodscode)sl
from #sj where SaleAmount>0 group by deptcode,left(goodscode,2))b on a.nodecode=b.deptcode and  a.CategoryCode=b.CategoryCode 
left join 
(select deptcode,CategoryCode,sum(sl)sl from 
(select deptcode,left(goodscode,2)CategoryCode,count(goodscode)sl
from #sj where WorkStateCode in (1,2,5) group by deptcode,left(goodscode,2)
union all 
select deptcode,left(goodscode,2)CategoryCode,count(goodscode)sl
from #sj where WorkStateCode in (3,4,50) and Amount>0 group by deptcode,left(goodscode,2))a
group by deptcode,CategoryCode)c on a.nodecode=c.deptcode and  a.CategoryCode=c.CategoryCode 

order by 1,2,3

'exec (@sql1)







declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8),@bm1 varchar(8000),@fl1 varchar(8000)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${rq}'),112)
set @jsny= @dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=convert(varchar(8),dateadd(MM,-1,@dqrq),112)

set @sql1='


select a.DeptCode,a.goodscode,a.WorkStateCode,isnull(b.SaleAmount,0)SaleAmount,
isnull(c.StartAmount,0)+isnull(Amount,0)Amount
into #sj
  from 
(

select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from 
 [000]A .TBDEPTWORKSTATE a 
,[000]A .tbGoods b 
 where  a.GoodsCode =b.GoodsCode  and   GoodsType =0  and a.WorkStateCode <>09 
and deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))
and (a.goodscode like ''3%'' or a.goodscode like ''14%'' or  a.goodscode like ''4%''  or  a.goodscode like ''5%'') and a.goodscode not like ''300%''

)a
 left join 
(select nodecode,goodscode ,sum(SaleAmount)SaleAmount from 
(select * from  [000]A .tb'+@qsny+'_GoodsDayPSSM where OccurDate between '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)
union all 
 select * from  [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between  '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0))a
 group by nodecode,goodscode)b on a.DeptCode=b.NodeCode and a.GoodsCode =b.GoodsCode 
left join 
(select *  from  [000]A .tb'+@jsny+'_GoodsMonPSSM 
where GoodsCode in (select GoodsCode from [000]A .tbGoods where  GoodsType =0)) c on a.DeptCode =c.nodecode and a.goodscode=c.goodscode 
left join 
(select nodecode,goodscode,sum(isnull(PURCHAMOUNT,0) + isnull(REDEPLOYINAMOUNT,0) + isnull(PROFITAMOUNT,0) + isnull(COUNTPROFITAMOUNT ,0)- isnull(SALEAMOUNT,0) - isnull(REDEPLOYOUTAMOUNT,0) - isnull(LOSSAMOUNT ,0)- isnull(COUNTLOSSAMOUNT,0)-isnull(ToGiftAmount,0)+isnull(FreshLossAmount,0))Amount
 from   [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between '+@jsny+'+''01'' and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsType =0) 
  group by  nodecode ,goodscode)d on a.deptcode=d.nodecode and a.goodscode=d.goodscode  
  


select a.CategoryName, a.NodeCode DeptCode,isnull(b.sl,0) PinSKU,isnull(c.sl,0) SKU  from 
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=0013
where  a.DeptCatItemCode =0013 AND a.NodeCode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112)) ) a
left join 
(select deptcode,count(goodscode)sl from #sj where SaleAmount>0 group by deptcode)b on a.nodecode=b.deptcode
left join 
(select deptcode,sum(sl)sl from 
(select deptcode,count(goodscode)sl from #sj where WorkStateCode in (1,2,5)  group by deptcode
union all 
select deptcode,count(goodscode)sl from #sj where WorkStateCode in (3,4,50) and Amount>0  group by deptcode)a
group by deptcode )c on a.nodecode=c.deptcode 

order by 1,2,3

'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6),@jsrq varchar(8), @qsrq varchar(8),@bm1 varchar(8000),@fl1 varchar(8000)

set @dqrq=convert(varchar(8),dateadd(dd,0,'${rq}'),112)
set @jsny= @dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=convert(varchar(8),dateadd(MM,-1,@dqrq),112)

set @sql1='


select a.DeptCode,a.goodscode,a.WorkStateCode,isnull(b.SaleAmount,0)SaleAmount,
isnull(c.StartAmount,0)+isnull(Amount,0)Amount
into #sj
  from 
(

select a.DeptCode ,a.WorkStateCode ,a.GoodsCode  from 
 [000]A .TBDEPTWORKSTATE a 
,[000]A .tbGoods b 
 where  a.GoodsCode =b.GoodsCode  and   GoodsType =0  and a.WorkStateCode <>09 and b.GoodsBrand =010001 and a.goodscode not like ''300%''
and deptcode in (select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))


)a
 left join 
(select nodecode,goodscode ,sum(SaleAmount)SaleAmount from 
(select * from  [000]A .tb'+@qsny+'_GoodsDayPSSM where OccurDate between '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsBrand =010001 and GoodsType =0)
union all 
 select * from  [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between  '+@qsrq+'  and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsBrand =010001 and GoodsType =0))a
 group by nodecode,goodscode)b on a.DeptCode=b.NodeCode and a.GoodsCode =b.GoodsCode 
left join 
(select *  from  [000]A .tb'+@jsny+'_GoodsMonPSSM 
where GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsBrand =010001 and GoodsType =0)) c on a.DeptCode =c.nodecode and a.goodscode=c.goodscode 
left join 
(select nodecode,goodscode,sum(isnull(PURCHAMOUNT,0) + isnull(REDEPLOYINAMOUNT,0) + isnull(PROFITAMOUNT,0) + isnull(COUNTPROFITAMOUNT ,0)- isnull(SALEAMOUNT,0) - isnull(REDEPLOYOUTAMOUNT,0) - isnull(LOSSAMOUNT ,0)- isnull(COUNTLOSSAMOUNT,0)-isnull(ToGiftAmount,0)+isnull(FreshLossAmount,0))Amount
 from   [000]A .tb'+@jsny+'_GoodsDayPSSM where OccurDate between '+@jsny+'+''01'' and '+@dqrq+' and GoodsCode in (select GoodsCode from [000]A .tbGoods where GoodsBrand =010001 and GoodsType =0) 
  group by  nodecode ,goodscode)d on a.deptcode=d.nodecode and a.goodscode=d.goodscode  

select  a.NodeCode DeptCode,CategoryCode,isnull(b.sl,0) PinSKU,isnull(c.sl,0) SKU  from 
(
select a.NodeCode,b.CategoryCode from 
(select a.NodeCode   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))a 
,
(select * from [000]A.TBGOODSCATEGORY c  where   C.CategoryItemCode=0000 and C.CategoryLevel=2 
 and (ParentCategoryCode = 3 or ParentCategoryCode = 4 or ParentCategoryCode = 5 )  or CategoryCode=14)b ) a
left join 
(select deptcode,LEFT(GOODSCODE,2) FL1,count(goodscode)sl from #sj where SaleAmount>0 group by deptcode,LEFT(GOODSCODE,2))b on a.nodecode=b.deptcode AND A.CategoryCode=B.FL1
left join 
(select deptcode,fl1,sum(sl)sl from 
(select deptcode,LEFT(GOODSCODE,2) FL1,count(goodscode)sl from #sj where WorkStateCode in (1,2,5)  group by deptcode,LEFT(GOODSCODE,2)
union all
select deptcode,LEFT(GOODSCODE,2) FL1,count(goodscode)sl from #sj where WorkStateCode in (3,4,50) and Amount>0  group by deptcode,LEFT(GOODSCODE,2))a
group by deptcode ,fl1
)c on a.nodecode=c.deptcode AND A.CategoryCode=C.FL1

order by 1,2,3

'exec (@sql1)

