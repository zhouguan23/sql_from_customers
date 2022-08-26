
select
a.*,
b.STOCK_QTY QTY1,
c.STOCK_QTY QTY2,
d.STOCK_QTY QTY3
from
(
select 
area_code,
goods_code,
NEW_ATTRIBUTE,
MANAGER,
cp_type,
NEW_OR_OLD
 from DIM_NET_CATALOGUE_GENERAL_ALL
where create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
--and area_code='00'
)a 
left join
(
select * from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-1)
) b 
on a.area_code=b.area_code and a.goods_code=b.goods_code
left join
(
select * from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-2)
) c 
on a.area_code=b.area_code and a.goods_code=b.goods_code
left join
(
select * from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-3)
) d 
on a.area_code=b.area_code and a.goods_code=b.goods_code


select max(area_price) area_price,a.area_code,a.goods_code 

from DIM_GOODS_MAPPING a,DIM_NET_CATALOGUE_GENERAL_ALL b
where a.area_code=b.area_code and a.goods_code=b.goods_code
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
group by a.area_code,a.goods_code

select
a.GOODS_CODE,
a.area_code,
(select count(*) from DIM_DAY
where month_id=to_char(trunc(sysdate-1),'yyyy-MM')
and ddate<trunc(sysdate)) day_num,
sum( DELIVERY_QTY) qty_now
from fact_delivery_new a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.sale_date>=trunc(add_months(last_day(sysdate), -1) + 1)
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
--and a.area_code='00'
group by a.GOODS_CODE,a.area_code

select
distinct
goods_code,
goods_name,
goods_code||'|'||goods_name
from dim_goods
where 1=1
${if(len(goodn)=0,"","and goods_code IN ('"+goodn+"')")}

select * from 
(select 
a.area_code,
a.goods_code,
a.supplier_code,
a.SUPPLIER_NAME,
a.order_date,
a.no_tax_price,
row_number()over(partition by a.goods_code,a.area_code order by a.order_date desc )rn
from fact_purchase a,DIM_NET_CATALOGUE_GENERAL_ALL b

where  
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.procurement_type='采进'
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
and no_tax_price>=0
)t
where t.rn=1
and 1=1
${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1
${if(len(gcode)=0, "", " and goods_code in ('" + gcode + "')")}


select 
a.area_code,
a.goods_code,
a.GOODS_NAME,
a.MANUFACTURER,
a.SPECIFICATION,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then JMPS_QTY end),0)) sqty1,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then JMPS_QTY end),0)) sqty2,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then JMPS_QTY end),0)) sqty3,

sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then ZYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') then JMPS_QTY end),0)) pqty1,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then ZYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') then JMPS_QTY end),0)) pqty2,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then ZYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') then JMPS_QTY end),0)) pqty3
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
a.area_code=b.area_code and a.goods_code=b.goods_code
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
and date1>=to_char(add_months(trunc(sysdate),-3),'yyyy-MM')
group by a.area_code,
a.goods_code,
a.GOODS_NAME,
a.MANUFACTURER,
a.SPECIFICATION


select *
from (
select

a.goods_code,
a.BUYER MANAGER,
a.NEW_OR_OLD,
nvl(b.STOCK_QTY,0) QTY1,
nvl(c.STOCK_QTY,0) QTY2,
nvl(d.STOCK_QTY,0) QTY3,
i.MANUFACTURER,
i.SPECIFICATION,
case when e.sqty1>=8000 then (m.lead_time+15)/30*e.sqty1
when e.sqty1<8000 and e.sqty1>=3000 then (m.lead_time+10)/30*e.sqty1
when e.sqty1<3000  then (m.lead_time+5)/30*e.sqty1 end as min_qty,
e.sqty1,
e.sqty2,
e.sqty3,
e.sqty_now,
e.pqty1,
e.pqty2,
e.pqty3,
f.day_num,
nvl(f.qty_now,0) qty_now,
g.supplier_code,
g.SUPPLIER_NAME,
g.no_tax_price,
h.area_price,
h.EFFECTIVE_MONTH,
i.goods_name,
i.LOAD,
i.UNIT,
i.TAX_RATE,
j.flag,
k.uom_name,
case when j.flag is null then '否' else '是' end as cp_type,
decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30) as 要货前配送周转,
decode(f.day_num,0,0,f.qty_now/f.day_num*30) as 预计本月配送,
decode(f.qty_now,0,0,nvl(b.STOCK_QTY,0)/(f.qty_now/f.day_num*30)*30) as 要货前预估周转,
case when decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30)>45 then '暂缓要货'
when decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30)>30 and decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30)<=45 then '进货'
when decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30)<=30 and decode(e.pqty1,0,0,nvl(b.STOCK_QTY,0)/e.pqty1*30)>=0 then '紧急进货' end as 是否进货,
nvl(l.sd_qty,0) sd_qty,
m.lead_time,
nvl(m.repl_qty,0) repl_qty,
nvl(m.min_order_qty,0) min_order_qty,
nvl(m.onorder_qty,0) onorder_qty,
nvl(m.mandatary_name_mom,'') mandatary_name_mom,
m.CG_FLAG,
nvl(b.STOCK_QTY,0)+nvl(m.onorder_qty,0) 要货后配送周转
from
(
select 
distinct
goods_code,
MANAGER,
NEW_OR_OLD,
BUYER
 from DIM_NET_CATALOGUE_GENERAL_ALL
where create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
--and area_code='00'
and goods_code in(select 
distinct
goods_code
 from DIM_NET_CATALOGUE_GENERAL3
where create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL3)
and  cp_type='总仓配送'
)
)a 
left join
(
select goods_code,AVI_QTY as STOCK_QTY from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-1) and area_code='00'
) b 
on   a.goods_code=b.goods_code
left join
(
select goods_code,AVI_QTY as STOCK_QTY from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-2) and area_code='00'
) c 
on  a.goods_code=c.goods_code
left join
(
select goods_code,AVI_QTY as STOCK_QTY from
DM_NET_CATALOGUE_GENERAL_STOCK
where date1=trunc(date'${date1}'-3) and area_code='00'
) d 
on  a.goods_code=d.goods_code



left join
(
select 
 
a.goods_code,

sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and b.cp_type<>'统签分采' then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and b.cp_type<>'统签分采' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and b.cp_type<>'统签分采' then JMPS_QTY end),0)) sqty1,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and b.cp_type<>'统签分采' then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and b.cp_type<>'统签分采' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and b.cp_type<>'统签分采' then JMPS_QTY end),0)) sqty2,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and b.cp_type<>'统签分采' then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and b.cp_type<>'统签分采' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and b.cp_type<>'统签分采' then JMPS_QTY end),0)) sqty3,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),0),'yyyy-MM') and b.cp_type<>'统签分采' then ZYXS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),0),'yyyy-MM') and b.cp_type<>'统签分采' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),0),'yyyy-MM') and b.cp_type<>'统签分采' then JMPS_QTY end),0)) sqty_now,

sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and a.area_code='00' then GLJYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and a.area_code='00' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-1),'yyyy-MM') and a.area_code='00' then JMPS_QTY end),0)
) pqty1,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and a.area_code='00' then GLJYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and a.area_code='00' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-2),'yyyy-MM') and a.area_code='00' then JMPS_QTY end),0)
) pqty2,
sum(nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and a.area_code='00' then GLJYPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and a.area_code='00' then PFPS_QTY end),0)
+nvl((case when date1=to_char(add_months(trunc(sysdate),-3),'yyyy-MM') and a.area_code='00' then JMPS_QTY end),0)
) pqty3
from DM_PURCHASE_SALE_STOCK_GOODS a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
a.area_code=b.area_code and a.goods_code=b.goods_code 
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
and date1>=to_char(add_months(trunc(sysdate),-3),'yyyy-MM')
group by  
a.goods_code
)e on   a.goods_code=e.goods_code


left join
(
select
a.GOODS_CODE,

(select count(*) from DIM_DAY
where month_id=to_char(trunc(sysdate-1),'yyyy-MM')
and ddate<trunc(sysdate)) day_num,
sum( DELIVERY_QTY) qty_now
from fact_delivery_new a,DIM_NET_CATALOGUE_GENERAL_ALL b
where 
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.sale_date>=trunc(add_months(last_day(sysdate), -1) + 1)
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)
and a.area_code='00'  
group by a.GOODS_CODE 
)f on a.goods_code=f.goods_code 


left join
(
select * from 
(select 
a.area_code,
a.goods_code,
a.supplier_code,
a.SUPPLIER_NAME,
a.order_date,
a.no_tax_price,

row_number()over(partition by a.goods_code  order by a.order_date desc )rn
from fact_purchase a,DIM_NET_CATALOGUE_GENERAL_ALL b

where  
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.procurement_type='采进'
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
--and no_tax_price>=0
and a.area_code='00'
)t
where t.rn=1
and 1=1
 
)g on   a.goods_code=g.goods_code 

left join
(
select distinct sale_price area_price
,EFFECTIVE_MONTH
,item  goods_code
from cmx_item_area_attributes where area_code='100'
)h on   a.goods_code=h.goods_code

left join
(
select
goods_code,
goods_name,
SPECIFICATION,
MANUFACTURER,
(select UDA_VALUE_DESC from item_uda a where uda_id = 17 and b.goods_code=a.ITEM) LOAD,
UNIT,
TAX_RATE
from dim_goods b
)i on   a.goods_code=i.goods_code

left join
(
select 
 goods_code,
LISTAGG(b.area_name,',') within group(order by b.area_name) as flag    
from DIM_NET_CATALOGUE_GENERAL3 a,dim_region b
where create_month=(select max(create_month) from DIM_NET_CATALOGUE_GENERAL3) and cp_type='统签分采' and a.area_code=b.area_code
group by goods_code
) j on a.goods_code=j.goods_code
left join 
(
select distinct uom_name,item goods_code from item_master
)k on a.goods_code=k.goods_code
left join
(
select sum(STOCK_ON_HAND) sd_qty,item goods_code from cmx_item_lot_loc_soh_day where loc = 10019
group by item
)l on a.goods_code=l.goods_code
left join
(
select 
item goods_code,
lead_time,
repl_qty,
min_order_qty,
onorder_qty,
mandatary_name_mom,
case when CG_FLAG='A' then '全部总仓配送' 
	when CG_FLAG='P' then '部分总仓配送' 
	when CG_FLAG='N' then '非总仓配送' 
	when CG_FLAG='U' then '批零一体'
	end as CG_FLAG
from CMX_AUTO_REPL_RESULT
where flash_date=trunc(sysdate)
)m on a.goods_code=m.goods_code

where 1=1
${if(len(goodn)=0,"","and a.goods_code IN ('"+goodn+"')")}
${if(len(mana)=0,"","and a.BUYER IN ('"+mana+"')")}
${if(len(sup_code)=0,"","and g.supplier_code IN ('"+sup_code+"')")}  
${if(len(newold)=0,"","and a.NEW_OR_OLD IN ('"+newold+"')")}
${if(len(cg)=0,"","and m.CG_FLAG IN ('"+cg+"')")}
order by g.supplier_code,i.MANUFACTURER,1,2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
)a 
where 1=1 and CG_FLAG in('全部总仓配送','部分总仓配送')
${if(len(flag)=0,"","and a.cp_type IN ('"+flag+"')")}
--order by  decode(是否进货,'紧急进货',1,'进货',2,'暂缓要货',3)

select distinct
area_code,area_name
from dim_region

select 
distinct
a.supplier_code,
a.SUPPLIER_NAME,
a.supplier_code||'|'||a.SUPPLIER_NAME
from fact_purchase a,DIM_NET_CATALOGUE_GENERAL_ALL b

where  
a.area_code=b.area_code and a.goods_code=b.goods_code
and a.procurement_type='采进'
and b.create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL) 
--and no_tax_price>=0
and a.area_code='00'

select 
distinct

 BUYER
 from DIM_NET_CATALOGUE_GENERAL_ALL
where create_month= 
(select max(create_month) from DIM_NET_CATALOGUE_GENERAL_ALL)

