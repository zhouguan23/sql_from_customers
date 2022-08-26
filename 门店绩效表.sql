select a.NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(a.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')  nodename ,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '新店' ELSE '老店' END SFXD,
b.CategoryName yddq,C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0013'
where  a.DeptCatItemCode ='0013')b on a.NodeCode=b.nodecode
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011')C on a.NodeCode=C.nodecode


declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='
 select nodecode,left(fl,1)fl1,fl,sum(SaleMoney)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost from 
 (select nodecode,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost   from 
(select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from [000]A .tb'+@qsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+'  and left(nodecode,1) between  1 and 2   and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}'' and exists (select * from [000]A.tbgoods b where b.goodsType=0 and a.goodscode=b.goodscode)
union all
select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost  from [000]A .tb'+@jsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+' and left(nodecode,1) between  1 and 2  and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}'' and exists (select * from [000]A.tbgoods b where b.goodsType=0 and a.goodscode=b.goodscode)
)a 

group by nodecode,left(goodscode,2)
union all 
 select case when nodecode=9011 then 1033 when nodecode=9020 then 1028 end nodecode,left(goodscode,2)fl,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost   from 
(select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from [000]A .tb'+@qsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+'  and (nodecode like ''9011'' or nodecode like ''9020'') and   goodscode  like ''3%'' and nodecode=case when ''${bm}''=1033 then 9011 when ''${bm}''=1028 then 9020 end and exists (select * from [000]A.tbgoods b where b.goodsType=0 and a.goodscode=b.goodscode)
union all
select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost  from [000]A .tb'+@jsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+' and (nodecode like ''9011'' or nodecode like ''9020'') and   goodscode  like ''3%''  and nodecode=case when''${bm}''=1033 then 9011 when ''${bm}''=1028 then 9020 end and exists (select * from [000]A.tbgoods b where b.goodsType=0 and a.goodscode=b.goodscode)
)a 

group by nodecode,left(goodscode,2))a

group by nodecode,left(fl,1),fl



order by nodecode,fl
 
 
'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='

select  left(a.goodscode,1)处别分类,case when left(a.GoodsCode,2)=29 then 20 else left(a.GoodsCode,2) end  as 分类编码,''联营'' 类型,b.SupplierCode ,b.SupplierName,round(SUM(SaleIncome+SaleTax),2)销售金额,
round(SUM(SaleIncome+SaleTax),2)-round(SUM(SaleGrossProfit),2) as 结款金额,round(SUM(SaleGrossProfit),2)销售毛利,
round((case when SUM(SaleGrossProfit)=0 then 0 when SUM(SaleIncome)=0 then 0 else  SUM(SaleGrossProfit)/SUM(SaleIncome) end ),4)毛利率 from 
(select a.goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit  from 
(select * from "000".tb'+@qsny+'_GOODSDAYPSSM where occurdate between   '+@qsrq+' and '+@dqrq+' and NodeCode=''${bm}''
Union All
select * from "000".tb'+@jsny+'_GOODSDAYPSSM  where occurdate between   '+@qsrq+' and '+@dqrq+' and NodeCode=''${bm}'') a ,
"000".TBGOODS b 
where a.goodscode=b.goodscode and b.goodstype=1  )a
left join 
(select distinct a.SupplierCode ,b.SupplierName ,GoodsCode from "000" .tbDeptGoodsSupp a ,"000".TBSUPPLIER b where a.SupplierCode=b.SupplierCode and a.DeptCode=''${bm}'')b  
on  a.GoodsCode=b.goodscode
group by left(a.GoodsCode,1),left(a.GoodsCode,2),b.SupplierCode ,b.SupplierName

union  all

select  left(goodscode,1)处别分类,case when left(GoodsCode,2)=29 then 20 else left(GoodsCode,2) end as 分类编码,''租赁'' 类型,a.SupplierCode,c.SupplierName, round(SUM(SaleEarning +SaleTax),2)as 销售金额,round(sum(SaleEarning +SaleTax),2)结款金额,''0'' as 销售毛利,''0'' as 毛利率 
from 
(select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5,6) and zb.DeptCode=''${bm}'' and EnterAccountDate between '+@qsrq+' and '+@dqrq+'
Union All
select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (1,2,3,4,5,6) and zb.DeptCode=''${bm}'' and EnterAccountDate between  '+@qsrq+' and '+@dqrq+' )a
left join "000".tbSupplier c on a.SupplierCode =c.SupplierCode 
group by left(goodscode,1),left(goodscode,2),a.SupplierCode,c.SupplierName

order by 1,2,3,4

 
'exec (@sql1)





declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='

select left(a.goodscode,1)fl,case when left(a.GoodsCode,5) in (29000,29001,29005,29011) then 20  when left(a.GoodsCode,5) in (29003,29006) then 21 else   left(a.GoodsCode,2) end  as 分类编码,round(SUM(SaleIncome),2)销售收入,round(SUM(SaleCost),2)销售成本,round(SUM(SaleIncome+SaleTax),2)销售金额,round(SUM(SaleGrossProfit),2)销售毛利,round(SUM(TaxSaleGrossProfit),2)含税毛利,
round((case when SUM(TaxSaleGrossProfit)=0 then 0 when SUM((SaleIncome+SaleTax))=0 then 0 else  SUM(TaxSaleGrossProfit)/SUM((SaleIncome+SaleTax)) end ),4)毛利率  from 
(select * from "000".tb'+@qsny+'_GOODSDAYPSSM where occurdate between  '+@qsrq+' and '+@dqrq+' and NodeCode=''${bm}''
Union All
select * from "000".tb'+@jsny+'_GOODSDAYPSSM  where occurdate between  '+@qsrq+' and '+@dqrq+' and NodeCode=''${bm}'') a ,
"000".TBGOODS b 
where a.goodscode=b.goodscode and b.goodstype in (2,3,4,5,6)

group by left(a.goodscode,1),case when left(a.GoodsCode,5) in (29000,29001,29005,29011) then 20  when left(a.GoodsCode,5) in (29003,29006) then 21 else   left(a.GoodsCode,2) end
 order by 1,2
'exec (@sql1)




declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='

select left(a.goodscode,1)fl,case when left(a.GoodsCode,5) in (29000,29001,29005,29011) then 20  when left(a.GoodsCode,5) in (29003,29006) then 21 else   left(a.GoodsCode,2) end  as 分类编码,round(SUM(SaleIncome),2)销售收入,round(SUM(SaleCost),2)销售成本,round(SUM(SaleIncome+SaleTax),2)销售金额,round(SUM(SaleGrossProfit),2)销售毛利,round(SUM(TaxSaleGrossProfit),2)含税毛利,
round((case when SUM(TaxSaleGrossProfit)=0 then 0 when SUM((SaleIncome+SaleTax))=0 then 0 else  SUM(TaxSaleGrossProfit)/SUM((SaleIncome+SaleTax)) end ),4)毛利率  from 
(select * from "000".tb'+@qsny+'_GOODSDAYPSSM where occurdate between  '+@qsrq+' and '+@dqrq+'  and NodeCode=''${bm}''
Union All
select * from "000".tb'+@jsny+'_GOODSDAYPSSM where occurdate between  '+@qsrq+' and '+@dqrq+'  and NodeCode=''${bm}'') a ,
"000".TBGOODS b 
where a.goodscode=b.goodscode and b.goodstype in (2,3,4,5,6) and b.SaleTaxRate=0
group by left(a.goodscode,1),case when left(a.GoodsCode,5) in (29000,29001,29005,29011) then 20  when left(a.GoodsCode,5) in (29003,29006) then 21 else   left(a.GoodsCode,2) end
 order by 1
'exec (@sql1)






select DeptCode,CategoryCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex
 from WHLessonBudget a 
 
 where BudgetYM = convert(varchar(6),dateadd(dd,0,'${jsrq}'),112)
 and deptcode='${bm}'
 group by deptcode,CategoryCode




declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='


select nodecode,case when left(goodscode,2)=29then 20 else left(goodscode,2) end fl,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost into #mlsj  from 
(select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from [000]A .tb'+@qsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+'  and left(nodecode,1) between  1 and 2   and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}'' 
union all
select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost  from [000]A .tb'+@jsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+' and left(nodecode,1) between  1 and 2  and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}'' 
)a 

group by nodecode,left(goodscode,2)

 union all 
 select case when nodecode=9011 then 1033 when nodecode=9020 then 1028 end nodecode,left(goodscode,2)fl,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost   from 
(select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from [000]A .tb'+@qsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+'  and (nodecode like ''9011'' or nodecode like ''9020'') and   goodscode  like ''3%'' and nodecode=case when ''${bm}''=1033 then 9011 when ''${bm}''=1028 then 9020 end
union all
select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost  from [000]A .tb'+@jsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+' and (nodecode like ''9011'' or nodecode like ''9020'') and   goodscode  like ''3%''  and nodecode=case when''${bm}''=1033 then 9011 when ''${bm}''=1028 then 9020  end 
)a 

group by nodecode,left(goodscode,2)


union all 
select  DeptCode nodecode,case when left(goodscode,2)=29then 20 else left(goodscode,2) end  fl,SUM(SaleEarning +SaleTax)as SaleMoney,SUM(SaleEarning)SaleIncome,0 SaleGrossProfit,0 TaxSaleGrossProfit,0 TaxSaleCost
from 
(select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@qsny+'_SaleBill  zb  ,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 
and   LEFT(goodscode,1) in (1,2,3,4,5,6) and zb.DeptCode=''${bm}'' and EnterAccountDate between '+@qsrq+' and '+@dqrq+' 
Union All
select EnterAccountDate,SupplierCode,zb.DeptCode,goodscode,SaleEarning,SaleTax 
from  "000".tb'+@jsny+'_SaleBill  zb  ,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where  zb.DeptCode = cb.DeptCode  And zb.BillNumber = cb.BillNumber and zb.IsOutRule=0 and   LEFT(goodscode,1) in (1,2,3,4,5,6) and zb.DeptCode=''${bm}'' and EnterAccountDate between '+@qsrq+' and '+@dqrq+' )a

group by DeptCode,case when left(goodscode,2)=29then 20 else left(goodscode,2) end 

select NodeCode into #yt from 
(select a.NodeCode,
b.CategoryName yddq,C.CategoryName jyyt  from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0013''
where  a.DeptCatItemCode =''0013'')b on a.NodeCode=b.nodecode
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode=''0011''
where  a.DeptCatItemCode =''0011'')C on a.NodeCode=C.nodecode)a
where jyyt =''大社区店''

select  ParentCategoryCode,case when CategoryCode=14 and nodecode in (select nodecode from #yt ) then 2 else lbh end lbh,CategoryCode,nodecode,fl1,lx,fl,SaleIncome,SaleMoney,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from 
(select ParentCategoryCode,lbh,CategoryCode,nodecode,left(fl,1)fl1,case when left(fl,1) in (3,4,5) then ''常规''  when left(fl,1) in (1,2) then ''生鲜/加工'' end lx,fl,sum(SaleIncome)SaleIncome,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost from 
(select ParentCategoryCode,case 
when CategoryCode in (10,11) then 2
when CategoryCode in (12,13) then 1
when CategoryCode in (14)  then 3
when CategoryCode in (30,31,32) then 4
when CategoryCode in (33,34) then 5
when CategoryCode in (40,41,42,43,44,45,48,49) then 6
when CategoryCode in (46,47) then 7
else 0 
 end lbh, CategoryCode  from [000]A.TBGOODSCATEGORY  
where CategoryItemCode=0000 and left(CategoryCode,1) between 1 and 5  and CategoryLevel = 2 and CategoryCode not in (19,23,28,29,52))A 
 LEFT JOIN 
 #mlsj B ON A.CategoryCode=B.fl

group by   ParentCategoryCode,lbh,CategoryCode,nodecode,left(fl,1),fl)a



order by 1,2,3
 
'exec (@sql1)





select 2 bh,'生食小计' mc,'10\11' bm
union all 
select 1 bh,'蔬果小计' mc,'12\13' bm
union all 
select 4 bh,'烟酒/休闲/冲饮' mc,'30\31\32' bm
union all 
select 5 bh,'副食/粮油/冷冻' mc,'33\34' bm
union all 
select 6 bh,'家居/家电' mc,'40\41\41\43\44\45\48\49' bm
union all 
select 7 bh,'家纺' mc,'46\47' bm



declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='


select nodecode,case when left(goodscode,2)=29 then 20  when left(goodscode,2)=14 then 33 else left(goodscode,2) end fl,sum(SaleIncome+SaleTax)SaleMoney,sum(SaleIncome)SaleIncome,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost into #mlsj  from 
(select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost from [000]A .tb'+@qsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+'  and left(nodecode,1) between  1 and 2   and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}''  and GoodsCode in (select distinct  goodscode from "000" .TBSUPPLIER a,"000" .TBDEPTGOODSSUPP b  where b.SupplierCode=a.SupplierCode and SupplierSymbol=''自有品牌'' and DeptCode=''${bm}'')
union all
select occurdate,nodecode,goodscode,SaleIncome,SaleTax,SaleGrossProfit,TaxSaleGrossProfit,TaxSaleCost  from [000]A .tb'+@jsny+'_goodsdaypssm a where OccurDate between '+@qsrq+'  and '+@dqrq+' and left(nodecode,1) between  1 and 2  and goodscode  not like ''0%'' and goodscode  not like ''6%'' and nodecode=''${bm}'' and GoodsCode in (select distinct  goodscode from "000" .TBSUPPLIER a,"000" .TBDEPTGOODSSUPP b  where b.SupplierCode=a.SupplierCode and SupplierSymbol=''自有品牌'' and DeptCode=''${bm}'')
)a 

group by nodecode,left(goodscode,2)




select * from 
(select ParentCategoryCode,lbh,CategoryCode,nodecode,left(fl,1)fl1,fl,sum(SaleIncome)SaleIncome,sum(SaleMoney)SaleMoney,sum(SaleGrossProfit)SaleGrossProfit,sum(TaxSaleGrossProfit)TaxSaleGrossProfit,sum(TaxSaleCost)TaxSaleCost from 
(select ParentCategoryCode,case 
when CategoryCode in (10,11) then 2
when CategoryCode in (12,13) then 1
when CategoryCode in (14) then 3
when CategoryCode in (30,31,32) then 4
when CategoryCode in (33,34) then 5
when CategoryCode in (40,41,42,43,44,45,48,49) then 6
when CategoryCode in (46,47) then 7
else 0 
 end lbh, CategoryCode  from [000]A.TBGOODSCATEGORY  
where CategoryItemCode=0000 and left(CategoryCode,1) between 1 and 5  and CategoryLevel = 2 and CategoryCode not in (19,29))A 
 LEFT JOIN 
 #mlsj B ON A.CategoryCode=B.fl

group by   ParentCategoryCode,lbh,CategoryCode,nodecode,left(fl,1),fl)a
where nodecode is not null 



order by 1,2,3
 
'exec (@sql1)





select a.NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(a.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')  nodename ,a.OpenDate,
case when convert(varchar(8),dateadd(YY,1,a.OpenDate),112)>convert(varchar(8),dateadd(YY,0,GETDATE()),112) then '新店' ELSE '老店' END SFXD,
b.CategoryName yddq,C.CategoryName jyyt from 
(select a.NodeCode,b.NodeName,a.OpenDate   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0 and a.OpenDate<=convert(varchar(8),dateadd(mm,0,GETDATE()),112))a
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0013'
where  a.DeptCatItemCode ='0013')b on a.NodeCode=b.nodecode
left join
(select b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011')C on a.NodeCode=C.nodecode
where 1=1 ${if(len(bm) == 0,"","and a.nodecode in (" + bm + ")")} 

declare @sql1 varchar(8000),@dqrq varchar(8),
@jsny varchar(6), @qsny varchar(6), @qsrq varchar(8)

set @dqrq= convert(varchar(8),dateadd(dd,0,'${jsrq}'),112)
set @jsny= @dqrq
set @qsrq= convert(varchar(8),dateadd(dd,0,'${qsrq}'),112)
set @qsny= convert(varchar(6),dateadd(mm,-1,@dqrq),112) 

set @sql1='


 select a.deptcode,a.GoodsCode ,sum(a.dkje)xsje into #mx from 
(select a.BillNumber,a.DeptCode,b.GoodsCode,c.xsje ,a.xsje*(b.xsje/c.xsje)dkje  from
(select a.BillNumber,a.DeptCode,SUM(xsje)xsje from 
(select cb.BillNumber,zb.DeptCode,SUM(PaymentMoney)xsje from 
"000".tb'+@qsny+'_SALEBILL zb,"000".tb'+@qsny+'_SALEPAYMENTDETAIL cb 
where PaymentModeCode in (''0007'' , ''0013'') and zb.BillNumber=cb.BillNumber and EnterAccountDate between '+@qsrq+'  and '+@dqrq+' and zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  
group by cb.BillNumber,zb.DeptCode
Union All
select cb.BillNumber,zb.DeptCode,SUM(PaymentMoney)xsje from 
"000".tb'+@jsny+'_SALEBILL zb,"000".tb'+@jsny+'_SALEPAYMENTDETAIL cb 
where PaymentModeCode in (''0007'' , ''0013'') and zb.BillNumber=cb.BillNumber and EnterAccountDate between '+@qsrq+'  and '+@dqrq+' and zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  
group by cb.BillNumber,zb.DeptCode)a
group by a.BillNumber,a.DeptCode)a

left join 
(select a.BillNumber,a.DeptCode,a.GoodsCode ,SUM(xsje)xsje from 
(select cb.BillNumber,zb.DeptCode,cb.goodscode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@qsny+'_SALEBILL zb,"000".tb'+@qsny+'_SALEBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode,cb.goodscode
union all 
select cb.BillNumber,zb.DeptCode,cb.goodscode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@qsny+'_SALEBILL zb,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode,cb.goodscode
Union All
select cb.BillNumber,zb.DeptCode,cb.goodscode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@jsny+'_SALEBILL zb,"000".tb'+@jsny+'_SALEBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode,cb.goodscode
union all 
select cb.BillNumber,zb.DeptCode,cb.goodscode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@jsny+'_SALEBILL zb,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode,cb.goodscode)a
group by BillNumber ,DeptCode,a.GoodsCode)b on a.BillNumber=b.BillNumber and a.DeptCode=b.DeptCode
left join 
(select a.BillNumber,a.DeptCode,SUM(xsje)xsje from 
(select cb.BillNumber,zb.DeptCode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@qsny+'_SALEBILL zb,"000".tb'+@qsny+'_SALEBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode 
union all 
select cb.BillNumber,zb.DeptCode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@qsny+'_SALEBILL zb,"000".tb'+@qsny+'_SALERENTDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode
Union All
select cb.BillNumber,zb.DeptCode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@jsny+'_SALEBILL zb,"000".tb'+@jsny+'_SALEBILLDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode 
union all 
select cb.BillNumber,zb.DeptCode,SUM(SaleEarning+SaleTax+AutoRebate+HandRebate)xsje from 
"000".tb'+@jsny+'_SALEBILL zb,"000".tb'+@jsny+'_SALERENTDETAIL cb 
where zb.BillNumber=cb.BillNumber and zb.DeptCode=cb.DeptCode  and EnterAccountDate between '+@qsrq+'  and '+@dqrq+'   and IsOutRule<>1
group by cb.BillNumber,zb.DeptCode)a
group by BillNumber ,DeptCode)c on a.BillNumber=c.BillNumber and a.DeptCode=c.DeptCode)a
group by DeptCode ,a.GoodsCode 

select a.deptcode,case when a.flbm=29 then 20 else a.flbm end as CategoryCode,b.Categoryname,a.xsje from
(select deptcode,left(goodscode,2)flbm,sum(xsje)xsje from #mx where deptcode in (select NodeCode  from "000".TBCATTODEPARTMENT b where DeptCatItemCode  =''0000'' and DeptCategoryCode in (01,02)) and deptcode not in (6666,8888) and (Left(deptcode,4)=''${bm}'') and(1=1) group by  deptcode,left(goodscode,2))a
left join 
"000" .TBGOODSCATEGORY b on a.flbm=b.CategoryCode and CategoryLevel=2 and CategoryItemCode=''0000''




order by 1,2,3
 
'exec (@sql1)





