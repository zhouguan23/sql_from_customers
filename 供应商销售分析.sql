             
             
             

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM['+[name]A+']A' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_报表数据源' and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL SELECT * FROM['+[name]A+']A' FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_促销销售表' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')
SET @SQL2=STUFF(@SQL2,1,11,'')
SET @SQL1='

select ROW_NUMBER() OVER (ORDER BY a.供应商 ASC) AS XUHAO,a.供应商,sum(a.销售成本)销售成本,sum(a.销售金额)销售金额,sum(isnull(d.销售金额,0))促销金额,sum(a.销售毛利)销售毛利,sum(isnull(b.库存成本,0))库存金额,sum(isnull(c.SKU,0))滞销SKU, datediff(DD,''${qsrq}'',''${dqrq}'')+1 天数 from 
(select 供应商,部门编码,商品编码,SUM(销售成本)销售成本,SUM(销售税金)+SUM(销售收入) as 销售金额,sum(含税销售毛利)销售毛利 from 
 ('+@SQL+') a
where  报表日期 between  '+@qsrq+' and '+@dqrq+' 
and  1=1 ${if(len(fl) == 0,   "",   "and left(五级分类编码,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and 部门编码 in (''" + replace(bm,",","'',''")+"'')") }

group by 供应商,部门编码,商品编码)a
left join 
(select 部门编码,商品编码,sum(库存成本)库存成本 from 
 ('+@SQL+') a
where  报表日期 ='+@dqrq+'
group by 部门编码,商品编码)b on  a.部门编码=b.部门编码 and a.商品编码=b.商品编码
left join 
(select 部门编码,商品编码,case when datediff(day,case when len(a.最后销货日)=0 then  a.最后进货日 else a.最后销货日 end,报表日期)>=b.UnSalaNotSellDay then 1 else 0 end SKU from 
 ('+@SQL+') a
left join 
TBREPORTPARADEFINE b on left(五级分类编码,4)= b.goodscode
where  报表日期 ='+@dqrq+' and left(五级分类编码,2) not in (23,28,29) and 商品类型 in (0,2) and 库存数量>0)c on  a.部门编码=c.部门编码 and a.商品编码=c.商品编码
left join 
(select deptcode  部门编码,goodscode 商品编码,sum(SaleIncome)+sum(SaleTax)销售金额 from 
 ('+@SQL2+') a
where  AccDate between  '+@qsrq+' and '+@dqrq+' 
group by deptcode,goodscode)d on  a.部门编码=d.部门编码 and a.商品编码=d.商品编码
where  1=1 ${if(len(gys) == 0,   "",   "and left(a.供应商,7) in (''" + replace(gys,",","'',''")+"'')") }
group by a.供应商
             
'exec(@sql1)



DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+'' FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,10,19) LIKE 'REPORTINFO'  and SUBSTRING(name,3,6) between  @qsny and @jsny
SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='

select SupplierCode as 商品厂商,isnull(SUM(CommonSaleCost),0)+isnull(SUM(PromotionSaleCost),0)销售成本,isnull(SUM(CommonSaleIncome)+SUM(CommonSaleTax ),0)+isnull(SUM(PromotionSaleIncome)+SUM(PromotionSaleTax),0) as 销售金额,(isnull(SUM(CommonSaleIncome)+SUM(CommonSaleTax ),0)+isnull(SUM(PromotionSaleIncome)+SUM(PromotionSaleTax),0)) -isnull(sum(TaxCommonSaleCost)+sum(TaxPromotionSaleCost),0)销售毛利,isnull(SUM(PromotionSaleIncome)+SUM(PromotionSaleTax),0) as 促销金额 from 

 ('+@SQL+')  a
where    len(a.SupplierCode)<>0 and ReportDate between  '+@qsrq+' and '+@dqrq+'  and (DepartmentCode like ''1%'' or DepartmentCode like ''2%'')
  and CategoryCode not like ''0%'' and CategoryCode not like ''6%''
and  1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in (''" + replace(bm,",","'',''")+"'')") }
and  1=1 ${if(len(cs) == 0,   "",   "and SupplierCode in (''" + replace(cs,",","'',''")+"'')") }

group by SupplierCode
order by SupplierCode
             
'exec(@sql1)



select SupplierCode as 商品品牌,isnull(SUM(StockCost ),0) as 库存金额, datediff(DD,'${qsrq}','${dqrq}')+1 天数 from 

[000]A.TB${YM}_REPORTINFO 
where   len(SupplierCode)<>0  and  ReportDate =convert(varchar(8),dateadd(dd,0,'${dqrq}'),112) and (DepartmentCode like '1%' or DepartmentCode like '2%')
and  1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in ('" + replace(fl,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(cs) == 0,   "",   "and SupplierCode in ('" + replace(cs,",","','")+"')") }
group by SupplierCode


select SupplierCode as 商品品牌,SUM(a.UnSalaNotSellDay)滞销SKU from 
(select SupplierCode,CategoryCode ,a.GoodsCode,case when datediff(day,isnull(case when len(LastSaleDate)=0 then  LastPurchDate else LastSaleDate end,''),convert(varchar(8),dateadd(dd,0,'${dqrq}'),112))>=UnSalaNotSellDay then 1 else 0 end UnSalaNotSellDay  from

[000]A.TB${YM}_REPORTINFO a  
left join 
[000]A.TBREPORTPARADEFINE c on left(a.CategoryCode,4)=c.goodscode and c.DeptType='0'
where len(SupplierCode)<>0 and round(StockAmount,1)>0 and 
 (DepartmentCode like '1%' or DepartmentCode like '2%') and ReportDate =(select max(ReportDate) from [000]A.TB${YM}_REPORTINFO d where a.GoodsCode =d.goodscode and a.DepartmentCode=d.DepartmentCode  )
and  1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2)  in ('" + replace(fl,",","','")+"')") }
and  1=1 ${if(len(bm) == 0,   "",   "and DepartmentCode in ('" + replace(bm,",","','")+"')") }
and  1=1 ${if(len(cs) == 0,   "",   "and SupplierCode in ('" + replace(cs,",","','")+"')") }

)a
group by SupplierCode

