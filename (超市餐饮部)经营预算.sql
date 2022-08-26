
select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex,
isnull(C.Salesindex,0)+isnull(d.Salesindex,0)+isnull(e.Salesindex,0)Actualcost,isnull(C.Salesindex,0)+isnull(d.Salesindex,0)+isnull(e.Salesindex,0)+ISNULL(f.Salesindex,0)Costaccrued from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
where a.CategoryLevel='1' and a.CategoryItemCode='0000'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    TB部门信息表 c 
    where left(NodeCode,1) in (1,2) and   1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
    left join 
    TB费用预算表 b on a.CategoryCode=b.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
        left join 
    TB账面费用表 c on a.CategoryCode=c.CategoryCode and a.NodeCode=c.deptcode and a.YM=c.budgetYM and a.CategoryItemCode=c.CategoryItemCode
    left join 
    TB会计费用调整表 d on a.CategoryCode=d.CategoryCode and a.NodeCode=d.deptcode and a.YM=d.budgetYM and a.CategoryItemCode=d.CategoryItemCode
    left join 
    TB费用项目调整表 e on a.CategoryCode=e.CategoryCode and a.NodeCode=e.deptcode and a.YM=e.budgetYM and a.CategoryItemCode=e.CategoryItemCode
    left join 
    TB费用预提表 f on a.CategoryCode=f.CategoryCode and a.NodeCode=f.deptcode and a.YM=f.budgetYM and a.CategoryItemCode=f.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)
    



select case when a.Category1Code in ('14','15','16','17','18') then '不可控费用' else '经营费用' end fyfl,
a.Category1Code,a. Category1Name,A.CategoryCode,A.CategoryName,a.YM,a.NodeCode,a.NodeName,isnull(b.Salesindex,0)Salesindex,
isnull(C.Salesindex,0)+isnull(d.Salesindex,0)+isnull(e.Salesindex,0)Actualcost,isnull(C.Salesindex,0)+isnull(d.Salesindex,0)+isnull(e.Salesindex,0)+ISNULL(f.Salesindex,0)Costaccrued from 
(select a.CategoryItemCode,a.Category1Code, Category1Name,A.CategoryCode,A.CategoryName,B.YM,c.NodeCode,c.NodeName from 
(select a.CategoryItemCode,a.CategoryCode Category1Code,a.CategoryName as Category1Name,b.CategoryCode,b.CategoryName  from 
tb预算科目表 a 
left join 
tb预算科目表 b on b.CategoryLevel='2' and a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0001'
where a.CategoryLevel='1' and a.CategoryItemCode='0001'
)a,

(sELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')B,
    TB部门信息表 c 
    where left(NodeCode,1) in (1,2) and   1=1 ${if(len(bm) == 0,   "", "and c.NodeCode in ('" + replace(bm,",","','")+"')") })a
 left join 
    TB费用预算表 b on a.CategoryCode=b.CategoryCode and a.NodeCode=b.deptcode and a.YM=b.budgetYM and a.CategoryItemCode=b.CategoryItemCode
        left join 
    TB账面费用表 c on a.CategoryCode=c.CategoryCode and a.NodeCode=c.deptcode and a.YM=c.budgetYM and a.CategoryItemCode=c.CategoryItemCode
    left join 
    TB会计费用调整表 d on a.CategoryCode=d.CategoryCode and a.NodeCode=d.deptcode and a.YM=d.budgetYM and a.CategoryItemCode=d.CategoryItemCode
    left join 
    TB费用项目调整表 e on a.CategoryCode=e.CategoryCode and a.NodeCode=e.deptcode and a.YM=e.budgetYM and a.CategoryItemCode=e.CategoryItemCode
    left join 
    TB费用预提表 f on a.CategoryCode=f.CategoryCode and a.NodeCode=f.deptcode and a.YM=f.budgetYM and a.CategoryItemCode=f.CategoryItemCode
    order by convert(int,a.Category1Code),convert(int,a.CategoryCode)
    


select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex from 
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select  b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and CategoryCode<>29   and CategoryCode<>19 
and left(b.NodeCode,1) between 1 and 2
and CategoryCode not in (28,23)
union all 

select  b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%'

union all 

select  b.NodeCode ,'7' ParentCategoryCode,'39'CategoryCode ,'烟酒专柜' CategoryName
from dbo.TB部门信息表 b where  nodecode in (1042,1061,1058)

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[无税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

	select a.CategoryCode ParentCategoryCode,a.CategoryCode ,a.CategoryName,YM month,a.NodeCode DeptCode ,
	ISNULL(b.Salesindex,0)TAXSalesindex,ISNULL(c.TAXSaleMoney,0)TAXSaleMoney,ISNULL(c.AfterTAXSaleMoney,0)AfterTAXSaleMoney,
	ISNULL(b.Grossprofitindex,0)TAXGrossprofitindex,ISNULL(c.TAXGross,0)+isnull(e.kx,0)TAXGross,ISNULL(c.AfterTAXGross,0)AfterTAXGross,
	ISNULL(D.Salesindex,0)Salesindex,ISNULL(c.SaleMoney,0)SaleMoney,ISNULL(c.AfterSaleMoney,0)AfterSaleMoney,
	ISNULL(D.Grossprofitindex,0)Grossprofitindex,ISNULL(c.Gross,0)+isnull(e.kx,0)Gross,ISNULL(c.AfterGross,0)AfterGross
	 from 
	(select CategoryCode ,CategoryName,YM,a.NodeCode  from 
	(select  b.NodeCode,a.CategoryCode ,a.CategoryName 
	from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=1 and left(CategoryCode,1) between 1 and 5
	and left(b.NodeCode,1) between 1 and 2
union all 
select  b.NodeCode,'7' CategoryCode ,'烟酒专柜'CategoryName 
from dbo.TB部门信息表 b 
where  left(b.NodeCode,1) between 1 and 2
	
	)a,
	(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
	FROM master.dbo.spt_values
	WHERE type = 'p'
	    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
	    )a
	    left join 
	    (select DeptCode,left(CategoryCode,1)CategoryCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[含税分课预算表]A
    where CategoryItemCode ='0000' and CategoryCode not like '39'
    group by DeptCode,left(CategoryCode,1),BudgetYM
    union all 
    select DeptCode,'7' CategoryCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[含税分课预算表]A
    where CategoryItemCode ='0000' and CategoryCode like '39'
    group by DeptCode,BudgetYM) b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode 	       
    	    left join 
	    (select DeptCode,left(CategoryCode,1)CategoryCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[无税分课预算表]A
    where CategoryItemCode ='0000' and CategoryCode not like '39'
    group by DeptCode,left(CategoryCode,1),BudgetYM
    union all 
    select DeptCode,'7' CategoryCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[无税分课预算表]A
    where CategoryItemCode ='0000' and CategoryCode like '39'
    group by DeptCode,BudgetYM) d on a.CategoryCode=d.CategoryCode and a.YM=d.BudgetYM and a.NodeCode=d.DeptCode 	     
    left join 
	    TB门店绩效表 c on a.CategoryCode=c.CategoryCode and a.YM=c.HappenYM and a.NodeCode=c.DeptCode and   c.CategoryItemCode ='0000' and len(c.CategoryCode)=1  
	        left join 
	    (select HappenYM,DeptCode,CategoryItemCode,left(CategoryCode,1)CategoryCode,sum(ProcePayMoney)+sum(TaxRateDiff)+sum(LossProfitMoney)+sum(Maoriadjustmentoftheprocessing)+sum(Incomeadjustment)kx from 
	    TB门店绩效表毛利扣减表
	    where CategoryItemCode='0000' and CategoryCode not in (39)
	    group by HappenYM,DeptCode,CategoryItemCode,left(CategoryCode,1))  e on a.CategoryCode=e.CategoryCode and a.YM=e.HappenYM and a.NodeCode=e.DeptCode 
	    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
	    order by len(a.CategoryCode ),1,4,6,5,7

	
	select YM month,a.NodeCode DeptCode ,
	ISNULL(b.Salesindex,0)TAXSalesindex,ISNULL(c.TAXSaleMoney,0)TAXSaleMoney,ISNULL(c.AfterTAXSaleMoney,0)AfterTAXSaleMoney,
	ISNULL(b.Grossprofitindex,0)TAXGrossprofitindex,ISNULL(c.TAXGross,0)TAXGross,ISNULL(c.AfterTAXGross,0)AfterTAXGross,
	ISNULL(D.Salesindex,0)Salesindex,ISNULL(c.SaleMoney,0)SaleMoney,ISNULL(c.AfterSaleMoney,0)AfterSaleMoney,
	ISNULL(D.Grossprofitindex,0)Grossprofitindex,ISNULL(c.Gross,0)Gross,ISNULL(c.AfterGross,0)AfterGross
	 from 
	(select YM,a.NodeCode  from 
	dbo.TB部门信息表 a,
	(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
	FROM master.dbo.spt_values
	WHERE type = 'p'
	    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
	    )a
	    left join 
	    (select DeptCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[含税分课预算表]A
    where CategoryItemCode ='0001' 
    group by DeptCode,BudgetYM
) b on  a.YM=b.BudgetYM and a.NodeCode=b.DeptCode 	       
    	    left join 
	    (select DeptCode,BudgetYM,sum(Salesindex)Salesindex,sum(Grossprofitindex) Grossprofitindex
     from .[无税分课预算表]A
    where CategoryItemCode ='0001' 
    group by DeptCode,BudgetYM
) d on a.YM=d.BudgetYM and a.NodeCode=d.DeptCode 	     
    left join 
	    TB门店绩效表 c on  a.YM=c.HappenYM and a.NodeCode=c.DeptCode and   c.CategoryItemCode ='0001' and CategoryCode='96'
	    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
	    order by 1,2

select ParentCategoryCode,CategoryCode,CategoryName+'收入' 收入名称,CategoryName+'占比' 占比名称,CategoryName+'税率' 税率名称,CategoryName+'毛利额' 毛利额名称,CategoryName+'毛利率' 毛利率名称
from [000]A.TBGOODSCATEGORY  
where CategoryItemCode='0000' and CategoryCode between 1 and 6 and len(CategoryCode )=1
union all 
select '','7','烟酒专柜收入','烟酒专柜占比','烟酒专柜税率','烟酒专柜毛利额','烟酒专柜毛利率'


select ParentCategoryCode,a.CategoryCode ,a.CategoryName,YM month,a.NodeCode DeptCode ,
ISNULL(b.Salesindex,0)Salesindex,ISNULL(c.TAXSaleMoney,0)TAXSaleMoney,isnull(c.SaleMoney,0)SaleMoney,ISNULL(c.AfterTAXSaleMoney,0)AfterTAXSaleMoney,isnull(c.AfterSaleMoney,0)AfterSaleMoney,
isnull(b.Grossprofitindex,0)Grossprofitindex,isnull(C.TAXGross,0)TaxGross,isnull(C.Gross,0)Gross,isnull(C.AfterTAXGross,0)AfterTaxGross,isnull(C.AfterGross,0)AfterGross from 
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select  b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and CategoryCode<>29   and CategoryCode<>19 
and left(b.NodeCode,1) between 1 and 2
and CategoryCode not in (28,23)
union all 

select  b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%'

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[无税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='0001'
            left join 
    TB门店绩效表 c on a.CategoryCode=c.CategoryCode and a.YM=c.HappenYM and a.NodeCode=c.DeptCode and   c.CategoryItemCode ='0001'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

 select a.NodeCode,a.nodename,left(a.defday,6)mm,a.defday,b.Salesindex,b.Grossprofitindex from 
 (select a.NodeCode,a.nodename,b.defday from 
 (select NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')  nodename   from 
TB部门信息表 a )a
,
(select convert(varchar(10),dateadd(dd,number,convert(varchar(8),'${qsrq}'+'01',112)),112)defday
from master..spt_values 
where type='p' and number <= datediff(dd,CONVERT(datetime,'${qsrq}'+'01'),convert(varchar,dateadd(day,-day('${jsrq}'+'01'),dateadd(month,1,'${jsrq}'+'01')),23) ))b

where 1=1 ${if(len(bm) == 0,   "","and nodecode in ('" + replace(bm,",","','")+"')") }
)a
 left join 
dbo.每日预算表 b on  a.NodeCode =b.DeptCode and a.defday=b.defday
order by 1,3



select ParentCategoryCode,a.CategoryCode ,a.CategoryName,LEFT(YM,4) YEAR,
 CASE       
 when RIGHT(YM,2) in('06','07','08')   then '第一季度'  
 when RIGHT(YM,2) in('09','10','11')   then '第二季度'   
 when  RIGHT(YM,2) in('12','01','02')  then '第三季度' 
 when RIGHT(YM,2) in('03','04','05')   then '第四季度'      end Quarter
,YM month,a.NodeCode DeptCode ,b.Salesindex,b.Grossprofitindex from 
(select ParentCategoryCode,CategoryCode ,CategoryName,YM,a.NodeCode  from 
(select  b.NodeCode,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName 
from dbo.TB商品分类表 a ,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=2 and left(CategoryCode,1) between 1 and 5
and CategoryCode<>29   and CategoryCode<>19 
and left(b.NodeCode,1) between 1 and 2
and CategoryCode not in (28,23)
union all 

select  b.NodeCode ,ParentCategoryCode,CategoryCode ,case when CategoryName='用品' then '用品/食品' when CategoryName='玩具' then '婴装/玩具'  when CategoryName='淘气堡' then '淘气堡/电玩' when CategoryName='男童' then '童装'  else  CategoryName end CategoryName
from dbo.TB商品分类表 a,dbo.TB部门信息表 b where CategoryItemCode='0000' and CategoryLevel=3 and CategoryCode in (610,611,613,620,621,622,642,640,641)
and b.NodeCode like '9%'

union all 

select  b.NodeCode ,'7' ParentCategoryCode,'39'CategoryCode ,'烟酒专柜' CategoryName
from dbo.TB部门信息表 b where  nodecode in (1042,1061,1058)

)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b
    )a
    left join 
    dbo.[含税分课预算表]A b on a.CategoryCode=b.CategoryCode and a.YM=b.BudgetYM and a.NodeCode=b.DeptCode and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    order by 2,4,6,5,7

    select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,a.YM YEAR,isnull(b.Salesindex,0)Salesindex from 
    (SELECT  a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,YM from 
    dbo.TB部门信息表 a  
,
    (SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB团购预算指标 b on a.NodeCode=b.deptcode  and a.YM=b.BudgetYM and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    

  select a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,a.YM YEAR,isnull(b.cardsales,0)cardsales,isnull(b.Employeecardsales,0)Employeecardsales from 
    (SELECT  a.AreaCode,a.AreaName,a.NodeCode,a.NodeName ,YM from 
    dbo.TB部门信息表 a  
,
    (SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'01'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'01') <= '${jsrq}'+'01')b)a
    left join 
    TB卡销售月表 b on a.NodeCode=b.deptcode  and a.YM=b.BudgetYM and   b.CategoryItemCode ='0000'
    where 1=1 ${if(len(bm) == 0,   "",   "and a.nodecode in ('" + replace(bm,",","','")+"')") } 
    

 DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX),@SQL2 VARCHAR(MAX),@SQL3 VARCHAR(MAX),
@jsny varchar(6), @qsny varchar(6),@qsrq varchar(6),@dqrq varchar(6)
set @jsny='${jsrq}'
set @qsny='${qsrq}'
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL SELECT * FROM [000]A.'+[name]A+' where SellCashierCode in (''777777'',''888888'')
and 1=1 ${if(len(bm) == 0,   "",   "and nodecode  in (''" + replace(bm,",","'',''")+"'')") }
' 
 FROM SYS.SYSOBJECTS WHERE type='U' AND SUBSTRING(name,9,99)= '_CASHIERMSUM' and SUBSTRING(name,3,6) between  @qsny and @jsny
 SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL='
select left(OccurDate,6)OccurDate,NodeCode  ,sum(SaleMoney)SaleMoney from 
('+@SQL1+')a
group by left(OccurDate,6),NodeCode


'exec(@sql)


select 
NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')   NodeName ,NodeCode+' '+replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'文城'),'麒龙缤纷城' ,'麒龙'),'地标广场' ,'地标店'),'七众奥莱' ,'七众'),'希望城' ,'') ,'华诚' ,''),'2010' ,''),'中建' ,''),'百货' ,''),'亿足鞋业' ,''),'遵义' ,''),'购物物流中心' ,'常温物流')  ,'配送中心' ,'生鲜物流'),'阳关站' ,''),'中央大街' ,'') ,'生活超市' ,'店'),'国腾商都' ,''),'太阳城' ,''),'运通广场' ,'运通'),'合力修文百货店' ,'修文文城店'),'合力修文百货一店' ,'修文店')Node
,OpenDate,WhetherNew,AreaCode,AreaName,FormatCode,FormatName
 from 
dbo.TB部门信息表 a

where   1=1 ${if (and(left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'1' , left(right(CONCATENATE(GETUSERDEPARTMENTS()),4),1)<>'2') ,""," and a.nodecode =" + right(CONCATENATE(GETUSERDEPARTMENTS()),4) + "")}


and  left(a.nodecode,1) between 1 and 2 and a.nodecode not in (6601) 

