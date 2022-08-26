select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.SubID 子档号,b.PromotionPeriodName+''+cast(b.SubID as varchar(255) ) 档期名称,b.BeginDate+'-'+b.EndDate 档期日期 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
left join 
[000]A .TBPERIODCGOODSBILL c on a.PromotionThemeCode=c.PromotionThemeCode and b.PromotionPeriodCode=c.PromotionPeriodCode and b.SubID = c.SubID 
where  c.State =1 



select distinct
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName 档期名称 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
left join 
[000]A .TBPERIODCGOODSBILL c on a.PromotionThemeCode=c.PromotionThemeCode and b.PromotionPeriodCode=c.PromotionPeriodCode and b.SubID = c.SubID 
where a.PromotionThemeCode = '${促销种类}' and c.State =1 

select b.SubID 子档号,left(b.BeginDate,4)+'-'+right(left(b.BeginDate,6),2)+'-'+RIGHT(b.BeginDate,2)BeginDate,b.EndDate,b.BeginDate+'-'+b.EndDate 档期日期 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
left join 
[000]A .TBPERIODCGOODSBILL c on a.PromotionThemeCode=c.PromotionThemeCode and b.PromotionPeriodCode=c.PromotionPeriodCode and b.SubID = c.SubID 
where  1=1 ${if(len(促销种类) == 0,   "",   "and a.PromotionThemeCode in ('" + replace(促销种类,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and b.PromotionPeriodCode in ('" + replace(档期,",","','")+"')") }
and c.State =1 

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@dqrq varchar(8),@dqny varchar(6)
set @dqrq=(select max(EndDate)  from [000]A .tbPromotionPeriod where 
1=1 ${if(len(促销种类) == 0,   "",   "and PromotionThemeCode in ('" + replace(促销种类,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and PromotionPeriodCode in ('" + replace(档期,",","','")+"')") }
and 1=1 ${if(len(波段) == 0,   "",   "and SubID in ('" + replace(波段,",","','")+"')") })
set @jsny=@dqrq
set @qsrq=(select min(BeginDate)  from [000]A .tbPromotionPeriod where 
1=1 ${if(len(促销种类) == 0,   "",   "and PromotionThemeCode in ('" + replace(促销种类,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and PromotionPeriodCode in ('" + replace(档期,",","','")+"')") }
and 1=1 ${if(len(波段) == 0,   "",   "and SubID in ('" + replace(波段,",","','")+"')") })
set @qsny=@qsrq
set @dqny=convert(varchar(8),dateadd(dd,0,GETDATE()),112)
SET @SQL=''
SELECT @SQL=@SQL+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where  AccDate between  '+@qsrq+' and '+@dqrq+''
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_PromSaleProjectList' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL=STUFF(@SQL,1,11,'')


SET @SQL1='


select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.SubID 子档号,b.PromotionPeriodName 档期名称,b.BeginDate 档期起始日期,b.EndDate 档期结束日期,
c.BillNumber 选品单号,c.BuildManCode 选品人,c.AuditManCode 审核人
,e.DeptCode 部门编码,k.SupplierCode 供应商,left(f.CategoryCode,2) 分类编码,d.GoodsCode 商品编码,f.GoodsName 商品名称,f.GoodsSpec 商品规格,f.BaseMeasureUnit 单位,i.WorkStateCode 经营状态,j.CirculationModeCode 流转途径
,d.PurchaseBeginDate+''-''+d.PurchaseEndDate 采购日期
,d.PromBeginDate+''-''+d.PromEndDate 促销日期
,g.PurchPreSaleAmount 采购预估数量,g.PurchPreMoney  采购预估金额,g.StorePreSaleAmount  门店预估销量,g.StorePreMoney 门店预估金额,l.ChangePriceCode 变价种类,d.ChangeCauseCode 变价原因,d.PromType 促销类型,d.EqualizeMode 补偿方式
,e.PurchPrice 供价,e.SpecialPrice 特供价,case when len(h.SalePrice)=0 then h.SalePrice else f.SalePrice end   销售单价,CASE WHEN e.PriceMode=1 then  (e.PromPrice/100)*case when len(h.SalePrice)=0 then h.SalePrice else f.SalePrice end   else e.PromPrice end 促销价
,h.CommonDMS 正常日均销量,h.PromotionDMS 促销日均销量,isnull(h.WayAmount,0)在途数量,isnull(StockAmount,0) 库存数量,isnull(PurchStockMoney,0) 库存金额
,convert(varchar(10),dateadd(dd,number,convert(varchar(8),d.PromBeginDate,112)),112)促销期
,sum(isnull(o.SaleAmount,0))SaleAmount ,sum(isnull(o.SaleInCome,0)+isnull(o.SaleTax,0))  SaleMoney
 from 
[000]A.TBPROMOTIONTHEME a --促销主题
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode --促销档期
left join 
[000]A .TBPERIODCGOODSBILL c on a.PromotionThemeCode=c.PromotionThemeCode and b.PromotionPeriodCode=c.PromotionPeriodCode and b.SubID=c.SubID 
left join 
[000]A .TBPERIODCGOODSDETAILS d on c.DeptCode=d.DeptCode AND c.BillNumber =d.BillNumber 
left join 
[000]A .TBPERIODCGOODSTODEPTDETAILS e on  c.DeptCode =e.BuildDeptCode AND c.BillNumber =e.BillNumber AND d.InsideID=e.GoodsInsideID and e.DeptType=1
LEFT join 
[000]A .tbGoods f on d.GoodsCode =f.GoodsCode 
left join 
[000]A .TBPERIODPRESALEAMOUNT g on  e.DeptCode =g.DeptCode and a.PromotionThemeCode=g.PromotionThemeCode and b.PromotionPeriodCode=g.PromotionPeriodCode and b.SubID=g.SubID and d.GoodsCode =g.GoodsCode 
left join 
[000]A .tb'+@dqny+'_Reportinfo h on e.DeptCode =h.DepartmentCode and d.GoodsCode =h.GoodsCode and h.ReportDate in (select MAX(ReportDate) from [000]A .tb'+@dqny+'_Reportinfo w where h.DepartmentCode =w.DepartmentCode and h.GoodsCode =w.GoodsCode and w.ReportDate <=convert(varchar(8),dateadd(dd,0,GETDATE()),112))
left join 
[000]A .tbDeptWorkState i on e.DeptCode =i.DeptCode and d.GoodsCode =i.GoodsCode 
left join 
[000]A .TBDEPTCIRCULATION j on e.DeptCode =j.DeptCode and d.GoodsCode =j.GoodsCode 
left join 
[000]A .TBDEPTGOODSSUPP  k on e.DeptCode =k.DeptCode and d.GoodsCode =k.GoodsCode 
left join 
[000]A .TBCHANGEPRICECAUSE  l on d.ChangeCauseCode =l.ChangeCauseCode 
left join 
master..spt_values n on type=''p'' and number<= datediff(dd,convert(varchar(8),d.PromBeginDate,112),convert(varchar(8),d.PromEndDate,112))
left join 
('+@SQL+')  o on e.DeptCode = o.DeptCode  and d.GoodsCode=o.GoodsCode and convert(varchar(10),dateadd(dd,number,convert(varchar(8),b.BeginDate,112)),112)=o.AccDate
where c.State =1 

and 1=1 ${if(len(促销种类) == 0,   "",   "and a.PromotionThemeCode in (''" + replace(促销种类,",","'',''")+"'')") }
and 1=1 ${if(len(档期) == 0,   "",   "and b.PromotionPeriodCode in (''" + replace(档期,",","'',''")+"'')") }
and 1=1 ${if(len(波段) == 0,   "",   "and b.SubID in (''" + replace(波段,",","'',''")+"'')") }
and 1=1 ${if(len(变价原因) == 0,   "",   "and d.ChangeCauseCode in (''" + replace(变价原因,",","'',''")+"'')") }
and 1=1 ${if(len(变价原因2) == 0,   "",   "and d.ChangeCauseCode in (''" + replace(变价原因2,",","'',''")+"'')") }
and 1=1 ${if(len(分类编码) == 0,   "",   "and left(f.CategoryCode,2) in (''" + replace(分类编码,",","'',''")+"'')") }
and 1=1 ${if(len(部门编码) == 0,   "",   "and e.DeptCode in (''" + replace(部门编码,",","'',''")+"'')") }
and 1=1 ${if(len(供应商) == 0,   "",   "and k.SupplierCode in (''" + replace(供应商,",","'',''")+"'')") }

group by a.PromotionThemeCode ,a.PromotionThemeName ,
b.PromotionPeriodCode ,b.SubID ,b.PromotionPeriodName ,b.BeginDate ,b.EndDate ,
c.BillNumber ,c.BuildManCode ,c.AuditManCode 
,e.DeptCode,k.SupplierCode ,left(f.CategoryCode,2) ,d.GoodsCode ,f.GoodsName ,f.GoodsSpec ,f.BaseMeasureUnit ,i.WorkStateCode ,j.CirculationModeCode
,d.PurchaseBeginDate+''-''+d.PurchaseEndDate 
,d.PromBeginDate+''-''+d.PromEndDate 
,g.PurchPreSaleAmount ,g.PurchPreMoney  ,g.StorePreSaleAmount  ,g.StorePreMoney ,l.ChangePriceCode ,d.ChangeCauseCode ,d.PromType ,d.EqualizeMode 
,e.PurchPrice ,e.SpecialPrice ,case when len(h.SalePrice)=0 then h.SalePrice else f.SalePrice end 
,CASE WHEN e.PriceMode=1 then  (e.PromPrice/100)*case when len(h.SalePrice)=0 then h.SalePrice else f.SalePrice end   else e.PromPrice end 
,h.CommonDMS ,h.PromotionDMS ,isnull(h.WayAmount,0),isnull(StockAmount,0) ,isnull(PurchStockMoney,0) 
,convert(varchar(10),dateadd(dd,number,convert(varchar(8),d.PromBeginDate,112)),112)
order by 12,11,13,38

'exec(@sql1)

select ChangePriceCode,ChangeCauseCode,ChangeCauseCode+' '+ChangeCauseName ChangeCauseName,OrderAttribution from 
[000]A .TBCHANGEPRICECAUSE 
where ChangePriceCode in ('1','2') and ChangeCauseCode not in (19,20)


