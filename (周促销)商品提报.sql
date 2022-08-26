select a.PromotionThemeCode,a.PromotionPeriodCode,a.PromotionPeriodName,a.BeginDate,a.EndDate,a.CategoryCode,a.CategoryName,count(distinct 商品编码)SKU,count(distinct case when 单据状态 not in ('11','0') then  商品编码 else null end )已审SKU from 
(select PromotionThemeCode,PromotionPeriodCode,PromotionPeriodName,BeginDate,EndDate,'31'SpecialTypeCode,'(生鲜)周促销商品'SpecialTypeName,b.CategoryCode,b.CategoryName from 
TB生鲜周促销周期表 a ,
TB商品分类表 b
where b.CategoryLevel=2 and b.ParentCategoryCode like '1%' and b.CategoryItemCode='0000' and b.CategoryCode not in ('19') 
and EndDate <=dateadd(MONTH,2,convert(varchar(8),getdate(),112))
and convert(varchar(6),EndDate,112) >'201904'
)a
left join 
TB档期选品商品明细 b on a.PromotionPeriodCode=b.档期编码 and a.SpecialTypeCode=b.促销种类 and a.CategoryCode=b.制单部门
and b.制单部门 like '1%' 
and 1=1 ${if(len(部门编码) == 0,   "",   "and b.促销门店 in ('" + replace(部门编码,",","','")+"')") }

and 单据状态 not in ('0','-1')
where 1=1 ${if(len(分类编码) == 0,   "",   "and a.CategoryCode in ('" + replace(分类编码,",","','")+"')") }
group by a.PromotionThemeCode,a.PromotionPeriodCode,a.PromotionPeriodName,a.BeginDate,a.EndDate,a.CategoryCode,a.CategoryName
order by 4 desc ,6,2


select CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) =1 and CategoryLevel=2 and CategoryCode not in ( '19','29','28')


