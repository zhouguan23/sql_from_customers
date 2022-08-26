select a.area_code,a.goods_code,b.goods_name,b.specification,b.manufacturer,a.attribute,a.dtp,sum(stock_qty),sum(no_tax_cost),count(storage_code) as storage_number from (

select a.area_code,
to_char(a.ddate,'yyyy-mm') as ddate,
e.goods_code,
(case when c.new_attribute is null then '地采' else new_attribute end) as attribute,storage_code,
(case when d.goods_code is null then '否' else '是' end) as dtp, sum(stock_qty) as stock_qty, sum(No_tax_cost) as no_tax_cost
 from FACT_STOCK_GENERAL_DETAIL A 
 left join dim_disable_code e on a.goods_code=e.disable_code
 left join DIM_NET_CATALOGUE_GENERAL_ALL C ON A.AREA_CODE=C.AREA_CODE AND A.GOODS_cODE=C.GOODS_CODE AND C.CREATE_MONTH=TO_CHAR(DDATE,'YYYY-MM')
 left join DIM_DTP D on a.goods_code=d.goods_code and a.area_code=d.area_code and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm')
where A.DDATE=last_day(to_date('${Date}'||'-01','yyyy-mm-dd'))
  group by a.area_code,to_char(a.ddate,'yyyy-mm'),e.goods_code,storage_code,(case when c.new_attribute is null then '地采' else new_attribute end),
(case when d.goods_code is null then '否' else '是' end) 

) a,DIM_GOODS b
where  a.GOODS_CODE=b.GOODS_CODE
and 1=1 ${if(len(area)=0,"","and area_Code in ('"+area+"')")} 
and 1=1 ${if(len(dtp)=0,"","and dtp in ('"+dtp+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and 1=1 ${if(len(goods)=0,"","and a.goods_code in ('"+goods+"')")}
 
 group by  a.area_code,a.goods_code,b.goods_name,b.specification,b.manufacturer,a.attribute,a.dtp
--ORDER BY a.area_code,a.goods_code

union all

select a.area_code,a.goods_code,b.goods_name,b.specification,b.manufacturer,a.attribute,a.dtp,sum(stock_qty),sum(no_tax_cost),1 as storage_number from (

select a.area_code,
to_char(a.ddate,'yyyy-mm') as ddate,
e.goods_code,
(case when c.new_attribute is null then '地采' else new_attribute end) as attribute, /*storage_code,*/
(case when d.goods_code is null then '否' else '是' end) as dtp, sum(stock_qty) as stock_qty, sum(No_tax_cost) as no_tax_cost
 from FACT_STOCK_GENERAL A 
 left join dim_disable_code e on a.goods_code=e.disable_code
 left join DIM_NET_CATALOGUE_GENERAL_ALL C ON A.AREA_CODE=C.AREA_CODE AND A.GOODS_cODE=C.GOODS_CODE AND C.CREATE_MONTH=TO_CHAR(DDATE,'YYYY-MM')
 left join DIM_DTP D on a.goods_code=d.goods_code and a.area_code=d.area_code and d.create_month=to_char(add_months(ddate,-1),'yyyy-mm')
 inner join dim_region dr on a.area_code=dr.area_code and dr.type='OFFLINE'
where A.DDATE=last_day(to_date('${Date}'||'-01','yyyy-mm-dd'))
  group by a.area_code,to_char(a.ddate,'yyyy-mm'),e.goods_code,/*storage_code,*/(case when c.new_attribute is null then '地采' else new_attribute end),
(case when d.goods_code is null then '否' else '是' end) 

) a,DIM_GOODS b
where  a.GOODS_CODE=b.GOODS_CODE
and 1=1 ${if(len(area)=0,"","and area_Code in ('"+area+"')")} 
and 1=1 ${if(len(dtp)=0,"","and dtp in ('"+dtp+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and 1=1 ${if(len(goods)=0,"","and a.goods_code in ('"+goods+"')")}
 
 group by  a.area_code,a.goods_code,b.goods_name,b.specification,b.manufacturer,a.attribute,a.dtp
--ORDER BY a.area_code,a.goods_code

select distinct c.goods_code,C.goods_code||'|'||b.goods_name goods_name from FACT_STOCK_GENERAL_DETAIL A 
left join dim_disable_code C on a.goods_code=c.disable_code 
left join dim_goods B on C.goods_code=b.goods_code    
where A.DDATE=last_day(to_date('${Date}'||'-01','yyyy-mm-dd')) 
and 1=1 ${if(len(area)=0,"","and area_Code in ('"+area+"')")}  
ORDER BY 1
--and rownum<5000

select area_code,area_name from DIM_REGION

select distinct new_attribute from DIM_NET_CATALOGUE_GENERAL_ALL
UNION
SELECT '地采' from dual

