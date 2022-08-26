 
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select NodeCode ,GoodsCode ,SUM(SaleAmount)SaleAmount,SUM(SaleIncome)SaleIncome,SUM(saletax)saletax,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from  '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' and (NodeCode like ''1%'' or NodeCode like ''2%'')
group by NodeCode ,GoodsCode
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='
select a.NodeCode,a.GoodsCode,b.GoodsName,b.BaseMeasureUnit,isnull(c.WorkStateCode,'''')WorkStateCode,sum(isnull(d.SaleAmount,0))SaleAmount
,sum(isnull(d.SaleIncome+d.saletax,0))SaleMoney,sum(isnull(d.TaxSaleGrossProfit,0))TaxSaleGrossProfit,
sum(isnull(e.Amount,0))ZK_Amount,sum(isnull(e.TaxCost,0))ZK_TaxCost,sum(isnull(f.Amount,0))WayAmount  from 
TB部门特殊商品对照 a
left join 
TB商品档案 b on a.GoodsCode =b.GoodsCode 
left join 
TB部门商品经营状态表 c on a.nodecode =c.deptcode and a.goodscode =c.goodscode  
 left join 
tbStocks  e on a.nodecode =e.CounterCode and a.goodscode =e.goodscode 
left join 
tbWayArrivalannual f on a.nodecode=f.deptcode and a.goodscode=f.goodscode 
left join 
 ('+@SQL1+') d on a.nodecode =d.nodecode and a.goodscode =d.goodscode 
 
where GoodsPropertyCode=''1999''
and b.CategoryCode not like ''0%''  
and b.CategoryCode not like ''6%'' 
and b.CategoryCode not like ''19%'' 
and b.CategoryCode not like ''29%''
and c.WorkStateCode in (''1'',''2'',''5'')
and (a.NodeCode like ''1%'' or a.NodeCode like ''2%'')
and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl) == 0,   "",   "and LEFT(b.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
group by a.NodeCode,a.GoodsCode,b.GoodsName,b.BaseMeasureUnit,isnull(c.WorkStateCode,'''')




'exec(@sql)


select distinct * from 
(select DeptCode ,GoodsCode,PackRate  from 
[6001]A.TBWRAPCONTROL
where  ControlPass=2 and DeptType  =1  
union all 
select NodeCode  ,GoodsCode,PackRate  from 
[6001]A.TBWRAPCONTROL a 
left join 
[6001]A .TBCATTODEPARTMENT  b on a.DeptCode=b.DeptCategoryCode and b.DeptCatItemCode ='0001'
where  ControlPass=2 and DeptType  =0  )a
where 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in ('" + replace(bm,",","','")+"')") }

