select distinct buyer from DIM_NET_CATALOGUE_GENERAL
where new_or_old='正常'


--总部配送
select to_char(sale_date,'yyyy-mm') as date1,
b.buyer,
sum(no_tax_cost) 总部配送成本 from dim_dtp c right join fact_delivery a 
on a.goods_code=c.goods_code
and a.area_code=c.area_code
and to_char(a.sale_date,'YYYY-MM')=c.create_month
left join dim_net_catalogue_general b
on a.goods_code=b.goods_code
and to_char(a.sale_date,'YYYY-MM')=b.create_month
where b.NEW_OR_OLD='正常' 
and a.area_code='00'
and to_char(sale_date,'yyyy-mm')='${date}'
and 1=1 ${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when c.goods_code is null then '否' else '是' end) = '"+dtp+"'")} 
group by to_char(sale_date,'yyyy-mm') ,b.buyer

--月初总部库存成本+区域大仓库存成本+直营门店库存成本
select a.date1,b.buyer,
nvl(sum(a.zykc_amount),0)+nvl(sum(a.dckc_amount),0)
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and to_date(a.date1,'yyyy-MM')=add_months(to_date('${date}','yyyy-MM'),-1)

and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.date1,b.buyer


--月初总部库存成本
select a.date1,b.buyer,
sum(a.dckc_amount) 
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code='00'
and to_date(a.date1,'yyyy-MM')=add_months(to_date('${date}','yyyy-MM'),-1)
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.date1,b.buyer


select 
b.buyer 采购经理,
sum(a.zykc_amount) 区域直营店仓库成本,  
sum(a.jmkc_amount) 区域加盟店库存成本,  
sum(a.zyxs_cost) 区域直营店销售成本,  
sum(a.jmps_cost) 区域加盟店配送成本,
sum(a.dckc_amount) 区域大仓库存成本,
sum(a.pfps_cost) 区域外部客户批发成本
from DM_PURCHASE_SALE_STOCK_GOODS a, DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code!='00'
and a.date1='${date}'
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by b.buyer

--总部库存
select b.buyer,
sum(a.dckc_amount) 总部库存成本
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code='00'
and a.date1='${date}'
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by b.buyer

select 
distinct b.buyer 采购经理
from DM_PURCHASE_SALE_STOCK_GOODS a, DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.date1='${date}'
and 1=1 ${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by b.buyer

