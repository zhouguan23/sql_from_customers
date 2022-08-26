select a.PromotionThemeCode,a.PromotionPeriodCode,a.PromotionPeriodName,a.BeginDate,a.EndDate,a.SpecialTypeCode,a.SpecialTypeName,count(distinct 商品编码)SKU,count(distinct case when 单据状态 not in ('11','0') then  商品编码 else null end )已审SKU from 
(select PromotionThemeCode,PromotionPeriodCode,PromotionPeriodName,BeginDate,EndDate,SpecialTypeCode,SpecialTypeName from 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.9\sql2008;User ID=sa;Password=hlzb888 ').hllszb.[000]A.TBPROMOTIONPERIOD a ,
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.9\sql2008;User ID=sa;Password=hlzb888 ').hllszb.[000]A.TBSPECIALTYPE b 
where SpecialTypeCode not in ('29','30','31','32') and PromotionThemeCode!='2018')a
left join 
TB档期选品商品明细 b on a.PromotionPeriodCode=b.档期编码 and a.SpecialTypeCode=b.促销种类
where 1=1 ${if(len(部门编码) == 0,   "",   "and b.促销门店 in ('" + replace(部门编码,",","','")+"')") }
and 1=1 ${if(len(分类编码) == 0,   "",   "and b.制单部门 in ('" + replace(分类编码,",","','")+"')") }
and 单据状态 not in ('0','-1') and exists(select * from TB商品档案 z  where b.商品编码=z.goodscode  and z.GoodsBrand !='010001')
group by a.PromotionThemeCode,a.PromotionPeriodCode,a.PromotionPeriodName,a.BeginDate,a.EndDate,a.SpecialTypeCode,a.SpecialTypeName
order by 4 desc ,6,2


select CategoryCode,CategoryCode+' '+case when CategoryName='生鲜加工' then '加工' else CategoryName end  CategoryName from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and left(CategoryCode,1) =1 and CategoryLevel=2 and CategoryCode not in ( '19','29','28')


