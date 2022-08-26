select * from 
tb人资_人效坪效分析
where 1=1 ${if(len(bm) == 0,   "",   "and 部门编码  in ('" + replace(bm,",","','")+"')") }
and 年月 between '${qsny}' and '${jsny}'

SELECT b.CategoryCode,b.CategoryName,a.NodeCode,a.NodeName,A.Area FROM 
(select a.NodeCode,a.NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')NodeName
,Area   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and (left(a.NodeCode,1) between 1 and 2  )
and a.State=0 and b.NodeType=0 )A
left join
(select  b.CategoryCode,b.CategoryName,a.NodeCode from 
[000]A.TBCATTODEPARTMENT a
left join
[000]A.TBDEPTCATEGORY b on a.DeptCategoryCode=b.CategoryCode  and CategoryItemCode='0011'
where  a.DeptCatItemCode ='0011')B on a.NodeCode=B.nodecode
where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode  in ('" + replace(bm,",","','")+"')") }

