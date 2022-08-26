
 select NodeCode,SellCashierCode ,SellCashierName,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney from 
 (select NodeCode,SellCashierCode ,SellCashierName,sum(SaleCount)SaleCount,sum(SaleMoney)SaleMoney	 from 
tb${YM}_CASHIERMSUM
group by NodeCode,SellCashierCode ,SellCashierName
union all 
select a.DeptCode,a.SellCashierCode,a.SellCashierName,0-COUNT(distinct a.BillNumber )SaleCount,0-(SUM(SaleEarning)+SUM(SaleTax))SaleMoney
 from 
tb${YM}_SALEBILL a,tb${YM}_SALERENTDETAIL b
where IsOutRule=0  and CancelFlag ='0' and A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode  and b.goodscode like '0%'
group by  a.DeptCode,a.SellCashierCode,a.SellCashierName
union all 
select a.DeptCode,a.SellCashierCode,a.SellCashierName,0-COUNT(distinct a.BillNumber )SaleCount,0-(SUM(SaleEarning)+SUM(SaleTax))SaleMoney
 from 
tb${YM}_SALEBILL a,tb${YM}_SALEBILLDETAIL b
where IsOutRule=0  and CancelFlag ='0' and A.BillNumber =B.BillNumber AND A.DeptCode =B.DeptCode  and b.GoodsCode like '35%'

group by  a.DeptCode,a.SellCashierCode,a.SellCashierName

)a
where   1=1 ${if(len(bm) == 0,   "",   "and a.NodeCode in ('" + replace(bm,",","','")+"')") }
 group by a.NodeCode,a.SellCashierCode,a.SellCashierName
order by 1,2

