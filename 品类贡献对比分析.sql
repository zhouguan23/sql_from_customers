select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName  from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and (CategoryCode like '1%' or CategoryCode like '2%' or CategoryCode like '3%' or CategoryCode like '4%' or CategoryCode like '5%') and CategoryLevel<=2

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where (nodecode like ''1%'' or nodecode like ''2%'')  and occurdate between  '+@qsrq+' and '+@dqrq+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='
select DeptCategoryCode,b.nodecode,left(a.CategoryCode,1)一级分类,left(a.CategoryCode,2)二级分类,left(a.CategoryCode,3)三级分类,left(a.CategoryCode,4)四级分类,
SUM(b.SaleAmount)销售数量,SUM(b.SaleInCome)+sum(b.SaleTax)销售金额,sum(b.TaxSaleGrossProfit)销售毛利  from 
 [000]A.tbgoods a, 
 ('+@SQL+')b,
 [000]A.TBCATTODEPARTMENT c 
 where a.goodscode=b.goodscode and b.nodecode=c.nodecode and  a.CategoryCode not like ''0%'' and  a.CategoryCode not like ''6%''  and c.DeptCatItemCode =''0011''
and  1=1  ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and b.nodecode  in (''" + replace(bm,",","'',''")+"'')") }
group by DeptCategoryCode,b.nodecode,left(a.CategoryCode,1),left(a.CategoryCode,2),left(a.CategoryCode,3),left(a.CategoryCode,4)
order by 4
'exec(@sql1)


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where (nodecode like ''1%'' or nodecode like ''2%'')  and occurdate between  '+@qsrq+' and '+@dqrq+' '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')

SET @SQL1='
select DeptCategoryCode,left(a.CategoryCode,1)一级分类,left(a.CategoryCode,2)二级分类,left(a.CategoryCode,3)三级分类,left(a.CategoryCode,4)四级分类,
SUM(b.SaleAmount)销售数量,SUM(b.SaleInCome)+sum(b.SaleTax)销售金额,sum(b.TaxSaleGrossProfit)销售毛利  from 
 [000]A.tbgoods a, 
 ('+@SQL+')b,
 [000]A.TBCATTODEPARTMENT c 
 where a.goodscode=b.goodscode and b.nodecode=c.nodecode and  a.CategoryCode not like ''0%'' and  a.CategoryCode not like ''6%''  and c.DeptCatItemCode =''0011''
and  1=1  ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2)  in (''" + replace(fl,",","'',''")+"'')") }
and  1=1  ${if(len(bm) == 0,   "",   "and c.DeptCategoryCode  in (select DeptCategoryCode from  [000]A.TBCATTODEPARTMENT where DeptCatItemCode =''0011'' and  nodecode in ( ''" + replace(bm,",","'',''")+"''))") }
group by DeptCategoryCode,left(a.CategoryCode,1),left(a.CategoryCode,2),left(a.CategoryCode,3),left(a.CategoryCode,4)
order by 4
'exec(@sql1)



select distinct 
FormatCode NodeCode ,FormatName NodeName ,'' FormatCode from 
dbo.TB部门信息表 a
where 
exists (select * from  dbo.TB部门信息表 b where (a.AreaCode =b.AreaCode or a.FormatCode =b.FormatCode ))

and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601,1047)
union all 
select 
NodeCode,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,FormatCode
 from 
dbo.TB部门信息表 a

where 
exists (select * from  dbo.TB部门信息表 b where (a.AreaCode =b.AreaCode or a.FormatCode =b.FormatCode ))
and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601,1047)


