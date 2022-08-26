select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='1'  and  left(CategoryCode,1) between 3 and 5
union all 
select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2' and CategoryCode not in ( '19','29','28','35') and  left(CategoryCode,1) between 3 and 5




select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and len(ColonyCode)!=0
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}



DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@jsrq varchar(8),@dqny varchar(6)
set @dqny=convert(varchar(6),dateadd(dd,0,getdate()),112)
set @jsrq=convert(varchar(8),dateadd(dd,0,'20200218'),112)
set @jsny=@jsrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'20191216'),112)
set @qsny=@qsrq

SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 

select 
       A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,a.CirculationModeCode
      ,a.InProm
      ,sum([StoreOrderAmount]A+[OrderAmount]A) StoreOrderAmount
      ,sum([StoreOrderMoney]A+OrderMoney) StoreOrderMoney

,sum( b.Amount)库存数量
,sum( c.Amount)申请在途数量
,sum( cc.Amount)订单在途数量
,sum( ccc.Amount)配送在途数量
,sum( d.Amount)到货数量
,sum( d.PurchMoney)到货成本
from 
hldddw.dbo.tbYEARPOBILLDETAIL'+Nodecode+' a
left join 
tbStocks b on a.deptcode=b.CounterCode and a.goodscode=b.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=0 group by deptcode,goodscode) c on a.deptcode=c.deptcode and a.goodscode=c.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=1 group by deptcode,goodscode) cc on a.deptcode=cc.deptcode and a.goodscode=cc.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount from [hldw]A.dbo.tbGoodsWayArrivalannual where BillState=2 group by deptcode,goodscode) ccc on a.deptcode=ccc.deptcode and a.goodscode=ccc.goodscode
left join 
(select deptcode,goodscode,sum(Amount)Amount,sum(PurchMoney)PurchMoney from [hldw]A.dbo.tbGoodsArrivalannual where LastPerformDate between 20191209 and 20200124 group by deptcode,goodscode) d on a.deptcode=d.deptcode and a.goodscode=d.goodscode

left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode

where IsImportGoods+StoreOrderAmount!=0 
and  1=1 ${if(len(lx) == 0,   "","and a.IsImportGoods in (''" + replace(lx,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(a.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }
and    1=1 ${if(len(cx) == 0,   "",   "and a.InProm  like''%"+cx+"%''") }



group by A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,a.CirculationModeCode
      ,a.InProm
 '   
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%')  and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='
SELECT A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,a.CirculationModeCode
      ,a.InProm
      ,case when len(b.goodscode)!=0 then ''1'' else 0 end GoodsPropertyCode
	  ,sum([StoreOrderAmount]A) StoreOrderAmount
      ,sum([StoreOrderMoney]A) StoreOrderMoney

	  ,sum(库存数量)库存数量
	  ,sum( 申请在途数量)申请在途数量
      ,sum( 订单在途数量)订单在途数量
      ,sum( 配送在途数量 )配送在途数量 


	    ,sum(到货数量)到货数量
	    ,sum(到货成本)到货成本
	  FROM ('+@SQL1+') A  
	  LEFT JOIN 
 	  (select distinct goodscode from TB部门特殊商品对照 where GoodsPropertyCode=''2008'')  b on a.goodscode=b.goodscode
	  GROUP BY A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,a.CirculationModeCode
      ,case when len(b.goodscode)!=0 then ''1'' else 0 end 
      ,a.InProm
ORDER BY 6  DESC ,7 desc ,GOODSCODE asc
 'exec(@sql)


DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@jsrq varchar(8),@dqny varchar(6)
set @dqny=convert(varchar(6),dateadd(dd,0,getdate()),112)
set @jsrq=convert(varchar(8),dateadd(dd,0,'20200218'),112)
set @jsny=@jsrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'20191216'),112)
set @qsny=@qsrq

SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 

select 
       A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,sum([StoreOrderAmount]A+[OrderAmount]A) StoreOrderAmount
      ,sum([StoreOrderMoney]A+OrderMoney) StoreOrderMoney

,isnull(sum(
  b.StartAmount --期初
+ b.PURCHAmount --进货
+ b.REDEPLOYINAmount --拨入
+ b.PROFITAmount --升溢
+ b.COUNTPROFITAmount --盘升
- b.SaleAmount  --销售
- b.REDEPLOYOUTAmount --拨出
- b.LOSSAmount --损耗
- b.COUNTLOSSAmount --盘耗
- b.ToGiftAmount),0)库存数量  from 
hldddw.dbo.tbYEARPOBILLDETAIL'+Nodecode+' a
left join 
hldw.dbo.tb'+@dqny+'_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode

where IsImportGoods+StoreOrderAmount!=0 
and  1=1 ${if(len(lx) == 0,   "","and a.IsImportGoods in (''" + replace(lx,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }
and    1=1 ${if(len(cx) == 0,   "",   "and a.InProm  like''%"+cx+"%''") }


group by A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
 ' 
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')


SET @SQL2=''
SELECT @SQL2=@SQL2+' UNION ALL 

select 
a.occurdate,
a.GoodsCode,
A.nodecode DeptCode,

isnull(a.SaleAmount,0)销售数量,
isnull(a.SaleIncome+a.SaleTax,0)销售金额  from 
'+[name]A+' a
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode
where  a.occurdate between  '+@qsrq+' and '+@jsrq+' 
and exists(select * from ('+@SQL1+') z where  a.goodscode=z.goodscode )
and  1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }

 '
 FROM SYS.SYSOBJECTS WHERE type='U' AND name LIKE '%_GoodsDayPSSM' and SUBSTRING(name,3,6) between  @qsny and @jsny

SET @SQL2=STUFF(@SQL2,1,11,'')

SET @SQL='
select a.defday,b.goodscode ,isnull(sum(b.销售数量),0)销售数量,isnull(sum(b.销售金额),0)销售金额 from
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),'+@qsrq+',112)),112)defday
from master..spt_values 
where type=''p'' and number <= datediff(dd,convert(varchar(8),'+@qsrq+',112),convert(varchar(8),'+@jsrq+' ,112))) a 
left join 
('+@sql2+') b on a.defday=b.occurdate

group by  a.defday,b.goodscode 

ORDER BY a.defday,GOODSCODE
'exec(@sql)

DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@jsrq varchar(8),@dqny varchar(6)
set @dqny=convert(varchar(6),dateadd(dd,0,getdate()),112)
set @jsrq=convert(varchar(8),dateadd(dd,0,'20200218'),112)
set @jsny=@jsrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'20191216'),112)
set @qsny=@qsrq

SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 

select 
       A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,sum([StoreOrderAmount]A+[OrderAmount]A) StoreOrderAmount
      ,sum([StoreOrderMoney]A+OrderMoney) StoreOrderMoney

,isnull(sum(
  b.StartAmount --期初
+ b.PURCHAmount --进货
+ b.REDEPLOYINAmount --拨入
+ b.PROFITAmount --升溢
+ b.COUNTPROFITAmount --盘升
- b.SaleAmount  --销售
- b.REDEPLOYOUTAmount --拨出
- b.LOSSAmount --损耗
- b.COUNTLOSSAmount --盘耗
- b.ToGiftAmount),0)库存数量  from 
hldddw.dbo.tbYEARPOBILLDETAIL'+Nodecode+' a
left join 
hldw.dbo.tb'+@dqny+'_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode

where IsImportGoods+StoreOrderAmount!=0 
and  1=1 ${if(len(lx) == 0,   "","and a.IsImportGoods in (''" + replace(lx,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }
and    1=1 ${if(len(cx) == 0,   "",   "and a.InProm  like''%"+cx+"%''") }


group by A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
 ' 
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.* from 
tbGoodsWayArrivalannual a 
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode
where exists(select * from ('+@SQL1+') z where  a.goodscode=z.goodscode )
and  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and h.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }

'exec(@sql)

DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(8),@jsrq varchar(8),@dqny varchar(6)
set @dqny=convert(varchar(6),dateadd(dd,0,getdate()),112)
set @jsrq=convert(varchar(8),dateadd(dd,0,'20200218'),112)
set @jsny=@jsrq
set @qsrq=convert(varchar(8),dateadd(dd,0,'20191216'),112)
set @qsny=@qsrq

SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 

select 
       A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
      ,sum([StoreOrderAmount]A+[OrderAmount]A) StoreOrderAmount
      ,sum([StoreOrderMoney]A+OrderMoney) StoreOrderMoney

,isnull(sum(
  b.StartAmount --期初
+ b.PURCHAmount --进货
+ b.REDEPLOYINAmount --拨入
+ b.PROFITAmount --升溢
+ b.COUNTPROFITAmount --盘升
- b.SaleAmount  --销售
- b.REDEPLOYOUTAmount --拨出
- b.LOSSAmount --损耗
- b.COUNTLOSSAmount --盘耗
- b.ToGiftAmount),0)库存数量  from 
hldddw.dbo.tbYEARPOBILLDETAIL'+Nodecode+' a
left join 
hldw.dbo.tb'+@dqny+'_GoodsMonPSSM b on a.deptcode=b.NodeCode and a.goodscode=b.goodscode
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode

where IsImportGoods+StoreOrderAmount!=0 
and  1=1 ${if(len(lx) == 0,   "","and a.IsImportGoods in (''" + replace(lx,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and    1=1 ${if(len(gys) == 0,   "",   "and A.SupplierCode  in (''" + replace(gys,",","'',''")+"'')") }
and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }
and    1=1 ${if(len(cx) == 0,   "",   "and a.InProm  like''%"+cx+"%''") }


group by A.CategoryCode
      ,A.CateCatCode
      ,A.GoodsCode
      ,A.GoodsName
      ,A.BaseMeasureUnit
      ,A.IsImportGoods
 ' 
 FROM hldw.dbo.TB部门信息表 WHERE (NodeCode like '1%' or NodeCode like '2%') and 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }

SET @SQL1=STUFF(@SQL1,1,11,'')



SET @SQL='

select a.NodeCode DeptCode,a.GoodsCode,sum(PurchAmount+RedeployinAmount)Amount,sum(PurchCost+PurchTax +RedeployinCost+RedeployinTax)PurchMoney   from 
(select * from [hldw]A.dbo.tb201912_goodsdaypssm where OccurDate between 20191209 and 20200124 
union all 
       select * from [hldw]A.dbo.tb202001_goodsdaypssm where OccurDate between 20191209 and 20200124 ) a 
left join 
[HLDW]A.DBO.tb商品档案 h on a.goodscode=h.goodscode
where  exists(select * from ('+@SQL1+') z where  a.goodscode=z.goodscode )
and 1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }
and  1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in (''" + replace(bm,",","'',''")+"'')") }
and    1=1 ${if(len(fl) == 0,   "",   "and left(h.CategoryCode,2) in (''" + replace(fl,",","'',''")+"'')") }

and    1=1 ${if(len(spbm) == 0,   "",   "and A.GoodsCode  in (''" + replace(spbm,",","'',''")+"'')") }
and    1=1 ${if(sx == 3,   "",if(sx == 0,"and h.GoodsBrand!=''010001''",   " and h.GoodsBrand=''010001''")) }
group by a.nodecode,a.GoodsCode
'exec(@sql)

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

