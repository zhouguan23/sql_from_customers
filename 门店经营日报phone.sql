select AreaCode,NodeCode ,a.ParentCategoryCode,a.bm CategoryCode,a.defday,
sum(round(case when isnull(b.Salesindex,0)*isnull(d.xszb,0)<>0 then isnull(b.Salesindex,0)*isnull(d.xszb,0) else isnull(c.Salesindex,0)*isnull(d.xszb,0) end ,2)) Salesindex,
sum(round(case when isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0)<>0 then  isnull(b.Grossprofitindex,0)*isnull(d.mlzb,0) else isnull(c.Grossprofitindex,0)*isnull(d.mlzb,0) end,2)) Grossprofitindex
 from 
(select  AreaCode,NodeCode ,c.ParentCategoryCode,c.CategoryCode,c.bm,convert(varchar(10),dateadd(dd,number,convert(varchar(8),dateadd(dd,-day('${rq}')+1,'${rq}'),112)),112)defday
from master..spt_values a ,TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
tb分类对照表 a
left join 
tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
left join 
tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%' and a.CategoryCode not like '7%' and c.CategoryCode not in (28,29))  c
where type='p' and number <= datediff(dd,dateadd(dd,-day('${rq}')+1,'${rq}')   ,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${rq}')+1, 0)))
and (NodeCode  LIKE '1%' OR NodeCode  LIKE '2%')
and left(c.CategoryCode,1) between 1 and 5
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }

)a
left join 
每日预算表 b on a.defday=b.defday and a.NodeCode=b.DeptCode
left join 
(select DeptCode,sum(Salesindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${rq}')+1, 0)))Salesindex,sum(Grossprofitindex)/DAY(dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${rq}')+1, 0)))Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${rq}'),112) and convert(varchar(6),dateadd(dd,0,'${rq}'),112)
group by DeptCode)c on a.NodeCode=c.DeptCode 
left join 
(select a.DeptCode,a.CategoryCode,case when a.Salesindex=0 then 0 else a.Salesindex/b.Salesindex end xszb,
case when a.Grossprofitindex=0 then 0 else  a.Grossprofitindex/b.Grossprofitindex end mlzb  from 
(select DeptCode,CategoryCode,Salesindex,Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%')  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${rq}'),112) and convert(varchar(6),dateadd(dd,0,'${rq}'),112))a,
(select DeptCode,sum(Salesindex)Salesindex,sum(Grossprofitindex)Grossprofitindex from 
含税分课预算表
where(DeptCode   LIKE '1%' OR DeptCode   LIKE '2%' OR DeptCode   LIKE '9%' )  and CategoryItemCode='0000'
and BudgetYM  between convert(varchar(6),dateadd(dd,0,'${rq}'),112) and convert(varchar(6),dateadd(dd,0,'${rq}'),112)
group by DeptCode)b
where a.DeptCode=b.DeptCode)d on a.NodeCode=d.DeptCode and a.bm=d.CategoryCode 

group by AreaCode,NodeCode ,a.ParentCategoryCode,a.CategoryCode,a.bm,a.defday


 select a.ParentCategoryCode,a.CategoryCode,a.SaleCount,
 isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
 isnull(C.SaleMoney,0)Cx_SaleMoney,ISNULL(d.StartCost,0)+ISNULL(e.Cost,0)EndCost from 
 (select left(c.CategoryCode,1)ParentCategoryCode,case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,
 count(distinct case when c.CategoryCode ='41100' then null else a.BillNumber end)SaleCount from 
"${bm}" .tb${YM}_SALEBILL a ,
(select a.DeptCode,a.BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,case when IsBinding=1 then scbb.AutoRebate else a.AutoRebate end AutoRebate,case when IsBinding=1 then scbb.HandRebate else a.HandRebate end HandRebate,0 SaleGrossProfit,0 TAXSaleGrossProfit from "${bm}" .tb${YM}_SALEBILLDETAIL a left Join (select cbb.DeptCode,cbb.BillNumber,cbb.MasterID,sum(cbb.AutoRebate) AutoRebate,sum(cbb.HandRebate) HandRebate  from "${bm}" .tb${YM}_SALEBANDDETAIL cbb with(nolock)  group by cbb.DeptCode,cbb.BillNumber,cbb.MasterID  ) scbb on scbb.DeptCode=a.DeptCode and scbb.BillNumber=a.BillNumber  and scbb.MasterID=a.InnerId  
where CancelFlag ='0'
union all 
select DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,AutoRebate,HandRebate,(SaleEarning) SaleGrossProfit ,(SaleEarning+SaleTax) TAXSaleGrossProfit from "${bm}" .tb${YM}_SALERENTDETAIL
where CancelFlag ='0')b ,
"${bm}" .tbGoods c 
where  A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode   and b.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6
and  IsOutRule=0 and EnterAccountDate='${rq}'
and  not exists(select *  from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and  a.DeptCode=z.nodecode and b.GoodsCode=z.goodscode)
group by left(c.CategoryCode,1),case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end)a
left join 
(select case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
"${bm}" .tb${YM}_GoodsDayPssm a ,
"${bm}" .tbGoods c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Occurdate='${rq}'
and  not exists(select *  from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

)b on a.CategoryCode=b.CategoryCode

left join 
(select case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney from 
"${bm}" .tb${YM}_PromSaleProjectList a ,
"${bm}" .tbGoods c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Accdate='${rq}'
and  not exists(select *  from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and a.GoodsCode=z.goodscode)
group by case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

)c on a.CategoryCode=c.CategoryCode

left join 
(select case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum(a.StartCost+a.StartTax)StartCost from 
"${bm}" .tb${YM}_GoodsMonPssm a 
,
"${bm}" .tbGoods c  
where a.goodscode=c.goodscode AND left(c.CategoryCode,1) between 1 and 6 
and  not exists(select *  from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

)d on a.CategoryCode=d.CategoryCode
left join 
(select case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum( a.PURCHCOST+a.PurchTax --进货
+ a.REDEPLOYINCOST+a.RedeployinTax --拨入
+ a.PROFITCOST+a.ProfitTax --升溢
+ a.COUNTPROFITCOST+a.CountProfitTax --盘升
- a.TaxSaleCost  --销售
- a.REDEPLOYOUTCOST-a.RedeployoutTax --拨出
- a.LOSSCOST-a.LossTax --损耗
- a.COUNTLOSSCOST-a.CountLossTax --盘耗
- a.ToGiftCost-a.ToGiftTax)Cost from 
"${bm}" .tb${YM}_GoodsDayPssm a 
,
"${bm}" .tbGoods c  
where a.goodscode=c.goodscode AND left(c.CategoryCode,1) between 1 and 6 
and  not exists(select *  from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

)e on a.CategoryCode=e.CategoryCode

select 
 count(distinct case when c.CategoryCode ='41100' then null else a.BillNumber end)SaleCount,
 sum(SaleEarning+SaleTax)SeleMoney from 
"${bm}" .tb${YM}_SALEBILL a ,
(select a.DeptCode,a.BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,case when IsBinding=1 then scbb.AutoRebate else a.AutoRebate end AutoRebate,case when IsBinding=1 then scbb.HandRebate else a.HandRebate end HandRebate,0 SaleGrossProfit,0 TAXSaleGrossProfit from "${bm}" .tb${YM}_SALEBILLDETAIL a left Join (select cbb.DeptCode,cbb.BillNumber,cbb.MasterID,sum(cbb.AutoRebate) AutoRebate,sum(cbb.HandRebate) HandRebate  from "${bm}" .tb${YM}_SALEBANDDETAIL cbb with(nolock)  group by cbb.DeptCode,cbb.BillNumber,cbb.MasterID  ) scbb on scbb.DeptCode=a.DeptCode and scbb.BillNumber=a.BillNumber  and scbb.MasterID=a.InnerId  
where CancelFlag ='0'
union all 
select DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,AutoRebate,HandRebate,(SaleEarning) SaleGrossProfit ,(SaleEarning+SaleTax) TAXSaleGrossProfit from "${bm}" .tb${YM}_SALERENTDETAIL
where CancelFlag ='0')b ,
"${bm}" .tbGoods c 
where  A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode   and b.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6
and  IsOutRule=0 and EnterAccountDate='${rq}'
and  not exists(select * from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and b.GoodsCode=z.goodscode)


select * from 
	dbo.日期对照表
	where OccurDate =convert(varchar(8),dateadd(dd,0,'${rq}'),112)

select 
NodeCode,NodeName
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName,isnull(d.CarryState,0)CarryState
 from 
dbo.TB部门信息表 a
left join 
TBDAYCARRYLOG d on a.NodeCode=d.deptcode and d.CarryDate=convert(varchar(8),dateadd(dd,0,'${rq}'),112)

where  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}

SELECT isnull(CarryState,0)CarryState
FROM "${bm}" .TBCHAINCONTROL
unpivot(CarryState FOR scoure in(Date2,Date1,Date3,Date4,Date5,Date6,Date7,Date8,Date9,Date10,Date11,Date12,Date13,Date14,Date15,Date16,Date17,Date18,Date19,Date20,Date21,Date22,Date23,Date24,Date25,Date26,Date27,Date28,Date29,Date30,Date31
))AS up
where ChainControlYM+right('00'+REPLACE(scoure,'Date',''),2)='${rq}' 

select left(c.CategoryCode,1)ParentCategoryCode,
 count(distinct case when c.CategoryCode ='41100' then null else a.BillNumber end)SaleCount from 
"${bm}" .tb${YM}_SALEBILL a ,
(select a.DeptCode,a.BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,case when IsBinding=1 then scbb.AutoRebate else a.AutoRebate end AutoRebate,case when IsBinding=1 then scbb.HandRebate else a.HandRebate end HandRebate,0 SaleGrossProfit,0 TAXSaleGrossProfit from "${bm}" .tb${YM}_SALEBILLDETAIL a left Join (select cbb.DeptCode,cbb.BillNumber,cbb.MasterID,sum(cbb.AutoRebate) AutoRebate,sum(cbb.HandRebate) HandRebate  from "${bm}" .tb${YM}_SALEBANDDETAIL cbb with(nolock)  group by cbb.DeptCode,cbb.BillNumber,cbb.MasterID  ) scbb on scbb.DeptCode=a.DeptCode and scbb.BillNumber=a.BillNumber  and scbb.MasterID=a.InnerId  
where CancelFlag ='0'
union all 
select DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,AutoRebate,HandRebate,(SaleEarning) SaleGrossProfit ,(SaleEarning+SaleTax) TAXSaleGrossProfit from "${bm}" .tb${YM}_SALERENTDETAIL
where CancelFlag ='0')b ,
"${bm}" .tbGoods c 
where  A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode   and b.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6
and  IsOutRule=0 and EnterAccountDate='${rq}'
and  not exists(select * from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and b.GoodsCode=z.goodscode)
group by left(c.CategoryCode,1)

select left(C.CategoryCode,1)ParentCategoryCode,case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
tb${TQYM}_GoodsDayPssm a ,
tb商品档案 c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Occurdate='${tqrq}'
and a.NodeCode='${bm}' and  not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by left(C.CategoryCode,1),case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

 select a.Occurdate,a.SaleCount,
 isnull(b.SaleMoney,0)SaleMoney,isnull(b.TaxSaleGrossProfit,0)TaxSaleGrossProfit,
 isnull(C.SaleMoney,0)Cx_SaleMoney from 
 (select EnterAccountDate Occurdate, 
 count(distinct case when c.CategoryCode ='41100' then null else a.BillNumber end)SaleCount from 
"${bm}" .tb${YM}_SALEBILL a ,
(select a.DeptCode,a.BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,case when IsBinding=1 then scbb.AutoRebate else a.AutoRebate end AutoRebate,case when IsBinding=1 then scbb.HandRebate else a.HandRebate end HandRebate,0 SaleGrossProfit,0 TAXSaleGrossProfit from "${bm}" .tb${YM}_SALEBILLDETAIL a left Join (select cbb.DeptCode,cbb.BillNumber,cbb.MasterID,sum(cbb.AutoRebate) AutoRebate,sum(cbb.HandRebate) HandRebate  from "${bm}" .tb${YM}_SALEBANDDETAIL cbb with(nolock)  group by cbb.DeptCode,cbb.BillNumber,cbb.MasterID  ) scbb on scbb.DeptCode=a.DeptCode and scbb.BillNumber=a.BillNumber  and scbb.MasterID=a.InnerId  
where CancelFlag ='0'
union all 
select DeptCode,BillNumber,GoodsCode,SaleAmount,SaleEarning,SaleTax,AutoRebate,HandRebate,(SaleEarning) SaleGrossProfit ,(SaleEarning+SaleTax) TAXSaleGrossProfit from "${bm}" .tb${YM}_SALERENTDETAIL
where CancelFlag ='0')b ,
"${bm}" .tbGoods c 
where  A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode   and b.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6
and  IsOutRule=0 and EnterAccountDate<='${rq}'
and  not exists(select * from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and b.GoodsCode=z.goodscode)
group by EnterAccountDate)a
left join 
(select Occurdate,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
"${bm}" .tb${YM}_GoodsDayPssm a ,
"${bm}" .tbGoods c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Occurdate<='${rq}'
and  not exists(select * from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by Occurdate

)b on  a.Occurdate=b.Occurdate

left join 
(select Accdate,sum(SaleIncome+saletax)SaleMoney from 
"${bm}" .tb${YM}_PromSaleProjectList a ,
"${bm}" .tbGoods c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Accdate<='${rq}'
and  not exists(select * from OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.33,1433\sql2008;User ID=sa;Password=85973099hlxxb!@#').HLDW.dbo.TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.DeptCode=z.nodecode and a.GoodsCode=z.goodscode)
group by Accdate

)c on  a.Occurdate=c.Accdate



select left(C.CategoryCode,1)ParentCategoryCode,case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end CategoryCode,sum(SaleIncome+saletax)SaleMoney,sum(TaxSaleGrossProfit)TaxSaleGrossProfit from 
tb${SZYM}_GoodsDayPssm a ,
tb商品档案 c 
where a.goodscode=c.goodscode and left(c.CategoryCode,1) between 1 and 6 and Occurdate='${szrq}'
and a.NodeCode='${bm}' and  not exists(select * from TB部门特殊商品对照 z where  z.GoodsPropertyCode like 1888 and a.NodeCode=z.nodecode and a.GoodsCode=z.goodscode)
group by left(C.CategoryCode,1),case when (left(C.CategoryCode,3) in ('280','287') or c.CategoryCode in (29000,29001,29002,29004,29005,29010,29011,29012,29013,29020,29021,29022,29023)) then '20'  
   when left(c.CategoryCode,3) in ('281','288') then '21' 
   when left(c.CategoryCode,3) in ('282','289') then '22'   
   when left(c.CategoryCode,2) in ('35') then '30'    
   else left(c.CategoryCode,2) end

