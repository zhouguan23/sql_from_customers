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
--where IsPeriod=1
order by SpecialTypeCode

select case when BeginDate<=CONVERT(varchar(8),GETDATE(),112) then '1' else '2' end xh, a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018'   and
1=1 ${if(dqlx == 1,  "and  left(b.PromotionPeriodCode,2) = '19'",if(dqlx == 2,"and  left(b.PromotionPeriodCode,2) = '00'","and  left(b.PromotionPeriodCode,2) != '19' and  left(b.PromotionPeriodCode,2) != '00' ")) }
order by 1 asc,4 desc  



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
a.起始日期+'-'+a.结束日期 促销期,
d.GoodsName 商品名称,
d.BaseMeasureUnit 单位,
b.促销部门 ,
a.促销种类,
a.促销方式,
isnull(b.计划量,0)计划数量,
isnull(f.Amount,0)库存数量,
isnull(g.Amount,0)在途数量,
AccDate,
sum(isnull(e.SaleAmount,0))销售数量,
sum(isnull(e.SaleIncome+e.SaleTax,0))销售金额  from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
tb部门信息表 c on b.促销部门=c.nodecode
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
left join 
tbStocks f on b.促销部门=f.CounterCode and b.商品编码=f.goodscode
left join 
tbWayArrivalannual g on b.促销部门=g.DeptCode and b.商品编码=g.goodscode
left join 
(select * from tb${qsym}_门店促销数据 
union all 
select * from tb${jsym}_门店促销数据) e on b.促销部门=e.deptcode and b.商品编码=e.goodscode and a.起始日期+a.结束日期=e.BeginDate+e.EndDate --and a.开始时间+a.结束时间=e.BeginTime+e.EndTime

where  a.状态=7 and len(AccDate)!=0 and GoodsBrand!='010001'
and 1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(d.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(bm) == 0,   "",   "and b.促销部门 in ('" + replace(bm,",","','")+"')") }
and 1=1 ${if(len(zl) == 0,   "",   "and a.促销种类 in ('" + replace(zl,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and a.商品编码 in ('" + replace(sp,",","','")+"')") }
and 1=1 ${if(zypp == 1 ,"and GoodsBrand =010001", if(zypp == 0,"and GoodsBrand !=010001","")) }
group by a.档期编码,a.主题名称,a.商品编码,a.起始日期+'-'+a.结束日期,d.GoodsName ,d.BaseMeasureUnit ,b.促销部门 ,a.促销种类,a.促销方式,isnull(b.计划量,0),AccDate,isnull(f.Amount,0),isnull(g.Amount,0)
order by 8,13,7,1,2,3


select SpecialTypeCode,SpecialTypeCode+' '+SpecialTypeName SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
where SpecialTypeCode like '1%'
order by SpecialTypeCode

select distinct ColonyCode AreaCode ,ColonyName AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(ColonyCode)<>0 and 1=1 ${if(len(yydq)=0,""," and  ColonyCode in ('"+yydq+"')")}

