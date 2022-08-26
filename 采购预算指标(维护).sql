select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,a.NodeCode DeptCode ,isnull(b.Salesindex,0)Salesindex,isnull(b.Grossprofitindex,0)Grossprofitindex,
isnull(round(case when a.CategoryCode in (11,13,14) then b.Salesindex/1.1 when a.CategoryCode in (10,12) then b.Salesindex/1 else b.Salesindex/1.16 end,2),0) TaxSalesindex,
isnull(round(case when a.CategoryCode in (11,13,14) then (b.Salesindex/1.1)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end )  when a.CategoryCode in (10,12) then (b.Salesindex/1.0)*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) else b.Salesindex/1.16*(case when b.Grossprofitindex=0 or b.Salesindex=0 then 0 else   b.Grossprofitindex/b.Salesindex end ) end,2),0) TaxGrossprofitindex from 
(select a.CategoryItemCode,CategoryCode2 ParentCategoryCode,CategoryCode3 CategoryCode,CategoryName3 CategoryName,YM,a.CategoryItemCode NodeCode  from 
(select a.CategoryItemCode,a.CategoryCode CategoryCode1,a.CategoryName CategoryName1,b.CategoryCode  CategoryCode2,b.CategoryName CategoryName2,c.CategoryCode  CategoryCode3,c.CategoryName CategoryName3 from 
TB分类对照表 a 
left join 
TB分类对照表 b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.ParentCategoryCode and b.CategoryLevel=1
left join 
TB分类对照表 c on b.CategoryItemCode=c.CategoryItemCode and b.CategoryCode=c.ParentCategoryCode and c.CategoryLevel=2
where a.CategoryLevel=0 and a.CategoryItemCode ='${lx}'

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='${lx}'

    order by 2,4,6,5,7
    

