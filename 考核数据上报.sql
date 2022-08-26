select a.NodeCode,a.nodename,a.OpenDate,a.ParentCategoryCode,a.CategoryCode  from 
(select  b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,left('${jsrq}',6)+'01')+1, 0)))OpenDate,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and left(b.NodeCode,1) between 1 and 2
)a
where  1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
order by a.NodeCode,a.CategoryCode 



select a.DeptCode,a.CategoryCode,sum(a.Salesindex) TaxSalesindex,sum(a.Grossprofitindex )TaxGrossprofitindex,sum(b.Salesindex)Salesindex,sum(b.Grossprofitindex)Grossprofitindex from 
    [含税分课预算表]A a 
    left join 
    [无税分课预算表]A  b on a.BudgetYM =b.BudgetYM and a.CategoryCode=b.CategoryCode and a.DeptCode=b.DeptCode and a.CategoryItemCode=b.CategoryItemCode
    where a.BudgetYM between left('${qsrq}',6) and left('${jsrq}',6) and 1=1 ${if(len(bm) == 0,   "",   "and a.DEPTCODE in ('" + replace(bm,",","','")+"')") } and a.CategoryItemCode='0000' and b.CategoryItemCode='0000'
    group by a.DeptCode,a.CategoryCode

select * from 
TB门店绩效表毛利扣减表
where HappenYM=left('${jsrq}',6) and    CategoryItemCode ='0000'

declare @sql varchar(8000), @ny varchar(6),@rq varchar(8),@qsrq varchar(8),@jsrq varchar(8),@qsny varchar(6)
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) 
set @jsrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112) 
set @ny=convert(varchar(6),dateadd(mm,0,@jsrq),112) 
set @qsny=convert(varchar(6),dateadd(mm,-1,@jsrq),112) 
set @sql='
 select NodeCode ,CategoryCode1,CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
  (select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,LEFT(a.CategoryCode,2)CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@qsny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode  and a.GoodsType=''0'' and OccurDate between '+@qsrq+' and '+@jsrq+' 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),LEFT(a.CategoryCode,2)
 union all 
  
  select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,LEFT(a.CategoryCode,2)CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@ny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode  and a.GoodsType=''0''  and OccurDate between '+@qsrq+' and '+@jsrq+' 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),LEFT(a.CategoryCode,2))a
  group by NodeCode ,CategoryCode1,CategoryCode
 'execute(@sql)
 

declare @sql varchar(8000), @ny varchar(6),@rq varchar(8),@qsrq varchar(8),@jsrq varchar(8),@qsny varchar(6)
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) 
set @jsrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112) 
set @ny=convert(varchar(6),dateadd(mm,0,@jsrq),112) 
set @qsny=convert(varchar(6),dateadd(mm,-1,@jsrq),112) 
set @sql='
 select NodeCode ,CategoryCode,CategoryCode2,SupplierCode 
  ,SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,
  case  when SupplierCode=''9000022'' then 0.12 when SUM(SaleGrossProfit)=0 or SUM(SaleIncome)=0 then 0  else  SUM(SaleGrossProfit)/SUM(SaleIncome) end 扣点,
  case   when SupplierCode=''9000022'' then 0.12 when SUM(TaxSaleGrossProfit)=0 or SUM(SaleMoney)=0 then 0  else SUM(TaxSaleGrossProfit)/SUM(SaleMoney) end 含税扣点
  
  
   from 
 (select b.NodeCode ,left(a.CategoryCode,1)CategoryCode, case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end CategoryCode2,a.goodscode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@qsny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode    and a.GoodsType in (1,7)  
 and OccurDate between '+@qsrq+' and '+@jsrq+' 
 and LEFT(a.CategoryCode,2) not in (23)
 and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1), case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end,a.goodscode
  
  
 union all 
 select zb.DeptCode,left(c.CategoryCode,1)CategoryCode,
 case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(c.CategoryCode,2) end CategoryCode2,cb.goodscode 
,sum(SaleEarning)SaleIncome,sum(SaleEarning+SaleTax)SaleMoney ,0 SaleGrossProfit,0 TaxSaleGrossProfit
 from  [000]A.tb'+@qsny+'_SaleBill  zb  ,[000]A.tb'+@qsny+'_SALERENTDETAIL cb ,[000]A .tbGoods c 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
  and EnterAccountDate between '+@qsrq+' and '+@jsrq+' 
 and cb.GoodsCode=c.GoodsCode  and   
 cb.goodscode not like ''0%'' 
 and   cb.goodscode not like ''6%''
 and LEFT(c.CategoryCode,2) not in (23)
 and  1=1 ${if(len(bm) == 0,   "",   "and zb.deptcode in (''" + replace(bm,",","'',''")+"'')") }
 group by zb.DeptCode,left(c.CategoryCode,1), case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(c.CategoryCode,2) end,cb.goodscode 

union all 


 select b.NodeCode ,left(a.CategoryCode,1)CategoryCode, case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end CategoryCode2,a.goodscode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@ny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode    and a.GoodsType in (1,7)  
 and OccurDate between '+@qsrq+' and '+@jsrq+' 
 and LEFT(a.CategoryCode,2) not in (23)
 and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1), case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end,a.goodscode
  
  
 union all 
 select zb.DeptCode,left(c.CategoryCode,1)CategoryCode,
 case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(c.CategoryCode,2) end CategoryCode2,cb.goodscode 
,sum(SaleEarning)SaleIncome,sum(SaleEarning+SaleTax)SaleMoney ,0 SaleGrossProfit,0 TaxSaleGrossProfit
 from  [000]A.tb'+@ny+'_SaleBill  zb  ,[000]A.tb'+@ny+'_SALERENTDETAIL cb ,[000]A .tbGoods c 
 where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
  and EnterAccountDate between '+@qsrq+' and '+@jsrq+' 
 and cb.GoodsCode=c.GoodsCode  and   
 cb.goodscode not like ''0%'' 
 and   cb.goodscode not like ''6%''
 and LEFT(c.CategoryCode,2) not in (23)
 and  1=1 ${if(len(bm) == 0,   "",   "and zb.deptcode in (''" + replace(bm,",","'',''")+"'')") }
 group by zb.DeptCode,left(c.CategoryCode,1), case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(c.CategoryCode,2) end,cb.goodscode )a
left join 
 [000]A .tbDeptGoodsSupp b on a.nodecode =b.deptcode and a.goodscode =b.goodscode 
 and ContractNumber in (select MAX(ContractNumber) from [000]A .tbGoodsSupp c where b.GoodsCode=c.GoodsCode)
 group by  NodeCode ,CategoryCode,CategoryCode2,SupplierCode 
 'execute(@sql)
 
 

declare @sql varchar(8000), @ny varchar(6),@rq varchar(8),@qsrq varchar(8),@jsrq varchar(8),@qsny varchar(6)
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) 
set @jsrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112) 
set @ny=convert(varchar(6),dateadd(mm,0,@jsrq),112) 
set @qsny=convert(varchar(6),dateadd(mm,-1,@jsrq),112) 
set @sql='
 select NodeCode ,CategoryCode1,CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
  (select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@qsny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode  and a.GoodsType in (2,3,4,5,6) and OccurDate between '+@qsrq+' and '+@jsrq+' 
and LEFT(a.CategoryCode,2) not in (23) 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end
 union all 
  
  select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@ny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode  and a.GoodsType in (2,3,4,5,6)  and OccurDate between '+@qsrq+' and '+@jsrq+'
and LEFT(a.CategoryCode,2) not in (23) 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),case when 
 ( CategoryCode like ''281%'' or  CategoryCode like ''21%'' or  CategoryCode like ''288%'')  then ''21'' 
 when  
 (CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023) or 
 CategoryCode like ''280%'' or  CategoryCode like ''20%'' or  CategoryCode like ''287%'')  then ''20'' 
  when  
 (CategoryCode in (29003,29006) or 
 CategoryCode like ''282%'' or  CategoryCode like ''22%'' or  CategoryCode like ''289%'')  then ''22'' 
  else LEFT(CategoryCode,2) end

 
 )a
  group by NodeCode ,CategoryCode1,CategoryCode
 'execute(@sql)
 

 declare @sql varchar(8000), @ny varchar(6),@rq varchar(8),@qsrq varchar(8),@jsrq varchar(8),@qsny varchar(6)
set @qsrq=convert(varchar(8),dateadd(dd,0,'${qsrq}'),112) 
set @jsrq=convert(varchar(8),dateadd(dd,0,'${jsrq}'),112) 
set @ny=convert(varchar(6),dateadd(mm,0,@jsrq),112) 
set @qsny=convert(varchar(6),dateadd(mm,-1,@jsrq),112) 
set @sql='
 select NodeCode ,CategoryCode1,CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleMoney)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
  (select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,LEFT(a.CategoryCode,2)CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@qsny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode and a.GoodsBrand =''010001'' and a.GoodsType=''0'' and OccurDate between '+@qsrq+' and '+@jsrq+' 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),LEFT(a.CategoryCode,2)
 union all 
  
  select b.NodeCode ,LEFT(a.CategoryCode,1)CategoryCode1,LEFT(a.CategoryCode,2)CategoryCode
  ,SUM(SaleIncome)SaleIncome,SUM(SaleIncome+SaleTax)SaleMoney,SUM(SaleGrossProfit)SaleGrossProfit,SUM(TaxSaleGrossProfit)TaxSaleGrossProfit from 
 [000]A .tbGoods a ,
 [000]A .tb'+@ny+'_GoodsdayPSSM b 
 where a.GoodsCode =b.GoodsCode and a.GoodsBrand =''010001'' and a.GoodsType=''0''  and OccurDate between '+@qsrq+' and '+@jsrq+' 
   and  1=1 ${if(len(bm) == 0,   "",   "and nodecode in (''" + replace(bm,",","'',''")+"'')") }
 group by b.NodeCode ,left(a.CategoryCode,1),LEFT(a.CategoryCode,2))a
  group by NodeCode ,CategoryCode1,CategoryCode
 'execute(@sql)
 

select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工(黔惠)' else CategoryName+'(黔惠)' end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<3



select a.DeptCode,a.CategoryCode,sum(a.Salesindex) TaxSalesindex,sum(a.Grossprofitindex )TaxGrossprofitindex,sum(b.Salesindex)Salesindex,sum(b.Grossprofitindex)Grossprofitindex from 
    [含税分课预算表]A a 
    left join 
    [无税分课预算表]A  b on a.BudgetYM =b.BudgetYM and a.CategoryCode=b.CategoryCode and a.DeptCode=b.DeptCode and a.CategoryItemCode=b.CategoryItemCode
    where a.BudgetYM between left('${qsrq}',6) and left('${jsrq}',6) and 1=1 ${if(len(bm) == 0,   "",   "and a.DEPTCODE in ('" + replace(bm,",","','")+"')") } and a.CategoryItemCode='0001'
    group by a.DeptCode,a.CategoryCode

