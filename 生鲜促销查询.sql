select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<3 and CategoryCode not in ( '19','29','28')



select * from 
[000]A .TBPROMOTIONTYPE
where PromotionTypeCode between 0001 and 0003
union all 
select '0004'PromotionTypeCode,'折扣价'PromotionTypeName,'1000000'PromotionTypeBasics,'2'PRI,'0'ExportFlag
order by 1


    select
        * 
    from
        tb职员用户表

select 
NodeCode,NodeName ,NodeCode+' '+NodeName Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表

where left(nodecode,1) between 1 and 2 and nodecode not in ('1047')
order by NodeCode

select * from 
[000]A.TBPROMOTIONTHEME 

select a.PromotionThemeCode 促销种类编码,'生鲜周促销' 促销种类名称,
a.PromotionPeriodCode 档期编码,a.PromotionPeriodName+' '+a.BeginDate+'-'+a.EndDate 档期名称,a.BeginDate,a.EndDate from 
TB生鲜周促销周期表 a

where a.PromotionThemeCode<>'2018' and a.PromotionPeriodCode = '${档期}'


select * from
tb商品档案

select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

select a.*
 from 
TB档期选品商品明细 a ,TB商品档案 b 
where  a.商品编码 =b.GoodsCode  
and 1=1 ${if(len(分类编码) == 0,   "",   "and  a.制单部门 in ('" + replace(分类编码,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and a.档期编码 in ('" + replace(档期,",","','")+"')") }
and 1=1 ${if(len(自有品牌) == 0, "",if(自有品牌==1,"and b.GoodsBrand='010001'","and b.GoodsBrand!='010001'")) }
and 1=1 ${if(len(部门编码) == 0,   "",   "and a.促销部门 in ('" + replace(部门编码,",","','")+"')") }

select a.PromotionThemeCode 促销种类编码,'生鲜周促销' 促销种类名称,
a.PromotionPeriodCode 档期编码,a.PromotionPeriodName+' '+a.BeginDate+'-'+a.EndDate 档期名称,a.BeginDate,a.EndDate from 
TB生鲜周促销周期表 a

where a.PromotionThemeCode<>'2018' 


