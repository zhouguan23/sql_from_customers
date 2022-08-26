

select a.NodeCode,a.nodename,rq,OpenDate,
sum(TAXSaleindex)TAXSaleindex,sum(TAXSaleMoney)TAXSaleMoney,sum(Saleindex)Saleindex,sum(SaleMoney)SaleMoney,
sum(TAXGrossindex)TAXGrossindex,sum(TAXGross)TAXGross,sum(Grossindex)Grossindex,sum(Gross)Gross,
sum(AfterTAXSaleindex)AfterTAXSaleindex,sum(AfterTAXSaleMoney)AfterTAXSaleMoney,sum(AfterSaleindex)AfterSaleindex,
sum(AfterSaleMoney)AfterSaleMoney,sum(AfterTAXGrossindex)AfterTAXGrossindex,sum(AfterTAXGross)AfterTAXGross,sum(AfterGrossindex)AfterGrossindex,sum(AfterGross)AfterGross  from 
(select b.NodeCode,b.nodename,OpenDate rq,datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))OpenDate from 
hldw.dbo.TB部门信息表 b
where left(b.NodeCode,1) in (1,2)  and datediff(day,OpenDate,dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,'${jsrq}'+'01')+1, 0)))>=20 
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

