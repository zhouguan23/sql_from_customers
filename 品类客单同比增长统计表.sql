select a.GoodsCatCode,A.SaleMoney,a.SaleCount ,B.SaleMoney TQSaleMoney,B.SaleCount	TQSaleCount 

from 
(select case when a.GoodsCatCode='2' then '1' else a.GoodsCatCode end GoodsCatCode,sum(SaleMoney)SaleMoney,
sum(SaleCount)SaleCount
 from 
TB${YM}_门店客单客流 a
left join 
TB部门信息表 b on a.deptcode=b.NodeCode
where CategoryLevel='1'  and (a.deptcode like '1%' or a.deptcode like '2%')
and left(GoodsCatCode,1) between 1 and 5
and case when DATEDIFF(day,b.OpenDate,convert(varchar,dateadd(yy,-1,convert(varchar,dateadd(day,-day('201812'+'01'),dateadd(month,1,'201812'+'01')),112)),112))>='20' then 0 else 1 end=0
group by case when a.GoodsCatCode='2' then '1' else a.GoodsCatCode end 
)a
left join 
(select case when a.GoodsCatCode='2' then '1' else a.GoodsCatCode end GoodsCatCode,
sum(SaleMoney)SaleMoney,
sum(SaleCount)SaleCount
 from 
TB${TQYM}_门店客单客流 a
left join 
TB部门信息表 b on a.deptcode=b.NodeCode
where CategoryLevel='1'  and (a.deptcode like '1%' or a.deptcode like '2%')
and left(GoodsCatCode,1) between 1 and 5
and case when DATEDIFF(day,b.OpenDate,convert(varchar,dateadd(yy,-1,convert(varchar,dateadd(day,-day('201812'+'01'),dateadd(month,1,'201812'+'01')),112)),112))>='20' then 0 else 1 end=0
group by case when a.GoodsCatCode='2' then '1' else a.GoodsCatCode end 
 )B ON a.GoodsCatCode=B.GoodsCatCode

order by a.GoodsCatCode



