
select a.NodeCode,a.CategoryCode,isnull(c.f_sps,0)sps,isnull(c.f_bz,0)bz from 


 (select  a.CategoryName as Format,a.nodecode,a.nodecode+' '+replace(replace(replace(replace(replace(replace(replace(replace(a.nodename,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二') nodename 
 ,b.CategoryCode
from
(select b.CategoryName,a.NodeCode,c.NodeName from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
left join 
[000]A .tbNode c on a.NodeCode=c.NodeCode 

where  a.DeptCatItemCode ='0011' and   b.CategoryCode not like '04' )a,
(select CategoryCode  from [000]A .TBGOODSCATEGORY where CategoryLevel=5 and CategoryCode not like '0%' and CategoryCode not like '6%' and CategoryCode not like '1%' and CategoryCode not like '2%' and CategoryItemCode='0000') b
 
)a
left join 
tbmdsp c on a.nodecode=c.deptcode and a.CategoryCode=c.CategoryCode
where  1=1 ${if(len(分类) == 0,   "",   "and a.CategoryCode in ('" + replace(分类,",","','")+"')") } and 1=1 ${if(len(部门) == 0,   "",   "and a.nodecode in ('" + replace(部门,",","','")+"')") } and a.CategoryCode not like '300%'
order by 2,1

