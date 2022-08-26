select ParentCategoryCode,CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) between 1 and 5 and CategoryLevel<3 and CategoryCode not in ( '19','29','28')



select * from 
[000]A .TBPROMOTIONTYPE
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
where a.PromotionThemeCode>='2019' and b.PromotionPeriodCode = '${档期}'
and b.SubID='0' and b.PromotionThemeCode not in ('0001')

select goodscode,goodscode+' '+goodsname goodsname from
tb商品档案

select ChangePriceCode,ChangeCauseCode,ChangeCauseName,OrderAttribution,Remark from 
[000]A .TBCHANGEPRICECAUSE 
where ChangePriceCode in ('1') and ChangeCauseCode not in (19,20)
order by Remark

select a.制单部门,a.制单日期,a.制单人编码,a.审核人编码,a.审核日期,a.档期编码,a.档期开始日期,a.档期结束日期,a.会员卡折上折,a.促销对象,a.特价方式,a.促销门店,
b.商品ID ,b.商品编码 ,b.起始日期,b.结束日期,b.促销种类,b.补差方式,b.促销方式,b.批量数量,b.原供价,b.原售价,b.特供价,b.特售价,b.单据状态
 from 
tb档期选品主表 a ,
TB档期选品商品明细 b 
where a.制单部门=b.制单部门 and a.档期编码 =b.档期编码 
and 1=1 ${if(len(分类编码) == 0,   "",   "and  a.制单部门 in ('" + replace(分类编码,",","','")+"')") }
and 1=1 ${if(len(档期) == 0,   "",   "and a.档期编码 in ('" + replace(档期,",","','")+"')") }

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName+' '+b.BeginDate+'-'+b.EndDate 档期名称 from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode>='2019' 

