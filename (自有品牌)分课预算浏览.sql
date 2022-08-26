
select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,a.NodeCode DeptCode ,isnull(b.Salesindex,0)Salesindex,isnull(b.Grossprofitindex,0)Grossprofitindex,isnull(c.Salesindex,0)TaxSalesindex,isnull(c.Grossprofitindex,0) TaxGrossprofitindex from 
(select a.CategoryItemCode,ParentCategoryCode,CategoryCode ,CategoryName,YM,c.NodeCode  from 
(select a.CategoryItemCode,A.CategoryCode ParentCategoryCode,B.CategoryCode,B.CategoryName from 
HLCWDW.DBO.TB分类对照表 a 
left join 
HLCWDW.DBO.TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and b.ParentCategoryCode=a.CategoryCode

where a.CategoryItemCode='0007' and a.CategoryLevel='0' 





)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b,hldw.dbo.TB部门信息表 c
    where left(c.nodecode,1) between 1 and 2
    )a
    left join 
    dbo.[含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='0001'
    left join 
    dbo.[无税分课预算表]A c on a.CategoryCode=c.CategoryCode and a.YM=c.BudgetYM and a.NodeCode=c.DeptCode and   c.CategoryItemCode ='0001'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

select nodecode,nodecode+' '+NodeName Node
,AreaCode
 from 
dbo.TB部门信息表 a

where 
 left(a.nodecode,1) in (1,2) 
and nodecode not in (1047,6601,6602)
and 1=1 ${if(len(md)=0,""," and  nodecode in ("+md+")")}
and 1=1 ${if(len(大区)=0,""," and  AreaCode in ("+大区+")")}


select distinct AreaCode ,AreaName  from 
dbo.TB部门信息表 a


where left(a.nodecode,1) in (1,2)  and len(AreaCode)<>0 
and 1=1 ${if(len(dq)=0,""," and  AreaCode in ('"+dq+"')")}

select a.CategoryCode,a.CategoryCode+' '+a.CategoryName CategoryName from 
HLCWDW.DBO.TB分类对照表 a 


where a.CategoryItemCode='0007' 

