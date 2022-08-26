

select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,b.CategoryCode bm from 
[HLDW]A.[dbo]A.tb分类对照表 a
left join 
[HLDW]A.[dbo]A.tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'

where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%' )a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0000' and HappenYM between '${qsrq}' and '${jsrq}'   and CategoryLevel='2' and CategoryCode not in ('95','96')
group by DeptCode,CategoryCode)b on a.NodeCode =b.DeptCode  and a.bm=b.CategoryCode
    group by a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,6,5




select a.NodeCode,a.nodename,rq,OpenDate,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,
sum(isnull(b.ProcePayMoney,0))ProcePayMoney,sum(isnull(b.TaxRateDiff,0) )TaxRateDiff,
sum(isnull(b.LossProfitMoney,0))LossProfitMoney,sum(isnull(b.Newstoreortaxrate,0))Newstoreortaxrate,
sum(isnull(b.Maoriadjustmentoftheprocessing,0))Maoriadjustmentoftheprocessing,sum(isnull(b.Incomeadjustment,0))Incomeadjustment from 
(select b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,c.CategoryCode bm from 
[HLDW]A.[dbo]A.tb分类对照表 a
left join 
[HLDW]A.[dbo]A.tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0000'
left join 
[HLDW]A.[dbo]A.tb分类对照表 c on b.CategoryCode=c.ParentCategoryCode and c.CategoryItemCode='0000'
where a.CategoryItemCode='0000' and a.CategoryLevel='0' and a.CategoryCode not like '9%')a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
TB门店绩效表毛利扣减表 b on a.NodeCode =b.DeptCode  and a.bm=b.CategoryCode and HappenYM between '${qsrq}' and '${jsrq}'
    group by a.NodeCode,a.nodename,rq,OpenDate,a.ParentCategoryCode,a.CategoryCode ,a.CategoryName
order by 2,6,5





select  CategoryItemCode,CategoryCode,'(黔惠)'+CategoryName CategoryName,ParentCategoryCode,CategoryLevel from 
tb分类对照表
where CategoryItemCode in ('0000') and CategoryLevel=0 and CategoryCode not in ('7')
union all 
select  CategoryItemCode,case when CategoryCode='31' then '33' else CategoryCode end CategoryCode,'(黔惠)'+CategoryName CategoryName,ParentCategoryCode,CategoryLevel from 
tb分类对照表
where CategoryItemCode in ('0007') and CategoryLevel=1





select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName,bm from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,b.CategoryCode,b.CategoryName,b.CategoryCode bm from 
[HLDW]A.[dbo]A.tb分类对照表 a
left join 
[HLDW]A.[dbo]A.tb分类对照表 b on a.CategoryCode=b.ParentCategoryCode and b.CategoryItemCode='0001'

where a.CategoryItemCode='0001' and a.CategoryLevel='0' and a.CategoryCode not like '9%')a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0001' and HappenYM between '${qsrq}' and '${jsrq}'   and CategoryLevel='2' and CategoryCode not in ('95','96')
group by DeptCode,CategoryCode)b on a.NodeCode =b.DeptCode  and a.bm=b.CategoryCode
    group by a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,6,5


select  * from 
tb分类对照表
where CategoryItemCode='0000' and CategoryLevel<=1

union all 
select  * from 
tb分类对照表
where CategoryItemCode='0001' and CategoryCode in (95,96)



select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,a.CategoryCode,a.CategoryName from 
[HLDW]A.[dbo]A.tb分类对照表 a

where a.CategoryItemCode='0000' and a.CategoryLevel='0' )a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20 
and a.CategoryCode  not like '9%'
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0000' and HappenYM between '${qsrq}' and '${jsrq}'  and CategoryLevel=1 and CategoryCode not in ('91','92','93','94')
group by DeptCode,CategoryCode
union all 
select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0000' and HappenYM between '${qsrq}' and '${jsrq}'  and CategoryLevel='2' and CategoryCode in ('91','92','93','94')
group by DeptCode,CategoryCode

)b on a.NodeCode =b.DeptCode  and a.CategoryCode=b.CategoryCode
    group by a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,6,5



select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,a.CategoryCode,a.CategoryName from 
[HLDW]A.[dbo]A.tb分类对照表 a

where a.CategoryItemCode='0001' and a.CategoryLevel='0' and a.CategoryCode  not like '9%')a
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0001' and HappenYM between '${qsrq}' and '${jsrq}'  and CategoryLevel='1' and CategoryCode not in ('91','92','93','94')
group by DeptCode,CategoryCode
union all 
select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0001' and HappenYM between '${qsrq}' and '${jsrq}'  and CategoryLevel='2' and CategoryCode in ('95','96')
group by DeptCode,CategoryCode

)b on a.NodeCode =b.DeptCode  and a.CategoryCode=b.CategoryCode
    group by a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,6,5



select a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1)ParentCategoryCode,left(a.CategoryCode,2)CategoryCode,a.CategoryName,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select a.CategoryItemCode,b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate,
a.ParentCategoryCode,a.CategoryCode ,a.CategoryName from 
[HLDW]A.[dbo]A.TB部门信息表 b,
(select a.CategoryItemCode,a.CategoryCode ParentCategoryCode,a.CategoryCode,a.CategoryName from 
[HLDW]A.[dbo]A.tb分类对照表 a

where a.CategoryItemCode in ('0000','0001') and a.CategoryLevel='0' )a
where left(b.NodeCode,1) in (1,2)  and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20 and a.CategoryCode  like '9%'
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(
select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode in ('0000','0001') and HappenYM between '${qsrq}' and '${jsrq}'  and len(CategoryCode)=2 and CategoryCode in ('91','92','93','94','96','95')
group by DeptCode,CategoryCode

)b on a.NodeCode =b.DeptCode  and a.CategoryCode=b.CategoryCode
    group by a.NodeCode,a.nodename,rq,OpenDate,left(a.ParentCategoryCode,1),left(a.CategoryCode,2) ,a.CategoryName

order by 1,6,5



select a.NodeCode,a.nodename,rq,OpenDate,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate from 
[HLDW]A.[dbo]A.TB部门信息表 b
where left(b.NodeCode,1) in (1,2)  
--and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20 
and 1=1 ${if(len(bm) == 0,   "",   "and b.nodecode in ('" + replace(bm,",","','")+"')") }
)a
left join 
(select DeptCode,CategoryCode,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross
 from 
TB门店绩效表
where CategoryItemCode='0000' and HappenYM between '${qsrq}' and '${jsrq}'  and len(CategoryCode)=0 
group by DeptCode,CategoryCode


)b on a.NodeCode =b.DeptCode  
    group by a.NodeCode,a.nodename,rq,OpenDate

order by 1

