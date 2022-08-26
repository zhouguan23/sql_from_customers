SELECT 总部门 FROM 部门

select distinct  ColonyCode NodeCode,ColonyName NodeName,'' ColonyCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and a.State!=-1 
and len(ColonyCode)!=0
union all 
select NodeCode,NodeCode+' '+NodeName NodeName,ColonyCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and a.State!=-1 
and len(ColonyCode)!=0


select SpecialTypeCode,SpecialTypeCode+' '+SpecialTypeName SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' and
1=1 ${if(dqlx == 1,  "and  left(b.PromotionPeriodCode,2) = '19'",if(dqlx == 2,"and  left(b.PromotionPeriodCode,2) = '00'","and  left(b.PromotionPeriodCode,2) != '19' and  left(b.PromotionPeriodCode,2) != '00' ")) }

order by 5 desc 

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' AND 
1=1 ${if(len(dq) == 0,"",  "and  b.PromotionPeriodCode in ('" + replace(dq,",","','")+"')") }  
order by 5 desc 

select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='1' 
union all 
select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2' and CategoryCode not in ( '19','29','28')




select nodecode,nodecode+' '+NodeName Node
,ColonyCode AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047)
and len(ColonyCode)!=0
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  ColonyCode in ("+大区+")")}


select 
a.档期编码,
a.主题名称,
a.商品编码,
d.GoodsName 商品名称,
d.BaseBarCode 商品条码,
d.BaseMeasureUnit 单位,
c.ColonyName 集群,
b.促销部门 ,
a.促销种类,
a.补差方式,
a.促销方式,
a.批量数量,
a.批量金额,
a.原供价,
a.原售价,
a.特供价,
a.特售价,
b.计划量,
b.计划额,
a.组合定价,
a.满减金额,
a.最大满减金额,
isnull(b.订货数量,0)订货数量,
a.陈列位,
a.起始日期,
a.结束日期,
a.开始时间,
a.结束时间,
a.状态 into #sj from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
tb部门信息表 c on b.促销部门=c.nodecode
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
where  a.状态>=5 
and 1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(d.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and b.促销部门 in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(zl) == 0,   "",   "and a.促销种类 in ('" + replace(zl,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.商品编码 in ('" + replace(sp,",","','")+"')") }
and 1=1 ${if(zypp == 1 ,"and GoodsBrand =010001", if(zypp == 0,"and GoodsBrand !=010001","")) }
order by 1,6,7,2,3

select a.档期编码,a.主题名称,a.商品编码,a.商品名称,a.商品条码,a.单位,STUFF((SELECT distinct ',' + 集群 FROM #sj b WHERE a.档期编码=b.档期编码 and a.商品编码=b.商品编码  FOR XML PATH('')),1, 1, '') 集群
,STUFF((SELECT distinct ',' + 促销部门 FROM #sj b WHERE a.档期编码=b.档期编码 and a.商品编码=b.商品编码  FOR XML PATH('')),1, 1, '') 部门,a.促销种类,a.补差方式,a.促销方式,a.批量数量,a.批量金额,a.原供价,a.原售价,a.特供价,a.特售价,a.组合定价,a.满减金额,a.最大满减金额,sum(a.计划量)计划量,sum(a.计划额)计划额,sum(a.订货数量)订货数量,a.起始日期,a.结束日期,a.开始时间,a.结束时间,a.陈列位,a.状态 from 
#sj a

group by  a.档期编码,a.主题名称,a.商品编码,a.商品名称,a.商品条码,a.单位,a.促销种类,a.补差方式,a.促销方式,a.批量数量,a.批量金额,a.原供价,a.原售价,a.特供价,a.特售价,a.组合定价,a.满减金额,a.最大满减金额,a.起始日期,a.结束日期,a.陈列位,a.状态,a.开始时间,a.结束时间
order by a.促销种类,a.档期编码,a.商品编码


drop table #sj


select 
a.档期编码,
a.主题名称,
a.商品编码,
d.GoodsName 商品名称,
d.BaseBarCode 商品条码,
d.BaseMeasureUnit 单位,
c.ColonyName 集群,
b.促销部门+' '+nodename 促销部门,
a.促销种类,
a.补差方式,
a.促销方式,
a.批量数量,
a.批量金额,
a.原供价,
a.原售价,
a.特供价,
a.特售价,
b.计划量,
b.计划额,
a.组合定价,
a.满减金额,
a.最大满减金额,
isnull(b.订货数量,0)订货数量,
a.陈列位,
a.起始日期,
a.结束日期,
a.开始时间,
a.结束时间,
a.状态  from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
tb部门信息表 c on b.促销部门=c.nodecode
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
where a.促销种类 in ('11','13','16')
and 1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(d.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }

order by 1,6,7,2

select 
a.档期编码,
a.主题名称,
a.商品编码,
d.GoodsName 商品名称,
d.BaseBarCode 商品条码,
d.BaseMeasureUnit 单位,
c.ColonyName 集群,
b.促销部门+' '+nodename 促销部门,
e.WorkStateCode 经营状态,
f.CirculationModeCode 流转途径,
h.SupplierCode+' '+i.SupplierName 供应商,
isnull(g.Amount,0) 库存量,
isnull(g.TaxCost,0) 库存金额,
a.促销种类,
a.补差方式,
a.促销方式,
a.批量数量,
a.批量金额,
a.原供价,
a.原售价,
a.特供价,
a.特售价,
b.计划量,
b.计划额,
a.组合定价,
a.满减金额,
a.最大满减金额,
isnull(b.订货数量,0)订货数量,
a.陈列位,
a.起始日期,
a.结束日期,
a.开始时间,
a.结束时间,
a.状态  from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
tb部门信息表 c on b.促销部门=c.nodecode
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
left JOIN
TB部门商品经营状态表 e on a.商品编码=e.goodscode and b.促销部门=e.deptcode 
left JOIN
TB部门商品流转途径表 f on a.商品编码=f.goodscode and b.促销部门=f.deptcode 
left join 
tbStocks g on a.商品编码=g.goodscode and b.促销部门=g.CounterCode
left join 
TB合同商品部门对照 h on a.商品编码=h.goodscode and b.促销部门=h.deptcode 
left join 
TB供应商档案 i on h.suppliercode=i.suppliercode
where  a.状态>=5 
and 1=1 ${if(zypp == 1 ,"and GoodsBrand =010001", if(zypp == 0,"and GoodsBrand !=010001","")) }
and 1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(d.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and b.促销部门 in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(zl) == 0,   "",   "and a.促销种类 in ('" + replace(zl,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.商品编码 in ('" + replace(sp,",","','")+"')") }


order by 1,6,7,2

select SpecialTypeCode,SpecialTypeCode+' '+SpecialTypeName SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
where SpecialTypeCode like '1%'
order by SpecialTypeCode

select distinct ColonyCode AreaCode ,ColonyName AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(ColonyCode)<>0 and 1=1 ${if(len(yydq)=0,""," and ColonyCode in ('"+yydq+"')")}

