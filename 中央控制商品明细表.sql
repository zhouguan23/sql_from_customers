 
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


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM '+[name]A+' a where  报表日期 between  '+@qsrq+' and '+@dqrq+' 
and 五级分类编码 not like ''0%''  and 五级分类编码 not like ''6%'' 
and 五级分类编码 not like ''19%'' and 五级分类编码 not like ''29%''
and (部门编码 like ''1%'' or 部门编码 like ''2%'')
and exists(select * from TB部门特殊商品对照 c where c.GoodsPropertyCode=''1999'' and  a.商品编码 =c.goodscode and a.部门编码 =c.NodeCode )
and 1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl) == 0,   "",   "and LEFT(五级分类编码,2) in (''" + replace(fl,",","'',''")+"'')") }
and 1=1 ${if(len(gys) == 0,   "",   "and left(供应商,7) in (''" + replace(gys,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_报表数据源' AND name not LIKE '%分类%' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL1='
select a.nodecode,a.goodscode,a.SaleAmount,a.SaleMeony,a.TaxSaleGrossProfit,isnull(b.Amount,0)Amount,isnull(c.Amount,0)WayAmount from 
(select 部门编码 nodecode,商品编码 goodscode,sum(销售数量)SaleAmount,sum(销售收入+销售税金)SaleMeony,sum(含税销售毛利)TaxSaleGrossProfit from 
('+@SQL+')a


group by 部门编码,商品编码)a
left join 
tbStocks b on a.nodecode=b.CounterCode and a.goodscode=b.goodscode 
left join 
tbWayArrivalannual c on a.nodecode=c.deptcode and a.goodscode=c.goodscode 
order by 1,2
'exec(@sql1)




