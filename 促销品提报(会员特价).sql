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
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2'and 1=1 ${if(len(fl) == 0,   "",   "and CategoryCode in ('" + replace(fl,",","','")+"')") }

select NodeCode,ColonyName+' '+NodeCode+' '+NodeName NodeName
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and a.State!=-1 
and len(ColonyCode)!=0

order by ColonyCode,1

