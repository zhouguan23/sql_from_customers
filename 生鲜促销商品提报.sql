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

select CategoryCode NodeCode,Categoryname NodeName,''DeptCategoryCode,''CategoryName from 
[000]A .TBDEPTCATEGORY
where CategoryItemCode='0008'
union all 
select a.NodeCode,c.NodeName,a.DeptCategoryCode,b.CategoryName from 
[000]A .TBCATTODEPARTMENT a 
left join 
[000]A .TBDEPTCATEGORY b on b.CategoryItemCode='0008' and a.DeptCategoryCode=b.CategoryCode
left join 
[000]A .tbNode c on a.NodeCode =c.NodeCode 
where DeptCatItemCode='0008' and a.NodeCode in (select NodeCode  from 
[000]A .TBDEPARTMENT
where State='0' )


select * from 
[000]A.TBPROMOTIONTHEME a
where a.PromotionThemeCode <>'2018'

select a.PromotionThemeCode 促销种类编码,'生鲜周促销' 促销种类名称,
a.PromotionPeriodCode 档期编码,a.PromotionPeriodName+' '+a.BeginDate+'-'+a.EndDate 档期名称,a.BeginDate,a.EndDate from 
TB生鲜周促销周期表 a

where a.PromotionThemeCode<>'2018' and a.PromotionPeriodCode = '${档期}'


select goodscode,goodscode+' '+goodsname goodsname from
tb商品档案

select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

select a.*
 from 
TB档期选品商品明细 a ,TB商品档案 b 
where  a.商品编码 =b.GoodsCode  and b.GoodsBrand !='010001' 
and 1=1 ${if(len(分类编码) == 0,   "",   "and  a.制单部门 in ('" + replace(分类编码,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and a.档期编码 in ('" + replace(档期,",","','")+"')") }



select a.PromotionThemeCode 促销种类编码,'2019年度周促销' 促销种类名称,
a.PromotionPeriodCode 档期编码,a.PromotionPeriodCode+' '+a.PromotionPeriodName+' '+a.BeginDate+'-'+a.EndDate 档期名称 from 
TB生鲜周促销周期表 a

where a.PromotionThemeCode!='2018' and a.BeginDate> convert(varchar(8),dateadd(dd,0,GETDATE()),112)

select FormatCode DeptCategoryCode,a.NodeCode  from 

dbo.TB部门信息表 a

where 
  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601,1047)


