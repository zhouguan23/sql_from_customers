 
 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select NodeCode ,GoodsCode ,SUM(SaleIncome)SaleIncome,SUM(saletax)saletax,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from  '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+' and (NodeCode like ''1%'' or NodeCode like ''2%'')
group by NodeCode ,GoodsCode
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='
select  a.AreaCode,a.NodeCode,left(a.CategoryCode,1)ParentCategoryCode,a.CategoryCode,isnull(b.jy_SKU,0)JY_SKU,
isnull(c.zk_SKU,0)ZK_SKU,isnull(ZK_SaleMoney,0)ZK_SaleMoney,isnull(ZK_TaxSaleGrossProfit,0)ZK_TaxSaleGrossProfit,
isnull(ZK_Amount,0)ZK_Amount,isnull(ZK_TaxCost,0)ZK_TaxCost  from 
(SELECT b.AreaCode,b.NodeCode,a.CategoryCode   from 
TB商品分类表 a,
TB部门信息表 b 

where a.CategoryItemCode=''0000'' and a.CategoryLevel=''2'' and a.CategoryCode not like ''0%''  
and a.CategoryCode not like ''6%'' and a.CategoryCode not like ''19%'' and a.CategoryCode not like ''29%''
and (b.NodeCode like ''1%'' or b.NodeCode like ''2%'') and b.State=0)a
left join 
(select a.DeptCode  NodeCode,left(b.CategoryCode,2)CategoryCode,COUNT(distinct a.GoodsCode)jy_SKU from 
TB部门商品经营状态表 a 
left join 
TB商品档案 b on a.GoodsCode =b.GoodsCode 
where a.WorkStateCode in (1,2,5)
and b.CategoryCode not like ''0%''  
and b.CategoryCode not like ''6%'' 
and b.CategoryCode not like ''19%'' 
and b.CategoryCode not like ''29%''
and (a.DeptCode like ''1%'' or a.DeptCode like ''2%'')
GROUP BY a.DeptCode,left(b.CategoryCode,2))b on a.NodeCode=b.NodeCode and a.CategoryCode=b.CategoryCode

left join 
(select a.NodeCode,left(b.CategoryCode,2)CategoryCode,COUNT(distinct a.GoodsCode)zk_SKU,sum(d.SaleIncome+d.saletax)ZK_SaleMoney,sum(d.TaxSaleGrossProfit)ZK_TaxSaleGrossProfit  from 
TB部门特殊商品对照 a
left join 
TB商品档案 b on a.GoodsCode =b.GoodsCode 
left join 
 ('+@SQL1+') d on a.nodecode =d.nodecode and a.goodscode =d.goodscode 
 left join 
 TB部门商品经营状态表 e on a.nodecode= e.deptcode and a.goodscode =e.goodscode 
where GoodsPropertyCode=''1999''
and b.CategoryCode not like ''0%''  
and b.CategoryCode not like ''6%'' 
and b.CategoryCode not like ''19%'' 
and b.CategoryCode not like ''29%''
and e.WorkStateCode in (1,2,5)
and (a.NodeCode like ''1%'' or a.NodeCode like ''2%'')
group by a.NodeCode,left(b.CategoryCode,2))c on a.NodeCode=c.NodeCode and a.CategoryCode=c.CategoryCode

left join 
(select a.NodeCode,left(b.CategoryCode,2)CategoryCode,COUNT(distinct a.GoodsCode)zk_SKU,sum(d.Amount)ZK_Amount,sum(d.TaxCost)ZK_TaxCost  from 
TB部门特殊商品对照 a
left join 
TB商品档案 b on a.GoodsCode =b.GoodsCode 
left join 
tbStocks  d on a.nodecode =d.CounterCode and a.goodscode =d.goodscode 
 left join 
 TB部门商品经营状态表 e on a.nodecode= e.deptcode and a.goodscode =e.goodscode 
where GoodsPropertyCode=''1999''
and b.CategoryCode not like ''0%''  
and b.CategoryCode not like ''6%'' 
and b.CategoryCode not like ''19%'' 
and b.CategoryCode not like ''29%''
and e.WorkStateCode in (1,2,5)
and (a.NodeCode like ''1%'' or a.NodeCode like ''2%'')
group by a.NodeCode,left(b.CategoryCode,2))d on a.NodeCode=d.NodeCode and a.CategoryCode=d.CategoryCode
where  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl) == 0,   "",   "and a.CategoryCode in (''" + replace(fl,",","'',''")+"'')") }


'exec(@sql)


