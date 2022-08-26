
select  CategoryItemCode,CategoryCode,'(黔惠)'+CategoryName CategoryName,ParentCategoryCode,CategoryLevel from 
tb分类对照表
where CategoryItemCode in ('0000','0001') and CategoryLevel<=2


select  * from 
tb分类对照表
where CategoryItemCode in ('0000','0001') and CategoryLevel<=2


 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,
left(a.CategoryCode,2)CategoryCode,a.CategoryName,bm,
isnull(b.Salesindex,0)TaxSalesindex,isnull(b.Grossprofitindex,0) TaxGrossprofitindex,
isnull(c.Salesindex,0)Salesindex,isnull(c.Grossprofitindex,0)Grossprofitindex,
isnull(d.SaleMoney,0)SaleMoney,isnull(d.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
isnull(d.SaleIncome,0)SaleIncome,isnull(d.SaleGrossProfit,0)SaleGrossProfit,
isnull(ProcePayMoney,0)ProcePayMoney,isnull(TaxRateDiff,0)TaxRateDiff,
isnull(LossProfitMoney,0)LossProfitMoney,isnull(Newstoreortaxrate,0)Newstoreortaxrate,
isnull(Maoriadjustmentoftheprocessing,0)Maoriadjustmentoftheprocessing,isnull(Incomeadjustment,0)Incomeadjustment
 from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,
datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'+@jsny+'+''01'')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
[HLCWDW]A.[dbo]A.tb分类对照表 a
left join 
[HLCWDW]A.[dbo]A.tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
[HLCWDW]A.[dbo]A.tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'' )a
where left(b.NodeCode,1) in (1,2)  
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }

)a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
[HLCWDW]A.[dbo]A.[含税分课预算表]A 
where CategoryItemCode=''0000'' and BudgetYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) b on a.nodecode=b.deptcode and a.bm=b.CategoryCode 
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
[HLCWDW]A.[dbo]A.[无税分课预算表]A 
where CategoryItemCode=''0000'' and BudgetYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) c on a.nodecode=c.deptcode and a.bm=c.CategoryCode 
left join 
(select NodeCode DeptCode,left(CategoryCode,2)CategoryCode,
SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(select b.NodeCode ,
   case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (''29000'',''29001'',''29002'',''29004'',''29005'',''29010'',''29011'',''29012'',''29013'',''29020'',''29021'',''29022'',''29023'')) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   when left(CategoryCode,2) in (''35'') then ''30''  
   else left(CategoryCode,2) end   CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 tb商品档案 a ,
tb'+[YM]A+'_GoodsDayPssm b 
 where a.GoodsCode =b.GoodsCode   
  and OccurDate between '+@qsrq+' and '+@dqrq+'  
  and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in (''" + replace(bm,",","'',''")+"'')") }

  and left(NodeCode,1) between ''1'' and ''2''
  and left(CategoryCode,1) between ''1'' and ''5''
  and left(CategoryCode,2) not in (''23'')  
  and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(2002, 1888) and b.nodecode=z.nodecode and b.goodscode=z.goodscode)
  
 group by b.NodeCode ,
 case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (''29000'',''29001'',''29002'',''29004'',''29005'',''29010'',''29011'',''29012'',''29013'',''29020'',''29021'',''29022'',''29023'')) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''
   when left(CategoryCode,2) in (''35'') then ''30''    
   else left(CategoryCode,2) end 
  
  union all
  select b.NodeCode ,''39''CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 tb商品档案 a ,
tb'+[YM]A+'_GoodsDayPssm b 
 where a.GoodsCode =b.GoodsCode   
  and OccurDate between '+@qsrq+' and '+@dqrq+' 
  and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in (''" + replace(bm,",","'',''")+"'')") }

  and left(NodeCode,1) between ''1'' and ''2''
  and left(CategoryCode,1) in (''1'',''2'',''3'',''4'',''5'')  
  and exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(2002) and b.nodecode=z.nodecode and b.goodscode=z.goodscode)
    and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(1888) and b.nodecode=z.nodecode and b.goodscode=z.goodscode)
  

 group by b.NodeCode 

 union all 
 
select zb.DeptCode,
 case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (''29000'',''29001'',''29002'',''29004'',''29005'',''29010'',''29011'',''29012'',''29013'',''29020'',''29021'',''29022'',''29023'')) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end  CategoryCode,
  sum(SaleEarning)SaleIncome,sum(SaleEarning+SaleTax)SaleMoney ,sum(SaleEarning) SaleGrossProfit,sum(SaleEarning+SaleTax) TaxSaleGrossProfit
 from  tb'+[YM]A+'_SaleBill zb  ,tb'+[YM]A+'_SALERENTDETAIL cb ,tb商品档案 c 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
 and zb.EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
 and 1=1 ${if(len(bm) == 0,   "",   "and ZB.DeptCode in (''" + replace(bm,",","'',''")+"'')") }
 
 and left(ZB.DeptCode,1) between ''1'' and ''2''
 and cb.GoodsCode=c.GoodsCode  
 and cb.goodscode not like ''0%'' 
 and cb.goodscode not like ''6%''
 and LEFT(c.CategoryCode,2) not in (''23'')
 and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(2002, 1888) and z.nodecode=zb.DeptCode and z.goodscode=c.goodscode)
 group by zb.DeptCode,
 case when (left(CategoryCode,3) in (''280'',''287'') or CategoryCode in (''29000'',''29001'',''29002'',''29004'',''29005'',''29010'',''29011'',''29012'',''29013'',''29020'',''29021'',''29022'',''29023'')) then ''20'' 
   when left(CategoryCode,3) in (''281'',''288'') then ''21'' 
   when left(CategoryCode,3) in (''282'',''289'') then ''22''  
   else left(CategoryCode,2) end )a
  group by NodeCode ,left(CategoryCode,2)) d on a.nodecode=d.deptcode and a.bm=d.CategoryCode 
left join 
(select DeptCode,CategoryCode,sum(ProcePayMoney)ProcePayMoney,sum(TaxRateDiff)TaxRateDiff,sum(LossProfitMoney)LossProfitMoney,sum(Newstoreortaxrate)Newstoreortaxrate,sum(Maoriadjustmentoftheprocessing)Maoriadjustmentoftheprocessing,sum(Incomeadjustment)Incomeadjustment from 
[HLCWDW]A.[dbo]A.[TB门店绩效表毛利扣减表]A
where CategoryItemCode=''0000'' and HappenYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) e on a.nodecode=e.deptcode and a.bm=e.CategoryCode  ' 
 FROM (select distinct convert(varchar(6),dateadd(dd,number,@qsrq),112) AS YM 
    from master..spt_values 
    where type='p' and dateadd(dd,number,@qsrq)<=@dqrq)a

 SET @SQL1=STUFF(@SQL1,1,11,'')


 SET @SQL='
select a.NodeCode,b.CategoryLengCode,a.nodename,a.rq,a.OpenDate,a.ParentCategoryCode,
a.CategoryCode,a.CategoryName,a.bm,
sum(TaxSalesindex)TaxSalesindex,sum(TaxGrossprofitindex) TaxGrossprofitindex,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex,
sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,
sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,
sum(ProcePayMoney)ProcePayMoney,sum(TaxRateDiff)TaxRateDiff,
sum(LossProfitMoney)LossProfitMoney,sum(Newstoreortaxrate)Newstoreortaxrate,
sum(Maoriadjustmentoftheprocessing)Maoriadjustmentoftheprocessing,sum(Incomeadjustment)Incomeadjustment from 
('+@sql1+')a
left join 
  [HLCWDW]A.[dbo]A.TB分类对照表 b on b.CategoryItemCode=''0003'' and a.NodeCode=b.CategoryCode

group by a.NodeCode,b.CategoryLengCode,a.nodename,a.rq,a.OpenDate,a.ParentCategoryCode,
a.CategoryCode,a.CategoryName,a.bm

 order by 1,9,7

 'exec(@sql)

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8)
set @dqrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny=@dqrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny=@qsrq
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,
left(a.CategoryCode,2)CategoryCode,a.CategoryName,bm,
isnull(b.Salesindex,0)TaxSalesindex,isnull(b.Grossprofitindex,0) TaxGrossprofitindex,
isnull(c.Salesindex,0)Salesindex,isnull(c.Grossprofitindex,0)Grossprofitindex,
isnull(d.SaleMoney,0)SaleMoney,isnull(d.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
isnull(d.SaleIncome,0)SaleIncome,isnull(d.SaleGrossProfit,0)SaleGrossProfit,
isnull(ProcePayMoney,0)ProcePayMoney,isnull(TaxRateDiff,0)TaxRateDiff,
isnull(LossProfitMoney,0)LossProfitMoney,isnull(Newstoreortaxrate,0)Newstoreortaxrate,
isnull(Maoriadjustmentoftheprocessing,0)Maoriadjustmentoftheprocessing,isnull(Incomeadjustment,0)Incomeadjustment
 from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,
datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'+@jsny+'+''01'')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
[HLCWDW]A.[dbo]A.tb分类对照表 a
left join 
[HLCWDW]A.[dbo]A.tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode=''0000''
left join 
[HLCWDW]A.[dbo]A.tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode=''0000''
where a.CategoryItemCode=''0000'' and a.CategoryLevel=''0'' and a.CategoryCode not like ''9%'' )a
where left(b.NodeCode,1) in (1,2)  
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in (''" + replace(bm,",","'',''")+"'')") }

)a
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
[HLCWDW]A.[dbo]A.[含税分课预算表]A 
where CategoryItemCode=''0001'' and BudgetYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) b on a.nodecode=b.deptcode and a.bm=b.CategoryCode 
left join 
(select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
[HLCWDW]A.[dbo]A.[无税分课预算表]A 
where CategoryItemCode=''0001'' and BudgetYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) c on a.nodecode=c.deptcode and a.bm=c.CategoryCode 
left join 
(select NodeCode DeptCode,left(CategoryCode,2)CategoryCode,
SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit
from
(select b.NodeCode ,
   case
   when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
   when left(CategoryCode,2) in (''30'',''32'',''33'') then ''30''  
   when left(CategoryCode,2) in (''31'') then ''31''  
   when left(CategoryCode,2) in (''40'',''41'') then ''40''  
   when left(CategoryCode,2) in (''46'',''47'') then ''46''  
   when left(CategoryCode,1) in (''5'') then ''50'' 
   else left(CategoryCode,2) end   CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 tb商品档案 a ,
tb'+[YM]A+'_GoodsDayPssm b 
 where a.GoodsCode =b.GoodsCode   
  and OccurDate between '+@qsrq+' and '+@dqrq+'  
  and 1=1 ${if(len(bm) == 0,   "",   "and NodeCode in (''" + replace(bm,",","'',''")+"'')") }
  and GoodsBrand =''010001''
  and left(NodeCode,1) between ''1'' and ''2''
  and left(CategoryCode,1) between ''1'' and ''5''
  and left(CategoryCode,2) not in (''23'')  
  and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(2002, 1888) and b.nodecode=z.nodecode and b.goodscode=z.goodscode)
  
 group by b.NodeCode ,
 case
   when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
   when left(CategoryCode,2) in (''30'',''32'',''33'') then ''30''  
   when left(CategoryCode,2) in (''31'') then ''31''  
   when left(CategoryCode,2) in (''40'',''41'') then ''40''  
   when left(CategoryCode,2) in (''46'',''47'') then ''46''  
   when left(CategoryCode,1) in (''5'') then ''50'' 
   else left(CategoryCode,2) end
  

 union all 
 
select zb.DeptCode,
 case
   when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
   when left(CategoryCode,2) in (''30'',''32'',''33'') then ''30''  
   when left(CategoryCode,2) in (''31'') then ''31''  
   when left(CategoryCode,2) in (''40'',''41'') then ''40''  
   when left(CategoryCode,2) in (''46'',''47'') then ''46''  
   when left(CategoryCode,1) in (''5'') then ''50'' 
   else left(CategoryCode,2) end  CategoryCode,
  sum(SaleEarning)SaleIncome,sum(SaleEarning+SaleTax)SaleMoney ,sum(SaleEarning) SaleGrossProfit,sum(SaleEarning+SaleTax) TaxSaleGrossProfit
 from  tb'+[YM]A+'_SaleBill zb  ,tb'+[YM]A+'_SALERENTDETAIL cb ,tb商品档案 c 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
 and zb.EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
 and 1=1 ${if(len(bm) == 0,   "",   "and ZB.DeptCode in (''" + replace(bm,",","'',''")+"'')") }
 and GoodsBrand =''010001''
 and left(ZB.DeptCode,1) between ''1'' and ''2''
 and cb.GoodsCode=c.GoodsCode  
 and cb.goodscode not like ''0%'' 
 and cb.goodscode not like ''6%''
 and LEFT(c.CategoryCode,2) not in (''23'')
 and not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode in(2002, 1888) and z.nodecode=zb.DeptCode and z.goodscode=c.goodscode)
 group by zb.DeptCode,
 case
   when left(CategoryCode,1) in (''1'',''2'') then ''10'' 
   when left(CategoryCode,2) in (''30'',''32'',''33'') then ''30''  
   when left(CategoryCode,2) in (''31'') then ''31''  
   when left(CategoryCode,2) in (''40'',''41'') then ''40''  
   when left(CategoryCode,2) in (''46'',''47'') then ''46''  
   when left(CategoryCode,1) in (''5'') then ''50'' 
   else left(CategoryCode,2) end )a
  group by NodeCode ,left(CategoryCode,2)) d on a.nodecode=d.deptcode and a.bm=d.CategoryCode 
left join 
(select DeptCode,CategoryCode,sum(ProcePayMoney)ProcePayMoney,sum(TaxRateDiff)TaxRateDiff,sum(LossProfitMoney)LossProfitMoney,sum(Newstoreortaxrate)Newstoreortaxrate,sum(Maoriadjustmentoftheprocessing)Maoriadjustmentoftheprocessing,sum(Incomeadjustment)Incomeadjustment from 
[HLCWDW]A.[dbo]A.[TB门店绩效表毛利扣减表]A
where CategoryItemCode=''0001'' and HappenYM between '+@qsny+' and '+@jsny+' 
and 1=1 ${if(len(bm) == 0,   "",   "and DeptCode in (''" + replace(bm,",","'',''")+"'')") }

group by DeptCode,CategoryCode) e on a.nodecode=e.deptcode and a.bm=e.CategoryCode  ' 
 FROM (select distinct convert(varchar(6),dateadd(dd,number,@qsrq),112) AS YM 
    from master..spt_values 
    where type='p' and dateadd(dd,number,@qsrq)<=@dqrq)a

 SET @SQL1=STUFF(@SQL1,1,11,'')


 SET @SQL='
select a.NodeCode,b.CategoryLengCode,a.nodename,a.rq,a.OpenDate,a.ParentCategoryCode,
case when a.bm=''31'' then ''33'' else a.CategoryCode end CategoryCode,a.CategoryName,a.bm,
sum(TaxSalesindex)TaxSalesindex,sum(TaxGrossprofitindex) TaxGrossprofitindex,
sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex,
sum(SaleMoney)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,
sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,
sum(ProcePayMoney)ProcePayMoney,sum(TaxRateDiff)TaxRateDiff,
sum(LossProfitMoney)LossProfitMoney,sum(Newstoreortaxrate)Newstoreortaxrate,
sum(Maoriadjustmentoftheprocessing)Maoriadjustmentoftheprocessing,sum(Incomeadjustment)Incomeadjustment from 
('+@sql1+')a
left join 
  [HLCWDW]A.[dbo]A.TB分类对照表 b on b.CategoryItemCode=''0003'' and a.NodeCode=b.CategoryCode

group by a.NodeCode,b.CategoryLengCode,a.nodename,a.rq,a.OpenDate,a.ParentCategoryCode,case when a.bm=''31'' then ''33'' else a.CategoryCode end,a.CategoryName,a.bm
 order by 1,9,7

 'exec(@sql)

