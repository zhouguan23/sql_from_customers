select * from 
TB预算科目
where 
CategoryLevel='3'
order by 2,4,5

select CategoryItemCode,CategoryCode,CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel>='0' and CategoryItemCode ='0000'
order by 1,6,5,cast(CategoryCode as int)

select left(a.GoodsCode,1) CategoryCode,a.YM,sum(b.Salesindex)TaxSalesindex,sum(b.Grossprofitindex)TaxGrossprofitindex,sum(c.Salesindex)Salesindex,sum(c.Grossprofitindex)Grossprofitindex from 
(select a.DeptCode,a.GoodsCode,b.YM from
(select distinct c.DeptCode,b.GoodsCode from 
TB分类对照表 a
left join 
tbCatToGoods b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
left join 
tbCatToDept  c on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode and b.CategoryCode=c.CategoryCode
where  a.CategoryItemCode='0003' and  CHARINDEX ('${bm}',a.CategoryLengCode)>0)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906')b)a
left join 
含税分课预算表 b on a.GoodsCode=b.CategoryCode and a.DEPTcode=b.DeptCode and a.YM=b.BudgetYM and b.CategoryItemCode='0000'  
left join 
无税分课预算表 c on a.GoodsCode=c.CategoryCode and a.DEPTcode=c.DeptCode and a.YM=c.BudgetYM and c.CategoryItemCode='0000'  

group by  left(a.GoodsCode,1),a.YM
order by 1,2


select * from 
TB营业外收入预算表
where deptcode in (select CategoryCode
from  TB分类对照表 where CategoryItemCode='0003' and CategoryLengCode like '${bm}%') and BudgetYM like '${qsrq}%'

${if(js == "1","
select case when rank()  over(order by CategoryLevel)=1 then '' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+' '+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode='0003' and CategoryLevel>=0
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)","
DECLARE @SQL VARCHAR(MAX),@SQL1 VARCHAR(MAX)
SET @SQL1=''
SELECT @SQL1=@SQL1+' UNION ALL 
select case when rank()  over(order by CategoryLevel)=1 then '''' else  ParentCategoryCode end  F_ID,CategoryCode ID,CategoryCode, CategoryCode+'' ''+CategoryName  CategoryName,ParentCategoryCode,CategoryLevel,CategoryLengCode from 
TB分类对照表 a
where a.CategoryItemCode=''0003''
and  CHARINDEX ('''+CategoryLengCode+''',a.CategoryLengCode)>0
 ' 
 FROM  [HLCWDW]A.[dbo]A.[tbCatToOperator]A a
  left join 
  [HLCWDW]A.[dbo]A.[TB分类对照表]A b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
  WHERE a.CategoryItemCode='0003' and a.OperatorCode in (select distinct 部门编码 from tb职员用户表 where 职员编码='"+gh+"')


SET @SQL1=STUFF(@SQL1,1,11,'')

SET @SQL='
select * from 
('+@sql1+')a
order by a.CategoryLevel,convert(int,a.ParentCategoryCode),convert(int,a.CategoryCode)
'exec(@sql)")}


select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' 


select '${qsrq}'+'00'YM
union all 
SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906'


select * from 
TB部门费用预算表
where deptcode in (select CategoryCode
from  TB分类对照表 where CategoryItemCode='0003' and CategoryLengCode like '${bm}%') and BudgetYM like '${qsrq}%'

select ParentCategoryCode F_ID,CategoryCode ID,CategoryCode,CategoryName,ParentCategoryCode,CategoryLevel from 
TB分类对照表 a
where a.CategoryItemCode='0003' 
and  CHARINDEX ('${bm}',a.CategoryLengCode)>0


select * from 
TB部门费用预算表
where deptcode='${bm}' and BudgetYM like '${qsrq}%'

select DeptCode,CategoryItemCode,CategoryCode,BudgetYM,accounting+Differential+Withholding ChargeMoney from 
tb费用调整表
where deptcode in (select CategoryCode
from  TB分类对照表 where CategoryItemCode='0003' and CategoryLengCode like '${bm}%') and BudgetYM like '${qsrq}%'

select a.ChargeDeptCode DeptCode,a.CostCoding,a.BuildYM,sum(CEMoneyext)CEMoneye from 
TB费用报销单  a
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.[ACT_HI_PROCINST]A b on a.BillNumber=b.BUSINESS_KEY_
left join 
opendatasource( 'SQLOLEDB ',  'Data Source=192.100.0.16\sql2008;User ID=sa;Password=85973099hlxxb!@# '). [fine]A.[dbo]A.act_hi_varinst c on c.NAME_='process_state'  
and  b.PROC_INST_ID_=c.PROC_INST_ID_  
where a.BuildDate like '${qsrq}%' and a.ChargeDeptCode in (select CategoryCode
from  TB分类对照表 where CategoryItemCode='0003' and CategoryLengCode like '${bm}%') and case when len(a.AdaltState)=0 then c.TEXT_ else a.AdaltState end not in ('-1','7','9')
group by ChargeDeptCode,CostCoding,BuildYM



select left(a.GoodsCode,1) CategoryCode,a.YM,sum(b.Salesindex)TaxSalesindex,sum(b.Grossprofitindex)TaxGrossprofitindex from 
(select a.DeptCode,a.GoodsCode,b.YM from
(select distinct c.DeptCode,b.GoodsCode from 
TB分类对照表 a
left join 
tbCatToGoods b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
left join 
tbCatToDept  c on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode and b.CategoryCode=c.CategoryCode
where  a.CategoryItemCode='0003' and  CHARINDEX ('${bm}',a.CategoryLengCode)>0)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906')b)a
left join 
含税分课预算表 b on a.GoodsCode=b.CategoryCode and a.DEPTcode=b.DeptCode and a.YM=b.BudgetYM and b.CategoryItemCode='0001'  

group by  left(a.GoodsCode,1),a.YM
order by 1,2


select left(a.GoodsCode,1) CategoryCode,a.YM,sum(b.AfterTAXSaleMoney)TaxSaleMoney,sum(b.AfterTAXGross)TaxGrossprofit,sum(b.AfterSaleMoney)Salesindex,sum(b.AfterGross)Grossprofit from 
(select distinct a.DeptCode,left(a.GoodsCode,1) GoodsCode,b.YM from
(select distinct c.DeptCode,b.GoodsCode from 
TB分类对照表 a
left join 
tbCatToGoods b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
left join 
tbCatToDept  c on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode and b.CategoryCode=c.CategoryCode
where  a.CategoryItemCode='0003' and  CHARINDEX ('${bm}',a.CategoryLengCode)>0)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906')b)a
left join 
TB门店绩效表 b on a.GoodsCode=case when b.CategoryCode like '7' then '3' else b.CategoryCode end  and a.DEPTcode=b.DeptCode and a.YM=b.HappenYM and b.CategoryItemCode='0000' and CategoryLevel='1' and b.CategoryCode not in ('91','92','93','94')


group by  left(a.GoodsCode,1),a.YM
order by 1,2

select left(a.GoodsCode,1) CategoryCode,a.YM,sum(b.AfterTAXSaleMoney)TaxSaleMoney,sum(b.AfterTAXGross)TaxGrossprofit,sum(b.AfterSaleMoney)SalesMoney,sum(b.AfterGross)Grossprofit from 
(select distinct a.DeptCode,left(a.GoodsCode,1) GoodsCode,b.YM from
(select distinct c.DeptCode,b.GoodsCode from 
TB分类对照表 a
left join 
tbCatToGoods b on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode
left join 
tbCatToDept  c on a.CategoryItemCode=b.CategoryItemCode and a.CategoryCode=b.CategoryCode and b.CategoryCode=c.CategoryCode
where  a.CategoryItemCode='0003' and  CHARINDEX ('${bm}',a.CategoryLengCode)>0)a,
(SELECT CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112) AS YM
FROM master.dbo.spt_values
WHERE type = 'p'
    AND DATEADD(month,number,'${qsrq}'+'0101') <= '${qsrq}'+'1201'
    AND CONVERT(varchar(6),DATEADD(month,number,'${qsrq}'+'0101'),112)>='201906')b)a
left join 
TB门店绩效表 b on a.GoodsCode=case when b.CategoryCode like '7' then '3' else b.CategoryCode end  and a.DEPTcode=b.DeptCode and a.YM=b.HappenYM and b.CategoryItemCode='0001' and CategoryLevel='1' and b.CategoryCode not in ('91','92','93','94')


group by  left(a.GoodsCode,1),a.YM
order by 1,2


select CategoryItemCode,CategoryCode,CategoryName,Controllable,case when ParentCategoryCode=CategoryItemCode then '' else ParentCategoryCode end ParentCategoryCode,CategoryLevel  from 
TB费用科目表
where  CategoryLevel>='0' and CategoryItemCode ='0001'
order by 1,6,5,cast(CategoryCode as int)

select DeptCode,CategoryItemCode,CategoryCode,BudgetYM,Income from 
TB营业外收入表
where deptcode in (select CategoryCode
from  TB分类对照表 where CategoryItemCode='0003' and CategoryLengCode like '${bm}%') and BudgetYM like '${qsrq}%'

