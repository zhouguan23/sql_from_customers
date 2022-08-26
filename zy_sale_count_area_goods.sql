select a.AREA_CODE        区域编码,
       dr.area_name       区域名称,
	   dr.UNION_AREA_NAME 合并区域,
	   dr.sorted,
       a.goods_code       商品编码,
       g.goods_name       商品名称,
       g.specification    规格,
       g.manufacturer     生产厂家,
		g.UNIT,
		g.LARGE_CATE,
		g.CATEGORY,
		g.COMPOSITION,
		g.SUB_COMPOSITION,
		g.FUNCTION,
		nvl(e.NEW_ATTRIBUTE,'地采') 采购属性,
		decode(d.GOODS_CODE ,NULL,'否','是') DTP,
		
       /*sum(NO_TAX_AMOUNT) 直营销售额,
       sum(nvl(NO_TAX_AMOUNT,0))-sum(nvl(NO_TAX_COST,0)) 毛利,
	   sum(TAX_AMOUNT) 直营含税销售额,
       sum(nvl(TAX_AMOUNT,0))-sum(nvl(TAX_COST,0)) 含税毛利,
	   sum(SALE_QTY) 数量,*/

/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量, 
	   
	   /*sum(case when a.vip='是' then nvl(TAX_AMOUNT,0) end) vip_销售额,
	   sum(case when a.vip='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) vip_毛利,
	   sum(case when a.vip='是' then nvl(SALE_QTY,0) end) vip_数量*/

(case when '${Tax}'='无税' then sum(case when a.vip='是' then nvl(no_tax_amount,0)end) else sum(case when a.vip='是' then nvl(tax_amount,0)end)end) as vip_销售额,
(case when '${Tax}'='无税' then sum(case when a.vip='是' then nvl(no_tax_amount,0)-nvl(no_tax_cost,0)end) else sum(case when a.vip='是' then nvl(tax_amount,0)-nvl(tax_cost,0)end)end) as vip_毛利,
sum(case when a.vip='是' then nvl(SALE_QTY,0) end) vip_数量
	   
from DIM_CUS b,dim_region dr,/*(select * from USER_AUTHORITY)ua,*/FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join
DIM_NET_CATALOGUE_GENERAL_ALL e 
on a.area_code=e.area_code and a.cus_code=e.cus_code and a.goods_code=e.goods_code
and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=e.CREATE_MONTH
left join dim_goods g
on a.goods_code=g.goods_code
where 
/*(dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}

and*/ a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}

and a.area_code=dr.area_code
group by a.AREA_CODE,dr.area_name,dr.UNION_AREA_NAME,dr.sorted,a.goods_code,g.goods_name,g.specification,g.manufacturer,g.UNIT,
		g.LARGE_CATE,
		g.CATEGORY,
		g.COMPOSITION,
		g.SUB_COMPOSITION,
		g.FUNCTION,
		nvl(e.NEW_ATTRIBUTE,'地采'),
		decode(d.GOODS_CODE ,NULL,'否','是')

--order by decode(a.area_code,'00','AA',dr.union_area_name),a.area_code,a.goods_code
order by dr.sorted,a.goods_code,nlssort(g.goods_name, 'NLS_SORT=SCHINESE_PINYIN_M')

--直营销售同比
select a.AREA_CODE        区域编码,
       a.goods_code       商品编码,
       /*sum(NO_TAX_AMOUNT) 直营销售同比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利同比*/
/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量

       
from DIM_CUS b,dim_region dr,FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE

where a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}


group by a.AREA_CODE,a.goods_code
order by a.area_code,a.goods_code

--直营销售对比
select a.AREA_CODE        区域编码,
       a.goods_code       商品编码,
       /*sum(NO_TAX_AMOUNT) 直营销售环比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利环比*/
/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量
       
from DIM_CUS b,dim_region dr,FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE

where a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}


--and 1=1 ${if(len(uid)=0,""," and 列名 in ('"+replace(uid,";","','")+"')")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}


and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}


group by a.AREA_CODE,a.goods_code


select 
area_code,
goods_code,
stock_qty  gen_stock_qty
from DM_STOCK_GENERAL_DAY 
where ddate=trunc(sysdate-1) 

select area_code,goods_code,sum(stock_qty) shop_stock_qty from DM_STOCK_SHOP_DAY
where ddate=trunc(sysdate-1)
 group by  area_code,goods_code

select 区域编码,区域名称,合并区域,sorted,商品编码,商品名称,规格,生产厂家,UNIT,LARGE_CATE,CATEGORY,COMPOSITION,SUB_COMPOSITION,FUNCTION,采购属性,DTP,
sum(直营销售额)直营销售额,
sum(毛利)毛利,
sum(数量)数量,
sum(同期直营销售额)同期直营销售额,
sum(同期毛利)同期毛利,
sum(同期数量)同期数量,
sum(对比期直营销售额)对比期直营销售额,
sum(对比期毛利)对比期毛利,
sum(对比期数量)对比期数量,
sum(vip_销售额)vip_销售额,
sum(vip_毛利)vip_毛利,
sum(vip_数量)vip_数量
from 
(select a.AREA_CODE        区域编码,
       dr.area_name       区域名称,
     dr.UNION_AREA_NAME 合并区域,
     dr.sorted,
       a.goods_code       商品编码,
       g.goods_name       商品名称,
       g.specification    规格,
       g.manufacturer     生产厂家,
    g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采') 采购属性,
    decode(d.GOODS_CODE ,NULL,'否','是') DTP,
    
       /*sum(NO_TAX_AMOUNT) 直营销售额,
       sum(nvl(NO_TAX_AMOUNT,0))-sum(nvl(NO_TAX_COST,0)) 毛利,
     sum(TAX_AMOUNT) 直营含税销售额,
       sum(nvl(TAX_AMOUNT,0))-sum(nvl(TAX_COST,0)) 含税毛利,
     sum(SALE_QTY) 数量,*/

/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,
sum(SALE_QTY) 数量, 
0 as 同期直营销售额,
0 as 同期毛利,
0 as 同期数量,
0 as 对比期直营销售额,
0 as 对比期毛利,
0 as 对比期数量,

     
     /*sum(case when a.vip='是' then nvl(TAX_AMOUNT,0) end) vip_销售额,
     sum(case when a.vip='是' then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0) end) vip_毛利,
     sum(case when a.vip='是' then nvl(SALE_QTY,0) end) vip_数量*/

(case when '${Tax}'='无税' then sum(case when a.vip='是' then nvl(no_tax_amount,0)end) else sum(case when a.vip='是' then nvl(tax_amount,0)end)end) as vip_销售额,
(case when '${Tax}'='无税' then sum(case when a.vip='是' then nvl(no_tax_amount,0)-nvl(no_tax_cost,0)end) else sum(case when a.vip='是' then nvl(tax_amount,0)-nvl(tax_cost,0)end)end) as vip_毛利,
sum(case when a.vip='是' then nvl(SALE_QTY,0) end) vip_数量
     
from DIM_CUS b,dim_region dr,(select * from USER_AUTHORITY)ua,FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join
DIM_NET_CATALOGUE_GENERAL_ALL e 
on a.area_code=e.area_code and a.cus_code=e.cus_code and a.goods_code=e.goods_code
and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=e.CREATE_MONTH
left join dim_goods g
on a.goods_code=g.goods_code
where 
(dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}

and a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}

and a.area_code=dr.area_code
group by a.AREA_CODE,dr.area_name,dr.UNION_AREA_NAME,dr.sorted,a.goods_code,g.goods_name,g.specification,g.manufacturer,g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采'),
    decode(d.GOODS_CODE ,NULL,'否','是')

--order by decode(a.area_code,'00','AA',dr.union_area_name),a.area_code,a.goods_code
--order by dr.sorted,a.goods_code,nlssort(g.goods_name, 'NLS_SORT=SCHINESE_PINYIN_M')

--full join 
union 

--直营销售同比
select 
    a.AREA_CODE        区域编码,
       dr.area_name       区域名称,
     dr.UNION_AREA_NAME 合并区域,
     dr.sorted,
       a.goods_code       商品编码,
       g.goods_name       商品名称,
       g.specification    规格,
       g.manufacturer     生产厂家,
    g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采') 采购属性,
    decode(d.GOODS_CODE ,NULL,'否','是') DTP,
    0 as   直营销售额,
    0 as 毛利,
    0 as 数量,
    --a.AREA_CODE        区域编码,
       --a.goods_code       商品编码,
       /*sum(NO_TAX_AMOUNT) 直营销售同比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利同比*/
/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 同期直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 同期毛利,

sum(SALE_QTY) 同期数量,
0 as 对比期直营销售额,
0 as 对比期毛利,
0 as 对比期数量,
0 as vip_销售额,
0 as vip_毛利,
0 as vip_数量

       
from DIM_CUS b,dim_region dr,(select * from USER_AUTHORITY)ua,FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join
DIM_NET_CATALOGUE_GENERAL_ALL e 
on a.area_code=e.area_code and a.cus_code=e.cus_code and a.goods_code=e.goods_code
and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=e.CREATE_MONTH
left join dim_goods g
on a.goods_code=g.goods_code
where (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}


--group by a.AREA_CODE,a.goods_code
group by a.AREA_CODE,dr.area_name,dr.UNION_AREA_NAME,dr.sorted,a.goods_code,g.goods_name,g.specification,g.manufacturer,g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采'),
    decode(d.GOODS_CODE ,NULL,'否','是')
--order by a.area_code,a.goods_code

--on a.区域编码=b.区域编码
--and a.商品编码=b.商品编码
--full join 
union

--直营销售对比
select 
    a.AREA_CODE        区域编码,
       dr.area_name       区域名称,
     dr.UNION_AREA_NAME 合并区域,
     dr.sorted,
       a.goods_code       商品编码,
       g.goods_name       商品名称,
       g.specification    规格,
       g.manufacturer     生产厂家,
    g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采') 采购属性,
    decode(d.GOODS_CODE ,NULL,'否','是') DTP,
    0 as   直营销售额,
    0 as 毛利,
    0 as 数量,
    0 as 同期直营销售额,
0 as 同期毛利,
0 as 同期数量,

    
    --a.AREA_CODE        区域编码,
       --a.goods_code       商品编码,
       /*sum(NO_TAX_AMOUNT) 直营销售环比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利环比*/
/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 对比期直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 对比期毛利,

sum(SALE_QTY) 对比期数量,
0 as vip_销售额,
0 as vip_毛利,
0 as vip_数量
       
from DIM_CUS b,dim_region dr,(select * from USER_AUTHORITY)ua,FACT_SALE a
left join 
DIM_MARKETING_all c on   a.MARKETING_CODE=c.MARKETING_CODE and decode(a.area_code,'16','15',a.area_code)=c.area_code
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join
DIM_NET_CATALOGUE_GENERAL_ALL e 
on a.area_code=e.area_code and a.cus_code=e.cus_code and a.goods_code=e.goods_code
and to_char(ADD_MONTHS(A.SALE_DATE,-1),'YYYY-MM')=e.CREATE_MONTH
left join dim_goods g
on a.goods_code=g.goods_code
where (dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and a.area_code=dr.area_code
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(goods)=0, "", " and a.goods_code in ('" + goods + "')")}
--and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in (" + goodn + ")")}


--and 1=1 ${if(len(uid)=0,""," and 列名 in ('"+replace(uid,";","','")+"')")}
and 1=1 ${if(len(goodn)=0, "", " and a.goods_code in ('"+replace(goodn,",","','")+"')")}


and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}


--group by a.AREA_CODE,a.goods_code
group by a.AREA_CODE,dr.area_name,dr.UNION_AREA_NAME,dr.sorted,a.goods_code,g.goods_name,g.specification,g.manufacturer,g.UNIT,
    g.LARGE_CATE,
    g.CATEGORY,
    g.COMPOSITION,
    g.SUB_COMPOSITION,
    g.FUNCTION,
    nvl(e.NEW_ATTRIBUTE,'地采'),
    decode(d.GOODS_CODE ,NULL,'否','是')

)
--on a.区域编码=c.区域编码
--and a.商品编码=c.商品编码
group by 区域编码,区域名称,合并区域,sorted,商品编码,商品名称,规格,生产厂家,UNIT,LARGE_CATE,CATEGORY,COMPOSITION,SUB_COMPOSITION,FUNCTION,采购属性,DTP
order by sorted,商品编码,nlssort(商品名称, 'NLS_SORT=SCHINESE_PINYIN_M')

