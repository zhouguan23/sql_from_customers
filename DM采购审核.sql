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

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.SubID 子档号,b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称,b.BeginDate,b.EndDate from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' and b.PromotionPeriodCode = '${档期}'
and b.SubID='0' and b.PromotionThemeCode not in ('0001')

select goodscode,goodscode+' '+goodsname goodsname from
tb商品档案

select SpecialTypeCode,SpecialTypeName,IsPeriod from 
[000]A .TBSPECIALTYPE
order by SpecialTypeCode

select a.*
 from 
TB档期选品商品明细 a ,TB商品档案 b 
where  a.商品编码 =b.GoodsCode  and b.GoodsBrand !='010001' 
and  1=1 ${if(len(分类编码) == 0,   "",   "and  a.制单部门 in ('" + replace(分类编码,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and a.档期编码 in ('" + replace(档期,",","','")+"')") }
and a.单据状态='11'


    select
        a.PromotionThemeCode 促销种类编码,
        a.PromotionThemeName 促销种类名称,
        b.PromotionPeriodCode 档期编码,
        b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称           
    from
        [000]A.TBPROMOTIONTHEME a           
    left join
        [000]A .tbPromotionPeriod b                           
            on a.PromotionThemeCode=b.PromotionThemeCode           
    where
        a.PromotionThemeCode<>'2018' and b.BeginDate  >=convert(varchar(8),dateadd(dd,0,GETDATE()),112)

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


