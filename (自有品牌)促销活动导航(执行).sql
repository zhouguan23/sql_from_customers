

select 档期编码,促销方式,count(distinct 商品编码)SKU,
count(distinct case when 状态 in ('0') then  商品编码 else null end)提报SKU,
count(distinct case when 状态 in ('1') then  商品编码 else null end)退回SKU,
count(distinct case when 状态 in ('2') then  商品编码 else null end)未审SKU,
count(distinct case when 状态 in ('3') then  商品编码 else null end)复审SKU,
count(distinct case when 状态 in ('4') then  商品编码 else null end)审定SKU,
count(distinct case when 状态 in ('5') then  商品编码 else null end)定稿SKU,
count(distinct case when 状态 in ('6') then  商品编码 else null end)执行SKU      from 
tb档期商品明细 a
left join 
TB商品档案 b on a.商品编码=b.goodscode
where 状态 !=-1 and b.GoodsBrand='010001'
and  1=1 ${if(len(fl) == 0,   "",   "and left(b.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
group by 档期编码,促销方式
order by 1 desc,2,3 asc

select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='1' 
union all 
select CategoryCode,CategoryCode+''+CategoryName CategoryName,ParentCategoryCode from
tb商品分类表 
where CategoryItemCode='0000' and CategoryCode not  like '0%' and CategoryCode not  like '6%' and CategoryLevel='2' and CategoryCode not in ( '19','29','28')

select a.PromotionThemeCode 促销种类编码,a.PromotionThemeName 促销种类名称,
b.PromotionPeriodCode 档期编码,b.PromotionPeriodCode+' '+b.PromotionPeriodName 档期名称,b.BeginDate,b.EndDate  from 
[000]A.TBPROMOTIONTHEME a
left join 
[000]A .tbPromotionPeriod b on a.PromotionThemeCode=b.PromotionThemeCode
where a.PromotionThemeCode<>'2018' AND 
1=1 ${if(dqlx == 1,  "and  left(b.PromotionPeriodCode,2) = '19'",if(dqlx == 2,"and  left(b.PromotionPeriodCode,2) = '00'","and  left(b.PromotionPeriodCode,2) != '19' and  left(b.PromotionPeriodCode,2) != '00' ")) }  
order by 5 desc 

select * from 
[000]A.TBSPECIALTYPE

