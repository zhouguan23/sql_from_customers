select a.DeptCode,left(b.CategoryCode,2)CategoryCode,a.GoodsCode,b.GoodsName,b.BaseMeasureUnit,b.BaseBarCode,c.SupplierCode+' '+d.SupplierName SupplierCode,e.WorkStateCode,f.CirculationModeCode,a.SurplusDay IsBeoverdue,
a.FirstPurchDate,a.LastPurchDate,a.LastSaleDate,a.Durability,a.NotPurchDay,a.NotSellDay,a.IsBeoverdue SurplusDay,
a.CounterCode,a.CountAmount,
a.StockAmount,a.StockCost,a.TaxStockCost,a.StockMoney,
g.OperateDate,g.OperCause,g.OperManCode,g.OperManName
 from 
OPENDATASOURCE('SQLOLEDB','Data Source=192.100.0.59,1433\sql2012;User ID=sa;Password=85973099hlxxb!@#').HLDW2.dbo.TBExpiredGoods a 
left join 
TB商品档案  b on a.GoodsCode=b.goodscode 
left join 
TB合同商品部门对照 c on a.DeptCode=c.DeptCode and a.GoodsCode=c.GoodsCode
left join 
TB供应商档案 d on c.SupplierCode=d.SupplierCode
left join 
TB部门商品经营状态表 e on a.DeptCode=e.DeptCode and a.GoodsCode=e.GoodsCode
left join 
TB部门商品流转途径表 f on a.DeptCode=f.DeptCode and a.GoodsCode=f.GoodsCode
left join 
tbTBExpiredOperCause G on a.DeptCode=g.DeptCode and a.GoodsCode=g.GoodsCode
and convert(varchar(8),dateadd(dd,0,getdate()),112)  between convert(varchar(8),dateadd(dd,0,g.OperateDate),112) and  convert(varchar(8),dateadd(dd,2,g.OperateDate),112)

where round(a.StockAmount,0)>0 and 
1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") } 
 and  1=1 ${if(len(bm)==0,"","and a.DeptCode in ('"+replace(bm,",","','")+"')")} 
 and 1=1 ${if(len(lx)==0,"","and SurplusDay in ('"+replace(lx,",","','")+"')")} 
  and 1=1 ${if(len(cl)==0,"",if(cl==1," and len(isnull(g.OperateDate,''))=0  ","and len(g.OperateDate)!=0 "))} 
order by 1,2,3

select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' 
  else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<=2
 order by 1,2

select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


