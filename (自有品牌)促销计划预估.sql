select 
a.档期编码,
a.商品编码,
d.GoodsName 商品名称,
d.BaseBarCode 商品条码,
d.BaseMeasureUnit 单位,
d.GoodsSpec 规格,
e.ColonyName 集群,
b.促销部门,
a.促销种类,
a.促销方式,
a.特供价,
a.特售价,
b.计划量,
b.计划额,
isnull(b.订货数量,0)订货数量,
b.陈列位
  from 
TB档期商品明细 a
left join 
TB档期部门商品明细 b on a.档期编码=b.档期编码 and a.商品编码=b.商品编码
left join 
TB商品档案 d on a.商品编码=d.GoodsCode
left join 
TB部门信息表 e on b.促销部门=e.NodeCode
where  a.促销种类 in ('11','13','16')
and 1=1 ${if(len(zt) == 0,   "",   "and a.状态 in ('" + replace(zt,",","','")+"')") }
and 1=1 ${if(len(dq) == 0,   "",   "and a.档期编码 in ('" + replace(dq,",","','")+"')") }
and 1=1 ${if(len(fl) == 0,   "",   "and left(CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(fs) == 0,   "",   "and a.促销方式 in ('" + replace(fs,",","','")+"')") }
and GoodsBrand='010001'
order by 1,6,2

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


select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' 
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
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2'

select NodeCode,ColonyName+' '+NodeCode+' '+NodeName NodeName
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and a.State!=-1 
and len(ColonyCode)!=0

order by ColonyCode,1


SELECT Goodscode 商品编码,Goodscode+' '+GoodsName 商品 FROM 
TB商品档案 a

where not exists (select * from TB档期商品明细 b where a.goodscode =b.商品编码 and 1=1 ${if(len(zt) == 0,   "",   "and 状态 in ('" + replace(zt,",","','")+"')") }
 and 1=1 ${if(len(dq) == 0,   "",   "and b.档期编码 in ('" + replace(dq,",","','")+"')") } )
and 1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }


