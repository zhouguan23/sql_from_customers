select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2,6,7,8)  and len(AreaCode)<>0 
and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}
and  1=1 ${if(sx == 0,   " and left(a.nodecode,1) not in (6,7,8)", "") }

select CategoryCode,CategoryName from 
[000]A.TBDEPTCATEGORY 
where  CategoryItemCode ='0011'

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2,6,7,8) 
and nodecode not in (1047,6601,6602)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and  1=1 ${if(sx == 0,   " and left(a.nodecode,1) not in (6,7,8)", "") }

select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='1'
union all 
select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2'

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${dqrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM '+[name]A+' where occurdate between '+@qsrq+' and '+@dqrq+'

' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDAYpssm' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL='

select a.AreaCode ,a.nodecode,a.ParentCategoryCode,a.CategoryCode,isnull(b.StartCost,0)+isnull(c.Cost,0)StockCost,isnull(d.SaleCost,0)SaleCost from
(select a.AreaCode ,a.NodeCode ,b.ParentCategoryCode,b.CategoryCode  from 
tb部门信息表 a,TB商品分类表 b 
where	 left(a.NodeCode,1) between 1 and 8 and a.nodecode not in (6601) and a.OpenDate<='+@dqrq+' and State!=2
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode  in (''" + replace(bm,",","'',''")+"'')") }
and 1=1 ${if(len(fl2) == 0,   "",   "and left(b.CategoryCode,2) in (''" + replace(fl2,",","'',''")+"'')") }
and  1=1 ${if(cy == 0,   "",   "and b.CategoryCode not like ''23%''") }
and  1=1 ${if(mt == 0,   "",   "and b.CategoryCode not like ''35000%''") }
and b.CategoryItemCode=''0000'' and b.CategoryLevel=''2'' and b.ParentCategoryCode between 1 and 5
and b.CategoryCode not in (''19'',''28'',''29'')
)a
left join
(select nodecode,case 
when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end CategoryCode, SUM(StartCost)StartCost from 
tb'+@jsny+'_GoodsMonPssm a ,tb商品档案 b 
where a.goodscode=b.goodscode 
and b.GoodsType not in (1,6,7) 

and  1=1 ${if(sx == 0,   "",   "and GoodsBrand=''" +sx+"''") }
and  1=1 ${if(xy == 0,   "",   "and CategoryCode not like ''300%''") }
and  1=1 ${if(cy == 0,   "",   "and CategoryCode not like ''23%''") }
and  1=1 ${if(mt == 0,   "",   "and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like ''1888'' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)") }
and not exists (select * from 
TB部门特殊商品对照 z 
where a.nodecode =z.nodecode and a.goodscode =z.goodscode and z.GoodsPropertyCode=''2002'')
and left(b.CategoryCode,1) between 1 and 5 

group by  nodecode,case when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end)b on a.nodecode=b.nodecode and a.CategoryCode=b.CategoryCode
   left join 
   (select nodecode,case 
when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end CategoryCode,
   sum(PURCHCOST+ REDEPLOYINCOST+ PROFITCOST+ COUNTPROFITCOST - SaleCost  - REDEPLOYOUTCOST- LOSSCOST- COUNTLOSSCOST-ToGiftCost)COST from 
tb'+@jsny+'_GoodsDayPssm a ,tb商品档案 b 
where a.goodscode=b.goodscode 
and b.GoodsType not in (1,6,7) 
and Occurdate <= '+@dqrq+'
and  1=1 ${if(sx == 0,   "",   "and GoodsBrand=''" +sx+"''") }
and  1=1 ${if(xy == 0,   "",   "and CategoryCode not like ''300%''") }
and  1=1 ${if(cy == 0,   "",   "and CategoryCode not like ''23%''") }
and  1=1 ${if(mt == 0,   "",   "and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like ''1888'' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)") }
and not exists (select * from 
TB部门特殊商品对照 z 
where a.nodecode =z.nodecode and a.goodscode =z.goodscode and z.GoodsPropertyCode=''2002''
)


and left(b.CategoryCode,1) between 1 and 5 

group by  nodecode,case when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end)c on a.nodecode=c.nodecode and a.CategoryCode=c.CategoryCode

      left join 
   (select nodecode,case 
when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end CategoryCode,
   sum(SaleCost) SaleCost from 
 ('+@SQL1+') a ,tb商品档案 b 
where a.goodscode=b.goodscode 
and b.GoodsType not in (1,6,7) 
AND a.nodecode NOT in (6666,7777,8888)
and  1=1 ${if(sx == 0,   "",   "and GoodsBrand=''" +sx+"''") }
and  1=1 ${if(xy == 0,   "",   "and CategoryCode not like ''300%''") }
and  1=1 ${if(cy == 0,   "",   "and CategoryCode not like ''23%''") }
and  1=1 ${if(mt == 0,   "",   "and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like ''1888'' and a.nodecode=z.nodecode and a.goodscode=z.goodscode)") }
and not exists (select * from 
TB部门特殊商品对照 z 
where a.nodecode =z.nodecode and a.goodscode =z.goodscode and z.GoodsPropertyCode=''2002''
)


and left(b.CategoryCode,1) between 1 and 5 

group by  nodecode,case when (left(CategoryCode,3) in (''280'',''287'') or left(CategoryCode,2)=''29'') then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end)D on a.nodecode=D.nodecode and a.CategoryCode=D.CategoryCode

   order by 1,2,3,4
'exec(@sql)





