select * from 
(select  b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and left(b.NodeCode,1) between 1 and 2
union all 
select  NodeCode,'3' ParentCategoryCode,'39' CategoryCode ,'烟酒柜'CategoryName
from
dbo.TB部门信息表
where NodeCode in (1042,1061,1058,1040)
union all 


select  b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%')a
where 1=1 ${if(len(bm) == 0,   "",   "and nodecode in ('" + replace(bm,",","','")+"')") }
order by 1,2,3

select * from 
TB门店绩效表毛利扣减表
where HappenYM='${YM}' and CategoryItemCode='${lx}'

