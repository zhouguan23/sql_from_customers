select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称,b.BeginDate,b.EndDate from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode>='2019' 

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称,b.BeginDate,b.EndDate,convert(varchar(8),DATEADD(mm, -1,  b.EndDate),112)SYEndDate from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode>='2019' and b.PromotionPeriodCode = '${档期}'


select 档期编码,促销门店,起始日期+'-'+结束日期 促销日期,LEFT(b.CategoryCode ,2)分类,商品编码,b.goodsname 商品名称,
b.BaseMeasureUnit 商品单位,促销种类,补差方式,促销方式,批量数量,原供价,原售价,特供价,特售价,计划量,计划金额
,isnull(c.Amount,0) 库存数量,isnull(c.TaxCost,0) 库存金额,isnull(d.Amount,0) 在途数量,isnull(d.PurchMoney,0) 在途金额,
e.AccDate 促销期,
ISNULL(e.SaleAmount,0)促销销量,ISNULL(e.SaleMenoy,0)促销销售金额

  from 
 TB档期选品商品明细 a
 left join 
 TB商品档案 b on a.商品编码 =b.GoodsCode 
 left join 
 tbStocks c on a.促销门店=c.CounterCode and a.商品编码=c.GoodsCode 
  left join 
 tbWayArrivalannual d on a.促销门店=d.DeptCode  and a.商品编码=d.GoodsCode 
 left join 
 (select AccDate ,DeptCode ,GoodsCode ,SUM(SaleAmount)SaleAmount,SUM(SaleIncome+SaleTax)SaleMenoy from 
 (select * from  TB${qsym}_门店促销销售 union all select * from  TB${jsym}_门店促销销售)a
group by AccDate ,DeptCode ,GoodsCode) e  on a.促销门店 =e.DeptCode and  a.商品编码=e.GoodsCode and e.AccDate between 起始日期 and 结束日期
 
 where a.单据状态='4' 
 
and  1=1 ${if(len(档期) == 0,   "",   "and a.档期编码 in ('" + replace(档期,",","','")+"')") }
and 1=1 ${if(len(部门编码) == 0,   "",   "and a.促销门店 in ('" + replace(部门编码,",","','")+"')") }
and 1=1 ${if(len(商品编码) == 0,   "",   "and a.商品编码 in ('" + replace(商品编码,",","','")+"')") }
and 1=1 ${if(len(变价原因) == 0,   "",   "and a.促销种类 in ('" + replace(变价原因,",","','")+"')") }
and 1=1 ${if(len(变价原因_2) == 0,   "",   "and a.促销种类 in ('" + replace(变价原因_2,",","','")+"')") }
and 1=1 ${if(len(分类编码) == 0,   "",   "and left(b.CategoryCode ,2) in ('" + replace(分类编码,",","','")+"')") }
order by  e.AccDate,档期编码,a.商品编码,left(b.CategoryCode ,2),a.促销门店


select SpecialTypeCode,SpecialTypeCode+' '+SpecialTypeName SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
where SpecialTypeCode like '1%'
order by SpecialTypeCode


select distinct AreaCode NodeCode ,AreaName NodeName ,'' AreaCode from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}
union all 
select 
NodeCode,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2)   and len(AreaCode)<>0 
and 1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}



select SpecialTypeCode,SpecialTypeCode+' '+SpecialTypeName SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
where SpecialTypeCode like '2%'
order by SpecialTypeCode

select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

