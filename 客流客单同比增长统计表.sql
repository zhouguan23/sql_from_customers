select a.deptcode,a.EnterAccountDate,a.SaleCount,A.SalePrice ,
CASE WHEN a.EnterAccountDate='1' THEN  B.SaleCount ELSE C.SaleCount END TQSaleCount,
CASE WHEN a.EnterAccountDate='1' THEN  B.SalePrice ELSE C.SalePrice END TQSalePrice

from 
(select a.deptcode,
case when DATEDIFF(day,b.OpenDate,convert(varchar,dateadd(yy,-1,convert(varchar,dateadd(day,-day('${YM}'+'01'),dateadd(month,1,'${YM}'+'01')),112)),112))>='20' then 0 else 1 end  EnterAccountDate
,sum(SaleCount)SaleCount,
case when  sum(SaleMoney)=0 or sum(SaleCount)=0 then 0 else  sum(SaleMoney)/sum(SaleCount)end SalePrice
 from 
TB${YM}_门店客单客流 a
left join 
TB部门信息表 b on a.deptcode=b.NodeCode
where CategoryLevel='0'  and (a.deptcode like '1%' or a.deptcode like '2%')
group by a.deptcode ,b.OpenDate )a
left join 
(select a.deptcode,
sum(SaleCount)SaleCount,
case when  sum(SaleMoney)=0 or sum(SaleCount)=0 then 0 else  sum(SaleMoney)/sum(SaleCount)end SalePrice
 from 
TB${HQYM}_门店客单客流 a
left join 
TB部门信息表 b on a.deptcode=b.NodeCode
where CategoryLevel='0'  and (a.deptcode like '1%' or a.deptcode like '2%')
group by a.deptcode  )B ON a.deptcode=B.deptcode
left join 
(select a.deptcode,
sum(SaleCount)SaleCount,
case when  sum(SaleMoney)=0 or sum(SaleCount)=0 then 0 else  sum(SaleMoney)/sum(SaleCount)end SalePrice
 from 
TB${TQYM}_门店客单客流 a
left join 
TB部门信息表 b on a.deptcode=b.NodeCode
where CategoryLevel='0'  and (a.deptcode like '1%' or a.deptcode like '2%')
group by a.deptcode  )C ON a.deptcode=C.deptcode
where 1=1 ${if(len(bm) == 0,   "",   "and a.deptcode in ('" + replace(bm,",","','")+"')") }
order by a.deptcode



