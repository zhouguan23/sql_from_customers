select a.goods_code 商品代码,
a.goods_name 品名,
a.specification 规格,
a.manufacturer 厂家,
b.buyer 采购经理,
sum(a.zykc_qty) 区域直营店库存数量, 
sum(a.zykc_amount) 区域直营店仓库成本,  
sum(a.jmkc_qty) 区域加盟店库存数量	,
sum(a.jmkc_amount) 区域加盟店库存成本,	
sum(a.zyxs_qty) 区域直营店销售数量,
sum(a.zyxs_cost) 区域直营店销售成本,	
sum(a.jmxs_qty) 区域加盟店销售数量,
sum(a.jmps_qty) 区域加盟店配送数量,
sum(a.jmps_cost) 区域加盟店配送成本,
sum(a.pfps_qty) 区域外部客户批发数量,
sum(a.pfps_cost) 区域外部客户批发成本
from DM_PURCHASE_SALE_STOCK_GOODS a, DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code!='00'
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and a.date1='${date}'
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.goods_code,
a.goods_name ,
a.specification ,
a.manufacturer ,
b.buyer 
order by a.goods_code

select distinct buyer from DIM_NET_CATALOGUE_GENERAL
where new_or_old='正常'



/*--总部配送
select a.goods_code,to_char(sale_date,'yyyy-mm') as date1,
b.buyer,sum(Delivery_QTY) 总部配送数量,
sum(no_tax_cost) 总部配送成本
from FACT_delivery a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and to_char(sale_date,'yyyy-mm')=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code='00'
and to_char(sale_date,'yyyy-mm')='${date}'
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
group by a.goods_code,to_char(sale_date,'yyyy-mm') ,b.buyer*/


--总部配送
select a.goods_code,to_char(sale_date,'yyyy-mm') as date1,
b.buyer,sum(Delivery_QTY) 总部配送数量,
sum(no_tax_cost) 总部配送成本
from dim_dtp c right join fact_delivery a 
on a.goods_code=c.goods_code
and a.area_code=c.area_code
and to_char(a.sale_date,'YYYY-MM')=c.create_month
left join dim_net_catalogue_general b
on a.goods_code=b.goods_code
and to_char(a.sale_date,'YYYY-MM')=b.create_month
where b.NEW_OR_OLD='正常' 
and a.area_code='00'
and to_char(sale_date,'yyyy-mm')='${date}'
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
AND 1=1 ${if(len(dtp)=0,""," and (case when c.goods_code is null then '否' else '是' end) = '"+dtp+"'")} 
group by a.goods_code,to_char(sale_date,'yyyy-mm') ,b.buyer

select distinct a.goods_code as goods_code,a.goods_code||'|'||b.goods_name as goods_name 
from DIM_NET_CATALOGUE_GENERAL a ,dim_goods b
where new_or_old='正常' 
and a.goods_code=b.goods_code
order by a.goods_code





--月初总部库存成本+区域大仓库存成本+直营门店库存成本
select a.goods_code,a.date1,b.buyer,
nvl(sum(a.zykc_amount),0)+nvl(sum(a.dckc_amount),0) 
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and to_date(a.date1,'yyyy-MM')=add_months(to_date('${date}','yyyy-MM'),-1)
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.goods_code,a.date1,b.buyer


--月初总部库存成本
select a.goods_code,a.date1,b.buyer，
sum(a.dckc_amount) 
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code='00'
and to_date(a.date1,'yyyy-MM')=add_months(to_date('${date}','yyyy-MM'),-1)
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.goods_code,a.date1,b.buyer


--区域大仓库存
select a.goods_code,a.date1,b.buyer,sum(dckc_qty) 区域大仓库存数量,
sum(a.dckc_amount) 区域大仓库存成本
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code!='00'
and a.date1='${date}'
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.goods_code,a.date1,b.buyer

--总部库存
select a.goods_code,a.date1,b.buyer,sum(dckc_qty) 总部库存数量,
sum(a.dckc_amount) 总部库存成本
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and a.area_code='00'
and a.date1='${date}'
and 1=1 
${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 
${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
group by a.goods_code,a.date1,b.buyer

--总部当前库存数量
select goods_code,sum(stock_qty)总部当前库存数量 from dm_stock_general_day
where area_code='00'
and 1=1 
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}
group by goods_code


select goods_code,sum(stock_qty)区域大仓当前库存数量 from dm_stock_general_day
where area_code!='00'
and 1=1 
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}
group by goods_code

--区域直营店当前库存数量
select goods_code,sum(stock_qty) from dm_stock_shop_day a,dim_cus b
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.attribute='直营'
and a.area_code!='00'
and 1=1 
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}
group by goods_code

--区域加盟店当前库存数量
select goods_code,sum(stock_qty) from dm_stock_shop_day a,dim_cus b
where a.area_code=b.area_code
and a.cus_code=b.cus_code
and b.attribute='加盟'
and a.area_code!='00'
and 1=1 
${if(len(gcode)=0,""," and goods_code in ('"+gcode+"')")}
group by goods_code

select distinct a.goods_code 商品代码,
a.goods_name 品名,
a.specification 规格,
a.manufacturer 厂家,
b.buyer 采购经理
from DM_PURCHASE_SALE_STOCK_GOODS a, DIM_NET_CATALOGUE_GENERAL b
where a.goods_code=b.goods_code
and a.date1=b.create_month 
and b.NEW_OR_OLD='正常' 
and 1=1 ${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and a.date1='${date}'
and 1=1 ${if(len(buyer)=0,""," and b.buyer in ('"+buyer+"')")}
and 1=1 ${if(len(dtp)=0,"","and a.dtp ='"+dtp+"'")}
order by a.goods_code

