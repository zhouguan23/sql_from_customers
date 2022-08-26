--门店级直营销售统计
select dr.union_area_name 合并区域,
       a.AREA_CODE 区域编码,
       dr.area_name 区域名称,
       b.cus_code 门店编码,
       b.cus_name 门店名称,
       b.open_date 开店日期,
       b.health_care 是否医保,
       b.formats 业态分类,
       dr.sorted,
       /*sum(NO_TAX_AMOUNT) 直营销售额,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利*/
/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量
       
from DIM_CUS b,DIM_MARKETING c,dim_region dr/*,(select * from USER_AUTHORITY)ua*/,FACT_SALE a
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join dim_goods g
on a.goods_code=g.goods_code
where /*(dr.UNION_AREA_NAME=ua.UNION_AREA_NAME or ua.UNION_AREA_NAME='ALL') 
and ${"ua.user_id='"+$fr_username+"'"}
and*/ a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(cus)=0, "", " and b.cus_code in ('" + cus + "')")}
and a.sale_date between to_date('${start_date}', 'yyyy-mm-dd') and
to_date('${end_date}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}
and 1=1 ${if(len(small_scale)=0,"","and nvl(b.small_scale,'否') ='"+small_scale+"'")}
and a.MARKETING_CODE=c.MARKETING_CODE 
and a.area_code=dr.area_code
group by dr.union_area_name,a.AREA_CODE,dr.area_name,dr.sorted,b.cus_code,b.cus_name, b.open_date, b.health_care, b.formats
order by dr.sorted
--order by decode(a.area_code,'00','AA',dr.union_area_name),a.area_code,b.cus_code

--直营销售同比
select a.AREA_CODE 区域编码,
       b.cus_code 门店编码,

       
       /*sum(NO_TAX_AMOUNT) 直营销售同比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利同比*/

/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量
       
from DIM_CUS b,DIM_MARKETING c,dim_region dr,FACT_SALE a
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join dim_goods g
on a.goods_code=g.goods_code
where a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")} 
and 1=1 ${if(len(cus)=0, "", " and b.cus_code in ('" + cus + "')")}
and a.sale_date between add_months(to_date('${start_date}', 'yyyy-mm-dd'),-12) and
add_months(to_date('${end_date}', 'yyyy-mm-dd'),-12)
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}
and 1=1 ${if(len(small_scale)=0,"","and nvl(b.small_scale,'否') ='"+small_scale+"'")}
and a.MARKETING_CODE=c.MARKETING_CODE 
and a.area_code=dr.area_code
group by a.AREA_CODE,dr.area_name,b.cus_code,b.cus_name, b.open_date, b.health_care, b.formats
order by a.area_code,b.cus_code

--直营销售对比
select a.AREA_CODE 区域编码,

       b.cus_code 门店编码,
 
       /*sum(NO_TAX_AMOUNT) 直营销售环比,
       nvl(sum(NO_TAX_AMOUNT),0)-nvl(sum(NO_TAX_COST),0) 毛利环比*/

/*(case when '${Tax}'='无税' then sum(no_tax_amount) else sum(tax_amount) end) as 直营销售额,
(case when '${Tax}'='无税' then sum(nvl(no_tax_amount,0))-sum(nvl(no_tax_cost,0)) else sum(nvl(tax_amount,0))-sum(nvl(tax_cost,0)) end) as 毛利,*/

(case when '${Tax}'='无税' then (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.no_tax_amount else 0 end) else  sum(a.no_tax_amount) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then a.tax_amount else 0 end) else  sum(a.tax_amount) end ) end)as 直营销售额,
(case when '${Tax}'='无税' then(case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.no_tax_amount,0)-nvl(a.no_tax_cost,0) else 0 end) else  nvl(sum(a.no_tax_amount),0)-nvl(sum(a.no_tax_cost),0) end ) else (case when '${b2c}'='否' then sum(case when nvl(a.is_b2c,'N')='N' then nvl(a.tax_amount,0)-nvl(a.tax_cost,0) else 0 end) else  nvl(sum(a.tax_amount),0)-nvl(sum(a.tax_cost),0) end ) end) as 毛利,

sum(SALE_QTY) 数量
       
from DIM_CUS b,DIM_MARKETING c,dim_region dr,FACT_SALE a
left join 
DIM_DTP d 
on to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.CREATE_MONTH
and a.AREA_CODE=d.AREA_CODE 
and a.GOODS_CODE=d.GOODS_CODE
left join dim_goods g
on a.goods_code=g.goods_code
where a.AREA_CODE=b.AREA_CODE 
and a.CUS_CODE=b.CUS_CODE
and b.ATTRIBUTE='直营' 
and 1=1 ${if(len(area)=0, "", " and a.area_code in ('" + area + "')")}
and 1=1 ${if(len(UNION_AREA)=0,"","and dr.UNION_AREA_NAME in('"+UNION_AREA+"')")}
and 1=1 ${if(len(cus)=0, "", " and b.cus_code in ('" + cus + "')")}
and a.sale_date between to_date('${start_date1}', 'yyyy-mm-dd') and
to_date('${end_date1}', 'yyyy-mm-dd')
and 1=1 ${if(len(dtp)=0,"","and decode(d.GOODS_CODE ,NULL,'否','是') ='"+dtp+"'")}
and 1=1 ${if(len(o2o)=0,"","and c.oto ='"+o2o+"'")}
and 1=1 ${if(len(small_scale)=0,"","and nvl(b.small_scale,'否') ='"+small_scale+"'")}
and a.MARKETING_CODE=c.MARKETING_CODE 
and a.area_code=dr.area_code
group by a.AREA_CODE,dr.area_name,b.cus_code,b.cus_name, b.open_date, b.health_care, b.formats
order by a.area_code,b.cus_code

