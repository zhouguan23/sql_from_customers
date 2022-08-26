

DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+'' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PromSaleProjectList' and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select GoodsBrand as 商品品牌,isnull(SUM(SaleIncome)+SUM(SaleTax),0) as 销售金额 from 
[000]A .tbgoods a
left join 

 ('+@SQL+') b on a.goodscode=b.goodscode and AccDate between  '+@qsrq+' and '+@dqrq+' and (deptcode like ''1%'' or deptcode like ''2%'')
where  len(a.goodsbrand)<>0 
and  1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }
and  1=1 ${if(len(pp) == 0,   "",   "and GoodsBrand in (''" + replace(pp,",","'',''")+"'')") }

group by GoodsBrand
             
'exec(@sql1)





DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+'' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select GoodsBrand as 商品品牌,isnull(SUM(SaleCost),0)销售成本,isnull(SUM(SaleIncome)+SUM(SaleTax),0) as 销售金额,isnull(sum(TaxSaleGrossProfit),0)销售毛利 from 
[000]A .tbgoods a
left join 
 ('+@SQL+')  b  on a.goodscode=b.goodscode and b.occurdate between  '+@qsrq+' and '+@dqrq+' and (nodecode like ''1%'' or nodecode like ''2%'')
where   len(a.goodsbrand)<>0 and a.goodsbrand<>''020001''
and  1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
and  1=1 ${if(len(pp) == 0,   "",   "and GoodsBrand in (''" + replace(pp,",","'',''")+"'')") }

group by GoodsBrand
order by GoodsBrand
             
'exec(@sql1)



select GoodsBrand as 商品品牌,isnull(SUM(StockCost ),0) as 库存金额, datediff(DD,'${qsrq}','${dqrq}')+1 天数 from 
[000]A.tbgoods a 
left join 
[000]A.TB${YM}_REPORTINFO b  on a.goodscode=b.goodscode and  ReportDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)and (DepartmentCode like '1%' or DepartmentCode like '2%')
where   len(a.goodsbrand)<>0 
and  1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2)  in ('" + replace(fl,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(pp) == 0,   "",   "and a.GoodsBrand in ('" + replace(pp,",","','")+"')") }
group by GoodsBrand


select GoodsBrand as 商品品牌,SUM(a.UnSalaNotSellDay)滞销SKU from 
(select a.GoodsBrand,a.CategoryCode ,a.GoodsCode,case when datediff(day,isnull(case when len(b.LastSaleDate)=0 then  b.LastPurchDate else b.LastSaleDate end,''),convert(varchar(8),dateadd(dd,0,'${dqrq}'),112))>=c.UnSalaNotSellDay then 1 else 0 end UnSalaNotSellDay  from
[000]A .tbgoods a 
left join 
[000]A.TB${YM}_REPORTINFO b on a.GoodsCode =b.goodscode  and (b.DepartmentCode like '1%' or b.DepartmentCode like '2%') and ReportDate  =(select max(ReportDate) from [000]A.TB${YM}_REPORTINFO d where b.GoodsCode =d.goodscode and b.DepartmentCode=d.DepartmentCode  )
left join 
[000]A.TBREPORTPARADEFINE c on left(a.CategoryCode,4)=c.goodscode and c.DeptType='0'
where len(a.goodsbrand)<>0 and round(b.StockAmount,1)>0
and  1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2)  in ('" + replace(fl,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and b.DepartmentCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(pp) == 0,   "",   "and a.GoodsBrand in ('" + replace(pp,",","','")+"')") }

)a
group by GoodsBrand

select * from 
[000]A.TBGOODSBRAND

