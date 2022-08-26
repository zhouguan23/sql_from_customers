
select a.Formatcode,a.Format,a.nodecode ,left(a.CategoryCode,1)CategoryCode1,
left(a.CategoryCode,2)CategoryCode2,left(a.CategoryCode,3)CategoryCode3,left(a.CategoryCode,4)CategoryCode4,a.CategoryCode
,isnull (sum(b.f_sps) ,0)jhs,ISNULL(SUM(c.sps),0)sps from 
 ( select b.CategoryCode Formatcode,b.CategoryName as Format,a.nodecode ,c.CategoryCode from 
 [000]A.TBCATTODEPARTMENT a,
 [000]A.TBDEPTCATEGORY b  ,
 [000]A .TBGOODSCATEGORY  c
 where a.DeptCatItemCode='0011' and b.CategoryItemCode='0011' and a.DeptCategoryCode=b.CategoryCode and   b.CategoryCode  like '04' 
 and c.CategoryLevel=5 and c.CategoryCode  like '6%' and c.CategoryItemCode='0000' and LEFT(a.nodecode,1) between 9 and 9
 

 )a
left join 
tbmdsp b on a.NodeCode =b.DeptCode  and  a.CategoryCode=b.Categorycode
left join 
(select DeptCode ,b.CategoryCode CategoryCode5
,count(a.GoodsCode)sps  from [000]A .TBDEPTWORKSTATE  a ,[000]A .tbGoods b 
where  a.GoodsCode =b.GoodsCode and 
left(DeptCode,1) between 9 and 9   and a.WorkStateCode in (1,2,4,5)  AND a.goodscode in (select GoodsCode  from "000" .tbGoods where GoodsType =0)
group by DeptCode ,b.CategoryCode)c on a.nodecode=c.deptcode and a.CategoryCode=c.CategoryCode5
where 1=1 ${if(len(fl2) == 0,   "",   "and left(a.CategoryCode,2) in ('" + replace(fl2,",","','")+"')") }
 and 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") }
group by a.Formatcode,a.Format,a.nodecode ,a.CategoryCode

order by 8,1,3

select ParentCategoryCode,CategoryCode,CategoryCode+' '+CategoryName CategoryName  from [000]A.TBGOODSCATEGORY  where CategoryItemCode='0000' and CategoryCode like '6%'  and CategoryLevel<=2

select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')NodeName   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 9 and 9 
and a.State=0 and b.NodeType=0 

