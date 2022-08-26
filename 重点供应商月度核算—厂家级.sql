select a.cjmc 厂家名称,
       --d.union_area_name  合并区域名称,
       date1, 
       sum(zyxs_tax_amount) 直营销售含税额,
       sum(jmxs_tax_amount) 加盟销售含税额,
       sum(zyps_tax_amount) 直营配送含税额,
       sum(jmps_tax_amount) 加盟配送含税额,
       sum(pfps_tax_amount) 外部配送含税额,
       sum(nvl(zyxs_tax_amount,0)-nvl(zyxs_tax_cost,0)) 直营销售毛利,
       sum(nvl(jmxs_tax_amount,0)-nvl(jmxs_tax_cost,0)) 加盟销售毛利,
       sum(nvl(zyps_tax_amount,0)-nvl(zyps_tax_cost,0)) 直营配送毛利,
       sum(nvl(jmps_tax_amount,0)-nvl(jmps_tax_cost,0)) 加盟配送毛利,
       sum(nvl(pfps_tax_amount,0)-nvl(pfps_tax_cost,0)) 外部配送毛利,

       sum(zyxs_amount) 直营销售无税额,
       sum(jmxs_amount) 加盟销售无税额,
       sum(zyps_amount) 直营配送无税额,
       sum(jmps_amount) 加盟配送无税额,
       sum(pfps_amount) 外部配送无税额,
       sum(nvl(zyxs_amount,0)-nvl(zyxs_cost,0)) 直营销售无税毛利,
       sum(nvl(jmxs_amount,0)-nvl(jmxs_cost,0)) 加盟销售无税毛利,
       sum(nvl(zyps_amount,0)-nvl(zyps_cost,0)) 直营配送无税毛利,
       sum(nvl(jmps_amount,0)-nvl(jmps_cost,0)) 加盟配送无税毛利,
       sum(nvl(pfps_amount,0)-nvl(pfps_cost,0)) 外部配送无税毛利
from DM_PURCHASE_SALE_STOCK_GOODS b, DIM_DISABLE_CODE C,dim_region d,dim_zdgys_goods a 
left join (select cjmc,start_month,end_month from dim_zdgys_cj
where create_year='${year}') cj
on cj.cjmc=a.cjmc
where
a.goods_code=b.goods_code
and A.goods_code = C.disable_code
and b.area_code=d.area_code
--and date1>='${date1}'
--and date1<='${date2}'
and date1>=nvl('${date1}' ,cj.start_month)
and date1<=nvl('${date2}' ,cj.end_month)
--and 1=1 ${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}

and 1=1 ${if(len(gcode)=0,""," and a.goods_code in ('"+gcode+"')")}
and 1=1 ${if(len(cjmc)=0,""," and a.cjmc in ('"+cjmc+"')")}
--and 1=1 ${if(len(gname)=0,""," and b.goods_name in ('"+gname+"')")}
group by a.cjmc ,
        date1--,d.union_area_name

order by a.cjmc,date1 desc
--order by date1 desc,min(d.sorted),a.cjmc

select distinct cjmc from  dim_zdgys_goods

select distinct a.goods_code as goods_code,a.goods_code||'|'||b.goods_name as goods_name
from dim_zdgys_goods a ,dim_goods b, DIM_DISABLE_CODE C
where
a.goods_code=b.goods_code
and A.goods_code = C.disable_code
--and b.area_code=d.area_code
--and 1=1 ${if(len(cjmc)=0,""," and cjmc in ('"+cjmc+"')")}
--and 1=1 ${if(len(area)=0,""," and d.union_area_name in ('"+area+"')")}
order by a.goods_code




select 
        d.union_area_name 
       
from dim_region d
order by d.sorted



select cjmc,date1,sum(核算量)over(partition by cjmc order by date1)核算量 from (
select cjmc,date1,sum(核算量)核算量 from(
select a.cjmc,b.goods_code,b.date1,sum(value)*(case when '${hsj}'='是' then  a.hsj else 1 end)as 核算量
from dim_zdgys_goods a,(select goods_code,date1,attr,value from (
select goods_code,date1,ZYXS_QTY,JMXS_QTY,ZYPS_QTY,JMPS_QTY,PFPS_QTY,ZYXS_TAX_AMOUNT,JMXS_TAX_AMOUNT,PFPS_TAX_AMOUNT,ZYPS_TAX_AMOUNT,JMPS_TAX_AMOUNT,
(case when area_code='00' then cg_qty end )as 总仓采购数量,
(case when area_code<>'00' then cg_qty end )as 区域采购数量,
(case when area_code='00' then cg_tax_amount end )as 总仓采购含税金额,
(case when area_code<>'00' then cg_tax_amount end )as 区域采购含税金额
from dm_purchase_sale_stock_goods
where date1>='${date1}'
and date1<='${date2}'
)
unpivot(value for attr in (ZYXS_QTY,JMXS_QTY,ZYPS_QTY,JMPS_QTY,PFPS_QTY,ZYXS_TAX_AMOUNT,JMXS_TAX_AMOUNT,PFPS_TAX_AMOUNT,
ZYPS_TAX_AMOUNT,JMPS_TAX_AMOUNT,总仓采购数量,区域采购数量,总仓采购含税金额,区域采购含税金额))
)b
where a.goods_code=b.goods_code
and 1=1 ${if(len(attr)=0,""," and attr in ('"+attr+"')")}
--and attr='ZYPS_QTY'
--and cjmc='晖致万艾可'
group by a.cjmc,b.goods_code,b.date1,a.hsj)
group by cjmc,date1
)

select * from dim_zdgys_cj
where create_year='${year}'

select distinct create_year from dim_zdgys_cj

select cjmc,date1,sum(核算量)核算量 from(
select a.cjmc,b.goods_code,b.date1,sum(value)*(case when '${hsj}'='是' then  a.hsj else 1 end)as 核算量
from dim_zdgys_goods a,(select goods_code,date1,attr,value from (
select goods_code,date1,ZYXS_QTY,JMXS_QTY,ZYPS_QTY,JMPS_QTY,PFPS_QTY,ZYXS_TAX_AMOUNT,JMXS_TAX_AMOUNT,PFPS_TAX_AMOUNT,ZYPS_TAX_AMOUNT,JMPS_TAX_AMOUNT,
(case when area_code='00' then cg_qty end )as 总仓采购数量,
(case when area_code<>'00' then cg_qty end )as 区域采购数量,
(case when area_code='00' then cg_tax_amount end )as 总仓采购含税金额,
(case when area_code<>'00' then cg_tax_amount end )as 区域采购含税金额
from dm_purchase_sale_stock_goods
where date1>='${date1}'
and date1<='${date2}'
)
unpivot(value for attr in (ZYXS_QTY,JMXS_QTY,ZYPS_QTY,JMPS_QTY,PFPS_QTY,ZYXS_TAX_AMOUNT,JMXS_TAX_AMOUNT,PFPS_TAX_AMOUNT,
ZYPS_TAX_AMOUNT,JMPS_TAX_AMOUNT,总仓采购数量,区域采购数量,总仓采购含税金额,区域采购含税金额))
)b
where a.goods_code=b.goods_code
and 1=1 ${if(len(attr)=0,""," and attr in ('"+attr+"')")}
--and attr='ZYPS_QTY'
--and cjmc='晖致万艾可'
group by a.cjmc,b.goods_code,b.date1,a.hsj)
group by cjmc,date1

